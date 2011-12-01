
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := tz
PRJ_DEPS := tz
PRJ_TYPE := lib
PRJ_INCS := 
PRJ_LIBS := 
PRJ_OBJROOT := _0_dep

PRJ_LIBROOT := ..

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),windows)
	PRJ_DEFS := $(PRJ_DEFS) HAVE_SYS_WAIT_H=0 HAVE_UNISTD_H=0
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_CXX_def := c
LOC_SRC_def := $(CFG_LIBROOT)/tz
ifeq ($(PLATFORM),windows)
	LOC_EXC_def := date difftime localtime zdump zic
endif
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

