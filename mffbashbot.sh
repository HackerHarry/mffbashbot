#!/usr/bin/env bash
# shellcheck disable=SC2086,SC2155
#
# My Free Farm Bash Bot
# Copyright 2016-24 Harry Basalamah
#
# For license see LICENSE file

# variable 1 is mandatory
: ${1:?No MFF username provided}
cd $1 || exit 1

# variables
VERSION=$(cat ../version.txt)
LOGFILE=mffbot.log
OUTFILE=mffbottemp.html
COOKIEFILE=mffcookies.txt
FARMDATAFILE=farmdata.txt
LASTRUNFILE=lastrun.txt
LASTERRORFILE=lasterror.txt
STATUSFILE=isactive.txt
CFGFILE=config.ini
PIDFILE=bashpid.txt
JQBIN=$(command -v jq)
USCRIPTURL="https://raw.githubusercontent.com/HackerHarry/mffbashbot/master/update.sh"
UTMPFILE=/tmp/mffbot-update.sh
DONKEYCLAIMED=0
MFFUSER=$1
PAUSECORRECTEDAT=0
TIMEDELTA=0
CURRENTEPOCH=0
SKIPQUEUEUPDATE=0
WORKERQUEUE=0
LOGOFFTHRESHOLD=30
ERRCOUNT=0
TMPFILE=/tmp/${MFFUSER}-$$
# get server, password & language
MFFPASS=$(grep password $CFGFILE | tr -d "'")
MFFSERVER=$(grep server $CFGFILE)
MFFLANG=$(grep lang $CFGFILE | tr -d "'")
# let's just hope IFS is a white space ;)
set -- $MFFPASS
: ${3:?No MFF password found in $CFGFILE}
MFFPASS=$3
set -- $MFFSERVER
: ${3:?No MFF server-no. found in $CFGFILE}
MFFSERVER=$3
set -- $MFFLANG
: ${3:?No MFF language found in $CFGFILE}
MFFLANG=$3
case "$MFFLANG" in
 en) DOMAIN=myfreefarm.com
         ;;
 bg) DOMAIN=veselaferma.com
         ;;
 pl) DOMAIN=wolnifarmerzy.pl
         ;;
  *) DOMAIN=myfreefarm.de
         ;;
