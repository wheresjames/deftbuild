
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := cvblobslib
PRJ_DEPS := cvblobslib
PRJ_TYPE := lib
PRJ_INCS := opencv/include/opencv
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),posix)
	ifeq ($(PROC),x64)
#		PRJ_DEFS := $(PRJ_DEFS) ptrdiff_t=long difference_type=long
	else
#		PRJ_DEFS := $(PRJ_DEFS) ptrdiff_t=long
	endif
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/cvblobslib
LOC_EXC_def := BlobProperties
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


