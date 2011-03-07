# build.mk

ifndef ABORT_UNSUPPORTED

ifneq ($(PRJ_DEFS),)
	ifeq ($(BUILD),vs)
		CFG_ADD_DEFS := $(foreach def,$(PRJ_DEFS),/D$(def) )
	else
		CFG_ADD_DEFS := $(foreach def,$(PRJ_DEFS),-D$(def) )
	endif	
	CFG_DEFS := $(CFG_DEFS) $(CFG_ADD_DEFS)
	PRJ_DEFS :=
endif

ifeq ($(LOC_CXX_$(LOC_TAG)),)
	LOC_CXX_$(LOC_TAG) := cpp
endif

ifeq ($(LOC_H_$(LOC_TAG)),)
	LOC_H_$(LOC_TAG) := h
endif

ifeq ($(LOC_BLD_$(LOC_TAG)),)
	LOC_BLD_$(LOC_TAG) := $(LOC_CXX_$(LOC_TAG))
else
	ifeq ($(LOC_BLD_$(LOC_TAG)),c)
		BLD_MSFLAGS := /Tc
	else
		ifeq ($(LOC_BLD_$(LOC_TAG)),cpp)
			BLD_MSFLAGS := /Tp
		endif
	endif
endif

BLD_EXT_$(LOC_TAG) := $(CFG_OBJ_EXT)
ifeq ($(LOC_BLD_$(LOC_TAG)),c)
	BLD_COMPILER_$(LOC_TAG) := $(CFG_CC)
else
	ifeq ($(LOC_BLD_$(LOC_TAG)),rc)
		BLD_COMPILER_$(LOC_TAG) := $(CFG_RC)
		BLD_EXT_$(LOC_TAG) := $(CFG_RES_EXT)
	else	
		ifeq ($(LOC_BLD_$(LOC_TAG)),as)
			BLD_COMPILER_$(LOC_TAG) := $(CFG_AS)
		else
			ifeq ($(LOC_BLD_$(LOC_TAG)),asm)
				ifeq ($(LOC_ASM_$(LOC_TAG)),)
					BLD_ASM := $(CFG_ASM)
				else
					BLD_ASM := $(LOC_ASM_$(LOC_TAG))
				endif
			else
				BLD_COMPILER_$(LOC_TAG) := $(CFG_PP)
			endif
		endif
	endif
endif

# Using full paths helps IDE editors to locate the file when there's an error ;)
ifneq ($(LOC_SRC_$(LOC_TAG)),)
#ifeq ($(CYGBLD),)
#BLD_PATH_SRC_$(LOC_TAG) := $(CFG_CUR_ROOT)/$(LOC_SRC_$(LOC_TAG))
#else
BLD_PATH_SRC_$(LOC_TAG) := $(LOC_SRC_$(LOC_TAG))
#endif
ifneq ($(LOC_SRC_$(LOC_TAG)),$(LOC_INC_$(LOC_TAG)))
	ifeq ($(BUILD),vs)
		BLD_PATH_INC_$(LOC_TAG) := $(CFG_CC_INC)"$(CFG_CUR_ROOT)/$(LOC_SRC_$(LOC_TAG))"
	else
		BLD_PATH_INC_$(LOC_TAG) := $(CFG_CC_INC)$(CFG_CUR_ROOT)/$(LOC_SRC_$(LOC_TAG))
	endif
endif
else
	ifeq ($(CYGBLD),)
		BLD_PATH_SRC_$(LOC_TAG) := $(CFG_CUR_ROOT)
	else
		BLD_PATH_SRC_$(LOC_TAG) := .
	endif
endif

ifneq ($(LOC_INC_$(LOC_TAG)),)
	ifeq ($(BUILD),vs)
		BLD_PATH_INC_$(LOC_TAG) := $(BLD_PATH_INC_$(LOC_TAG)) $(CFG_CC_INC)"$(CFG_CUR_ROOT)/$(LOC_INC_$(LOC_TAG))"
	else
		BLD_PATH_INC_$(LOC_TAG) := $(BLD_PATH_INC_$(LOC_TAG)) $(CFG_CC_INC)$(CFG_CUR_ROOT)/$(LOC_INC_$(LOC_TAG))
	endif
else
ifeq ($(LOC_SRC_$(LOC_TAG)),)
	ifeq ($(BUILD),vs)
		BLD_PATH_INC_$(LOC_TAG) := $(BLD_PATH_INC_$(LOC_TAG)) $(CFG_CC_INC)"$(CFG_CUR_ROOT)"
	else
		BLD_PATH_INC_$(LOC_TAG) := $(BLD_PATH_INC_$(LOC_TAG)) $(CFG_CC_INC)$(CFG_CUR_ROOT)
	endif
endif
endif

ifdef PRJ_OBJROOT
BLD_PATH_BIN_$(LOC_TAG) := $(CFG_OUTROOT)/$(PRJ_OBJROOT)/$(PRJ_NAME)/$(LOC_TAG)
else
BLD_PATH_BIN_$(LOC_TAG) := $(CFG_OUTROOT)/_0_obj/$(PRJ_NAME)/$(LOC_TAG)
endif

