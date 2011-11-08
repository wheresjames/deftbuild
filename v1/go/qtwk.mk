
ifdef PRJ_QTWK

	export LOC_TAG := _qtwk
	LOC_SRC__qtwk := $(CFG_LIBROOT)/winglib/tools/qtwk
	include $(PRJ_LIBROOT)/build.mk	

	export LOC_TAG := _qtwk_moc
	LOC_BLD__qtwk_moc := moc
	LOC_LST__qtwk_moc := mainwindow network
	LOC_SRC__qtwk_moc := $(CFG_LIBROOT)/winglib/tools/qtwk
	include $(PRJ_LIBROOT)/build.mk	

endif
