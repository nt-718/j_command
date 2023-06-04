#!/bin/sh

j() {

    CURRENT=$(pwd)
    REF_FILE=~/.j-reference

    # No argument provided and add to the list
    if [[ -z "$1" ]]; then
        if ! grep -Fxq "$CURRENT" $REF_FILE; then
            echo "$CURRENT" >> $REF_FILE
            echo "$CURRENT was added to the list of visited directories."
        fi
        return 0
    fi

    # --help option
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Jump to a previously visited directory"
        echo ""
        echo "Usage to jump: j [directory]"
		echo "Usage to opt: j [Options]"
		echo ""
        echo "Options:"
        echo "  --edit, -e            Open the directory list in vim"
        echo "  --list, -l            Show the directory list"
        echo "  --sort, -s            Sort the directory list"
        echo "  --clean, -c           Clean invalid directories from the list"
		echo "  --remove, -r          Remove the current directory from the directory list"
        echo "  --help, -h            Display this help and exit"
        echo ""
        echo "If no options and directory are provided, the current directory is added to the list of visited directories."
        return 0
    fi

    # --edit option
    if [[ "$1" == "--edit" || "$1" == "-e" ]]; then
        vim $REF_FILE
        echo "Edit mode was finished."
        return 0
    fi

    # --remove option
    if [[ "$1" == "--remove" || "$1" == "-r" ]]; then
      grep -v "^$CURRENT$" "$REF_FILE" > "$REF_FILE.tmp" && mv "$REF_FILE.tmp" "$REF_FILE"
      echo "$CURRENT was removed from the list of visited directories."   
	  return 0
	fi

    # --list option
    if [[ "$1" == "--list" || "$1" == "-l" ]]; then
        echo "The list of visited directories:"
        cat $REF_FILE
        return 0
    fi

    # --sort option
    if [[ "$1" == "--sort" || "$1" == "-s" ]]; then
        sortfile=$(cat $REF_FILE | awk '{print length() ,$0}' | sort -n | awk '{print $2}')
        echo "$sortfile" > $REF_FILE
        echo "The list of visited directories was sorted."
        return 0
    fi

    # --clean option
    if [[ "$1" == "--clean" || "$1" == "-c" ]]; then
        while read -r line; do
            if [[ ! -d "$line" || ! -r "$line" ]]; then
                grep -v "^$line$" "$REF_FILE" > "$REF_FILE.tmp" && mv "$REF_FILE.tmp" "$REF_FILE"
            fi
        done < "$REF_FILE"
        echo "Invalid directories was cleaned."
        return 0
    fi

    # Jump to directory
    while read line; do
        if [[ "$line" =~ "$1" ]]; then
            DIR_NAME="$line"
            break
        fi
    done < $REF_FILE

    if [[ -z "$DIR_NAME" ]]; then
        echo "No such directory: $1"
        return 1
    else
        cd "$DIR_NAME"
        return 0
    fi
}