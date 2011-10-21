
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := cxcore
PRJ_DEPS := _old_opencv
PRJ_TYPE := lib
PRJ_INCS := /opencv/include/opencv zlib
PRJ_LIBS := 

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
LOC_INCE_def := $(CFG_LIBROOT)/opencv/src/cxcore
LOC_SRC_def := $(CFG_LIBROOT)/opencv/src/cxcore
LOC_EXC_def := cxflann cxlapack
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


