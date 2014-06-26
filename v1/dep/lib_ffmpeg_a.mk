
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := ffa
PRJ_DEPS := ffmpeg
PRJ_TYPE := lib
PRJ_INCS := ffmpeg openssl/include x264
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

export LOC_TAG := avf
LOC_CXX_avf := c
LOC_SRC_avf := $(CFG_LIBROOT)/ffmpeg/libavformat
LOC_WLS_avf := 0 1 2 3 4 5 6 7 8 9 a b c d e f
LOC_EXC_avf := avisynth bluray rtpdec_theora
LOC_WEX_avf := lib
include $(PRJ_LIBROOT)/build.mk

ifneq ($(PROC),arm)

# HAVE_AVX = Intel Sandy Bridge vector extension ???

	ASMOPTS := $(ASMOPTS) -I$(CFG_LIBROOT)/ffmpeg/libavutil/x86	
	ASMOPTS := $(ASMOPTS) -DHAVE_MMX=1 -DHAVE_AVX=1 -DHAVE_AMD3DNOW=1 \
						  -DHAVE_SSE=1 -DHAVE_SSSE=1 -DHAVE_SSSE3=1
	ifeq ($(PLATFORM),windows)
		ASMOPTS := $(ASMOPTS) -DHAVE_MMX2=1
	else
		ifneq ($(PROC),x64)
			ASMOPTS := $(ASMOPTS) -DHAVE_MMX2=1
		else
			ASMOPTS := $(ASMOPTS) -DHAVE_MMX2=0
		endif
	endif

	export LOC_TAG := av86_asm
	LOC_CXX_av86_asm := asm
	LOC_BLD_av86_asm := asm
	ifeq ($(PLATFORM),windows)
		ifeq ($(PROC),x64)
			LOC_ASM_av86_asm := yasm -f win64 -DARCH_X86_32=0 -DARCH_X86_64=1 $(ASMOPTS)
		else
			LOC_ASM_av86_asm := yasm -f win32 -a x86 -DPREFIX -DARCH_X86=1 -DARCH_X86_32=1 -DARCH_X86_64=0 $(ASMOPTS)
		endif
	else
		ifeq ($(PROC),x64)
			LOC_ASM_av86_asm := yasm -f elf64 -DARCH_X86_32=0 -DARCH_X86_64=1 $(ASMOPTS)
		else
			LOC_ASM_av86_asm := yasm -f elf32 -a x86 -DPIC -DARCH_X86=1 -DARCH_X86_32=1 -DARCH_X86_64=0 $(ASMOPTS)
		endif
	endif
	LOC_SRC_av86_asm := $(CFG_LIBROOT)/ffmpeg/libavcodec/x86
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := av86
	LOC_CXX_av86 := c
	LOC_SRC_av86 := $(CFG_LIBROOT)/ffmpeg/libavcodec/x86
	LOC_EXC_av86 :=	dsputil_h264_template_mmx dsputil_h264_template_ssse3 dsputil_mmx_avg_template \
				   	 dsputil_mmx_qns_template dsputil_mmx_rnd_template \
				   	 mpegvideo_mmx_template h264_qpel_mmx w64xmmtest
	ifneq ($(PLATFORM),windows)
		ifeq ($(PROC),x64)
			LOC_WEX_av86 := $(LOC_WEX_av86) *mmx*
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

#export LOC_TAG := avd
#LOC_CXX_avd := c
#LOC_SRC_avd := $(CFG_LIBROOT)/ffmpeg/libavdevice
#LOC_EXC_avd := alsa-audio-common alsa-audio-dec alsa-audio-enc bktr \
#					   jack_audio libdc1394 fbdev sndio_dec sndio_common sndio_enc
#ifeq ($(PLATFORM),windows)					   
#	LOC_EXC_avd := $(LOC_EXC_libavdevice) dv1394 oss_audio v4l v4l2 x11grab
#	ifeq ($(PROC),arm)
#		LOC_EXC_avd := $(LOC_EXC_avd) vfwcap
#	endif
#else
#LOC_EXC_avd := $(LOC_EXC_avd) vfwcap
#endif
#include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := sws
LOC_CXX_sws := c
LOC_SRC_sws := $(CFG_LIBROOT)/ffmpeg/libswscale
#LOC_EXC_sws := swscale-example colorspace-test
LOC_WEX_sws := *_template *-example *-test
include $(PRJ_LIBROOT)/build.mk


