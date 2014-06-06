#include "ibsmon_np.h"
#include <syslog.h>
#include <sys/poll.h>
#include <sys/select.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>

#define PERMS 0600

char *ibsmon_fifo = NULL;
char *program_name = NULL;
int missed_heartbeat_count = 0;

/**
 * Follows some basic rules to coding a daemon.
 * Reference: Advanced Programming in the UNIX Environment 3rd Ed
 *
 * How to check this daemon process:
 * Linux: ps -efj | grep ibsmon
 * AIX: /usr/sysv/bin/ps -efj | grep ibsmon
 *
 * return 0
 *          if operation is successful
 *        errno
 *          if any of the function call fails
 */
int init_daemon( void )
{
    pid_t pid = 0;

    // Clear file creation mask.
    umask( 0 );

    // Get maximum number of file descriptors.
    struct rlimit rl = { 0, 0 };
    if( getrlimit( RLIMIT_NOFILE, &rl ) < 0 )
    {
        d_log_error( "%s (%d): Error on getrlimit (errno = %d), %s failed to start",
                     __FILE__,
                     __LINE__,
                     errno,
                     program_name );
        return errno;
    }

    // Become a session leader to lose controlling TTY.
    if( ( pid = fork() ) < 0 )
    {
        d_log_error( "%s (%d): Error on fork (errno = %d), %s failed to start",
                     __FILE__,
                     __LINE__,
                     errno,
                     program_name );
        return errno;
    }
    else if( pid != 0 )
    {
        // Parent.
        exit( 0 );
    }
    if( setsid() < 0 )
    {
        d_log_error( "%s (%d): Error on setsid (errno = %d), %s failed to start",
                     __FILE__,
                     __LINE__,
                     errno,
                     program_name );
        return errno;
    }

    // Ensure future opens won¡¦t allocate controlling TTYs.
    // The SIGHUP signal is sent to the controlling process (session leader)
    // associated with a controlling terminal if a disconnect is detected by
    // the terminal interface.
    int signums[ 1 ] = { SIGHUP };
    int rc = 0;
    if( ( rc = ignore_signals( signums, sizeof( signums ) / sizeof( int ) ) ) != 0 )
    {
        d_log_error( "%s (%d): Error ignoring SIGHUP signal (errno = %d), %s failed to start",
                     __FILE__,
                     __LINE__,
                     errno,
                     program_name );
        return rc;
    }

    // This means that the daemon is in an orphaned process group and is not
    // a session leader and, therefore, has no chance of allocating a
    // controlling terminal.
    if( ( pid = fork() ) < 0 )
    {
        d_log_error( "%s (%d): Error on fork (errno = %d), %s failed to start",
                     __FILE__,
                     __LINE__,
                     errno,
                     program_name );
        return errno;
    }
    else if( pid != 0 )
    {
        // Parent.
        exit( 0 );
    }

    // Change the current working directory to the root so we won¡¦t prevent
    // file systems from being unmounted.
    if( chdir( "/" ) < 0 )
    {
        d_log_error( "%s (%d): Error changing the current working directory to the root (errno = %d), %s failed to start",
                     __FILE__,
                     __LINE__,
                     errno,
                     program_name );
        return errno;
    }

    // Close all open file descriptors.
    // AIX: if we called syslog function before closing all file descriptors,
    // it seems that the unix domain socket used for communication with syslogd
    // will be closed, and future calls to syslog function will not create a
    // new unix domain socket. Therefore messages written to syslog are not
    // shown. We should make sure no calls to syslog function was made before
    // closing all file descriptors on AIX.
    // Linux: if we called syslog function before closing all file descriptors,
    // the file descriptor used for communication with syslogd seems to be
    // remembered by syslog function (usually file descriptor 3). If we open
    // FIFO after closing all file descriptors, the FIFO shall use file
    // descriptor 3. Howvere, if we call syslog function after FIFO is open,
    // file descriptor 3 is used by the unix domain socket again, and the
    // FIFO file descriptor does not exist anymore. We should make sure no
    // calls to syslog function was made before closing all file descriptors
    // on Linux.
    if( rl.rlim_max == RLIM_INFINITY )
    {
        rl.rlim_max = 1024;
    }
    for( int i = 0; i < rl.rlim_max; i++ )
    {
        close( i );
    }

    // Attach file descriptors 0, 1, and 2 to /dev/null.
    int fd0 = open( "/dev/null", O_RDWR );
    if( fd0 < 0 )
    {
        d_log_error( "%s (%d): Error opening '/dev/null' (errno = %d), %s failed to start",
                     __FILE__,
                     __LINE__,
                     errno,
                     program_name );
        return errno;
    }
    int fd1 = dup( 0 );
    if( fd1 < 0 )
    {
        d_log_error( "%s (%d): Error duplicating file descriptor '0' (errno = %d), %s failed to start",
                     __FILE__,
                     __LINE__,
                     errno,
                     program_name );
        return errno;
    }
    int fd2 = dup( 0 );
    if( fd2 < 0 )
    {
        d_log_error( "%s (%d): Error duplicating file descriptor '0' (errno = %d), %s failed to start",
                     __FILE__,
                     __LINE__,
                     errno,
                     program_name );
        return errno;
    }
    if( fd0 != 0 || fd1 != 1 || fd2 != 2 )
    {
        d_log_error( "%s (%d): Unexpected file descriptors (%d %d %d), %s failed to start",
                     __FILE__,
                     __LINE__,
                     fd0,
                     fd1,
                     fd2,
                     program_name );
        return -1;
    }

    openlog( program_name, LOG_CONS, LOG_DAEMON );

    // If d_log_info() is designated to syslog, the unix domain socket for
    // communication with syslogd shall use file descriptor 3 on both AIX and
    // Linux, and the FIFO opened later shall use file descriptor 4.
    d_log_info( "%s daemon initialized\n", program_name );

    return 0;
}

