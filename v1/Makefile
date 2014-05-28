
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

ifeq ($(VER),)
	VER := $(shell date +'%y.%m.%d.%H%M')
endif

.PHONY all: $(BUILDDIRS)

.PHONY $(BUILDDIRS) :
	$(MAKE) -C $@ VER=$(VER) $(BUILDTYPE)

