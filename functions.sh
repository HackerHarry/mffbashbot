# Functions file for Harry's My Free Farm Bash Bot
# Copyright 2016-18 Harun "Harry" Basalamah
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

function WGETREQ {
 sHTTPReq=$1
 wget -nv -T10 -a $LOGFILE --output-document=/dev/null --user-agent="$AGENT" --load-cookies $COOKIEFILE $sHTTPReq
}
AJAXURL="http://s${MFFSERVER}.${DOMAIN}/ajax/"
AJAXFARM="${AJAXURL}farm.php?rid=${RID}&"
AJAXFOREST="${AJAXURL}forestry.php?rid=${RID}&"
AJAXFOOD="${AJAXURL}foodworld.php?rid=${RID}&"
AJAXCITY="${AJAXURL}city.php?rid=${RID}&"
AJAXMAIN="${AJAXURL}main.php?rid=${RID}&"
AJAXGUILD="${AJAXURL}guild.php?rid=${RID}&"

function exitBot {
 echo "Caught an exit signal"
 if [ -e "$STATUSFILE" ]; then
  echo "Logging off..."
  WGETREQ "$LOGOFFURL"
  rm -f "$STATUSFILE" "$COOKIEFILE" "$FARMDATAFILE" "$OUTFILE" "$TMPFILE" "$PIDFILE"
 fi
 echo "Exiting..."
 exit 0
}

function GetFarmData {
 local sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXFARM}mode=getfarms&farm=1&position=0"
}

function GetForestryData {
 local sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXFOREST}action=initforestry"
}

function GetFoodWorldData {
 local sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXFOOD}action=foodworld_init&id=0&table=0&chair=0"
}

function GetLotteryData {
 sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXCITY}city=2&mode=initlottery"
}

function GetWindMillData {
 local sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXCITY}city=2&mode=windmillinit"
}

function GetPanData {
 local sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXFARM}mode=showpan&farm=1&position=0"
}

function GetInnerInfoData {
 local sFile=$1
 local iFarm=$2
 local iPosition=$3
 local sMode=$4
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXFARM}mode=${sMode}&farm=${iFarm}&position=${iPosition}"
}

function GetOlympiaData {
 sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXMAIN}action=olympia_init"
}

function DoFarm {
 # read function from queue file
 local iFarm=$1
 # for the forestry this should be called sFarm.. but what the hell.
 local iPosition=$2
 local iSlot=$3
 if check_QueueSleep ${iFarm}/${iPosition}/${iSlot}; then
  echo "Set to sleep"
  return
 fi
 local sFunction=$(head -1 ${iFarm}/${iPosition}/${iSlot})
 # now we should know which function to call
 harvest_${sFunction} ${iFarm} ${iPosition} ${iSlot}
 start_${sFunction}${NONPREMIUM} ${iFarm} ${iPosition} ${iSlot}
 update_queue ${iFarm} ${iPosition} ${iSlot}
}

function harvest_Stable {
 local iFarm=$1
 local iPosition=$2
 SendAJAXFarmRequest "mode=inner_crop&farm=${iFarm}&position=${iPosition}"
}

function start_Stable {
 # get parameters from line 2
 # since stable takes two parameters, we need to split 'em
 local iFarm=$1
 local iPosition=$2
 local aParams=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 IFS=,
 set -- $aParams
 unset IFS
 local iPID=$1
 local iAmount=$2
 # feeding
 local sAJAXSuffix="mode=inner_feed&farm=${iFarm}&position=${iPosition}&pid=${iPID}&amount=${iAmount}"
 if [ "$GUILDJOB" = true ]; then
  local sAJAXSuffix="${sAJAXSuffix}&guildjob=1"
  # reset guild job flag
  GUILDJOB=false
 fi
 SendAJAXFarmRequest $sAJAXSuffix
}

function start_StableNP {
 start_Stable $1 $2
}

function harvest_KnittingMill {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iRealSlot=$(get_RealSlotName $iFarm $iPosition $iSlot)
 SendAJAXFarmRequest "position=${iPosition}&mode=crop&slot=${iRealSlot}&farm=${iFarm}"
}

function start_KnittingMill {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iRealSlot=$(get_RealSlotName $iFarm $iPosition $iSlot)
 # Knitting Mill takes one parameter
 local iPID=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 # PIDs start at 1 for this building type
 iPID=$((iPID-154))
 local sAJAXSuffix="position=${iPosition}&item=${iPID}&mode=start&slot=${iRealSlot}&farm=${iFarm}"
 if [ "$GUILDJOB" = true ]; then
  local sAJAXSuffix="${sAJAXSuffix}&guildjob=1"
  GUILDJOB=false
 fi
 # do the knitting
 SendAJAXFarmRequest $sAJAXSuffix
}

function start_KnittingMillNP {
 start_KnittingMill $1 $2 $3
}

function harvest_OilMill {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # slot index in oil mill doesn't always match slot "name"
 local iRealSlot=$(get_RealSlotName $iFarm $iPosition $iSlot)
 # oil mills use slots 1, 2 and 3 instead of 0, 1... FFS
 SendAJAXFarmRequest "position=${iPosition}&mode=crop&slot=${iRealSlot}&farm=${iFarm}"
}

function start_OilMill {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # oil mills use slots 1, 2 and 3 FFS
 # Special Oil Mill takes one parameter
 local iPID=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 # PIDs start at 1 for this building type
 iPID=$((iPID-115))
 local iRealSlot=$(get_RealSlotName $iFarm $iPosition $iSlot)
 # do the mill
 SendAJAXFarmRequest "position=${iPosition}&oil=${iPID}&mode=start&slot=${iRealSlot}&farm=${iFarm}"
}

function start_OilMillNP {
 start_OilMill $1 $2 $3
}

 function harvest_TeaFactory {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iRealSlot=$(get_RealSlotName $iFarm $iPosition $iSlot)
 SendAJAXFarmRequest "position=${iPosition}&mode=crop&slot=${iRealSlot}&farm=${iFarm}"
}

function start_TeaFactory {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 # PIDs start at 1 for this building type
 iPID=$((iPID-749))
 # this only works cuz the farm data isn't updated in between harvesting and planting (!)
 local iRealSlot=$(get_RealSlotName $iFarm $iPosition $iSlot)
 SendAJAXFarmRequest "farm=${iFarm}&position=${iPosition}&slot=${iRealSlot}&item=${iPID}&mode=start"
}

function start_TeaFactoryNP {
 start_TeaFactory $1 $2 $3
}

function harvest_Factory {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 SendAJAXFarmRequest "mode=getadvancedcrop&farm=${iFarm}&position=${iPosition}"
}

function start_Factory {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # Factory takes one parameter
 local iPID=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 local sAJAXSuffix="mode=setadvancedproduction&farm=${iFarm}&position=${iPosition}&id=${iPID}&product=${iPID}"
 if [ "$GUILDJOB" = true ]; then
  local sAJAXSuffix="${sAJAXSuffix}&guildjob=1"
  GUILDJOB=false
 fi
 # start the factory
 SendAJAXFarmRequest $sAJAXSuffix
}

function start_FactoryNP {
 start_Factory $1 $2 $3
}

function harvest_Farm {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 SendAJAXFarmRequest "mode=cropgarden&farm=${iFarm}&position=${iPosition}"
}

function start_Farm {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # Farm takes one parameter
 local iPID=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 # start the farm
 SendAJAXFarmRequest "mode=autoplant&farm=${iFarm}&position=${iPosition}&id=${iPID}&product=${iPID}"
 # water the farm
 SendAJAXFarmRequest "mode=watergarden&farm=${iFarm}&position=${iPosition}"
}

function start_FarmNP {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # fetch garden data
 GetInnerInfoData $TMPFILE $iFarm $iPosition gardeninit
 local iProduct=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 local iProductDim_x=$(echo $aDIM_X | $JQBIN '."'${iProduct}'" | tonumber')
 local iProductDim_y=$(echo $aDIM_Y | $JQBIN '."'${iProduct}'" | tonumber')
 local iPlot=1
 local iCache=0
 local iCacheFlag=0
 local sData="mode=garden_plant&farm=${iFarm}&position=${iPosition}&"
 local sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
 while (true); do
  if [ $iPlot -gt 120 ]; then
   if [ $iCacheFlag -eq 1 ]; then
    SendAJAXFarmRequest "${sData}cid=${iPosition}"
    SendAJAXFarmRequest "${sDataWater}"
    iCacheFlag=0
    iCache=0
   fi
   if ! check_RipePlotOnField $iFarm $iPosition; then
    GetFarmData $FARMDATAFILE
    return
   fi
   # there's more to harvest on this very field
   harvest_Farm $iFarm $iPosition $iSlot
   GetInnerInfoData $TMPFILE $iFarm $iPosition gardeninit
   iPlot=1
  fi
 # don't plant on last column if x-dim is 2
 if ! ((iPlot % 12)); then
  if [ $iProductDim_x -eq 2 ]; then
   iPlot=$((iPlot+1))
   continue
  fi
 fi
 if [ $iPlot -ge 109 ] && [ $iProductDim_y -eq 2 ]; then
  if [ $iCacheFlag -eq 1 ]; then
   SendAJAXFarmRequest "${sData}cid=${iPosition}"
   SendAJAXFarmRequest "${sDataWater}"
   iCacheFlag=0
   iCache=0
  fi
  if ! check_RipePlotOnField $iFarm $iPosition; then
   GetFarmData $FARMDATAFILE
   return
  fi
  harvest_Farm $iFarm $iPosition $iSlot
  GetInnerInfoData $TMPFILE $iFarm $iPosition gardeninit
  iPlot=1
 fi
 if ! get_FieldPlotReadiness $iPlot ; then
  iPlot=$((iPlot+1))
  continue
 fi
 # plot can be used
 if [ $iProductDim_x -eq 1 ]; then
  # product dimensions is 1 x 1
  sData="${sData}pflanze[]=${iProduct}&feld[]=${iPlot}&felder[]=${iPlot}&"
  sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot}&"
  iCacheFlag=1
  iCache=$((iCache+1))
  if [ $iCache -eq 5 ]; then
   # CID is some water interval ID .. screw it.
   SendAJAXFarmRequest "${sData}cid=${iPosition}"
   SendAJAXFarmRequest "${sDataWater}"
   sData="mode=garden_plant&farm=${iFarm}&position=${iPosition}&"
   sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
   iPlot=$((iPlot+1))
   iCacheFlag=0
   iCache=0
   continue
  else
   iPlot=$((iPlot+1))
   continue
  fi
 fi
 # x dim is 2
 if ! get_FieldPlotReadiness $((iPlot+1)); then
  iPlot=$((iPlot+2))
  continue
 fi
 if [ $iProductDim_y -eq 1 ]; then
  # product dimensions is 1 x 2
  sData="${sData}pflanze[]=${iProduct}&feld[]=${iPlot}&felder[]=${iPlot},$((iPlot+1))&"
  sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot},$((iPlot+1))&"
  iCacheFlag=1
  iCache=$((iCache+1))
  if [ $iCache -eq 5 ]; then
   SendAJAXFarmRequest "${sData}cid=${iPosition}"
   SendAJAXFarmRequest "${sDataWater}"
   sData="mode=garden_plant&farm=${iFarm}&position=${iPosition}&"
   sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
   iPlot=$((iPlot+2))
   iCacheFlag=0
   iCache=0
   continue
  else
   iPlot=$((iPlot+2))
   continue
  fi
 fi
 # y dim is 2
 if ! get_FieldPlotReadiness $((iPlot+12)); then
  iPlot=$((iPlot+1))
  continue
 fi
 if ! get_FieldPlotReadiness $((iPlot+13)); then
  iPlot=$((iPlot+1))
  continue
 fi
 sData="${sData}pflanze[]=${iProduct}&feld[]=${iPlot}&felder[]=${iPlot},$((iPlot+1)),$((iPlot+12)),$((iPlot+13))&"
 sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot},$((iPlot+1)),$((iPlot+12)),$((iPlot+13))&"
 iCacheFlag=1
 iCache=$((iCache+1))
 if [ $iCache -eq 5 ]; then
  SendAJAXFarmRequest "${sData}cid=${iPosition}"
  SendAJAXFarmRequest "${sDataWater}"
  sData="mode=garden_plant&farm=${iFarm}&position=${iPosition}&"
  sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
  iPlot=$((iPlot+2))
  iCacheFlag=0
  iCache=0
  continue
 else
  iPlot=$((iPlot+2))
  continue
 fi
# you should not get here :)
 done
}

 function water_FieldNP {
 # this function only supports completely filled fields of the same crop size
 local iFarm=$1
 local iPosition=$2
 SendAJAXFarmRequestOverwrite "mode=gardeninit&farm=${iFarm}&position=${iPosition}"
 local iProductDim_x=$($JQBIN '.datablock[1]["1"].x' $FARMDATAFILE)
 local iProductDim_y=$($JQBIN '.datablock[1]["1"].y' $FARMDATAFILE)
 local sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
 local iPlot=1
 local iCache=0
 local iCacheFlag=0
 while (true); do
  if [ $iPlot -gt 120 ]; then
   if [ $iCacheFlag -eq 1 ]; then
    SendAJAXFarmRequest "${sDataWater}"
    GetFarmData $FARMDATAFILE
    return
   fi
  GetFarmData $FARMDATAFILE
  return
  fi
 if ! ((iPlot % 12)); then
  if [ $iProductDim_x -eq 2 ]; then
   iPlot=$((iPlot+1))
   continue
  fi
 fi
 if [ $iPlot -ge 109 ]; then
  if [ $iProductDim_y -eq 2 ]; then
   if [ $iCacheFlag -eq 1 ]; then
    SendAJAXFarmRequest "${sDataWater}"
    GetFarmData $FARMDATAFILE
    return
   else
    GetFarmData $FARMDATAFILE
    return
   fi
  fi
 fi
 if [ $iProductDim_x -eq 1 ]; then
  # product dimensions is 1 x 1
  sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot}&"
  iCacheFlag=1
  iCache=$((iCache+1))
  if [ $iCache -eq 5 ]; then
   SendAJAXFarmRequest "${sDataWater}"
   sleep 1
   sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
   iPlot=$((iPlot+1))
   iCacheFlag=0
   iCache=0
   continue
  else
   iPlot=$((iPlot+1))
   continue
  fi
 fi
 # x dim is 2
 if [ $iProductDim_y -eq 1 ]; then
  # product dimensions is 1 x 2
  sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot},$((iPlot+1))&"
  iCacheFlag=1
  iCache=$((iCache+1))
  if [ $iCache -eq 5 ]; then
   SendAJAXFarmRequest "${sDataWater}"
   sleep 1
   sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
   iPlot=$((iPlot+2))
   iCacheFlag=0
   iCache=0
   continue
  else
   iPlot=$((iPlot+2))
   continue
  fi
 fi
 # y dim is 2
 sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot},$((iPlot+1)),$((iPlot+12)),$((iPlot+13))&"
 iCacheFlag=1
 iCache=$((iCache+1))
 if [ $iCache -eq 5 ]; then
  SendAJAXFarmRequest "${sDataWater}"
  sleep 1
  sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
  iPlot=$((iPlot+2))
  iCacheFlag=0
  iCache=0
  continue
 else
  iPlot=$((iPlot+2))
  continue
 fi
 done
}

function DoForestry {
 # read stuff from queue file
 # code iss a bit cheesy due to laziness ;)
 local sFile=$1
 local sFunction=$(head -1 ${sFile}/${sFile}/${sFile})
 if check_QueueSleep ${sFile}/${sFile}/${sFile}; then
  echo "Set to sleep"
  return
 fi
 harvest_${sFunction}
 start_${sFunction} ${sFile}/${sFile}/${sFile}
 update_queue ${sFile} ${sFile} ${sFile}
}

function harvest_Tree {
 # harvest all trees
 SendAJAXForestryRequest "action=cropall"
}

function start_Tree {
 local sFile=$1
 local iPID=$(sed '2q;d' ${sFile})
 # plant trees
 SendAJAXForestryRequest "action=autoplant&productid=${iPID}"
 water_Tree
}

function water_Tree {
 # water trees
 SendAJAXForestryRequest "action=water"
}

function harvest_ForestryBuilding {
 local iPosition=$2
 local iSlot=$3
 SendAJAXForestryRequest "action=cropproduction&position=${iPosition}&slot=${iSlot}"
}

function start_ForestryBuilding {
 local sFarm=$1
 local iPosition=$2
 local iSlot=$3
 # this building needs one parameter
 local iPID=$(sed '2q;d' ${sFarm}/${iPosition}/${iSlot})
 SendAJAXForestryRequest "action=startproduction&position=${iPosition}&productid=${iPID}&slot=${iSlot}"
}

function start_ForestryBuildingNP {
 start_ForestryBuilding $1 $2 $3
}

function harvest_FoodWorldBuilding {
 local iPosition=$2
 local iSlot=$3
 SendAJAXFoodworldRequest "action=crop&id=0&table=${iPosition}&chair=${iSlot}"
}

function start_FoodWorldBuilding {
 local sFarm=$1
 local iPosition=$2
 local iSlot=$3
 # this building needs one parameter
 iPID=$(sed '2q;d' ${sFarm}/${iPosition}/${iSlot})
 SendAJAXFoodworldRequest "action=production&id=${iPID}&table=${iPosition}&chair=${iSlot}"
}

function start_FoodWorldBuildingNP {
 start_FoodWorldBuilding $1 $2 $3
}

function DoFarmersMarket {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 if check_QueueSleep ${sFarm}/${sPosition}/${iSlot}; then
  echo "Set to sleep"
  return
 fi
 local sFunction=$(head -1 ${sFarm}/${sPosition}/${iSlot})
 harvest_${sFunction} ${sFarm} ${sPosition} ${iSlot}
 start_${sFunction} ${sFarm} ${sPosition} ${iSlot}
 update_queue ${sFarm} ${sPosition} ${iSlot}  
}

function harvest_FlowerArea {
 # harvest flowers
 if [ "$NONPREMIUM" = "NP" ]; then
  harvest_FlowerAreaNP
  return
 fi
 SendAJAXFarmRequest "mode=flowerarea_harvest_all&farm=1&position=1"
}

function harvest_FlowerAreaNP {
 # this function only supports the same flower in all spots
 local iPID=$($JQBIN '.updateblock.farmersmarket.flower_area["1"].pid | tonumber' $FARMDATAFILE)
 local iCount
 local sData="mode=flowerarea_harvest&farm=1&position=1&set="
 for iCount in {1..36}; do
  sData=${sData}${iCount}:${iPID},
 done
 SendAJAXFarmRequest $sData
}

function start_FlowerArea {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 if [ "$iPID" = "998" ]; then
  # bonus plant?
  iPID=$($JQBIN '.updateblock.farmersmarket.flower_bonus.pid' $FARMDATAFILE)
 fi
 if [ "$NONPREMIUM" = "NP" ]; then
  start_FlowerAreaNP $iPID
  return
 fi
 SendAJAXFarmRequest "mode=flowerarea_autoplant&farm=1&position=1&set=0&pid=${iPID}"
 # water the flowers
 SendAJAXFarmRequest "mode=flowerarea_water_all&farm=1&position=1"
}

function start_FlowerAreaNP {
 local iPID=$1
 local iCount
 local sData="mode=flowerarea_plant&farm=1&position=1&set="
 local sDataWater="mode=flowerarea_water&farm=1&position=1&set="
 for iCount in {1..36}; do
  sData=${sData}${iCount}:${iPID},
  sDataWater=${sDataWater}${iCount}:${iPID},
 done
 SendAJAXFarmRequest $sData
 SendAJAXFarmRequest $sDataWater
}

function harvest_Nursery {
 local iSlot=$3
 SendAJAXFarmRequest "mode=nursery_harvest&farm=1&position=1&id=1&slot=${iSlot}"
}

function start_Nursery {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 SendAJAXFarmRequest "mode=nursery_startproduction&farm=1&position=1&id=${iPID}&pid=${iPID}&slot=${iSlot}"
}

function DoFarmersMarketFlowerPots {
 local iSlot=$1
 SendAJAXFarmRequest "mode=flowerslot_water&farm=1&position=1&set=${iSlot}:1,"
}

function harvest_MonsterFruitHelper {
 :
}

function start_MonsterFruitHelper {
 sFarm=$1
 sPosition=$2
 iSlot=$3
 iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 SendAJAXFarmRequest "mode=megafruit_buyobject&farm=1&position=1&id=${iPID}&oid=${iPID}"
}

function DoFoodContestCashDesk {
 SendAJAXFarmRequest "mode=foodcontest_merchpin&farm=1&position=1"
}

function DoFoodContestAudience {
 local iBlock=$1
 local sPinType=$2
 SendAJAXFarmRequest "mode=foodcontest_pincache&farm=1&position=1&id=1_${sPinType},&value=${iBlock}_${sPinType},"
}

function DoFoodContestFeeding {
 SendAJAXFarmRequest "mode=foodcontest_feed&farm=1&position=1"
}

function harvest_Pets {
 local iSlot=$3
 SendAJAXFarmRequest "mode=pets_harvest_production&slot=${iSlot}&position=1"
}

function start_Pets {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 SendAJAXFarmRequest "mode=pets_start_production&slot=${iSlot}&pid=${iPID}"
}

function harvest_Vet {
 local iSlot=$3
 SendAJAXFarmRequest "mode=vet_harvestproduction&farm=1&position=1&id=${iSlot}&slot=${iSlot}&pos=1"
}

function start_Vet {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 SendAJAXFarmRequest "mode=vet_startproduction&farm=1&position=1&id=${iSlot}&slot=${iSlot}&pid=${iPID}&pos=1"
}

function DoFarmersMarketAnimalTreatment {
 local iSlot=$1
 local iAnimalID
 local aQueue
 local sTreatmentSet=
 local iDiseaseID
 local iFastestCure
 SendAJAXFarmRequest "mode=vet_endtreatment&farm=1&position=1&id=${iSlot}&slot=${iSlot}"
 if ! grep -q "restartvetjob = 0" $CFGFILE && grep -q "restartvetjob = " $CFGFILE; then
  check_VetJobDone
 fi
 if get_AnimalQueueLength ; then
  # queue is empty, return
  return
 fi
 # get animal ID from queue holding status 0
 iAnimalID=$($JQBIN '.updateblock.farmersmarket.vet.animals.queue | tostream | select(length == 2) as [$key,$value] | if $key[-1] == "status" and $value == "0" then ($key[-2] | tonumber) else empty end' $FARMDATAFILE | head -1)
 # place it in slot
 SendAJAXFarmRequest "mode=vet_setslot&farm=1&position=1&id=${iSlot}&slot=${iSlot}&aid=${iAnimalID}"
 # isolate deseases for animal ID
 aQueue=$($JQBIN '.updateblock.farmersmarket.vet.animals.queue["'${iAnimalID}'"].diseases | .[] | .id?' $FARMDATAFILE)
 for iDiseaseID in $aQueue; do
  # find fastest cure for disease
  iFastestCure=$(get_AnimalsFastestCureForDisease $iDiseaseID)
  sTreatmentSet=${sTreatmentSet}${iDiseaseID}_${iFastestCure},
 done
 # start treatment
 SendAJAXFarmRequest "mode=vet_starttreatment&farm=1&position=1&id=${iSlot}&slot=${iSlot}&set=${sTreatmentSet}"
 GetFarmData $FARMDATAFILE
}

function check_VetJobDone {
 local iNumAnimalsHealed=$($JQBIN '.updateblock.farmersmarket.vet.info.role_count | tonumber' $FARMDATAFILE)
 local iNumAnimals2Heal=$($JQBIN '.updateblock.farmersmarket.vet.info.role_count_max | tonumber' $FARMDATAFILE)
 # we're not using updated farm data at this point, but a treatment has just been finished
 # that's why we're calculating with one less treatment
 iNumAnimals2Heal=$((iNumAnimals2Heal-1))
 if [ $iNumAnimals2Heal -eq $iNumAnimalsHealed ]; then
  CFGLINE=$(grep restartvetjob $CFGFILE)
  TOKENS=( $CFGLINE )
  local iVetJob=${TOKENS[2]}
  echo "Restarting vets' treatment with difficulty ${iVetJob}..."
  sleep 2
  SendAJAXFarmRequest "mode=vet_setrole&farm=1&position=1&id=${iVetJob}&role=${iVetJob}"
 fi
}

function DoFarmersMarketPetCare {
 local sSlot=$1
 # get config data
 if grep -q "care${sSlot} = 0" $CFGFILE; then
  echo "Pet's $sSlot care is set to sleep"
 else
  local sCFGline=$(grep care${sSlot} $CFGFILE)
  local sTokens=( $sCFGline )
  local sCare=${sTokens[2]}
  SendAJAXFarmRequest "mode=pets_care&set=${sCare},${sCare},${sCare}"
 fi
}

function harvest_CowRacing {
 local iSlot=$3
 SendAJAXFarmRequest "slot=${iSlot}&position=1&mode=cowracing_harvestproduction"
}

function start_CowRacing {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 SendAJAXFarmRequest "slot=${iSlot}&pid=${iPID}&mode=cowracing_startproduction"
}

function check_RaceCowFeeding {
 local iSlot=$1
 CFGLINE=$(grep racecowslot${iSlot} $CFGFILE)
 TOKENS=( $CFGLINE )
 local iPID=${TOKENS[2]}
 local sSlotType=$($JQBIN -r '.updateblock.farmersmarket.cowracing.data.cowslots["'${iSlot}'"] | type' $FARMDATAFILE 2>/dev/null)
 if [ "$sSlotType" = "number" ]; then
  SLOTREMAIN=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'${iSlot}'"].feed_remain?' $FARMDATAFILE 2>/dev/null)
  if [ "$SLOTREMAIN" = "null" ]; then
   echo "Feeding race cow in slot ${iSlot}..."
   SendAJAXFarmRequest "pid=${iPID}&slot=${iSlot}&mode=cowracing_feedCow"
  fi
 else
  echo "There seems to be no cow in slot ${iSlot}!"
 fi
}

function check_CowRace {
 local iSlot
 local sEnvironment
 local sBodyPart
 local iEquipmentID
 local aSlots=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cowslots | keys | .[] | tonumber' $FARMDATAFILE 2>/dev/null)
 for iSlot in $aSlots; do
  if check_TimeRemaining '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].race_remain'; then
   # remove all equipment from cow
   SendAJAXFarmRequest "type=head&slot=${iSlot}&mode=cowracing_unequipitem" && sleep 1
   SendAJAXFarmRequest "type=body&slot=${iSlot}&mode=cowracing_unequipitem" && sleep 1
   SendAJAXFarmRequest "type=foot&slot=${iSlot}&mode=cowracing_unequipitem" && sleep 1
   GetFarmData $FARMDATAFILE
   sEnvironment=$($JQBIN -r '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].lanestatus' $FARMDATAFILE 2>/dev/null)
   for sBodyPart in head body foot; do
    # find best equipment for the cow
    iEquipmentID=$(get_CowEquipmentID $sBodyPart $sEnvironment)
    if [ "$iEquipmentID" = "-1" ]; then
     continue
    fi
    # equip it
    SendAJAXFarmRequest "id=${iEquipmentID}&slot=${iSlot}&mode=cowracing_equipitem"
   done
  # start the race
  sleep 1
  echo "Starting cow race in slot ${iSlot}..."
  SendAJAXFarmRequest "type=pve&slot=${iSlot}&mode=cowracing_startrace"
  fi
 done
}

function get_CowEquipmentID {
 local sBodyPart=$1
 local sEnvironment=$2
 local iEquipmentID=-1
 case "$sBodyPart:$sEnvironment" in
  head:normal)
     iEquipmentID=$(check_CowEquipmentAvailability "1 4")
     ;;
  head:rain)
     iEquipmentID=$(check_CowEquipmentAvailability "2 1")
     ;;
  head:cold)
     iEquipmentID=$(check_CowEquipmentAvailability "4 2")
     ;;
  head:heat)
     iEquipmentID=$(check_CowEquipmentAvailability "5 3")
     ;;
  head:mud)
     iEquipmentID=$(check_CowEquipmentAvailability "3 5")
     ;;
  body:normal)
     iEquipmentID=$(check_CowEquipmentAvailability "11 13")
     ;;
  body:rain)
     iEquipmentID=$(check_CowEquipmentAvailability "14 15")
     ;;
  body:cold)
     iEquipmentID=$(check_CowEquipmentAvailability "13 11")
     ;;
  body:heat)
     iEquipmentID=$(check_CowEquipmentAvailability "12 14")
     ;;
  body:mud)
     iEquipmentID=$(check_CowEquipmentAvailability "15 14")
     ;;
  foot:normal)
     iEquipmentID=$(check_CowEquipmentAvailability "6 8")
     ;;
  foot:rain)
     iEquipmentID=$(check_CowEquipmentAvailability "9 6")
     ;;
  foot:cold)
     iEquipmentID=$(check_CowEquipmentAvailability "10 7")
     ;;
  foot:heat)
     iEquipmentID=$(check_CowEquipmentAvailability "8 7")
     ;;
  foot:mud)
     iEquipmentID=$(check_CowEquipmentAvailability "7 9")
     ;;
 esac
 echo "$iEquipmentID"
}

function check_CowEquipmentAvailability {
 local iSearchPattern="$1"
 local iItem
 local iKey
 # desired globbing
 for iItem in $iSearchPattern; do
  iKey=$($JQBIN '.updateblock.farmersmarket.cowracing.data.items | tostream | select(length == 2)  as [$key,$value] | if $key[-1] == "type" and $value == "'${iItem}'" then ($key[-2] | tonumber) else empty end' $FARMDATAFILE | head -1)
  if [ -n "$iKey" ]; then
   echo $iKey
   return
  fi
 done
 echo "-1"
}

function harvest_MegaField {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iHarvestDevice=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 local iPlot=1
 local iVehicleBought=0
 # check for 2x2 harvest device
 case "$iHarvestDevice" in
  5|7|9|10) harvest_MegaField2x2 ${iFarm} ${iPosition} ${iSlot} ${iHarvestDevice}
  update_queue ${iFarm} ${iPosition} ${iSlot}
  iHarvestDevice=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
  case "$iHarvestDevice" in
   5|7|9|10) echo "You need a 1x1 device after the 2x2 one - cannot continue"
   return
   ;;
  esac
  ;;
 esac
 iHarvestDelay=$(get_MegaFieldHarvesterDelay $iHarvestDevice)
 while (true); do
  if [ $iPlot -gt 99 ]; then
   if ! check_RipePlotOnMegaField ; then
    return
   fi
   # there's more to harvest...
   iPlot=1
  fi
  iVehicleBought=$(check_MegaFieldEmptyHarvestDevice $iHarvestDevice $iVehicleBought)
  if check_TimeRemaining '.updateblock.megafield.area["'$iPlot'"].remain?'; then
   echo -n "Harvesting Mega Field plot ${iPlot}..."
   SendAJAXFarmRequestOverwrite "mode=megafield_tour&farm=1&position=1&set=${iPlot},|&vid=${iHarvestDevice}"
   echo "delaying ${iHarvestDelay} seconds"
   sleep ${iHarvestDelay}s
   if grep -q "megafieldinstantplant = 1" $CFGFILE; then
    start_MegaField${NONPREMIUM}
   fi
   iPlot=$((iPlot+1))
   continue
  fi
  iPlot=$((iPlot+1))
 done
}

function start_MegaField {
 local iProductSlot
 local iSafetyCount=$1
 local iPID
 local amountToGo
 local iFreePlots
 if [ $iSafetyCount -gt 4 ] 2>/dev/null; then
  echo "Exiting start_MegaField after four cycles! (Not enough crop in stock?)"
  return
 fi
 for iProductSlot in 0 1 2; do
  if ! check_MegaFieldProductIsHarvestable $iProductSlot ; then
   continue
  fi
  # here we've got a product that is harvestable
  iPID=$($JQBIN '.updateblock.megafield.job.products['$iProductSlot'].pid' $FARMDATAFILE)
  amountToGo=$(get_MegaFieldAmountToGoInSlot $iProductSlot)
  if [ "$amountToGo" = "0" ]; then
   continue
   # no need to plant more
  fi
  iFreePlots=$(get_MegaFieldFreePlotsNum)
  if [ $iFreePlots -eq 0 ]; then
   # no free plots, no need to plant
   return
  fi
  # plant
  if [ $iFreePlots -lt $amountToGo ]; then
   # plant on all free plots
   MegaFieldPlant${NONPREMIUM} $iPID $iFreePlots
   return
  fi
  MegaFieldPlant${NONPREMIUM} $iPID $amountToGo
  # call function again since there are still free plots
  if [ "$iSafetyCount" = "" ]; then
   start_MegaField 2
  else
   iSafetyCount=$((iSafetyCount+1))
   start_MegaField $iSafetyCount
  fi
 done
}

function start_MegaFieldNP {
 start_MegaField
}

function harvest_FuelStation {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iRealSlot=$(get_RealSlotName $iFarm $iPosition $iSlot)
 SendAJAXFarmRequest "mode=fuelstation_harvest&farm=${iFarm}&position=${iPosition}&id=${iRealSlot}&slot=${iRealSlot}"
}

function start_FuelStation {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iRealSlot=$(get_RealSlotName $iFarm $iPosition $iSlot)
 local iPID=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 iSlot=$iRealSlot
 # get points per good
 local iPointsPerGood=$($JQBIN '.updateblock.farms.farms["'${iFarm}'"]["'${iPosition}'"].data.data.slots["'${iSlot}'"].products["'${iPID}'"].points' $FARMDATAFILE)
 # calculate points and amount needed to start fuel production
 # it's defined as constants in .updateblock.farms.farms[FARM][POSITION].data.constants.slot_level[LEVEL].limit
 # and devided by the points we get per good
 local iSlotLevel=$($JQBIN '.updateblock.farms.farms["'${iFarm}'"]["'${iPosition}'"].data.data.slots["'${iSlot}'"].level' $FARMDATAFILE)
 local iPointsNeededToStart=$((iSlotLevel*1000000))
 # amount needs to be calculated using "round to nearest"
 # changed to "round up" 08.11.2015 (old foobar/2, new foobar-1)
 local iAmount=$(((iPointsNeededToStart+(iPointsPerGood-1))/iPointsPerGood))
 # force 3 second delay, cuz upjers server can't handle too quick a re-start
 sleep 3
 SendAJAXFarmRequest "mode=fuelstation_entry&farm=${iFarm}&position=${iPosition}&id=${iSlot}&amount=${iAmount}&slot=${iSlot}&pid=${iPID}"
}

function start_FuelStationNP {
 start_FuelStation $1 $2 $3
}

function harvest_WindMill {
 local iSlot=$3
 SendAJAXCityRequest "city=2&mode=windmillcrop&slot=${iSlot}"
}

function start_WindMillNP {
 start_WindMill $1 $2 $3
}

function start_WindMill {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 SendAJAXCityRequest "city=2&mode=windmillstartproduction&formula=${iPID}&slot=${iSlot}"
}

function harvest_PonyFarm {
 local iFarm=$1
 local iPosition=$2
 local iSlot
 local sBlocked
 local iFarmie
 GetInnerInfoData $TMPFILE $iFarm $iPosition innerinfos
 for iSlot in 1 2 3; do
  sBlocked=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].block?' $TMPFILE)
  if [ "$sBlocked" = "null" ] || [ "$sBlocked" = "0" ]; then
   iFarmie=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].data.farmi?' $TMPFILE)
   if [ "$iFarmie" != "null" ]; then
    if $JQBIN '.datablock[1].farmis["'$iFarmie'"].data.remain?' $TMPFILE | grep -q '-'; then
     SendAJAXFarmRequest "mode=pony_crop&farm=${iFarm}&position=${iPosition}&id=${iSlot}"
    fi
   fi
  fi
 done
}

function start_PonyFarmNP {
 start_PonyFarm $1 $2
}

function start_PonyFarm {
 local iFarm=$1
 local iPosition=$2
 local iMaxFood=8
 local iDuration
 local iSlot
 local iFarmie
 local iPony
 local iFood
 local iEnergyBarCount
 for iSlot in 1 2 3; do
  GetInnerInfoData $TMPFILE $iFarm $iPosition innerinfos
  sBlocked=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].block?' $TMPFILE)
  if [ "$sBlocked" = "null" ]; then
   iFarmie=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].data.farmi?' $TMPFILE)
   if [ "$iFarmie" = "null" ]; then
    # slot is unblocked and idle...
    iPony=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].animalid | tonumber' $TMPFILE)
    # refill food dispenser
    iFood=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].data.feed' $TMPFILE)
    iFood=$((iMaxFood-iFood))
    SendAJAXFarmRequest "mode=pony_feed&farm=${iFarm}&position=${iPosition}&id=${iSlot}&pos=${iSlot}&amount=${iFood}"
    # find a farmie
    if [ $iSlot -ge 2 ]; then
     update_queue ${iFarm} ${iPosition} 0
    fi
    iDuration=$(sed '2q;d' ${iFarm}/${iPosition}/0)
    iFarmie=$(get_Farmie4Pony $iDuration)
    if [ "$iFarmie" = "-1" ]; then
     # something went wrong. bail out.
     return
    fi
    SendAJAXFarmRequest "mode=pony_setfarmi&farm=${iFarm}&position=${iPosition}&farmi=${iFarmie}&pony=${iPony}"
    # check for pony energy bar...
    if grep -q "useponyenergybar = 1" $CFGFILE; then
     iEnergyBarCount=$((iDuration/2))
     sleep 2
     SendAJAXFarmRequest "mode=pony_speedup&farm=${iFarm}&position=${iPosition}&id=${iSlot}&pos=${iSlot}&amount=${iEnergyBarCount}"
    fi
   fi
  fi
 done
}

function get_Farmie4Pony {
 local iDuration=$1
 local iFarmiesCount
 local iFarmie
 local iCount
 local iStatus
 local iType
 iFarmiesCount=$($JQBIN '.datablock[1].farmis | length' $TMPFILE)
 for iCount in $(seq 0 $((iFarmiesCount-1))); do
  iFarmie=$($JQBIN '.datablock[1].farmis | keys['${iCount}'] | tonumber' $TMPFILE)
  iStatus=$($JQBIN '.datablock[1].farmis["'${iFarmie}'"].status | tonumber' $TMPFILE)
  if [ $iStatus -eq 0 ]; then
   # farmie is not in use
   iType=$($JQBIN '.datablock[1].farmis["'${iFarmie}'"].type | tonumber' $TMPFILE)
   if [ $iType -eq $iDuration ]; then
    # this is "the one"
    echo $iFarmie
    return
   fi
  fi
 done
 # ideally, you don't get here
 echo "-1"
 return
}

function check_VehiclePosition {
 local iFarm=$1
 local iRoute=$2
 local iVehicle
 local iCurrentVehiclePos
 echo -n "Transport vehicle for route $iRoute is "
 CFGLINE=$(grep vehiclemgmt${iFarm} $CFGFILE)
 TOKENS=( $CFGLINE )
 iVehicle=${TOKENS[2]}
 if ! $JQBIN -e '.updateblock.map.vehicles["'${iRoute}'"]["'${iVehicle}'"].remain' $FARMDATAFILE >/dev/null; then
  iCurrentVehiclePos=$($JQBIN '.updateblock.map.vehicles["'${iRoute}'"]["'$iVehicle'"].current | tonumber' $FARMDATAFILE)
  if [ "$iCurrentVehiclePos" = "1" ]; then
   echo "on farm 1"
   check_SendGoodsOffMainFarm $iVehicle $iFarm $iRoute
  else
   echo "on farm $iCurrentVehiclePos"
   # check if sending a fully loaded vehicle is possible
   check_SendGoodsToMainFarm $iVehicle $iFarm $iRoute
  fi
 else
  echo "en route"
 fi
}

function check_SendGoodsToMainFarm {
 local iVehicle=$1
 local iFarm=$2
 local iRoute=$3
 local iProduct
 local iProductCount
 local iSafetyCount
 local iCount
 local sCart=
 local iTransportCount=0
 local iVehicleSlotsUsed=0
 local -a aItemsFarm5=( 351 352 353 354 355 356 357 358 359 360 361 )
 local -a aItemsFarm6=( 700 701 702 703 704 705 706 707 708 709 )
 local iVehicleCapacity=$($JQBIN '.updateblock["map"]["config"]["vehicles"]["'${iVehicle}'"]["capacity"]' $FARMDATAFILE)
 local iVehicleSlotCount=$($JQBIN '.updateblock["map"]["config"]["vehicles"]["'${iVehicle}'"]["products"]' $FARMDATAFILE)
 local iFieldsOnFarmNum=$(get_FieldsOnFarmNum $iFarm)
 # this will fail if more than one rack is in use on farm 5 or 6
 local iItemCount=$($JQBIN '.updateblock.stock.stock["'${iFarm}'"]["1"] | keys | length' $FARMDATAFILE)
 # You know, somehow, "I told you so" just doesn't quite say it. ;)
 for iCount in $(seq 1 $iItemCount); do
  iProduct=$($JQBIN '.updateblock.stock.stock["'${iFarm}'"]["1"]["'${iCount}'"]["pid"] | tonumber' $FARMDATAFILE)
  if ! check_ValueInArray aItemsFarm${iFarm} $iProduct; then
   # only transport items that can be grown on farm 5 / 6
   continue
  fi
  iProductCount=$($JQBIN '.updateblock.stock.stock["'${iFarm}'"]["1"]["'${iCount}'"]["amount"] | tonumber' $FARMDATAFILE)
  iSafetyCount=$(get_ProductCountFittingOnField $iProduct)
  # do we have multiple fields on the current farm?
  iSafetyCount=$((iSafetyCount*iFieldsOnFarmNum))
  iProductCount=$((iProductCount-iSafetyCount))
  if [ $iProductCount -le 0 ]; then
   continue
  fi
  iTransportCount=$((iTransportCount+iProductCount))
  if [ $iTransportCount -ge $iVehicleCapacity ]; then
   local iCropValue=$((iTransportCount-iVehicleCapacity))
   iProductCount=$((iProductCount-iCropValue))
   iVehicleSlotsUsed=$((iVehicleSlotsUsed+1))
   sCart=${sCart}${iVehicleSlotsUsed},${iProduct},${iProductCount}_
   echo "Sending $((iTransportCount-iCropValue)) items to main farm..."
   SendAJAXFarmRequest "mode=map_sendvehicle&farm=${iFarm}&position=1&route=${iRoute}&vehicle=${iVehicle}&cart=${sCart}"
   return
  fi
  iVehicleSlotsUsed=$((iVehicleSlotsUsed+1))
  sCart=${sCart}${iVehicleSlotsUsed},${iProduct},${iProductCount}_
  if [ $iVehicleSlotsUsed -eq $iVehicleSlotCount ]; then
   echo "Sending partially loaded vehicle to main farm (no slots left)..."
   SendAJAXFarmRequest "mode=map_sendvehicle&farm=${iFarm}&position=1&route=${iRoute}&vehicle=${iVehicle}&cart=${sCart}"
   return
  fi
 done
 if [ $iTransportCount -lt 0 ]; then
  iTransportCount=0
 fi
 echo "$iTransportCount/$iVehicleCapacity items available for transport on route ${iRoute}, no transport started"
}

function get_ProductCountFittingOnField {
 local iProduct=$1
 local iProductDim_x=$(echo $aDIM_X | $JQBIN '."'${iProduct}'" | tonumber')
 local iProductDim_y=$(echo $aDIM_Y | $JQBIN '."'${iProduct}'" | tonumber')
 local iProductDim=$((iProductDim_x*iProductDim_y))
 local iProductCountFittingOnField=$((120/iProductDim))
 echo $iProductCountFittingOnField
}

function get_FieldsOnFarmNum {
 local iFarm=$1
 local iFieldsOnFarm=0
 local iBuildingID
 local bStatus
 for iCount in {1..6}; do
  iBuildingID=$($JQBIN '.updateblock.farms.farms["'${iFarm}'"]["'${iCount}'"].buildingid | tonumber' $FARMDATAFILE)
  bStatus=$($JQBIN '.updateblock.farms.farms["'${iFarm}'"]["'${iCount}'"].status | tonumber' $FARMDATAFILE)
  if [ $iBuildingID -eq 1 ] && [ $bStatus -eq 1 ]; then
   # building is a field and is active
   iFieldsOnFarm=$((iFieldsOnFarm+1))
  fi
 done
 echo $iFieldsOnFarm
}

function check_ValueInArray {
 local -n aProducts=$1
 local iProduct=$2
 local iValue
 for iValue in "${aProducts[@]}"; do
  if [ $iValue -eq $iProduct ]; then
   return 0
  fi
 done
 return 1
}

function check_SendGoodsOffMainFarm {
 local iVehicle=$1
 # this is the destination farm
 local iFarm=$2
 local iRoute=$3
 local iProduct
 local iProductCount
 local sCart=
 local iTransportCount=0
 local iVehicleSlotsUsed=0
 local iVehicleCapacity=$($JQBIN '.updateblock["map"]["config"]["vehicles"]["'${iVehicle}'"]["capacity"]' $FARMDATAFILE)
 local iVehicleSlotCount=$($JQBIN '.updateblock["map"]["config"]["vehicles"]["'${iVehicle}'"]["products"]' $FARMDATAFILE)
 local iPosition=trans2${iFarm}
 # ugly static coding... :)
 while (true); do
  if check_QueueSleep city2/${iPosition}/0; then
   echo "Sending $iTransportCount items to farm ${iFarm}..."
   SendAJAXFarmRequest "mode=map_sendvehicle&farm=1&position=1&route=${iRoute}&vehicle=${iVehicle}&cart=${sCart}"
   return
  fi
  local aParams=$(sed '2q;d' city2/${iPosition}/0)
  IFS=,
  set -- $aParams
  unset IFS
  iProduct=$1
  iProductCount=$2
  iTransportCount=$((iTransportCount+iProductCount))
  if [ $iTransportCount -gt $iVehicleCapacity ]; then
   echo "Transport to farm ${iFarm} stopped due to vehicle overload"
   return
  fi
  iVehicleSlotsUsed=$((iVehicleSlotsUsed+1))
  sCart=${sCart}${iVehicleSlotsUsed},${iProduct},${iProductCount}_
  if [ $iTransportCount -eq $iVehicleCapacity ]; then
   echo "Sending $iTransportCount items to farm ${iFarm}..."
   SendAJAXFarmRequest "mode=map_sendvehicle&farm=1&position=1&route=${iRoute}&vehicle=${iVehicle}&cart=${sCart}"
   update_queue city2 ${iPosition} 0
   return
  fi
  if [ $iVehicleSlotsUsed -eq $iVehicleSlotCount ]; then
   echo "Sending partially loaded vehicle to farm ${iFarm} (no slots left)..."
   SendAJAXFarmRequest "mode=map_sendvehicle&farm=1&position=1&route=${iRoute}&vehicle=${iVehicle}&cart=${sCart}"
   update_queue city2 ${iPosition} 0
   return
  fi
  update_queue city2 ${iPosition} 0
 done
}

