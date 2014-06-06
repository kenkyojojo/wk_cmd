#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <limits.h>
#include <time.h>
#include <unistd.h>
#include <stdarg.h>
#include <signal.h>
#include <syslog.h>
#include <sys/types.h>
#if defined(_AIX)
#include <sys/errids.h>
#endif
#include "ibsmon_util.h"

#define IBSMON_FORMAT_STRING_SIZE 512
#define IBSMON_LOG_MSG_SIZE ( IBSMON_FORMAT_STRING_SIZE * 2 )

char ibsmon_format_string[ IBSMON_FORMAT_STRING_SIZE ] = "";
char ibsmon_log_msg[ IBSMON_LOG_MSG_SIZE ] = "";

#define IBSMON_LOG_ERROR_LEVEL "[ERR] "
#define IBSMON_LOG_WARN_LEVEL "[WARN] "
#define IBSMON_LOG_INFO_LEVEL "[INFO] "
#define IBSMON_LOG_DEBUG_LEVEL "[DEBUG] "

/**
 * Ignore signals specified by signums argument.
 *
 * return 0
 *          all signals specified by signums argument are ignored
 *        errno
 *          error on sigemptyset()/sigaction()
 */
int ignore_signals( const int* signums, const int size )
{
    int rc = 0;
    struct sigaction action;

    memset( &action, 0, sizeof( action ) );
    if( ( rc = sigemptyset( &action.sa_mask ) ) != 0 )
    {
        return rc;
    }
    action.sa_flags = 0;
    action.sa_handler = SIG_IGN;

    for( int i = 0; i < size; i++ )
    {
        if( ( rc = sigaction( signums[ i ], &action, NULL ) ) != 0 )
        {
            return rc;
        }
    }

    return 0;
}

/**
 * Returns the current timestamp in the format similar to
 * "Wed Apr 23 13:57:28 2014".
 */
char *get_timestamp( void )
{
    time_t now = time( NULL );
    if( now == (time_t)-1 )
    {
        return "";
    }

    char *ts = asctime( localtime( &now ) );
    if( ts[ strlen( ts ) - 1 ] == '\n' )
    {
        ts[ strlen( ts ) - 1 ] = '\0';
    }

    return ts;
}

/**
 * A helper function that sets the format string to be used with logging.
 * This function writes the format string to ibsmon_format_string global
 * variabl.
 *
 * return 0
 *          if ibsmon_format_string is set
 *        -1
 *          if ibsmon_format_string is not large enough to accomodate fmt
 *          string.
 */
int set_format_string( const char *log_level,
                       const char *fmt,
                       int include_timestamp,
                       int include_log_level,
                       int include_newline )
{
    memset( ibsmon_format_string, 0, IBSMON_FORMAT_STRING_SIZE );

    // format should look like "timestamp level - "
    char *cur = ibsmon_format_string;
    char *end = ibsmon_format_string + sizeof( ibsmon_format_string );
    if( include_timestamp )
    {
        // Some words about snprintf.
        // AXI man page: The snprintf subroutine places a null character (\0)
        // at the end. You must ensure that enough storage space is available
        // to contain the formatted string.
        // Linux man page: The functions snprintf() and vsnprintf() write at
        // most size bytes (including the trailing null byte ('\0')) to str.
        cur += snprintf( cur, end - cur, "%s ", get_timestamp() );
    }
    if( include_log_level )
    {
        if( cur < end )
        {
            cur += snprintf( cur, end - cur, "%s", log_level );
        }
        else
        {
            return -1;
        }
    }

    size_t fmt_len = strlen( fmt );
    size_t needed_len = ( include_newline ? fmt_len + 1 : fmt_len );
    if( end - cur - 1 < needed_len )
    {
        // Not enough space in ibsmon_format_string.
        return -1;
    }

    // It's safe just calling strcat().
    strcat( ibsmon_format_string, fmt );
    if( include_newline )
    {
        strcat( ibsmon_format_string, "\n" );
    }

    return 0;
}

void log_error_stderr( const char *fmt, ... )
{
    if( set_format_string( IBSMON_LOG_ERROR_LEVEL, fmt, TRUE, TRUE, TRUE ) != 0 )
    {
        return;
    }

    va_list argp;
    va_start( argp, fmt );
    vfprintf( stderr, ibsmon_format_string, argp );
    va_end( argp );
}

void log_warn_stderr( const char *fmt, ... )
{
    if( set_format_string( IBSMON_LOG_WARN_LEVEL, fmt, TRUE, TRUE, TRUE ) != 0 )
    {
        return;
    }

    va_list argp;
    va_start( argp, fmt );
    vfprintf( stderr, ibsmon_format_string, argp );
    va_end( argp );
}

