
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := crtmpserver
PRJ_DEPS := crtmp
PRJ_TYPE := exe
PRJ_INCS := openssl/include lua/src \
			crtmp/sources/common/include crtmp/sources/thelib/include
PRJ_LIBS := crtmp openssl_a openssl_b lua tinyxml
PRJ_DEFS := NET_SELECT HAS_LUA LITTLE_ENDIAN_BYTE_ALIGNED \
			HAS_PROTOCOL_TS HAS_PROTOCOL_RTMP
PRJ_WINL := shlwapi

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/crtmp/sources/crtmpserver/src
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

