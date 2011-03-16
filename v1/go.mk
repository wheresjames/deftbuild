
ifndef ABORT_UNSUPPORTED

# Create file name
ifndef BLD_FILE_EXE
	ifdef PRJ_FILE_EXE		 
		BLD_FILE_EXE := $(PRJ_FILE_EXE)
	else
		ifeq ($(PRJ_TYPE),lib)
			BLD_FILE_EXE := $(CFG_LIB_PRE)$(PRJ_NAME)$(CFG_DPOSTFIX)$(CFG_LIB_POST)
		else
			ifeq ($(PRJ_TYPE),dll)
				BLD_FILE_EXE := $(CFG_DLL_PRE)$(PRJ_NAME)$(CFG_DPOSTFIX)$(CFG_DLL_POST)
			else
				BLD_FILE_EXE := $(CFG_EXE_PRE)$(PRJ_NAME)$(CFG_DPOSTFIX)$(CFG_EXE_POST)
			endif
		endif
	endif
	BLD_PATH_EXE := $(CFG_OUTROOT)/$(BLD_FILE_EXE)	
endif

# Windows Version Resource
ifneq ($(CFG_VER),)
ifeq ($(PLATFORM),windows)
ifeq ($(PRJ_NORC),)
ifneq ($(strip $(foreach t,dll exe,$(findstring $(t),$(PRJ_TYPE)))),)

ifeq ($(PRJ_WVER_NAME),)
	PRJ_WVER_NAME := $(PRJ_NAME)
endif
ifeq ($(PRJ_WVER_FVER),)
	PRJ_WVER_FVER := $(subst .,\$(CFG_COMMA) ,$(CFG_VER))
endif
ifeq ($(PRJ_WVER_PVER),)
	PRJ_WVER_PVER := $(subst .,\$(CFG_COMMA) ,$(CFG_VER))
endif
ifeq ($(PRJ_WVER_FNAME),)
	PRJ_WVER_FNAME := $(BLD_FILE_EXE)
endif
ifeq ($(PRJ_WVER_DESC),)
	PRJ_WVER_DESC := $(PRJ_DESC)
endif
ifeq ($(PRJ_WVER_COMPANY),)
	PRJ_WVER_COMPANY := $(PRJ_COMPANY)
endif
ifeq ($(PRJ_WVER_COPYRIGHT),)
	PRJ_WVER_COPYRIGHT := $(PRJ_COPYRIGHT)
endif
ifeq ($(PRJ_WVER_COMMENTS),)
	PRJ_WVER_COMMENTS := $(PRJ_URL)
endif
ifeq ($(PRJ_TYPE),dll)
	PRJ_WVER_FTYPE := 0x2L
else
	PRJ_WVER_FTYPE := 0x1L
endif
CFG_VER_OUT := $(CFG_OUTROOT)/_0_obj/$(PRJ_NAME)
CFG_VER_FSRC := $(PRJ_LIBROOT)/win.vinf.rc
CFG_VER_FDST := $(CFG_VER_OUT)/ver.rc
.PRECIOUS: $(CFG_VER_FDST)
$(CFG_VER_FDST): $(CFG_VER_FSRC)
	$(shell $(CFG_CPY) "$(CFG_VER_FSRC)" "$(CFG_VER_FDST)")
	$(shell $(CFG_SAR) "s/@NAME/$(call CFG_FWD_ESCAPE,$(PRJ_WVER_NAME))/g" "$(CFG_VER_FDST)")
	$(shell $(CFG_SAR) "s/@FVER/$(call CFG_FWD_ESCAPE,$(PRJ_WVER_FVER))/g" "$(CFG_VER_FDST)")
	$(shell $(CFG_SAR) "s/@PVER/$(call CFG_FWD_ESCAPE,$(PRJ_WVER_PVER))/g" "$(CFG_VER_FDST)")
	$(shell $(CFG_SAR) "s/@FTYPE/$(call CFG_FWD_ESCAPE,$(PRJ_WVER_FTYPE))/g" "$(CFG_VER_FDST)")
	$(shell $(CFG_SAR) "s/@FNAME/$(call CFG_FWD_ESCAPE,$(PRJ_WVER_FNAME))/g" "$(CFG_VER_FDST)")
	$(shell $(CFG_SAR) "s/@DESC/$(call CFG_FWD_ESCAPE,$(PRJ_WVER_DESC))/g" "$(CFG_VER_FDST)")
	$(shell $(CFG_SAR) "s/@COMPANY/$(call CFG_FWD_ESCAPE,$(PRJ_WVER_COMPANY))/g" "$(CFG_VER_FDST)")
	$(shell $(CFG_SAR) "s/@COPYRIGHT/$(call CFG_FWD_ESCAPE,$(PRJ_WVER_COPYRIGHT))/g" "$(CFG_VER_FDST)")
	$(shell $(CFG_SAR) "s/@COMMENTS/$(call CFG_FWD_ESCAPE,$(PRJ_WVER_COMMENTS))/g" "$(CFG_VER_FDST)")