void log_info_stderr( const char *fmt, ... )
{
    if( set_format_string( IBSMON_LOG_INFO_LEVEL, fmt, TRUE, TRUE, TRUE ) != 0 )
    {
        return;
    }

    va_list argp;
    va_start( argp, fmt );
    vfprintf( stderr, ibsmon_format_string, argp );
    va_end( argp );
}

void log_debug_stderr( const char *fmt, ... )
{
    if( set_format_string( IBSMON_LOG_DEBUG_LEVEL, fmt, TRUE, TRUE, TRUE ) != 0 )
    {
        return;
    }

    va_list argp;
    va_start( argp, fmt );
    vfprintf( stderr, ibsmon_format_string, argp );
    va_end( argp );
}

void log_error_syslog( const char *fmt, ... )
{
    if( set_format_string( IBSMON_LOG_ERROR_LEVEL, fmt, FALSE, TRUE, FALSE ) != 0 )
    {
        return;
    }

    va_list argp;
    va_start( argp, fmt );
    vsnprintf( ibsmon_log_msg,
               IBSMON_LOG_MSG_SIZE,
               ibsmon_format_string,
               argp );
    va_end( argp );

    syslog( LOG_ERR, ibsmon_log_msg );
}

void log_warn_syslog( const char *fmt, ... )
{
    if( set_format_string( IBSMON_LOG_WARN_LEVEL, fmt, FALSE, TRUE, FALSE ) != 0 )
    {
        return;
    }

    va_list argp;
    va_start( argp, fmt );
    vsnprintf( ibsmon_log_msg,
               IBSMON_LOG_MSG_SIZE,
               ibsmon_format_string,
               argp );
    va_end( argp );

    syslog( LOG_WARNING, ibsmon_log_msg );
}

void log_info_syslog( const char *fmt, ... )
{
    if( set_format_string( IBSMON_LOG_INFO_LEVEL, fmt, FALSE, TRUE, FALSE ) != 0 )
    {
        return;
    }

    va_list argp;
    va_start( argp, fmt );
    vsnprintf( ibsmon_log_msg,
               IBSMON_LOG_MSG_SIZE,
               ibsmon_format_string,
               argp );
    va_end( argp );

    syslog( LOG_INFO, ibsmon_log_msg );
}

void log_debug_syslog( const char *fmt, ... )
{
    if( set_format_string( IBSMON_LOG_DEBUG_LEVEL, fmt, FALSE, TRUE, FALSE ) != 0 )
    {
        return;
    }

    va_list argp;
    va_start( argp, fmt );
    vsnprintf( ibsmon_log_msg,
               IBSMON_LOG_MSG_SIZE,
               ibsmon_format_string,
               argp );
    va_end( argp );

    syslog( LOG_DEBUG, ibsmon_log_msg );
}

#if defined(_AIX)
/**
 * Creates a log entry in AIX error log.
 * Reference: http://ps-2.kev009.com/tl/techlib/qna/sfam/html/N/N9814L.htm
 */
void log_aix_errlog( const char *fmt, ... )
{
    // See /usr/include/sys/err_rec.h for detail.
    // I believe IBSMON_LOG_MSG_SIZE should be less than ERR_REC_MAX (4096).
    ERR_REC( IBSMON_LOG_MSG_SIZE ) error_rec;

    // We need an ID that can show arbitray detail_data. ERRID_OPMSG is used
    // by errlogger command.
    //error_rec.error_id = ERRID_SOFTWARE_SYMPTOM;
    error_rec.error_id = ERRID_OPMSG;

    // size of resource_name is ERR_NAMESIZE.
    strncpy( error_rec.resource_name, program_name, ERR_NAMESIZE - 1 );
    error_rec.resource_name[ ERR_NAMESIZE - 1 ] = '\0';

    if( set_format_string( IBSMON_LOG_ERROR_LEVEL, fmt, FALSE, TRUE, FALSE ) != 0 )
    {
        return;
    }
    va_list argp;
    va_start( argp, fmt );
    vsnprintf( error_rec.detail_data, // size of detail_data should be IBSMON_LOG_MSG_SIZE
               IBSMON_LOG_MSG_SIZE,
               ibsmon_format_string,
               argp );
    va_end( argp );

    unsigned int rec_len = sizeof( error_rec );

    if( errlog( &(error_rec), rec_len ) != 0 )
    {
        // Fall back to syslog.
        log_error_syslog( "Failed to log error entry to AIX error log for %s",
                          program_name );
        log_error_syslog( "The failing message: %s", error_rec.detail_data );
    }

    // Sent to syslog as well.
    //log_error_syslog( "%s", error_rec.detail_data + 8 );
    log_error_syslog( "%s", error_rec.detail_data + strlen( IBSMON_LOG_ERROR_LEVEL ) );
}
#endif
