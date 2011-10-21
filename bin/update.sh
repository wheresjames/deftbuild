

# Only update if it already exists
if [ ! -d ${LIBPATH} ] || [ "${REVN}" != "-" ]; then

	echo "  .  Ignoring ${PROJ} : ${REPO} : ${REVN}"
	
	return
fi
		
echo " *** Updating ${PROJ} : ${REPO} : ${REVN}"

# Subversion
if [ "${REPO}" == "svn" ]; then	

	cd ${LIBPATH}
	svn ${SVN_OPTIONS} update

fi

# CVS
if [ "${REPO}" == "cvs" ]; then	

	cd ${LIBPATH}
	cvs -Q update

fi

# git
if [ "${REPO}" == "git" ]; then	

	cd ${LIBPATH}
	git pull

fi

# hg
if [ "${REPO}" == "hg" ]; then	

	cd ${LIBPATH}
	hg pull

fi

# targz
if [ "${REPO}" == "targz" ]; then	

	# Lose the current 
	rm -Rf ${LIBPATH}

	# ensure download directory
	if [ ! -d ${DIR_DNL} ]; then
		mkdir -p ${DIR_DNL}
	fi

	# Download and extract the file
	FILE="${DIR_DNL}/${PROJ}.tar.gz"
	[ -f ${FILE} ] || wget -O "${FILE}" "${LINK}"

	if [ "${REVN}" != "*" ]; then
		gunzip -c ${FILE} | tar xf -
		mv "${REVN}" "${PROJ}"
	else
		cd "${PROJ}"
		gunzip -c ${FILE} | tar xf -
	fi			

fi

# tarbz2
if [ "${REPO}" == "tarbz2" ]; then	

	# Lose the current 
	rm -Rf ${LIBPATH}

	# ensure download directory
	if [ ! -d ${DIR_DNL} ]; then
		mkdir -p ${DIR_DNL}
	fi

	# Download and extract the file
	FILE="${DIR_DNL}/${PROJ}.tar.bz2"
	[ -f ${FILE} ] || wget -O "${FILE}" "${LINK}"

	if [ "${REVN}" != "*" ]; then
		bunzip2 -c ${FILE} | tar xf -
		mv "${REVN}" "${PROJ}"
	else			
		cd "${PROJ}"
		bunzip2 -c ${FILE} | tar xf -
	fi

fi


