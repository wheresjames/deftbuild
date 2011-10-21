
ifdef CFG_JARSIGNING
	GO_SIGN_EXISTS := 1
endif
ifdef CFG_CODESIGNING
	GO_SIGN_EXISTS := 1
endif

# Code signing
ifdef PRJ_SIGN
ifdef PVKPASS
ifdef GO_SIGN_EXISTS

GO_SIGN_ENABLED := 1
GO_SIGN_OUT := $(CFG_OUTROOT)/_0_obj/$(PRJ_NAME)
GO_SIGN_TRACK := $(GO_SIGN_OUT)/sign.result

ifeq ($(PRJ_PACK),apk)

# Self signed help ;)
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ss.pem -out ss.pem
# openssl pkcs12 -export -out ss.pfx -in ss.pem -name “ss”
# openssl pkcs12 -in ss.pfx -out ss.pem
# openssl pkcs12 -export -in ss.pem -out ss.ks -name "ss"
GO_SIGN_FILE := $(CFG_CUR_ROOT)/$(GO_FINAL)
GO_SIGN := $(GO_SIGN_TRACK)-verified
GO_DELSIGN := $(CFG_DEL) $(GO_SIGN)
$(GO_SIGN): $(GO_FINAL)
	$(CFG_JARSIGNER) -storetype pkcs12 -keypass $(PVKPASS) -storepass $(PVKPASS) -keystore $(CFG_ROOT)/$(PRJ_SIGN).ks $(GO_SIGN_FILE) $(PRJ_SIGNALIAS)
	$(CFG_JARSIGNER) -verify $(GO_SIGN_FILE) > $(GO_SIGN_TRACK)-$(findstring verified,`$(CFG_JARSIGNER) -verify $(GO_SIGN_FILE)`)

else

GO_SIGN_FILE := $(GO_FINAL)
GO_SIGN := $(GO_SIGN_TRACK)-Success
GO_DELSIGN := $(CFG_DEL) $(GO_SIGN)
GO_SIGN_EXE = $(CFG_CODESIGN) sign /f $(CFG_ROOT)/$(PRJ_SIGN).pfx /p "$(PVKPASS)" /t "$(CFG_SIGN_TIMESTAMP)" /d "$(2)" /du "$(PRJ_URL)" $(1)
GO_SIGN_VERIFY = $(CFG_CODESIGN) verify /pa $(1)
ifneq ($(strip $(EXISTS_MSPSDK)),)
$(GO_SIGN): $(GO_FINAL)
	$(call GO_SIGN_EXE,$(GO_SIGN_FILE),$(PRJ_DESC))	
	- @echo $(shell $(CFG_SIGNROOT)/$(CFG_CODESIGN) verify /pa $(GO_SIGN_FILE)) 2>&1 > $(GO_SIGN_TRACK)-$(findstring Success,$(shell $(CFG_SIGNROOT)/$(CFG_CODESIGN) verify /pa $(GO_SIGN_FILE)))
else
$(GO_SIGN): $(GO_FINAL)
	- $(CFG_CODESIGN) $(GO_SIGN_FILE) $(PRJ_NAME) $(CFG_ROOT)/$(PRJ_URL) $(PRJ_SIGN) $(CFG_SIGNROOT)	
endif

# apk
endif

GO_FINAL := $(GO_SIGN)

# CFG_CODESIGNING
endif

# PVKPASS
endif

# PRJ_SIGN
endif
