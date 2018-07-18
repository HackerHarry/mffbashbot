#!/bin/bash
# Install script for Harry's My Free Farm Bash Bot on Cygwin

LCONF=/etc/lighttpd/lighttpd.conf
LMODS=/etc/lighttpd/modules.conf
LCGICONF=/etc/lighttpd/conf.d/cgi.conf
BOTGUIROOT=/var/www/html/mffbashbot
STRINGS_en='{"strings":{"downloadingbot":{"text":"Downloading Harrys MFF Bash Bot..."},"unpackarc":{"text":"Unpacking the archive..."},"conflighttpd":{"text":"Configuring lighttpd..."},"movegui":{"text":"Moving GUI files..."},"patchgui":{"text":"Patching GUI files..."},"wannasetup":{"text":"If you do not wish for automatic bot setup, press CTRL-C now"},"enterfarm":{"text":"Please enter your farm name: "},"enterserver":{"text":"Please enter your server number: "},"enterpass":{"text":"Please enter your password for that farm: "},"gonnadothis":{"text":"This script will now set up your farm using this information:"},"farmname":{"text":"Farm name: "},"password":{"text":"Password: "},"isinfocorrect":{"text":"Is this info correct? (Y/N): "},"settingupfarm":{"text":"Setting up farm..."},"adjustini":{"text":"The preset language for this farm is GERMAN! Adjust it in config.ini."},"creatingscript":{"text":"Creating bot start script..."},"done":{"text":"Done!"}}}'
STRINGS_de='{"strings":{"downloadingbot":{"text":"Harrys MFF Bash Bot herunterladen..."},"unpackarc":{"text":"Archiv auspacken..."},"conflighttpd":{"text":"lighttpd konfigurieren..."},"movegui":{"text":"GUI Dateien verschieben..."},"patchgui":{"text":"GUI Dateien patchen..."},"wannasetup":{"text":"Falls du keine automatische Bot-Einrichtung wünschst, drücke jetzt STRG-C"},"enterfarm":{"text":"Bitte gib Deinen Farmnamen ein: "},"enterserver":{"text":"Bitte die passende Servernummer eingeben: "},"enterpass":{"text":"Bitte das Passwort für diese Farm eingeben: "},"gonnadothis":{"text":"Deine Farm wird mit diesen Daten angelegt:"},"farmname":{"text":"Farmname: "},"password":{"text":"Passwort: "},"isinfocorrect":{"text":"Sind die Infos korrekt? (J/N): "},"settingupfarm":{"text":"Farm einrichten..."},"adjustini":{"text":"Die voreingestellte Sprache für diese Farm ist DEUTSCH!"},"creatingscript":{"text":"Bot-Startskript erstellen..."},"done":{"text":"Fertig!"}}}'
STRINGS_bg='{"strings":{"osnotsupported":{"text":"Съжаляваме не поддържат версии на Debian по-високи от Jessie. Отмяна."},"instpackages":{"text":"Инсталиране на нужните пакети..."},"downloadingbot":{"text":"Изтегляне на бота на Хари..."},"unpackarc":{"text":"Разопаковане на архива..."},"settingpermissions":{"text":"Задаване на достъп..."},"conflighttpd":{"text":"Конфигурация на Web сървър-а..."},"nowebserveruser":{"text":"Потребителят на уеб сървър не можа да бъде определен. Не известна грешка!"},"settingupgui":{"text":"Настройка на графичните файлове..."},"settinguplogrotate":{"text":"Настройка на логовете..."},"wannasetup":{"text":"Ако не желаете автоматична настройка на бота, натиснете CTRL-C"},"enterfarm":{"text":"Въведете име на ферма:"},"enterserver":{"text":"Моля, изберете номер на сървър:"},"enterpass":{"text":"Моля, въведете парола за ферма:"},"gonnadothis":{"text":"Този скрипт ще настрои вашата ферма използвайки:"},"farmname":{"text":"ферма: "},"password":{"text":"Парола: "},"isinfocorrect":{"text":"Вярна ли е информацията? (Д/Н): "},"settingupfarm":{"text":"Настройка на ферма..."},"adjustini":{"text":"Предварителният език за тази ферма е НЕМСКИ!"},"creatingscript":{"text":"Създаване на стартиращ скрипт..."},"done":{"text":"Готово!"}}}'

# jq should be available if mffbashbot-setup.exe was used
if ! which jq >/dev/null 2>&1; then
 echo -e "jq could not be found. Cannot continue.\njq konnte nicht gefunden werden. Fortfahren nicht möglich."
 exit 1
fi
JQBIN="$(which jq) -r"

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
chmod +x mffbashbot/*.sh

getString conflighttpd
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

getString movegui
mkdir -p /var/www/html 2>/dev/null
if [ -d "$BOTGUIROOT" ]; then
 rm -rf ${BOTGUIROOT}.old
 mv $BOTGUIROOT ${BOTGUIROOT}.old
fi
mv mffbashbot/mffbashbot-GUI $BOTGUIROOT
chmod +x $BOTGUIROOT/script/*.sh

getString patchgui
sed -i 's/\/pi\//\/'$USER'\//' $BOTGUIROOT/config.php

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
/usr/sbin/lighttpd -f '$LCONF'
cd mffbashbot
./mffbashbot.sh '$FARMNAME >startallbots.sh
chmod +x startallbots.sh

echo
getString done
sleep 5
