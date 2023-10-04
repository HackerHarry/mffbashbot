#!/usr/bin/env bash
# Install script for My Free Farm Bash Bot on GNU/Linux
# Tested on Debian 8 - 12, Ubuntu 16.04.1 LTS, Linux Mint 19, Devuan 5
# and Bash on Windows 10 x64 Version 1703 Build 15063.0
set -e

echo "Running apt-get update..."
sudo apt-get -q update

if ! command -v jq &>/dev/null; then
 echo "Installing jq..."
 sudo apt-get -qq install jq
 if ! command -v jq &>/dev/null; then
  echo -e "jq could not be found. Cannot continue.\njq konnte nicht gefunden werden. Fortfahren nicht möglich."
  sleep 5
  exit 1
 fi
fi
JQBIN="$(command -v jq) -r"
if ! $JQBIN -nj . 2>/dev/null 1>&2; then
 echo -e "This version of jq seems to be too old. Make sure to include jessie-backports\nin your sources.list if you're using Debian Jessie. Cannot continue.\n"
 echo -e "Die jq Version scheint veraltet zu sein. Falls Du Debian Jessie benutzt, füge\nin der sources.list jessie-backports hinzu. Fortfahren nicht möglich."
 sleep 5
 exit 1
fi

if [ -f /etc/debian_version ]; then
 DVER=$(cat /etc/debian_version)
else
 echo "Sorry, only Debian Jessie, Stretch and Buster are supported for the time being. Bailing out."
 exit 1
fi
case $DVER in
 8.*|*essie*)
  PHPV=php5-cgi
  ;;
 9.*|10.*|11.*|12.*|*tretch*|*uster*|*ookworm*|*sid*)
  PHPV=php-cgi
  ;;
esac
LCONF=/etc/lighttpd/lighttpd.conf
BOTGUIROOT=/var/www/html/mffbashbot

echo "Installing needed packages..."
sudo apt-get -qq install lighttpd $PHPV screen logrotate cron unzip nano

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
chmod 775 mffbashbot
cd ~/mffbashbot
echo "Setting permissions..."
find . -type d -exec chmod 775 {} +
find . -type f -exec chmod 664 {} +
chmod +x *.sh
case $DVER in
 12.*|*ookworm*|*sid*)
  chmod g+rx ~
  ;;
esac

echo "Configuring lighttpd..."
if grep -q 'server\.document-root\s\+=\s\+"/var/www"' $LCONF; then
 sudo sed -i 's/server\.document-root\s\+=\s\+\"\/var\/www\"/server\.document-root = \"\/var\/www\/html\"/' $LCONF
 sudo mkdir -p /var/www/html
fi
HTTPUSER=$(grep server.username $LCONF | sed -e 's/.*= \"\(.*\)\"/\1/')
if [ -z "$HTTPUSER" ]; then
 echo "Webserver user could not be determined. Cannot continue."
 sleep 5
 exit 1
fi
sudo usermod -a -G $USER $HTTPUSER 2>/dev/null
if ! grep -q 'fastcgi\.server\s\+=\s\+(\s\+"\.php"' $LCONF; then
 echo '
fastcgi.server = ( ".php" => ((
                     "bin-path" => "/usr/bin/'$PHPV'",
                     "socket" => "/tmp/php.socket"
                 )))' | sudo tee --append $LCONF > /dev/null
fi
cd /etc/lighttpd/conf-enabled/
if [ ! -h 10-accesslog.conf ]; then
 sudo ln -s ../conf-available/10-accesslog.conf 10-accesslog.conf
fi
if [ ! -h 10-fastcgi.conf ]; then
 sudo ln -s ../conf-available/10-fastcgi.conf 10-fastcgi.conf
fi
if ! grep -q 'server\.stream-response-body\s\+=\s\+1' $LCONF; then
 echo "server.stream-response-body = 1" | sudo tee --append $LCONF > /dev/null
fi

sudo /etc/init.d/lighttpd restart

echo "Setting up GUI files..."
cd ~/mffbashbot
if [ -d "$BOTGUIROOT" ]; then
 rm -rf ${BOTGUIROOT}.old
 mv $BOTGUIROOT ${BOTGUIROOT}.old
fi
sudo mv mffbashbot-GUI $BOTGUIROOT
sudo chmod +x $BOTGUIROOT/script/*.sh
sudo sed -i 's/\/pi\//\/'$USER'\//' $BOTGUIROOT/config.php
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

cd
echo
echo "Creating bot start script..."
echo '#!/usr/bin/env bash
cd
sudo /etc/init.d/lighttpd start' >startallbots.sh

chmod 775 startallbots.sh
# create .screenrc
if [ ! -f ~/.screenrc ]; then
 echo 'hardstatus alwayslastline
hardstatus string "%{.bW}%-w%{.rW}%n %t%{-}%+w %=%{..G} %H %{..Y}"
defscrollback 5000' >~/.screenrc
fi
echo
echo "Done! Start the bot with ./startallbots.sh after adding farms using your browser."
echo "Fertig! Starte den Bot mit ./startallbots.sh nachdem Hinzufuegen von Farmen ueber den Browser."
sleep 5
