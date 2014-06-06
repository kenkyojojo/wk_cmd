/*
 *  Copyright 2001 Red Hat, Inc.
 * 
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  This file is formatted to fit on a 132-column screen.
 */

/* by OLS3: 修改自 RedHat 7.3 MAKEDEV-3.3.tar.gz 中的 mksock.c */

#include <sys/socket.h>
#include <sys/types.h>
#include <sys/un.h>
#include <errno.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int
main(int argc, char **argv)
{
	struct sockaddr_un sun;
	int sockfd, r;

	if(argc == 1) {
		fprintf(stderr, "Usage: mksock -V\n");
		fprintf(stderr, "       mksock PATH\n");
		return 1;
	}
	while((r = getopt(argc, argv, "V")) != -1) {
		switch(r) {
			case 'V':
			  printf("mksock version 3.3\n"); /* 去掉 VERSION */
				return 0;
			default:
				return 1;
		}
	}

	memset(&sun, 0, sizeof(sun));
	sun.sun_family = AF_UNIX;
	snprintf(sun.sun_path, sizeof(sun.sun_path), "%s", argv[1]);

	sockfd = socket(PF_UNIX, SOCK_STREAM, 0);

	r = bind(sockfd, (struct sockaddr*)&sun, sizeof(sun));
	if(r != 0) {
		fprintf(stderr, "mksock: error making %s: %s\n", sun.sun_path, strerror(errno));
		exit(1);
	}

	return 0;
}
