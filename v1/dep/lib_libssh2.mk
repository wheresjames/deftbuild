
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := ssh2
PRJ_DEPS := libssh2
PRJ_TYPE := lib
PRJ_INCS := libssh2/include openssl/include zlib
PRJ_LIBS := 
PRJ_DEFS := USE_OPENSSL USE_SSLEAY LIBSSH2DEBUG_USERCALLBACK

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),windows)
	PRJ_INCS := $(PRJ_INCS) libssh2/win32
else
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/libssh2/inc/posix $(PRJ_INCS)
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_CXX_def := c
LOC_SRC_def := $(CFG_LIBROOT)/libssh2/src
LOC_EXC_def :=  
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

