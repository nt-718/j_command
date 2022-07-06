#!/bin/sh


PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'zz'


zz() {

	CURRENT=$(pwd)

	check=`cat ~/zzz.txt | grep $CURRENT`

	if [ -z $1 ]; then

		if [ -z "$check" ]; then
		
			echo "$CURRENT" >> ~/zzz.txt
		fi

	else
		
		while read line
	do
		DIR_NAME=`echo $line | grep $1 | sed -e 's/.*\/\([^\/]*\)$/\1/'`

		[[ "$DIR_NAME" =~ $1 ]] && break

	done < ~/zzz.txt

		if [ -z $line ]; then
			echo "No such a directory"
		else
			cd $line
		fi
	fi
}
