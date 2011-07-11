
ifndef PRJ_OPTS
	PRJ_OPTS := -O3
endif

ifdef CFG_VER
	CFG_VER_DEF := -DOEX_PROJECT_VERSION="\"$(CFG_VER)\""
endif
ifdef CFG_FVER
	CFG_VER_DEF := $(CFG_VER_DEF) -DOEX_PROJECT_FILEVERSION="\"$(CFG_FVER)\""
endif
CFG_DEFS := -DOEX_PROJECT_NAME="\"$(CFG_NAME)\"" -DOEX_PROJECT_LNAME="\"$(CFG_LNAME)\"" -DOEX_PROJECT_DESC="\"$(CFG_DESC)\"" $(CFG_VER_DEF)
ifdef SQENGINE
	CFG_DEFS := $(CFG_DEFS) -DOEX_SQENGINE="\"$(SQENGINE)\""
endif	


CFG_LOCAL_TOOL_JOIN  	:= $(CFG_LOCAL_BUILD_TYPE)/join

ifdef PRJ_SQEX
	CFG_LOCAL_TOOL_RESCMP  	:= "$(CFG_LOCAL_BUILD_TYPE)/sqrbld"
else
	CFG_LOCAL_TOOL_RESCMP 	:= $(CFG_LOCAL_BUILD_TYPE)/resbld
endif

ifdef DBG
	CFG_CEXTRA	 := -g -DDEBUG -D_DEBUG $(CFG_CEXTRA)
	CFG_LEXTRA	 := -g
	CFG_DPOSTFIX := _d
else
	CFG_CEXTRA	 := $(PRJ_OPTS) -s -DNDEBUG=1 $(CFG_CEXTRA)
	ifneq ($(PRJ_TYPE),dll)
		CFG_LEXTRA	 := -s
	endif
endif

# Arm compiler
ifeq ($(CFG_PROC),arm)

	ifeq ($(CFG_TOOLS),snapgear)

		OS := linux
		PLATFORM := posix

		# Snapgear
		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/local/bin/arm-linux-
		CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm-linux

		CFG_STDLIB := -lrt -pthread
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSTRUCTINIT -DOEX_PACKBROKEN -DOEX_NOSHM -DOEX_NODL
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif
	ifeq ($(CFG_TOOLS),codesourcery)

		OS := android
		PLATFORM := posix

		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm/bin/arm-none-eabi-
		CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm/arm-none-eabi

		CFG_STDLIB := -lc -lstdc++ -lg
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_PACKBROKEN -DOEX_NODIRENT -DOEX_NODL
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq
		
		CFG_NODL := 1

	endif
	ifeq ($(CFG_TOOLS),android)

		# http://android-tricks.blogspot.com/
		# http://betelco.blogspot.com/2010/01/buildingdebugging-android-native-c.html
		# http://honeypod.blogspot.com/2007/12/dynamically-linked-hello-world-for.html

		OS := android
		APILEVEL = android-9
		PLATFORM := posix
		PRJ_DEFS := $(PRJ_DEFS) ANDROID __ANDROID__

		ifneq ($(WBLD),)

			EXISTS_ANDROIDNDK := $(wildcard $(CFG_LIBROOT)/android-ndk-win)
			ifneq ($(strip $(EXISTS_ANDROIDNDK)),)

				TOOLS := google
				PRJ_DEFS := $(PRJ_DEFS)
				CFG_ANDROIDNDK := $(CFG_LIBROOT)/android-ndk-win

				# PATH := $(CFG_ANDROIDNDK)/toolchains/arm-eabi-4.4.0/prebuilt/windows/bin:$(PATH)
				# CFG_TOOLPREFIX := arm-eabi-
				# CFG_SYSROOT := $(CFG_ANDROIDNDK)/toolchains/arm-eabi-4.4.0/prebuilt/windows

				PATH := $(CFG_ANDROIDNDK)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/windows/bin:$(PATH)
				CFG_TOOLPREFIX := arm-linux-androideabi-
				# CFG_SYSROOT := $(CFG_ANDROIDNDK)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/windows
				
				CFG_ANDROIDROOT := $(CFG_ANDROIDNDK)/platforms/$(APILEVEL)/arch-arm/usr

				CFG_CPFLAGS := $(CFG_CPFLAGS) -fno-rtti 
				# CFG_NODL := 1
			else

				EXISTS_ANDROIDNDK := $(wildcard $(CFG_LIBROOT)/android-crystax-win)
				ifneq ($(strip $(EXISTS_ANDROIDNDK)),)

					TOOLS := crystax
					PRJ_DEFS := $(PRJ_DEFS)
					CFG_ANDROIDNDK := $(CFG_LIBROOT)/android-crystax-win
					
					#PATH := $(CFG_ANDROIDNDK)/build/prebuilt/windows/arm-eabi-4.4.0/bin:$(PATH)
					#CFG_TOOLPREFIX := arm-eabi-
					
					PATH := $(CFG_ANDROIDNDK)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/windows/bin:$(PATH)
					CFG_TOOLPREFIX := arm-linux-androideabi-
					
					CFG_ANDROIDROOT := $(CFG_ANDROIDNDK)/platforms/$(APILEVEL)/arch-arm/usr

					# -msoft-float -mcpu=xscale -mtune=xscale -march=armv5te -mthumb -fomit-frame-pointer 
					# -finline-limit=64 -fexceptions -frtti
					# CFG_STDLIB := -fno-exceptions -static-libgcc -static-libstdc++
					# CFG_CFLAGS := $(CFG_CFLAGS) -fno-exceptions
					# -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__ -DANDROID 

				endif
			
			endif
		else
			EXISTS_ANDROIDNDK := $(wildcard $(CFG_LIBROOT)/android-ndk-linux)
			ifneq ($(strip $(EXISTS_ANDROIDNDK)),)

				TOOLS := google
				PRJ_DEFS := $(PRJ_DEFS)
				CFG_ANDROIDNDK := $(CFG_LIBROOT)/android-ndk-linux

