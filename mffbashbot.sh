#!/bin/bash
# Harrys My Free Farm Bash Bot
# Copyright 2016 Harun "Harry" Basalamah
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

# as are 2 and 3
: ${2:?No MFF password provided}
: ${3:?No MFF server provided}

cd $1
umask 002
PIDFILE=bashpid.txt
echo $BASHPID > "$PIDFILE"
while (true); do
# variables
MFFUSER=$1
MFFPASS=$2
MFFSERVER=$3
VERSION=$(cat ../version.txt)
PAUSETIME=10
LOGFILE=mffbot.log
OUTFILE=mffbottemp.html
COOKIEFILE=mffcookies.txt
FARMDATAFILE=farmdata.txt
LASTRUNFILE=lastrun.txt
STATUSFILE=status.txt
CFGFILE=config.ini
echo "<font color=\"red\">aktiv</font>" > "$STATUSFILE"
# remove lingering cookies
rm $COOKIEFILE 2>/dev/null
NANOVALUE=$(echo $(($(date +%s%N)/1000000)))
LOGOFFURL="http://s${MFFSERVER}.myfreefarm.de/main.php?page=logout&logoutbutton=1"
POSTURL="http://www.myfreefarm.de/ajax/createtoken2.php?n=${NANOVALUE}"
AGENT="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0"
# There's another AGENT string in logonandgetfarmdata.sh (!)
POSTDATA="server=${MFFSERVER}&username=${MFFUSER}&password=${MFFPASS}&ref=and&retid="
JQBIN=/usr/bin/jq

echo "Running Harrys My Free Farm Bash Bot $VERSION"
echo "Getting a token to MFF server ${MFFSERVER}"
# backslashes need to be escaped within backticks
# echo "Got a (hopefully valid) login token"
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

# get farm status
echo "Getting farm status..."
GetFarmData $FARMDATAFILE

for FARM in 1 2 3 4 5; do
 echo "Checking for pending tasks on farm ${FARM}..."
 for POSITION in 1 2 3 4 5 6; do
  BUILDINGID=$($JQBIN '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].buildingid|tonumber' $FARMDATAFILE 2>/dev/null)
  if [ "$BUILDINGID" = "19" ]; then
   DoFarm ${FARM} ${POSITION} 0
   continue
  fi
  for SLOT in 0 1 2; do
    if $JQBIN '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].production['${SLOT}'].remain' $FARMDATAFILE 2>/dev/null | grep '-' >/dev/null ; then
      echo "Doing farm ${FARM}, position ${POSITION}, slot ${SLOT}..."
      if $JQBIN '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].production['${SLOT}'].guild|tonumber' $FARMDATAFILE 2>/dev/null | grep '1' >/dev/null ; then
       echo "(as a Guild job)"
       GUILDJOB=true
      fi
      DoFarm ${FARM} ${POSITION} ${SLOT}
    fi
    if [ $SLOT -eq 0 ]; then
     if $JQBIN '.updateblock.farms.farms["'${FARM}'"]["'${POSITION}'"].water[0].waterremain' $FARMDATAFILE 2>/dev/null | grep '-' >/dev/null ; then
      echo "Watering farm ${FARM}, position ${POSITION}, slot ${SLOT}..."
      SendAJAXFarmRequest "mode=watergarden&farm=${FARM}&position=${POSITION}"
     fi
    fi
  done
 done
done

# work farmers market
echo "Checking for pending tasks on farmers market..."
# first the flower area. we'll only check one of 'em.
if $JQBIN '.updateblock.farmersmarket.flower_area["1"].remain' $FARMDATAFILE 2>/dev/null | grep '-' >/dev/null ; then
  echo "Doing flower area..."
  DoFarmersMarket farmersmarket flowerarea 0
fi
# nursery is next
for SLOT in 1 2; do
  if $JQBIN '.updateblock.farmersmarket.nursery.slots["'${SLOT}'"].remain' $FARMDATAFILE 2>/dev/null | grep '-' >/dev/null ; then
    echo "Doing nursery slot ${SLOT}..."
    DoFarmersMarket farmersmarket nursery ${SLOT}
  fi
