#include "ibsmon_np.h"

char *ibsmon_fifo = NULL;
char *program_name = NULL;

/**
 * return 0
 *          if parsing is successful
 *        EINVAL (22)
 *          if the number of arguments is not correct, or
 *          if retry-interval-millis arguemnt is not a valid number or is
 *          less than or equal to 0, or
 *          if retry-interval-millis argument is not a valid number or is
 *          less than 0
 */
int parse_command_line_arguments( int argc,
                                  char *argv[],
                                  unsigned int *p_retry_interval_micros,
                                  int *p_retry_count )
{
    program_name = basename( argv[ 0 ] );

    if( argc != 4 )
    {
        c_log_error( "%s (%d): Usage: %s fifo-file retry-interval-millis retry-count, %s failed to run",
                     __FILE__,
                     __LINE__,
                     argv[ 0 ],
                     program_name );
        return EINVAL;
    }

    ibsmon_fifo = argv[ 1 ];

    char *end = NULL;
    int interval_millis = (int)strtol( argv[ 2 ], &end, 10 );
    if( *end != '\0' || interval_millis < 0 )
    {
        c_log_error( "%s (%d): Invalid retry-interval-millis argument (%s), %s failed to run",
                     __FILE__,
                     __LINE__,
                     argv[ 2 ],
                     program_name );
        return EINVAL;
    }
    *p_retry_interval_micros = (unsigned int)( interval_millis * 1000 ); // 1 millisecond = 1000 microsecond

    *p_retry_count = (int)strtol( argv[ 3 ], &end, 10 );
    if( *end != '\0' || *p_retry_count < 0 )
    {
        c_log_error( "%s (%d): Invalid retry-count argument (%s), %s failed to run",
                     __FILE__,
                     __LINE__,
                     argv[ 3 ], program_name );
        return EINVAL;
    }

    return 0;
}

/**
 * Ignores SIGPIPE signal (the default handler is to terminate the write
 * process). So when writing to a broken pipe, SIGPIPE won't terminate this
 * process. Instead, we get failed write() call with EPIPE errno.
 *
 * return 0
 *          if operation is successful
 *        errno
 *          if sigemptyset() or sigaction() call fails
 */
int ignore_SIGPIPE( void )
{
    int rc = 0;
    int signums[ 1 ] = { SIGPIPE };

    if( ( rc = ignore_signals( signums, sizeof( signums ) / sizeof( int ) ) ) != 0 )
    {
        c_log_error( "%s (%d): Error on sigemptyset/sigaction (errno = %d), %s failed to run",
                     __FILE__,
                     __LINE__,
                     errno,
                     program_name );
    }
    return rc;
}

/*
 * return 0
 *          if opening FIFO for write is successful
 *        ENXIO (6)
 *          no process opens FIFO for reading (the monitor process might be
 *          dead)
 *        ENOENT (2)
 *          FIFO file does not exist
 *        errno
 *          if open() call fails
 */
int open_fifo_for_write( int *p_fifo_fd,
                         unsigned int retry_interval_micros,
                         int retry_count )
{
    for( int i = 0; i < retry_count + 1; i++ )
    {
        // If FIFO was opened for reading by the other process, returns OK.
        // If FIFO was not opened for reading by the other process, returns
        // an error of ENXIO.
        if( DEBUG_ENABLED ) c_log_debug( "try to open FIFO, retry count = %d", i );
        *p_fifo_fd = open( ibsmon_fifo, O_WRONLY | O_NONBLOCK );
        if( *p_fifo_fd < 0 )
        {
            if( errno == ENXIO )
            {
                if( DEBUG_ENABLED ) c_log_debug( "get ENXIO when opening FIFO" );
                if( retry_interval_micros > 0 && i < retry_count )
                {
                    // If this is the last time for retry, we don't go to
                    // sleep.
                    if( DEBUG_ENABLED ) c_log_debug( "sleep for %u microseconds then try to open again", retry_interval_micros );
                    usleep( retry_interval_micros );
                }
            }
            else
            {
                c_log_error( "%s (%d): Error opening FIFO '%s' (errno = %d), %s failed to run",
                             __FILE__,
                             __LINE__,
                             ibsmon_fifo,
                             errno,
                             program_name );
                return errno;
            }
        }
        else
        {
            if( DEBUG_ENABLED ) c_log_debug( "successfully open FIFO, retry count = %d", i );
            break;
        }
    }
    if( *p_fifo_fd < 0 )
    {
        c_log_error( "%s (%d): No process opens FIFO '%s' for reading, %s failed to run",
                     __FILE__,
                     __LINE__,
                     ibsmon_fifo,
                     program_name );
        return ENXIO;
    }

    return 0;
}

/*
 * return 0
 *          if writing to FIFO is successful
 *        EAGAIN (11)
 *          FIFO is full
 *        EPIPE (32)
 *          no process opens FIFO for reading (the monitor process might be
 *          dead)
 *        errno
 *          if write() call fails
 */
int write_heartbeat_msg_to_fifo( int fifo_fd,
                                 unsigned int retry_interval_micros,
                                 int retry_count )
{
    ssize_t bytes_written = 0;
    size_t msg_len = strlen( IBSMON_HEARTBEAT_MSG ) + 1; // 1 for '\0'
    for( int i = 0; i < retry_count + 1; i++ )
    {
        // If FIFO is opened for reading, return OK.
        // If FIFO is full, returns an error of EAGAIN.
        // If FIFO is not opened for reading (usually because the other end
        // was once opened but now is closed), AND SIGPIPE signal is ignored,
        // returns an error of EPIPE.
        bytes_written = write( fifo_fd, IBSMON_HEARTBEAT_MSG, msg_len );
        if( bytes_written < 0 )
        {
            if( errno == EAGAIN )
            {
                if( DEBUG_ENABLED ) c_log_debug( "get EAGAIN when writing to FIFO, retry count = %d", i );
                if( retry_interval_micros > 0 && i < retry_count )
                {
                    // If this is the last time for retry, we don't go to
                    // sleep.
                    if( DEBUG_ENABLED ) c_log_debug( "sleep for %u microseconds then try to write again, retry count = %d", retry_interval_micros, i );
                    usleep( retry_interval_micros );
                }
            }
            else
            {
                c_log_error( "%s (%d): Error writing FIFO '%s' (errno = %d), %s failed to run",
                             __FILE__,
                             __LINE__,
                             ibsmon_fifo,
                             errno,
                             program_name );
                return errno;
            }
        }
        else
        {
            if( bytes_written != msg_len )
            {
                c_log_warn( "%s (%d): Unexpected number of bytes (%d) written to FIFO '%s' (expected = %d)",
                            __FILE__,
                            __LINE__,
                            bytes_written,
                            ibsmon_fifo,
                            msg_len );
            }
            else
            {
                if( DEBUG_ENABLED ) c_log_debug( "successfully write %d bytes heartbeat message to FIFO, retry count = %d", bytes_written, i );
            }
            break;
        }
    }

    if( bytes_written < 0 )
    {
        c_log_error( "%s (%d): Error writing FIFO '%s' (errno = %d), %s failed to run",
                     __FILE__,
                     __LINE__,
                     ibsmon_fifo,
                     EAGAIN,
                     program_name );
        return EAGAIN;
    }

    return 0;
}

int main( int argc, char *argv[] )
{
    int rc = 0;

    unsigned int retry_interval_micros = 0;
    int retry_count = 0;
    if( ( rc = parse_command_line_arguments( argc,
                                             argv,
                                             &retry_interval_micros,
                                             &retry_count ) ) != 0 )
    {
        return rc;
    }
    if( DEBUG_ENABLED ) c_log_debug( "program_name = %s", program_name );
    if( DEBUG_ENABLED ) c_log_debug( "ibsmon_fifo = %s", ibsmon_fifo );
    if( DEBUG_ENABLED ) c_log_debug( "retry_interval_micros = %u", retry_interval_micros );
    if( DEBUG_ENABLED ) c_log_debug( "retry_count = %d", retry_count );

    if( ( rc = ignore_SIGPIPE() ) != 0 )
    {
        return rc;
    }

    int fifo_fd = -1;
    if( ( rc = open_fifo_for_write( &fifo_fd,
                                    retry_interval_micros,
                                    retry_count ) ) != 0 )
    {
        return rc;
    }

    rc = write_heartbeat_msg_to_fifo( fifo_fd,
                                      retry_interval_micros,
                                      retry_count );

    close( fifo_fd );

    return rc;
}
