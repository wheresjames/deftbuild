
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := ffserver
PRJ_DEPS := ffmpeg
PRJ_TYPE := exe
PRJ_INCS := zlib ffmpeg
PRJ_LIBS :=
PRJ_DEFS := HAVE_AV_CONFIG_H=1 __STDC_CONSTANT_MACROS

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),windows)
UNSUPPORTED := PLATFORM=$(PLATFORM) is invalid
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
LOC_LST_def := ffserver cmdutils
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