esac
# shellcheck disable=SC2089,SC2034
# SC2089 doesn't apply. the data is used solely by jq
aDIM_X='{"0":"0","1":"2","2":"2","3":"2","4":"2","5":"2","6":"2","7":"2","8":"2","9":"1","10":"1","11":"1","12":"1","13":"1","14":"1","15":"1","16":"1","17":"1","18":"1","19":"1","20":"1","21":"1","22":"1","23":"1","24":"1","25":"1","26":"1","27":"1","28":"1","29":"2","30":"1","31":"1","32":"1","33":"1","34":"1","35":"1","36":"2","37":"2","38":"1","39":"2","40":"2","41":"2","42":"2","43":"2","44":"1","91":"1","92":"1","93":"1","97":"1","45":"2","46":"1","47":"2","48":"2","49":"2","50":"1","51":"1","52":"2","53":"2","54":"2","55":"1","56":"2","57":"2","58":"2","59":"2","60":"2","61":"2","62":"2","63":"2","64":"2","65":"1","66":"2","67":"2","68":"1","69":"2","70":"2","71":"2","72":"2","73":"1","74":"1","75":"1","76":"2","77":"2","78":"2","79":"2","80":"2","81":"2","82":"2","83":"2","84":"2","85":"1","86":"1","87":"2","88":"2","89":"1","90":"2","94":"2","95":"2","96":"1","98":"2","99":"2","100":"2","101":"2","102":"2","103":"2","104":"1","105":"1","106":"2","107":"1","108":"2","109":"2","110":"1","111":"1","112":"1","113":"1","114":"2","115":"2","116":"1","117":"1","118":"1","119":"1","120":"1","121":"1","122":"1","123":"1","124":"1","125":"1","126":"1","127":"2","128":"2","129":"2","130":"1","131":"1","132":"1","133":"1","134":"1","135":"1","136":"1","137":"1","138":"1","139":"1","140":"1","141":"1","142":"1","143":"1","144":"1","145":"1","146":"1","147":"1","148":"1","149":"1","150":"1","151":"1","152":"1","153":"2","154":"2","155":"1","156":"1","157":"1","158":"2","159":"1","160":"1","161":"1","162":"1","163":"1","164":"1","165":"1","166":"1","167":"1","168":"1","169":"1","170":"1","171":"1","172":"1","173":"1","174":"1","175":"1","176":"1","177":"1","178":"1","179":"1","180":"1","181":"1","182":"1","183":"1","184":"1","185":"1","186":"1","187":"1","188":"1","189":"1","200":"1","201":"1","202":"1","203":"1","204":"1","205":"1","206":"1","207":"1","208":"1","209":"1","210":"1","211":"1","212":"1","213":"1","214":"1","215":"1","216":"1","217":"1","218":"1","219":"1","220":"1","221":"1","250":"1","251":"1","252":"1","253":"1","254":"1","255":"1","256":"1","257":"1","258":"1","259":"1","260":"1","261":"1","262":"1","263":"1","264":"1","265":"1","266":"1","267":"1","268":"1","269":"1","270":"1","271":"1","272":"1","273":"1","274":"1","275":"1","276":"1","300":"1","301":"1","302":"1","303":"1","304":"1","305":"1","306":"1","307":"1","308":"1","309":"1","310":"1","311":"1","312":"1","313":"1","314":"1","315":"1","316":"1","317":"1","318":"1","319":"1","320":"1","321":"1","322":"1","323":"1","324":"1","325":"1","326":"1","327":"1","328":"1","329":"1","330":"1","331":"1","332":"1","333":"1","334":"1","335":"1","336":"1","337":"1","338":"1","339":"1","340":"1","341":"1","342":"1","343":"1","344":"1","345":"1","346":"1","347":"1","348":"1","349":"1","350":"0","351":"2","352":"2","353":"2","354":"2","355":"1","356":"2","357":"1","358":"2","359":"2","360":"2","361":"2","400":"1","401":"1","402":"1","403":"1","450":"1","451":"1","452":"1","453":"1","454":"1","455":"1","456":"1","457":"1","458":"1","459":"1","460":"1","461":"1","462":"1","463":"1","464":"1","465":"1","466":"1","467":"1","468":"1","469":"1","470":"1","471":"1","472":"1","473":"1","474":"1","475":"1","476":"1","477":"1","478":"1","479":"1","480":"1","481":"1","482":"1","483":"1","550":"2","551":"2","552":"2","553":"2","554":"2","555":"2","556":"1","557":"2","558":"2","559":"2","560":"2","561":"2","562":"2","563":"2","600":"1","601":"1","602":"1","603":"1","604":"1","605":"1","606":"1","607":"1","608":"1","609":"1","630":"1","631":"1","632":"1","633":"1","634":"1","635":"1","636":"1","637":"1","638":"1","639":"1","660":"1","661":"1","662":"1","663":"1","664":"1","665":"1","666":"1","667":"1","668":"1","669":"1","700":"2","701":"1","702":"2","703":"2","704":"2","705":"1","706":"2","707":"2","708":"2","709":"2","750":"1","751":"1","752":"1","753":"1","754":"1","755":"1","756":"1","757":"1","758":"1","759":"1","804":"1","801":"1","800":"1","805":"1","802":"1","807":"1","803":"1","809":"1","806":"1","810":"1","808":"1","812":"1","811":"1","813":"1","815":"1","814":"1","816":"1","818":"1","817":"1","819":"1","820":"1","821":"1","822":"1","823":"1","824":"1","825":"1","826":"1","827":"1","828":"1","829":"2","830":"1","831":"1","832":"2","833":"1","834":"1","900":"1","901":"1","902":"1","903":"1","904":"1","905":"1","906":"1","907":"1","908":"1","909":"1","910":"1","911":"1","912":"1","913":"1","914":"1","915":"1","916":"1","917":"1","918":"1","919":"1","920":"1","921":"1","922":"1","923":"1","945":"1","946":"1","947":"1","948":"1","950":"2","951":"2","952":"2","953":"2","954":"1","955":"1","956":"1","957":"1","970":"1","971":"1","972":"1","973":"1","974":"1","975":"1","976":"1","977":"1","978":"1","979":"1","980":"1","981":"1","982":"1","983":"1","984":"1","985":"1","1000":"1","1001":"1","1002":"1","1003":"1","1004":"1","1005":"1","1006":"1","1007":"1","1100":"2","1101":"2","1102":"2","1103":"1","1104":"2","1105":"2","1106":"1","1107":"1","1108":"1","1109":"1","1110":"1","1111":"1","1112":"1","1113":"1","1114":"1","1115":"1","1116":"1","1117":"1","1118":"1","1119":"1","1120":"1","1121":"1","1122":"1","1123":"1","1124":"1","1125":"1","1126":"1"}'
# shellcheck disable=SC2089,SC2034
aDIM_Y='{"0":"0","1":"1","2":"2","3":"1","4":"2","5":"2","6":"2","7":"2","8":"2","9":"1","10":"1","11":"1","12":"1","13":"1","14":"1","15":"1","16":"1","17":"1","18":"1","19":"1","20":"1","21":"1","22":"1","23":"1","24":"1","25":"1","26":"1","27":"1","28":"1","29":"1","30":"1","31":"1","32":"1","33":"1","34":"1","35":"1","36":"2","37":"2","38":"1","39":"2","40":"2","41":"2","42":"2","43":"2","44":"1","91":"1","92":"1","93":"1","97":"1","45":"2","46":"1","47":"2","48":"1","49":"2","50":"1","51":"1","52":"2","53":"2","54":"1","55":"1","56":"2","57":"2","58":"1","59":"2","60":"2","61":"2","62":"1","63":"1","64":"1","65":"1","66":"1","67":"2","68":"1","69":"1","70":"1","71":"1","72":"1","73":"1","74":"1","75":"1","76":"2","77":"2","78":"2","79":"2","80":"1","81":"2","82":"1","83":"1","84":"1","85":"1","86":"1","87":"1","88":"2","89":"1","90":"2","94":"1","95":"2","96":"1","98":"2","99":"1","100":"2","101":"2","102":"2","103":"2","104":"1","105":"1","106":"2","107":"1","108":"2","109":"1","110":"1","111":"1","112":"1","113":"1","114":"1","115":"1","116":"1","117":"1","118":"1","119":"1","120":"1","121":"1","122":"1","123":"1","124":"1","125":"1","126":"1","127":"2","128":"2","129":"2","130":"1","131":"1","132":"1","133":"1","134":"1","135":"1","136":"1","137":"1","138":"1","139":"1","140":"1","141":"1","142":"1","143":"1","144":"1","145":"1","146":"1","147":"1","148":"1","149":"1","150":"1","151":"1","152":"1","153":"1","154":"2","155":"1","156":"1","157":"1","158":"1","159":"1","160":"1","161":"1","162":"1","163":"1","164":"1","165":"1","166":"1","167":"1","168":"1","169":"1","170":"1","171":"1","172":"1","173":"1","174":"1","175":"1","176":"1","177":"1","178":"1","179":"1","180":"1","181":"1","182":"1","183":"1","184":"1","185":"1","186":"1","187":"1","188":"1","189":"1","200":"1","201":"1","202":"1","203":"1","204":"1","205":"1","206":"1","207":"1","208":"1","209":"1","210":"1","211":"1","212":"1","213":"1","214":"1","215":"1","216":"1","217":"1","218":"1","219":"1","220":"1","221":"1","250":"1","251":"1","252":"1","253":"1","254":"1","255":"1","256":"1","257":"1","258":"1","259":"1","260":"1","261":"1","262":"1","263":"1","264":"1","265":"1","266":"1","267":"1","268":"1","269":"1","270":"1","271":"1","272":"1","273":"1","274":"1","275":"1","276":"1","300":"1","301":"1","302":"1","303":"1","304":"1","305":"1","306":"1","307":"1","308":"1","309":"1","310":"1","311":"1","312":"1","313":"1","314":"1","315":"1","316":"1","317":"1","318":"1","319":"1","320":"1","321":"1","322":"1","323":"1","324":"1","325":"1","326":"1","327":"1","328":"1","329":"1","330":"1","331":"1","332":"1","333":"1","334":"1","335":"1","336":"1","337":"1","338":"1","339":"1","340":"1","341":"1","342":"1","343":"1","344":"1","345":"1","346":"1","347":"1","348":"1","349":"1","350":"0","351":"1","352":"1","353":"2","354":"2","355":"1","356":"2","357":"1","358":"2","359":"2","360":"1","361":"2","400":"1","401":"1","402":"1","403":"1","450":"1","451":"1","452":"1","453":"1","454":"1","455":"1","456":"1","457":"1","458":"1","459":"1","460":"1","461":"1","462":"1","463":"1","464":"1","465":"1","466":"1","467":"1","468":"1","469":"1","470":"1","471":"1","472":"1","473":"1","474":"1","475":"1","476":"1","477":"1","478":"1","479":"1","480":"1","481":"1","482":"1","483":"1","550":"2","551":"2","552":"2","553":"1","554":"2","555":"1","556":"1","557":"2","558":"2","559":"2","560":"2","561":"2","562":"2","563":"2","600":"1","601":"1","602":"1","603":"1","604":"1","605":"1","606":"1","607":"1","608":"1","609":"1","630":"1","631":"1","632":"1","633":"1","634":"1","635":"1","636":"1","637":"1","638":"1","639":"1","660":"1","661":"1","662":"1","663":"1","664":"1","665":"1","666":"1","667":"1","668":"1","669":"1","700":"2","701":"1","702":"1","703":"2","704":"1","705":"1","706":"2","707":"1","708":"2","709":"2","750":"1","751":"1","752":"1","753":"1","754":"1","755":"1","756":"1","757":"1","758":"1","759":"1","804":"1","801":"1","800":"1","805":"1","802":"1","807":"1","803":"1","809":"1","806":"1","810":"1","808":"1","812":"1","811":"1","813":"1","815":"1","814":"1","816":"1","818":"1","817":"1","819":"1","820":"1","821":"1","822":"1","823":"1","824":"1","825":"1","826":"1","827":"1","828":"1","829":"1","830":"1","831":"1","832":"2","833":"1","834":"1","900":"1","901":"1","902":"1","903":"1","904":"1","905":"1","906":"1","907":"1","908":"1","909":"1","910":"1","911":"1","912":"1","913":"1","914":"1","915":"1","916":"1","917":"1","918":"1","919":"1","920":"1","921":"1","922":"1","923":"1","945":"1","946":"1","947":"1","948":"1","950":"1","951":"2","952":"1","953":"1","954":"1","955":"1","956":"1","957":"1","970":"1","971":"1","972":"1","973":"1","974":"1","975":"1","976":"1","977":"1","978":"1","979":"1","980":"1","981":"1","982":"1","983":"1","984":"1","985":"1","1000":"1","1001":"1","1002":"1","1003":"1","1004":"1","1005":"1","1006":"1","1007":"1","1100":"1","1101":"2","1102":"2","1103":"1","1104":"2","1105":"2","1106":"1","1107":"1","1108":"1","1109":"1","1110":"1","1111":"1","1112":"1","1113":"1","1114":"1","1115":"1","1116":"1","1117":"1","1118":"1","1119":"1","1120":"1","1121":"1","1122":"1","1123":"1","1124":"1","1125":"1","1126":"1"}'
# dimension data can be extracted from .../js/jsconstants_xxxxxx.js
# shellcheck disable=SC2089,SC2034
aCAT='{"0":"","1":"v","2":"v","3":"v","4":"v","5":"v","6":"v","7":"v","8":"v","9":"e","10":"e","11":"e","12":"e","13":"u","14":"u","15":"u","16":"u","17":"v","18":"v","19":"v","20":"v","21":"v","22":"v","23":"v","24":"v","25":"e","26":"v","27":"e","28":"e","29":"v","30":"e","31":"v","32":"v","33":"v","34":"v","35":"v","36":"v","37":"v","38":"v","39":"v","40":"v","41":"v","42":"v","43":"v","44":"v","91":"e","92":"e","93":"e","97":"v","45":"z","46":"z","47":"z","48":"z","49":"z","50":"z","51":"z","52":"z","53":"z","54":"z","55":"z","56":"z","57":"z","58":"z","59":"z","60":"z","61":"z","62":"z","63":"z","64":"z","65":"z","66":"z","67":"z","68":"z","69":"z","70":"z","71":"z","72":"z","73":"z","74":"z","75":"z","76":"z","77":"z","78":"z","79":"z","80":"z","81":"z","82":"z","83":"z","84":"z","85":"z","86":"z","87":"z","88":"z","89":"z","90":"z","94":"z","95":"z","96":"z","98":"z","99":"z","100":"z","101":"z","102":"z","103":"z","104":"v","105":"z","106":"z","107":"v","108":"v","109":"v","110":"e","111":"e","112":"v","113":"v","114":"v","115":"v","116":"o","117":"o","118":"o","119":"o","120":"o","121":"o","122":"o","123":"o","124":"o","125":"o","126":"v","127":"v","128":"v","129":"v","130":"fw","131":"fw","132":"fw","133":"fw","134":"fw","135":"fw","136":"fw","137":"fw","138":"fw","139":"fw","140":"fw","141":"fw","142":"fw","143":"fw","144":"e","145":"fw","146":"fw","147":"fw","148":"fw","149":"fw","150":"fw","151":"e","152":"e","153":"v","154":"v","155":"e","156":"e","157":"e","158":"v","159":"e","160":"e","161":"fw","162":"fw","163":"fw","164":"fw","165":"fw","166":"fw","167":"fw","168":"fw","169":"fw","170":"fw","171":"fl","172":"fl","173":"fl","174":"fl","175":"fl","176":"fl","177":"fl","178":"fl","179":"fl","180":"fl","181":"fl","182":"fl","183":"fl","184":"fl","185":"fl","186":"fl","187":"fl","188":"fl","189":"fl","200":"fla","201":"fla","202":"fla","203":"fla","204":"fla","205":"fla","206":"fla","207":"fla","208":"fla","209":"fla","210":"fla","211":"fla","212":"fla","213":"fla","214":"fla","215":"fla","216":"fla","217":"fla","218":"fla","219":"fla","220":"fla","221":"fla","250":"hr","251":"hr","252":"hr","253":"hr","254":"hr","255":"hr","256":"hr","257":"hr","258":"hr","259":"hr","260":"hr","261":"hr","262":"hr","263":"hr","264":"hr","265":"hr","266":"hr","267":"hr","268":"hr","269":"hr","270":"hr","271":"hr","272":"hr","273":"hr","274":"hr","275":"hr","276":"hr","300":"md","301":"md","302":"md","303":"md","304":"md","305":"md","306":"md","307":"md","308":"md","309":"md","310":"md","311":"md","312":"md","313":"md","314":"md","315":"md","316":"md","317":"md","318":"md","319":"md","320":"md","321":"md","322":"md","323":"md","324":"md","325":"md","326":"md","327":"md","328":"md","329":"md","330":"md","331":"md","332":"md","333":"md","334":"md","335":"md","336":"md","337":"md","338":"md","339":"md","340":"md","341":"md","342":"md","343":"md","344":"md","345":"md","346":"md","347":"md","348":"md","349":"md","350":"e","351":"ex","352":"ex","353":"ex","354":"ex","355":"ex","356":"ex","357":"ex","358":"ex","359":"ex","360":"ex","361":"ex","400":"md","401":"md","402":"md","403":"md","450":"fw","451":"fw","452":"fw","453":"fw","454":"fw","455":"fw","456":"fw","457":"fw","458":"fw","459":"fw","460":"fw","461":"fw","462":"fw","463":"fw","464":"fw","465":"fw","466":"fw","467":"fw","468":"fw","469":"fw","470":"fw","471":"fw","472":"fw","473":"fw","474":"fw","475":"fw","476":"fw","477":"fw","478":"fw","479":"fw","480":"fw","481":"fw","482":"fw","483":"fw","550":"z","551":"z","552":"z","553":"z","554":"z","555":"z","556":"z","557":"z","558":"z","559":"z","560":"z","561":"z","562":"z","563":"z","600":"breed","601":"breed","602":"breed","603":"breed","604":"breed","605":"breed","606":"breed","607":"breed","608":"breed","609":"breed","630":"breed","631":"breed","632":"breed","633":"breed","634":"breed","635":"breed","636":"breed","637":"breed","638":"breed","639":"breed","660":"breed","661":"breed","662":"breed","663":"breed","664":"breed","665":"breed","666":"breed","667":"breed","668":"breed","669":"breed","700":"alpin","701":"alpin","702":"alpin","703":"alpin","704":"alpin","705":"alpin","706":"alpin","707":"alpin","708":"alpin","709":"alpin","750":"tea","751":"tea","752":"tea","753":"tea","754":"tea","755":"tea","756":"tea","757":"tea","758":"tea","759":"tea","804":"cow","801":"cow","800":"cow","805":"cow","802":"cow","807":"cow","803":"cow","809":"cow","806":"cow","810":"cow","808":"cow","812":"cow","811":"cow","813":"cow","815":"cow","814":"cow","816":"cow","818":"cow","817":"cow","819":"cow","820":"e","821":"e","822":"e","823":"e","824":"e","825":"v","826":"v","827":"v","828":"v","829":"v","830":"v","831":"v","832":"v","833":"v","834":"v","900":"fish","901":"fish","902":"fish","903":"fish","904":"fish","905":"fish","906":"fish","907":"fish","908":"fish","909":"fish","910":"fish","911":"fish","912":"fish","913":"fish","914":"fish","915":"fish","916":"fish","917":"fish","918":"fish","919":"fish","920":"fish","921":"fish","922":"fish","923":"fish","945":"u","946":"u","947":"u","948":"u","950":"water","951":"water","952":"water","953":"water","954":"water","955":"water","956":"water","957":"water","970":"sushi","971":"sushi","972":"sushi","973":"sushi","974":"sushi","975":"sushi","976":"sushi","977":"sushi","978":"sushi","979":"sushi","980":"sushi","981":"sushi","982":"sushi","983":"sushi","984":"sushi","985":"sushi","1000":"scouts","1001":"scouts","1002":"scouts","1003":"scouts","1004":"scouts","1005":"scouts","1006":"scouts","1007":"scouts","1100":"spice","1101":"spice","1102":"spice","1103":"spice","1104":"spice","1105":"spice","1106":"spice","1107":"spicedried","1108":"spicedried","1109":"spicedried","1110":"spicedried","1111":"spicedried","1112":"spicedried","1113":"spicedried","1114":"spicedried","1115":"spicedried","1116":"spicedried","1117":"spiceground","1118":"spiceground","1119":"spiceground","1120":"spiceground","1121":"spiceground","1122":"spiceground","1123":"spiceground","1124":"spiceground","1125":"spiceground","1126":"spiceground"}'
function checkSoftwareVersions {
 local bTestsPassed=false
 local iMajorVersion
 local iMinorVersion
 local sJQVer=$($JQBIN --version)
 # rudimentary software version checks
 # jq
 iMajorVersion=$(echo $sJQVer | sed 's/jq-\([1-9][0-9]*\)\..*/\1/')
 iMinorVersion=$(echo $sJQVer | sed 's/jq-[1-9][0-9]*\.\([0-9]*\).*/\1/')
 if [ $iMajorVersion -ge 1 ]; then
  if [ $iMajorVersion -gt 1 ] || [[ $iMajorVersion -eq 1 && $iMinorVersion -ge 5 ]]; then
   # bash
   if [ ${BASH_VERSINFO[0]} -ge 4 ]; then
    if [ ${BASH_VERSINFO[0]} -gt 4 ] || [[ ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -ge 3 ]]; then
     # PHP
     iMajorVersion=$(php -r "echo PHP_MAJOR_VERSION;")
     iMinorVersion=$(php -r "echo PHP_MINOR_VERSION;")
     if [ $iMajorVersion -ge 5 ]; then
      if [ $iMajorVersion -gt 5 ] || [[ $iMajorVersion -eq 5 && $iMinorVersion -ge 4 ]]; then
       bTestsPassed=true
       # echo "Sofware version tests passed"
      fi
     fi
    fi
   fi
  fi
 fi
 if [ "$bTestsPassed" = "false" ]; then
  echo -e "Software version tests have FAILED\nYou need PHP >= v5.4, jq >= v1.5 and Bash >= v4.3!\nCannot continue"
  sleep 5
  exit 1
 fi
}
checkSoftwareVersions
umask 002
echo $BASHPID > "$PIDFILE"

