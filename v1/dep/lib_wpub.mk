
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := Vp
PRJ_DEPS := Vp
PRJ_TYPE := exe
PRJ_INCS := rulib/inc SqPlus/include
PRJ_LIBS := rulib cximage jpeg png zlib
PRJ_DEFS := ENABLE_SOCKETS
PRJ_OSLB := winmm.lib vfw32.lib

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(PLATFORM),windows)
UNSUPPORTED := PLATFORM=$(PLATFORM) is invalid, rulib can only be built on Windows
include $(PRJ_LIBROOT)/unsupported.mk
else

CFG_LFLAGS := $(CFG_LFLAGS) /SUBSYSTEM:WINDOWS

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/Vp
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := opc
LOC_SRC_opc := $(CFG_LIBROOT)/Vp/opc
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

