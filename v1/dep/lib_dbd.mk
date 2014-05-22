
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := dbd
PRJ_DEPS := dbd
PRJ_TYPE := lib
PRJ_INCS := 
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

PRJ_DEFS := $(PRJ_DEFS) HAVE_WORKING_BOOST_SLEEP 

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/dbd/
LOC_EXC_def :=
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk
