
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := ffd
PRJ_DEPS := ffmpeg
PRJ_TYPE := lib
PRJ_INCS := ffmpeg x264 vpx rtmpd
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

include lib_ffmpeg.i

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := libavcodec
LOC_CXX_libavcodec := c
LOC_SRC_libavcodec := $(CFG_LIBROOT)/ffmpeg/libavcodec
LOC_WLS_libavcodec := g h i j k l m n o p q r s t u v w x y z
LOC_WEX_libavcodec := vaa vda lib *_template
ifneq ($(PLATFORM),windows)
	ifeq ($(PROC),x64)
		LOC_WEX_libavcodec := $(LOC_WEX_libavcodec) *mmx*
	endif
endif
LOC_EXC_libavcodec := beosthread imgconvert_template motion_est_template gsmdec_template \
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

#ifeq ($(PLATFORM),windows)
#	LOC_EXC_libavcodec := $(LOC_EXC_libavcodec) pthread
#else
#	LOC_EXC_libavcodec := $(LOC_EXC_libavcodec) w32thread
#endif
ifneq ($(PLATFORM),windows)
	ifeq ($(PROC),x64)
		LOC_EXC_libavcodecx86 := $(LOC_EXC_libavcodecx86) *mmx*
	endif
endif

include $(PRJ_LIBROOT)/build.mk

# 3rd party libs
export LOC_TAG := libavcodec_lib
LOC_CXX_libavcodec_lib := c
LOC_SRC_libavcodec_lib := $(CFG_LIBROOT)/ffmpeg/libavcodec
LOC_LST_libavcodec_lib := libx264 libvpxenc libvpxdec
include $(PRJ_LIBROOT)/build.mk

# 3rd party libs
export LOC_TAG := libavformat_lib
LOC_CXX_libavformat_lib := c
LOC_SRC_libavformat_lib := $(CFG_LIBROOT)/ffmpeg/libavformat
LOC_LST_libavformat_lib := librtmp
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

endif
