default_dep: all
EOD=

.PHONY : init showdbg all

#-------------------------------------------------------------------
# Init
#-------------------------------------------------------------------

# Required
CFG_REQUIRE := init
init:
	$(DBGOUT) CFG00: $@	
EOD=


#-------------------------------------------------------------------
# Extensions
#-------------------------------------------------------------------
	
CFG_EXT_REP := repo
CFG_EXT_OBJ := obj
CFG_EXT_PAT := patch
CFG_EXT_DIF := diff

# Default input extension
CFG_EXT_CXX := cpp


#-------------------------------------------------------------------
# Paths
#-------------------------------------------------------------------

# Current directory
CFG_DIR_CUR := $(subst \,/,$(shell pwd))
CFG_DIR_RDB := $(CFG_DIR_CUR)

CFG_DIR_ROOT := $(CFG_DIR_RDB)/..

# Input paths

CFG_DIR_PRJD := $(CFG_DIR_RDB)/oss
CFG_DIR_LBIN := $(CFG_DIR_RDB)/bin
CFG_DIR_MAKE := $(CFG_DIR_RDB)/mk

# Output paths

CFG_DIR_IDX := 4
CFG_DIR_LIB := $(CFG_DIR_ROOT)/lib$(CFG_DIR_IDX)
CFG_DIR_BIN := $(CFG_DIR_ROOT)/bin$(CFG_DIR_IDX)
CFG_DIR_DNL := $(CFG_DIR_ROOT)/dnl$(CFG_DIR_IDX)
CFG_DIR_UPL := $(CFG_DIR_ROOT)/upl$(CFG_DIR_IDX)
CFG_DIR_ARC := $(CFG_DIR_ROOT)/arc$(CFG_DIR_IDX)
CFG_DIR_DIF := $(CFG_DIR_ROOT)/dif$(CFG_DIR_IDX)

CFG_DIR_OBJ := $(CFG_DIR_BIN)/_0_obj
CFG_DIR_RES := $(CFG_DIR_BIN)/_0_res


#-------------------------------------------------------------------
# Config
#-------------------------------------------------------------------
include $(CFG_DIR_MAKE)/win/config-win.mk


#-------------------------------------------------------------------
# Debug
#-------------------------------------------------------------------

# Debug output
DBGOUT:=@echo ---
#DBGOUT:=@set __DBGOUT

showdbg:
	$(DBGOUT) DBGSTR: $(DBGSTR)
EOD=		

