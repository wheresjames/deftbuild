
# Only update if it already exists
if [ ! -d ${LIBPATH} ]; then 
	return
fi

echo " *** Building ${PROJ}"

# make -C $(CFG_LIBROOT)/winglib

cd "${DIR_LBLD}/dep"
make -f "lib_${PROJ}.mk" ${EXTPARAM}



	