#					PATH := $(CFG_ANDROIDNDK)/toolchains/arm-eabi-4.4.0/prebuilt/linux-x86/bin:$(PATH)
#					CFG_TOOLPREFIX := arm-eabi-

				CFG_ANDROIDTOOLS := $(CFG_ANDROIDNDK)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86
				PATH := $(CFG_ANDROIDTOOLS)/bin:$(PATH)
				CFG_TOOLPREFIX := arm-linux-androideabi-

				CFG_ANDROIDROOT := $(CFG_ANDROIDNDK)/platforms/$(APILEVEL)/arch-arm/usr

			endif
		endif

		PRJ_SYSI := $(PRJ_SYSI) $(CFG_ANDROIDROOT)/include

#			wchar_static
#			CFG_CPFLAGS := $(CFG_CPFLAGS) -I$(CFG_ANDROIDROOT)/include \
#										  -I$(CFG_ANDROIDNDK)/sources/wchar-support/include \
#										  -I$(CFG_ANDROIDNDK)/sources/cxx-stl/stlport/stlport \
#										  $(CFG_ANDROIDNDK)/sources/cxx-stl/stlport/libs/armeabi/libstlport_static.a \
#										  $(CFG_ANDROIDNDK)/sources/cxx-stl/gnu-libstdc++/libs/armeabi/libstdc++.a

		CFG_CPFLAGS := $(CFG_CPFLAGS) -I$(CFG_ANDROIDROOT)/include \
									  -I$(CFG_ANDROIDNDK)/sources/wchar-support/include \
									  -I$(CFG_ANDROIDNDK)/sources/cxx-stl/gnu-libstdc++/include \
									  -I$(CFG_ANDROIDNDK)/sources/cxx-stl/gnu-libstdc++/libs/armeabi/include \
								  
		CFG_STDLIB := $(CFG_STDLIB) -L$(CFG_ANDROIDROOT)/lib
		CFG_LFLAGS := $(CFG_LFLAGS) -Wl -nostdlib -dynamic-linker=/system/bin/linker

		ifeq ($(PRJ_TYPE),exe)
			# CFG_STDLIB := $(CFG_STDLIB) -Wl,--entry=main
			ifeq ($(LIBLINK),static)
				CFG_LFLAGS := $(CFG_LFLAGS) $(CFG_ANDROIDROOT)/lib/crtbegin_static.o
			else
				CFG_LFLAGS := $(CFG_LFLAGS) $(CFG_ANDROIDROOT)/lib/crtbegin_dynamic.o
				CFG_STDLIB := $(CFG_STDLIB) -Wl,-rpath-link=$(CFG_ANDROIDROOT)/lib
				CFG_STDLIB := $(CFG_STDLIB) -Wl,-rpath=/system/lib
			endif				
			CFG_STDLIB := $(CFG_STDLIB) $(CFG_ANDROIDROOT)/lib/crtend_android.o
		endif
		
		ifeq ($(LIBLINK),static)
			CFG_STDLIB := $(CFG_STDLIB) -lc -lgcc -lsupc++ -lstdc++ -lc -lm \
										$(CFG_ANDROIDNDK)/sources/cxx-stl/gnu-libstdc++/libs/armeabi/libstdc++.a \
										$(CFG_ANDROIDNDK)/sources/cxx-stl/gnu-libstdc++/libs/armeabi-v7a/libstdc++.a
		else
			CFG_STDLIB := $(CFG_STDLIB) -lc -lgcc -lsupc++ -lstdc++ -lc -lm \
										$(CFG_ANDROIDNDK)/sources/cxx-stl/gnu-libstdc++/libs/armeabi/libstdc++.a \
										$(CFG_ANDROIDNDK)/sources/cxx-stl/gnu-libstdc++/libs/armeabi-v7a/libstdc++.a
		endif				

		# --disable-libunwind-exceptions -mthumb -fno-exceptions
		# -Wno-psabi +++ What's the correct way to get rid of va_list warning?
		CFG_LFLAGS := $(CFG_LFLAGS) $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) -fno-short-enums -Wno-psabi \
									-msoft-float -march=armv5te -mthumb-interwork -mthumb \
									-c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_PACKBROKEN -DOEX_NOPACK -DOEX_NODIRENT \
									-DOEX_NODL -DOEX_NOEXECINFO -DOEX_NOPTHREADCANCEL -DOEX_NOMSGBOX -DOEX_NOTLS \
									-DOEX_NOWCSTO -DOEX_NOSETTIME -DOEX_NOTIMEGM -DOEX_NOTHREADTIMEOUTS  -DOEX_NOEPOLL \
									-DOEX_NOWCSTO -DOEX_NOWCHAR -DOEX_CRASHDUMPSTDOUT
#										-DOEX_NOEXCEPTIONS
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

		ifeq ($(LIBLINK),static)
			CFG_NODL := 1
		endif

	endif
	ifeq ($(CFG_TOOLS),crystax)

		OS := android
		PLATFORM := posix

		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/build/prebuilt/linux-x86/arm-eabi-4.4.0/bin/arm-eabi-
		CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/build/platforms/android-8/arch-arm

		CFG_STDLIB := -nostdlib -lgcc -lc -lgcc -lstdc++ -L$(CFG_TOOLROOT)/$(CFG_TOOLS)/build/platforms/android-8/arch-arm/usr/lib
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) \
									-c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_PACKBROKEN -DOEX_NODIRENT \
									-DOEX_NODL -DOEX_NOEXECINFO -DOEX_NOPTHREADCANCEL -DOEX_NOMSGBOX \
									-DOEX_NOWCSTO -DOEX_NOSETTIME -DOEX_NOTIMEGM -DOEX_NOTHREADTIMEOUTS
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

		ifeq ($(LIBLINK),static)
			CFG_NODL := 1
		endif

	endif
	ifeq ($(CFG_TOOLS),nihilism)

		OS := linux
		PLATFORM := posix

		# nihilism
		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/bin/arm-unknown-linux-gnu-
		CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm-unknown-linux-gnu

		CFG_STDLIB := -lrt -pthread
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT -DOEX_PACKBROKEN -DOEX_NOVIDEO -DOEX_NODL
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif
	ifeq ($(CFG_TOOLS),uclinux)

		OS := linux
		PLATFORM := posix

		# uclinux
		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/local/bin/arm-linux-
		CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/local/arm-linux

		CFG_STDLIB := -lrt -pthread
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT -DOEX_PACKBROKEN -DOEX_NOVIDEO -D__GCC_FLOAT_NOT_NEEDED
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif
	ifeq ($(CFG_TOOLS),openmoko)

		OS := linux
		PLATFORM := posix

		# openmoko
		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm/bin/arm-angstrom-linux-gnueabi-
		CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm/arm-angstrom-linux-gnueabi

		CFG_STDLIB := -lrt -pthread
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT -DOEX_NOVIDEO
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif
	ifeq ($(CFG_TOOLS),armel)

		OS := linux
		PLATFORM := posix

		# armel
		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/bin/arm-linux-gnu-
		CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/

		CFG_STDLIB := -lrt -pthread
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT -DOEX_NOVIDEO
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif
	ifeq ($(CFG_TOOLS),buildroot)

		OS := linux
		PLATFORM := posix

		# buildroot
		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/build_arm/staging_dir/usr/bin/arm-linux-uclibcgnueabi-
		CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/build_arm/staging_dir/

		CFG_STDLIB := -lrt -pthread
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) \ 
							-c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT -DOEX_NOSTAT64 \
							-DOEX_NOWCHAR -DOEX_NOEXECINFO -D_FILE_OFFSET_BITS=32
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif
	ifeq ($(CFG_TOOLS),crosstool)

		OS := linux
		PLATFORM := posix

		# crosstool
		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/bin/arm-crosstool-linux-gnueabi-
		CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/arm-crosstool-linux-gnueabi

		CFG_STDLIB := -lrt -pthread
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) \ 
							-c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT -DOEX_NOSTAT64 \
							-DOEX_NOWCHAR -DOEX_NOEXECINFO
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif
	ifeq ($(CFG_TOOLS),scratchbox)

		OS := linux
		PLATFORM := posix

		# scratchbox/compilers/arm-linux-gcc3.4.cs-glibc2.3/bin/arm-linux-g++
		# scratchbox/compilers/arm-linux-gcc3.4.cs-glibc2.3/bin

		# martin's crosstool build
		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm-gcc3.4-uclibc0.9.28/bin/arm-linux-
		#CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm-gcc3.4-uclibc0.9.28

		CFG_STDLIB := -lrt -pthread
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) \ 
							-c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT \
							-DOEX_NOSTAT64 -DOEX_NOWCHAR -DOEX_NOEXECINFO -DOEX_PACKBROKEN
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif
	ifeq ($(CFG_TOOLS),iphone)

		OS := darwin9
		PLATFORM := posix

		# iphone
		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/tc/toolchain/pre/bin/arm-apple-darwin9-
		CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/tc/toolchain/sys/

		CFG_STDLIB :=
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) \ 
							-c -MMD -DOEX_IPHONE -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM \
							-DOEX_NOSTRUCTINIT -DOEX_NOSTAT64 -DOEX_NOVIDEO -DOEX_NOEPOLL
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif
	ifeq ($(CFG_TOOLS),cegcc)

		OS := wince
		PLATFORM := windows

		# cegcc
		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/bin/arm-wince-cegcc-
		CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm-wince-cegcc/

		CFG_STDLIB := -lole32
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) \ 
							-c -MMD -D_WIN32_WCE=0x0400 -DOEX_ARM -D__int64="long long" \
							-DOEX_LOWRAM -DOEX_NOVIDEO -DOEX_NOCRTDEBUG -DOEX_NOXIMAGE
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

		CFG_EXE_POST := .exe

	endif
	ifeq ($(CFG_TOOLS),mingw32ce)

		OS := wince
		PLATFORM := windows

		# mingw32ce
		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/bin/arm-wince-mingw32ce-
		CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm-wince-mingw32ce/

		# -lwinsock
		CFG_STDLIB := -lole32 -laygshell -lws2
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) \
							-c -MMD -D_WIN32_WCE=0x0400 -DOEX_ARM -D__int64="long long" \
							-DOEX_LOWRAM -DOEX_NOCRTDEBUG -DOEX_NODSHOW -DOEX_NOVFW
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

		CFG_EXE_POST := .exe

	endif
	ifeq ($(CFG_TOOLS),)


		OS := linux
		PLATFORM := posix

		# Custom tools
		CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/bin/$(CFG_TOOLS)-
