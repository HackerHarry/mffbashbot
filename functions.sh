# Functions file for Harrys My Free Farm Bash Bot
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

# WGETREQ="wget -nv -a $LOGFILE --output-document=/dev/null --user-agent=\"$AGENT\" --load-cookies $COOKIEFILE"
# quoting within a variable are never a good idea...
function WGETREQ {
 sHTTPReq=$1
 wget -nv -a $LOGFILE --output-document=/dev/null --user-agent="$AGENT" --load-cookies $COOKIEFILE $sHTTPReq
}
AJAXFARM="http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/farm.php?rid=${RID}&"
AJAXFOREST="http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/forestry.php?rid=${RID}&"
AJAXFOOD="http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/foodworld.php?rid=${RID}&"
AJAXCITY="http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/city.php?rid=${RID}&"

function ctrl_c {
 echo "Caught CTRL-C - Trying to log off..."
 wget -nv -a $LOGFILE --output-document=/dev/null --user-agent="$AGENT" --load-cookies $COOKIEFILE "$LOGOFFURL"
 rm -f "$STATUSFILE"
 exit 1
}

function GetFarmData {
 local sFile=$1
 wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/farm.php?rid=${RID}&mode=getfarms&farm=1&position=0"
}

function GetForestryData {
 local sFile=$1
 wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/forestry.php?rid=${RID}&action=initforestry"
}

function GetFoodWorldData {
 local sFile=$1
 wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/foodworld.php?action=foodworld_init&id=0&table=0&chair=0&rid=${RID}"
}

#function GetMenuUpdateData {
# local sFile=$1
# wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.${TLD}/menu-update.php"
#}

function GetLotteryData {
 sFile=$1
 wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/city.php?rid=${RID}&city=2&mode=initlottery"
}

function GetWindMillData {
 local sFile=$1
 wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/city.php?rid=${RID}&city=2&mode=windmillinit"
}

function GetInnerInfoData {
 local sFile=$1
 local iFarm=$2
 local iPosition=$3
 wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/farm.php?rid=${RID}&mode=innerinfos&farm=${iFarm}&position=${iPosition}"
}

