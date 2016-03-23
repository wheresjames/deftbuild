
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := ffd
PRJ_DEPS := ffmpeg
PRJ_TYPE := lib
PRJ_INCS := ffmpeg x264 vpx rtmpd lame/include zlib
PRJ_LIBS :=
PRJ_DEFS := HAVE_AV_CONFIG_H=1 __STDC_CONSTANT_MACROS
PRJ_OPTS := -O2

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

ifneq ($(BUILD),gcc)
    ifeq ($(findstring msvs14,$(TGT)),)
	NOTSUPPORTED := 1
    endif
endif

ifneq ($(NOTSUPPORTED),)
UNSUPPORTED := $(BUILD)-$(TGT) is invalid for ffmpeg
include $(PRJ_LIBROOT)/unsupported.mk
else

include lib_ffmpeg.i

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := libavcodec
LOC_CXX_libavcodec := c
LOC_SRC_libavcodec := $(CFG_LIBROOT)/ffmpeg/libavcodec
LOC_WLS_libavcodec := i j k l m n o p
LOC_WEX_libavcodec := vaa* vda* lib* *_template *_tablegen qsv* vdpau* *-test
ifneq ($(PLATFORM),windows)
	ifeq ($(PROC),x64)
		LOC_WEX_libavcodec := $(LOC_WEX_libavcodec) *mmx*
	endif
else
	LOC_WEX_libavcodec := $(LOC_WEX_libavcodec) *_xvmc
endif
LOC_EXC_libavcodec := imgconvert_template motion_est_template \
					  os2thread vdpau mpegaudio_tablegen \
					  \
					  motion-test \
					  \
					  mmaldec \
					  \
					  nvenc

include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

endif
