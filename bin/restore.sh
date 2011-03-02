
# Skip if already checked out	
if [ -d ${LIBPATH} ]; then 

	echo "  .  Ignoring ${PROJ} : ${REPO} : ${REVN}"
	
	return

fi

# Let the use know what's going on
echo " *** Restore ${PROJ} from ${ARCHPATH}"

# Download and extract the file
FILE="${ARCHPATH}/${PROJ}.tar.bz2"
if [ -z "${DOWNLOADLINK}" ] || wget -O "${FILE}" "${DOWNLOADLINK}/${PROJ}.tar.bz2"; then

	bunzip2 -c ${FILE} | tar xf -
	
else

	echo " !!! Failed to retrieve ${FILE} : ${DOWNLOADLINK}"

fi