/**
 * return 0
 *          if parsing is successful
 *        EINVAL (22)
 *          if the number of arguments is not correct, or
 *          if sensativity-of-missed-heartbeats arguemnt is not a valid number
 *          or is less than 0, or
 *          if heartbeat-interval-sec argument is not a valid number or is
 *          less than or equal to 0
 */
int parse_command_line_arguments( int argc,
                                  char *argv[],
                                  int *p_sensativity_missed_heartbeats,
                                  unsigned long *p_heartbeat_interval_millis )
{
    if( argc != 4 )
    {
        d_log_error( "%s (%d): Usage: %s fifo-file sensativity-of-missed-heartbeats heartbeat-interval-sec, %s failed to start",
                     __FILE__,
                     __LINE__,
                     argv[ 0 ],
                     program_name );
        return EINVAL;
    }

    ibsmon_fifo = argv[ 1 ];

    char *end = NULL;
    *p_sensativity_missed_heartbeats = (int)strtol( argv[ 2 ], &end, 10 );
    if( *end != '\0' || *p_sensativity_missed_heartbeats <= 0 )
    {
        d_log_error( "%s (%d): Invalid sensativity-of-missed-heartbeats argument (%s), %s failed to start",
                     __FILE__,
                     __LINE__,
                     argv[ 2 ],
                     program_name );
        return EINVAL;
    }

    long interval_secs = strtol( argv[ 3 ], &end, 10 );
    if( *end != '\0' || interval_secs <= 0L )
    {
        d_log_error( "%s (%d): Invalid heartbeat-interval-sec argument (%s), %s failed to start",
                     __FILE__,
                     __LINE__,
                     argv[ 3 ],
                     program_name );
        return EINVAL;
    }
    *p_heartbeat_interval_millis = (unsigned long)( interval_secs * 1000L ); // 1 second = 1000 milliseconds

    return 0;
}

