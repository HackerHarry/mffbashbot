#!/bin/bash
# Install script for Harry's My Free Farm Bash Bot on GNU/Linux
# Tested on Debian Jessie, Stretch, Ubuntu 16.04.1 LTS
# and Bash on Windows 10 x64 Version 1703 Build 15063.0
set -e
STRINGS_en='{"strings":{"osnotsupported":{"text":"Sorry, only Debian Jessie and Stretch are supported for the time being. Bailing out."},"instpackages":{"text":"Installing needed packages..."},"downloadingbot":{"text":"Downloading Harrys MFF Bash Bot..."},"unpackarc":{"text":"Unpacking the archive..."},"settingpermissions":{"text":"Setting permissions..."},"conflighttpd":{"text":"Configuring lighttpd..."},"nowebserveruser":{"text":"Webserver user could not be determined. Cannot continue."},"settingupgui":{"text":"Setting up GUI files..."},"settinguplogrotate":{"text":"Setting up logrotate..."},"wannasetup":{"text":"If you do not wish for automatic bot setup, press CTRL-C now"},"enterfarm":{"text":"Please enter your farm name: "},"enterserver":{"text":"Please enter your server number: "},"enterpass":{"text":"Please enter your password for that farm: "},"gonnadothis":{"text":"This script will now set up your farm using this information:"},"farmname":{"text":"Farm name: "},"password":{"text":"Password: "},"isinfocorrect":{"text":"Is this info correct? (Y/N): "},"settingupfarm":{"text":"Setting up farm..."},"adjustini":{"text":"The preset language for this farm is GERMAN! Adjust it in config.ini."},"creatingscript":{"text":"Creating bot start script..."},"done":{"text":"Done! Start your Bot with ./startallbots.sh"}}}'
STRINGS_de='{"strings":{"osnotsupported":{"text":"Nur Debian Jessie and Stretch werden momentan unterstüzt. Abbruch."},"instpackages":{"text":"Benötigte Pakete installieren..."},"downloadingbot":{"text":"Harrys MFF Bash Bot herunterladen..."},"unpackarc":{"text":"Archiv auspacken..."},"settingpermissions":{"text":"Dateirechte setzen..."},"conflighttpd":{"text":"lighttpd konfigurieren..."},"nowebserveruser":{"text":"Der Webserver-Benutzer konnte nicht ermittelt werden. Hier endet alles."},"settingupgui":{"text":"GUI Dateien verarbeiten..."},"settinguplogrotate":{"text":"Logrotate einrichten..."},"wannasetup":{"text":"Falls du keine automatische Bot-Einrichtung wuenschst, druecke jetzt STRG-C"},"enterfarm":{"text":"Bitte gib Deinen Farmnamen ein: "},"enterserver":{"text":"Bitte die passende Servernummer eingeben: "},"enterpass":{"text":"Bitte das Passwort für diese Farm eingeben: "},"gonnadothis":{"text":"Deine Farm wird mit diesen Daten angelegt:"},"farmname":{"text":"Farmname: "},"password":{"text":"Passwort: "},"isinfocorrect":{"text":"Sind die Infos korrekt? (J/N): "},"settingupfarm":{"text":"Farm einrichten..."},"adjustini":{"text":"Die voreingestellte Sprache fuer diese Farm ist DEUTSCH!"},"creatingscript":{"text":"Bot-Startskript erstellen..."},"done":{"text":"Fertig! Starte Deinen Bot mit ./startallbots.sh"}}}'
STRINGS_bg='{"strings":{"osnotsupported":{"text":"Съжаляваме не поддържат версии на Debian по-високи от Jessie. Отмяна."},"instpackages":{"text":"Инсталиране на нужните пакети..."},"downloadingbot":{"text":"Изтегляне на бота на Хари..."},"unpackarc":{"text":"Разопаковане на архива..."},"settingpermissions":{"text":"Задаване на достъп..."},"conflighttpd":{"text":"Конфигурация на Web сървър-а..."},"nowebserveruser":{"text":"Потребителят на уеб сървър не можа да бъде определен. Не известна грешка!"},"settingupgui":{"text":"Настройка на графичните файлове..."},"settinguplogrotate":{"text":"Настройка на логовете..."},"wannasetup":{"text":"Ако не желаете автоматична настройка на бота, натиснете CTRL-C"},"enterfarm":{"text":"Въведете име на ферма:"},"enterserver":{"text":"Моля, изберете номер на сървър:"},"enterpass":{"text":"Моля, въведете парола за ферма:"},"gonnadothis":{"text":"Този скрипт ще настрои вашата ферма използвайки:"},"farmname":{"text":"ферма: "},"password":{"text":"Парола: "},"isinfocorrect":{"text":"Вярна ли е информацията? (Д/Н): "},"settingupfarm":{"text":"Настройка на ферма..."},"adjustini":{"text":"Предварителният език за тази ферма е НЕМСКИ!"},"creatingscript":{"text":"Създаване на стартиращ скрипт..."},"done":{"text":"Готово!"}}}'

