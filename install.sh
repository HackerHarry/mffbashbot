#!/bin/bash
# Install script for Harry's My Free Farm Bash Bot on GNU/Linux
# Tested on Debian Jessie, Stretch, Ubuntu 16.04.1 LTS
# and Bash on Windows 10 x64 Version 1703 Build 15063.0

if [ -f /etc/debian_version ]; then
 DVER=$(cat /etc/debian_version)
else
 echo "Sorry, only Debian Jessie and Stretch are supported for the time being. Bailing out."
 exit 1
fi
case $DVER in
 8.*|*essie*)
  PHPV=php5-cgi
  ;;
 9.*|*tretch*)
  PHPV=php-cgi
  ;;
esac
LCONF=/etc/lighttpd/lighttpd.conf

echo "Installing needed packages..."
sudo apt-get update
sudo apt-get install jq lighttpd $PHPV screen logrotate cron unzip nano

cd
echo "Downloading Harrys MFF Bash Bot..."
wget "https://github.com/HackerHarry/mffbashbot/archive/master.zip"

echo "Unpacking the archive..."
unzip -q master.zip
mv mffbashbot-master mffbashbot
chmod 775 mffbashbot
cd ~/mffbashbot
echo "Setting permissions..."
find . -type d -exec chmod 775 {} +
find . -type f -exec chmod 664 {} +
chmod +x *.sh

echo "Configuring lighttpd..."
if grep -q 'server\.document-root\s\+=\s\+"/var/www"' $LCONF; then
 sudo sed -i 's/server\.document-root\s\+=\s\+\"\/var\/www\"/server\.document-root = \"\/var\/www\/html\"/' $LCONF
 sudo mkdir -p /var/www/html
fi
HTTPUSER=$(grep server.username $LCONF | sed -e 's/.*= \"\(.*\)\"/\1/')
if [ -z "$HTTPUSER" ]; then
 echo "Webserver user could not be determined. Cannot continue."
 echo "Der Webserver-Benutzer konnte nicht ermittelt werden. Hier endet alles."
 exit 1
fi
sudo usermod -a -G $USER $HTTPUSER 2>/dev/null
echo '
fastcgi.server = ( ".php" => ((
                     "bin-path" => "/usr/bin/'$PHPV'",
                     "socket" => "/tmp/php.socket"
                 )))
# source of all modification in order to make php5 run under
# lighttpd http://www.howtoforge.com/lighttpd_mysql_php_debian_etch ' | sudo tee --append $LCONF > /dev/null

cd /etc/lighttpd/conf-enabled/
sudo ln -s ../conf-available/10-accesslog.conf 10-accesslog.conf
sudo ln -s ../conf-available/10-fastcgi.conf 10-fastcgi.conf
sudo /etc/init.d/lighttpd restart

echo "Setting up GUI files..."
cd ~/mffbashbot
sudo mv mffbashbot-GUI /var/www/html/mffbashbot
sudo chmod +x /var/www/html/mffbashbot/script/*.sh
sudo sed -i 's/\/pi\//\/'$USER'\//' /var/www/html/mffbashbot/gamepath.php
echo $HTTPUSER' ALL=(ALL) NOPASSWD: /bin/kill' | sudo tee /etc/sudoers.d/www-data-kill-cmd > /dev/null

echo "Setting up logrotate..."
echo '/home/'$USER'/mffbashbot/*/mffbot.log
{
        rotate 6
        daily
        su '$USER' '$USER'
        missingok
        notifempty
        delaycompress
        compress
} ' | sudo tee /etc/logrotate.d/mffbashbot > /dev/null

echo
echo "If you don't wish for automatic bot setup, press CTRL-C now"
echo "Falls du keine automatische Bot-Einrichtung wuenschst, druecke jetzt STRG-C"
while (true); do
 echo
 echo "Please enter your farm name:"
 read -p "Bitte gib Deinen Farmnamen ein: " FARMNAME
 echo "Please enter your server number:"
 read -p "Jetzt die Servernummer: " SERVER
 echo "Please enter your password for farm $FARMNAME on server #${SERVER}:"
 read -p "Und nun das Passwort der Farm $FARMNAME auf Server ${SERVER}: " PASSWORD
 echo
 echo "This script will now set up your farm using this information:"
 echo "Dieses Skript wird Deine Farm mit diesen Informationen anlegen: "
 echo "Farm name: $FARMNAME"
 echo "Server: ${SERVER}"
 echo "Password: $PASSWORD"
 echo
 echo "Is this info correct? (Y/N):"
 read -p "Sind die Infos korrekt? (J/N):" CONFIRM
 [[ "$CONFIRM" != "Y" ]] || break
 [[ "$CONFIRM" != "y" ]] || break
 [[ "$CONFIRM" != "J" ]] || break
 [[ "$CONFIRM" != "j" ]] || break
done

CFGFILE=config.ini
echo "Setting up farm..."
cd
mv mffbashbot/dummy mffbashbot/$FARMNAME
sed -i 's/server = 2/server = '$SERVER'/' mffbashbot/$FARMNAME/$CFGFILE
sed -i 's/password = \x27s3cRet!\x27/password = \x27'$PASSWORD'\x27/' mffbashbot/$FARMNAME/$CFGFILE
echo "Die voreingestellte Sprache fuer diese Farm ist DEUTSCH!"
echo "The preset language for this farm is GERMAN!"
sleep 5
echo
echo "Creating bot start script..."
echo '#!/bin/bash
cd
sudo /usr/sbin/lighttpd -f '$LCONF'
cd mffbashbot
./mffbashbot.sh '$FARMNAME >startallbots.sh
chmod +x startallbots.sh

echo
echo "Fertig! Starte Deinen Bot mit ./startallbots.sh"
echo "Done! Start your Bot with ./startallbots.sh"
sleep 5
