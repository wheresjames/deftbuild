
unset IFS
DIR_CURRENT=$PWD
DIR_CHO=${DIR_CURRENT}/co
DIR_LIB=${DIR_CURRENT}/../lib3
DIR_BIN=${DIR_CURRENT}/../bin
DIR_DNL=${DIR_CURRENT}/../dnl
DIR_UPL=${DIR_CURRENT}/../upl

# Get directory listing
#


# Get directory roots
if [ $1 ]; then
	if [ $1 != "-" ]; then
		IFS=","; DIRLIST=($1); unset IFS
	else
		cd ${DIR_CHO}
		for i in $(ls -d */); do DIRLIST="${DIRLIST} ${i%*/}"; done		
	fi
else
	DIRLIST="core"
fi

echo ${DIRLIST[@]}

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
		for i in $(find "${DIR_CHO}/${DR}" -maxdepth 1 -type f); do FILELIST="${FILELIST} ${i##*/}"; done
	fi
	
	for CF in ${FILELIST[@]} 
	do

		CF=${CF%.*}
		FNAME=${CF%:*}
		FVERS=${CF#*:}
		FULL="${DIR_CHO}/${DR}/${FNAME}.txt"

		if [ -f ${FULL} ]; then

			echo " *** Checkout ${FULL}"
			
		fi
	done
done

