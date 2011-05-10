
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := dshowbase
PRJ_DEPS := msdxsdk
PRJ_TYPE := lib
PRJ_INCS := 
PRJ_LIBS :=

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(BUILD),vs)
UNSUPPORTED := BUILD=$(BUILD) is not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/mspsdk/Samples/multimedia/directshow/baseclasses
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif


