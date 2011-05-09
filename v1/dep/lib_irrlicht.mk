
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := irrlicht
PRJ_DEPS := irrlicht
PRJ_TYPE := lib
PRJ_INCS := irrlicht/include jpeg png tiff zlib bzip2
PRJ_LIBS := 
PRJ_DEFS := NO_IRR_USE_NON_SYSTEM_JPEG_LIB_  NO_IRR_USE_NON_SYSTEM_LIB_PNG_ \
			NO_IRR_USE_NON_SYSTEM_ZLIB_ NO_IRR_USE_NON_SYSTEM_BZLIB_ \
			NO_IRR_COMPILE_WITH_CONSOLE_DEVICE_ \
			_STDCALL_SUPPORTED
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

ifeq ($(PLATFORM),windows)
	PRJ_DEFS := $(PRJ_DEFS) _IRR_STATIC_LIB_ _IRR_MULTI_ZLIB_
else
	PRJ_DEFS := $(PRJ_DEFS) _IRR_USE_LINUX_DEVICE_ 
endif

ifeq ($(PLATFORM),windows)
	PRJ_DEFS := $(PRJ_DEFS) IRRLICHT_EXPORTS
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/irrlicht/source/Irrlicht
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := aes
LOC_SRC_aes := $(CFG_LIBROOT)/irrlicht/source/Irrlicht/aesGladman
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := lzma
LOC_CXX_lzma := c
LOC_SRC_lzma := $(CFG_LIBROOT)/irrlicht/source/Irrlicht/lzma
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

