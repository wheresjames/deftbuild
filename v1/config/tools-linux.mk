
EXISTS_JDK := $(wildcard $(CFG_LIBROOT)/jdk-linux)
ifneq ($(strip $(EXISTS_JDK)),)
	PRJ_DEFS := $(PRJ_DEFS)
	CFG_JDKROOT := $(CFG_LIBROOT)/jdk-linux
	PATH := $(CFG_JDKROOT)/bin:$(PATH)
	CFG_JAVAC := javac
endif