function DoFarm {
 # read function from queue file
 local iFarm=$1
 # for the forestry this should be called sFarm.. but what the hell.
 local iPosition=$2
 local iSlot=$3
 if check_QueueSleep ${iFarm}/${iPosition}/${iSlot}; then
  echo "Set to sleep."
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
 # fetch garden data overwriting $FARMDATAFILE
 SendAJAXFarmRequestOverwrite "mode=gardeninit&farm=${iFarm}&position=${iPosition}"
 local iProduct=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 local iProductDim_x=$(echo $aDIM_X | $JQBIN '."'${iProduct}'"|tonumber')
 local iProductDim_y=$(echo $aDIM_Y | $JQBIN '."'${iProduct}'"|tonumber')
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
    SendAJAXFarmRequest "${sData}cid=${iPosition}"
    SendAJAXFarmRequest "${sDataWater}"
    GetFarmData $FARMDATAFILE
    return
   else
    GetFarmData $FARMDATAFILE
    return
   fi
  fi
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
   SendAJAXFarmRequestOverwrite "${sData}cid=${iPosition}"
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
 if ! get_FieldPlotReadiness $((iPlot+1)) ; then
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
   SendAJAXFarmRequestOverwrite "${sData}cid=${iPosition}"
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
 if ! get_FieldPlotReadiness $((iPlot+12)) ; then
  iPlot=$((iPlot+1))
  continue
 fi
 if ! get_FieldPlotReadiness $((iPlot+13)) ; then
  iPlot=$((iPlot+1))
  continue
 fi
 sData="${sData}pflanze[]=${iProduct}&feld[]=${iPlot}&felder[]=${iPlot},$((iPlot+1)),$((iPlot+12)),$((iPlot+13))&"
 sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot},$((iPlot+1)),$((iPlot+12)),$((iPlot+13))&"
 iCacheFlag=1
 iCache=$((iCache+1))
 if [ $iCache -eq 5 ]; then
  SendAJAXFarmRequestOverwrite "${sData}cid=${iPosition}"
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
 # this function only supports completely filled fields of the same crop
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
  echo "Set to sleep."
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
  echo "Set to sleep."
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
 local iPID=$($JQBIN '.updateblock.farmersmarket.flower_area["1"].pid|tonumber' $FARMDATAFILE)
 local iCount
 local sData="mode=flowerarea_harvest&farm=1&position=1&set="
 for iCount in $(seq 1 36); do
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
 for iCount in $(seq 1 36); do
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
 # echo "Finishing animal treatment in slot ${iSlot}..."
 SendAJAXFarmRequest "mode=vet_endtreatment&farm=1&position=1&id=${iSlot}&slot=${iSlot}"
 if get_AnimalQueueLength ; then
  # queue is empty, return
  return
 fi
 # get animal ID from queue holding status 0
 local iCount=0
 local iAnimalStatus=1
 while [ "$iAnimalStatus" -eq 1 ]; do 
  local iAnimalID=$($JQBIN '.updateblock.farmersmarket.vet.animals.queue|keys['${iCount}']|tonumber' $FARMDATAFILE)
  iAnimalStatus=$($JQBIN '.updateblock.farmersmarket.vet.animals.queue["'${iAnimalID}'"].status|tonumber' $FARMDATAFILE)
  iCount=$((iCount+1))
 done
 # place it in slot
 SendAJAXFarmRequest "mode=vet_setslot&farm=1&position=1&id=${iSlot}&slot=${iSlot}&aid=${iAnimalID}"
 # isolate deseases for animal ID
 local iQueueLength=$($JQBIN '.updateblock.farmersmarket.vet.animals.queue["'${iAnimalID}'"].diseases|length' $FARMDATAFILE)
 local sTreatmentSet=
 for iCount in $(seq 0 $((iQueueLength-1))); do
  iDiseaseID=$($JQBIN '.updateblock.farmersmarket.vet.animals.queue["'${iAnimalID}'"].diseases['${iCount}'].id' $FARMDATAFILE)
  # find fastest cure for disease
  iFastestCure=$(get_AnimalsFastestCureForDisease $iDiseaseID)
  sTreatmentSet=${sTreatmentSet}${iDiseaseID}_${iFastestCure},
 done
 # start treatment
 # echo "Starting new animal treatment in slot ${iSlot}..."
 SendAJAXFarmRequest "mode=vet_starttreatment&farm=1&position=1&id=${iSlot}&slot=${iSlot}&set=${sTreatmentSet}"
 GetFarmData $FARMDATAFILE
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

function harvest_MegaField {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 iHarvestDevice=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 # check for running job
 if check_RunningMegaFieldJob ; then
  echo "Checking for pending tasks on Mega Field..."
  iHarvestDelay=$(get_MegaFieldHarvesterDelay $iHarvestDevice)
  while check_RipePlotOnMegaField ; do
   # iPlot and sPlotName come from check_RipePlotOnMegaField
   check_MegaFieldEmptyHarvestDevice $iHarvestDevice
   # harvest mega field plot
   local iPlotnum=$(echo $sPlotName | tr -d '"')
   # check for 2x2 harvest device
#   case "$iHarvestDevice" in
#    5|7|9|10) iPlotnum=$(get_MegaField2x2Set $iPlotnum)
#    ;;
#   esac
   echo -n "Harvesting Mega Field plot ${iPlotnum}..."
   SendAJAXFarmRequestOverwrite "mode=megafield_tour&farm=1&position=1&set=${iPlotnum},|&vid=${iHarvestDevice}"
   echo "delaying ${iHarvestDelay} seconds"
   sleep ${iHarvestDelay}s
  done
 fi
}

