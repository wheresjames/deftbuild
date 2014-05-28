
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := gsoap
PRJ_DEPS := gsoap
PRJ_TYPE := lib
PRJ_INCS := openssl/include
PRJ_LIBS :=
PRJ_DEFS :=
PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(BUILD),vs)
#	PRJ_INCS := $(PRJ_INCS) $(CFG_LIB2BLD)/dep/etc/vs/inc/c99
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/gsoap/gsoap
LOC_EXC_def := 
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