#			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/sysroot
		override CFG_TOOLS := custom

		CFG_STDLIB := -lrt -pthread
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) \
							-c -fexceptions -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSTRUCTINIT \
							-DOEX_PACKBROKEN -DOEX_NOSHM
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif

else

	ifeq ($(CFG_TOOLS),mingw32)

		OS := win32
		PLATFORM := windows

		CFG_STDLIB := -lole32 -lgdi32 -lws2_32 -lvfw32
		CFG_LFLAGS := $(CFG_CFLAGS) $(CFG_LEXTRA) -export-all-symbols
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) \
							-c -MMD -Wall -fno-strict-aliasing \
							-DOEX_NODSHOW -DOEX_NOCRTDEBUG -D__int64="long long" -DOEX_NOSTRUCTINIT
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif
	ifeq ($(CFG_TOOLS),mingw64)

		OS := win64
		PLATFORM := windows
		
		EXISTS_MINGW64 := $(wildcard $(CFG_LIBROOT)/mingw64-win)
		ifneq ($(strip $(EXISTS_MINGW64)),)

			# _MACHINE:x64 SYB_LP64 _LARGEFILE_SOURCE _FILE_OFFSET_BITS=64
			PRJ_DEFS := $(PRJ_DEFS) _AMD64_ __x86_64 __LP64__
			CFG_MINGW64 := $(CFG_LIBROOT)/mingw64-win
			PATH := $(CFG_MINGW64)/bin:$(PATH)
			CFG_TOOLPREFIX := x86_64-w64-mingw32-

		else
		
			EXISTS_MINGW64 := $(wildcard $(CFG_LIBROOT)/mingw64)
			ifneq ($(strip $(EXISTS_MINGW64)),)
			
				CFG_MINGW64 := $(CFG_LIBROOT)/mingw64
				CFG_SYSROOT := $(CFG_MINGW64)/x86_64-w64-mingw32
				CFG_TOOLPREFIX := $(CFG_MINGW64)/bin/x86_64-w64-mingw32-
				
			else

				# Cross compile for windows
				CFG_TOOLPREFIX := amd64-mingw32msvc-
				# CFG_TOOLPREFIX := ~/mingw64/bin/amd64-mingw32msvc
			
			endif
			
		endif

		# -fstack-check -m64
		CFG_STDLIB := -lole32 -lgdi32 -lws2_32 -lavicap32 -lmsvfw32
		CFG_LFLAGS := $(CFG_LEXTRA) -export-all-symbols -fno-leading-underscore -static-libgcc -static-libstdc++
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) -m64 \
							-c -MMD -Wall -fno-strict-aliasing -fno-leading-underscore \
							-DOEX_NODSHOW -DOEX_NOCRTDEBUG -DOEX_NOSTRUCTINIT -D__int64="long long"
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif
	ifeq ($(CFG_TOOLS),mac)

		OS := apple
		PLATFORM := posix

		# Cross compile for mac
		CFG_TOOLPREFIX :=

		CFG_STDLIB :=
		CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) -c -MMD -Wall -fno-strict-aliasing -DOEX_NOSTRUCTINIT
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

	endif
	ifeq ($(CFG_TOOLS),local)

		OS := linux
		PLATFORM := posix

		# Local platform
		CFG_TOOLPREFIX :=

		# -mtune=generic -mfpmath=387 -mno-sse2
		# -lregex -lpng -ljpeg -lzlib -ltiff -lstdc++ -lgcc -lodbc32 -lwsock32 -lwinspool -lwinmm -lshell32 -lcomctl32 -lctl3d32 -lodbc32 -ladvapi32 -lodbc32 -lwsock32 -lopengl32 -lglu32 -lole32 -loleaut32
		# --whole-archive
		
		CFG_STDLIB := -lrt -pthread