#function get_MegaField2x2Set {
# local s2x2Set=$1
# if [ $s2x2Set -gt 88 ]; then
#  s2x2Set=$((s2x2Set-11))
#  # prevent harvesting of last row
# fi
# if ! ((s2x2Set % 11)); then
#  s2x2Set=$((s2x2Set-1))
#  # prevent harvesting of last column
# fi
# s2x2Set="${s2x2Set},$((s2x2Set+1)),$((s2x2Set+11)),$((s2x2Set+12))"
# echo $s2x2Set
#}

function start_MegaField {
 local iProductSlot
 local iSafetyCount=$1
 if [ $iSafetyCount -gt 4 ] 2>/dev/null; then
  echo "Exiting start_MegaField after four cycles! (Not enough crop in stock?)"
  return
 fi
 for iProductSlot in 0 1 2; do
  if ! check_MegaFieldProductIsHarvestable $iProductSlot ; then
   continue
  fi
  # here we've got a product that is harvestable
  local iPID=$($JQBIN '.updateblock.megafield.job.products['$iProductSlot'].pid' $FARMDATAFILE)
  local amountToGo=$(get_MegaFieldAmountToGoInSlot $iProductSlot)
  if [ "$amountToGo" = "0" ]; then
   continue
   # no need to plant more
  fi
  local iFreePlots=$(get_MegaFieldFreePlotsNum)
  if [ $iFreePlots -eq 0 ]; then
   # no free plots, no need to plant
   return
  fi
  # plant
  if [ $iFreePlots -lt $amountToGo ]; then
   # plant on all free plots
   MegaFieldPlant${NONPREMIUM} $iPID $iFreePlots
   GetFarmData $FARMDATAFILE
   # exit function
   return
  fi
  MegaFieldPlant${NONPREMIUM} $iPID $amountToGo
  # call function again since there are still free plots
  GetFarmData $FARMDATAFILE
  if [ "$iSafetyCount" = "" ]; then
   start_MegaField 2
  else
   iSafetyCount=$((iSafetyCount+1))
   start_MegaField $iSafetyCount
  fi
 done
 GetFarmData $FARMDATAFILE
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
 GetInnerInfoData $TMPFILE $iFarm $iPosition
 for iSlot in 1 2 3; do
  sBlocked=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].block?' $TMPFILE)
  if [ "$sBlocked" = "null" ] || [ "$sBlocked" = "0" ]; then
   iFarmie=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].data.farmi?' $TMPFILE)
   if [ "$iFarmie" != "null" ]; then
    if $JQBIN '.datablock[1].farmis["'$iFarmie'"].data.remain?' $TMPFILE | grep -q '-' ; then
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
  GetInnerInfoData $TMPFILE $iFarm $iPosition
  sBlocked=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].block?' $TMPFILE)
  if [ "$sBlocked" = "null" ]; then
   iFarmie=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].data.farmi?' $TMPFILE)
   if [ "$iFarmie" = "null" ]; then
    # slot is unblocked and idle...
    iPony=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].animalid|tonumber' $TMPFILE)
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
 iFarmiesCount=$($JQBIN '.datablock[1].farmis|length' $TMPFILE)
 for iCount in $(seq 0 $((iFarmiesCount-1))); do
  iFarmie=$($JQBIN '.datablock[1].farmis|keys['${iCount}']|tonumber' $TMPFILE)
  iStatus=$($JQBIN '.datablock[1].farmis["'${iFarmie}'"].status|tonumber' $TMPFILE)
  if [ $iStatus -eq 0 ]; then
   # farmie is not in use
   iType=$($JQBIN '.datablock[1].farmis["'${iFarmie}'"].type|tonumber' $TMPFILE)
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
  iCurrentVehiclePos=$($JQBIN '.updateblock.map.vehicles["'${iRoute}'"]["'$iVehicle'"].current|tonumber' $FARMDATAFILE)
  if [ "$iCurrentVehiclePos" = "1" ]; then
   echo "on farm 1, sending it to farm $iFarm"
   SendAJAXFarmRequest "mode=map_sendvehicle&farm=1&position=1&route=${iRoute}&vehicle=${iVehicle}&cart="
  else
   echo "on farm $iCurrentVehiclePos"
   # check if sending a fully loaded vehicle is possible
   check_VehicleFullLoad $iVehicle $iFarm $iRoute
  fi
 else
  echo "en route"
 fi
}