$(CFG_VER_OUT)/_rc/%.res: $(CFG_VER_OUT)/%.rc
#GO_DEPENDS 	:= $(GO_DEPENDS) $(CFG_VER_FDST)
export LOC_TAG := _rc
LOC_CXX__rc := rc
LOC_BLD__rc := rc
LOC_SRC__rc := $(CFG_VER_OUT)
LOC_LST__rc := ver
include $(PRJ_LIBROOT)/build.mk

endif
endif
endif
endif

# Squirrel build
ifdef PRJ_SQRL
	ifeq ($(PRJ_SQRL),service)
		export LOC_TAG := sqs
		LOC_SRC_sqs := $(CFG_LIBROOT)/winglib/tools/sqservice
		include $(PRJ_LIBROOT)/build.mk	
	else
		export LOC_TAG := sq
		LOC_SRC_sq := $(CFG_LIBROOT)/winglib/tools/sqembed
		include $(PRJ_LIBROOT)/build.mk	
	endif
endif

ifdef PRJ_EXSY
	GO_ADD := $(GO_ADD) -Wl,--exclude-symbols$(foreach s,$(PRJ_EXSY),,$(s))
endif

ifeq ($(BUILD),vs)

	GO_LIBS := $(GO_LIBS) $(CFG_STDLIBS)
	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_LIBS), $(CFG_LIB_PRE)$(lib)$(CFG_DPOSTFIX)$(CFG_LIB_POST))
	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_PLIB), $(CFG_LIB_PRE)$(lib)$(CFG_DPOSTFIX)$(CFG_LIB_POST))
	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_VSLB), $(CFG_LIB_PRE)$(lib)$(CFG_DPOSTFIX)$(CFG_LIB_POST))
	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_OSLB), $(CFG_LIB_PRE)$(lib)$(CFG_LIB_POST))
	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_WINL), $(CFG_LIB_PRE)$(lib)$(CFG_LIB_POST))
	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_WINX), $(lib))
	
	GO_LIBPATHS	:= $(GO_LIBPATHS) $(foreach lib,$(PRJ_WLBP),/LIBPATH:$(lib))
	GO_LIBPATHS	:= $(GO_LIBPATHS) $(foreach lib,$(PRJ_LIBP),/LIBPATH:$(lib))
	GO_LIBPATHS := $(GO_LIBPATHS) /LIBPATH:$(CFG_BINROOT)
	ifneq ($(CFG_BINROOT),$(CFG_OUTROOT))
		GO_LIBPATHS := $(GO_LIBPATHS) /LIBPATH:$(CFG_OUTROOT)
	endif
	GO_EXPORTS 	:= $(foreach exp,$(PRJ_EXPORTS), $(CFG_FLAG_EXPORT)$(exp))
	
else

	GO_LIBS	:= $(GO_LIBS) $(foreach lib,$(PRJ_LIBS), -l$(lib)$(CFG_DPOSTFIX))
	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_PLIB), -l$(lib)$(CFG_DPOSTFIX))
	GO_LIBS	:= $(GO_LIBS) $(foreach lib,$(PRJ_OSLB), -l$(lib))
	ifeq ($(PLATFORM),windows)
		GO_LIBS	:= $(GO_LIBS) $(foreach lib,$(PRJ_WINL), -l$(lib))
	else
		GO_LIBS	:= $(GO_LIBS) $(foreach lib,$(PRJ_POSL), -l$(lib))
	endif
	
	GO_LIBPATHS	:= $(GO_LIBPATHS) $(foreach lib,$(PRJ_PLBP),-L$(lib))
	GO_LIBPATHS	:= $(GO_LIBPATHS) $(foreach lib,$(PRJ_LIBP),-L$(lib))
	GO_LIBPATHS := $(GO_LIBPATHS) -L$(CFG_BINROOT)
	ifneq ($(CFG_BINROOT),$(CFG_OUTROOT))
		GO_LIBPATHS := $(GO_LIBPATHS) -L$(CFG_OUTROOT)
	endif
	
endif

ifeq ($(PRJ_TYPE),lib)
ifeq ($(BUILD),vs)	  
$(BLD_PATH_EXE): $(BLD_OBJECTS_TOTAL) $(BLD_DEPENDS_TOTAL)
	- $(CFG_DEL) $(subst /,\,$@)
	$(CFG_AR) $(CFG_AFLAGS) $(CFG_AR_OUT)$@ $(BLD_OBJECTS_TOTAL) $(GO_ADDF)
else
$(BLD_PATH_EXE): $(BLD_OBJECTS_TOTAL)
	- $(CFG_DEL) $@
	$(CFG_AR) $(CFG_AFLAGS) $(CFG_AR_OUT)$@ $(BLD_OBJECTS_TOTAL) $(GO_ADDF)
endif
else
ifeq ($(PRJ_TYPE),dll)

GO_DEPENDS 	:= $(GO_DEPENDS) $(foreach lib,$(PRJ_LIBS),$(CFG_BINROOT)/$(CFG_LIB_PRE)$(lib)$(CFG_DPOSTFIX)$(CFG_LIB_POST))

