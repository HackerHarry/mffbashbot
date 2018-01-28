#!/bin/bash
# Install script for Harry's My Free Farm Bash Bot on Cygwin

LCONF=/etc/lighttpd/lighttpd.conf
LMODS=/etc/lighttpd/modules.conf
LCGICONF=/etc/lighttpd/conf.d/cgi.conf
BOTGUIROOT=/var/www/html/mffbashbot

cd
echo "Downloading Harrys MFF Bash Bot..."
rm -f master.zip 2>/dev/null
wget -nv "https://github.com/HackerHarry/mffbashbot/archive/master.zip"

echo "Unpacking the archive..."
unzip -q master.zip
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
echo '
server.modules += ( "mod_cgi" )
cgi.assign = (".php"=>"/usr/bin/php-cgi")
' >$LCGICONF
mkdir -p /var/log/lighttpd 2>/dev/null

echo "Moving GUI files..."
mkdir -p /var/www/html 2>/dev/null
mv mffbashbot/mffbashbot-GUI $BOTGUIROOT
chmod +x $BOTGUIROOT/script/logonandgetfarmdata.sh $BOTGUIROOT/script/wakeupthebot.sh

echo "Patching GUI files..."
sed -i 's/\/pi\//\/'$USER'\//' $BOTGUIROOT/gamepath.php

echo
echo "If you don't wish for automatic bot setup, press CTRL-C now"
echo "Ако не искате автоматична настройка на бота, натиснете CTRL+C"
echo "Falls du keine automatische Bot-Einrichtung wuenschst, druecke jetzt STRG-C"
while (true); do
 echo
 echo "Please enter your farm name:"
 echo "Въведете името на вашата ферма:"
 read -p "Bitte gib Deinen Farmnamen ein: " FARMNAME
 echo "Please enter your server number:"
 echo "Моля, въведете сървъра в който е вашата ферма:"
 read -p "Jetzt die Servernummer: " SERVER
 echo "Please enter your password for farm $FARMNAME on server #${SERVER}:"
 echo "Моля въведете паролата за ферма $FARMNAME на сървър #${SERVER}:"
 read -p "Und nun das Passwort der Farm $FARMNAME auf Server ${SERVER}: " PASSWORD
 echo
 echo "This script will now set up your farm using this information:"
 echo "Този скрипт ще настрои вашата ферма използвайки:"
 echo "Dieses Skript wird Deine Farm mit diesen Informationen anlegen: "
 echo "Farm name: $FARMNAME"
 echo "Server: ${SERVER}"
 echo "Password: $PASSWORD"
 echo
 echo "Is this info correct? (Y/N):"
 echo "Вярна ли е информацията? (Д/Н):"
 read -p "Sind die Infos korrekt? (J/N):" CONFIRM
 [[ "$CONFIRM" != "Y" ]] || break
 [[ "$CONFIRM" != "y" ]] || break
 [[ "$CONFIRM" != "J" ]] || break
 [[ "$CONFIRM" != "j" ]] || break
 [[ "$CONFIRM" != "Д" ]] || break
 [[ "$CONFIRM" != "д" ]] || break
done

CFGFILE=config.ini
echo "Setting up farm..."
cd
mv mffbashbot/dummy mffbashbot/$FARMNAME
sed -i 's/server = 2/server = '$SERVER'/' mffbashbot/$FARMNAME/$CFGFILE
sed -i 's/password = \x27s3cRet!\x27/password = \x27'$PASSWORD'\x27/' mffbashbot/$FARMNAME/$CFGFILE
echo "The preset language for this farm is GERMAN!"
echo "Предварителният език за тази ферма е НЕМСКИ!"
echo "Die voreingestellte Sprache fuer diese Farm ist DEUTSCH!"
sleep 5
echo
echo "Creating bot start script..."
echo '#!/bin/bash
cd
/usr/sbin/lighttpd -f '$LCONF'
cd mffbashbot
./mffbashbot.sh '$FARMNAME >startallbots.sh
chmod +x startallbots.sh

echo
echo "Done!"
echo "Готово!"
echo "Fertig!"
sleep 5
