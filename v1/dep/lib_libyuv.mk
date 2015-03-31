
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := yuv
PRJ_DEPS := libyuv
PRJ_TYPE := lib
PRJ_INCS := libyuv/include
PRJ_DEFS := LIBYUV_DISABLE_X86
PRJ_LIBS := 
PRJ_FWRK := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_CXX_def := cc
LOC_BLD_def := cpp
LOC_WEX_def :=
LOC_EXC_def :=
ifeq ($(PLATFORM),windows)
	LOC_EXC_def := $(LOC_EXC_def)
	LOC_WEX_def := $(LOC_WEX_def)
endif
LOC_SRC_def := $(CFG_LIBROOT)/libyuv/source
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

