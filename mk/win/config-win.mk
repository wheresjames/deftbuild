
include 

#-------------------------------------------------------------------
# Windows config
#-------------------------------------------------------------------

# Tools
CFG_PP := cl /nologo /DWIN32 /wd4996
CFG_LD := link /NOLOGO
CFG_CC := cl /nologo /DWIN32 /wd4996
CFG_AR := lib /nologo

CFG_CD := cd
CFG_MV := copy
CFG_RD := rmdir /s /q
CFG_RM := del /f /q
#CFG_MD := "$(subst /,\,$(CFG_DIR_LBIN)/make_directory.bat)"
CFG_MD := mkdir
CFG_DP := makedepend

#CFG_EXE_CHECKOUT := "$(CFG_DIR_LBAT)/checkout-prj.bat"
CFG_EXE_CHECKOUT := "bat/checkout-prj.bat"
