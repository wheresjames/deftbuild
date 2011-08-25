
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := purple
PRJ_DEPS := pidgin
PRJ_TYPE := lib
PRJ_INCS := glib/glib 
PRJ_LIBS := 
PRJ_DEFS :=
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
#LOC_BLD_def := cpp
LOC_SRC_def := $(CFG_LIBROOT)/pidgin/libpurple
LOC_EXC_def := 
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk



