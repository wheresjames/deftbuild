
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := ffmpeg_a
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

ifneq ($(PROC),arm)

	ASMOPTS := $(ASMOPTS) -DHAVE_SSE
	ifeq ($(PLATFORM),windows)
		ASMOPTS := $(ASMOPTS) -DHAVE_MMX2 
	else
		ifneq ($(PROC),x64)
			ASMOPTS := $(ASMOPTS) -DHAVE_MMX2 
		endif
	endif

	export LOC_TAG := libavcodecx86_asm
	LOC_CXX_libavcodecx86_asm := asm
	LOC_BLD_libavcodecx86_asm := asm
	ifeq ($(PLATFORM),windows)
		ifeq ($(PROC),x64)
			LOC_ASM_libavcodecx86_asm := yasm -f win64 -DARCH_X86_64 $(ASMOPTS)
		else
			LOC_ASM_libavcodecx86_asm := yasm -f win32 -a x86 -DPREFIX -DARCH_X86 -DARCH_X86_32 $(ASMOPTS)
		endif
	else
		ifeq ($(PROC),x64)
			LOC_ASM_libavcodecx86_asm := yasm -f elf64 -DPIC -DARCH_X86_64 $(ASMOPTS)
		else
			LOC_ASM_libavcodecx86_asm := yasm -f elf32 -a x86 -DPIC -DARCH_X86 -DARCH_X86_32 $(ASMOPTS)
		endif
	endif
	LOC_SRC_libavcodecx86_asm := $(CFG_LIBROOT)/ffmpeg/libavcodec/x86
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := libavcodecx86
	LOC_CXX_libavcodecx86 := c
	LOC_SRC_libavcodecx86 := $(CFG_LIBROOT)/ffmpeg/libavcodec/x86
	LOC_EXC_libavcodecx86 := dsputil_h264_template_mmx dsputil_h264_template_ssse3 dsputil_mmx_avg_template \
				   			 dsputil_mmx_qns_template dsputil_mmx_rnd_template \
				   			 mpegvideo_mmx_template h264_qpel_mmx
	ifneq ($(PLATFORM),windows)
		ifeq ($(PROC),x64)
			LOC_WEX_libavcodecx86 := $(LOC_WEX_libavcodecx86) *mmx*
		endif
	endif
	include $(PRJ_LIBROOT)/build.mk

endif

ifeq ($(PROC),arm)

	export LOC_TAG := arm
	LOC_CXX_arm := c
	LOC_CXX_arm := c
	LOC_SRC_arm := $(CFG_LIBROOT)/ffmpeg/libavcodec/arm
	LOC_EXC_arm := dsputil_iwmmxt_rnd_template \
				   dsputil_iwmmxt mpegvideo_iwmmxt
	include $(PRJ_LIBROOT)/build.mk
	
#	export LOC_TAG := arm_asm
#	LOC_CXX_arm_asm := S
#	LOC_BLD_arm_asm := c
#	LOC_SRC_arm_asm := $(CFG_LIBROOT)/ffmpeg/libavcodec/arm
#	LOC_LST_arm_asm := 
#	include $(PRJ_LIBROOT)/build.mk
	
endif

export LOC_TAG := libavutil
LOC_CXX_libavutil := c
LOC_SRC_libavutil := $(CFG_LIBROOT)/ffmpeg/libavutil
LOC_EXC_libavutil := integer softfloat
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := libavformat
LOC_CXX_libavformat := c
LOC_SRC_libavformat := $(CFG_LIBROOT)/ffmpeg/libavformat
LOC_EXC_libavformat := avisynth libnut librtmp rtpdec_theora
#LOC_EXC_libavformat := avisynth libnut matroskadec mov
#ifeq ($(PROC),arm)
#	LOC_EXC_libavformat := $(LOC_EXC_libavformat) ipmovie mpegts sierravmd
#endif
include $(PRJ_LIBROOT)/build.mk

#export LOC_TAG := libavdevice
#LOC_CXX_libavdevice := c
#LOC_SRC_libavdevice := $(CFG_LIBROOT)/ffmpeg/libavdevice
#LOC_EXC_libavdevice := alsa-audio-common alsa-audio-dec alsa-audio-enc bktr \
#					   jack_audio libdc1394 fbdev sndio_dec sndio_common sndio_enc
#ifeq ($(PLATFORM),windows)					   
#	LOC_EXC_libavdevice := $(LOC_EXC_libavdevice) dv1394 oss_audio v4l v4l2 x11grab
#	ifeq ($(PROC),arm)
#		LOC_EXC_libavdevice := $(LOC_EXC_libavdevice) vfwcap
#	endif
#else
#LOC_EXC_libavdevice := $(LOC_EXC_libavdevice) vfwcap					   
#endif
#include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := libswscale
LOC_CXX_libswscale := c
LOC_SRC_libswscale := $(CFG_LIBROOT)/ffmpeg/libswscale
LOC_EXC_libswscale := rgb2rgb_template swscale_template \
					  swscale-example colorspace-test
include $(PRJ_LIBROOT)/build.mk
					  				  

ifneq ($(PROC),arm)

	export LOC_TAG := libswscalex86
	LOC_CXX_libswscalex86 := c
	LOC_SRC_libswscalex86 := $(CFG_LIBROOT)/ffmpeg/libswscale/x86
	LOC_EXC_libswscalex86 := yuv2rgb_template
	include $(PRJ_LIBROOT)/build.mk
	
	export LOC_TAG := libavutil_x86
	LOC_CXX_libavutil_x86 := c
	LOC_SRC_libavutil_x86 := $(CFG_LIBROOT)/ffmpeg/libavutil/x86
	LOC_EXC_libavutil_x86 := 
	include $(PRJ_LIBROOT)/build.mk

endif

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

endif

