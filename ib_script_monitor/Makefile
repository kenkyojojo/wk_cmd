# Use gmake on AIX

OSNAME = $(shell uname -s)

ifeq ($(OSNAME), AIX)
    CC = xlc
    CFLAGS = -q64 -qinfo=cmp:cnd:cnv:dcl:eff:ext:gen:gnr:ini:ord:par:por:pro:rea:ret:trd:uni:use -lrts
    MAKE = gmake
endif
ifeq ($(OSNAME), Linux)
    CC = gcc
    CFLAGS = -m64 -D_BSD_SOURCE -D_POSIX_SOURCE -Wall -std=c99
    MAKE = make
endif

ifdef DEBUG
	MODE = debug
    ifeq ($(OSNAME), AIX)
        CFLAGS += -g -O0 -D_IBSMON_DEBUG
    endif
    ifeq ($(OSNAME), Linux)
        CFLAGS += -g -O0 -D_IBSMON_DEBUG
    endif
endif
ifdef RELEASE
	MODE = release
    ifeq ($(OSNAME), AIX)
        CFLAGS += -O2
    endif
    ifeq ($(OSNAME), Linux)
        CFLAGS += -O2
    endif
endif

BUILDDIR = ./$(MODE)

all:
	$(MAKE) DEBUG=1 build
	$(MAKE) RELEASE=1 build

build: dir $(BUILDDIR)/ibsmon_np $(BUILDDIR)/ibsmon_np_client

dir:
	if [ -d $(BUILDDIR) ] ; then true; else mkdir -p $(BUILDDIR) ; fi;

$(BUILDDIR)/ibsmon_np:   ibsmon_np.c ibsmon_np.h $(BUILDDIR)/ibsmon_util.o
	$(CC) $(CFLAGS) -o $@ ibsmon_np.c $(BUILDDIR)/ibsmon_util.o

$(BUILDDIR)/ibsmon_np_client:   ibsmon_np_client.c ibsmon_np.h $(BUILDDIR)/ibsmon_util.o
	$(CC) $(CFLAGS) -o $@ ibsmon_np_client.c $(BUILDDIR)/ibsmon_util.o

$(BUILDDIR)/ibsmon_util.o:   ibsmon_util.c ibsmon_util.h
	$(CC) $(CFLAGS) -o $@ -c ibsmon_util.c

clean:
	rm -rf release debug
