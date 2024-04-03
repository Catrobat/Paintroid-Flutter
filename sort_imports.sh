#!/bin/bash

run_import_sorter() {
    echo "Running dart run import_sorter:main in $1..."
    cd "$1" || exit 1
    dart run import_sorter:main
    cd - > /dev/null
}

traverse_and_run_import_sorter() {
    local directory="$1"
    local subdirs=$(find "$directory" -type d)
    
    for subdir in $subdirs; do
        if [ -f "$subdir/pubspec.yaml" ]; then
            run_import_sorter "$subdir"
        fi
    done
}

directory="packages"
traverse_and_run_import_sorter "$directory"
