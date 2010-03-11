
unset IFS
DIR_CURRENT=$PWD
DIR_OSS=${DIR_CURRENT}/oss
DIR_LIB=${DIR_CURRENT}/../lib3
DIR_BIN=${DIR_CURRENT}/../bin
DIR_DNL=${DIR_CURRENT}/../dnl
DIR_UPL=${DIR_CURRENT}/../upl

# Hmmmm...
#SVN_OPTIONS=--trust-server-cert --non-interactive

# Get directory roots
if [ $1 ]; then
	if [ $1 != "-" ]; then
		IFS=","; DIRLIST=($1); unset IFS
	else
		cd ${DIR_OSS}
		for i in $(ls -d */); do DIRLIST="${DIRLIST} ${i%*/}"; done		
	fi
else
	DIRLIST="core"
fi

echo "Searching in : ${DIRLIST[@]}"

FRESHCOPY=0
if [ $3 ]; then
	FRESHCOPY=1
fi

# Ensure lib directory
if [ ! -d ${DIR_LIB} ]; then
	mkdir -p ${DIR_LIB}
fi

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
	
					if [ ${FRESHCOPY} -gt 0 ]; then	
						if [ -s ${LIBPATH} ]; then
							rm -Rf "${LIBPATH}"
						fi
					fi
		
					if [ -d ${LIBPATH} ]; then 

						echo "  .  Ignoring ${PROJ} : ${REPO} : ${REVN}"
		
					else
		
						# Let the use know what's going on
						echo " *** Checkout ${PROJ} : ${REPO} : ${REVN}"

						# Subversion
						if [ "${REPO}" == "svn" ]; then	
			
							if [ "${REVN}" != "*" ]; then
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
						
							if [ "${REVN}" != "*" ]; then
								cvs -Q -z3 -d "${PROTO}${LINK}" co -r ${REVN} -d "${PROJ}" "${MODL}"
							else
								cvs -Q -z3 -d "${PROTO}${LINK}" co -d "${PROJ}" "${MODL}"
							fi
		
						fi
		
						# git
						if [ "${REPO}" == "git" ]; then	
			
							git clone "${LINK}" "${PROJ}"
							if [ "${REVN}" != "*" ]; then
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
			done < ${FULL}		
		fi
	done
done

