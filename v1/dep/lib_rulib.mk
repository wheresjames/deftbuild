
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := rulib
PRJ_DEPS := rulib
PRJ_TYPE := lib
PRJ_INCS := rulib/inc SqPlus/include SqPlus/sqplus opencv/include
PRJ_DEFS := ENABLE_SOCKETS ENABLE_SQUIRREL ENABLE_OPENCV

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(PLATFORM),windows)
UNSUPPORTED := BUILD=$(BUILD) is invalid
include $(PRJ_LIBROOT)/unsupported.mk
else

ifneq ($(UNICODE),)
UNSUPPORTED := UNICODE=$(UNICODE) is invalid
include $(PRJ_LIBROOT)/unsupported.mk
else

ifeq ($(BUILD),gcc)
	PRJ_DEFS := $(PRJ_DEFS) NO_VDMDBG
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/rulib
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

endif

