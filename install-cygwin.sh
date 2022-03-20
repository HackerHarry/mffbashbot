#!/bin/bash
# Install script for My Free Farm Bash Bot on Cygwin

LCONF=/etc/lighttpd/lighttpd.conf
LMODS=/etc/lighttpd/modules.conf
LCGICONF=/etc/lighttpd/conf.d/cgi.conf
BOTGUIROOT=/var/www/html/mffbashbot

# jq should be available if mffbashbot-setup.exe was used
if ! command -v jq &>/dev/null; then
 echo -e "jq could not be found. Cannot continue.\njq konnte nicht gefunden werden. Fortfahren nicht möglich."
 sleep 5
 exit 1
fi
JQBIN="$(command -v jq) -r"

cd
echo "Downloading My Free Farm Bash Bot..."
# just in case...
rm -f master.zip
rm -rf mffbashbot-master
wget -nv "https://github.com/HackerHarry/mffbashbot/archive/master.zip"

echo "Unpacking the archive..."
unzip -q master.zip
# make sure to preserve an existing directory at least once
if [ -d "mffbashbot" ]; then
 rm -rf mffbashbot.old
 mv mffbashbot mffbashbot.old
fi
mv mffbashbot-master mffbashbot
chmod +x mffbashbot/*.sh

echo "Configuring lighttpd..."
sed -i 's/var\.server_root = \"\/srv\/www\"/var\.server_root = \"\/var\/www\/html\"/' $LCONF
sed -i 's/server_root + \"\/htdocs\"/server_root/' $LCONF
sed -i 's/server\.username/#server\.username/' $LCONF
sed -i 's/server\.groupname/#server\.groupname/' $LCONF
sed -i 's/server\.event-handler/#server\.event-handler/' $LCONF
sed -i 's/server\.use-ipv6 = \"enable\"/server\.use-ipv6 = \"disable\"/' $LCONF
sed -i 's/server\.network-backend/#server\.network-backend/' $LCONF
sed -i 's/#include \"conf\.d\/cgi.conf\"/include \"conf\.d\/cgi.conf\"/' $LMODS
if ! grep -qe 'cgi\.assign\s\+=\s\+("\.php"' $LCGICONF; then
 echo '
server.modules += ( "mod_cgi" )
cgi.assign = (".php"=>"/usr/bin/php-cgi")
' >$LCGICONF
fi
mkdir -p /var/log/lighttpd 2>/dev/null
if ! grep -qe 'server\.stream-response-body\s\+=\s\+1' $LCONF; then
 echo "server.stream-response-body = 1" >>$LCONF
fi

echo "Moving GUI files..."
mkdir -p /var/www/html 2>/dev/null
if [ -d "$BOTGUIROOT" ]; then
 rm -rf ${BOTGUIROOT}.old
 mv $BOTGUIROOT ${BOTGUIROOT}.old
fi
mv mffbashbot/mffbashbot-GUI $BOTGUIROOT
chmod +x $BOTGUIROOT/script/*.sh

echo "Patching GUI files..."
sed -i 's/\/pi\//\/'$USER'\//' $BOTGUIROOT/config.php

cd
echo
echo "Creating bot start script..."
echo '#!/usr/bin/env bash
cd
/usr/sbin/lighttpd -f '$LCONF >startallbots.sh

chmod +x startallbots.sh
# create .screenrc
if [ ! -f ~/.screenrc ]; then
 echo 'hardstatus alwayslastline
hardstatus string "%{.bW}%-w%{.rW}%n %t%{-}%+w %=%{..G} %H %{..Y}"
defscrollback 5000' >~/.screenrc
fi
# set a larger font for mintty
# hmm. doesn't exist at run time :/
# sed -i 's/^FontHeight=[0-9]*$/FontHeight=14/' .minttyrc
# let's see if this helps
echo "FontHeight=14" >>.minttyrc
echo
/usr/sbin/lighttpd -f $LCONF
echo "Done! Start the bot with ./startallbots.sh after adding farms using your browser."
echo "Fertig! Starte den Bot mit ./startallbots.sh nach dem Hinzufuegen von Farmen im Browser."
sleep 5
