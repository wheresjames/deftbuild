
# Code signing
ifdef PRJ_SIGN
ifdef PVKPASS
ifdef CFG_CODESIGN
GO_SIGN_ENABLED := 1
GO_SIGN_OUT := $(CFG_OUTROOT)/_0_obj/$(PRJ_NAME)
GO_SIGN_TRACK := $(GO_SIGN_OUT)/sign.result
#GO_SIGN_EXE = [ "Success" == "$(findstring Success,$(shell $(CFG_CODESIGN) sign /f $(CFG_ROOT)/$(PRJ_SIGN).pfx /p $(PVKPASS) /t $(CFG_SIGN_TIMESTAMP) /d "$(2)" /du "$(PRJ_URL)" $(1)))" ]
#GO_SIGN_EXE = $(findstring Success,$(shell $(CFG_CODESIGN) sign /f $(CFG_ROOT)/$(PRJ_SIGN).pfx /p $(PVKPASS) /t $(CFG_SIGN_TIMESTAMP) /d "$(2)" /du "$(PRJ_URL)" $(1)))
GO_SIGN_EXE = $(CFG_CODESIGN) sign /f $(CFG_ROOT)/$(PRJ_SIGN).pfx /p "$(PVKPASS)" /t "$(CFG_SIGN_TIMESTAMP)" /d "$(2)" /du "$(PRJ_URL)" $(1)
GO_SIGN_VERIFY = $(CFG_CODESIGN) verify /pa $(1)
GO_SIGN := $(GO_SIGN_TRACK)-Success
GO_FINAL := $(GO_SIGN)
GO_DELSIGN := $(CFG_DEL) $(GO_SIGN)
ifneq ($(strip $(EXISTS_MSPSDK)),)
#.PHONY : do_sign
#do_sign: $(BLD_PATH_EXE)
#	[ "Success" == "$(findstring Success,$(shell $(CFG_CODESIGN) sign /f $(CFG_ROOT)/$(PRJ_SIGN).pfx /p $(PVKPASS) /t $(CFG_SIGN_TIMESTAMP) /d "$(PRJ_DESC)" /du "$(PRJ_URL)" $(BLD_PATH_EXE)))" ]
$(GO_SIGN): $(BLD_PATH_EXE)
	$(call GO_SIGN_EXE,$(BLD_PATH_EXE),$(PRJ_DESC))	
	- @echo Signing $(BLD_PATH_EXE) > $(GO_SIGN_TRACK)-$(findstring Success,$(shell $(CFG_SIGNROOT)/$(CFG_CODESIGN) verify /pa $(BLD_PATH_EXE)))
else
$(GO_SIGN): $(BLD_PATH_EXE)
	- $(CFG_CODESIGN) $(BLD_PATH_EXE) $(PRJ_NAME) $(CFG_ROOT)/$(PRJ_URL) $(PRJ_SIGN) $(CFG_SIGNROOT)
endif
endif
endif
endif

