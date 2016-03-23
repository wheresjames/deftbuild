
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := ffc
PRJ_DEPS := ffmpeg
PRJ_TYPE := lib
PRJ_INCS := ffmpeg x264 zlib
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

# *_a.lib, *_b.lib crap is because of windows command line limit

export LOC_TAG := libavcodec
LOC_CXX_libavcodec := c
LOC_SRC_libavcodec := $(CFG_LIBROOT)/ffmpeg/libavcodec
LOC_WLS_libavcodec := 0 1 2 3 4 5 6 7 8 9 a b c d e f g h
LOC_WEX_libavcodec := vaa* lib* *_template *_tablegen *-test
ifneq ($(PLATFORM),windows)
	ifeq ($(PROC),x64)
		LOC_WEX_libavcodec := $(LOC_WEX_libavcodec) *mmx*
	endif
endif
ifneq ($(PLATFORM),windows)
	LOC_EXC_libavcodec := $(LOC_EXC_libavcodec) dxva2 dxva2_h264 dxva2_vc1 dxva2_hevc dxva2_mpeg2
endif
LOC_EXC_libavcodec := $(LOC_EXC_libavcodec) \
					  \
					  beosthread imgconvert_template gsmdec_template \
					  \
					  dv_tablegen \
					  \
					  aacpsdata dct32 \
					  \
					  dct-test fft-test \
					  \
					  crystalhd \
					  \
					  hapenc

include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

endif
