
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := ffe
PRJ_DEPS := ffmpeg
PRJ_TYPE := lib
PRJ_INCS := ffmpeg x264 vpx rtmpd lame/include
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
LOC_WLS_libavcodec := q r s t u v w x y z
LOC_WEX_libavcodec := vaa* vda* lib* *_template *_tablegen qsv* vdpau* *-test
ifneq ($(PLATFORM),windows)
	ifeq ($(PROC),x64)
		LOC_WEX_libavcodec := $(LOC_WEX_libavcodec) *mmx*
	endif
else
#	LOC_WEX_libavcodec := $(LOC_WEX_libavcodec) *_xvmc
endif
LOC_EXC_libavcodec := videotoolbox

include $(PRJ_LIBROOT)/build.mk


# 3rd party libs
export LOC_TAG := libavcodec_lib
LOC_CXX_libavcodec_lib := c
LOC_SRC_libavcodec_lib := $(CFG_LIBROOT)/ffmpeg/libavcodec
LOC_LST_libavcodec_lib := libx264 libmp3lame libvpx libvpxenc libvpxdec
include $(PRJ_LIBROOT)/build.mk

# 3rd party libs
export LOC_TAG := libavformat_lib
LOC_CXX_libavformat_lib := c
LOC_SRC_libavformat_lib := $(CFG_LIBROOT)/ffmpeg/libavformat
LOC_LST_libavformat_lib := librtmp
include $(PRJ_LIBROOT)/build.mk

# 3rd party libs
export LOC_TAG := libswresample_lib
LOC_CXX_libswresample_lib := c
LOC_SRC_libswresample_lib := $(CFG_LIBROOT)/ffmpeg/libswresample
LOC_WEX_libswresample_lib := *_template *test
LOC_EXC_libswresample_lib := noise_shaping_data soxr_resample
include $(PRJ_LIBROOT)/build.mk


ifneq ($(PROC),arm)

export LOC_TAG := libswresample_x86_lib
LOC_CXX_libswresample_x86_lib := c
LOC_WEX_libswresample_x86_lib := *test
LOC_SRC_libswresample_x86_lib := $(CFG_LIBROOT)/ffmpeg/libswresample/x86
include $(PRJ_LIBROOT)/build.mk

	ASMOPTS := $(ASMOPTS) -I$(CFG_LIBROOT)/ffmpeg/libswresample/x86	
	ASMOPTS := $(ASMOPTS) -DHAVE_MMX=1 -DHAVE_AVX=1 -DHAVE_AMD3DNOW=1 \
						  -DHAVE_SSE=1 -DHAVE_SSSE=1 -DHAVE_SSSE3=1 \
						  -DHAVE_CPUNOP=1 -DHAVE_ALIGNED_STACK=1 -DHAVE_MMXEXT_EXTERNAL=1 \
						  -DHAVE_SSE2_EXTERNAL=1 -DHAVE_SSSE3_EXTERNAL=1 \
						  -DHAVE_FMA3_EXTERNAL=1 -DHAVE_AVX_EXTERNAL=1 -DHAVE_XOP_EXTERNAL=1 \
						  -DHAVE_AVX2_EXTERNAL=0 -DHAVE_FMA4_EXTERNAL=1

	export LOC_TAG := libswresample_x86_lib_asm
	LOC_CXX_libswresample_x86_lib_asm := asm
	LOC_BLD_libswresample_x86_lib_asm := asm
	ifeq ($(PLATFORM),windows)
		ifeq ($(PROC),x64)
			LOC_ASM_libswresample_x86_lib_asm := yasm -f win64 -DARCH_X86_32=0 -DARCH_X86_64=1 $(ASMOPTS)
		else
			LOC_ASM_libswresample_x86_lib_asm := yasm -f win32 -a x86 -DPREFIX -DARCH_X86=1 -DARCH_X86_32=1 -DARCH_X86_64=0 $(ASMOPTS)
		endif
	else
		ifeq ($(PROC),x64)
			LOC_ASM_libswresample_x86_lib_asm := yasm -f elf64 -DPIC -DARCH_X86_32=0 -DARCH_X86_64=1 $(ASMOPTS)
		else
			LOC_ASM_libswresample_x86_lib_asm := yasm -f elf32 -a x86 -DPIC -DARCH_X86=1 -DARCH_X86_32=1 -DARCH_X86_64=0 $(ASMOPTS)
		endif
	endif
	LOC_SRC_libswresample_x86_lib_asm := $(CFG_LIBROOT)/ffmpeg/libswresample/x86
	LOC_WEX_libswresample_x86_lib_asm := 
	LOC_EXC_libswresample_x86_lib_asm := 
	include $(PRJ_LIBROOT)/build.mk

endif


#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

endif