ifneq ($(PROC),arm)

	export LOC_TAG := sws86
	LOC_CXX_sws86 := c
	LOC_SRC_sws86 := $(CFG_LIBROOT)/ffmpeg/libswscale/x86
	LOC_WEX_sws86 := *_template
	ifneq ($(PLATFORM),windows)
		ifeq ($(PROC),x64)
			# LOC_EXC_sws86 := yuv2rgb_mmx
			LOC_WEX_sws86 := $(LOC_WEX_sws86) *mmx*
		endif
	endif
	ifneq ($(PROC),x64)
		LOC_EXC_sws86 := w64xmmtest
	endif
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := avu86
	LOC_CXX_avu86 := c
	LOC_SRC_avu86 := $(CFG_LIBROOT)/ffmpeg/libavutil/x86
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := sws86_asm
	LOC_CXX_sws86_asm := asm
	LOC_BLD_sws86_asm := asm
	ifeq ($(PLATFORM),windows)
		ifeq ($(PROC),x64)
			LOC_ASM_sws86_asm := yasm -f win64 -DARCH_X86_32=0 -DARCH_X86_64=1 $(ASMOPTS)
		else
			LOC_ASM_sws86_asm := yasm -f win32 -a x86 -DPREFIX -DARCH_X86=1 -DARCH_X86_32=1 -DARCH_X86_64=0 $(ASMOPTS)
		endif
	else
		ifeq ($(PROC),x64)
			LOC_ASM_sws86_asm := yasm -f elf64 -DARCH_X86_32=0 -DARCH_X86_64=1 $(ASMOPTS)
		else
			LOC_ASM_sws86_asm := yasm -f elf32 -a x86 -DPIC -DARCH_X86=1 -DARCH_X86_32=1 -DARCH_X86_64=0 $(ASMOPTS)
		endif
	endif
	LOC_SRC_sws86_asm := $(CFG_LIBROOT)/ffmpeg/libswscale/x86
	include $(PRJ_LIBROOT)/build.mk

endif

export LOC_TAG := avu
LOC_CXX_avu := c
LOC_SRC_avu := $(CFG_LIBROOT)/ffmpeg/libavutil
LOC_EXC_avu := integer softfloat
include $(PRJ_LIBROOT)/build.mk

ifneq ($(PROC),arm)

	export LOC_TAG := avu86
	LOC_CXX_avu86 := c
	LOC_SRC_avu86 := $(CFG_LIBROOT)/ffmpeg/libavutil/x86
	LOC_WEX_avu86 := *_template
	ifneq ($(PLATFORM),windows)
		ifeq ($(PROC),x64)
			LOC_WEX_avu86 := $(LOC_WEX_avu86) *mmx*
		endif
	endif
	ifneq ($(PROC),x64)
		LOC_EXC_avu86 := w64xmmtest
	endif
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := avu86
	LOC_CXX_avu86 := c
	LOC_SRC_avu86 := $(CFG_LIBROOT)/ffmpeg/libavutil/x86
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := avu86_asm
	LOC_CXX_avu86_asm := asm
	LOC_BLD_avu86_asm := asm
	ifeq ($(PLATFORM),windows)
		ifeq ($(PROC),x64)
			LOC_ASM_avu86_asm := yasm -f win64 -DARCH_X86_32=0 -DARCH_X86_64=1 $(ASMOPTS)
		else
			LOC_ASM_avu86_asm := yasm -f win32 -a x86 -DPREFIX -DARCH_X86=1 -DARCH_X86_32=1 -DARCH_X86_64=0 $(ASMOPTS)
		endif
	else
		ifeq ($(PROC),x64)
			LOC_ASM_avu86_asm := yasm -f elf64 -DARCH_X86_32=0 -DARCH_X86_64=1 $(ASMOPTS)
		else
			LOC_ASM_avu86_asm := yasm -f elf32 -a x86 -DPIC -DARCH_X86=1 -DARCH_X86_32=1 -DARCH_X86_64=0 $(ASMOPTS)
		endif
	endif
	LOC_SRC_avu86_asm := $(CFG_LIBROOT)/ffmpeg/libavutil/x86
	include $(PRJ_LIBROOT)/build.mk

endif

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

endif

