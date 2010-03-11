
unset IFS
DIR_CURRENT=$PWD
DIR_OSS=${DIR_CURRENT}/oss
DIR_LIB=${DIR_CURRENT}/../lib3
DIR_BIN=${DIR_CURRENT}/../bin
DIR_DNL=${DIR_CURRENT}/../dnl
DIR_UPL=${DIR_CURRENT}/../upl
DIR_ARC=${DIR_CURRENT}/../arc

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

echo "Creating Archive : ${ARCHNAME}"

ARCHPATH="${DIR_ARC}/${ARCHNAME}"
if [ ! -d ${ARCHPATH} ]; then
	mkdir -p ${ARCHPATH}
fi

cd ${DIR_LIB}
for i in $(ls -d */); do DIRLIST="${DIRLIST} ${i%*/}"; done		

echo "Archiving : ${DIRLIST[@]}"

for DR in ${DIRLIST[@]} 
do
	# Where will the files go?
	LIBPATH=${DIR_LIB}/${DR}

	# Only update if it already exists
	if [ -d ${LIBPATH} ]; then 

		echo " *** Archiving ${DR}"

		# Download and extract the file
#		FILE="${ARCHPATH}/${DR}.tar.bz2"		
#		tar -cf - ${PROJ} | gzip -c > ${FILE}	
#		tar -cf - ${DR} | bzip2 -c > ${FILE}

		FILE="${ARCHPATH}/${DR}.tgz"		
		tar -czf ${FILE} ${DR}

	fi
	
done

