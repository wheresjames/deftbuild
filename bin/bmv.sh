
# $1 = File patterh				- *.txt
# $2 = Search pattern			- \\\(.*\.\\\)txt
# $3 = Replace pattern			- \1repo.txt 
# $4 = non zero for non-test	- 1

PATTERN="s/$2/$3/"

echo " Parameters : $1, ${PATTERN}, $3"

if [ $4 ]; then
	echo "Here goes the real thing..."
	for FILE in $(find . -name "$1"); do mv "$FILE" `echo "$FILE" | sed $PATTERN`; done
else
	echo "This is just a test..."
	for FILE in $(find . -name "$1"); do echo mv "$FILE" `echo "$FILE" | sed $PATTERN`; done
fi