/**
 * Ignores signals for this daemon process.
 *
 * SIGPIPE
 * SIGTTIN: A process cannot read from the user's terminal while it is
 *          running as a background job. When any process in a background
 *          job tries to read from the terminal, all of the processes in the
 *          job are sent a SIGTTIN signal. The default action for this signal
 *          is to stop the process.
 *          If the background process ignores or blocks the SIGTTIN signal, or
 *          if its process group is orphaned, then the read() returns an EIO
 *          error, and no signal is sent.
 * SIGTTOU: This is similar to SIGTTIN, but is generated when a process in
 *          a background job attempts to write to the terminal or set its
 *          modes. Again, the default action is to stop the process.
 *          If the background process ignores or blocks the SIGTTOU signal, or
 *          if its process group is orphaned, then the write() returns an EIO
 *          error, and no signal is sent.
 *
 * return 0
 *          if operation is successful
 *        errno
 *          if sigemptyset() or sigaction() call fails
 */
int ignore_signals_for_daemon( void )
{
    int signums[ 3 ] = { SIGPIPE, SIGTTOU, SIGTTIN };
    int rc = 0;

    if( ( rc = ignore_signals( signums, sizeof( signums ) / sizeof( int ) ) ) != 0 )
    {
        d_log_error( "%s (%d): Error ignoring SIGPIPE/SIGTTOU/SIGTTIN signals (errno = %d), %s failed to start",
                     __FILE__,
                     __LINE__,
                     errno,
                     program_name );
    }
    return rc;
}

/*
 * return 0
 *          if FIFO file creation is successful, or if FIFO file already exists
 *        ENOENT (2)
 *          FIFO file can't be created
 *        errno
 *          if mkfifo() call fails
 */
int create_fifo_if_not_exists( void )
{
    if( ( mkfifo( ibsmon_fifo, PERMS ) < 0 ) && ( errno != EEXIST ) )
    {
        d_log_error( "%s (%d): Error creating FIFO file '%s' (errno = %d), %s failed to start",
                     __FILE__,
                     __LINE__,
                     ibsmon_fifo,
                     errno,
                     program_name );
        return errno;
    }
    return 0;
}

/*
 * return 0
 *          if malloc() call is successful
 *        ENOMEM (12)
 *          if malloc() call returns NULL
 */
int allocate_read_buffer( char **p_buffer, size_t buf_len )
{
    *p_buffer = malloc( buf_len );
    if( *p_buffer == NULL )
    {
        d_log_error( "%s (%d): Error allocating read buffer in %u bytes, %s failed to start",
                     __FILE__,
                     __LINE__,
                     buf_len,
                     program_name );
        return ENOMEM;
    }
    return 0;
}

/*
 * return 0
 *          if opening FIFO for read/write is successful
 *        ENOENT (2)
 *          FIFO file does not exist
 *        errno
 *          if open() call fails
 */
int open_fifo_for_read_write( int *p_fifo_fd )
{
    // With O_RDWR | O_NONBLOCK, pipe stays alive even when one side closes,
    // and which don't cause POLLHUP revents for poll() or return 0 for
    // read().
    *p_fifo_fd = open( ibsmon_fifo, O_RDWR | O_NONBLOCK );
    if( *p_fifo_fd < 0 )
    {
        d_log_error( "%s (%d): Error opening FIFO '%s' (errno = %d), %s shutdown",
                     __FILE__,
                     __LINE__,
                     ibsmon_fifo,
                     errno,
                     program_name );
        return errno;
    }
    return 0;
}

/**
 * Checks if the message read from FIFO is exactly the predefined heartbeat
 * message.
 *
 * return 0
 *          if buffer argument represents the predefined heartbeat message
 *          between client and server
 *        -1
 *          otherwise
 */
