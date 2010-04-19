
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := tiff
PRJ_DEPS := tiff
PRJ_TYPE := lib
PRJ_INCS := zlib
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
LOC_CXX_def := c
LOC_INC_def := $(CFG_LIBROOT)/tiff/libtiff
LOC_SRC_def := $(CFG_LIBROOT)/tiff/libtiff
LOC_EXC_def := tif_vms tif_wince tif_unix
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


