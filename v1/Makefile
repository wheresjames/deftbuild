
BUILDDIRS := dep

ifndef NOAPPS
	BUILDDIRS := $(BUILDDIRS) app
endif

ifndef NOINSTALL
	ifndef DBG
		BUILDDIRS := $(BUILDDIRS) ../install/sqrl
	endif
endif

.PHONY all: $(BUILDDIRS)

.PHONY $(BUILDDIRS) :
	$(MAKE) -C $@ $(BUILDTYPE)

