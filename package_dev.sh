#!/bin/sh
rm -rdf "${HOME}/Desktop/HandleiPad.ipa"

DATE=`date +%Y-%m-%d" "%H:%M`
targetName="HandleiPad_dev"
schemeName="HandleiPad_dev"
signName="Shanghai HANDOU Information Technology Co., Ltd"
provisionFile="c0bacfff-57f3-4d25-b649-af31b4500dfc.mobileprovision"

ipafile="${HOME}/Desktop/${schemeName}_${DATE}.ipa"

releaseDir="build/Release-iphoneos"
appfile="${releaseDir}/${targetName}.app"
provisionFullpath="${HOME}/Library/MobileDevice/Provisioning Profiles/$provisionFile"

# 拷贝渠道文件

echo "******start clean*******"
xcodebuild clean -target "$targetName" -configuration Release
rm -rdf "$releaseDir"
echo "******clean success"

echo "******start build******"
xcodebuild -project HandleiPad.xcodeproj -target "$targetName" -configuration Release  -sdk iphoneos build
echo "******build success******"


echo "******start package******"
/usr/bin/xcrun -sdk iphoneos -v PackageApplication -v "$appfile" -o "$ipafile"
echo "******package success******"

rm -rdf "build"

#unzip "$ipafile"
rm -rf Payload/ ${targetName}.app/_CodeSignature
cp provisionFullpath Payload/ ${targetName}.app/embedded.mobileprovision
#/usr/bin/codesign -f -s "iPhone Distribution: $signName" --resource-rules Payload/ ${targetName}.app/ResourceRules.plist Payload/ ${targetName}.app


#mv "$ipafile" "Handlecar.ipa"
