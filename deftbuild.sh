#!/bin/bash

#-------------------------------------------------------------------
#
# Parameters
#
# $1 = idx			- value postfixed to output directories
#
# $2 = Command      - show, checkout, update, archive, diff,
#                     makepatch, applypatch, build
#
# $3 = Group list   - Project group
#
# $4 = Project list -
#
# $5 = Tag			- Unique tag for archives, diffs, or patches
#
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------

if [ $1 ] && [ $1 != "-" ]; then
	DIR_IDX=$1
fi

. ./config.sh

#-------------------------------------------------------------------
# Read in parameters
#-------------------------------------------------------------------

# Shortcuts
CMD=$2
if [ ${CMD} == "-" ]; then 
	CMD=show 
fi
if [ ${CMD} == "co" ]; then
	CMD=checkout 
fi
if [ ${CMD} == "up" ]; then 
	CMD=update 
fi
if [ ${CMD} == "arc" ]; then
	CMD=archive
fi
if [ ${CMD} == "dif" ]; then
	CMD=diff
fi
if [ ${CMD} == "mp" ]; then
CMD=makepatch
fi
if [ ${CMD} == "ap" ]; then
	CMD=applypatch
fi
if [ ${CMD} == "bld" ]; then
	CMD=build
fi

# Get directory roots
if [ $3 ] && [ $3 != "-" ]; then
	IFS=","; DIRLIST=($3); unset IFS
else
	cd ${DIR_LPRJ}
	for i in $(ls -d */); do DIRLIST="${DIRLIST} ${i%*/}"; done		
fi

echo "---"
echo " Index    : $5"
echo " Command  : ${CMD}"
echo " Groups   : ${DIRLIST[@]}"
if [ $4 ]; then
	echo " Projects : $4"
fi
if [ $5 ]; then
	echo " Tag      : $5"
fi
echo "---"

# Ensure lib directory
if [ ! -d ${DIR_LIB} ]; then
	mkdir -p ${DIR_LIB}
fi

# Extra parameter
EXTPARAM=$5

# Unique field
if [ ! -z ${EXTPARAM} ] && [ ${EXTPARAM} != "-" ]; then
	UNIQUENAME=${EXTPARAM}
else
	UNIQUENAME=`date +%G%m%d-%H%M%S`
fi

#-------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------

if [ ${CMD} == "archive" ]; then
	ARCHPATH="${DIR_ARC}/${UNIQUENAME}"
	if [ ! -d ${ARCHPATH} ]; then
		mkdir -p ${ARCHPATH}
	fi
fi

if [ ${CMD} == "diff" ]; then
	ARCHPATH="${DIR_DIF}/${UNIQUENAME}"
	if [ ! -d ${ARCHPATH} ]; then
		mkdir -p ${ARCHPATH}
	fi
fi

if [ ${CMD} == "makepatch" ]; then
	if [ -z ${EXTPARAM} ]; then
		EXTPARAM=default
	fi
	ARCHPATH="${DIR_LPAT}/${EXTPARAM}"
	if [ ! -d ${ARCHPATH} ]; then
		mkdir -p ${ARCHPATH}
	fi
fi

if [ ${CMD} == "applypatch" ]; then
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

	if [ $4 ] && [ $4 != "-" ]; then
		IFS=","; FILELIST=($4); unset IFS
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

