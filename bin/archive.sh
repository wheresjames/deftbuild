
# Only update if it exists
if [ ! -d ${LIBPATH} ]; then 
	return
fi

echo " *** Archiving ${PROJ}"

#tar -czf "${ARCHPATH}/${PROJ}.tgz" ${PROJ}

tar -c ${PROJ} | bzip2 > "${ARCHPATH}/${PROJ}.bz2"

zip -q -r "${ARCHPATH}/${PROJ}.zip" ${PROJ}

