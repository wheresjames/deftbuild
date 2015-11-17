
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := live555
PRJ_DEPS := live555
PRJ_TYPE := lib
PRJ_INCS := live555/liveMedia/include live555/groupsock/include \
			live555/UsageEnvironment/include live555/BasicUsageEnvironment/include 
PRJ_DEFS := SOCKLEN_T=socklen_t BSD=1
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),windows)
	PRJ_DEFS := $(PRJ_DEFS) _WINNT=$(WINVER) WINNT=$(WINVER)
	ifeq ($(PROC),arm)
		PRJ_DEFS := $(PRJ_DEFS) LOCALE_NOT_USED
	endif
endif

ifeq ($(BUILD),gcc)
#	PRJ_DEFS := $(PRJ_DEFS) TIMEVAL=timeval
#	PRJ_DEFS := $(PRJ_DEFS) _TIMEVAL_DEFINED
endif

ifeq ($(OS),android)
	PRJ_DEFS := $(PRJ_DEFS) NULL=0
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/live555/liveMedia
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := def_c
LOC_CXX_def_c := c
LOC_SRC_def_c := $(CFG_LIBROOT)/live555/liveMedia
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := bue
LOC_SRC_bue := $(CFG_LIBROOT)/live555/BasicUsageEnvironment
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := ue
LOC_SRC_ue := $(CFG_LIBROOT)/live555/UsageEnvironment
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := net
LOC_SRC_net := $(CFG_LIBROOT)/live555/groupsock
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := net_c
LOC_CXX_net_c := c
LOC_SRC_net_c := $(CFG_LIBROOT)/live555/groupsock
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


