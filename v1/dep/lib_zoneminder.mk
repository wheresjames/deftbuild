
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := zoneminder
PRJ_DEPS := zoneminder
PRJ_TYPE := lib
PRJ_INCS := zlib ffmpeg
PRJ_DEFS := __STDC_CONSTANT_MACROS

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(PLATFORM),posix)
UNSUPPORTED := PLATFORM=$(PLATFORM) is invalid
include $(PRJ_LIBROOT)/unsupported.mk
else

PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/zoneminder/inc $(PRJ_INCS)

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_EXC_def := zma zmb zmc zmf zmfix zms zmstreamer zmu
LOC_SRC_def := $(CFG_LIBROOT)/zoneminder/src
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

