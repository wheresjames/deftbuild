
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := openssl_b
PRJ_DEPS := openssl
PRJ_TYPE := lib
PRJ_INCS := openssl openssl/include openssl/crypto \
			openssl/crypto/asn1 openssl/crypto/evp
PRJ_LIBS := 
PRJ_DEFS := NO_WINDOWS_BRAINDEATH I386_ONLY OPENSSL_NO_ASM

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),windows)
	PRJ_DEFS := $(PRJ_DEFS) OPENSSL_NO_ERR
endif
ifeq ($(BUILD),vs)
	PRJ_DEFS := $(PRJ_DEFS) ssize_t=long
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := ssl
LOC_CXX_ssl := c
LOC_SRC_ssl := $(CFG_LIBROOT)/openssl/ssl
LOC_EXC_ssl := ssl_task ssltest
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := engines
LOC_CXX_engines := c
LOC_SRC_engines := $(CFG_LIBROOT)/openssl/engines
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := engines_gost
LOC_CXX_engines_gost := c
LOC_SRC_engines_gost := $(CFG_LIBROOT)/openssl/engines/ccgost
LOC_EXC_engines_gost := gostsum
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


