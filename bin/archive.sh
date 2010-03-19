
# Only update if it already exists
if [ ! -d ${LIBPATH} ]; then 
	return
fi

echo " *** Archiving ${PROJ}"

FILE="${ARCHPATH}/${PROJ}.tgz"		
tar -czf ${FILE} ${PROJ}

	

