#!/bin/bash

git filter-branch --env-filter "
	if [ \"\$$1\" = \"$2\" ]; then
		echo . Changing $1 from $2 to $3;
		export $1=$3
	fi
  " HEAD

