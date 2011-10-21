
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := panotools
PRJ_DEPS := panotools
PRJ_TYPE := lib
PRJ_INCS := jpeg png zlib tiff/libtiff
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
#LOC_INC_def := $(CFG_LIBROOT)/panotools/pano13
LOC_SRC_def := $(CFG_LIBROOT)/panotools/pano13
LOC_EXC_def := PTDialogs pteditor ptpicker seamer_

#LOC_EXC_def := PixMap pict pteditor ptpicker seamer_ \
#			   shell_mac sys_mac sys_X11

ifeq ($(PLATFORM),windows)
	LOC_EXC_def := $(LOC_EXC_def) 
else
	LOC_EXC_def := $(LOC_EXC_def)
endif

include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


