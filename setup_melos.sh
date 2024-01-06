#!/bin/bash

# Check if the 'melos' command is available
if ! command -v melos &> /dev/null; then
    echo "Melos is not installed. Installing Melos globally using Dart."
    dart pub global activate melos

    if [ $? -eq 0 ]; then
        echo "Successfully installed Melos."
    else
        echo "Failed to install Melos."
        exit 1
    fi
fi