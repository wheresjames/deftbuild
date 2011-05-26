
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := irrlicht-es
PRJ_DEPS := irrlicht-es
PRJ_TYPE := lib
PRJ_INCS := irrlicht-es/include jpeg png tiff zlib bzip2
PRJ_LIBS := 
PRJ_DEFS := GL_APIENTRY= glTexEnvi=glTexEnvx \
		    EGL_RENDERABLE_TYPE=0x3040 EGL_OPENGL_ES_BIT=0x0001 EGL_CLIENT_APIS=0x308D \
			NO_IRR_USE_NON_SYSTEM_JPEG_LIB_  NO_IRR_USE_NON_SYSTEM_LIB_PNG_ \
			NO_IRR_USE_NON_SYSTEM_ZLIB_ NO_IRR_USE_NON_SYSTEM_BZLIB_ \
			NO_IRR_COMPILE_WITH_SDL_DEVICE_ NO_IRR_COMPILE_WITH_CONSOLE_DEVICE_ \
			NO_IRR_COMPILE_WITH_DIRECT3D_8_ NO_IRR_COMPILE_WITH_DIRECT3D_9_ \
			NO_IRR_COMPILE_WITH_OPENGL_ NO_IRR_COMPILE_WITH_X11_
			

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(OS),wince)
UNSUPPORTED := OS=$(OS) not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

ifeq ($(TOOLS),iphone)
	PRJ_INCS := $(PRJ_INCS) ogles/include
#	PRJ_DEFS := _IRR_IPHONE_PLATFORM_ _IRR_USE_IPHONE_DEVICE_
endif

ifeq ($(PLATFORM),windows)
	PRJ_DEFS := _IRR_STATIC_LIB_
	ifeq ($(OS),wince)
		PRJ_DEFS := $(PRJ_DEFS)
		PRJ_INCS := $(PRJ_INCS) ogles/include
	else
		PRJ_DEFS := $(PRJ_DEFS) _IRR_COMPILE_WITH_OPENGL_
	endif	
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

ifeq ($(PLATFORM),windows)
CFG_CFLAGS := $(CFG_CFLAGS) /DIRRLICHT_EXPORTS
endif

export LOC_TAG := def
LOC_INC_def := $(CFG_LIBROOT)/irrlicht-es/include
LOC_SRC_def := $(CFG_LIBROOT)/irrlicht-es/source/Irrlicht
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif


