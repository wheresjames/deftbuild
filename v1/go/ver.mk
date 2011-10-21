
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

CFG_VER_OUT := $(CFG_OBJROOT)
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
