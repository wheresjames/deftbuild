
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := zlib
PRJ_DEPS := zlib
PRJ_TYPE := lib
PRJ_INCS := 
PRJ_LIBS := 
PRJ_OBJROOT := _0_dep

PRJ_LIBROOT := ..

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(OS),wince)
	PRJ_DEFS := NO_ERRNO_H
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_CXX_def := c
LOC_EXC_def := example inflate minigzip
LOC_SRC_def := $(CFG_LIBROOT)/zlib
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

