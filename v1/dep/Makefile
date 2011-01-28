
#SHELL=cmd.exe

# Total dependencies

makefiles   = $(wildcard *.mk)

.PHONY all: $(makefiles)
.PHONY rebuild: $(makefiles)
.PHONY clean: $(makefiles)

.PHONY $(makefiles) :
	$(MAKE) -j2 -f $@ $(BUILDTYPE)

