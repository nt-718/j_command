#!/bin/sh

j() {

	CURRENT=$(pwd)

	if [[ -z "$1" ]]; then
		
		check=`cat ~/.j-reference | grep -x $CURRENT`

		if [[ -z "$check" ]]; then
		
			echo "$CURRENT" >> ~/.j-reference
		fi

	elif [[ "$1" == --edit ]]; then
		vim ~/.j-reference
	
	elif [[ "$1" == --list ]]; then
		cat ~/.j-reference

	#elif [[ "$1" == --start ]]; then
	
	#	PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'j'

	elif [[ -z "$1" ]]; then
		echo $CURRENT >> ~/.j-reference

	elif [[ "$1" == --sort ]]; then
		sortfile=`cat ~/.j-reference | awk '{print length() ,$0}' | sort -n | awk '{print $2}'`

		echo "$sortfile" > ~/.j-reference

	else	

		while read line
	do
		#lineforgrep=${line,,}
		#DIR_NAME=`echo "$line" | grep "$1" | sed -e 's/.*\/\([^\/]*\)$/\1/'`
		DIR_NAME=`echo "$line" | grep "$1"`

		[[ "$DIR_NAME" =~ "$1" ]] && break

	done < ~/.j-reference

		if [[ -z "$line" ]]; then
			echo "No such a directory"
		else
			cd "$line"
		fi
	fi
}

