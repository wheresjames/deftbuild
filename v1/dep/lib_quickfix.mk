
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := quickfix
PRJ_DEPS := quickfix
PRJ_TYPE := lib
PRJ_INCS := libxml2/include
PRJ_LIBS := 
PRJ_DEFS := LIBXML_STATIC=1 LIBXML_THREAD_ENABLED=1

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),windows)
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/libxml/inc/windows $(PRJ_INCS)
else
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/libxml/inc/posix $(PRJ_INCS)
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/quickfix/src/C++
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


