
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
			if [ -f ${PATCH} ]; then

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
		
							echo " *** Applying : ${PATCH}"

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
						fi
					fi
				done < ${FULL}		
			fi
		fi
	done
done