function check_PowerUps {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 if check_QueueSleep ${iFarm}/${iPosition}/${iSlot}; then
  return
 fi
 local iActivePowerUp
 local iCount
 local iPowerUp=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 local iActivePowerUps=$($JQBIN '.updateblock.farms.powerups.active | keys | length' $FARMDATAFILE)
 if [ $iActivePowerUps -eq 0 ]; then
  echo "Activating power-up #${iPowerUp}..."
  SendAJAXFarmRequest "mode=activatepowerup&farm=1&position=1&id=${iPowerUp}&formula=${iPowerUp}"
  update_queue ${iFarm} ${iPosition} ${iSlot}
  return
 else
  # there are active powerups
  for iCount in $(seq 0 $((iActivePowerUps-1))); do
   iActivePowerUp=$($JQBIN '.updateblock.farms.powerups.active | keys['$iCount'] | tonumber' $FARMDATAFILE)
   if [ $iActivePowerUp -eq $iPowerUp ]; then
    echo "Requested power-up #${iPowerUp} is already in use"
    return
   fi
  done
  echo "Activating power-up #${iPowerUp}..."
  SendAJAXFarmRequest "mode=activatepowerup&farm=1&position=1&id=${iPowerUp}&formula=${iPowerUp}"
  update_queue ${iFarm} ${iPosition} ${iSlot}
 fi
}

 function check_Tools {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 if check_QueueSleep ${iFarm}/${iPosition}/${iSlot}; then
  return
 fi
 local iActiveTool
 local iActiveGuildJob=$($JQBIN '.updateblock.job.guild_job_data | length' $FARMDATAFILE)
 local iTool=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 if [ $iActiveGuildJob -gt 0 ]; then
  # job is running and player is taking part
  iActiveTool=$($JQBIN '.updateblock.job.tool.remain' $FARMDATAFILE)
  if [ $iActiveTool -gt 0 ]; then
   echo "Requested tool #${iTool} is already in use"
   return
  else
   echo "Activating tool #${iTool}..."
   SendAJAXGuildRequest "mode=job_set_tool&pid=${iTool}"
   update_queue ${iFarm} ${iPosition} ${iSlot}
   return
  fi
 fi
}

function update_queue {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # re-order the queue if any
 local sInfile=${iFarm}/${iPosition}/${iSlot}
 local sTmpfile=/tmp/mff-q-$$
 local iLines=$(cat $sInfile | wc -l)
 if [ $iLines -gt 2 ]; then
  echo "Updating queue..."
  head -1 $sInfile >$sTmpfile
  sed -n '3,'$iLines'p' $sInfile >>$sTmpfile
  head -2 $sInfile | tail -1 >>$sTmpfile
  mv $sTmpfile $sInfile
  unset sInfile sTmpfile # unset a local variable??
 fi
}

function check_QueueSleep {
 local sFile=$1
 local sQueueItem=$(sed '2q;d' $sFile)
 if [ "$sQueueItem" = "sleep" ] || [ -z "$sQueueItem" ]; then
  return 0
 fi
 return 1
}

function check_RipePlotOnField {
 # returns true if at least one plot is ripe
 local iFarm=$1
 local iPosition=$2
 GetInnerInfoData $TMPFILE $iFarm $iPosition gardeninit
 local bHasRipePlots=$($JQBIN '.datablock[1] | .[] | select(.phase? == 4)' $TMPFILE)
 if [ -z "$bHasRipePlots" ]; then
  return 1
 fi
 return 0
}

function check_RunningMegaFieldJob {
 local iJobEnd=$($JQBIN '.updateblock.megafield.job_endtime | tonumber' $FARMDATAFILE)
 local iJobStart=$($JQBIN '.updateblock.megafield.job_start | tonumber' $FARMDATAFILE)
 if [ $iJobStart -gt 0 ] && [ $iJobEnd -eq 0 ]; then
  return 0
 fi
 return 1
}

function check_RipePlotOnMegaField {
 # returns true if a plot shows a negative remainder
 local bHasNegatives=$($JQBIN '.updateblock.megafield.area | .[] | select(.remain < 0)' $FARMDATAFILE)
 if [ -z "$bHasNegatives" ]; then
  return 1
 fi
 return 0
}

function get_UnlockedMegaFieldPlotNum {
 local iUnlockedPlots=$($JQBIN '.updateblock.megafield.area_free | length' $FARMDATAFILE)
 # we always have a positive number here
 echo $iUnlockedPlots
}

function get_BusyMegaFieldPlotName {
 local iPlotIndex=$1
 local sPlotName=$($JQBIN '.updateblock.megafield.area | keys | .['$iPlotIndex']' $FARMDATAFILE)
 echo $sPlotName
}

function get_MegaFieldHarvesterDelay {
 local iHarvestDevice=$1
 # taken from here: .updateblock.megafield.vehicle_slots["nn"].duration
 case "$iHarvestDevice" in
   1) echo 55
      ;;
   2) echo 50
      ;;
   3) echo 45
      ;;
   4) echo 40
      ;;
   5) echo 80
      ;;
   6) echo 30
      ;;
   7) echo 60
      ;;
   8) echo 20
      ;;
   9) echo 60
      ;;
  10) echo 20
      ;;
   *) echo "Unknown harvest device in get_MegaFieldHarvesterDelay()" >&2
      echo 0
      ;;
 esac
}

function check_MegaFieldEmptyHarvestDevice {
 local iHarvestDevice=$1
 local iVehicleBought=$2
 local iDurability=$($JQBIN '.updateblock.megafield.vehicles["'${iHarvestDevice}'"].durability' $FARMDATAFILE 2>/dev/null)
 if [ "$iDurability" = "null" ] || [ -z "$iDurability" ]; then
  if [ $iVehicleBought -eq 0 ]; then
   # buy a brand new one if empty
   echo "Buying new vehicle #${iHarvestDevice}..." >&2
   SendAJAXFarmRequest "mode=megafield_vehicle_buy&farm=1&position=1&id=${iHarvestDevice}&vid=${iHarvestDevice}"
   echo 1
   return
  else
   # sending to STDERR...not the best way to do it
   echo "Not buying new vehicle since it's already been bought this iteration" >&2
   echo 1
   return
  fi
 else
  echo 0
 fi
}

function check_MegaFieldProductIsHarvestable {
 local iProductSlot=$1
 local iIsHarvestable=$($JQBIN '.updateblock.megafield.job.products['$iProductSlot'].harvest' $FARMDATAFILE)
 if [ "$iIsHarvestable" = "1" ]; then
  return 0
 fi
 return 1
}

function get_MegaFieldAmountToGoInSlot {
 local iBusyPlots
 local iProductSlot=$1
 local iNeededPID=$($JQBIN '.updateblock.megafield.job.products['$iProductSlot'].need' $FARMDATAFILE)
 local iHavePID=$($JQBIN '.updateblock.megafield.job.products['$iProductSlot'].have' $FARMDATAFILE)
 local iPID=$($JQBIN '.updateblock.megafield.job.products['$iProductSlot'].pid' $FARMDATAFILE)
 local iSeeminglyNeeded=$(($iNeededPID-$iHavePID))
 if [ "$iSeeminglyNeeded" = "0" ]; then
  # no more products needed in this slot
  echo 0
  return
 fi
 # look at mega field, see if theres still busy plots with needed PID
 iBusyPlots=$($JQBIN '.updateblock.megafield.area | length' $FARMDATAFILE)
 if [ $iBusyPlots -eq 0 ]; then
  # no busy plots at all... return needed products
  echo $iSeeminglyNeeded
  return
 fi
 local iPIDOnBusyPlots=0
 for iPlot in $(seq 0 $((iBusyPlots-1))); do
  sPlotName=$(get_BusyMegaFieldPlotName $iPlot)
  local iBusyPID=$($JQBIN '.updateblock.megafield.area['${sPlotName}'].pid' $FARMDATAFILE)
  if [ "$iBusyPID" = "$iPID" ]; then
   iPIDOnBusyPlots=$((iPIDOnBusyPlots+1))
  fi
 done
 echo $(($iSeeminglyNeeded-$iPIDOnBusyPlots))
 # in theory, this amount can't be less than zero
}

function get_MegaFieldFreePlotsNum {
 local iTotalPlots=$($JQBIN '.updateblock.megafield.area_free | length' $FARMDATAFILE)
 local iBusyPlots=$($JQBIN '.updateblock.megafield.area | length' $FARMDATAFILE)
 local iFreePlots=$((iTotalPlots-iBusyPlots))
 echo $iFreePlots
}

function MegaFieldPlantNP {
 local iPID=$1
 local iFreePlots=$2
 local iCount=1
 local iCount2=0
 local sPlotOccupied
 local iUnlockedPlotsCount=$(get_UnlockedMegaFieldPlotNum)
 while [ "$iCount" -le "$iFreePlots" ]; do
   while [ "$iCount2" -lt "$iUnlockedPlotsCount" ]; do
    sUnlockedPlotName=$($JQBIN '.updateblock.megafield.area_free | keys | .['$iCount2'] | tonumber' $FARMDATAFILE)
    sPlotOccupied=$($JQBIN '.updateblock.megafield.area["'$sUnlockedPlotName'"]?' $FARMDATAFILE)
    if [ -z "$sPlotOccupied" ] || [ "$sPlotOccupied" = "null" ]; then
     # plot is free, plant stuff on it
     echo "Planting item ${iPID} on Mega Field plot ${sUnlockedPlotName}..."
     SendAJAXFarmRequestOverwrite "mode=megafield_plant&farm=1&position=1&set=${sUnlockedPlotName}_${iPID}|"
     iCount2=$((iCount2+1))
     break
    fi
    iCount2=$((iCount2+1))
   done
  iCount=$((iCount+1))
 done
}

function MegaFieldPlant {
 # new premium function after changes made by upjers 09.02.2016
 local iPID=$1
 local iAmount=$2
 echo "Planting item ${iPID} on ${iAmount} Mega Field plot(s)..."
 SendAJAXFarmRequestOverwrite "mode=megafield_autoplant&farm=1&position=1&id=${iPID}&pid=${iPID}"
}