BLD_PATH_OBJ_$(LOC_TAG) := $(BLD_PATH_BIN_$(LOC_TAG))
BLD_PATH_INS_$(LOC_TAG) := /usr/share/$(PRJ_NAME)
BLD_PATH_LNK_$(LOC_TAG) := /usr/bin

#-------------------------------------------------------------------
# Sources
#-------------------------------------------------------------------
ifneq ($(LOC_LST_$(LOC_TAG)),)
	BLD_SOURCES_$(LOC_TAG) 	:= $(foreach file,$(LOC_LST_$(LOC_TAG)),$(BLD_PATH_SRC_$(LOC_TAG))/$(file).$(LOC_CXX_$(LOC_TAG)))
else
	BLD_SOURCES_$(LOC_TAG) 	:= $(wildcard $(BLD_PATH_SRC_$(LOC_TAG))/*.$(LOC_CXX_$(LOC_TAG)))
endif

ifneq ($(LOC_EXC_$(LOC_TAG)),)
	BLD_EXCLUDE_$(LOC_TAG) 	:= $(foreach file,$(LOC_EXC_$(LOC_TAG)),$(BLD_PATH_SRC_$(LOC_TAG))/$(file).$(LOC_CXX_$(LOC_TAG)))
	BLD_SOURCES_$(LOC_TAG) 	:= $(filter-out $(BLD_EXCLUDE_$(LOC_TAG)),$(BLD_SOURCES_$(LOC_TAG)))
endif

BLD_OBJECTS_$(LOC_TAG) 	:= $(subst $(BLD_PATH_SRC_$(LOC_TAG))/,$(BLD_PATH_OBJ_$(LOC_TAG))/, $(BLD_SOURCES_$(LOC_TAG):.$(LOC_CXX_$(LOC_TAG))=.$(BLD_EXT_$(LOC_TAG))) )
BLD_INCS			    := $(BLD_PATH_INC_$(LOC_TAG)) $(foreach inc,$(PRJ_INCS), $(CFG_CC_INC)$(CFG_LIBROOT)/$(inc))
ifneq ($(PRJ_SYSI),)
	ifeq ($(BUILD),vs)
		BLD_INCS		    := $(BLD_PATH_INC_$(LOC_TAG)) $(foreach inc,$(PRJ_INCS), $(CFG_CC_INC)"$(CFG_LIBROOT)/$(inc)")
		BLD_INCS			:= $(BLD_INCS) $(foreach inc,$(PRJ_SYSI), $(CFG_CC_INC)"$(inc)")
	else
		BLD_INCS		    := $(BLD_PATH_INC_$(LOC_TAG)) $(foreach inc,$(PRJ_INCS), $(CFG_CC_INC)$(CFG_LIBROOT)/$(inc))
		BLD_INCS			:= $(BLD_INCS) $(foreach inc,$(PRJ_SYSI), $(CFG_CC_INC)$(inc))
	endif
endif
ifdef CFG_RES_OUT
	BLD_INCS			:= $(CFG_CC_INC)$(CFG_RES_OUT) $(BLD_INCS)
endif

BLD_OBJECTS_TOTAL 		:= $(BLD_OBJECTS_TOTAL) $(BLD_OBJECTS_$(LOC_TAG))
#BLD_DEPENDS_$(LOC_TAG) := $(subst $(BLD_PATH_SRC_$(LOC_TAG))/,$(BLD_PATH_OBJ_$(LOC_TAG))/, $(BLD_SOURCES_$(LOC_TAG):.$(LOC_CXX_$(LOC_TAG))=.$(CFG_DEP_EXT)) )
#BLD_DEPENDS_INCS		:= -I$(BLD_PATH_INC_$(LOC_TAG)) $(foreach inc,$(PRJ_INCS), -I$(CFG_LIBROOT)/$(inc))
#BLD_DEPENDS_TOTAL 		:= $(BLD_DEPENDS_TOTAL) $(BLD_DEPENDS_$(LOC_TAG))


ifneq ($(BUILD),vs)
	include $(wildcard $(BLD_PATH_OBJ_$(LOC_TAG))/*.$(CFG_DEP_EXT))
endif

#-------------------------------------------------------------------
# Options
#-------------------------------------------------------------------

all_$(LOC_TAG): setup_$(LOC_TAG)

rebuild_$(LOC_TAG): clean_$(LOC_TAG) all_$(LOC_TAG)

setup_$(LOC_TAG): $(BLD_PATH_OBJ_$(LOC_TAG))

ifeq ($(BUILD),vs)

$(BLD_PATH_OBJ_$(LOC_TAG)):
	$(shell $(CFG_MD) "$(subst /,\,$@)")
	
clean_$(LOC_TAG):
	- $(CFG_RM) "$(subst /,\,$(BLD_PATH_OBJ_$(LOC_TAG)))"
	
else

$(BLD_PATH_OBJ_$(LOC_TAG)):
	$(CFG_MD) $@
	
clean_$(LOC_TAG):
	- $(CFG_RM) $(BLD_PATH_OBJ_$(LOC_TAG))

endif

BLD_ALL 	:= $(BLD_ALL) all_$(LOC_TAG)
BLD_REBUILD := $(BLD_REBUID) rebuild_$(LOC_TAG)
BLD_SETUP 	:= $(BLD_SETUP) setup_$(LOC_TAG)
BLD_CLEAN 	:= $(BLD_CLEAN) clean_$(LOC_TAG)

#-------------------------------------------------------------------
# Build
#-------------------------------------------------------------------

$(print BLD_OBJECTS_$(LOC_TAG) )
$(print $(BLD_PATH_OBJ_$(LOC_TAG))/%.$(CFG_OBJ_EXT) )

ifeq ($(BUILD),vs)

#$(subst $(BLD_PATH_SRC_$(LOC_TAG))/,,$<)
#$(BLD_PATH_OBJ_$(LOC_TAG))/%.$(CFG_DEP_EXT) : $(BLD_PATH_SRC_$(LOC_TAG))/%.$(LOC_CXX_$(LOC_TAG))
#	echo # makedepend -o.obj $(subst /,\,$(BLD_DEPENDS_INCS)) -p$(BLD_PATH_OBJ_$(LOC_TAG))/ -f$@ $< >> $@
#	$(CFG_DP) -o.obj $(subst /,\,$(BLD_DEPENDS_INCS)) -f$@ $<
# - $(CFG_DEL) $(subst /,\,$@)

ifeq ($(LOC_BLD_$(LOC_TAG)),rc)

$(BLD_PATH_OBJ_$(LOC_TAG))/%.$(CFG_RES_EXT) : $(BLD_PATH_SRC_$(LOC_TAG))/%.$(LOC_CXX_$(LOC_TAG))
	$(CFG_RC) $(BLD_INCS) /fo $@ $<

else

$(BLD_PATH_OBJ_$(LOC_TAG))/%.$(CFG_OBJ_EXT) : $(BLD_PATH_SRC_$(LOC_TAG))/%.$(LOC_CXX_$(LOC_TAG))
	$(CFG_PP) $(CFG_CFLAGS) $(CFG_DEFS) $(BLD_INCS) $(BLD_MSFLAGS) "$<" $(CFG_CC_OUT)"$@"

endif

else

ifeq ($(LOC_BLD_$(LOC_TAG)),asm)

ifeq ($(PLATFORM),windows)

$(BLD_PATH_OBJ_$(LOC_TAG))/%.$(CFG_OBJ_EXT) : $(BLD_PATH_SRC_$(LOC_TAG))/%.$(LOC_CXX_$(LOC_TAG))
	$(BLD_ASM) $(CFG_ASMFLAGS) $(CFG_DEFS) $(PRJ_EXTC) $(BLD_INCS) $< $(CFG_CC_OUT)$@

# - $(CFG_DEL) $@
#yasm -f win32 -a x86 -DPREFIX $(CFG_ASMFLAGS) $(CFG_DEFS) $(PRJ_EXTC) $(BLD_INCS) $< $(CFG_CC_OUT)$@
	
else

$(BLD_PATH_OBJ_$(LOC_TAG))/%.$(CFG_OBJ_EXT) : $(BLD_PATH_SRC_$(LOC_TAG))/%.$(LOC_CXX_$(LOC_TAG))
	$(BLD_ASM) $(CFG_ASMFLAGS) $(CFG_DEFS) $(PRJ_EXTC) $(BLD_INCS) $< $(CFG_CC_OUT)$@

# - $(CFG_DEL) $@
#yasm -f elf32 -a x86 $(CFG_ASMFLAGS) $(CFG_DEFS) $(PRJ_EXTC) $(BLD_INCS) $< $(CFG_CC_OUT)$@	
	
endif

# +++ WTF ??? Why doesn't this work ??? $(LOC_ASM_$(LOC_TAG)) is ALWAYS EMPTY!!!
#	$(LOC_ASM_$(LOC_TAG)) $(CFG_ASMFLAGS) $(CFG_DEFS) $(PRJ_EXTC) $(BLD_INCS) $< $(CFG_CC_OUT)$@

else

ifeq ($(LOC_BLD_$(LOC_TAG)),as)

$(BLD_PATH_OBJ_$(LOC_TAG))/%.$(CFG_OBJ_EXT) : $(BLD_PATH_SRC_$(LOC_TAG))/%.$(LOC_CXX_$(LOC_TAG))
	$(CFG_AS) $(CFG_ASFLAGS) $(PRJ_EXTC) $(BLD_INCS) $< $(CFG_CC_OUT)$@

else

$(BLD_PATH_OBJ_$(LOC_TAG))/%.$(CFG_OBJ_EXT) : $(BLD_PATH_SRC_$(LOC_TAG))/%.$(LOC_CXX_$(LOC_TAG))
	$(BLD_COMPILER_$(LOC_TAG)) $(CFG_CFLAGS) $(CFG_DEFS) $(PRJ_EXTC) $(BLD_INCS) $< $(CFG_CC_OUT)$@
endif

endif

endif

endif