done
# see if flower pots need water...
for SLOT in {1..17}; do
 # check if water is needed and pot hasn't withered yet
 $JQBIN -e '.updateblock.farmersmarket.flower_slots.slots["'${SLOT}'"].waterremain' $FARMDATAFILE >/dev/null 2>&1
 if [ $? -ne 1 -a $? -ne 4 ]; then
  if ! $JQBIN '.updateblock.farmersmarket.flower_slots.slots["'${SLOT}'"].remain' $FARMDATAFILE 2>/dev/null | grep '-' >/dev/null; then
   POTTED=$($JQBIN '.updateblock.farmersmarket.flower_slots.slots["'${SLOT}'"].pid|tonumber' $FARMDATAFILE 2>/dev/null)
   # skip watering of special flowers
   if [ $POTTED -ne 220 -a $POTTED -ne 221 ]; then
    echo "Watering flower pot ${SLOT}..."
    DoFarmersMarketFlowerPots ${SLOT}
   fi
  fi
 fi
done
# monster fruit
if ! $JQBIN '.updateblock.farmersmarket.megafruit.current.remain' $FARMDATAFILE | grep '-' >/dev/null ; then
  for HELPER in water light fertilize; do
    if $JQBIN '.updateblock.farmersmarket.megafruit.current.data.'${HELPER}'.remain' $FARMDATAFILE | grep '-' >/dev/null ; then
      echo "Using ${HELPER} on monster fruit..."
      DoFarmersMarket farmersmarket monsterfruit ${HELPER}
    fi
  done
fi
# food contest
$JQBIN -e '.updateblock.farmersmarket.foodcontest.current.remain' $FARMDATAFILE >/dev/null 2>&1
if [ $? -ne 1 -a $? -ne 4 ]; then
# check for a ready cash desk first
 if $JQBIN '.updateblock.farmersmarket.foodcontest.current.data.merchpin_remain' $FARMDATAFILE | grep '-' >/dev/null ; then
   echo "Doing cash desk..."
   DoFoodContestCashDesk
 fi
# next the audience
 for BLOCK in 1 2 3 4; do
  for PINTYPE in fame money points products; do
    if $JQBIN '.updateblock.farmersmarket.foodcontest.blocks["'${BLOCK}'"].pin.'${PINTYPE}'.remain' $FARMDATAFILE | grep '-' >/dev/null ; then
      echo "Picking up ${PINTYPE} from block ${BLOCK}..."
      DoFoodContestAudience ${BLOCK} ${PINTYPE}
    fi
  done
 done
# feed the contestant if needed
  if $JQBIN '.updateblock.farmersmarket.foodcontest.current.feedremain' $FARMDATAFILE | grep '-' >/dev/null ; then
    echo "Feeding contestant..."
    DoFoodContestFeeding
  fi
fi
# check for active pet breeding
PETBREEDING=$($JQBIN '.updateblock.farmersmarket.pets.breed' $FARMDATAFILE 2>/dev/null)
if [ "$PETBREEDING" != "0" ]; then
 for SLOT in food toy plushy; do
  CAREREMAIN=$($JQBIN '.updateblock.farmersmarket.pets.breed.happiness_interval.'${SLOT}'' $FARMDATAFILE 2>/dev/null)
  if [ "$CAREREMAIN" != "1" ]; then
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
VETJOBSTATUS=$($JQBIN '.updateblock.farmersmarket.vet.info.role|tonumber' $FARMDATAFILE)
if [ "$VETJOBSTATUS" != "0" ]; then
 for SLOT in 1 2 3; do
  if $JQBIN '.updateblock.farmersmarket.vet.animals.slots["'${SLOT}'"].remain' $FARMDATAFILE | grep -q '-' ; then
  echo "Doing animal treatment slot ${SLOT}..."
  DoFarmersMarketAnimalTreatment ${SLOT}
  fi
 done
fi

# transport vehicle handling
if ! grep vehiclemgmt $CFGFILE | grep -q 0; then
  echo -n "Transport vehicle is "
  CFGLINE=$(grep vehiclemgmt $CFGFILE)
  TOKENS=( $CFGLINE )
  iVehicle=${TOKENS[2]}
  if ! $JQBIN -e '.updateblock.map.vehicles["1"]["'${iVehicle}'"].remain' $FARMDATAFILE >/dev/null; then
   iCurrentVehiclePos=$($JQBIN '.updateblock.map.vehicles["1"]["'$iVehicle'"].current|tonumber' $FARMDATAFILE)
   if [ "$iCurrentVehiclePos" = "1" ]; then
    echo "on farm 1, sending it to farm 5"
    SendAJAXFarmRequest "mode=map_sendvehicle&farm=1&position=1&route=1&vehicle=${iVehicle}&cart="
   else
    # assuming farm 5 here
    echo "on farm 5"
    # check if sending a full vehicle is possible
    check_VehicleFullLoad $iVehicle 5
   fi
  else
   echo "en route"
  fi
