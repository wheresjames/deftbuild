
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

#-------------------------------------------------------------------
# Build
#-------------------------------------------------------------------
ifeq ($(BUILD),vs)
	NSIS_PATH := "C:\Program Files\NSIS\makensis"
else
	NSIS_PATH := makensis.exe
endif

ifeq ($(PLATFORM),windows)

all:
	echo *** Building Squirrel Engine Installer
	$(NSIS_PATH) /DOUTROOT="$(CFG_OUTROOT)" /DPOSTFIX="$(CFG_DPOSTFIX)" windows-installer.nsi

else

UNSUPPORTED := BUILD=$(BUILD) is not supported
include $(PRJ_LIBROOT)/unsupported.mk

endif
