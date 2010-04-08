
# Only update if it already exists
if [ ! -d ${LIBPATH} ]; then 

	return
	
fi
		
DNLREL="../dnl${DIR_IDX}/${PROJ}"
PATCH="${ARCHPATH}/${PROJ}.${REPO}.patch"

echo " *** Creating Patch : ${PATCH}"

# Subversion
if [ "${REPO}" == "svn" ]; then	

# booo, svn diff doesn't pick up new files
#	cd ${LIBPATH}
#	svn diff > "${PATCH}"

	# ensure download directory
	if [ ! -d ${DIR_DNL} ]; then
		mkdir -p ${DIR_DNL}
	fi

	if [ "${REVN}" != "-" ]; then
		svn ${SVN_OPTIONS} co -q -r ${REVN} "${LINK}" "${DIR_DNL}/${PROJ}"
	else
		cd ${LIBPATH}
		CVER=`svnversion`
		svn ${SVN_OPTIONS} co -q -r ${CVER%*M} "${LINK}" "${DIR_DNL}/${PROJ}"
	fi

	cd ${DIR_LIB}
	diff -rupwbBEN --strip-trailing-cr -x ".svn" "${DNLREL}/" "${PROJ}" > "${PATCH}"
	rm -Rf "${DIR_DNL}/${PROJ}/"							

fi

# CVS
if [ "${REPO}" == "cvs" ]; then	

	# Save the diff anyway
#	cd ${LIBPATH}
#	cvs -Q -w diff -N -u > "${PATCH}"


	# ensure download directory
	if [ ! -d ${DIR_DNL} ]; then
		mkdir -p ${DIR_DNL}
	fi

	MODL=${STR%% *}
	STR=${STR#* }
	PROTO=${STR%% *}
	STR=${STR#* }
	if [ ${PROTO} == ${MODL} ]; then
		PROTO=
	fi

	cd ${DIR_DNL}
	if [ "${REVN}" != "-" ]; then
		cvs -Q -z3 -d "${PROTO}${LINK}" co -r ${REVN} -d "${PROJ}" "${MODL}"
	else
		cvs -Q -z3 -d "${PROTO}${LINK}" co -d "${PROJ}" "${MODL}"
	fi

	cd ${DIR_LIB}
	diff -rupwbBEN --strip-trailing-cr -x "CVS" "${DNLREL}/" "${PROJ}" > "${PATCH}"
	rm -Rf "${DIR_DNL}/${PROJ}/"							

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
	diff -rupwbBEN --strip-trailing-cr "${DNLREL}/" "${PROJ}" > "${PATCH}"
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
	diff -rupwbBEN --strip-trailing-cr "${DNLREL}/" "${PROJ}" > "${PATCH}"
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
	diff -rupwbBEN --strip-trailing-cr "${DNLREL}/" "${PROJ}" > "${PATCH}"
	rm -Rf "${DIR_DNL}/${PROJ}/"							
fi

# Just delete empty patches
if [ -f ${PATCH} ] && [ ! -s ${PATCH} ]; then
	rm -f "${PATCH}"
fi
					

