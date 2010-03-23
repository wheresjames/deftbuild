
# Only update if it already exists
if [ ! -d ${LIBPATH} ]; then 

	return
	
fi
		
DNLREL="../dnl${DIR_IDX}/${PROJ}"
PATCH="${ARCHPATH}/${PROJ}.${REPO}.patch"

echo " *** Creating Patch : ${PATCH}"

# Subversion
if [ "${REPO}" == "svn" ]; then	

	cd ${LIBPATH}
	svn diff > "${PATCH}"

fi

# CVS
if [ "${REPO}" == "cvs" ]; then	

	# Save the diff anyway
	cd ${LIBPATH}
	cvs -Q -w diff > "${PATCH}"
fi

# git
if [ "${REPO}" == "git" ]; then	

	cd ${LIBPATH}
	git -w diff > "${PATCH}"

fi

# targz
if [ "${REPO}" == "targz" ]; then	

	# ensure download directory
	if [ ! -d ${DIR_DNL} ]; then
		mkdir -p ${DIR_DNL}
	fi

	# Download and extract the file
	FILE="${DIR_DNL}/${PROJ}.tar.gz"
	[ -f ${FILE} ] || wget -O "${FILE}" "${LINK}"

	cd ${DIR_DNL}
	if [ "${REVN}" != "*" ]; then
		gunzip -c ${FILE} | tar xf -
		mv "${REVN}" "${PROJ}"
	else
		cd "${PROJ}"
		gunzip -c ${FILE} | tar xf -
	fi		
	
	cd ${DIR_LIB}
	diff -rupwN "${DNLREL}/" "${PROJ}" > "${PATCH}"
	rm -Rf "${DIR_DNL}/${PROJ}/"							

fi

# tarbz2
if [ "${REPO}" == "tarbz2" ]; then	

	# ensure download directory
	if [ ! -d ${DIR_DNL} ]; then
		mkdir -p ${DIR_DNL}
	fi

	# Download and extract the file
	FILE="${DIR_DNL}/${PROJ}.tar.bz2"
	[ -f ${FILE} ] || wget -O "${FILE}" "${LINK}"

	cd ${DIR_DNL}
	if [ "${REVN}" != "*" ]; then
		bunzip2 -c ${FILE} | tar xf -
		mv "${REVN}" "${PROJ}"
	else			
		cd "${PROJ}"
		bunzip2 -c ${FILE} | tar xf -
	fi

	cd ${DIR_LIB}
	diff -rupwN "${DNLREL}/" "${PROJ}" > "${PATCH}"
	rm -Rf "${DIR_DNL}/${PROJ}/"							

fi

# zip
if [ "${REPO}" == "zip" ]; then	

	# ensure download directory
	if [ ! -d ${DIR_DNL} ]; then
		mkdir -p ${DIR_DNL}
	fi

	# Download and extract the file
	FILE="${DIR_DNL}/${PROJ}.zip"
	[ -f ${FILE} ] || wget -O "${FILE}" "${LINK}"

	cd ${DIR_DNL}
	if [ "${REVN}" != "*" ]; then
		unzip -q ${FILE}
		mv "${REVN}" "${PROJ}"
	else
		mkdir "${PROJ}"
		cd "${PROJ}"
		unzip -q ${FILE}
	fi

	cd ${DIR_LIB}
	diff -rupwN "${DNLREL}/" "${PROJ}" > "${PATCH}"
	rm -Rf "${DIR_DNL}/${PROJ}/"							
fi

# Just delete empty patches
if [ -f ${PATCH} ] && [ ! -s ${PATCH} ]; then
	rm -f "${PATCH}"
fi
					

