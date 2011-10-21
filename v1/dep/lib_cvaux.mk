
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := cvaux
PRJ_DEPS := _old_opencv
PRJ_TYPE := lib
PRJ_INCS := opencv/include/opencv opencv/src/cv
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
LOC_INC_def := $(CFG_LIBROOT)/opencv/src/cvaux
LOC_SRC_def := $(CFG_LIBROOT)/opencv/src/cvaux
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


