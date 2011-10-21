
# Only update if it already exists
if [ ! -d ${LIBPATH} ]; then 

	return
	
fi

echo " *** Diffing ${PROJ} : ${REPO} : ${REVN}"

# Subversion
if [ "${REPO}" == "svn" ]; then	

	cd ${LIBPATH}
	CVER=`svnversion`
	svn diff > "${ARCHPATH}/${PROJ}.${CVER%*M}.svn.diff"

fi

# CVS
if [ "${REPO}" == "cvs" ]; then	

	# +++ Ok, didn't find an obvious way to get CVS versions.
	#     So I'm going to just tar for now.
	CVER="---"

	FILE="${ARCHPATH}/${PROJ}.${CVER}.tar.bz2"
	tar -cf - ${PROJ} | bzip2 -c > ${FILE}

	# Save the diff anyway
	cd ${LIBPATH}
	cvs -Q diff > "${ARCHPATH}/${PROJ}.${CVER%*M}.cvs.diff"
fi

# git
if [ "${REPO}" == "git" ]; then	

	cd ${LIBPATH}
	CVER=`git rev-parse --verify HEAD`
	git diff > "${ARCHPATH}/${PROJ}.${CVER}.git.diff"

fi

# targz
if [ "${REPO}" == "targz" ]; then	

	# Download and extract the file
	FILE="${ARCHPATH}/${PROJ}.${REVN}.tar.gz"
	tar -cf - ${PROJ} | gzip -c > ${FILE}

fi

# tarbz2
if [ "${REPO}" == "tarbz2" ]; then	

	# Download and extract the file
	FILE="${ARCHPATH}/${PROJ}-${REVN}.tar.bz2"
	tar -cf - ${PROJ} | bzip2 -c > ${FILE}

fi

# zip
if [ "${REPO}" == "zip" ]; then	

	# Download and extract the file
	FILE="${ARCHPATH}/${PROJ}-${REVN}.zip"
	zip -q -r "${FILE}" "${PROJ}"

fi

