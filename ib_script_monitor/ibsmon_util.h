#ifndef _H_IBSMON_UTIL
#define _H_IBSMON_UTIL

#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif

extern char *program_name;

// Defined in ibsmon_util.c
int ignore_signals( const int*, const int );
void log_error_stderr( const char *, ... );
void log_warn_stderr( const char *, ... );
void log_info_stderr( const char *, ... );
void log_debug_stderr( const char *, ... );
void log_error_syslog( const char *, ... );
void log_warn_syslog( const char *, ... );
void log_info_syslog( const char *, ... );
void log_debug_syslog( const char *, ... );
#if defined(_AIX)
void log_aix_errlog( const char *, ... );
#endif

#endif // _H_IBSMON_UTIL
