
ifndef ABORT_UNSUPPORTED

# Create file name
ifndef BLD_FILE_EXE
	ifdef PRJ_FILE_EXE		 
		BLD_FILE := $(PRJ_FILE_EXE)
		BLD_FILE_EXE := $(PRJ_FILE_EXE)
	else
		ifeq ($(PRJ_TYPE),lib)
			BLD_FILE := $(CFG_LIB_PRE)$(PRJ_NAME)$(CFG_DPOSTFIX)
			BLD_FILE_EXE := $(BLD_FILE)$(CFG_LIB_POST)
		else
			ifeq ($(PRJ_TYPE),dll)
				BLD_FILE := $(CFG_DLL_PRE)$(PRJ_NAME)$(CFG_DPOSTFIX)
				BLD_FILE_EXE := $(BLD_FILE)$(CFG_DLL_POST)
			else
				ifeq ($(PRJ_TYPE),apk)
					BLD_FILE := $(CFG_DEX_PRE)$(PRJ_NAME)$(CFG_DPOSTFIX)
					BLD_FILE_EXE := $(BLD_FILE).$(CFG_APK_POST)
				else
					BLD_FILE := $(CFG_EXE_PRE)$(PRJ_NAME)$(CFG_DPOSTFIX)
					BLD_FILE_EXE := $(BLD_FILE)$(CFG_EXE_POST)
				endif
			endif
		endif
	endif
	BLD_PATH_FILE := $(CFG_OUTROOT)/$(BLD_FILE)
	BLD_PATH_EXE := $(CFG_OUTROOT)/$(BLD_FILE_EXE)
endif

# Windows Version Resource
include $(PRJ_LIBROOT)/go/ver.mk

# Squirrel build
include $(PRJ_LIBROOT)/go/sqrl.mk

ifdef PRJ_EXSY
	GO_ADD := $(GO_ADD) -Wl,--exclude-symbols$(foreach s,$(PRJ_EXSY),,$(s))
endif

ifeq ($(BUILD),vs)

	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_PLIB), $(CFG_LIB_PRE)$(lib)$(CFG_DPOSTFIX)$(CFG_LIB_POST))
	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_VSLB), $(CFG_LIB_PRE)$(lib)$(CFG_DPOSTFIX)$(CFG_LIB_POST))
	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_OSLB), $(CFG_LIB_PRE)$(lib)$(CFG_LIB_POST))
	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_WINL), $(CFG_LIB_PRE)$(lib)$(CFG_LIB_POST))
	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_WINX), $(lib))
	GO_LIBS := $(GO_LIBS) $(CFG_STDLIBS)
	GO_LIBS := $(GO_LIBS) $(foreach lib,$(PRJ_LIBS), $(CFG_LIB_PRE)$(lib)$(CFG_DPOSTFIX)$(CFG_LIB_POST))

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
$(BLD_PATH_EXE): $(BLD_DEPENDS_TOTAL) $(BLD_OBJECTS_TOTAL) $(BLD_DEPENDS_TOTAL)
	- $(CFG_DEL) $(subst \,/,$@)
	$(CFG_AR) $(CFG_AFLAGS) $(CFG_AR_OUT)$@ $(BLD_OBJECTS_TOTAL) $(GO_ADDF)
else
$(BLD_PATH_EXE): $(BLD_DEPENDS_TOTAL) $(BLD_OBJECTS_TOTAL)
	- $(CFG_DEL) $@
	$(CFG_AR) $(CFG_AFLAGS) $(CFG_AR_OUT)$@ $(BLD_OBJECTS_TOTAL) $(GO_ADDF)
endif

# lib
else

ifeq ($(PRJ_TYPE),dll)

GO_DEPENDS 	:= $(GO_DEPENDS) $(foreach lib,$(PRJ_LIBS),$(CFG_BINROOT)/$(CFG_LIB_PRE)$(lib)$(CFG_DPOSTFIX)$(CFG_LIB_POST))

ifeq ($(BUILD),vs)	  
$(BLD_PATH_EXE): $(BLD_DEPENDS_TOTAL) $(BLD_OBJECTS_TOTAL) $(GO_DEPENDS) $(BLD_DEPENDS_TOTAL)	
	- $(GO_DELSIGN)
	- $(CFG_DEL) $(subst \,/,$@)
	$(CFG_LD) $(CFG_LFLAGS) $(GO_EXPORTS) $(BLD_OBJECTS_TOTAL) $(CFG_LD_OUT)$@ $(GO_LIBPATHS) $(GO_LIBS) $(GO_ADD)
