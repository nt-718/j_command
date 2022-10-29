#!/bin/bash

# main section

json=`cat ~/annotation.json | sed '/^$/d'`

keyarray=()
valuearray=()
depth=1
square_brackets_count=0
parent=""

json_low_count=`echo $json | jq -r . | wc -l`

shopt -s extglob lastpipe

echo "$json" | while read line

do
	key=`echo "$line" | cut -f 1 -d ":"`

	keyarray+=("$key")

	value=`echo "$line" | cut -f 2- -d ":"`
	
	valuearray+=("$value")

done

make_data() {

for num in `seq 0 $((${#keyarray[@]} - 1))`

do

	key=`echo "${keyarray[num]}" | sed 's/ //g'`
	value=`echo "${valuearray[num]}" | sed 's/ //g'`

	case "$value" in
		'{')
			data[$num]="$key $value $depth $square_brackets_count"
			depth=$(($depth + 1)) ;;
			
		'}')
			depth=$(($depth - 1)) 
			data[$num]="$key $value $depth $square_brackets_count" ;;
				
		'[')
			square_brackets_count=$(($square_brackets_count + 1))
			data[$num]="$key $value $depth $square_brackets_count" ;; 
	
		'},')
			data[$num]="$key $value $depth $square_brackets_count"
			depth=$(($depth - 1)) ;;
	
		']')
			square_brackets_count=$(($square_brackets_count - 1))
			data[$num]="$key $value $depth $square_brackets_count" ;;
					
		'],')
			square_brackets_count=$(($square_brackets_count - 1))
			data[$num]="$key $value $depth $square_brackets_count" ;;

		* )
			data[$num]="$key $value $depth $square_brackets_count" ;;
	esac

	depth_value=`echo "${data[$num]}" | awk '{print $3}'`

	parent="hello"

	echo "${data[$num]}"

done

}

data=$(make_data)

echo "$data"