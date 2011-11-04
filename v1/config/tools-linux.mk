
ifneq ($(findstring Qt,$(PRJ_FWRK)),)
	CFG_QTROOT := /usr/share/qt4
	PRJ_LIBP := $(CFG_QTROOT)/lib $(PRJ_LIBP)
	PRJ_SYSI := /usr/include/qt4 $(PRJ_SYSI)
	PATH := $(CFG_QTROOT)/bin:$(PATH)
	CFG_QTMOC := moc
endif

EXISTS_JDK := $(wildcard $(CFG_LIBROOT)/jdk-linux)
ifneq ($(strip $(EXISTS_JDK)),)
	PRJ_DEFS := $(PRJ_DEFS)
	CFG_JDKROOT := $(CFG_LIBROOT)/jdk-linux
	PATH := $(CFG_JDKROOT)/bin:$(PATH)
	CFG_JAVAC := javac -target 1.6
	CFG_JARSIGNER := jarsigner
	CFG_JARSIGNING := 1
else
	CFG_JAVAC := javac -target 1.6
	CFG_JARSIGNER := jarsigner
	CFG_JARSIGNING := 1
endif

CFG_ANDROID_APILEVEL := android-9
EXISTS_ANDROIDSDK := $(wildcard $(CFG_LIBROOT)/android-sdk-linux)
ifneq ($(strip $(EXISTS_ANDROIDSDK)),)
	CFG_ANDROIDSDK := $(CFG_LIBROOT)/android-sdk-linux
	PATH := $(CFG_ANDROIDSDK)/platform-tools:$(CFG_ANDROIDSDK)/tools:$(PATH)
	CFG_ANDROID_AAPT := aapt
	CFG_ANDROID_DX := dx --dex
	CFG_ANDROID_APKBUILDER := apkbuilder
	CFG_ANDROID_JAR := $(CFG_ANDROIDSDK)/platforms/$(CFG_ANDROID_APILEVEL)/android.jar
	CFG_JDK_CLASSPATH := $(CFG_ANDROID_JAR)
endif

