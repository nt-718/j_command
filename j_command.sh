#!/bin/sh

j() {

	CURRENT=$(pwd)

	if [[ -z "$1" ]]; then
		
		check=`cat ~/zzz.txt | grep -x $CURRENT`

		if [[ -z "$check" ]]; then
		
			echo "$CURRENT" >> ~/zzz.txt
		fi

	elif [[ "$1" == --edit ]]; then
		vim ~/zzz.txt
	
	elif [[ "$1" == --start ]]; then
	
		PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'j'

	elif [[ "$1" == --sort ]]; then
		sortfile=`cat ~/zzz.txt | awk '{print length() ,$0}' | sort -n | awk '{print $2}'`

		echo "$sortfile" > ~/zzz.txt

	else	

		while read line
	do
		#lineforgrep=${line,,}
		#DIR_NAME=`echo "$line" | grep "$1" | sed -e 's/.*\/\([^\/]*\)$/\1/'`
		DIR_NAME=`echo "$line" | grep "$1"` # j A/Bのように検索できる

		[[ "$DIR_NAME" =~ "$1" ]] && break

	done < ~/zzz.txt

		if [[ -z "$line" ]]; then
			echo "No such a directory"
		else
			cd "$line"
		fi
	fi
}

