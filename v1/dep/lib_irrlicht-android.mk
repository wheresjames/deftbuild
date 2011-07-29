
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := irrlicht-android
PRJ_DEPS := irrlicht-android
PRJ_TYPE := lib
PRJ_INCS := irrlicht-android/project/include irrlicht-android/project/jni jpeg png tiff zlib bzip2
PRJ_LIBS := 
PRJ_DEFS := NO_IRR_USE_NON_SYSTEM_JPEG_LIB_  NO_IRR_USE_NON_SYSTEM_LIB_PNG_ \
			NO_IRR_USE_NON_SYSTEM_ZLIB_ NO_IRR_USE_NON_SYSTEM_BZLIB_ \
			NO_IRR_COMPILE_WITH_CONSOLE_DEVICE_ \
			png_set_gray_1_2_4_to_8=png_set_expand_gray_1_2_4_to_8 \
			ANDROID_NDK \
			_STDCALL_SUPPORTED
PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(PROC),arm)
UNSUPPORTED := PROC=$(PROC) is not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

PRJ_DEFS := $(PRJ_DEFS) _IRR_USE_LINUX_DEVICE_ 

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/irrlicht-android/project/jni
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := aes
LOC_SRC_aes := $(CFG_LIBROOT)/irrlicht-android/project/jni/aesGladman
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := lzma
LOC_CXX_lzma := c
LOC_SRC_lzma := $(CFG_LIBROOT)/irrlicht-android/project/jni/lzma
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