function check_VehicleFullLoad {
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
 local iVehicleCapacity=$($JQBIN '.updateblock["map"]["config"]["vehicles"]["'${iVehicle}'"]["capacity"]' $FARMDATAFILE)
 local iVehicleSlotCount=$($JQBIN '.updateblock["map"]["config"]["vehicles"]["'${iVehicle}'"]["products"]' $FARMDATAFILE)
 local iFieldsOnFarmNum=$(get_FieldsOnFarmNum $iFarm)
 # this will fail if more than one rack is in use on farms 5 or 6
 local iItemCount=$($JQBIN '.updateblock.stock.stock["'${iFarm}'"]["1"]|keys|length' $FARMDATAFILE)
 # You know, somehow, "I told you so" just doesn't quite say it. ;)
 for iCount in $(seq 1 $iItemCount); do
  iProduct=$($JQBIN '.updateblock.stock.stock["'${iFarm}'"]["1"]["'${iCount}'"]["pid"]|tonumber' $FARMDATAFILE)
  iProductCount=$($JQBIN '.updateblock.stock.stock["'${iFarm}'"]["1"]["'${iCount}'"]["amount"]|tonumber' $FARMDATAFILE)
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
 local iProductDim_x=$(echo $aDIM_X | $JQBIN '."'${iProduct}'"|tonumber')
 local iProductDim_y=$(echo $aDIM_Y | $JQBIN '."'${iProduct}'"|tonumber')
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
  iBuildingID=$($JQBIN '.updateblock.farms.farms["'${iFarm}'"]["'${iCount}'"].buildingid|tonumber' $FARMDATAFILE)
  bStatus=$($JQBIN '.updateblock.farms.farms["'${iFarm}'"]["'${iCount}'"].status|tonumber' $FARMDATAFILE)
  if [ $iBuildingID -eq 1 ] && [ $bStatus -eq 1 ]; then
   # building is a field and is active
   iFieldsOnFarm=$((iFieldsOnFarm+1))
  fi
 done
 echo $iFieldsOnFarm
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
  head -2 $sInfile| tail -1 >>$sTmpfile
  mv $sTmpfile $sInfile
  unset sInfile sTmpfile
 fi
}

function check_QueueSleep {
 local sFile=$1
 local sQueueItem=$(sed '2q;d' $sFile)
 if [ "$sQueueItem" = "sleep" ]; then
  return 0
 fi
  return 1
}

function check_RunningMegaFieldJob {
 local iJobEnd=$($JQBIN '.updateblock.megafield.job_endtime|tonumber' $FARMDATAFILE)
 local iJobStart=$($JQBIN '.updateblock.megafield.job_start|tonumber' $FARMDATAFILE)
 if [ $iJobStart -gt 0 ] && [ $iJobEnd -eq 0 ]; then
  return 0
 fi
 return 1
}

function check_RipePlotOnMegaField {
 # returns true if a plot shows a negative remainder
 # propagates iPlot and sPlotName
 local iBusyPlots=$(get_MegaFieldBusyPlotsNum)
 # DON'T set this local
 iPlot=0
 while [ "$iPlot" -lt "$iBusyPlots" ]; do
  # or this
  sPlotName=$(get_BusyMegaFieldPlotName $iPlot)
  if $JQBIN '.updateblock.megafield.area['${sPlotName}'].remain' $FARMDATAFILE | grep -q '-' ; then
   return 0
  fi
  # or this
  iPlot=$((iPlot+1))
 done
 return 1
}

function get_BusyMegaFieldPlotNum {
 local iBusyPlots=$($JQBIN '.updateblock.megafield.area|length' $FARMDATAFILE)
 echo $iBusyPlots
}

