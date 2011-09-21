
# Only update if it exists
if [ ! -d ${LIBPATH} ]; then 
	return
fi

echo " *** Archiving ${PROJ}"

#tar -hczf "${ARCHPATH}/${PROJ}.tgz" ${PROJ}

tar -hc ${PROJ} | bzip2 > "${ARCHPATH}/${PROJ}.tar.bz2"

#zip -q -r "${ARCHPATH}/${PROJ}.zip" ${PROJ}

