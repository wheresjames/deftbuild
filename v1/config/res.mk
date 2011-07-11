
ifdef PRJ_RESP
	CFG_RES_INP := $(foreach res,$(PRJ_RESD),$(PRJ_RESP)/$(res))
else
	CFG_RES_INP := $(foreach res,$(PRJ_RESD),$(res))
endif

CFG_RES_OUT := $(CFG_OUTROOT)/_0_res/$(PRJ_NAME)
CFG_RES_DEP := $(CFG_RES_OUT)/oexres.dpp
CFG_RES_INC := $(CFG_RES_OUT)/oexres.h
CFG_RES_MAK := $(CFG_RES_OUT)/oexres.mk

.PRECIOUS: $(CFG_RES_DEP)
$(CFG_RES_MAK):
	$(CFG_TOOL_RESCMP) -d:"$(CFG_RES_INP)" -o:"$(CFG_RES_OUT)" -c:"$(PRJ_SQEX)"

.PRECIOUS: $(CFG_RES_MAK)
include $(CFG_RES_MAK)
CFG_RES_OBJ := $(CFG_RES_OBJ) $(subst .cpp,.$(CFG_OBJ_EXT),$(RES_CPP))

.PRECIOUS: $(CFG_RES_DEP)
$(CFG_RES_DEP): $(CFG_RES_MAK) $(RES_CPP)
	$(CFG_TOOL_RESCMP) -d:"$(CFG_RES_INP)" -o:"$(CFG_RES_OUT)" -c:"$(PRJ_SQEX)"

include $(CFG_RES_DEP)

ifneq ($(BUILD),vs)
include $(wildcard $(CFG_RES_OUT)/*.$(CFG_DEP_EXT))
endif

#.PRECIOUS: $(CFG_RES_OUT)/%.cpp: $(RES_CPP)
$(CFG_RES_OUT)/%.cpp:
	$(CFG_TOOL_TOUCH) "$@"

.PRECIOUS: $(CFG_RES_OUT)/%.$(CFG_OBJ_EXT)
$(CFG_RES_OUT)/%.$(CFG_OBJ_EXT): $(CFG_RES_OUT)/%.cpp $(CFG_RES_DEP)
	$(CFG_PP) $(CFG_CFLAGS) $(CFG_INCS) $< $(CFG_CC_OUT)$@

CFG_RES_EOF := 1