int check_heartbeat_msg( char *buffer, ssize_t bytes_read )
{
    int rc = 0;

    if( buffer[ bytes_read - 1 ] != '\0' )
    {
        buffer[ bytes_read - 1 ] = '\0';
        if( DEBUG_ENABLED ) d_log_debug( "incomplete heartbeat message '%s' from FIFO, bytes_read = %d", buffer, bytes_read );
    }
    if( strcmp( IBSMON_HEARTBEAT_MSG, buffer ) == 0 )
    {
        // Exactly the heartbeat message we expect.
        rc = 0;
    }
    else
    {
        d_log_warn( "%s (%d): Unexpected IB script heartbeat message '%s' from FIFO '%s'",
                    __FILE__,
                    __LINE__,
                    buffer,
                    ibsmon_fifo );
        rc = -1;
    }

    return rc;
}

void ib_script_dead_action( void )
{
    d_log_error( "***** IB monitor script seems dead *****" );
}

/**
 * This program reads hearbeat message which was sent by IB monitor script
 * from a FIFO, and takes appropriate action if no heartbeat message was
 * received after (sensitivity of missed beats) * (heartbeat interval)
 * seconds.
 *
 * For FIFO implementation, refer to
 * http://stackoverflow.com/questions/15055065/o-rdwr-on-named-pipes-with-poll
 */
