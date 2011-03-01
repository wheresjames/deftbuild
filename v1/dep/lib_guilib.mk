
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := guilib
PRJ_DEPS := guilib
PRJ_TYPE := lib
PRJ_INCS := guilib
PRJ_LIBS := 
PRJ_DEFS := _GUILIB_NOLIB _GUILIB_STATIC_

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(PROC),x86)
UNSUPPORTED := PROC=$(PROC) is not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

ifneq ($(PLATFORM),windows)
UNSUPPORTED := PLATFORM=$(PLATFORM) is invalid
include $(PRJ_LIBROOT)/unsupported.mk
else

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_EXC_def := GuiADODB CGuiEditView GuiDockBar GuiGridLayout GuiLib
LOC_SRC_def := $(CFG_LIBROOT)/guilib
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := rc
LOC_CXX_rc := rc
LOC_BLD_rc := rc
LOC_SRC_rc := 
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

endif