echo "Running apt-get update..."
sudo apt-get -q update

if ! which jq >/dev/null 2>&1; then
 echo "Installing jq..."
 sudo apt-get -qq install jq
 if ! which jq >/dev/null 2>&1; then
  echo -e "jq could not be found. Cannot continue.\njq konnte nicht gefunden werden. Fortfahren nicht möglich."
  exit 1
 fi
fi
JQBIN="$(which jq) -r"
if ! $JQBIN -nj . 2>/dev/null 1>&2; then
 echo -e "This version of jq seems to be too old. Make sure to include jessie-backports\nin your sources.list if you're using Debian Jessie. Cannot continue.\n"
 echo -e "Die jq Version scheint veraltet zu sein. Falls Du Debian Jessie benutzt, füge\nin der sources.list jessie-backports hinzu. Fortfahren nicht möglich."
 exit 1
fi

while (true); do
 echo -e "\nInstallions-Sprache wählen"
 echo "Choose your install language"
 read -p "de = Deutsch, en = English, bg = Bulgarian -> " IL
 [[ "$IL" != "de" ]] || break
 [[ "$IL" != "en" ]] || break
 [[ "$IL" != "bg" ]] || break
done

TEXT=STRINGS_$IL
function getString {
 # 1 = text, 2 = parameter
 # indirect parameter expansion
 echo ${!TEXT} | $JQBIN $2 '.strings.'$1'.text'
}

if [ -f /etc/debian_version ]; then
 DVER=$(cat /etc/debian_version)
else
 getString osnotsupported
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
BOTGUIROOT=/var/www/html/mffbashbot

getString instpackages
sudo apt-get -qq install lighttpd $PHPV screen logrotate cron unzip nano

cd
getString downloadingbot
# just in case...
rm -f master.zip
rm -rf mffbashbot-master
wget -nv "https://github.com/HackerHarry/mffbashbot/archive/master.zip"

getString unpackarc
unzip -q master.zip
# make sure to preserve an existing directory at least once
if [ -d "mffbashbot" ]; then
 rm -rf mffbashbot.old
 mv mffbashbot mffbashbot.old
fi
mv mffbashbot-master mffbashbot
chmod 775 mffbashbot
cd ~/mffbashbot
getString settingpermissions
find . -type d -exec chmod 775 {} +
find . -type f -exec chmod 664 {} +
chmod +x *.sh

getString conflighttpd
if grep -q 'server\.document-root\s\+=\s\+"/var/www"' $LCONF; then
 sudo sed -i 's/server\.document-root\s\+=\s\+\"\/var\/www\"/server\.document-root = \"\/var\/www\/html\"/' $LCONF
 sudo mkdir -p /var/www/html
fi
HTTPUSER=$(grep server.username $LCONF | sed -e 's/.*= \"\(.*\)\"/\1/')
if [ -z "$HTTPUSER" ]; then
 getString nowebserveruser
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

getString settingupgui
cd ~/mffbashbot
# force the move ? hmm..
sudo mv mffbashbot-GUI $BOTGUIROOT
sudo chmod +x $BOTGUIROOT/script/*.sh
sudo sed -i 's/\/pi\//\/'$USER'\//' $BOTGUIROOT/gamepath.php
echo $HTTPUSER' ALL=(ALL) NOPASSWD: /bin/kill' | sudo tee /etc/sudoers.d/www-data-kill-cmd > /dev/null

getString settinguplogrotate
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
getString wannasetup
while (true); do
 echo
 # -j suppresses new line
 getString enterfarm -j
 read FARMNAME
 getString enterserver -j
 read SERVER
 getString enterpass -j
 read PASSWORD
 echo
 getString gonnadothis
 getString farmname -j
 echo $FARMNAME
 echo "Server: ${SERVER}"
 getString password -j
 echo $PASSWORD
 echo
 getString isinfocorrect -j
 read CONFIRM
 [[ "$CONFIRM" != "Y" ]] || break
 [[ "$CONFIRM" != "y" ]] || break
 [[ "$CONFIRM" != "J" ]] || break
 [[ "$CONFIRM" != "j" ]] || break
 [[ "$CONFIRM" != "Д" ]] || break
 [[ "$CONFIRM" != "д" ]] || break
done

CFGFILE=config.ini
getString settingupfarm
cd
mv mffbashbot/dummy mffbashbot/$FARMNAME
sed -i 's/server = 2/server = '$SERVER'/' mffbashbot/$FARMNAME/$CFGFILE
sed -i 's/password = \x27s3cRet!\x27/password = \x27'$PASSWORD'\x27/' mffbashbot/$FARMNAME/$CFGFILE
getString adjustini
sleep 5
echo
getString creatingscript
echo '#!/bin/bash
cd
sudo /etc/init.d/lighttpd start
cd mffbashbot
./mffbashbot.sh '$FARMNAME >startallbots.sh
chmod +x startallbots.sh

echo
getString done
sleep 5
