#!/bin/sh

echo "package for Production_dev"
#cp ./package_env/3.0/HDAppEnvDefine.h ./Handlecar/
echo "-----------copy success----------"

. package_dev.sh
for((i=1;i<15;i++));
do
echo "\a"
done

#scp -r "Handlecar.ipa" root@121.199.30.58:/var/www/html/projects/3_0
#scp -r ${HOME}/Desktop/Handlecargsc.ipa root@www.handlecar-oms.com:/usr/share/nginx/html/appfile/test/Handlecar/
