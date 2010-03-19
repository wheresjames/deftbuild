
PATCH="${ARCHPATH}/${PROJ}.${REPO}.patch"

# Only update if it already exists
if [ ! -d ${LIBPATH} ] || [ ! -s ${PATCH} ]; then 

	return

fi
		
echo " *** Applying patch : ${PATCH}"

# Subversion
if [ "${REPO}" == "svn" ]; then	

	cd ${LIBPATH}
	patch -p0 < "${PATCH}"

fi

# CVS
if [ "${REPO}" == "cvs" ]; then	

	# Save the diff anyway
	cd ${LIBPATH}
	patch -p0 < "${PATCH}"
fi

# git
if [ "${REPO}" == "git" ]; then	

	cd ${LIBPATH}
	git apply "${PATCH}"

fi

# targz
if [ "${REPO}" == "targz" ]; then	

	cd ${LIBPATH}
	patch -p0 < "${PATCH}"							
	
fi

# tarbz2
if [ "${REPO}" == "tarbz2" ]; then	

	cd ${LIBPATH}
	patch -p0 < "${PATCH}"
	
fi

# zip
if [ "${REPO}" == "zip" ]; then	

	cd ${LIBPATH}
	patch -p0 < "${PATCH}"
	
fi

