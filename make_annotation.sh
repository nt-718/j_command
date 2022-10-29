#!/bin/bash

# main section

json=`cat ~/annotation.json | sed '/^$/d'`

keyarray=()
valuearray=()
depth=1
square_brackets_count=0
parent=""

put_parent() {
	tmp_key=$1
	prev_key=$2
	tmp_depth=$3
	prev_depth=$4
	num=$5
	i=1

	if [[ $tmp_depth = 1 ]]; then
		res="self"
	elif [[ $tmp_depth = 2 ]]; then 
		res="root"
	elif [[ $tmp_depth > $prev_depth ]]; then
		res="$prev_key"
		tmp_parent[$i]="$prev_key"
		i=$(($i+1))
	elif [[ $tmp_depth = $prev_depth ]]; then
		res="$tmp_parent[$(($num-1))]"
	else
		res=$tmp_parent[$i]
	fi

	echo "$res"

	# echo "$1 $2 $3 $4"
}

json_low_count=`echo $json | jq -r . | wc -l`

shopt -s extglob lastpipe

echo "$json" | while read line

do
	key=`echo "$line" | cut -f 1 -d ":"`

	keyarray+=("$key")

	value=`echo "$line" | cut -f 2- -d ":"`
	
	valuearray+=("$value")

done

for num in `seq 0 $((${#keyarray[@]} - 1))`

do

	key=`echo "${keyarray[num]}" | sed 's/ //g'`
	value=`echo "${valuearray[num]}" | sed 's/ //g'`

	case "$value" in
		'{')
			parent=`put_parent "$key" "$prev_key" $depth $prev_depth $num`
			data[$num]="$key $value $depth $square_brackets_count $parent"
			# [[ "$key" == "$value" ]] && Schema[$num]="$key $depth"
			# [[ "$key" != "$value" ]] && Schema[$num]="$key $depth"
			depth=$(($depth + 1))  ;;
			
		'}')
			depth=$(($depth - 1))
			parent=`put_parent "$key" "$prev_key" $depth $prev_depth $num`
			data[$num]="$key $value $depth $square_brackets_count $parent" ;;
				
		'[')
			square_brackets_count=$(($square_brackets_count + 1))
			parent=`put_parent "$key" "$prev_key" $depth $prev_depth $num`
			data[$num]="$key $value $depth $square_brackets_count $parent" ;; 
	
		'},')
			parent=`put_parent "$key" "$prev_key" $depth $prev_depth $num`
			data[$num]="$key $value $depth $square_brackets_count $parent"
			depth=$(($depth - 1)) ;;
	
		']')
			square_brackets_count=$(($square_brackets_count - 1))
			parent=`put_parent "$key" "$prev_key" $depth $prev_depth $num`
			data[$num]="$key $value $depth $square_brackets_count $parent" ;;
					
		'],')
			square_brackets_count=$(($square_brackets_count - 1))
			parent=`put_parent "$key" "$prev_key" $depth $prev_depth $num`
			data[$num]="$key $value $depth $square_brackets_count $parent" ;;

		* )
			parent=`put_parent "$key" "$prev_key" $depth $prev_depth $num`
			data[$num]="$key $value $depth $square_brackets_count $parent" ;;
	esac

	prev_depth=`echo "${data[$(($num-1))]}" | awk '{print $3}'`
	prev_key=`echo "${data[$(($num-1))]}" | awk '{print $1}'`

	depth_value=`echo "${data[$num]}" | awk '{print $3}'`

	echo "${data[$num]}"

done







# for n in `seq 0 $(( ${#data[@]} -1 ))`
# do
# 	key=`echo "${data[$n]}" | awk '{print $1}'`
# 	value=`echo "${data[$n]}" | awk '{print $2}'`
# 	depth=`echo "${data[$n]}" | awk '{print $3}'`
	
# 	if [[ $depth > 0 ]]; then

# 		for m in {10..0}
# 		do
# 			name_schema=`echo "${Schema[m]}" | awk '{print $1}'`
# 			depth_schema=`echo "${Schema[m]}" | awk '{print $2}'`
# 			depth_for_search=$(($depth - 1))
# 			[[ "$depth_for_search" == "$depth_schema" ]] && new_data[$n]="$key $value $depth $name_schema"
# 		done
# 	else
# 		new_data[$n]="${data[n]} root"
# 	fi

# 	echo "${new_data[$n]}"

# done

# echo "${new_data[@]}"