else
ifneq ($(PLATFORM),windows)
$(BLD_PATH_EXE): $(BLD_DEPENDS_TOTAL) $(BLD_OBJECTS_TOTAL) $(GO_DEPENDS)	
	- $(CFG_DEL) $@
	$(CFG_LD) $(CFG_LFLAGS) $(BLD_OBJECTS_TOTAL) $(CFG_LD_OUT)$@ $(GO_LIBPATHS) $(GO_LIBS) $(CFG_STDLIB) $(GO_ADD)
else
$(BLD_PATH_EXE): $(BLD_DEPENDS_TOTAL) $(BLD_OBJECTS_TOTAL) $(GO_DEPENDS)	
	- $(GO_DELSIGN)
	- $(CFG_DEL) $@
	$(CFG_LD) $(CFG_LFLAGS) $(BLD_OBJECTS_TOTAL) $(CFG_LD_OUT)$@ $(GO_LIBPATHS) $(GO_LIBS) $(CFG_STDLIB) $(GO_ADD)
endif
endif

# dll
else

GO_DEPENDS 	:= $(foreach lib,$(PRJ_LIBS),$(CFG_BINROOT)/$(CFG_LIB_PRE)$(lib)$(CFG_DPOSTFIX)$(CFG_LIB_POST))

#$(GO_DEPENDS):
#	$(MAKE) -C $(PRJ_LIBROOT)
	
ifeq ($(BUILD),vs)	
  
$(BLD_PATH_EXE): $(CFG_RES_OBJ) $(BLD_DEPENDS_TOTAL) $(BLD_OBJECTS_TOTAL) $(GO_DEPENDS) $(BLD_DEPENDS_TOTAL)
	- $(GO_DELSIGN)
	- $(CFG_DEL) $(subst \,/,$@)
	$(CFG_LD) $(CFG_LFLAGS) $(GO_EXPORTS) $(BLD_OBJECTS_TOTAL) $(CFG_RES_OBJ) $(CFG_LD_OUT)$@ $(GO_LIBPATHS) $(GO_LIBS) $(GO_ADD)
	
else

$(BLD_PATH_EXE): $(CFG_RES_OBJ) $(BLD_OBJECTS_TOTAL) $(GO_DEPENDS)
	- $(CFG_DEL) $@
	$(CFG_LD) $(CFG_LFLAGS) $(PRJ_EXTL) $(BLD_OBJECTS_TOTAL) $(CFG_RES_OBJ) $(CFG_LD_OUT)$@ $(GO_LIBPATHS) $(GO_LIBS) $(CFG_STDLIB) $(GO_ADD)
	
endif	

# dll
endif

# lib
endif

# dependency chain
GO_FINAL := $(BLD_PATH_EXE)

#packaging
include $(PRJ_LIBROOT)/go/pkg.mk

# signing
include $(PRJ_LIBROOT)/go/sign.mk

#ifeq ($(GO_FINAL),)
#GO_FINAL := $(BLD_PATH_EXE)
#endif

ifneq ($(findstring $(PRJ_NAME),$(PLATRUN)),)
#ifneq ($(findstring $(OS),$(PRJ_PLAT)),)
ifeq ($(OS),android)
ifeq ($(PLATRUN_0),)
	PLATRUN_0 := /data/tmp
endif
ifneq ($(PRJ_PACK),apk)
.PHONY : android
android: $(GO_FINAL)
	adb push $(BLD_PATH_EXE) $(PLATRUN_0)/$(BLD_FILE_EXE)
	adb shell chmod 0755 $(PLATRUN_0)/$(BLD_FILE_EXE)
else
android: $(GO_FINAL)
	adb uninstall
endif
GO_FINAL := android
endif
#endif
endif

.PHONY : all rebuild setup clean
all: cfg_init $(BLD_ALL) $(GO_FINAL)
rebuild: cfg_init $(BLD_REBUILD) $(GO_FINAL)
setup: cfg_init $(BLD_SETUP)
clean: cfg_init $(BLD_CLEAN)

endif

