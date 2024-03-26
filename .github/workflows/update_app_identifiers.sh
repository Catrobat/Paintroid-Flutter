
PR_NUMBER=$1

ANDROID_MANIFEST="android/app/src/main/AndroidManifest.xml"
sed -i "s/android:label=\"Pocket Paint\"/android:label=\"Pocket Paint PR$PR_NUMBER\"/" $ANDROID_MANIFEST
sed -i "s/package=\"org.catrobat.paintroid\"/package=\"org.catrobat.paintroid.pr$PR_NUMBER\"/" $ANDROID_MANIFEST

INFO_PLIST="ios/Runner/Info.plist"
xmlstarlet ed -L -u "/plist/dict/key[text()='CFBundleName']/following-sibling::string[1]" -v "paintroid PR$PR_NUMBER" $INFO_PLIST
xmlstarlet ed -L -u "/plist/dict/key[text()='CFBundleIdentifier']/following-sibling::string[1]" -v "org.catrobat.paintroidflutter.pr$PR_NUMBER" $INFO_PLIST
