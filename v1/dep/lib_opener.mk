
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := opener
PRJ_DEPS := opener
PRJ_TYPE := lib
PRJ_INCS := opener/src opener/src/cip opener/src/enet_encap \
			opener/src/ports/platform-pc
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),windows)
	ifeq ($(BUILD),vs)
		PRJ_INCS := $(PRJ_INCS) $(CFG_LIB2BLD)/dep/etc/vs/inc/c99
	endif
endif


#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := enet
LOC_CXX_enet := c
LOC_SRC_enet := $(CFG_LIBROOT)/opener/src/enet_encap
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := cip
LOC_CXX_cip := c
LOC_SRC_cip := $(CFG_LIBROOT)/opener/src/cip
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := pc
LOC_CXX_pc := c
LOC_SRC_pc := $(CFG_LIBROOT)/opener/src/ports/platform-pc
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

