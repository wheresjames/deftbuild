
#-------------------------------------------------------------------
# Configure
#-------------------------------------------------------------------
include config.mk

#-------------------------------------------------------------------
# Ensure directories
#-------------------------------------------------------------------

CFG_REQUIRE := $(CFG_REQUIRE) $(CFG_DIR_LIB)
$(CFG_DIR_LIB):
	$(DBGOUT) CFG01: $@
	$(CFG_MD) $(subst \,/,$@)	
EOD=


#-------------------------------------------------------------------
# Build list of projects
#-------------------------------------------------------------------

# List of all repo files we want
CFG_REPOS := $(foreach g, $(GRP), $(wildcard $(CFG_DIR_PRJD)/$(g)/*.$(CFG_EXT_REP)) )

# List of project stubs - <grp>/<repo>
CFG_PRJS := $(subst $(CFG_DIR_PRJD)/, , $(CFG_REPOS:.$(CFG_EXT_REP)=) )

# Source repo
CFG_PRJREP := $(foreach p, $(CFG_PRJS), $(CFG_DIR_PRJD)/$(p).$(CFG_EXT_REP) )

# Library dirs
CFG_PRJLIB := $(foreach g, $(GRP), $(subst $(g)/, $(CFG_DIR_LIB)/, $(filter $(g)/%, $(CFG_PRJS) ) ) )

CFG_PRJREQ := $(foreach r, $(CFG_PRJS), _prj_repo/$(r) )

# Add libraries to requirements
CFG_REQUIRE := $(CFG_REQUIRE) $(CFG_PRJREQ)

#DBGSTR := $(CFG_PRJREQ)


#-------------------------------------------------------------------
# Checkout rules
#-------------------------------------------------------------------

_prj_repo/%:
	$(DBGOUT) CFG02: $@	
	$(CFG_EXE_CHECKOUT) $(CFG_DIR_PRJD)/$(subst _prj_repo/,,$@).repo $(foreach g,$(GRP),$(subst $(g)/,$(CFG_DIR_LIB)/,$(filter $(g)/%,$(subst _prj_repo/,,$@))))
EOD=

#$(CFG_DIR_LIB)/%:
#	$(DBGOUT) CFG02: $@
#	$(CFG_EXE_CHECKOUT) $@
#	$(CFG_MD) "$(subst \,/,$@)"	
#EOD=


#-------------------------------------------------------------------
# Go!
#-------------------------------------------------------------------

ifdef DBGSTR
all: showdbg
EOD=
else
all: $(CFG_REQUIRE)
EOD=
endif