#			CFG_LFLAGS := $(CFG_LEXTRA)
		CFG_CFLAGS := $(CFG_CFLAGS) $(CFG_CEXTRA) -c -MMD -Wall -fno-strict-aliasing
#			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -Wall
		CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
		CFG_AFLAGS := cq

		ifeq ($(PROC),x64)
			CFG_CFLAGS := $(CFG_CFLAGS) -m64
			CFG_ASFLAGS := -f elf64
		else
			CFG_ASFLAGS := -f elf32 -a x86
		endif
		
		ifeq ($(PRJ_TYPE),dll)
			CFG_LFLAGS := $(CFG_LEXTRA) -rdynamic -Wl,-E -Wl,--export-dynamic
		endif

		ifeq ($(LIBLINK),static)
			CFG_LFLAGS := $(CFG_LFLAGS) -static-libgcc -static-libstdc++
		else
			CFG_LFLAGS := $(CFG_LFLAGS) -shared-libgcc
		endif
#			endif

	endif

endif

ifneq ($(LIBLINK),static)
	CFG_LFLAGS := $(CFG_LFLAGS)
	ifeq ($(PRJ_NPIC),)
		CFG_CFLAGS := $(CFG_CFLAGS) -fPIC -DPIC
	endif
endif

ifeq ($(PRJ_TYPE),dll)
	CFG_LFLAGS := $(CFG_LFLAGS) -shared
	ifeq ($(PLATFORM),windows)
		CFG_LFLAGS := $(CFG_LFLAGS) -Wl,-enable-auto-import
	endif
