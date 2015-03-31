
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := srtp
PRJ_DEPS := libsrtp
PRJ_TYPE := lib
PRJ_INCS := libsrtp/include libsrtp/crypto/include openssl/include
PRJ_LIBS := 
PRJ_DEFS := HAVE_CONFIG_H \
			OPENSSL

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/srtp/inc/$(PLATFORM)/$(PROC) $(PRJ_INCS)

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := srtp
LOC_CXX_srtp := c
LOC_SRC_srtp := $(CFG_LIBROOT)/libsrtp/srtp
LOC_EXC_srtp := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := cipher
LOC_CXX_cipher := c
LOC_SRC_cipher := $(CFG_LIBROOT)/libsrtp/crypto/cipher
LOC_EXC_cipher :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := hash
LOC_CXX_hash := c
LOC_SRC_hash := $(CFG_LIBROOT)/libsrtp/crypto/hash
LOC_EXC_hash := sha1
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := ck
LOC_CXX_ck := c
LOC_SRC_ck := $(CFG_LIBROOT)/libsrtp/crypto/kernel
LOC_EXC_ck := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := creply
LOC_CXX_creply := c
LOC_SRC_creply := $(CFG_LIBROOT)/libsrtp/crypto/replay
LOC_EXC_creply := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := math
LOC_CXX_math := c
LOC_SRC_math := $(CFG_LIBROOT)/libsrtp/crypto/math
LOC_EXC_math := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := rng
LOC_CXX_rng := c
LOC_SRC_rng := $(CFG_LIBROOT)/libsrtp/crypto/rng
LOC_EXC_rng := 
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

