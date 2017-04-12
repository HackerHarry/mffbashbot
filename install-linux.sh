#!/bin/bash
# Install script for Harrys My Free Farm Bash Bot on GNU/Linux
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

echo "Installing needed packages..."
sudo apt-get install jq lighttpd $PHPV screen logrotate cron unzip nano

cd
echo "Downloading Harrys MFF Bash Bot..."
wget --no-check-certificate "https://github.com/HackerHarry/mffbashbot/archive/master.zip"

echo "Unpacking the archive..."
unzip master.zip
mv mffbashbot-master mffbashbot
cd ~/mffbashbot
echo "Setting permissions..."
find . -type d -exec chmod 775 {} +
find . -type f -exec chmod 664 {} +
chmod +x mffbashbot.sh

echo "Configuring lighttpd..."
HTTPUSER=$(grep server.username /etc/lighttpd/lighttpd.conf | sed -e 's/.*= \"\(.*\)\"/\1/')
if [ -z "$HTTPUSER" ]; then
 echo "Webserver user could not be determined. Please set it manually."
 echo "Der Webserver-Benutzer konnte nicht ermittelt werden. Bitte manuell anpassen."
fi
sudo usermod -a -G $USER $HTTPUSER 2>/dev/null
echo '
fastcgi.server = ( ".php" => ((
                     "bin-path" => "/usr/bin/'$PHPV'",
                     "socket" => "/tmp/php.socket"
                 )))
# source of all modification in order to make php5 run under
# lighttpd http://www.howtoforge.com/lighttpd_mysql_php_debian_etch ' | sudo tee --append /etc/lighttpd/lighttpd.conf > /dev/null

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
echo "Don't forget configuring your bot. Keep in mind jq v1.5 or higher is needed!"
echo "Nicht vergessen, den Bot zu konfigurieren und dass mind. jq v1.5 benoetigt wird!"
