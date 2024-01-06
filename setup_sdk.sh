#!/bin/bash

MELOS_CONFIG="melos.yaml"
MAKEFILE="Makefile"

# Try running 'fvm flutter pub get' to check if FVM is properly configured
if fvm flutter pub get; then
    echo "FVM Flutter SDK is properly configured."

    # Use sed to set the sdkPath to '.fvm/flutter_sdk' in melos.yaml
    sed -i.bak 's|sdkPath: .*|sdkPath: .fvm/flutter_sdk|' "$MELOS_CONFIG" && rm "${MELOS_CONFIG}.bak"

    if [ $? -eq 0 ]; then
        echo " -> Successfully set sdkPath to .fvm/flutter_sdk in melos.yaml."
    else
        echo " -> Failed to set sdkPath in melos.yaml."
        exit 1
    fi

    # Use sed to set the FLUTTER variable to 'fvm flutter' in Makefile
    sed -i.bak 's|FLUTTER := .*|FLUTTER := fvm flutter|' "$MAKEFILE" && rm "${MAKEFILE}.bak"

    if [ $? -eq 0 ]; then
        echo " -> Successfully set FLUTTER to 'fvm flutter' in Makefile."
    else
        echo " -> Failed to set FLUTTER in Makefile."
        exit 1
    fi
   
    sed -i.bak 's|DART := .*|DART := fvm dart|' "$MAKEFILE" && rm "${MAKEFILE}.bak"

    if [ $? -eq 0 ]; then
        echo " -> Successfully set DART to 'fvm dart' in Makefile."
    else
        echo " -> Failed to set DART in Makefile."
        exit 1
    fi

else
    echo "FVM Flutter SDK not properly configured."

    # Use sed to replace the sdkPath with 'auto' in melos.yaml
    sed -i.bak 's|sdkPath: .*|sdkPath: auto|' "$MELOS_CONFIG" && rm "${MELOS_CONFIG}.bak"

    if [ $? -eq 0 ]; then
        echo " -> Successfully updated sdkPath to auto in melos.yaml."
    else
        echo " -> Failed to update sdkPath in melos.yaml."
        exit 1
    fi

    # Use sed to replace the FLUTTER with 'flutter' in Makefile
    sed -i.bak 's|FLUTTER := .*|FLUTTER := flutter|' "$MAKEFILE" && rm "${MAKEFILE}.bak"

    if [ $? -eq 0 ]; then
        echo " -> Successfully updated FLUTTER to 'flutter' in Makefile."
    else
        echo " -> Failed to update FLUTTER in Makefile."
        exit 1
    fi

    sed -i.bak 's|DART := .*|DART := dart|' "$MAKEFILE" && rm "${MAKEFILE}.bak"

    if [ $? -eq 0 ]; then
        echo " -> Successfully updated DART to 'dart' in Makefile."
    else
        echo " -> Failed to update DART in Makefile."
        exit 1
    fi

    flutter pub get
fi
