
unset IFS
DIR_CURRENT=$PWD
DIR_OSS=${DIR_CURRENT}/oss
DIR_LIB=${DIR_CURRENT}/../lib3
DIR_BIN=${DIR_CURRENT}/../bin
DIR_DNL=${DIR_CURRENT}/../dnl
DIR_UPL=${DIR_CURRENT}/../upl
DIR_ARC=${DIR_CURRENT}/../arc
DIR_DIF=${DIR_CURRENT}/../dif

#Get archive name
# date +%G%m%d%H%M%S
if [ $1 ]; then
	if [ $1 != "-" ]; then
		ARCHNAME=$1
	else
		ARCHNAME=`date +%G%m%d%H%M%S`
	fi
else
	ARCHNAME=`date +%G%m%d%H%M%S`
fi

echo "Creating Diff : ${ARCHNAME}"

ARCHPATH="${DIR_DIF}/${ARCHNAME}"
if [ ! -d ${ARCHPATH} ]; then
	mkdir -p ${ARCHPATH}
fi

# Get directory roots
if [ $2 ]; then
	if [ $2 != "-" ]; then
		IFS=","; DIRLIST=($2); unset IFS
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

	if [ $3 ]; then
		IFS=","; FILELIST=($3); unset IFS
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
		
						echo " *** Diffing ${PROJ} : ${REPO} : ${REVN}"

						# Subversion
						if [ "${REPO}" == "svn" ]; then	
		
							FILE="${ARCHPATH}/${PROJ}.svn"
				
							cd ${LIBPATH}
							CVER=`svnversion`
#							svnversion > "${FILE}.ver"
							svn diff > "${FILE}.${CVER}.diff"
	
						fi
	
						# CVS
						if [ "${REPO}" == "cvs" ]; then	
		
							FILE="${ARCHPATH}/${PROJ}-${REVN}.cvs"
							
							cd ${LIBPATH}
							cvs -Q diff > "${FILE}.diff"
	
						fi
	
						# git
						if [ "${REPO}" == "git" ]; then	
		
							FILE="${ARCHPATH}/${PROJ}-${REVN}.git"
							
							cd ${LIBPATH}
							git diff > "${FILE}.diff"
	
						fi
	
						# targz
						if [ "${REPO}" == "targz" ]; then	

							# Download and extract the file
							FILE="${ARCHPATH}/${PROJ}-${REVN}.tar.gz"

#							tar -cf - ${PROJ} | gzip -c > ${FILE}

						fi

						# tarbz2
						if [ "${REPO}" == "tarbz2" ]; then	

							# Download and extract the file
							FILE="${ARCHPATH}/${PROJ}-${REVN}.tar.bz2"
							
#							tar -cf - ${PROJ} | bzip2 -c > ${FILE}

						fi
					fi
				fi
			done < ${FULL}		
		fi
	done
done

