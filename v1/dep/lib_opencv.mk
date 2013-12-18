
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := opencv
PRJ_DEPS := opencv
PRJ_TYPE := lib
PRJ_INCS := jpeg png tiff/libtiff zlib \
			opencv/include/opencv opencv/src/cv \
			opencv/3rdparty/include
PRJ_LIBS := 
ifneq ($(USE_HIGHGUI),)
	PRJ_INCS := $(PRJ_INCS) jpeg png
	PRJ_DEFS := $(PRJ_DEFS) USE_HIGHGUI HAVE_JPEG=1 HAVE_ZLIB=1 HAVE_PNG=1 \
				png_set_gray_1_2_4_to_8=png_set_expand_gray_1_2_4_to_8
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

ifeq ($(PLATFORM),posix)
	ifeq ($(PROC),x64)
#		PRJ_DEFS := $(PRJ_DEFS) ptrdiff_t=long difference_type=long
	endif
endif

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
	LOC_EXC_cvaux := cvba
	include $(PRJ_LIBROOT)/build.mk
endif

ifneq ($(USE_HIGHGUI),)

	export LOC_TAG := highgui
	LOC_SRC_highgui := $(CFG_LIBROOT)/opencv/src/highgui
	LOC_EXC_highgui := gstappsink image
	LOC_WEX_highgui := cvcap *carbon* *gtk*
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := highgui_cap
	LOC_SRC_highgui_cap := $(CFG_LIBROOT)/opencv/src/highgui
	LOC_LST_highgui_cap := cvcap cvcap_images 

	ifeq ($(PLATFORM),windows)
		LOC_LST_highgui_cap := $(LOC_LST_highgui_cap) cvcap_w32 cvcap_vfw 
	else
		LOC_LST_highgui_cap := $(LOC_LST_highgui_cap) cvcap_v4l
	endif

	include $(PRJ_LIBROOT)/build.mk

endif

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

