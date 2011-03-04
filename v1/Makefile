
ifndef NODEPS
	BUILDDIRS := dep
endif

ifndef NOAPPS
	BUILDDIRS := $(BUILDDIRS) app
endif

ifndef NOINSTALL
	ifndef DBG
		BUILDDIRS := $(BUILDDIRS) ../install/sqrl
	endif
endif

#default_target: all
#PRJ_NAME := _v1_build_
#PRJ_LIBROOT := .
#include $(PRJ_LIBROOT)/config.mk

.PHONY all: $(BUILDDIRS)

.PHONY $(BUILDDIRS) :
	$(MAKE) -C $@ $(BUILDTYPE)

