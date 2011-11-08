
PRJ_INCS := $(PRJ_INCS) winglib/lib/oexlib
PRJ_LIBS := $(PRJ_LIBS) oexlib cximage jpeg png tiff zlib
PRJ_RESD := $(PRJ_RESD) qtwk
PRJ_CIIX := $(PRJ_CIIX);*.qtw

PRJ_DEFS := $(PRJ_DEFS) OEX_QTWK
PRJ_FWRK := $(PRJ_FWRK) Qt

ifneq ($(findstring windows,$(TGT)),)
	PRJ_OSLB := $(PRJ_OSLB) QtWebKit4 QtGui4 QtNetwork4 QtCore4
else
	PRJ_OSLB := $(PRJ_OSLB) QtWebKit QtGui QtNetwork QtCore
endif

