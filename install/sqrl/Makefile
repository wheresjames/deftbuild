
.PHONY : default_target
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := installers
PRJ_DESC := Squirrel Installer
PRJ_DEPS := SqPlus
PRJ_LIBROOT := ../../v1

# Signing info
#PRJ_COMPANY :=
#PRJ_URL :=
#PRJ_EMAIL :=
#PRJ_COPYRIGHT :=
#PRJ_SIGN :=

#-------------------------------------------------------------------
# Configure
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(NOSQINSTALL),)
UNSUPPORTED := SQ Engine Installer disabled (NOSQINSTALL)
include $(PRJ_LIBROOT)/unsupported.mk
else

ifeq ($(CFG_NSIS),)
UNSUPPORTED := NSIS is not installed
include $(PRJ_LIBROOT)/unsupported.mk
else

ifneq ($(PLATFORM),windows)
UNSUPPORTED := PLATFORM=$(PLATFORM) not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

ifneq ($(DBG)$(NOINSTALL),)
UNSUPPORTED := Not making installers for debug version
include $(PRJ_LIBROOT)/unsupported.mk
else

#-------------------------------------------------------------------
# Build
#-------------------------------------------------------------------
ifeq ($(SQENGINE),)
	ifeq ($(BUILD),vs)
		SQENGINE := SquirrelScript
	else
		SQENGINE := WinglibScriptEngine
	endif
endif

ifneq ($(CFG_VER),)
	NSIS_VER_STR := /DDVER="$(CFG_VER)"
endif

ifneq ($(CFG_FVER),)
	NSIS_VER_STR := $(NSIS_VER_STR) /DFVER="$(CFG_FVER)"
endif

ifneq ($(PROC),)
	NSIS_PROC_STR := /DPROC="$(PROC)"
endif

ifneq ($(BUILD),)
	NSIS_BUILD_STR := /DBUILD="$(BUILD)"
endif

ifneq ($(OS),)
	NSIS_OS_STR := /DOS="$(OS)"
endif

ifneq ($(UTOOLS),)
	NSIS_UTOOLS_STR := /DUTOOLS="$(UTOOLS)"
endif

ifneq ($(LIBLINK),)
	NSIS_LIBLINK_STR := /DLIBLINK="$(LIBLINK)"
endif

# Build list of tarets
NSIS_SCRIPTS := windows-installer-$(SQENGINE).nsi
NSIS_INSTALLERS := $(foreach f,$(NSIS_SCRIPTS),$(CFG_OUTROOT)/Install$(subst .nsi,,$(f))$(CFG_DPOSTFIX)_$(CFG_FVER)_$(PROC).exe)
NSIS_DEL_INSTALLERS := $(foreach f,$(NSIS_INSTALLERS),$(shell $(CFG_DEL) $(f)))

# Make the installers
include $(PRJ_LIBROOT)/go/sign.mk
ifneq ($(GO_SIGN_ENABLED),)
$(CFG_OUTROOT)/Install%$(CFG_DPOSTFIX)_$(CFG_FVER)_$(PROC).exe : %.nsi
	$(CFG_NSIS) /DOUTROOT="$(CFG_OUTROOT)" /DPOSTFIX="$(CFG_DPOSTFIX)" /DLIBROOT="$(CFG_LIBROOT)" $(NSIS_VER_STR) $(NSIS_PROC_STR) $(NSIS_BUILD_STR) $(NSIS_OS_STR) $(NSIS_UTOOLS_STR) $(NSIS_LIBLINK_STR) $<
	$(call GO_SIGN_EXE,$@,$(PRJ_DESC))
	$(call GO_SIGN_VERIFY,$@)
else
$(CFG_OUTROOT)/Install%$(CFG_DPOSTFIX)_$(CFG_FVER)_$(PROC).exe : %.nsi
	$(CFG_NSIS) /DOUTROOT="$(CFG_OUTROOT)" /DPOSTFIX="$(CFG_DPOSTFIX)" /DLIBROOT="$(CFG_LIBROOT)" $(NSIS_VER_STR) $(NSIS_PROC_STR) $(NSIS_BUILD_STR) $(NSIS_OS_STR) $(NSIS_UTOOLS_STR) $(NSIS_LIBLINK_STR) $<
endif

.PHONY : all
all : $(NSIS_INSTALLERS)

endif
endif
endif
endif
