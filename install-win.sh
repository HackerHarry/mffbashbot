#!/bin/bash
# Install script for Harrys My Free Farm Bash Bot on Cygwin

LCONF=/etc/lighttpd/lighttpd.conf
LMODS=/etc/lighttpd/modules.conf
LCGICONF=/etc/lighttpd/conf.d/cgi.conf
BOTGUIROOT=/var/www/mffbashbot

cd
echo "Downloading Harrys MFF Bash Bot..."
rm -f master.zip 2>/dev/null
wget -nv --no-check-certificate "https://github.com/HackerHarry/mffbashbot/archive/master.zip"

echo "Unpacking the archive..."
unzip -q master.zip
mv mffbashbot-master mffbashbot
chmod +x mffbashbot/mffbashbot.sh

echo "Configuring lighttpd..."
sed -i 's/var\.server_root = \"\/srv\/www\"/var\.server_root = \"\/var\/www\"/' $LCONF
sed -i 's/server_root + \"\/htdocs\"/server_root/' $LCONF
sed -i 's/server\.username/#server\.username/' $LCONF
sed -i 's/server\.groupname/#server\.groupname/' $LCONF
sed -i 's/server\.event-handler/#server\.event-handler/' $LCONF
sed -i 's/server\.use-ipv6 = \"enable\"/server\.use-ipv6 = \"disable\"/' $LCONF
sed -i 's/server\.network-backend/#server\.network-backend/' $LCONF
sed -i 's/#include \"conf\.d\/cgi.conf\"/include \"conf\.d\/cgi.conf\"/' $LMODS
echo '
server.modules += ( "mod_cgi" )
cgi.assign = (".php"=>"/usr/bin/php-cgi")
' >$LCGICONF

echo "Moving GUI files..."
mkdir -p /var/www 2>/dev/null
mv mffbashbot/mffbashbot-GUI $BOTGUIROOT
chmod +x $BOTGUIROOT/script/logonandgetfarmdata.sh $BOTGUIROOT/script/wakeupthebot.sh

echo "Patching GUI files..."
sed -i 's/\/pi\//\/'$USER'\//' $BOTGUIROOT/gamepath.php

echo "Starting webserver lighttpd..."
mkdir -p /var/log/lighttpd 2>/dev/null
/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf

echo "Done!"
echo "Do not forget adjusting your game data in config.ini!"
