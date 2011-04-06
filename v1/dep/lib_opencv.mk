
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := opencv
PRJ_DEPS := opencv
PRJ_TYPE := lib
PRJ_INCS := opencv/include/opencv opencv/src/cv \
			opencv/3rdparty/include zlib
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

export LOC_TAG := cxcore
LOC_SRC_cxcore := $(CFG_LIBROOT)/opencv/src/cxcore
LOC_EXC_cxcore := cxflann
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := cv
LOC_SRC_cv := $(CFG_LIBROOT)/opencv/src/cv
LOC_EXC_cv := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := cvaux
LOC_SRC_cvaux := $(CFG_LIBROOT)/opencv/src/cvaux
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