function harvest_MegaField2x2 {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iHarvestDevice=$4
 local iPlot=1
 local iVehicleBought=0
 iHarvestDelay=$(get_MegaFieldHarvesterDelay $iHarvestDevice)
 while (true); do
  if [ $iPlot -gt 87 ]; then
   return
  fi
  iVehicleBought=$(check_MegaFieldEmptyHarvestDevice $iHarvestDevice $iVehicleBought)
  if ! ((iPlot % 11)); then
   iPlot=$((iPlot+1))
   # prevent harvesting of last column
  fi
  if check_TimeRemaining '.updateblock.megafield.area["'$iPlot'"].remain?'; then
   if check_TimeRemaining '.updateblock.megafield.area["'$((iPlot+1))'"].remain?'; then
    if check_TimeRemaining '.updateblock.megafield.area["'$((iPlot+11))'"].remain?'; then
     if check_TimeRemaining '.updateblock.megafield.area["'$((iPlot+12))'"].remain?'; then
      echo -n "Harvesting Mega Field plots ${iPlot}, $((iPlot+1)), $((iPlot+11)), $((iPlot+12))..."
      SendAJAXFarmRequestOverwrite "mode=megafield_tour&farm=1&position=1&set=${iPlot},$((iPlot+1)),$((iPlot+11)),$((iPlot+12)),|&vid=${iHarvestDevice}"
      echo "delaying ${iHarvestDelay} seconds"
      sleep ${iHarvestDelay}s
      if grep -q "megafieldinstantplant = 1" $CFGFILE; then
       start_MegaField${NONPREMIUM}
      fi
      iPlot=$((iPlot+2))
      continue
     else
      iPlot=$((iPlot+1))
      continue
     fi
    else
     iPlot=$((iPlot+1))
     continue
    fi
   else
    iPlot=$((iPlot+2))
    continue
   fi
  fi
 iPlot=$((iPlot+1))
 done
}

function get_AnimalQueueLength {
 local iAnimalQueueLength=($($JQBIN '.updateblock.farmersmarket.vet.animals.queue | length' $FARMDATAFILE))
 return $iAnimalQueueLength
}

function get_AnimalsFastestCureForDisease {
 local iDiseaseID=$1
 case "$iDiseaseID" in
   1) echo 300
      # Gelber Schnupfen
      ;;
   2) echo 301
      # Lichtempfindliche Augen
      ;;
   3) echo 300
      # Humpeln
      ;;
   4) echo 303
      # Roehrhusten
      ;;
   5) echo 303
      # Fieber
      ;;
   6) echo 304
      # Trockener Husten
      ;;
   7) echo 304
      # Magengrummeln
      ;;
   8) echo 307
      # Sehschwaeche
      ;;
   9) echo 307
      # Rote Augen
      ;;
   10) echo 309
      # Gruener Schnupfen
      ;;
   11) echo 309
      # Kopfschmerz
      ;;
   12) echo 311
      # Rote Flecken
      ;;
   13) echo 311
      # Weisser Schnupfen
      ;;
   14) echo 311
      # Magenverstimmung
      ;;
   15) echo 313
      # Gelenkprobleme
      ;;
   16) echo 313
      # Appetitlosigkeit
      ;;
   17) echo 315
      # Hoerschwaeche
      ;;
   18) echo 315
      # Juckende Haut
      ;;
   19) echo 317
      # Verrenkung
      ;;
   20) echo 317
      # Haarausfall
      ;;
   21) echo 319
      # Futterallergie
      ;;
   22) echo 320
      # Harte Muskeln
      ;;
   23) echo 322
      # Keuchhusten
      ;;
   24) echo 322
      # Kopfdruck
      ;;
   25) echo 320
      # Drehwurm
      ;;
   26) echo 324
      # Wacklige Beine
      ;;
   27) echo 327
      # Furchtbares Humpeln
      ;;
   28) echo 325
      # Furchtbar Gelber Schnupfen
      ;;
   29) echo 326
      # Furchtbar Lichtempfindliche Augen
      ;;
   30) echo 328
      # Furchtbares Fieber
      ;;
   31) echo 328
      # Furchtbarer Roehrhusten
      ;;
   32) echo 329
      # Furchtbares Magengrummeln
      ;;
   33) echo 329
      # Furchtbar Trockener Husten
      ;;
   34) echo 330
      # Beule
      ;;
   35) echo 333
      # Furchtbar Rote Augen
      ;;
   36) echo 333
      # Furchtbare Sehschwaeche
      ;;
   37) echo 335
      # Furchtbar Wacklige Beine
      ;;
   38) echo 336
      # Furchtbarer Kopfschmerz
      ;;
   39) echo 336
      # Furchtbar Gruener Schnupfen
      ;;
   40) echo 338
      # Furchtbare Magenverstimmung
      ;;
   41) echo 338
      # Furchtbar Weißer Schnupfen
      ;;
   42) echo 338
      # Furchtbar Rote Flecken
      ;;
   43) echo 340
      # Furchtbare Appetitlosigkeit
      ;;
   44) echo 340
      # Furchtbare Gelenkprobleme
      ;;
   45) echo 342
      # Furchtbar Juckende Haut
      ;;
   46) echo 342
      # Furchtbare Hoerschwaeche
      ;;
   47) echo 345
      # Furchtbarer Haarausfall
      ;;
   48) echo 345
      # Furchtbare Verrenkung
      ;;
   49) echo 347
      # Furchtbare Futterallergie
      ;;
   50) echo 348
      # Furchtbar Harte Muskeln
      ;;
   51) echo 348
      # Furchtbarer Drehwurm
      ;;
   52) echo 400
      # Furchtbarer Kopfdruck
      ;;
   53) echo 400
      # Furchtbarer Keuchhusten
      ;;
   54) echo 402
      # Furchtbare Beule
      ;;
   *) echo "Unknown disease id in get_AnimalsFastestCureForDisease()" >&2
      echo 0
      ;;
 esac
}

function get_RealSlotName {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iSlotName
 iSlotName=$($JQBIN -r '.updateblock.farms.farms["'${iFarm}'"]["'${iPosition}'"].production['${iSlot}'].slot' $FARMDATAFILE)
 echo $iSlotName
}

function get_FieldPlotReadiness {
 # returns 0 if a plot is not occupied in any way
 local iPlot=$1
 local sResult=$($JQBIN '.datablock[1] | .[] | select(.teil_nr? == "'$iPlot'")' $TMPFILE 2>/dev/null)
 if [ -z "$sResult" ]; then
  return 0
 else
  return 1
 fi
}

