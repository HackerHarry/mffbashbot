#!/bin/bash
# Harrys My Free Farm Bash Bot
# Copyright 2016-17 Harun "Harry" Basalamah
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
STATUSFILE=isactive.txt
CFGFILE=config.ini
PIDFILE=bashpid.txt
JQBIN=/usr/bin/jq
MFFUSER=$1
TMPFILE=/tmp/${MFFUSER}-$$
# get server, password & language
MFFPASS=$(grep password $CFGFILE | tr -d "'")
MFFSERVER=$(grep server $CFGFILE)
TLD=$(grep lang $CFGFILE | tr -d "'")
# let's just hope IFS is a white space ;)
set -- $MFFPASS
: ${3:?No MFF password found in $CFGFILE}
MFFPASS=$3
set -- $MFFSERVER
: ${3:?No MFF server-no. found in $CFGFILE}
MFFSERVER=$3
set -- $TLD
: ${3:?No MFF language found in $CFGFILE}
TLD=$3
if [ "$TLD" = "en" ]; then
 TLD=com
fi
aDIM_X='{"0":"0","1":"2","2":"2","3":"2","4":"2","5":"2","6":"2","7":"2","8":"2","9":"1","10":"1","11":"1","12":"1","13":"1","14":"1","15":"1","16":"1","17":"1","18":"1","19":"1","20":"1","21":"1","22":"1","23":"1","24":"1","25":"1","26":"1","27":"1","28":"1","29":"2","30":"1","31":"1","32":"1","33":"1","34":"1","35":"1","36":"2","37":"2","38":"1","39":"2","40":"2","41":"2","42":"2","43":"2","44":"1","91":"1","92":"1","93":"1","97":"1","45":"2","46":"1","47":"2","48":"2","49":"2","50":"1","51":"1","52":"2","53":"2","54":"2","55":"1","56":"2","57":"2","58":"2","59":"2","60":"2","61":"2","62":"2","63":"2","64":"2","65":"1","66":"2","67":"2","68":"1","69":"2","70":"2","71":"2","72":"2","73":"1","74":"1","75":"1","76":"2","77":"2","78":"2","79":"2","80":"2","81":"2","82":"2","83":"2","84":"2","85":"1","86":"1","87":"2","88":"2","89":"1","90":"2","94":"2","95":"2","96":"1","98":"2","99":"2","100":"2","101":"2","102":"2","103":"2","104":"1","105":"1","106":"2","107":"1","108":"2","109":"2","110":"1","111":"1","112":"1","113":"1","114":"2","115":"2","116":"1","117":"1","118":"1","119":"1","120":"1","121":"1","122":"1","123":"1","124":"1","125":"1","126":"1","127":"2","128":"2","129":"2","130":"1","131":"1","132":"1","133":"1","134":"1","135":"1","136":"1","137":"1","138":"1","139":"1","140":"1","141":"1","142":"1","143":"1","144":"1","145":"1","146":"1","147":"1","148":"1","149":"1","150":"1","151":"1","152":"1","153":"2","154":"2","155":"1","156":"1","157":"1","158":"2","159":"1","160":"1","161":"1","162":"1","163":"1","164":"1","165":"1","166":"1","167":"1","168":"1","169":"1","170":"1","171":"1","172":"1","173":"1","174":"1","175":"1","176":"1","177":"1","178":"1","179":"1","180":"1","181":"1","182":"1","183":"1","184":"1","185":"1","186":"1","187":"1","188":"1","189":"1","200":"1","201":"1","202":"1","203":"1","204":"1","205":"1","206":"1","207":"1","208":"1","209":"1","210":"1","211":"1","212":"1","213":"1","214":"1","215":"1","216":"1","217":"1","218":"1","219":"1","220":"1","221":"1","250":"1","251":"1","252":"1","253":"1","254":"1","255":"1","256":"1","257":"1","258":"1","259":"1","260":"1","261":"1","262":"1","263":"1","264":"1","265":"1","266":"1","267":"1","268":"1","269":"1","270":"1","271":"1","272":"1","273":"1","274":"1","275":"1","276":"1","300":"1","301":"1","302":"1","303":"1","304":"1","305":"1","306":"1","307":"1","308":"1","309":"1","310":"1","311":"1","312":"1","313":"1","314":"1","315":"1","316":"1","317":"1","318":"1","319":"1","320":"1","321":"1","322":"1","323":"1","324":"1","325":"1","326":"1","327":"1","328":"1","329":"1","330":"1","331":"1","332":"1","333":"1","334":"1","335":"1","336":"1","337":"1","338":"1","339":"1","340":"1","341":"1","342":"1","343":"1","344":"1","345":"1","346":"1","347":"1","348":"1","349":"1","350":"0","351":"2","352":"2","353":"2","354":"2","355":"1","356":"2","357":"1","358":"2","359":"2","360":"2","361":"2","400":"1","401":"1","402":"1","403":"1","450":"1","451":"1","452":"1","453":"1","454":"1","455":"1","456":"1","457":"1","458":"1","459":"1","460":"1","461":"1","462":"1","463":"1","464":"1","465":"1","466":"1","467":"1","468":"1","469":"1","470":"1","471":"1","472":"1","473":"1","474":"1","475":"1","476":"1","477":"1","478":"1","479":"1","480":"1","481":"1","482":"1","483":"1","550":"2","551":"2","600":"1","601":"1","602":"1","603":"1","604":"1","605":"1","606":"1","607":"1","608":"1","609":"1","630":"1","631":"1","632":"1","633":"1","634":"1","635":"1","636":"1","637":"1","638":"1","639":"1","660":"1","661":"1","662":"1","663":"1","664":"1","665":"1","666":"1","667":"1","668":"1","669":"1","700":"2","701":"1","702":"2","703":"2","704":"2","705":"1","706":"2","707":"2","708":"2","709":"2","750":"1","751":"1","752":"1","753":"1","754":"1","755":"1","756":"1","757":"1","758":"1","759":"1"}'
aDIM_Y='{"0":"0","1":"1","2":"2","3":"1","4":"2","5":"2","6":"2","7":"2","8":"2","9":"1","10":"1","11":"1","12":"1","13":"1","14":"1","15":"1","16":"1","17":"1","18":"1","19":"1","20":"1","21":"1","22":"1","23":"1","24":"1","25":"1","26":"1","27":"1","28":"1","29":"1","30":"1","31":"1","32":"1","33":"1","34":"1","35":"1","36":"2","37":"2","38":"1","39":"2","40":"2","41":"2","42":"2","43":"2","44":"1","91":"1","92":"1","93":"1","97":"1","45":"2","46":"1","47":"2","48":"1","49":"2","50":"1","51":"1","52":"2","53":"2","54":"1","55":"1","56":"2","57":"2","58":"1","59":"2","60":"2","61":"2","62":"1","63":"1","64":"1","65":"1","66":"1","67":"2","68":"1","69":"1","70":"1","71":"1","72":"1","73":"1","74":"1","75":"1","76":"2","77":"2","78":"2","79":"2","80":"1","81":"2","82":"1","83":"1","84":"1","85":"1","86":"1","87":"1","88":"2","89":"1","90":"2","94":"1","95":"2","96":"1","98":"2","99":"1","100":"2","101":"2","102":"2","103":"2","104":"1","105":"1","106":"2","107":"1","108":"2","109":"1","110":"1","111":"1","112":"1","113":"1","114":"1","115":"1","116":"1","117":"1","118":"1","119":"1","120":"1","121":"1","122":"1","123":"1","124":"1","125":"1","126":"1","127":"2","128":"2","129":"2","130":"1","131":"1","132":"1","133":"1","134":"1","135":"1","136":"1","137":"1","138":"1","139":"1","140":"1","141":"1","142":"1","143":"1","144":"1","145":"1","146":"1","147":"1","148":"1","149":"1","150":"1","151":"1","152":"1","153":"1","154":"2","155":"1","156":"1","157":"1","158":"1","159":"1","160":"1","161":"1","162":"1","163":"1","164":"1","165":"1","166":"1","167":"1","168":"1","169":"1","170":"1","171":"1","172":"1","173":"1","174":"1","175":"1","176":"1","177":"1","178":"1","179":"1","180":"1","181":"1","182":"1","183":"1","184":"1","185":"1","186":"1","187":"1","188":"1","189":"1","200":"1","201":"1","202":"1","203":"1","204":"1","205":"1","206":"1","207":"1","208":"1","209":"1","210":"1","211":"1","212":"1","213":"1","214":"1","215":"1","216":"1","217":"1","218":"1","219":"1","220":"1","221":"1","250":"1","251":"1","252":"1","253":"1","254":"1","255":"1","256":"1","257":"1","258":"1","259":"1","260":"1","261":"1","262":"1","263":"1","264":"1","265":"1","266":"1","267":"1","268":"1","269":"1","270":"1","271":"1","272":"1","273":"1","274":"1","275":"1","276":"1","300":"1","301":"1","302":"1","303":"1","304":"1","305":"1","306":"1","307":"1","308":"1","309":"1","310":"1","311":"1","312":"1","313":"1","314":"1","315":"1","316":"1","317":"1","318":"1","319":"1","320":"1","321":"1","322":"1","323":"1","324":"1","325":"1","326":"1","327":"1","328":"1","329":"1","330":"1","331":"1","332":"1","333":"1","334":"1","335":"1","336":"1","337":"1","338":"1","339":"1","340":"1","341":"1","342":"1","343":"1","344":"1","345":"1","346":"1","347":"1","348":"1","349":"1","350":"0","351":"1","352":"1","353":"2","354":"2","355":"1","356":"2","357":"1","358":"2","359":"2","360":"1","361":"2","400":"1","401":"1","402":"1","403":"1","450":"1","451":"1","452":"1","453":"1","454":"1","455":"1","456":"1","457":"1","458":"1","459":"1","460":"1","461":"1","462":"1","463":"1","464":"1","465":"1","466":"1","467":"1","468":"1","469":"1","470":"1","471":"1","472":"1","473":"1","474":"1","475":"1","476":"1","477":"1","478":"1","479":"1","480":"1","481":"1","482":"1","483":"1","550":"2","551":"2","600":"1","601":"1","602":"1","603":"1","604":"1","605":"1","606":"1","607":"1","608":"1","609":"1","630":"1","631":"1","632":"1","633":"1","634":"1","635":"1","636":"1","637":"1","638":"1","639":"1","660":"1","661":"1","662":"1","663":"1","664":"1","665":"1","666":"1","667":"1","668":"1","669":"1","700":"2","701":"1","702":"1","703":"2","704":"1","705":"1","706":"2","707":"1","708":"2","709":"2","750":"1","751":"1","752":"1","753":"1","754":"1","755":"1","756":"1","757":"1","758":"1","759":"1"}'
# dimension data can be extracted from .../js/jsconstants_xxxxxx.js
umask 002
echo $BASHPID > "$PIDFILE"

while (true); do
 if [ -f ../updateInProgress ]; then
  echo "Bot update in progress detected. Restarting bot in 3 mins..."
  sleep 3m
  cd ..
  exec /bin/bash mffbashbot.sh $MFFUSER
 fi
 if [ -f ../updateTrigger ]; then
  echo "Update trigger detected."
  /bin/bash ../update.sh
  echo "Restarting bot..."
  sleep 3
  cd ..
  exec /bin/bash mffbashbot.sh $MFFUSER
 fi
 if [ "$VERSION" != "$(cat ../version.txt)" ]; then
  echo "Version change detected, restarting bot..."
  sleep 3
  cd ..
  exec /bin/bash mffbashbot.sh $MFFUSER
 fi
 PAUSETIME=$(shuf -i7-10 -n1)
 if [ -f dontrunbot ]; then
  echo -n "Time stamp: "
  date "+%A, %d. %B %Y - %H:%Mh"
  echo "Run blocker detected. Pausing $PAUSETIME mins..."
  echo "---"
  sleep ${PAUSETIME}m
  continue
 fi
 touch "$STATUSFILE"
 # remove lingering cookies
 rm $COOKIEFILE 2>/dev/null
 NANOVALUE=$(echo $(($(date +%s%N)/1000000)))
 LOGOFFURL="http://s${MFFSERVER}.myfreefarm.${TLD}/main.php?page=logout&logoutbutton=1"
 POSTURL="https://www.myfreefarm.${TLD}/ajax/createtoken2.php?n=${NANOVALUE}"
 AGENT="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:54.0) Gecko/20100101 Firefox/55.0"
 # There's another AGENT string in logonandgetfarmdata.sh (!)
 POSTDATA="server=${MFFSERVER}&username=${MFFUSER}&password=${MFFPASS}&ref=and&retid="

 echo "Running Harrys My Free Farm Bash Bot $VERSION"
 echo "Getting a token to MFF server ${MFFSERVER}"
 MFFTOKEN=$(wget -nv -a $LOGFILE --output-document=- --user-agent="$AGENT" --post-data="$POSTDATA" --keep-session-cookies --save-cookies $COOKIEFILE "$POSTURL" | sed -e 's/\[1,"\(.*\)"\]/\1/g' | sed -e 's/\\//g')
 echo "Login to MFF server ${MFFSERVER} with username $MFFUSER"
 wget -nv -a $LOGFILE --output-document=$OUTFILE --user-agent="$AGENT" --keep-session-cookies --save-cookies $COOKIEFILE "$MFFTOKEN"
 # get our RID
 RID=$(grep -om1 '[a-z0-9]\{32\}' $OUTFILE)
 # at least test if this was successful
 if [ -z "$RID" ]; then
  echo "FATAL: RID could not be retrieved. Pausing 5 minutes before next attempt..."
  # try and logoff.. just in case
  wget -nv -a $LOGFILE --output-document=/dev/null --user-agent="$AGENT" --load-cookies $COOKIEFILE "$LOGOFFURL"
  sleep 5m
  continue
 fi
 echo "Our RID is $RID"

 # source functions
 . ../functions.sh

 # trap CTRL-C to call ctrl_c (in functions) for clean logoff in case bot is active
 trap ctrl_c INT

 echo "Getting farm status..."
 GetFarmData $FARMDATAFILE
 PREMIUM=$($JQBIN '.updateblock.menue.premium' $FARMDATAFILE 2>/dev/null)
 echo -n "This is a "
 if [ $PREMIUM -eq 0 ]; then
  NONPREMIUM=NP
  echo -n "non-"
 else
  unset NONPREMIUM
 fi
 echo "premium account"

 for FARM in 1 2 3 4 5 6; do
  echo "Checking for pending tasks on farm ${FARM}..."
  for POSITION in 1 2 3 4 5 6; do
   BUILDINGID=$($JQBIN '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].buildingid|tonumber' $FARMDATAFILE 2>/dev/null)
   # skip premium fields for non-premium users
   if [ "$NONPREMIUM" = "NP" ]; then
    if $JQBIN '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].premium?' $FARMDATAFILE | grep -q '1' ; then
     echo "Skipping farm ${FARM}, position ${POSITION}"
     continue
    fi
   fi
   # add/remove queues on demand
   if grep -q "correctqueuenum = 1" $CFGFILE; then
    QFS=$(get_QueueCountInFS $FARM $POSITION)
    MAXQ=$(get_MaxQueuesForBuildingID $BUILDINGID)
    if [ "$QFS" -gt "$MAXQ" ]; then
     echo "Reducing position $POSITION to $MAXQ Queue(s)..."
     reduce_QueuesOnPosition $FARM $POSITION $MAXQ
     QFS=$(get_QueueCountInFS $FARM $POSITION)
    fi
    # queues are capped to the max. possible value
    # from here we'll handle multi-q buildings
    case "$BUILDINGID" in
     13|14|16|21) QGAME=$(get_QueueCountFromInnerInfo $FARM $POSITION)
         ;;
     20) QGAME=$(get_QueueCount20 $FARM $POSITION)
         ;;
      *) QGAME=1
         ;;
    esac
    if [ "$QFS" -lt "$QGAME" ]; then
     echo "Adding $((QGAME-QFS)) Queue(s) to position $POSITION..."
     add_QueuesToPosition $FARM $POSITION $QFS $QGAME
    fi
    if [ "$QFS" -gt "$QGAME" ]; then
     echo "Reducing position $POSITION to $QGAME Queue(s)..."
     reduce_QueuesOnPosition $FARM $POSITION $QGAME
    fi
   fi
   if [ "$BUILDINGID" = "19" ]; then
    # 19 is a mega field
    if check_RunningMegaFieldJob ; then
     echo "Checking for pending tasks on Mega Field..."
     if check_RipePlotOnMegaField ; then
      DoFarm ${FARM} ${POSITION} 0
      GetFarmData $FARMDATAFILE
      continue
     fi
    fi
   fi
   for SLOT in 0 1 2; do
     if $JQBIN '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].production['${SLOT}'].remain' $FARMDATAFILE 2>/dev/null | grep -q '-' ; then
       echo "Doing farm ${FARM}, position ${POSITION}, slot ${SLOT}..."
       if $JQBIN '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].production['${SLOT}'].guild|tonumber' $FARMDATAFILE 2>/dev/null | grep -q '1' ; then
        echo "(as a Guild job)"
        GUILDJOB=true
       fi
       DoFarm ${FARM} ${POSITION} ${SLOT}
     fi
     if [ $SLOT -eq 0 ]; then
      if $JQBIN '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].water[0].waterremain' $FARMDATAFILE 2>/dev/null | grep -q '-' ; then
       echo "Watering farm ${FARM}, position ${POSITION}, slot ${SLOT}..."
       if [ $PREMIUM -eq 1 ]; then
        SendAJAXFarmRequest "mode=watergarden&farm=${FARM}&position=${POSITION}"
       else
        water_FieldNP $FARM $POSITION
       fi
      fi
     fi
   done
  done
 done
 # reset queue correction flag if set
 sed -i 's/correctqueuenum = 1/correctqueuenum = 0/' $CFGFILE

 # work farmers market
 echo "Checking for pending tasks on farmers market..."
 # first the flower area. we'll only check one of 'em.
 if $JQBIN '.updateblock.farmersmarket.flower_area["1"].remain' $FARMDATAFILE 2>/dev/null | grep -q '-' ; then
   echo "Doing flower area..."
   DoFarmersMarket farmersmarket flowerarea 0
 fi
 # nursery is next
 for SLOT in 1 2; do
   if $JQBIN '.updateblock.farmersmarket.nursery.slots["'${SLOT}'"].remain' $FARMDATAFILE 2>/dev/null | grep -q '-' ; then
     echo "Doing nursery slot ${SLOT}..."
     DoFarmersMarket farmersmarket nursery ${SLOT}
   fi
 done
 # see if flower pots need water...
 NUMPOTS=$($JQBIN '.updateblock.farmersmarket.flower_slots.slots|length' $FARMDATAFILE)
 if [ $NUMPOTS -gt 0 ]; then
  NUMPOTS=$((NUMPOTS-1))
  for SLOTINDEX in $(seq 0 $NUMPOTS); do
   SLOT=$($JQBIN '.updateblock.farmersmarket.flower_slots.slots|keys['$SLOTINDEX']|tonumber' $FARMDATAFILE)
   if ! $JQBIN '.updateblock.farmersmarket.flower_slots.slots["'${SLOT}'"].remain' $FARMDATAFILE 2>/dev/null | grep -q '-' ; then
    POTTED=$($JQBIN '.updateblock.farmersmarket.flower_slots.slots["'${SLOT}'"].pid|tonumber' $FARMDATAFILE 2>/dev/null)
    # skip watering of special flowers
    if [ $POTTED -ne 220 ] && [ $POTTED -ne 221 ]; then
     # skip plants that don't need water anymore
     if [ "$($JQBIN '.updateblock.farmersmarket.flower_slots.slots["'${SLOT}'"].remain' $FARMDATAFILE)" != "$($JQBIN '.updateblock.farmersmarket.flower_slots.slots["'${SLOT}'"].waterremain' $FARMDATAFILE)" ]; then
      echo "Watering flower pot ${SLOT}..."
      DoFarmersMarketFlowerPots ${SLOT}
     fi
    fi
   fi
  done
 fi
 # monster fruit
 RUNCHK=$($JQBIN '.updateblock.farmersmarket.megafruit.current' $FARMDATAFILE)
 if [ "$RUNCHK" != "0" ] && [ "$RUNCHK" != "null" ]; then
  if ! $JQBIN '.updateblock.farmersmarket.megafruit.current.remain' $FARMDATAFILE | grep -q '-' ; then
   for HELPER in water light fertilize; do
    if $JQBIN '.updateblock.farmersmarket.megafruit.current.data.'${HELPER}'.remain' $FARMDATAFILE | grep -q '-' ; then
     echo "Using ${HELPER} on monster fruit..."
     DoFarmersMarket farmersmarket monsterfruit ${HELPER}
    fi
   done
  fi
 fi
 # food contest
 RUNCHK=$($JQBIN '.updateblock.farmersmarket.foodcontest.current' $FARMDATAFILE)
 if [ "$RUNCHK" != "0" ] && [ "$RUNCHK" != "null" ]; then
  if ! $JQBIN '.updateblock.farmersmarket.foodcontest.current.remain' $FARMDATAFILE | grep -q '-' ; then
 # check for a ready cash desk first
   if $JQBIN '.updateblock.farmersmarket.foodcontest.current.data.merchpin_remain' $FARMDATAFILE | grep -q '-' ; then
     echo "Doing cash desk..."
     DoFoodContestCashDesk
   fi
 # next the audience
   for BLOCK in 1 2 3 4; do
    for PINTYPE in fame money points products; do
     if $JQBIN '.updateblock.farmersmarket.foodcontest.blocks["'${BLOCK}'"].pin.'${PINTYPE}'.remain' $FARMDATAFILE | grep -q '-' ; then
      echo "Picking up ${PINTYPE} from block ${BLOCK}..."
      DoFoodContestAudience ${BLOCK} ${PINTYPE}
     fi
    done
   done
 # feed the contestant if needed
   if $JQBIN '.updateblock.farmersmarket.foodcontest.current.feedremain' $FARMDATAFILE | grep -q '-' ; then
    echo "Feeding contestant..."
    DoFoodContestFeeding
   fi
  fi
 fi
 # check for active pet breeding
 PETBREEDING=$($JQBIN '.updateblock.farmersmarket.pets.breed' $FARMDATAFILE 2>/dev/null)
 if [ "$PETBREEDING" != "0" ]; then
  for SLOT in food toy plushy; do
   CAREREMAIN=$($JQBIN '.updateblock.farmersmarket.pets.breed.care_remains["'${SLOT}'"]' $FARMDATAFILE 2>/dev/null)
   if [ "$CAREREMAIN" == "null" ] || [ "$CAREREMAIN" == "[]" ]; then
    echo "Taking care of pet using ${SLOT}..."
    DoFarmersMarketPetCare ${SLOT}
   fi
  done
 fi
 # stuff for pets production
 for SLOT in 1 2 3; do
  PETSREMAIN=$($JQBIN '.updateblock.farmersmarket.pets.production["'${SLOT}'"]["1"].remain' $FARMDATAFILE 2>/dev/null)
   if [ "$PETSREMAIN" = "0" ]; then
     echo "Doing pets stuff production slot ${SLOT}..."
     DoFarmersMarket farmersmarket pets ${SLOT}
   fi
 done
 # veterinarian
 for SLOT in 1 2 3; do
  VETREMAIN=$($JQBIN '.updateblock.farmersmarket.vet.production["'${SLOT}'"]["1"].remain' $FARMDATAFILE 2>/dev/null)
   if [ "$VETREMAIN" = "0" ]; then
     echo "Doing vet production slot ${SLOT}..."
     DoFarmersMarket farmersmarket vet ${SLOT}
   fi
 done
 # animal treatment
 # check for running treatment job
 VETJOBSTATUS=$($JQBIN '.updateblock.farmersmarket.vet.info.role|tonumber' $FARMDATAFILE 2>/dev/null)
 if [ "$VETJOBSTATUS" != "0" ] && [ "$VETJOBSTATUS" != "" ]; then
  for SLOT in 1 2 3; do
   if $JQBIN '.updateblock.farmersmarket.vet.animals.slots["'${SLOT}'"].remain' $FARMDATAFILE | grep -q '-' ; then
   echo "Doing animal treatment slot ${SLOT}..."
   DoFarmersMarketAnimalTreatment ${SLOT}
   fi
  done
 fi
 # butterfly house
 for SLOT in 1 2 3 4 5 6; do
  if $JQBIN '.updateblock.farmersmarket.butterfly.data.breed["'${SLOT}'"].remain?' $FARMDATAFILE 2>/dev/null | grep -q '-' ; then
  echo "Doing butterfly house slot ${SLOT}..."
  SendAJAXFarmRequest "slot=${SLOT}&mode=butterfly_carebreed"
  fi
 done

 # transport vehicle handling
 if ! grep -q "vehiclemgmt5 = 0" $CFGFILE; then
  # parameters are farm no. and route no.
  check_VehiclePosition 5 1
 fi
 if ! grep -q "vehiclemgmt6 = 0" $CFGFILE; then
  check_VehiclePosition 6 2
 fi

 if grep -q "sendfarmiesaway = 1" $CFGFILE; then
  echo "Checking for waiting farmies..."
  NUMFARMIES=$($JQBIN '.updateblock.farmis[0]|length' $FARMDATAFILE)
  if [ $NUMFARMIES -gt 0 ] 2>/dev/null; then
   NUMFARMIES=$((NUMFARMIES-1))
   for FARMIE in $(seq 0 $NUMFARMIES); do
    ID=$($JQBIN '.updateblock.farmis[0]['${FARMIE}'].id|tonumber' $FARMDATAFILE)
    echo "Sending farmie no. $((FARMIE+1)) (ID ${ID}) away..."
    SendAJAXFarmRequest "mode=sellfarmi&farm=1&position=1&id=${ID}&farmi=${ID}&status=2"
   done
  fi
 fi

 if grep -q "sendflowerfarmiesaway = 1" $CFGFILE; then
  echo "Checking for waiting flower farmies..."
  NUMFARMIES=$($JQBIN '.updateblock.farmersmarket.farmis|length' $FARMDATAFILE)
  if [ $NUMFARMIES -gt 0 ] 2>/dev/null; then
   NUMFARMIES=$((NUMFARMIES-1))
   for FARMIE in $(seq 0 $NUMFARMIES); do
    ID=$($JQBIN '.updateblock.farmersmarket.farmis['${FARMIE}'].id|tonumber' $FARMDATAFILE)
    echo "Sending flower farmie no. $((FARMIE+1)) (ID ${ID}) away..."
    SendAJAXFarmRequest "mode=handleflowerfarmi&farm=1&position=1&id=${ID}&farmi=${ID}&status=2"
   done
  fi
 fi

 # daily actions
 if ! grep -q "dodog = 0" $CFGFILE; then
  echo -n "Checking for daily dog bonus..."
  DOGEXISTS=$($JQBIN '.updateblock.menue.farmdog?' $FARMDATAFILE)
  DOGSTATUS=$($JQBIN '.updateblock.menue.farmdog_harvest?' $FARMDATAFILE)
  if [ "$DOGEXISTS" = "1" ] && [ "$DOGSTATUS" = "null" ]; then
   echo "not yet claimed, activating it..."
   SendAJAXFarmRequest "mode=dogbonus&farm=1&position=0"
   # reduce pause time by 5 mins after claiming the dogs' time bonus
   PAUSETIME=$((PAUSETIME-5))
  else
   echo "already claimed"
  fi
 fi

 if grep -q "dopuzzleparts = 1" $CFGFILE; then
  echo -n "Checking for buyable puzzle parts..."
  PARTSSTATUS=$($JQBIN '.updateblock.farmersmarket.pets.daily' $FARMDATAFILE 2>&1)
  if [ "$PARTSSTATUS" = "1" ]; then
   echo "available, buying it..."
   SendAJAXFarmRequest "mode=pets_buy_parts&id=1&amount=1"
  else
   echo "already bought"
  fi
 fi

 if grep -q "redeempuzzlepacks = 1" $CFGFILE; then
  redeemPuzzlePartsPacks
 fi

 if grep -q "dobutterflies = 1" $CFGFILE; then
  echo "Checking for butterfly points bonus..."
  check_ButterflyBonus
 fi

 if grep -q "dodeliveryevent = 1" $CFGFILE; then
  echo "Checking for running delivery event..."
  check_DeliveryEvent
 fi

 # contents of FARMDATAFILE change from here !
 if ! grep -q "dolot = 0" $CFGFILE; then
   echo -n "Checking for daily lottery bonus..."
   GetLotteryData "$FARMDATAFILE"
   LOTSTATUS=$($JQBIN '.datablock[2]' $FARMDATAFILE)
  if [ "$LOTSTATUS" = "0" ]; then
   CFGLINE=$(grep dolot $CFGFILE)
   TOKENS=( $CFGLINE )
   iLot=${TOKENS[2]}
   echo "not yet claimed, getting it..."
   SendAJAXCityRequest "city=2&mode=newlot"
   if [ "$iLot" = "2" ]; then
    echo "and trading it for an instant-win..."
    sleep 1
    SendAJAXCityRequest "city=2&mode=lotgetprize"
   fi
  else
   echo "already claimed"
  fi
 fi

 echo "Getting forestry status..."
 GetForestryData $FARMDATAFILE

 echo "Checking for pending tasks in forestry..."
 # first the trees ... we'll only check one of 'em. timer ends at '0'
 if [ "$($JQBIN '.datablock[1][0].remain' $FARMDATAFILE 2>/dev/null)" = "0" ] 2>/dev/null; then
   echo "Doing trees..."
   DoForestry forestry
 fi
 if [ "$($JQBIN '.datablock[1][0].waterremain' $FARMDATAFILE 2>/dev/null)" = "0" ] 2>/dev/null;  then
   echo "Watering trees..."
   water_Tree
 fi
 # then the forestry buildings
 for POSITION in 1 2; do
  for SLOT in 1 2; do
    if $JQBIN '.datablock[2]["'${POSITION}'"].slots["'${SLOT}'"].remain' $FARMDATAFILE | grep -q '-' ; then
      echo "Doing position ${POSITION}, slot ${SLOT}..."
      DoFarm forestry ${POSITION} ${SLOT}
    fi
  done
 done
 # finally the forestry farmies
 if grep -q "sendforestryfarmiesaway = 1" $CFGFILE; then
  echo "Checking for waiting forestry farmies..."
  NUMFARMIES=$($JQBIN '.datablock[5]|length' $FARMDATAFILE)
  if [ $NUMFARMIES -gt 0 ] 2>/dev/null; then
   NUMFARMIES=$((NUMFARMIES-1))
   for FARMIE in $(seq 0 $NUMFARMIES); do
    ID=$($JQBIN '.datablock[5]['${FARMIE}'].farmiid|tonumber' $FARMDATAFILE)
    echo "Sending forestry farmie no. $((FARMIE+1)) (ID ${ID}) away..."
    SendAJAXForestryRequest "action=kickfarmi&productid=${ID}"
   done
  fi
 fi

 echo "Getting food world status..."
 GetFoodWorldData $FARMDATAFILE

 echo "Checking for pending tasks in food world..."
 for POSITION in 1 2 3 4; do
  for SLOT in 1 2; do
    # readiness in food world is signalled by a "ready:1" value
    if $JQBIN '.datablock.buildings["'${POSITION}'"].slots["'${SLOT}'"].ready' $FARMDATAFILE 2>/dev/null | grep -q '1' ; then
      echo "Doing position ${POSITION}, slot ${SLOT}..."
      DoFarm foodworld ${POSITION} ${SLOT}
    fi
  done
 done
 # munchies
 if grep -q "sendmunchiesaway = 1" $CFGFILE; then
  echo "Checking for waiting munchies..."
  NUMFARMIES=$($JQBIN '.datablock.farmis|length' $FARMDATAFILE)
  if [ $NUMFARMIES -gt 0 ] 2>/dev/null; then
   NUMFARMIES=$((NUMFARMIES-1))
   for FARMIE in $(seq 0 $NUMFARMIES); do
    ID=$($JQBIN '.datablock.farmis['${FARMIE}'].id|tonumber' $FARMDATAFILE)
    echo "Sending munchie no. $((FARMIE+1)) (ID ${ID}) away..."
    SendAJAXFoodworldRequest "action=kick&id=${ID}&table=0&chair=0"
   done
  fi
 fi
 # this is the only building with a queue in city 2, and it's unlikely for this
 # to ever change, hence static coding
 echo "Getting wind mill status..."
 GetWindMillData $FARMDATAFILE

 echo "Checking for pending tasks in wind mill..."
 # we handle two slots
 if $JQBIN '.datablock[2]["1"].remain' $FARMDATAFILE 2>/dev/null | grep -q '-' ; then
  echo "Doing wind mill, slot 1..."
  DoFarm city2 windmill 1
 fi
 if $JQBIN '.datablock[2]["2"].remain' $FARMDATAFILE 2>/dev/null | grep -q '-' ; then
  echo "Doing wind mill, slot 2..."
  DoFarm city2 windmill 2
 fi

 echo "Logging off..."
 wget -nv -a $LOGFILE --output-document=/dev/null --user-agent="$AGENT" --load-cookies $COOKIEFILE "$LOGOFFURL"
 # housekeeping -- adjust to your liking
 rm $COOKIEFILE $FARMDATAFILE $OUTFILE
 echo -n "Time stamp: "
 date "+%A, %d. %B %Y - %H:%Mh" | tee $LASTRUNFILE
 echo "Pausing $PAUSETIME mins..."
 echo "---"
 rm -f "$STATUSFILE"
 sleep ${PAUSETIME}m
done
