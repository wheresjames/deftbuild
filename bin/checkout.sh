
# Skip if already checked out	
if [ -d ${LIBPATH} ]; then 

	echo "  .  Ignoring ${PROJ} : ${REPO} : ${REVN}"
	
	return

fi

# Let the use know what's going on
echo " *** Checkout ${PROJ} : ${REPO} : ${REVN}"

# Subversion
if [ "${REPO}" == "svn" ]; then	

	if [ "${REVN}" != "-" ]; then
		svn ${SVN_OPTIONS} co -q -r ${REVN} "${LINK}" "${LIBPATH}"
	else
		svn ${SVN_OPTIONS} co -q "${LINK}" "${LIBPATH}"
	fi

fi

# CVS
if [ "${REPO}" == "cvs" ]; then	

	MODL=${STR%% *}
	STR=${STR#* }
	PROTO=${STR%% *}
	STR=${STR#* }
	if [ ${PROTO} == ${MODL} ]; then
		PROTO=
	fi

	if [ "${REVN}" != "-" ]; then
		cvs -Q -z3 -d "${PROTO}${LINK}" co -r ${REVN} -d "${PROJ}" "${MODL}"
	else
		cvs -Q -z3 -d "${PROTO}${LINK}" co -d "${PROJ}" "${MODL}"
	fi

fi

# git
if [ "${REPO}" == "git" ]; then	

	git clone "${LINK}" "${PROJ}"
	if [ "${REVN}" != "-" ]; then
		cd "${PROJ}"
		git checkout "${REVN}"
	fi

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

	if [ "${REVN}" != "-" ]; then
		gunzip -c ${FILE} | tar xf -
		mv "${REVN}" "${PROJ}"
	else
		cd "${PROJ}"
		gunzip -c ${FILE} | tar xf -
	fi			

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

	if [ "${REVN}" != "-" ]; then
		bunzip2 -c ${FILE} | tar xf -
		mv "${REVN}" "${PROJ}"
	else			
		cd "${PROJ}"
		bunzip2 -c ${FILE} | tar xf -
	fi

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

	if [ "${REVN}" != "-" ]; then
		unzip -q ${FILE}
		mv "${REVN}" "${PROJ}"
	else
		mkdir "${PROJ}"
		cd "${PROJ}"
		unzip -q ${FILE}
	fi

fi

