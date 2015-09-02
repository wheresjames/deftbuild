#ifndef VPX_CONFIG_H
#define VPX_CONFIG_H

#if defined( _WIN64 ) || defined( _M_X64 ) || defined( __amd64__ ) || defined( __LP64__ ) || defined( __x86_64__ ) || defined( __ppc64__ ) || defined( _LP64 )
#	define INT_BIT 64
#define HAVE_MMX 0
#define HAVE_MMX2 0
#else
#	define INT_BIT 32
#define HAVE_MMX 1
#define HAVE_MMX2 1
#endif

#if ( INT_BIT == 32 )
#	define ARCH_X86_32 1
#	define ARCH_X86_64 0
#else
#	define ARCH_X86_32 0
#	define ARCH_X86_64 1
#endif

#define RESTRICT __restrict__

#define ARCH_ARM 0
#define ARCH_MIPS 0
#define ARCH_PPC32 0
#define ARCH_PPC64 0
#define HAVE_EDSP 0
#define HAVE_MEDIA 0
#define HAVE_NEON 0
#define HAVE_MIPS32 0
#define HAVE_SSE 1
#define HAVE_SSE2 1
#define HAVE_SSE3 1
#define HAVE_SSSE3 1
#define HAVE_SSE4_1 1
#define HAVE_ALTIVEC 0
#define HAVE_VPX_PORTS 1
#define HAVE_STDINT_H 1
#define HAVE_ALT_TREE_LAYOUT 0
#define HAVE_PTHREAD_H 1
#define HAVE_SYS_MMAN_H 1
#define HAVE_UNISTD_H 1
#define CONFIG_EXTERNAL_BUILD 0
#define CONFIG_INSTALL_DOCS 1
#define CONFIG_INSTALL_BINS 1
#define CONFIG_INSTALL_LIBS 1
#define CONFIG_INSTALL_SRCS 0
#define CONFIG_DEBUG 0
#define CONFIG_GPROF 0
#define CONFIG_GCOV 0
#define CONFIG_RVCT 0
#define CONFIG_GCC 1
#define CONFIG_MSVS 0
#define CONFIG_PIC 0
#define CONFIG_BIG_ENDIAN 0
#define CONFIG_CODEC_SRCS 0
#define CONFIG_DEBUG_LIBS 0
#define CONFIG_FAST_UNALIGNED 1
#define CONFIG_MEM_MANAGER 0
#define CONFIG_MEM_TRACKER 0
#define CONFIG_MEM_CHECKS 0
#define CONFIG_MD5 1
#define CONFIG_DEQUANT_TOKENS 0
#define CONFIG_DC_RECON 0
#define CONFIG_RUNTIME_CPU_DETECT 1
#define CONFIG_POSTPROC 1
#define CONFIG_MULTITHREAD 1
#define CONFIG_INTERNAL_STATS 0
#define CONFIG_VP8_ENCODER 1
#define CONFIG_VP8_DECODER 1
#define CONFIG_VP8 1
#define CONFIG_ENCODERS 1
#define CONFIG_DECODERS 1
#define CONFIG_STATIC_MSVCRT 0
#define CONFIG_SPATIAL_RESAMPLING 1
#define CONFIG_REALTIME_ONLY 0
#define CONFIG_ONTHEFLY_BITPACKING 0
#define CONFIG_ERROR_CONCEALMENT 0
#define CONFIG_SHARED 0
#define CONFIG_STATIC 1
#define CONFIG_SMALL 0
#define CONFIG_POSTPROC_VISUALIZER 0
#define CONFIG_OS_SUPPORT 1
#define CONFIG_UNIT_TESTS 0
#define CONFIG_MULTI_RES_ENCODING 0
#endif /* VPX_CONFIG_H */
