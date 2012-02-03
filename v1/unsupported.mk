
# One shot
ifeq ($(ABORT_UNSUPPORTED),)

# exit 0 only works on Windows
ABORT_UNSUPPORTED := 1

# Save away first message as the probable root cause
ifeq ($(UNSUPPORTED_MSG),)
	UNSUPPORTED_MSG := $(UNSUPPORTED)
endif

# Echo the warning message
ifeq ($(NO_UNSUPPORTED_BARS),)
$(info .======================================================= )
$(info .= $(PRJ_NAME) : $(UNSUPPORTED) )
$(info .======================================================= )
else
$(info .= $(UNSUPPORTED) )
$(info .======================================================= )
endif

# On stderr as well
$(warning .= $(PRJ_NAME) : $(UNSUPPORTED) )

unsupported:
	exit 0

all: unsupported
rebuild: unsupported
setup: unsupported
clean: unsupported


endif
