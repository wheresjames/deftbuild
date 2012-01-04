
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := zma
PRJ_DEPS := zoneminder
PRJ_TYPE := exe
PRJ_INCS := zlib ffmpeg zoneminder
PRJ_LIBS := zoneminder \
			ffmpeg_a ffmpeg_b ffmpeg_c x264 \
			ffmpeg_a ffmpeg_b ffmpeg_c x264 \
			ffmpeg_a ffmpeg_b ffmpeg_c x264 \
			jpeg zlib 
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
PRJ_LIBP := $(PRJ_LIBP) /usr/lib/mysql
PRJ_OSLB := mysqlclient

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_LST_def := zma
LOC_SRC_def := $(CFG_LIBROOT)/zoneminder/src
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