# this is just a goodie. _might_ require kernel.sched_autogroup_enabled to be set to '0'
# 19 would be the highest nice level (lowest prio), -19 would be the lowest nice level as in 'not nice at all for hogging more CPU time'
# uncomment and set to your needs, if needed
#if command -v renice &>/dev/null; then
# NICELVL=19
# renice -n $NICELVL $$
#fi

while (true); do
 WORKERQUEUE=$((++WORKERQUEUE))
 ERRCOUNT=0
 if [ -f ../updateInProgress ]; then
  echo "Bot update in progress detected. Restarting bot in 3 mins..."
  sleep 3m
  cd ..
  exec /usr/bin/env bash mffbashbot.sh $MFFUSER
 fi
 if [ -f ../updateTrigger ]; then
  echo "Update trigger detected"
  USCRIPTMD5ON=$(wget -T10 -qO - $USCRIPTURL | md5sum | awk '{ print $1 }')
  USCRIPTMD5OFF=$(md5sum ../update.sh | awk '{ print $1 }')
  if [ -n "$USCRIPTMD5ON" ] && [ -n "$USCRIPTMD5OFF" ]; then
   if [ "$USCRIPTMD5ON" != "$USCRIPTMD5OFF" ] && [ "$USCRIPTMD5ON" != "d41d8cd98f00b204e9800998ecf8427e" ]; then
    # d41d8cd98f00b204e9800998ecf8427e would be an empty file
    echo "Replacing update script with newer version..."
    wget -T10 -qO ../update.sh $USCRIPTURL
    chmod +x ../update.sh
   fi
  fi
  cp -f ../update.sh $UTMPFILE
  if [ -x $UTMPFILE ] && [ -O $UTMPFILE ]; then
   /usr/bin/env bash $UTMPFILE
  else
   echo "Something's wrong with ${UTMPFILE}! Running update script from game folder, this might cause problems"
   /usr/bin/env bash ../update.sh
  fi
  rm -f $UTMPFILE
  echo "Restarting bot..."
  sleep 3
  cd ..
  exec /usr/bin/env bash mffbashbot.sh $MFFUSER
 fi
 if [ "$VERSION" != "$(cat ../version.txt)" ]; then
  echo "Version change detected. Restarting bot..."
  sleep 3
  cd ..
  exec /usr/bin/env bash mffbashbot.sh $MFFUSER
 fi
 PAUSETIME=600
 if [ -f dontrunbot ]; then
  echo -n "Time stamp: "
  date "+%A, %d. %B %Y - %H:%Mh"
  echo "Run blocker detected. Pausing $PAUSETIME secs..."
  echo "---"
  sleep ${PAUSETIME}
  continue
 fi
 if [ -f restartbot ]; then
  echo "Restart flag detected. Restarting bot..."
  rm -f restartbot
  cd ..
  exec /usr/bin/env bash mffbashbot.sh $MFFUSER
 fi
 touch "$STATUSFILE"
 # remove lingering cookies
 rm $COOKIEFILE 2>/dev/null
 NANOVALUE=$(($(date +%s%N) / 1000000))
 LOGOFFURL="https://s${MFFSERVER}.${DOMAIN}/main.php?page=logout&logoutbutton=1"
 POSTURL="https://www.${DOMAIN}/ajax/createtoken2.php?n=${NANOVALUE}"
 AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:127.0) Gecko/20100101 Firefox/127.0"
 # There's another AGENT string in logonandgetfarmdata.sh (!)
 POSTDATA="server=${MFFSERVER}&username=${MFFUSER}&password=${MFFPASS}&ref=&retid="

 echo "Running My Free Farm Bash Bot $VERSION"
 echo "Getting a login token"
 MFFTOKEN=$(wget -nv -T10 -a $LOGFILE --output-document=- --user-agent="$AGENT" --post-data="$POSTDATA" --keep-session-cookies --save-cookies $COOKIEFILE "$POSTURL" | sed -e 's/\[1,"\(.*\)"\]/\1/g' | sed -e 's/\\//g')
 echo "Attempting to log in to MFF server ${MFFSERVER} with username $MFFUSER"
 wget -nv -T10 -a $LOGFILE --output-document=$OUTFILE --user-agent="$AGENT" --keep-session-cookies --save-cookies $COOKIEFILE "$MFFTOKEN"
 # get our RID
 RID=$(grep -om1 '[a-z0-9]\{32\}' $OUTFILE)
 # at least test if this was successful
 if [ -z "$RID" ]; then
  echo "FATAL: RID could not be retrieved. Pausing 5 minutes before next attempt..."
  # try and logoff.. just in case
  wget -nv -T10 -a $LOGFILE --output-document=/dev/null --user-agent="$AGENT" --load-cookies $COOKIEFILE "$LOGOFFURL"
  rm -f "$STATUSFILE"
  sleep 5m
  continue
 fi
 echo "Login successful"

 # shellcheck source=functions.sh
 source ../functions.sh

 # trap signals for clean logoff and file system cleanup
 trap "exitBot INT" SIGINT
 trap "exitBot TERM" SIGTERM
 trap restartBot SIGHUP

 echo "Getting farm status..."
 getFarmData $FARMDATAFILE
 PLAYERLEVELNUM=$($JQBIN -r '.updateblock.menue.levelnum' $FARMDATAFILE)
 echo "Your player level is ${PLAYERLEVELNUM}"
 PREMIUM=$($JQBIN '.updateblock.menue.premium' $FARMDATAFILE 2>/dev/null)
 echo -n "This is a "
 if [ $PREMIUM -eq 0 ]; then
  NONPREMIUM=NP
  echo -n "non-"
 else
  unset NONPREMIUM
 fi
 echo "premium account"
 checkLoginNews

 # login bonus handling
 if ! grep -q "dologinbonus = 0" $CFGFILE && grep -q "dologinbonus = " $CFGFILE; then
  echo -n "Checking for daily login bonus..."
  checkLoginBonus
 fi
 while [ $WORKERQUEUE -gt 0 ]; do # prevent logging off if pause is less than LOGOFFTHRESHOLD
  # power up handling
  if [ $PLAYERLEVELNUM -ge 8 ]; then
   echo "Checking for pending power-ups..."
   checkPowerUps city2 powerups 0
   checkPowerUps city2 powerups 1
  fi

  # guild tool handling
  if checkActiveGuildJobForPlayer; then
   echo "Checking for pending guild job tools..."
   checkTools city2 tools 0
  fi

  for FARM in {1..10}; do
   PLACEEXISTS=$($JQBIN '.updateblock.farms.farms | has("'${FARM}'")' $FARMDATAFILE)
   if [ "$PLACEEXISTS" = "false" ]; then
    # echo "Skipping farm ${FARM}"
    continue
   fi
   echo "Checking for pending tasks on farm ${FARM}..."
   for POSITION in {1..6}; do
    BUILDINGID=$($JQBIN -r '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].buildingid' $FARMDATAFILE 2>/dev/null)
    # skip premium fields for non-premium users
    if [ "$NONPREMIUM" = "NP" ]; then
     if $JQBIN '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].premium?' $FARMDATAFILE | grep -q '1'; then
      # echo "Skipping farm ${FARM}, position ${POSITION}"
      continue
     fi
    fi
    # skip empty position or fields if playerlevel < 4
    if [ "$BUILDINGID" = "0" ] || [[ $PLAYERLEVELNUM -lt 4 && "$BUILDINGID" = "1" ]]; then
     # echo "Skipping farm ${FARM}, position ${POSITION}"
     continue
    fi
    # add/remove queues on demand
    if grep -q "correctqueuenum = 1" $CFGFILE; then
     checkQueueCount $FARM $POSITION $BUILDINGID
    fi
    if grep -q "removeweed = 1" $CFGFILE && [ "$BUILDINGID" = "1" ]; then
     removeWeed $FARM $POSITION
    fi
    if [ "$BUILDINGID" = "19" ]; then
     # 19 is a mega field
     if checkRunningMegaFieldJob; then
      echo "Checking for pending tasks on mega field..."
      if checkRipePlotOnMegaField; then
       doFarm ${FARM} ${POSITION} 0
       continue
      fi
     fi
     continue
    fi
    if [ "$BUILDINGID" = "23" ]; then
     # sushi bar
     echo "Checking for pending tasks in sushi bar..."
     checkSushiBarFarmies
     aSLOTS="1 2 3"
     for SLOT in $aSLOTS; do
      if checkTimeRemaining '.updateblock.sushibar.production["'${SLOT}'"]?["1"].remain'; then
       echo "Doing Sushi Bar production slot ${SLOT}..."
       doFarm ${FARM} ${POSITION} $((SLOT - 1))
      fi
     done
    checkSushiBarPlates
    continue
    fi
    # shellcheck disable=SC2046
    if [ $(getMaxQueuesForBuildingID $BUILDINGID) -eq 3 ]; then
     aSLOTS="0 1 2"
    else
     aSLOTS="0"
    fi
    # desired globbing
    for SLOT in $aSLOTS; do
     if checkTimeRemaining '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].production['${SLOT}']?.remain'; then
      echo -n "Doing farm ${FARM}, position ${POSITION}, slot ${SLOT}"
      if $JQBIN '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].production['${SLOT}'].guild | tonumber' $FARMDATAFILE 2>/dev/null | grep -q '1'; then
       echo " as a guild job..."
       GUILDJOB=true
      else
       echo "..."
      fi
      doFarm ${FARM} ${POSITION} ${SLOT}
     fi
     if [ $SLOT -eq 0 ]; then
      if checkTimeRemaining '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].water[0].waterremain'; then
       echo "Watering farm ${FARM}, position ${POSITION}, slot ${SLOT}..."
       waterField${NONPREMIUM} $FARM $POSITION
      fi
     fi
    done
   done
  done
  # reset one-shot flags if set
  sed -i 's/correctqueuenum = 1/correctqueuenum = 0/' $CFGFILE
  sed -i 's/removeweed = 1/removeweed = 0/' $CFGFILE

  # work farmers market
  if [ $PLAYERLEVELNUM -ge 23 ]; then
   echo "Checking for pending tasks on farmers market..."
   # first the flower area. we'll only check one of 'em.
   FASTATUS=$($JQBIN '.updateblock.farmersmarket.flower_area | length' $FARMDATAFILE)
   if [ $FASTATUS -gt 0 ]; then
    if checkTimeRemaining '.updateblock.farmersmarket.flower_area["1"]?.remain'; then
     echo "Doing flower area..."
     doFarmersMarket farmersmarket flowerarea 0
    fi
   fi
   # nursery is next
   for SLOT in 1 2; do
    if checkTimeRemaining '.updateblock.farmersmarket.nursery.slots["'${SLOT}'"]?.remain'; then
     echo "Doing nursery slot ${SLOT}..."
     doFarmersMarket farmersmarket nursery ${SLOT}
    fi
   done
   # see if flower pots need water...
   doFarmersMarketFlowerPots
   # monster fruit
   if [ $PLAYERLEVELNUM -ge 31 ]; then
    RUNCHK=$($JQBIN -r '.updateblock.farmersmarket.megafruit.current | type' $FARMDATAFILE)
    if [ "$RUNCHK" = "object" ]; then
     if ! $JQBIN '.updateblock.farmersmarket.megafruit.current.remain' $FARMDATAFILE | grep -q '-'; then
      for HELPER in water light fertilize; do
       if checkTimeRemaining '.updateblock.farmersmarket.megafruit.current.data.'${HELPER}'.remain'; then
        echo "Using ${HELPER} on monster fruit..."
        doFarmersMarket farmersmarket monsterfruit ${HELPER}
       fi
      done
     fi
    fi
    # food contest
    RUNCHK=$($JQBIN -r '.updateblock.farmersmarket.foodcontest.current | type' $FARMDATAFILE)
    if [ "$RUNCHK" = "object" ]; then
     if ! $JQBIN '.updateblock.farmersmarket.foodcontest.current.remain' $FARMDATAFILE | grep -q '-'; then
      # check for a ready cash desk first
      if checkTimeRemaining '.updateblock.farmersmarket.foodcontest.current.data.merchpin_remain'; then
       echo "Doing cash desk..."
       doFoodContestCashDesk
      fi
      # next the audience
      for BLOCK in 1 2 3 4; do
       for PINTYPE in fame money points products; do
        if checkTimeRemaining '.updateblock.farmersmarket.foodcontest.blocks["'${BLOCK}'"]?.pin.'${PINTYPE}'.remain'; then
         echo "Picking up ${PINTYPE} from audience block ${BLOCK}..."
         doFoodContestAudience ${BLOCK} ${PINTYPE}
        fi
       done
      done
      # feed the contestant if needed & desired
      if grep -q "dofoodcontest = 1" $CFGFILE; then
       if checkTimeRemaining '.updateblock.farmersmarket.foodcontest.current.feedremain'; then
        echo "Feeding speed eating contestant..."
        doFoodContestFeeding
       fi
      fi
     fi
    fi
    # check for active pet breeding
    RUNCHK=$($JQBIN -r '.updateblock.farmersmarket.pets.breed | type' $FARMDATAFILE)
    if [ "$RUNCHK" = "object" ]; then
     for SLOT in food toy plushy; do
      SLOTREMAIN=$($JQBIN -r '.updateblock.farmersmarket.pets.breed.care_remains["'${SLOT}'"]? | type' $FARMDATAFILE)
      if [ "$SLOTREMAIN" != "number" ]; then
       echo "Taking care of pet using ${SLOT}..."
       doFarmersMarketPetCare ${SLOT}
      else
       # we have a valid number, let's see if PAUSETIME needs a correction...
       checkTimeRemaining '.updateblock.farmersmarket.pets.breed.care_remains["'${SLOT}'"]'
      fi
     done
    fi
    # stuff for pets production
    for SLOT in 1 2 3; do
     if checkTimeRemaining '.updateblock.farmersmarket.pets.production["'${SLOT}'"]?["1"]?.remain'; then
      echo "Doing pets stuff production slot ${SLOT}..."
      doFarmersMarket farmersmarket pets ${SLOT}
     fi
    done
   fi
   # veterinarian
   if [ $PLAYERLEVELNUM -ge 36 ]; then
    for SLOT in 1 2 3; do
     if checkTimeRemaining '.updateblock.farmersmarket.vet.production["'${SLOT}'"]?["1"]?.remain'; then
      echo "Doing vet production slot ${SLOT}..."
      doFarmersMarket farmersmarket vet ${SLOT}
     fi
    done
    # animal treatment
    # check for running treatment job
    VETJOBSTATUS=$($JQBIN '.updateblock.farmersmarket.vet.info.role | tonumber' $FARMDATAFILE 2>/dev/null)
    if [ "$VETJOBSTATUS" != "0" ] && [ "$VETJOBSTATUS" != "" ]; then
     for SLOT in 1 2 3; do
      if checkTimeRemaining '.updateblock.farmersmarket.vet.animals.slots["'${SLOT}'"]?.remain'; then
       echo "Doing animal treatment slot ${SLOT}..."
       doFarmersMarketAnimalTreatment ${SLOT}
      fi
     done
    fi
   fi
  fi
  # butterfly house
  if [ $PLAYERLEVELNUM -ge 40 ]; then
   PLACEEXISTS=$($JQBIN -r '.updateblock.farmersmarket.butterfly | type' $FARMDATAFILE 2>/dev/null)
   if [ "$PLACEEXISTS" != "number" ] && [ "$PLACEEXISTS" != "null" ]; then
    for SLOT in {1..6}; do
     if ! grep -q "autobuybutterflies = 0" $CFGFILE && grep -q "autobuybutterflies = " $CFGFILE; then
      checkButterflies $SLOT
     fi
     if checkTimeRemaining '.updateblock.farmersmarket.butterfly.data.breed["'${SLOT}'"]?.remain'; then
      startButterflies $SLOT
     fi
    done
   fi
  fi
  # cow racing production
  if [ $PLAYERLEVELNUM -ge 42 ]; then
   PLACEEXISTS=$($JQBIN -r '.updateblock.farmersmarket.cowracing | type' $FARMDATAFILE 2>/dev/null)
   if [ "$PLACEEXISTS" != "number" ] && [ "$PLACEEXISTS" != "null" ]; then
    for SLOT in 1 2 3; do
     if checkTimeRemaining '.updateblock.farmersmarket.cowracing.production["'${SLOT}'"]?["1"]?.remain'; then
      echo "Doing cow racing production slot ${SLOT}..."
      doFarmersMarket farmersmarket2 cowracing ${SLOT}
     fi
    done
    # race cow feeding
    for SLOT in {1..15}; do
     if ! grep -q "racecowslot${SLOT} = 0" $CFGFILE && grep -q "racecowslot${SLOT} = " $CFGFILE; then
      checkRaceCowFeeding ${SLOT}
     fi
    done
    # start cow races
    if grep -q "docowrace = 1" $CFGFILE; then
     checkCowRace
    fi
    if grep -q "docowracepvp = 1" $CFGFILE; then
     checkCowRacePvP
    fi
   fi
  fi
  # fishing production & fisherman
  if [ $PLAYERLEVELNUM -ge 44 ]; then
   PLACEEXISTS=$($JQBIN -r '.updateblock.farmersmarket.fishing | type' $FARMDATAFILE 2>/dev/null)
   if [ "$PLACEEXISTS" != "number" ] && [ "$PLACEEXISTS" != "null" ]; then
    for SLOT in 1 2 3; do
     if checkTimeRemaining '.updateblock.farmersmarket.fishing.production["'${SLOT}'"]?["1"]?.remain'; then
      echo "Doing fishing production slot ${SLOT}..."
      doFarmersMarket farmersmarket2 fishing ${SLOT}
     fi
     if ! grep -q "speciesbait${SLOT} = 0" $CFGFILE && grep -q "speciesbait${SLOT} = " $CFGFILE; then
      if ! grep -q "raritybait${SLOT} = 0" $CFGFILE && grep -q "raritybait${SLOT} = " $CFGFILE; then
       if ! grep -q "fishinggear${SLOT} = 0" $CFGFILE && grep -q "fishinggear${SLOT} = " $CFGFILE; then
        if checkTimeRemaining '.updateblock.farmersmarket.fishing.data.fishingslots["'${SLOT}'"].remain'; then
         doFisherman ${SLOT}
        fi
       fi
      fi
     fi
    done
   fi
  fi
  # vineyard
  if [ $PLAYERLEVELNUM -ge 46 ]; then
   PLACEEXISTS=$($JQBIN -r '.updateblock.farmersmarket.vineyard | type' $FARMDATAFILE 2>/dev/null)
   if [ "$PLACEEXISTS" != "number" ] && [ "$PLACEEXISTS" != "null" ]; then
    checkVineYard
   fi
  fi
  # scouts production & tasks
  if [ $PLAYERLEVELNUM -ge 43 ]; then
   PLACEEXISTS=$($JQBIN -r '.updateblock.farmersmarket.scouts | type' $FARMDATAFILE 2>/dev/null)
   if [ "$PLACEEXISTS" != "number" ] && [ "$PLACEEXISTS" != "null" ]; then
    for SLOT in 1 2 3; do
     if checkTimeRemaining '.updateblock.farmersmarket.scouts.production["'${SLOT}'"]?["1"]?.remain'; then
      echo "Doing scouts production slot ${SLOT}..."
      doFarmersMarket farmersmarket2 scouts ${SLOT}
     fi
    done
   fi
   if ! grep -q "scoutfood = 0" $CFGFILE && grep -q "scoutfood = " $CFGFILE; then
    checkScouts
   fi
  fi

  # transport vehicle handling
  if ! grep -q "vehiclemgmt5 = 0" $CFGFILE && grep -q "vehiclemgmt5 = " $CFGFILE; then
   # parameters are farm no. and route no.
   checkVehiclePosition 5 1
  fi
  if ! grep -q "vehiclemgmt6 = 0" $CFGFILE && grep -q "vehiclemgmt6 = " $CFGFILE; then
   checkVehiclePosition 6 2
  fi
  if ! grep -q "vehiclemgmt7 = 0" $CFGFILE && grep -q "vehiclemgmt7 = " $CFGFILE; then
   checkVehiclePosition 7 3
  fi
  if ! grep -q "vehiclemgmt8 = 0" $CFGFILE && grep -q "vehiclemgmt8 = " $CFGFILE; then
   checkVehiclePosition 8 4
  fi
  if ! grep -q "vehiclemgmt9 = 0" $CFGFILE && grep -q "vehiclemgmt9 = " $CFGFILE; then
   checkVehiclePosition 9 5
  fi
  if ! grep -q "vehiclemgmt10 = 0" $CFGFILE && grep -q "vehiclemgmt10 = " $CFGFILE; then
   checkVehiclePosition 10 6
  fi

  if grep -q "sendfarmiesaway = 1" $CFGFILE; then
   echo "Checking for waiting farmies..."
   checkFarmies farmie
  fi

  if grep -q "sendflowerfarmiesaway = 1" $CFGFILE; then
   echo "Checking for waiting flower farmies..."
   checkFarmies flowerfarmie
   # checkFlowerFarmies
  fi

  if grep -q "doeventgarden = 1" $CFGFILE; then
   echo "Checking for pending tasks in event garden..."
   if ! checkEventGarden; then
    # turn off event garden feature
    sed -i 's/doeventgarden = 1/doeventgarden = 0/' $CFGFILE
   fi
  fi

  # daily actions
  if ! grep -q "dodog = 0" $CFGFILE && grep -q "dodog = " $CFGFILE; then
   echo -n "Checking for daily dog bonus..."
   checkDogBonus
  fi

  if grep -q "dodonkey = 1" $CFGFILE; then
   checkDonkeyBonus
  fi

  if grep -q "dopuzzleparts = 1" $CFGFILE; then
   echo -n "Checking for buyable puzzle parts..."
   checkPuzzleParts
  fi

  if grep -q "redeempuzzlepacks = 1" $CFGFILE; then
   redeemPuzzlePartsPacks
  fi

  if grep -q "dobutterflies = 1" $CFGFILE; then
   echo "Checking for butterfly points bonus..."
   checkButterflyBonus
  fi

  if grep -q "dodeliveryevent = 1" $CFGFILE; then
   echo "Checking for running delivery event..."
   checkDeliveryEvent
  fi

  if grep -q "dopentecostevent = 1" $CFGFILE; then
   echo "Checking for running pentecost event..."
   checkPentecostEvent
  fi
  if [ $PLAYERLEVELNUM -ge 9 ]; then
   for SLOT in {1..4}; do
    if ! grep -q "fruitstallslot${SLOT} = 0" $CFGFILE && grep -q "fruitstallslot${SLOT} = " $CFGFILE; then
     checkFruitStall ${SLOT} 1
    fi
    if [ $PLAYERLEVELNUM -ge 13 ] && [ $PREMIUM -eq 1 ] && [ $SLOT -lt 4 ]; then
     if ! grep -q "fruitstall2slot${SLOT} = 0" $CFGFILE && grep -q "fruitstall2slot${SLOT} = " $CFGFILE; then
      checkFruitStall ${SLOT} 2
     fi
    fi
   done
  fi

  if [ $PLAYERLEVELNUM -ge 29 ]; then
   if ! grep -q "doinsecthotel = 0" $CFGFILE && grep -q "doinsecthotel = " $CFGFILE; then
    checkInsectHotel
    checkInsectHotelStock
   fi
  fi

  # auto-buy
  if ! grep -q "autobuyrefillto = 0" $CFGFILE && grep -q "autobuyrefillto = " $CFGFILE && ! grep -q "autobuyitems = 0" $CFGFILE; then
   echo "Checking if stock needs a refill..."
   checkStockRefill
  fi

  if [ $PLAYERLEVELNUM -ge 49 ]; then
   if grep -q "doinfinitequest = 1" $CFGFILE; then
    if checkTimeRemaining '.updateblock.queststatus.infinite.data.quest.remain'; then
     doInfiniteQuest
    fi
   fi
  fi

  # contents of FARMDATAFILE change from here !

  # olympia / winter sports event
  if grep -q "doolympiaevent = 1" $CFGFILE; then
   echo "Checking for running olympia / winter sports event..."
   checkOlympiaEvent
  fi

  # calender event
  if grep -q "docalendarevent = 1" $CFGFILE; then
   echo -n "Checking for calendar event..."
   checkCalendarEvent
  fi

  if grep -q "doseedbox = 1" $CFGFILE; then
   echo "Checking for points bonus from seed box..."
   checkPanBonus
  fi

  if grep -q "dogreenhouse = 1" $CFGFILE; then
   echo "Checking for points bonus from green house..."
   checkGreenHouseBonus
  fi

  if [ $PLAYERLEVELNUM -ge 8 ]; then
   if ! grep -q "dolot = 0" $CFGFILE && grep -q "dolot = " $CFGFILE; then
    echo -n "Checking for daily lottery bonus..."
    checkLottery
   fi
  fi

  if [ $PLAYERLEVELNUM -ge 20 ]; then
   echo "Getting forestry status..."
   getForestryData $FARMDATAFILE
   echo "Checking for pending tasks in forestry..."
   # first the trees ... we'll only check one of 'em. timer ends at '0'
   if [ "$($JQBIN '.datablock[1][0].remain' $FARMDATAFILE 2>/dev/null)" = "0" ] 2>/dev/null; then
    echo "Doing trees..."
    doForestry forestry
   else
    if checkCanWaterTrees; then
     if [ "$($JQBIN '.datablock[1][0].waterremain' $FARMDATAFILE 2>/dev/null)" = "0" ] 2>/dev/null; then
      echo "Watering trees..."
      waterTree
     fi
    fi
   fi
   # then the forestry buildings
   for POSITION in 1 2; do
    for SLOT in 1 2; do
     if checkTimeRemaining '.datablock[2]["'${POSITION}'"]?.slots["'${SLOT}'"]?.remain'; then
      echo "Doing position ${POSITION}, slot ${SLOT}..."
      doFarm forestry ${POSITION} ${SLOT}
     fi
    done
   done
   # finally the forestry farmies
   if grep -q "sendforestryfarmiesaway = 1" $CFGFILE; then
    echo "Checking for waiting forestry farmies..."
    checkFarmies forestryfarmie
   fi
  fi

  if [ $PLAYERLEVELNUM -ge 11 ]; then
   echo "Getting food world status..."
   getFoodWorldData $FARMDATAFILE
   echo "Checking for pending tasks in food world..."
   for POSITION in 1 2 3 4; do
    for SLOT in 1 2; do
     # readiness in food world is signalled by a "ready:1" value
     if $JQBIN '.datablock.buildings["'${POSITION}'"].slots["'${SLOT}'"].ready' $FARMDATAFILE 2>/dev/null | grep -q '1'; then
      echo "Doing position ${POSITION}, slot ${SLOT}..."
      doFarm foodworld ${POSITION} ${SLOT}
     fi
    done
   done
   # munchies
   if grep -q "sendmunchiesaway = 1" $CFGFILE; then
    echo "Checking for waiting munchies..."
    checkFarmies munchie
    # checkMunchies
   fi
   echo "Checking for munchies sitting at tables..."
   checkMunchiesAtTables
  fi
  # this is the only building with a queue in city 2, and it's unlikely for this
  # to ever change, hence static coding
  if [ $PLAYERLEVELNUM -ge 8 ]; then
   echo "Getting wind mill status..."
   getWindMillData $FARMDATAFILE
   RUNCHK=$($JQBIN '.datablock[4].running == 1' $FARMDATAFILE)
   WINDMILLREADY=$($JQBIN '.datablock[4].ready >= 1' $FARMDATAFILE)
   if [ "$RUNCHK" = "true" ] || [ "$WINDMILLREADY" = "true" ]; then
    echo "Checking for pending tasks in wind mill..."
    # we handle two slots
    if checkTimeRemaining '.datablock[2]["1"]?.remain'; then
     echo "Doing wind mill, slot 1..."
     doFarm city2 windmill 1
    fi
    SLOTREMAIN=$($JQBIN '.datablock[3]' $FARMDATAFILE)
    if [ $SLOTREMAIN -gt 0 ]; then
     if checkTimeRemaining '.datablock[2]["2"]?.remain'; then
      echo "Doing wind mill, slot 2..."
      doFarm city2 windmill 2
     fi
    fi
   fi
  fi

  # consider time delta
  if [ $PAUSECORRECTEDAT -ne 0 ]; then
   CURRENTEPOCH=$(date +"%s")
   TIMEDELTA=$((CURRENTEPOCH - PAUSECORRECTEDAT))
   PAUSETIME=$((PAUSETIME - TIMEDELTA))
   if [ $PAUSETIME -ge $LOGOFFTHRESHOLD ]; then
    WORKERQUEUE=$((--WORKERQUEUE))
   else
    if [ $PAUSETIME -gt 0 ]; then
     echo "Pausing $PAUSETIME secs..."
     sleep ${PAUSETIME}
    fi
    PAUSETIME=600
    echo "---"
    echo "Refreshing farm status..."
    getFarmData $FARMDATAFILE
   fi
   TIMEDELTA=0
   PAUSECORRECTEDAT=0
  else
   WORKERQUEUE=$((--WORKERQUEUE))
  fi
 done

 echo "Logging off..."
 WGETREQ "$LOGOFFURL"
 # housekeeping -- adjust to your liking
 rm -f "$COOKIEFILE" "$FARMDATAFILE" "$OUTFILE" "$TMPFILE" "$TMPFILE"-*-[1-6]
 if [ $ERRCOUNT -eq 0 ] && [ -f "$LASTERRORFILE" ]; then
  rm -f "$LASTERRORFILE"
 fi
 echo -n "Time stamp: "
 date "+%d. %b - %H:%Mh" | tee $LASTRUNFILE
 echo "Pausing $PAUSETIME secs..."
 echo "---"
 rm -f "$STATUSFILE"
 sleep ${PAUSETIME}
done
