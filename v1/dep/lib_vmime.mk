
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := vmime
PRJ_DEPS := vmime
PRJ_TYPE := lib
PRJ_INCS := vmime/vmime
#			gnutls/lib/includes gnutls/libextra/includes libgsasl/src
PRJ_LIBS := 
PRJ_DEFS := VMIME_PACKAGE=\"\" VMIME_VERSION=\"\" VMIME_API=\"\" \
			VMIME_HAVE_MESSAGING_FEATURES VMIME_HAVE_FILESYSTEM_FEATURES \
			VMIME_BUILTIN_MESSAGING_PROTO_IMAP VMIME_BUILTIN_MESSAGING_PROTO_POP3 \
			VMIME_BUILTIN_MESSAGING_PROTO_SMTP VMIME_BUILTIN_MESSAGING_PROTO_MAILDIR
#			GSASL_API= ASN1_API= \			
#			VMIME_HAVE_TLS_SUPPORT VMIME_HAVE_SASL_SUPPORT 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PROC),arm)
UNSUPPORTED := PROC=$(PROC) is not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

ifeq ($(PLATFORM),windows)
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/vmime/inc/windows \
				$(CFG_LIB2BLD)/dep/etc/gnutls/inc/windows \
				$(PRJ_INCS)
else
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/vmime/inc/posix $(CFG_LIB2BLD)/dep/etc/gnutls/inc/posix $(PRJ_INCS)
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

#ifeq ($(PLATFORM),windows)
#export LOC_TAG := extra
#LOC_CXX_extra := c
#LOC_SRC_extra := $(CFG_LIBROOT)/vmime
#include $(PRJ_LIBROOT)/build.mk
#endif

export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/vmime/vmime/src
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := mdm
LOC_SRC_mdm := $(CFG_LIBROOT)/vmime/vmime/src/mdm
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := misc
LOC_SRC_misc := $(CFG_LIBROOT)/vmime/vmime/src/misc
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := net
LOC_SRC_net := $(CFG_LIBROOT)/vmime/vmime/src/net
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := net_imap
LOC_SRC_net_imap := $(CFG_LIBROOT)/vmime/vmime/src/net/imap
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := net_maildir
LOC_SRC_net_maildir := $(CFG_LIBROOT)/vmime/vmime/src/net/maildir
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := net_maildir_format
LOC_SRC_net_maildir_format := $(CFG_LIBROOT)/vmime/vmime/src/net/maildir/format
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := net_pop3
LOC_SRC_net_pop3 := $(CFG_LIBROOT)/vmime/vmime/src/net/pop3
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := net_sendmail
LOC_SRC_net_sendmail := $(CFG_LIBROOT)/vmime/vmime/src/net/sendmail
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := net_smtp
LOC_SRC_net_smtp := $(CFG_LIBROOT)/vmime/vmime/src/net/smtp
include $(PRJ_LIBROOT)/build.mk

#export LOC_TAG := tls
#LOC_SRC_tls := $(CFG_LIBROOT)/vmime/vmime/src/net/tls
#include $(PRJ_LIBROOT)/build.mk

ifeq ($(PLATFORM),windows)
	
	export LOC_TAG := platform_windows
	LOC_SRC_platform_windows := $(CFG_LIBROOT)/vmime/vmime/src/platforms/windows
	include $(PRJ_LIBROOT)/build.mk
	
	export LOC_TAG := win
	LOC_SRC_win := etc/vmime/src/windows
	include $(PRJ_LIBROOT)/build.mk
	
else

	export LOC_TAG := platform_posix
	LOC_SRC_platform_posix := $(CFG_LIBROOT)/vmime/vmime/src/platforms/posix
	include $(PRJ_LIBROOT)/build.mk
	
endif

export LOC_TAG := security
LOC_SRC_security := $(CFG_LIBROOT)/vmime/vmime/src/security
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := security_digest
LOC_SRC_security_digest := $(CFG_LIBROOT)/vmime/vmime/src/security/digest
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := security_digest_md5
LOC_SRC_security_digest_md5 := $(CFG_LIBROOT)/vmime/vmime/src/security/digest/md5
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := security_digest_sha1
LOC_SRC_security_digest_sha1 := $(CFG_LIBROOT)/vmime/vmime/src/security/digest/sha1
include $(PRJ_LIBROOT)/build.mk

#export LOC_TAG := security_sasl
#LOC_SRC_security_sasl := $(CFG_LIBROOT)/vmime/vmime/src/security/sasl
#include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := utility
LOC_SRC_utility := $(CFG_LIBROOT)/vmime/vmime/src/utility
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := utility_encoder
LOC_SRC_utility_encoder := $(CFG_LIBROOT)/vmime/vmime/src/utility/encoder
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif
