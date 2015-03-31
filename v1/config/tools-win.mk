
ifneq ($(findstring Qt,$(PRJ_FWRK)),)
	EXISTS_QT := $(wildcard $(CFG_LIBROOT)/qt-win)
	ifneq ($(strip $(EXISTS_QT)),)
		CFG_QTROOT := $(CFG_LIBROOT)/qt-win
		PRJ_LIBP := $(CFG_QTROOT)/lib $(PRJ_LIBP)
		PRJ_INCS := qt-win/include $(PRJ_INCS)
		PATH := $(CFG_QTROOT)/bin:$(PATH)
		CFG_QTMOC := moc
	endif
endif

EXISTS_JDK := $(wildcard $(CFG_LIBROOT)/jdk-win)
ifneq ($(strip $(EXISTS_JDK)),)
	PRJ_DEFS := $(PRJ_DEFS)
	CFG_JDKROOT := $(CFG_LIBROOT)/jdk-win
	PATH := $(CFG_JDKROOT)/bin:$(PATH)
	CFG_JAVA := java
	CFG_JAVAC := javac -target 1.7
	CFG_JARSIGNER := jarsigner
	CFG_JARSIGNING := 1

	# -classpath
	# CFG_JDK_CLASSPATH :=

endif

CFG_ANDROID_APILEVEL := android-19
EXISTS_ANDROIDSDK := $(wildcard $(CFG_LIBROOT)/android-sdk-win)
ifneq ($(strip $(EXISTS_ANDROIDSDK)),)
	CFG_ANDROIDSDK := $(CFG_LIBROOT)/android-sdk-win
	PATH := $(CFG_ANDROIDSDK)/platform-tools:$(CFG_ANDROIDSDK)/build-tools/19.0.2:$(CFG_ANDROIDSDK)/tools:$(PATH)
	CFG_ANDROID_AAPT := aapt
	CFG_ANDROID_DX := dx.bat --dex
	CFG_ANDROID_JAR := $(CFG_ANDROIDSDK)/platforms/$(CFG_ANDROID_APILEVEL)/android.jar
	CFG_SDKLIB_JAR := $(CFG_ANDROIDSDK)/tools/lib/sdklib.jar
	CFG_JDK_CLASSPATH := $(CFG_ANDROID_JAR)
	CFG_ANDROID_APKBUILDER := $(CFG_JAVA) -classpath $(CFG_SDKLIB_JAR) com.android.sdklib.build.ApkBuilderMain 
endif

CFG_SIGN_TIMESTAMP := http://timestamp.verisign.com/scripts/timstamp.dll

EXISTS_MSPSDK := $(wildcard $(CFG_LIBROOT)/mspsdk)
ifneq ($(strip $(EXISTS_MSPSDK)),)
	CFG_MSPSDK := $(CFG_LIBROOT)/mspsdk
	PATH := $(PATH):$(CFG_MSPSDK)/Bin
ifneq ($(findstring x64,$(BLD)),)
	PATH := $(PATH):$(CFG_MSPSDK)/Bin/x64
	CFG_SIGNROOT := $(CFG_MSPSDK)/Bin/x64
else
	PATH := $(PATH):$(CFG_MSPSDK)/Bin/x86
	CFG_SIGNROOT := $(CFG_MSPSDK)/Bin/x86
endif
	
	CFG_CODESIGN := signtool.exe
	CFG_CODESIGNING := 1	

	ifeq ($(BUILD),vs)
		PRJ_SYSI := $(CFG_MSPSDK)/Samples/multimedia/directshow/baseclasses \
					$(CFG_MSPSDK)/Include $(CFG_MSPSDK)/Include/um $(CFG_MSPSDK)/Include/shared \
					$(PRJ_SYSI)
		ifeq ($(PROC),x86)
			PRJ_LIBP := $(CFG_MSPSDK)/Lib $(CFG_MSPSDK)/Lib/x86 $(CFG_MSPSDK)/Lib $(PRJ_LIBP)
			CFG_MIDL_FLAGS := /win32
		else
			ifeq ($(PROC),ia64)
				PRJ_LIBP := $(CFG_MSPSDK)/Lib/IA64 $(PRJ_LIBP)
				CFG_MIDL_FLAGS := /win64 /ia64
			else
				PRJ_LIBP := $(CFG_MSPSDK)/Lib/x64 $(PRJ_LIBP)
				CFG_MIDL_FLAGS := /win64 /amd64
			endif
		endif
		ifeq ($(XBLD),)
			CFG_RC := "rc"
			CFG_MIDL := "Midl" /nologo
		else
			CFG_RC := wine "rc"
			CFG_MIDL := wine "Midl" /nologo
		endif

	endif
endif
