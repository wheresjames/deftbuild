
ifdef PRJ_SQRL
	ifeq ($(PRJ_SQRL),service)
		export LOC_TAG := sqs
		LOC_SRC_sqs := $(CFG_LIBROOT)/winglib/tools/sqservice
		include $(PRJ_LIBROOT)/build.mk	
	else
		export LOC_TAG := sq
		LOC_SRC_sq := $(CFG_LIBROOT)/winglib/tools/sqembed
		include $(PRJ_LIBROOT)/build.mk	
	endif
endif
