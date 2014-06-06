#ifndef _H_IBSMON_NP
#define _H_IBSMON_NP

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <memory.h>
#include <errno.h>
#include <signal.h>
#include <libgen.h>
#include <sys/stat.h>
#include "ibsmon_util.h"

#define IBSMON_HEARTBEAT_MSG "IB script alive"

#if defined(_IBSMON_DEBUG)
#define DEBUG_ENABLED 1
#else
#define DEBUG_ENABLED 0
#endif

// Client log functions
#define c_log_error( fmt, ... ) log_error_stderr( fmt, ##__VA_ARGS__ )
#define c_log_warn( fmt, ... ) log_warn_stderr( fmt, ##__VA_ARGS__ )
#define c_log_info( fmt, ... ) log_info_stderr( fmt, ##__VA_ARGS__ )
#define c_log_debug( fmt, ... ) log_debug_stderr( fmt, ##__VA_ARGS__ )

// Deamon (server) log functions
#if defined(_IBSMON_DEBUG)
#define d_log_error( fmt, ... ) log_error_stderr( fmt, ##__VA_ARGS__ )
//#define d_log_error( fmt, ... ) log_aix_errlog( fmt, ##__VA_ARGS__ )
#define d_log_warn( fmt, ... ) log_warn_stderr( fmt, ##__VA_ARGS__ )
#define d_log_info( fmt, ... ) log_info_stderr( fmt, ##__VA_ARGS__ )
#define d_log_debug( fmt, ... ) log_debug_stderr( fmt, ##__VA_ARGS__ )
//#define d_log_error( fmt, ... ) log_error_syslog( fmt, ##__VA_ARGS__ )
//#define d_log_warn( fmt, ... ) log_warn_syslog( fmt, ##__VA_ARGS__ )
//#define d_log_debug( fmt, ... ) log_debug_syslog( fmt, ##__VA_ARGS__ )
#else
#if defined(_AIX)
#define d_log_error( fmt, ... ) log_aix_errlog( fmt, ##__VA_ARGS__ )
#else
#define d_log_error( fmt, ... ) log_error_syslog( fmt, ##__VA_ARGS__ )
#endif // _AIX
#define d_log_warn( fmt, ... ) log_warn_syslog( fmt, ##__VA_ARGS__ )
#define d_log_info( fmt, ... ) log_info_syslog( fmt, ##__VA_ARGS__ )
#define d_log_debug( fmt, ... ) log_debug_syslog( fmt, ##__VA_ARGS__ )
#endif

#endif // _H_IBSMON_NP
