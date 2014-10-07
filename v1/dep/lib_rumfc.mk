
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := rumfc
PRJ_DEPS := rulib rumfc
PRJ_TYPE := lib
PRJ_INCS := rumfc rulib/inc SqPlus/include SqPlus/sqplus opencv/include
PRJ_DEFS := ENABLE_SOCKETS ENABLE_SQUIRREL ENABLE_OPENCV
PRJ_FWRK := mfc

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(PLATFORM),windows)
UNSUPPORTED := PLATFORM=$(PLATFORM) is invalid, rumfc can only be built on Windows
include $(PRJ_LIBROOT)/unsupported.mk
else

ifneq ($(BUILD),vs)
UNSUPPORTED := BUILD=$(BUILD) is invalid, rumfc can only be built with Visual Studio
include $(PRJ_LIBROOT)/unsupported.mk
else

ifneq ($(UNICODE),)
UNSUPPORTED := UNICODE=$(UNICODE) is invalid
include $(PRJ_LIBROOT)/unsupported.mk
else

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/rumfc
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := server
LOC_SRC_server := $(CFG_LIBROOT)/rumfc/server
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp
LOC_SRC_vp := $(CFG_LIBROOT)/rumfc/vp
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := zip
LOC_SRC_zip := $(CFG_LIBROOT)/rumfc/zip
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

endif

endif
