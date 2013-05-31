
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := firebreath
PRJ_DEPS := firebreath
PRJ_TYPE := lib
PRJ_INCS := boost \
			firebreath/src/config firebreath/src/ScriptingCore \
			firebreath/src/NpapiCore firebreath/src/ActiveXCore \
			firebreath/src/PluginCore firebreath/src/PluginCore/PluginEvents
PRJ_DEFS := 
PRJ_LIBS := 
PRJ_FWRK := mfc

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(OS),wince)
	PRJ_DEFS := NO_ERRNO_H
endif

ifeq ($(BUILD),vs)
	PRJ_DEFS := $(PRJ_DEFS) FB_WIN
#	PRJ_INCS := $(PRJ_INCS) $(CFG_LIB2BLD)/dep/etc/vs/inc/c99
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := pc
LOC_SRC_pc := $(CFG_LIBROOT)/firebreath/src/PluginCore
include $(PRJ_LIBROOT)/build.mk

ifeq ($(PLATFORM),windows)

#	export LOC_TAG := idl
#	LOC_CXX_idl := idl
#	LOC_SRC_idl := $(CFG_LIBROOT)/firebreath/gen_templates
#	include $(PRJ_LIBROOT)/build.mk

#	export LOC_TAG := paw
#	LOC_SRC_paw := $(CFG_LIBROOT)/firebreath/src/PluginAuto/Win
#	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := ax
	LOC_SRC_ax := $(CFG_LIBROOT)/firebreath/src/ActiveXCore
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := axd
	LOC_SRC_axd := $(CFG_LIBROOT)/firebreath/src/ActiveXCore/AXDOM
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := pc_win
	LOC_SRC_pc_win := $(CFG_LIBROOT)/firebreath/src/PluginCore/Win
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := sc
	LOC_SRC_sc := $(CFG_LIBROOT)/firebreath/src/ScriptingCore
	include $(PRJ_LIBROOT)/build.mk

endif

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