else
	ifeq ($(LIBLINK),static)
		CFG_LFLAGS := $(CFG_LFLAGS) -static
		CFG_CFLAGS := $(CFG_CFLAGS) -static
	else
		# CFG_LFLAGS := $(CFG_LFLAGS) -shared
		# CFG_CFLAGS := $(CFG_CFLAGS) -shared
	endif
endif

ifeq ($(LIBLINK),static)
	# CFG_LFLAGS := $(CFG_LFLAGS) -static-libgcc -static-libstdc++
endif

# you can't use dlopen() [-ldl] with static linking!
# http://www.qnx.com/developers/docs/6.3.2/neutrino/lib_ref/d/dlopen.html
ifeq ($(PLATFORM),posix)
#		ifeq ($(LIBLINK),shared)
	ifeq ($(CFG_NODL),)
		CFG_STDLIB := $(CFG_STDLIB) -ldl
	endif
#		endif
endif

#	ifeq ($(PRJ_TYPE),dll)
#		CFG_LD := $(CFG_TOOLPREFIX)ld -E --export-dynamic
#	else
#		ifeq ($(PRJ_TYPE),lib)
#			CFG_LD := $(CFG_TOOLPREFIX)ld -E --export-dynamic
#		else
#			CFG_LD := $(CFG_TOOLPREFIX)g++ -rdynamic -Wl,-E -Wl,--export-dynamic
#		endif
#	endif

#user override?
ifdef PRE
	CFG_TOOLPREFIX := $(strip $(PRE))
endif
ifdef SYS
	CFG_SYSROOT := $(strip $(SYS))
endif

ifneq ($(CFG_SYSROOT),)
	CFG_SYSROOT_OPTIONS := --sysroot=$(CFG_SYSROOT)
endif

ifneq ($(CFG_SYSROOT_HEADERS),)
	CFG_SYSROOT_OPTIONS := $(CFG_SYSROOT_OPTIONS) --headers=$(CFG_SYSROOT_HEADERS)
endif

# Tools
CFG_PP := $(CFG_TOOLPREFIX)g++ $(CFG_SYSROOT_OPTIONS)
CFG_LD := $(CFG_TOOLPREFIX)g++
CFG_CC := $(CFG_TOOLPREFIX)gcc $(CFG_SYSROOT_OPTIONS)
CFG_AR := $(CFG_TOOLPREFIX)ar
CFG_DT := $(CFG_TOOLPREFIX)dlltool
CFG_DP := $(CFG_TOOLPREFIX)makedepend
CFG_AS := $(CFG_TOOLPREFIX)as
CFG_RC := $(CFG_TOOLPREFIX)windres

CFG_ASM := yasm

CFG_MD := mkdir -p
CFG_RM := rm -rf
CFG_DEL:= rm -f
CFG_CPY:= cp
CFG_CD := cd
CFG_SAR:= sed -i

CFG_CC_OUT := -o $(nullstring)
CFG_LD_OUT := -o $(nullstring)

CFG_CUR_ROOT := $(shell pwd)

CFG_CC_INC := -I
