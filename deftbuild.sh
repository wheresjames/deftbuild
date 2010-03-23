
#-------------------------------------------------------------------
#
# Parameters
#
# $1 = Command      - show, checkout, update, archive, diff,
#                     makepatch, applypatch, build
#
# $2 = Group list   - Project group
#
# $3 = Project list -
#
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------
. ./config.sh

#-------------------------------------------------------------------
# Read in parameters
#-------------------------------------------------------------------

# Shortcuts
CMD=$1
if [ ${CMD} == "-" ]; 		then CMD=show; fi
if [ ${CMD} == "co" ]; 		then CMD=checkout; fi
if [ ${CMD} == "up" ]; 		then CMD=update; fi
if [ ${CMD} == "arc" ]; 	then CMD=archive; fi
if [ ${CMD} == "dif" ]; 	then CMD=diff; fi
if [ ${CMD} == "mp" ]; 		then CMD=makepatch; fi
if [ ${CMD} == "ap" ]; 		then CMD=applypatch; fi
if [ ${CMD} == "bld" ];		then CMD=build; fi

# Get directory roots
if [ $2 ] && [ $2 != "-" ]; then
	IFS=","; DIRLIST=($2); unset IFS
else
	cd ${DIR_LPRJ}
	for i in $(ls -d */); do DIRLIST="${DIRLIST} ${i%*/}"; done		
fi

echo "---"
echo " Command  : ${CMD}"
echo " Groups   : ${DIRLIST[@]}"
if [ $3 ]; then
	echo " Projects : $3"
fi
echo "---"

# Ensure lib directory
if [ ! -d ${DIR_LIB} ]; then
	mkdir -p ${DIR_LIB}
fi

# Extra parameter
EXTPARAM=$4

# Unique field
if [ ! -z ${EXTPARAM} ] && [ ${EXTPARAM} != "-" ]; then
	UNIQUENAME=${EXTPARAM}
else
	UNIQUENAME=`date +%G%m%d-%H%M%S`
fi

#-------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------

if [ $1 == "archive" ]; then
	ARCHPATH="${DIR_ARC}/${UNIQUENAME}"
	if [ ! -d ${ARCHPATH} ]; then
		mkdir -p ${ARCHPATH}
	fi
fi

if [ $1 == "diff" ]; then
	ARCHPATH="${DIR_DIF}/${UNIQUENAME}"
	if [ ! -d ${ARCHPATH} ]; then
		mkdir -p ${ARCHPATH}
	fi
fi

if [ $1 == "makepatch" ]; then
	if [ -z ${EXTPARAM} ]; then
		EXTPARAM=default
	fi
	ARCHPATH="${DIR_LPAT}/${EXTPARAM}"
	if [ ! -d ${ARCHPATH} ]; then
		mkdir -p ${ARCHPATH}
	fi
fi

if [ $1 == "applypatch" ]; then
	if [ -z ${EXTPARAM} ]; then
		EXTPARAM=default
	fi
	ARCHPATH="${DIR_LPAT}/${EXTPARAM}"
fi

#-------------------------------------------------------------------
# Process each group/project
#-------------------------------------------------------------------
for DR in ${DIRLIST[@]} 
do

	if [ $3 ] && [ $3 != "-" ]; then
		IFS=","; FILELIST=($3); unset IFS
	else	
		FILELIST=
		for i in $( find ${DIR_LPRJ}/${DR} -maxdepth 1 -type f -name '*'.${EXT_REPO} ); do FILELIST="${FILELIST} ${i##*/}"; done
	fi

	for CF in ${FILELIST[@]} 
	do

		CF=${CF%.*}
		FNAME=${CF%:*}
		FVERS=${CF#*:}
		FULL="${DIR_LPRJ}/${DR}/${FNAME}.${EXT_REPO}"

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

				if [ -z "${REVN}" ]; then
					REVN="-"
				fi

				if [ -n "${PROJ}" ] && [ -n ${REPO} ] && [ "${PROJ}" != "#" ]; then

					# Where is the library?	
					LIBPATH="${DIR_LIB}/${PROJ}"
					
					# Start in library root
					cd ${DIR_LIB}
					
					# Show affected projects
					if [ ${CMD} == "show" ]; then
						echo ${PROJ} : ${REPO} : ${REVN} : ${LINK}
					fi

					# build
					if [ ${CMD} == "build" ]; then
						. ${DIR_LBIN}/build.sh
					fi
					
					# Checkout
					if [ ${CMD} == "checkout" ]; then
						. ${DIR_LBIN}/checkout.sh
					fi

					# Update
					if [ ${CMD} == "update" ]; then
						. ${DIR_LBIN}/update.sh
					fi
	
					# Archive
					if [ ${CMD} == "archive" ]; then
						. ${DIR_LBIN}/archive.sh
					fi
	
					# diff
					if [ ${CMD} == "diff" ]; then
						. ${DIR_LBIN}/diff.sh
					fi
	
					# makepatch
					if [ ${CMD} == "makepatch" ]; then
						. ${DIR_LBIN}/makepatch.sh
					fi
	
					# makepatch
					if [ ${CMD} == "applypatch" ]; then
						. ${DIR_LBIN}/applypatch.sh
					fi
	
				fi
				
			done < ${FULL}		
		fi
	done
done

# The end
echo

