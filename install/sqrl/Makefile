
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := sqrl-install
PRJ_DEPS := SqPlus
PRJ_LIBROOT := ../../v1

#-------------------------------------------------------------------
# Configure
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(DBG),)
UNSUPPORTED := Not making installer for debug version
include $(PRJ_LIBROOT)/unsupported.mk
else

#-------------------------------------------------------------------
# Build
#-------------------------------------------------------------------
ifeq ($(BUILD),vs)
	NSIS_PATH := "$(CFG_LIBROOT)/nsis/makensis.exe"
	NSIS_SCRIPT := windows-installer.nsi
else
	NSIS_PATH := wine "$(CFG_LIBROOT)/nsis/makensis.exe"
	NSIS_SCRIPT := windows-installer-gcc.nsi
endif

ifneq ($(CFG_VER),)
	NSIS_VER_STR := /DDVER="$(CFG_VER)"
endif

ifneq ($(CFG_FVER),)
	NSIS_VER_STR := $(NSIS_VER_STR) /DFVER="$(CFG_FVER)"
endif

ifneq ($(CFG_PROC),)
	NSIS_PROC_STR := /DPROC="$(CFG_PROC)"
endif

ifeq ($(PLATFORM),windows)

all:
	echo *** Building Squirrel Engine Installer
	$(NSIS_PATH) /DOUTROOT="$(CFG_OUTROOT)" /DPOSTFIX="$(CFG_DPOSTFIX)" /DLIBROOT="$(CFG_LIBROOT)" $(NSIS_VER_STR) $(NSIS_PROC_STR) $(NSIS_SCRIPT)

else

UNSUPPORTED := BUILD=$(BUILD) is not supported
include $(PRJ_LIBROOT)/unsupported.mk

endif

endif
