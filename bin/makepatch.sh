
unset IFS
DIR_CURRENT=$PWD
DIR_OSS=${DIR_CURRENT}/oss
DIR_LIB=${DIR_CURRENT}/../lib3
DIR_BIN=${DIR_CURRENT}/../bin
DIR_DNL=${DIR_CURRENT}/../dnl
DIR_UPL=${DIR_CURRENT}/../upl
DIR_ARC=${DIR_CURRENT}/../arc
DIR_DIF=${DIR_CURRENT}/../dif

# Get directory roots
if [ $1 ]; then
	if [ $1 != "-" ]; then
		IFS=","; DIRLIST=($1); unset IFS
	else
		cd ${DIR_OSS}
		for i in $(ls -d */); do DIRLIST="${DIRLIST} ${i%*/}"; done		
	fi
else
#	DIRLIST="core"
	cd ${DIR_OSS}
	for i in $(ls -d */); do DIRLIST="${DIRLIST} ${i%*/}"; done		
fi

echo "Searching in : ${DIRLIST[@]}"

for DR in ${DIRLIST[@]} 
do

	if [ $2 ]; then
		IFS=","; FILELIST=($2); unset IFS
	else	
		FILELIST=
		for i in $(find "${DIR_OSS}/${DR}" -maxdepth 1 -type f); do FILELIST="${FILELIST} ${i##*/}"; done
	fi

	for CF in ${FILELIST[@]} 
	do

		CF=${CF%.*}
		FNAME=${CF%:*}
		FVERS=${CF#*:}
		FULL="${DIR_OSS}/${DR}/${FNAME}.repo"
		PATCH="${DIR_OSS}/${DR}/${FNAME}.patch"

		if [ -f ${FULL} ]; then

			# bug???
			if [ ${FNAME} == ${FVERS} ]; then
				FVERS=
			fi

			while read LINE
			do
				STR=${LINE}
				PROJ=${STR%% *}
				STR=${STR#* }
				REPO=${STR%% *}
				STR=${STR#* }
				REVN=${STR%% *}
				STR=${STR#* }
				LINK=${STR%% *}
				STR=${STR#* }
		
				if [ -n "${FVERS}" ]; then	
					REVN=${FVERS}			
				fi

				if [ -n "${PROJ}" ] && [ -n ${REPO} ] && [ "${PROJ}" != "#" ]; then
	
					# Switch to lib root
					cd ${DIR_LIB}
	
					# Where will the files go?
					LIBPATH=${DIR_LIB}/${PROJ}

					# Only update if it already exists
					if [ -d ${LIBPATH} ]; then 
		
						echo " *** Diffing : ${PATCH}"

						# Subversion
						if [ "${REPO}" == "svn" ]; then	
		
							cd ${LIBPATH}
							svn diff > "${PATCH}"
	
						fi
	
						# CVS
						if [ "${REPO}" == "cvs" ]; then	
					
							# Save the diff anyway
							cd ${LIBPATH}
							cvs -Q diff > "${PATCH}"
						fi
	
						# git
						if [ "${REPO}" == "git" ]; then	
		
							cd ${LIBPATH}
							git diff > "${PATCH}"

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
							
							diff -rupN "${DIR_DNL}/${PROJ}/" "${LIBPATH}/" > "${PATCH}"
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

							diff -rupN "${DIR_DNL}/${PROJ}/" "${LIBPATH}/" > "${PATCH}"
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
		
							diff -rupN "${DIR_DNL}/${PROJ}/" "${LIBPATH}/" > "${PATCH}"
							rm -Rf "${DIR_DNL}/${PROJ}/"							
						fi
						
					fi
				fi
			done < ${FULL}		
		fi
	done
done