ifeq ($(BUILD),vs)	  
$(BLD_PATH_EXE): $(BLD_OBJECTS_TOTAL) $(GO_DEPENDS) $(BLD_DEPENDS_TOTAL)	
	- $(GO_DELSIGN)
	- $(CFG_DEL) $(subst /,\,$@)
	$(CFG_LD) $(CFG_LFLAGS) $(GO_EXPORTS) $(BLD_OBJECTS_TOTAL) $(CFG_LD_OUT)$@ $(GO_LIBPATHS) $(GO_LIBS) $(GO_ADD)
else
ifneq ($(PLATFORM),windows)
$(BLD_PATH_EXE): $(BLD_OBJECTS_TOTAL) $(GO_DEPENDS)	
	- $(CFG_DEL) $@
	$(CFG_LD) $(CFG_LFLAGS) $(BLD_OBJECTS_TOTAL) $(CFG_LD_OUT)$@ $(GO_LIBPATHS) $(GO_LIBS) $(CFG_STDLIB) $(GO_ADD)
else
$(BLD_PATH_EXE): $(BLD_OBJECTS_TOTAL) $(GO_DEPENDS)	
	- $(GO_DELSIGN)
	- $(CFG_DEL) $@
	$(CFG_LD) $(CFG_LFLAGS) $(BLD_OBJECTS_TOTAL) $(CFG_LD_OUT)$@ $(GO_LIBPATHS) $(GO_LIBS) $(CFG_STDLIB) $(GO_ADD)
endif
endif

else

GO_DEPENDS 	:= $(foreach lib,$(PRJ_LIBS),$(CFG_BINROOT)/$(CFG_LIB_PRE)$(lib)$(CFG_DPOSTFIX)$(CFG_LIB_POST))

#$(GO_DEPENDS):
#	$(MAKE) -C $(PRJ_LIBROOT)
	
ifeq ($(BUILD),vs)	
  
$(BLD_PATH_EXE): $(CFG_RES_OBJ) $(BLD_OBJECTS_TOTAL) $(GO_DEPENDS) $(BLD_DEPENDS_TOTAL)
	- $(GO_DELSIGN)
	- $(CFG_DEL) $(subst /,\,$@)
	$(CFG_LD) $(CFG_LFLAGS) $(GO_EXPORTS) $(BLD_OBJECTS_TOTAL) $(CFG_RES_OBJ) $(CFG_LD_OUT)$@ $(GO_LIBPATHS) $(GO_LIBS) $(GO_ADD)
	
else

$(BLD_PATH_EXE): $(CFG_RES_OBJ) $(BLD_OBJECTS_TOTAL) $(GO_DEPENDS)
	- $(CFG_DEL) $@
	$(CFG_LD) $(CFG_LFLAGS) $(PRJ_EXTL) $(BLD_OBJECTS_TOTAL) $(CFG_RES_OBJ) $(CFG_LD_OUT)$@ $(GO_LIBPATHS) $(GO_LIBS) $(CFG_STDLIB) $(GO_ADD)
	
endif	

endif

endif

# Code signing
ifdef PRJ_SIGN
ifdef PVKPASS
ifdef CFG_CODESIGN
GO_SIGN_OUT := $(CFG_OUTROOT)/_0_obj/$(PRJ_NAME)
GO_SIGN := $(GO_SIGN_OUT)/sign.log.txt
GO_FINAL := $(GO_SIGN)
GO_DELSIGN := $(CFG_DEL) $(GO_SIGN)
ifneq ($(strip $(EXISTS_MSPSDK)),)
do_sign: $(BLD_PATH_EXE)
	[ "Success" == "$(findstring Success,$(shell $(CFG_CODESIGN) sign /f $(CFG_ROOT)/$(PRJ_SIGN).pfx /p $(PVKPASS) /t $(CFG_SIGN_TIMESTAMP) /d "$(PRJ_DESC)" /du "$(PRJ_URL)" $(BLD_PATH_EXE)))" ]
	- @echo $(shell $(CFG_CODESIGN) verify /pa $(BLD_PATH_EXE))
$(GO_SIGN): do_sign
	- $(shell $(CFG_CODESIGN) verify /pa $(BLD_PATH_EXE) > $(GO_SIGN))
else
$(GO_SIGN): $(BLD_PATH_EXE)
	- $(CFG_CODESIGN) $(BLD_PATH_EXE) $(PRJ_NAME) $(CFG_ROOT)/$(PRJ_URL) $(PRJ_SIGN) $(CFG_SIGNROOT)
endif
endif
endif
endif

ifeq ($(GO_FINAL),)
GO_FINAL := $(BLD_PATH_EXE)
endif

all: cfg_init $(BLD_ALL) $(GO_FINAL)
rebuild: cfg_init $(BLD_REBUILD) $(GO_FINAL)
setup: cfg_init $(BLD_SETUP)
clean: cfg_init $(BLD_CLEAN)

endif

