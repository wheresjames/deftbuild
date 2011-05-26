
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := cximage
PRJ_DEPS := CxImage
PRJ_TYPE := lib
PRJ_INCS := zlib tiff
PRJ_LIBS := 
PRJ_DEFS := CXIMAGE_CUSTOM_ALLOCATOR=1 CX_FORCE_CUSTOM_ALLOCATOR=1

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM)$(PROC)$(BUILD),windowsx64vs)
	PRJ_DEFS := $(PRJ_DEFS) _tfopen=fopen WIN32
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/CxImage
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


