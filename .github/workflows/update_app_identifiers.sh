#!/bin/bash

PR_NUMBER=$1

MAIN_MANIFEST="android/app/src/main/AndroidManifest.xml"
DEBUG_MANIFEST="android/app/src/debug/AndroidManifest.xml"
PROFILE_MANIFEST="android/app/src/profile/AndroidManifest.xml"

if [ -f "$MAIN_MANIFEST" ]; then
  echo "Updating $MAIN_MANIFEST with PR number $PR_NUMBER"
  sed -i "s/package=\"org.catrobat.paintroid\"/package=\"org.catrobat.paintroid.pr$PR_NUMBER\"/" $MAIN_MANIFEST
  sed -i "s/android:label=\"Pocket Paint\"/android:label=\"Pocket Paint PR$PR_NUMBER\"/" $MAIN_MANIFEST
else
  echo "$MAIN_MANIFEST does not exist."
fi

if [ -f "$DEBUG_MANIFEST" ]; then
  echo "Updating $DEBUG_MANIFEST with PR number $PR_NUMBER"
  sed -i "s/package=\"org.catrobat.paintroid\"/package=\"org.catrobat.paintroid.pr$PR_NUMBER\"/" $DEBUG_MANIFEST
else
  echo "$DEBUG_MANIFEST does not exist."
fi

if [ -f "$PROFILE_MANIFEST" ]; then
  echo "Updating $PROFILE_MANIFEST with PR number $PR_NUMBER"
  sed -i "s/package=\"org.catrobat.paintroid\"/package=\"org.catrobat.paintroid.pr$PR_NUMBER\"/" $PROFILE_MANIFEST
else
  echo "$PROFILE_MANIFEST does not exist."
fi

INFO_PLIST="ios/Runner/Info.plist"
if [ -f "$INFO_PLIST" ]; then
  echo "Updating $INFO_PLIST with PR number $PR_NUMBER"
  xmlstarlet ed -L -u "/plist/dict/key[text()='CFBundleName']/following-sibling::string[1]" -v "paintroid PR$PR_NUMBER" $INFO_PLIST
  xmlstarlet ed -L -u "/plist/dict/key[text()='CFBundleDisplayName']/following-sibling::string[1]" -v "Pocket Paint PR$PR_NUMBER" $INFO_PLIST
  if ! xmlstarlet sel -t -c "/plist/dict/key[text()='CFBundleDisplayName']" $INFO_PLIST | grep -q 'CFBundleDisplayName'; then
    xmlstarlet ed -L -s "/plist/dict" -t elem -n "key" -v "CFBundleDisplayName" \
      -s "/plist/dict/key[last()]" -t elem -n "string" -v "Pocket Paint PR$PR_NUMBER" $INFO_PLIST
  fi
  xmlstarlet ed -L -u "/plist/dict/key[text()='CFBundleIdentifier']/following-sibling::string[1]" -v "org.catrobat.paintroidflutter.pr$PR_NUMBER" $INFO_PLIST
else
  echo "$INFO_PLIST does not exist."
fi
