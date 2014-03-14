
#ifneq ($(VSVER),)
#	UTOOLS := $(VSVER)
#else
	UTOOLS := $(TOOLS)
#endif

ifneq ($(VSVER),)
	CFG_BUILD_TYPE := $(PLATFORM)-$(VSVER)-$(OS)-$(PROC)-$(UTOOLS)
else
	CFG_BUILD_TYPE := $(PLATFORM)-$(BUILD)-$(OS)-$(PROC)-$(UTOOLS)
endif

ifdef UNICODE
	CFG_BUILD_TYPE := $(CFG_BUILD_TYPE)-unicode
endif

ifdef DBG
	CFG_BUILD_TYPE := $(CFG_BUILD_TYPE)-debug
endif

ifeq ($(LIBLINK),static)
	CFG_BUILD_TYPE := $(CFG_BUILD_TYPE)-static
else
	CFG_BUILD_TYPE := $(CFG_BUILD_TYPE)-shared
endif

CFG_BINROOT  := $(CFG_OUT)/$(CFG_BUILD_TYPE)
CFG_LOCAL_BINROOT  := $(CFG_OUT)/$(CFG_LOCAL_BUILD_TYPE)

ifdef PRJ_BINROOT
	CFG_OUTROOT := $(PRJ_BINROOT)/bin$(CFG_IDX)/$(CFG_BUILD_TYPE)
else
	CFG_OUTROOT  := $(CFG_BINROOT)
endif

ifdef PRJ_SUBROOT
	CFG_OUTROOT := $(CFG_OUTROOT)/$(PRJ_SUBROOT)
endif

ifdef PRJ_OBJROOT
	CFG_OBJROOT := $(CFG_OUTROOT)/$(PRJ_OBJROOT)/$(PRJ_NAME)
else
	CFG_OBJROOT := $(CFG_OUTROOT)/_0_obj/$(PRJ_NAME)
endif

ifneq ($(CFG_MIDL),)
	CFG_PATH_IDL := $(CFG_OBJROOT)
	PRJ_SYSI := $(PRJ_SYSI) $(CFG_PATH_IDL)
endif

CFG_INCS := $(foreach inc,$(PRJ_INCS), $(CFG_CC_INC)$(CFG_LIBROOT)/$(inc))

#ifneq ($(PROC),x86)
	CFG_TOOL_RESCMP  := $(CFG_LOCAL_TOOL_RESCMP)
	CFG_TOOL_JOIN  := $(CFG_LOCAL_TOOL_JOIN)
	CFG_TOOL_TOUCH := touch
#else
#	CFG_TOOL_RESCMP  := $(CFG_OUTROOT)/$(CFG_EXE_PRE)resbld$(CFG_DPOSTFIX)$(CFG_EXE_POST)
#	CFG_TOOL_JOIN  := $(CFG_OUTROOT)/$(CFG_EXE_PRE)join$(CFG_DPOSTFIX)$(CFG_EXE_POST)
#endif

# http://www.codeproject.com/KB/debug/mapfile.aspx
ifeq ($(BUILD),vs)
	ifneq ($(CFG_DBGINFO),)
		CFG_DBGDIR := $(CFG_BINROOT)/_0_dbg
		CFG_CFLAGS := $(CFG_CFLAGS) /Fd"$(CFG_DBGDIR)/$(PRJ_NAME).pdb"
		CFG_LFLAGS := $(CFG_LFLAGS) /Fd"$(CFG_DBGDIR)/$(PRJ_NAME).pdb" \
									/MAP:$(CFG_DBGDIR)/$(PRJ_NAME).map \
									/MAPINFO:EXPORTS
	endif
endif
