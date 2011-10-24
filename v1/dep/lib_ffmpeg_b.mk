
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := ffmpeg_b
PRJ_DEPS := ffmpeg
PRJ_TYPE := lib
PRJ_INCS := ffmpeg x264
PRJ_LIBS := 
PRJ_DEFS := HAVE_AV_CONFIG_H=1 __STDC_CONSTANT_MACROS

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
UNSUPPORTED := BUILD=$(BUILD) is invalid, ffmpeg can only be built with 'gcc'
include $(PRJ_LIBROOT)/unsupported.mk
else

ifeq ($(PLATFORM),windows)
	ifeq ($(BUILD),vs)
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/windows/vs $(PRJ_INCS)
	else 
		ifeq ($(PROC),arm)
			PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/windows/arm $(PRJ_INCS) zlib
		else
			PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/windows/gcc $(PRJ_INCS) zlib
		endif
	endif
else
	ifeq ($(PROC),arm)
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/posix/arm $(PRJ_INCS) zlib
	else
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/posix $(PRJ_INCS) zlib
	endif
endif

CFG_CFLAGS := $(CFG_CFLAGS) -ffast-math -fomit-frame-pointer

ifdef DBG
	CFG_CFLAGS := $(CFG_CFLAGS) -fno-stack-check -O1
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

# *_a.lib, *_b.lib crap is because of windows command line limit

export LOC_TAG := libavcodec
LOC_CXX_libavcodec := c
LOC_SRC_libavcodec := $(CFG_LIBROOT)/ffmpeg/libavcodec
LOC_WLS_libavcodec := 0 1 2 3 4 5 6 7 8 9 a b c d e f
LOC_WEX_libavcodec := vaa lib *_template
ifneq ($(PLATFORM),windows)
	ifeq ($(PROC),x64)
		LOC_WEX_libavcodec := $(LOC_WEX_libavcodec) *mmx*
	endif
endif
LOC_EXC_libavcodec := beosthread g729dec imgconvert_template motion_est_template gsmdec_template \
					  mpegvideo_xvmc os2thread vdpau mpegaudio_tablegen \
					  \
					  dxva2 dxva2_h264 dxva2_vc1 \
					  \
					  dv_tablegen \
					  \
					  aacpsdata dct32 dxva2_mpeg2 \
					  \
					  dct-test fft-test motion-test \
					  \
					  crystalhd

include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

endif

