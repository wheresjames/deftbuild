
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := ffmpeg
PRJ_DEPS := ffmpeg
PRJ_TYPE := exe
PRJ_INCS := zlib ffmpeg
PRJ_LIBS :=
PRJ_DEFS := HAVE_AV_CONFIG_H=1 __STDC_CONSTANT_MACROS \
			AVCONV_DATADIR="\"\"" \
			CONFIG_ACONVERT_FILTER=1 \
			CONFIG_AFORMAT_FILTER=1 \
			CONFIG_AMERGE_FILTER=1 \
			CONFIG_ARESAMPLE_FILTER=1 \
			CONFIG_ASHOWINFO_FILTER=1 \
			CONFIG_ASPLIT_FILTER=1 \
			CONFIG_ASTREAMSYNC_FILTER=1 \
			CONFIG_EARWAX_FILTER=1 \
			CONFIG_PAN_FILTER=1 \
			CONFIG_SILENCEDETECT_FILTER=1 \
			CONFIG_VOLUME_FILTER=1 \
			CONFIG_ABUFFER_FILTER=0 \
			CONFIG_AEVALSRC_FILTER=1 \
			CONFIG_AMOVIE_FILTER=0 \
			CONFIG_ABUFFERSINK_FILTER=1 \
			CONFIG_ASS_FILTER=0 \
			CONFIG_BLACKDETECT_FILTER=1 \
			CONFIG_BOXBLUR_FILTER=1 \
			CONFIG_DELOGO_FILTER=1 \
			CONFIG_DESHAKE_FILTER=1 \
			CONFIG_LUT_FILTER=0 \
			CONFIG_LUTRGB_FILTER=0 \
			CONFIG_LUTYUV_FILTER=0 \
			CONFIG_NEGATE_FILTER=0 \
			CONFIG_SELECT_FILTER=1 \
			CONFIG_SETFIELD_FILTER=1 \
			CONFIG_SPLIT_FILTER=1 \
			CONFIG_THUMBNAIL_FILTER=1 \
			CONFIG_TINTERLACE_FILTER=1 \
			CONFIG_CELLAUTO_FILTER=1 \
			CONFIG_LIFE_FILTER=1 \
			CONFIG_MANDELBROT_FILTER=1 \
			CONFIG_MPTESTSRC_FILTER=1 \
			CONFIG_RGBTESTSRC_FILTER=0 \
			CONFIG_TESTSRC_FILTER=0 \
			CONFIG_BUFFERSINK_FILTER=0

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(BUILD),vs)
UNSUPPORTED := BUILD=$(BUILD) is invalid
include $(PRJ_LIBROOT)/unsupported.mk
else

ifeq ($(PLATFORM),windows)
	ifeq ($(BUILD),vs)
		PRJ_DEFS := 
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/windows/vs xlibs $(PRJ_INCS)
		PRJ_PLIB := ffa ffb ffc ffd x264 vpx openssl_a openssl_b
		ifeq ($(OS),win64)
			PRJ_LIBP := $(PRJ_LIBP) $(CFG_LIBROOT)/xlibs/x64
		else
			PRJ_LIBP := $(PRJ_LIBP) $(CFG_LIBROOT)/xlibs/x86
			PRJ_WINX := libgcc.a libmingwex.a
		endif
	else
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/windows/gcc $(PRJ_INCS) zlib
		PRJ_LIBS := $(PRJ_LIBS) ffa ffb ffc ffd ffa ffb ffc ffd x264 vpx \
								openssl_a openssl_b openssl_a openssl_b zlib
	endif
else
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/posix $(PRJ_INCS)
	PRJ_LIBS := $(PRJ_LIBS) ffa ffb ffc ffd ffa ffb ffc ffd x264 vpx \
							openssl_a openssl_b openssl_a openssl_b zlib
	PRJ_OSLB := $(PRJ_OSLB)
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_CXX_def := c
LOC_SRC_def := $(CFG_LIBROOT)/ffmpeg
LOC_LST_def := ffmpeg cmdutils
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := swr
LOC_CXX_swr := c
LOC_SRC_swr := $(CFG_LIBROOT)/ffmpeg/libswresample
LOC_EXC_swr := rematrix_template swresample_test
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := avfg
LOC_CXX_avfg := c
LOC_SRC_avfg := $(CFG_LIBROOT)/ffmpeg/libavfilter
LOC_EXC_avfg := vf_frei0r vf_libopencv vf_drawtext vf_ass vf_mp
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := avfg_x86
LOC_CXX_avfg_x86 := c
LOC_SRC_avfg_x86 := $(CFG_LIBROOT)/ffmpeg/libavfilter/x86
LOC_EXC_avfg_x86 := yadif_template
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