int main( int argc, char *argv[] )
{
    int rc = 0;

    program_name = basename( argv[ 0 ] );

    // Run this program in foreground if in debug mode.
    if( !DEBUG_ENABLED )
    {
        if( ( rc = init_daemon() ) != 0 )
        {
            return rc;
        }
    }

    int sensativity_missed_heartbeats = 0;
    unsigned long heartbeat_interval_millis = 0L;
    if( ( rc = parse_command_line_arguments( argc,
                                             argv,
                                             &sensativity_missed_heartbeats,
                                             &heartbeat_interval_millis ) ) != 0 )
    {
        return rc;
    }
    if( DEBUG_ENABLED ) d_log_debug( "program_name = %s", program_name );
    if( DEBUG_ENABLED ) d_log_debug( "ibsmon_fifo = %s", ibsmon_fifo );
    if( DEBUG_ENABLED ) d_log_debug( "sensativity_missed_heartbeats = %d", sensativity_missed_heartbeats );
    if( DEBUG_ENABLED ) d_log_debug( "heartbeat_interval_millis = %ld", heartbeat_interval_millis );

    if( ( rc = ignore_signals_for_daemon() ) != 0 )
    {
        return rc;
    }

    if( ( rc = create_fifo_if_not_exists() ) != 0 )
    {
        return rc;
    }

    size_t buf_len = strlen( IBSMON_HEARTBEAT_MSG ) + 1; // 1 for '\0'
    char *buffer = NULL;
    if( ( rc = allocate_read_buffer( &buffer, buf_len ) ) != 0 )
    {
        return rc;
    }

    int fifo_fd = -1;
    if( ( rc = open_fifo_for_read_write( &fifo_fd ) ) != 0 )
    {
        free( buffer );
        return rc;
    }

    // Main loop to check liveness of IB script.
    d_log_info( "%s started", program_name );
    int poll_rc = 0;
    struct pollfd fds[ 1 ] = {{ 0, 0, 0 }};
    int more_data_to_read = TRUE;
    int is_heartbeat_msg_found = FALSE;
    ssize_t bytes_read = 0;
    rc = 0;
    while( rc == 0 )
    {
        memset( fds, 0 , sizeof( fds ) );
        fds[ 0 ].fd = fifo_fd;
        fds[ 0 ].events = POLLIN;
        if( DEBUG_ENABLED ) d_log_debug( "waiting on poll()" );
        poll_rc = poll( fds, 1, heartbeat_interval_millis );
        if( poll_rc < 0 )
        {
            // poll call failed.
            d_log_error( "%s (%d): Error on poll (errno = %d), %s shutdown",
                         __FILE__,
                         __LINE__,
                         errno,
                         program_name );
            rc = errno;
        }
        else if( poll_rc == 0 )
        {
            // poll timed out.
            // Increment missed heartbeat count.
            ++missed_heartbeat_count;
            if( DEBUG_ENABLED ) d_log_debug( "poll() time out, missed_heartbeat_count = %d", missed_heartbeat_count );
            if( missed_heartbeat_count >= sensativity_missed_heartbeats )
            {
                ib_script_dead_action();
            }
        }
        else if( ( poll_rc == 1 ) && ( fds[ 0 ].revents == POLLIN ) )
        {
            // The FIFO is readable.
            // Read as much data as we can from FIFO.
            more_data_to_read = TRUE;
            is_heartbeat_msg_found = FALSE;
            while( more_data_to_read )
            {
                memset( buffer, 0, buf_len );
                bytes_read = read( fifo_fd, buffer, buf_len );
                if( bytes_read == 0 )
                {
                    // EOF.
                    // Something is wrong. It shouldn't happen with O_RDWR on
                    // named pipes, but only with O_RDONLY; it indicates a
                    // closed pipe which must be closed and re-opened.
                    if( DEBUG_ENABLED ) d_log_debug( "end of FIFO, missed_heartbeat_count = %d", missed_heartbeat_count );
                    d_log_warn( "%s (%d): End of FIFO %s",
                                __FILE__,
                                __LINE__,
                                ibsmon_fifo );
                    more_data_to_read = FALSE;
                    close( fifo_fd );
                    rc = open_fifo_for_read_write( &fifo_fd );
                }
                else if( bytes_read < 0 )
                {
                    // read() call failed.
                    if( errno == EAGAIN )
                    {
                        // FIFO is empty. Go back poll.
                        if( DEBUG_ENABLED ) d_log_debug( "read get EAGAIN, go back poll(), missed_heartbeat_count = %d", missed_heartbeat_count );
                        more_data_to_read = FALSE;
                    }
                    else if ( errno == EINTR )
                    {
                        // A read was interrupted by a signal. read() all
                        // over again.
                        if( DEBUG_ENABLED ) d_log_debug( "read() gets EINTR, missed_heartbeat_count = %d", missed_heartbeat_count );
                    }
                    else
                    {
                        d_log_error( "%s (%d): Error reading FIFO '%s' (errno = %d), %s shutdown",
                                     __FILE__,
                                     __LINE__,
                                     ibsmon_fifo,
                                     errno,
                                     program_name );
                        rc = errno;
                        more_data_to_read = FALSE;
                    }
                }
                else
                {
                    // read() succeeded.
                    // If the expected heartbeat message has been read, we
                    // don't check further messages. Just keep reading the
                    // remaining data until FIFO is empty.
                    if( !is_heartbeat_msg_found )
                    {
                        if( check_heartbeat_msg( buffer, bytes_read ) == 0 )
                        {
                            is_heartbeat_msg_found = TRUE;
                            if( DEBUG_ENABLED ) d_log_debug( "is_heartbeat_msg_found set to TRUE" );
                        }
                    }
                    if( DEBUG_ENABLED ) d_log_debug( "data read from FIFO: %s, missed_heartbeat_count = %d", buffer, missed_heartbeat_count );
                }
            }

            if( is_heartbeat_msg_found )
            {
                // Reset missed heartbeat count.
                missed_heartbeat_count = 0;
                if( DEBUG_ENABLED ) d_log_debug( "reset missed heartbeats, missed_heartbeat_count = %d", missed_heartbeat_count );
            }
        }
        else
        {
            d_log_warn( "%s (%d): Unexpected poll return status (rc = %d, revents = 0x%x)",
                        __FILE__,
                        __LINE__,
                        poll_rc,
                        fds[ 0 ].revents,
                        program_name );
        }
    }

    free( buffer );
    buffer = NULL;
    close( fifo_fd );
    d_log_info( "%s stopped", program_name );

    return rc;
}