function get_QueueCountInFS {
 local iFarm=$1
 local iPosition=$2
 local iQueueNum
 iQueueNum=$(ls -ld ${iFarm}/${iPosition}/* | wc -l)
 echo $iQueueNum
}

function get_MaxQueuesForBuildingID {
 local iBuildingID=$1
 case "$iBuildingID" in
  13|14|16|20|21) echo 3
   ;;
  *) echo 1
   ;;
 esac
}

function reduce_QueuesOnPosition {
 local iFarm=$1
 local iPosition=$2
 local iMaxQ=$3
 local iQueueNum=$(ls -ld ${iFarm}/${iPosition}/* | wc -l)
 local iQDel=$((iQueueNum-iMaxQ))
 rm $(ls -d1 ${iFarm}/${iPosition}/* | tail -${iQDel})
}

function get_QueueCountFromInnerInfo {
 local iFarm=$1
 local iPosition=$2
 local iCount
 local iSlots=1
 local iBlocked
 GetInnerInfoData $TMPFILE $iFarm $iPosition innerinfos
 # these buildings always have at least one slot. we'll check slots 2 and 3...
 for iCount in 2 3; do
  iBlocked=$($JQBIN '.datablock[1]["slots"]["'${iCount}'"].block?' $TMPFILE 2>/dev/null)
  if [ $iBlocked -eq 0 ]; then
   iSlots=$((iSlots+1))
  fi
 done
 echo $iSlots
}

function get_QueueCount20 {
 local iFarm=$1
 local iPosition=$2
 local iCount
 local iSlots=1
 local sBlocked
 # building ID 20 can have 4 slots, we only handle 3
 for iCount in 2 3; do
  sBlocked=$($JQBIN '.updateblock.farms.farms["'${iFarm}'"]["'${iPosition}'"].data.data.slots["'${iCount}'"].block?' $FARMDATAFILE 2>/dev/null)
  if [ "$sBlocked" = "null" ]; then
   iSlots=$((iSlots+1))
  fi
 done
 echo $iSlots
}

function add_QueuesToPosition {
 local iFarm=$1
 local iPosition=$2
 local iQueuesInFS=$3
 local iQueuesInGame=$4
 local iQueuesToAdd=$((iQueuesInGame-iQueuesInFS))
 # we'll assume queue '0' already exists
 if [ $iQueuesToAdd -eq 2 ] || ([ $iQueuesInFS -eq 2 ] && [ $iQueuesToAdd -eq 1 ]); then
  echo -e "sleep\nsleep" > ${iFarm}/${iPosition}/2
 fi
 if [ $iQueuesInFS -eq 1 ]; then
  echo -e "sleep\nsleep" > ${iFarm}/${iPosition}/1
 fi
}

function redeemPuzzlePartsPacks {
 local iNumPacks
 local iCount
 local iCount2
 local iType
 iNumPacks=$($JQBIN '.updateblock.farmersmarket.pets.packs | length' $FARMDATAFILE)
 if [ $iNumPacks -gt 0 ]; then
  for iCount in $(seq 0 $((iNumPacks-1))); do
   iType=$($JQBIN '.updateblock.farmersmarket.pets.packs | keys['$iCount'] | tonumber' $FARMDATAFILE)
   iNumPacks=$($JQBIN '.updateblock.farmersmarket.pets.packs["'$iType'"] | tonumber' $FARMDATAFILE)
   echo "Redeeming $iNumPacks puzzle parts pack(s) of type ${iType}..."
   for iCount2 in $(seq 1 $iNumPacks); do
    SendAJAXFarmRequest "mode=pets_open_pack&type=${iType}"
   done
  done
 fi
}

function check_PanBonus {
 # function by jbond47, update by maiblume & jbond47
 GetPanData "$FARMDATAFILE"
 local iToday=$($JQBIN '.datablock[11].today' $FARMDATAFILE)
 local iNumSheep=$($JQBIN '.datablock[11].collections.heros | length' $FARMDATAFILE)
 local iLastBonus
 local bValue
 # Hero Sheep Bonus
 if [ $iNumSheep -eq 12 ]; then # requires all 12 super sheep
  iLastBonus=$($JQBIN '.datablock[11].lastbonus.heros' $FARMDATAFILE)
  if [ $iLastBonus = "null" ]; then
   iLastBonus=0
  fi
  echo -n "Hero sheep..."
  if [ $iToday -gt $iLastBonus ]; then
   echo "available, claiming it..."
   SendAJAXFarmRequest "type=heros&mode=paymentitemcollection_bonus"
  else
   echo "already claimed"
  fi
 fi
 # Horror Sheep Bonus
 iNumSheep=$($JQBIN '.datablock[11].collections.horror | length' $FARMDATAFILE)
 if [ $iNumSheep -eq 9 ]; then # requires all 9 horror sheep
  iLastBonus=$($JQBIN '.datablock[11].lastbonus.horror' $FARMDATAFILE)
  if [ $iLastBonus = "null" ]; then
   iLastBonus=0
  fi
  echo -n "Horror sheep..."
  if [ $iToday -gt $iLastBonus ]; then
   echo "available, claiming it..."
   SendAJAXFarmRequest "type=horror&mode=paymentitemcollection_bonus"
  else
   echo "already claimed"
  fi
 fi
 # Sport Sheep Bonus
 iNumSheep=$($JQBIN '.datablock[11].collections.sport | length' $FARMDATAFILE)
 if [ $iNumSheep -eq 9 ]; then # requires all 9 sport sheep
  iLastBonus=$($JQBIN '.datablock[11].lastbonus.sport' $FARMDATAFILE)
  if [ $iLastBonus = "null" ]; then
   iLastBonus=0
  fi
  echo -n "Sport sheep..."
  if [ $iToday -gt $iLastBonus ]; then
   echo "available, claiming it..."
   SendAJAXFarmRequest "type=sport&mode=paymentitemcollection_bonus"
  else
   echo "already claimed"
  fi
 fi
 # Beach Sheep Bonus
 iNumSheep=$($JQBIN '.datablock[11].collections.beach | length' $FARMDATAFILE)
 if [ $iNumSheep -eq 9 ]; then # requires all 9 beach sheep
  iLastBonus=$($JQBIN '.datablock[11].lastbonus.beach' $FARMDATAFILE)
  if [ $iLastBonus = "null" ]; then
   iLastBonus=0
  fi
  echo -n "Beach sheep..."
  if [ $iToday -gt $iLastBonus ]; then
   echo "available, claiming it..."
   SendAJAXFarmRequest "type=beach&mode=paymentitemcollection_bonus"
  else
   echo "already claimed"
  fi
 fi
 # Fantasy Sheep Bonus
 iNumSheep=$($JQBIN '.datablock[11].collections.fantasy | length' $FARMDATAFILE)
 if [ $iNumSheep -eq 9 ]; then # requires all 9 fantasy sheep
  iLastBonus=$($JQBIN '.datablock[11].lastbonus.fantasy' $FARMDATAFILE)
  if [ $iLastBonus = "null" ]; then
   iLastBonus=0
  fi
  echo -n "Fantasy sheep..."
  if [ $iToday -gt $iLastBonus ]; then
   echo "available, claiming it..."
   SendAJAXFarmRequest "type=fantasy&mode=paymentitemcollection_bonus"
  else
   echo "already claimed"
  fi
 fi
 # Portal Rabbit Points
 bValue=$($JQBIN '.datablock[1].gifts | has("289")' $FARMDATAFILE)
 if [ "$bValue" = "true" ]; then
  echo -n "Portal rabbit..."
  bValue=$($JQBIN '.datablock[1].gifts."289" | has("giver")' $FARMDATAFILE)
  if [ "$bValue" = "true" ]; then
   echo "available, claiming it..."
   SendAJAXCityRequest "city=0&mode=giverpresent&id=289"
  else
   echo "already claimed"
  fi
 fi
 # Bug Rogers Points
 bValue=$($JQBIN '.datablock[1].gifts | has("410")' $FARMDATAFILE)
 if [ "$bValue" = "true" ]; then
  echo -n "Bug Rogers..."
  bValue=$($JQBIN '.datablock[1].gifts."410" | has("giver")' $FARMDATAFILE)
  if [ "$bValue" = "true" ]; then
   echo "available, claiming it..."
   SendAJAXCityRequest "city=0&mode=giverpresent&id=410"
  else
   echo "already claimed"
  fi
 fi
}

function check_ButterflyBonus {
 local iToday=$($JQBIN '.updateblock.farmersmarket.butterfly.data.today' $FARMDATAFILE)
 local iNumKeys=$($JQBIN '.updateblock.farmersmarket.butterfly.data.free | length' $FARMDATAFILE)
 local iCount
 local iLast
 local iKey
 if [ $iNumKeys -gt 0 ]; then
  for iCount in $(seq 0 $((iNumKeys-1))); do
   iKey=$($JQBIN '.updateblock.farmersmarket.butterfly.data.free | keys['$iCount'] | tonumber' $FARMDATAFILE)
   iLast=$($JQBIN '.updateblock.farmersmarket.butterfly.data.free["'$iKey'"].last?' $FARMDATAFILE)
   if [ "$iLast" = "null" ] || [ $iLast -lt $iToday ] 2>/dev/null; then
    if [ "$NONPREMIUM" != "NP" ]; then
     # butterfly can give a bonus (premium)
     echo "Collecting butterfly points bonus..."
     SendAJAXFarmRequest "mode=butterfly_click_all"
     return
    fi
    echo "Collecting points bonus from butterfly type ${iKey}..."
    SendAJAXFarmRequest "id=${iKey}&mode=butterfly_click"
   fi
  done
 fi
}

function check_DeliveryEvent {
 local iPointsNeeded=250
 local iPointsAvailable
 local iDeliveryEventRunning=$($JQBIN '.updateblock.menue.deliveryevent' $FARMDATAFILE)
 if [ "$iDeliveryEventRunning" = "0" ]; then
  return
 fi
 if check_TimeRemaining '.updateblock.menue.deliveryevent.data.tour.remain'; then
  iPointsAvailable=$($JQBIN '.updateblock.menue.deliveryevent.data["points"]' $FARMDATAFILE)
  if [ $iPointsAvailable -ge $iPointsNeeded ] 2>/dev/null; then
   echo "Starting one-hour delivery tour..."
   SendAJAXFarmRequest "spot=playground&mode=deliveryevent_starttour"
  else
   echo "Not enough points to start delivery tour"
  fi
 fi
}

function check_OlympiaEvent {
 GetOlympiaData $FARMDATAFILE
 local iBerriesNeeded=20
 local iBerriesAvailable
 local iEnergy
 local iOlympiayEventRemain=$($JQBIN '.datablock.remain?' $FARMDATAFILE)
 if [ $iOlympiayEventRemain -gt 0 ] 2>/dev/null; then
  iBerriesAvailable=$($JQBIN '.datablock.data.berries' $FARMDATAFILE)
  iEnergy=$($JQBIN '.datablock.energy' $FARMDATAFILE)
  if [ $iEnergy -lt 100 ] && [ $iBerriesAvailable -ge $iBerriesNeeded ]; then
   echo "Re-filling 10% energy..."
   SendAJAXMainRequest "amount=10&action=olympia_entry"
  fi
 fi
}

function check_TimeRemaining {
 # returns true if a zero or negative timer is found
 # and sets new PAUSETIME if applicable
 local sFilter=$1
 local iRemaining=$($JQBIN $sFilter $FARMDATAFILE 2>/dev/null)
 if ! [ $iRemaining -eq $iRemaining ] 2>/dev/null || [ -z "$iRemaining" ]; then
  # value is not an integer or empty
  return 1
 fi
 if [ $iRemaining -le 0 ]; then
  return 0
 else
  if [ $iRemaining -gt 0 ] && [ $iRemaining -lt $PAUSETIME ]; then
   PAUSETIME=$iRemaining
   PAUSECORRECTEDAT=$(date +"%s")
  fi
 fi
 return 1
}

function SendAJAXFarmRequest {
 local sAJAXSuffix=$1
 WGETREQ ${AJAXFARM}${sAJAXSuffix}
}

function SendAJAXFarmRequestOverwrite {
 local sAJAXSuffix=$1
 wget -nv -T10 -a $LOGFILE --output-document=$FARMDATAFILE --user-agent="$AGENT" --load-cookies $COOKIEFILE ${AJAXFARM}${sAJAXSuffix}
 # need to keep farm data file up to date here
}

function SendAJAXForestryRequest {
 local sAJAXSuffix=$1
 WGETREQ ${AJAXFOREST}${sAJAXSuffix}
}

function SendAJAXFoodworldRequest {
 local sAJAXSuffix=$1
 WGETREQ ${AJAXFOOD}${sAJAXSuffix}
}

function SendAJAXCityRequest {
 local sAJAXSuffix=$1
 WGETREQ ${AJAXCITY}${sAJAXSuffix}
}

function SendAJAXMainRequest {
 local sAJAXSuffix=$1
 WGETREQ ${AJAXMAIN}${sAJAXSuffix}
}

function SendAJAXGuildRequest {
 local sAJAXSuffix=$1
 WGETREQ ${AJAXGUILD}${sAJAXSuffix}
}
