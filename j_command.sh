#!/bin/sh

j() {

    CURRENT=$(pwd)
    REF_FILE=~/.j-reference

    # No argument provided
    if [[ -z "$1" ]]; then
        if ! grep -Fxq "$CURRENT" $REF_FILE; then
            echo "$CURRENT" >> $REF_FILE
            echo "$CURRENT has added to the list of visited directories."
        fi
        return 0
    fi

    # --help option
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Usage: j [OPTIONS] [directory]"
        echo "Jump to a previously visited directory"
        echo ""
        echo "Options:"
        echo "  --edit, -e            Open the list of visited directories in vim"
        echo "  --list, -l            Print the list of visited directories"
        echo "  --sort, -s            Sort the list of visited directories"
        echo "  --clean, -c           Clean the invalid directories from the list"
        echo "  --help, -h            Display this help and exit"
        echo ""
        echo "If no options and directory are provided, the current directory is added to the list of visited directories."
        return 0
    fi

    # --edit option
    if [[ "$1" == "--edit" || "$1" == "-e" ]]; then
        vim $REF_FILE
        echo "Edit mode has finished."
        return 0
    fi

    # --remove option
    # if [[ "$1" == "--remove" || "$1" == "-r" ]]; then
    #   grep -v "^$2$" "$REF_FILE" > "$REF_FILE.tmp" && mv "$REF_FILE.tmp" "$REF_FILE"
    # fi

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
        echo "The list of visited directories has sorted."
        return 0
    fi

    # --clean option
    if [[ "$1" == "--clean" || "$1" == "-c" ]]; then
        while read -r line; do
            if [[ ! -d "$line" || ! -r "$line" ]]; then
                grep -v "^$line$" "$REF_FILE" > "$REF_FILE.tmp" && mv "$REF_FILE.tmp" "$REF_FILE"
            fi
        done < "$REF_FILE"
        echo "Invalid directories has cleaned."
        return 0
    fi

    # Assume $1 is a directory to search for and navigate to
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