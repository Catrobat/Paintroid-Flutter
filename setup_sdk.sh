#!/bin/bash

# Path to the .fvm/flutter_sdk directory
FVM_SDK_PATH=".fvm/flutter_sdk"

# Path to the melos.yaml file
MELOS_CONFIG="melos.yaml"

# Check if the .fvm/flutter_sdk directory exists
if [ -d "$FVM_SDK_PATH" ]; then
    echo "FVM Flutter SDK found."
else
    echo "FVM Flutter SDK not found. Setting sdkPath to auto in melos.yaml."

    # Use sed to replace the sdkPath with 'auto' in melos.yaml
    # For compatibility across different systems (like macOS and Linux)
    sed -i.bak 's|sdkPath: .*|sdkPath: auto|' "$MELOS_CONFIG" && rm "${MELOS_CONFIG}.bak"

    if [ $? -eq 0 ]; then
        echo "Successfully updated sdkPath in melos.yaml."
    else
        echo "Failed to update sdkPath in melos.yaml."
        exit 1
    fi
fi
