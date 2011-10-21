
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := haru
PRJ_DEPS := haru
PRJ_TYPE := lib
PRJ_INCS := haru/include png zlib
PRJ_LIBS := 
PRJ_DEFS :=
PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(DBG),)
	PRJ_DEFS := $(PRJ_DEFS) LIBHPDF_DEBUG=1
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_CXX_def := c
LOC_SRC_def := $(CFG_LIBROOT)/haru/src
LOC_EXC_def := serial
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

