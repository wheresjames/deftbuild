
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := asio
PRJ_DEPS := asio
PRJ_TYPE := lib
PRJ_INCS := asio/common asio/host asio/host/pc
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(PLATFORM),windows)
UNSUPPORTED := PLATFORM=$(PLATFORM) is not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/asio/common
LOC_EXC_def := debugmessage dllentry register
ifeq ($(PLATFORM),windows)
	LOC_EXC_def := $(LOC_EXC_def) asiodrvr
	ifneq ($(BUILD),vs)
		LOC_EXC_def := $(LOC_EXC_def) combase
	endif
endif
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := host
LOC_SRC_host := $(CFG_LIBROOT)/asio/host
LOC_EXC_host := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := host_pc
LOC_SRC_host_pc := $(CFG_LIBROOT)/asio/host/pc
LOC_EXC_host_pc := 
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif
