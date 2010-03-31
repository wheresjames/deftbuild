
ifeq ($(ABORT_UNSUPPORTED),)

# exit 0 only works on Windows
ABORT_UNSUPPORTED := 1

unsupported:
	@echo =======================================================
	@echo = !!! $(UNSUPPORTED)
	@echo =======================================================
	$(warning $(UNSUPPORTED) )
	exit 0

all: unsupported
rebuild: unsupported
setup: unsupported
clean: unsupported

endif
