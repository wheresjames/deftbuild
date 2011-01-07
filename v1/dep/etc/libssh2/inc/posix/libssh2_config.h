#ifndef LIBSSH2_CONFIG_H
#define LIBSSH2_CONFIG_H

#define HAVE_UNISTD_H
#define HAVE_INTTYPES_H
#define HAVE_SYS_TIME_H
#define HAVE_SELECT
#define HAVE_UIO
#define HAVE_SYS_SOCKET_H
#define HAVE_NETINET_IN_H
#define HAVE_ARPA_INET_H

#define POSIX_C_SOURCE

/* Enable the possibility of using tracing */
//#define LIBSSH2DEBUG 1

/* For selection of proper block/unblock function in session.c */
#define HAVE_O_NONBLOCK

//#include <stropts.h>

#define LIBSSH2_HAVE_ZLIB

/* Enable newer diffie-hellman-group-exchange-sha1 syntax */
#define LIBSSH2_DH_GEX_NEW 1

#endif /* LIBSSH2_CONFIG_H */

