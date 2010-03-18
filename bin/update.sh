
unset IFS
DIR_CURRENT=$PWD
DIR_OSS=${DIR_CURRENT}/oss
DIR_LIB=${DIR_CURRENT}/../lib3
DIR_BIN=${DIR_CURRENT}/../bin
DIR_DNL=${DIR_CURRENT}/../dnl
DIR_UPL=${DIR_CURRENT}/../upl

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

				if [ -n "${PROJ}" ]; then
	
					# Switch to lib root
					cd ${DIR_LIB}
	
					# Where will the files go?
					LIBPATH=${DIR_LIB}/${PROJ}

					# Only update if it already exists
					if [ -d ${LIBPATH} ]; then 
			
						# Don't update projects set to a specific revision
						if [ "${REVN}" != "*" ]; then
					
							echo "  .  Ignoring ${PROJ} : ${REPO} : ${REVN}"
							
						else
		
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
							
						fi
					fi		
				fi
			done < ${FULL}		
		fi
	done
done

