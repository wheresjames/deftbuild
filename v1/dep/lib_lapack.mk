
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := lapack
PRJ_DEPS := opencv
PRJ_TYPE := lib
PRJ_INCS := opencv/3rdparty/include
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(TOOLS),iphone)
UNSUPPORTED := TOOLS=$(TOOLS) is not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := lapack
LOC_CXX_lapack := c
LOC_SRC_lapack := $(CFG_LIBROOT)/opencv/3rdparty/lapack
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