fi

# daily actions
if ! grep dodog $CFGFILE | grep -q 0; then
 echo -n "Checking for daily dog bonus..."
 DOGSTATUS=$($JQBIN '.updateblock.menue.farmdog_harvest' $FARMDATAFILE)
 if [ "$DOGSTATUS" != "1" ]; then
  echo "not yet claimed, activating it..."
  SendAJAXFarmRequest "mode=dogbonus&farm=1&position=0"
  # reduce pause time to 5 mins after claiming the (dog) time bonus
  PAUSETIME=5
 else
  echo "already claimed"
 fi
fi

if ! grep dolot $CFGFILE | grep -q 0; then
  echo -n "Checking for daily lottery bonus..."
  GetLotteryData "$FARMDATAFILE"
  LOTSTATUS=$($JQBIN '.datablock[2]' $FARMDATAFILE)
 if [ "$LOTSTATUS" = "0" ]; then
  CFGLINE=$(grep dolot $CFGFILE)
  TOKENS=( $CFGLINE )
  iLot=${TOKENS[2]}
  echo "not yet claimed, getting lottery ticket..."
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

# get forestry status
echo "Getting forestry status..."
GetForestryData $FARMDATAFILE

echo "Checking for pending tasks in forestry..."
# first the trees ... we'll only check one of 'em. timer ends at '0'
if [ $($JQBIN '.datablock[1][0].remain' $FARMDATAFILE) = "0" ];  then
  echo "Doing trees..."
  DoForestry forestry
fi
if [ $($JQBIN '.datablock[1][0].waterremain' $FARMDATAFILE) = "0" ];  then
  echo "Watering trees..."
  water_Tree
fi
# then the forestry buildings
for POSITION in 1 2; do
 for SLOT in 1 2; do
   if $JQBIN '.datablock[2]["'${POSITION}'"].slots["'${SLOT}'"].remain' $FARMDATAFILE | grep '-' >/dev/null ; then
     echo "Doing position ${POSITION}, slot ${SLOT}..."
     DoFarm forestry ${POSITION} ${SLOT}
   fi
 done
done

# get food world status
echo "Getting food world status..."
GetFoodWorldData $FARMDATAFILE

echo "Checking for pending tasks in food world..."
for POSITION in 1 2 3 4; do
 for SLOT in 1 2; do
   # readiness in food world is signalled by a "ready:1" value
   if $JQBIN '.datablock.buildings["'${POSITION}'"].slots["'${SLOT}'"].ready' $FARMDATAFILE 2>/dev/null | grep '1' >/dev/null; then
     echo "Doing position ${POSITION}, slot ${SLOT}..."
     DoFarm foodworld ${POSITION} ${SLOT}
   fi
 done
done

# get wind mill status
# this is the only building with a queue in city 2, and it's unlikely for this
# to ever change, hence static coding
echo "Getting wind mill status..."
GetWindMillData $FARMDATAFILE

echo "Checking for pending tasks in wind mill..."
# we only handle one slot here
if $JQBIN '.datablock[2]["1"].remain' $FARMDATAFILE 2>/dev/null | grep '-' >/dev/null; then
 echo "Doing wind mill, slot 1..."
 DoFarm city2 windmill 0
fi

echo "Logging off..."
wget -nv -a $LOGFILE --output-document=/dev/null --user-agent="$AGENT" --load-cookies $COOKIEFILE "$LOGOFFURL"
# housekeeping -- adjust to your liking
rm $COOKIEFILE $FARMDATAFILE $OUTFILE
echo -n "Time stamp: "
echo $(date "+%A, %d. %B %Y - %H:%Mh") | tee $LASTRUNFILE
echo "Pausing $PAUSETIME mins..."
echo "---"
echo "<font color=\"green\">inaktiv</font>" > "$STATUSFILE"
sleep ${PAUSETIME}m
done
