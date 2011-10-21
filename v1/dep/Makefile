
# Total dependencies

makefiles = $(wildcard *.mk)

.PHONY all: $(makefiles)
.PHONY rebuild: $(makefiles)
.PHONY clean: $(makefiles)

ifeq ($(NOMULTI),)
ifeq ($(NUMJOBS),)
ifdef NUMBER_OF_PROCESSORS
NUMJOBS := -j$(NUMBER_OF_PROCESSORS)
else
ifneq ($(NPROC),)
NUMJOBS := -j$(NPROC)
else
NUMJOBS := -j2
endif
endif
endif
endif

.PHONY $(makefiles) :
	$(MAKE) $(NUMJOBS) -f $@ $(BUILDTYPE)