function get_UnlockedMegaFieldPlotNum {
 local iUnlockedPlots=$($JQBIN '.updateblock.megafield.area_free|length' $FARMDATAFILE)
 # we always have a positive number here
 echo $iUnlockedPlots
}

function get_BusyMegaFieldPlotName {
 local iPlotIndex=$1
 local sPlotName=$($JQBIN '.updateblock.megafield.area|keys|.['$iPlotIndex']' $FARMDATAFILE)
 echo $sPlotName
}

function get_MegaFieldHarvesterDelay {
 local iHarvestDevice=$1
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
 local iDurability=$($JQBIN '.updateblock.megafield.vehicles["'${iHarvestDevice}'"].durability' $FARMDATAFILE 2>/dev/null)
 if [ "$iDurability" = "null" ] || [ -z "$iDurability" ]; then
  # buy a brand new one if empty
  echo "Buying new vehicle #${iHarvestDevice}..."
  SendAJAXFarmRequest "mode=megafield_vehicle_buy&farm=1&position=1&id=${iHarvestDevice}&vid=${iHarvestDevice}"
  # update farm data in order to prevent permanent re-buy during harvest phase
  GetFarmData $FARMDATAFILE
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
 iBusyPlots=$(get_BusyMegaFieldPlotNum)
 if [ $iBusyPlots -eq 0 ] ; then
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
 local iTotalPlots=$($JQBIN '.updateblock.megafield.area_free|length' $FARMDATAFILE)
 local iBusyPlots=$($JQBIN '.updateblock.megafield.area|length' $FARMDATAFILE)
 local iFreePlots=$((iTotalPlots-iBusyPlots))
 echo $iFreePlots
}

function get_MegaFieldBusyPlotsNum {
 local iBusyPlots=$($JQBIN '.updateblock.megafield.area|length' $FARMDATAFILE)
 echo $iBusyPlots
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
    sUnlockedPlotName=$($JQBIN '.updateblock.megafield.area_free|keys|.['$iCount2']|tonumber' $FARMDATAFILE)
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

function get_AnimalQueueLength {
 local iAnimalQueueLength=($($JQBIN '.updateblock.farmersmarket.vet.animals.queue|length' $FARMDATAFILE))
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
      # Röhrhusten
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
      # Sehschwäche
      ;;
   9) echo 307
      # Rote Augen
      ;;
   10) echo 309
      # Grüner Schnupfen
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
      # Hörschwäche
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
      # Furchtbarer Röhrhusten
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
      # Furchtbare Sehschwäche
      ;;
   37) echo 335
      # Furchtbar Wacklige Beine
      ;;
   38) echo 336
      # Furchtbarer Kopfschmerz
      ;;
   39) echo 336
      # Furchtbar Grüner Schnupfen
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
      # Furchtbare Hörschwäche
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
 local sResult=$($JQBIN '.datablock[1]|to_entries[]["value"]["teil_nr"?]' $FARMDATAFILE 2>/dev/null)
 if [ -z "$sResult" ]; then
  # structure changes after planting once
  sResult=$($JQBIN '.datablock[3][1]|to_entries[]["value"]["teil_nr"?]' $FARMDATAFILE 2>/dev/null)
 fi
 if ! echo $sResult | grep -q '"'${iPlot}'"' ; then
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
 GetInnerInfoData $TMPFILE $iFarm $iPosition
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
 if [ $iQueuesToAdd -eq 2 ]; then
  echo -e "sleep\nsleep" > ${iFarm}/${iPosition}/2
 fi
 echo -e "sleep\nsleep" > ${iFarm}/${iPosition}/1
}

function SendAJAXFarmRequest {
 local sAJAXSuffix=$1
 WGETREQ ${AJAXFARM}${sAJAXSuffix}
}

function SendAJAXFarmRequestOverwrite {
 local sAJAXSuffix=$1
 wget -nv -a $LOGFILE --output-document=$FARMDATAFILE --user-agent="$AGENT" --load-cookies $COOKIEFILE ${AJAXFARM}${sAJAXSuffix}
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
