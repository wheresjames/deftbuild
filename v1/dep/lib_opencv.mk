
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
ifneq ($(USE_HIGHGUI),)
	PRJ_DEFS := $(PRJ_DEFS) USE_HIGHGUI
endif
	
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
ifeq ($(OS),android)
	LOC_EXC_cv := cvkdtree
endif
include $(PRJ_LIBROOT)/build.mk

ifneq ($(OS),android)
	export LOC_TAG := cvaux
	LOC_SRC_cvaux := $(CFG_LIBROOT)/opencv/src/cvaux
	include $(PRJ_LIBROOT)/build.mk
endif

ifneq ($(USE_HIGHGUI),)
	export LOC_TAG := highgui
	LOC_SRC_highgui := $(CFG_LIBROOT)/opencv/src/highgui
	LOC_EXC_highgui := gstappsink image
	LOC_WEX_highgui := cvcap *carbon* *gtk*
	include $(PRJ_LIBROOT)/build.mk
endif

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

