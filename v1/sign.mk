
# Code signing
ifdef PRJ_SIGN
ifdef PVKPASS
ifdef CFG_CODESIGNING

GO_SIGN_ENABLED := 1
GO_SIGN_OUT := $(CFG_OUTROOT)/_0_obj/$(PRJ_NAME)
GO_SIGN_TRACK := $(GO_SIGN_OUT)/sign.result

ifeq ($(PRJ_TYPE),apk)

# openssl pkcs12 -in mine.pfx -out mine.pem
# openssl pkcs12 -export -in mine.pem -out mine.ks -name "mine"

GO_SIGN := $(GO_SIGN_TRACK)-verified
GO_FINAL := $(GO_SIGN)
GO_DELSIGN := $(CFG_DEL) $(GO_SIGN)
$(GO_SIGN): $(BLD_PATH_EXE)
	$(CFG_JARSIGNER) -storetype pkcs12 -keypass $(PVKPASS) -storepass $(PVKPASS) -keystore $(CFG_ROOT)/$(PRJ_SIGN).ks $(BLD_PATH_EXE) $(PRJ_SIGNALIAS)
	$(CFG_JARSIGNER) -verify $(BLD_PATH_EXE) > $(GO_SIGN_TRACK)-$(findstring verified,`$(CFG_JARSIGNER) -verify $(BLD_PATH_EXE)`)

else

GO_SIGN := $(GO_SIGN_TRACK)-Success
GO_FINAL := $(GO_SIGN)
GO_DELSIGN := $(CFG_DEL) $(GO_SIGN)
GO_SIGN_EXE = $(CFG_CODESIGN) sign /f $(CFG_ROOT)/$(PRJ_SIGN).pfx /p "$(PVKPASS)" /t "$(CFG_SIGN_TIMESTAMP)" /d "$(2)" /du "$(PRJ_URL)" $(1)
GO_SIGN_VERIFY = $(CFG_CODESIGN) verify /pa $(1)
ifneq ($(strip $(EXISTS_MSPSDK)),)
$(GO_SIGN): $(BLD_PATH_EXE)
	$(call GO_SIGN_EXE,$(BLD_PATH_EXE),$(PRJ_DESC))	
	- @echo $(shell $(CFG_SIGNROOT)/$(CFG_CODESIGN) verify /pa $(BLD_PATH_EXE)) 2>&1 > $(GO_SIGN_TRACK)-$(findstring Success,$(shell $(CFG_SIGNROOT)/$(CFG_CODESIGN) verify /pa $(BLD_PATH_EXE)))
else
$(GO_SIGN): $(BLD_PATH_EXE)
	- $(CFG_CODESIGN) $(BLD_PATH_EXE) $(PRJ_NAME) $(CFG_ROOT)/$(PRJ_URL) $(PRJ_SIGN) $(CFG_SIGNROOT)	
endif

# apk
endif

# CFG_CODESIGNING
endif

# PVKPASS
endif

# PRJ_SIGN
endif
