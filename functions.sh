# Functions file for My Free Farm Bash Bot
# Copyright 2016-19 Harun "Harry" Basalamah
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
 echo -e "\nCaught an exit signal"
 if [ -e "$STATUSFILE" ]; then
  echo "Logging off..."
  WGETREQ "$LOGOFFURL"
  rm -f "$STATUSFILE" "$COOKIEFILE" "$FARMDATAFILE" "$OUTFILE" "$TMPFILE" "$PIDFILE" "$TMPFILE"-[5-6]-[1-6]
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

function GetCalendarData {
 sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXFARM}mode=calendar_init"
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
 local sOldIFS=$IFS
 IFS=,
 set -- $aParams
 IFS=$sOldIFS
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
 iPID=$((iPID - 154))
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
 iPID=$((iPID - 115))
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
 iPID=$((iPID - 749))
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
   iPlot=$((iPlot + 1))
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
  iPlot=$((iPlot + 1))
  continue
 fi
 # plot can be used
 if [ $iProductDim_x -eq 1 ]; then
  # product dimensions is 1 x 1
  sData="${sData}pflanze[]=${iProduct}&feld[]=${iPlot}&felder[]=${iPlot}&"
  sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot}&"
  iCacheFlag=1
  iCache=$((iCache + 1))
  if [ $iCache -eq 5 ]; then
   # CID is some water interval ID .. screw it.
   SendAJAXFarmRequest "${sData}cid=${iPosition}"
   SendAJAXFarmRequest "${sDataWater}"
   sData="mode=garden_plant&farm=${iFarm}&position=${iPosition}&"
   sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
   iPlot=$((iPlot + 1))
   iCacheFlag=0
   iCache=0
   continue
  else
   iPlot=$((iPlot + 1))
   continue
  fi
 fi
 # x dim is 2
 if ! get_FieldPlotReadiness $((iPlot + 1)); then
  iPlot=$((iPlot + 2))
  continue
 fi
 if [ $iProductDim_y -eq 1 ]; then
  # product dimensions is 1 x 2
  sData="${sData}pflanze[]=${iProduct}&feld[]=${iPlot}&felder[]=${iPlot},$((iPlot + 1))&"
  sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot},$((iPlot + 1))&"
  iCacheFlag=1
  iCache=$((iCache + 1))
  if [ $iCache -eq 5 ]; then
   SendAJAXFarmRequest "${sData}cid=${iPosition}"
   SendAJAXFarmRequest "${sDataWater}"
   sData="mode=garden_plant&farm=${iFarm}&position=${iPosition}&"
   sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
   iPlot=$((iPlot + 2))
   iCacheFlag=0
   iCache=0
   continue
  else
   iPlot=$((iPlot + 2))
   continue
  fi
 fi
 # y dim is 2
 if ! get_FieldPlotReadiness $((iPlot + 12)); then
  iPlot=$((iPlot + 1))
  continue
 fi
 if ! get_FieldPlotReadiness $((iPlot + 13)); then
  iPlot=$((iPlot + 1))
  continue
 fi
 sData="${sData}pflanze[]=${iProduct}&feld[]=${iPlot}&felder[]=${iPlot},$((iPlot + 1)),$((iPlot + 12)),$((iPlot + 13))&"
 sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot},$((iPlot + 1)),$((iPlot + 12)),$((iPlot + 13))&"
 iCacheFlag=1
 iCache=$((iCache + 1))
 if [ $iCache -eq 5 ]; then
  SendAJAXFarmRequest "${sData}cid=${iPosition}"
  SendAJAXFarmRequest "${sDataWater}"
  sData="mode=garden_plant&farm=${iFarm}&position=${iPosition}&"
  sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
  iPlot=$((iPlot + 2))
  iCacheFlag=0
  iCache=0
  continue
 else
  iPlot=$((iPlot + 2))
  continue
 fi
# you should not get here :)
 done
}

function water_Field {
 local iFarm=$1
 local iPosition=$2
 SendAJAXFarmRequest "mode=watergarden&farm=${iFarm}&position=${iPosition}"
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
   iPlot=$((iPlot + 1))
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
  iCache=$((iCache + 1))
  if [ $iCache -eq 5 ]; then
   SendAJAXFarmRequest "${sDataWater}"
   sleep 1
   sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
   iPlot=$((iPlot + 1))
   iCacheFlag=0
   iCache=0
   continue
  else
   iPlot=$((iPlot + 1))
   continue
  fi
 fi
 # x dim is 2
 if [ $iProductDim_y -eq 1 ]; then
  # product dimensions is 1 x 2
  sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot},$((iPlot + 1))&"
  iCacheFlag=1
  iCache=$((iCache + 1))
  if [ $iCache -eq 5 ]; then
   SendAJAXFarmRequest "${sDataWater}"
   sleep 1
   sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
   iPlot=$((iPlot + 2))
   iCacheFlag=0
   iCache=0
   continue
  else
   iPlot=$((iPlot + 2))
   continue
  fi
 fi
 # y dim is 2
 sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot},$((iPlot + 1)),$((iPlot + 12)),$((iPlot + 13))&"
 iCacheFlag=1
 iCache=$((iCache + 1))
 if [ $iCache -eq 5 ]; then
  SendAJAXFarmRequest "${sDataWater}"
  sleep 1
  sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
  iPlot=$((iPlot + 2))
  iCacheFlag=0
  iCache=0
  continue
 else
  iPlot=$((iPlot + 2))
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

function check_MunchiesAtTables {
 local sJSONDataType
 local iTable
 local iChair
 local bMunchieReady
 # JSON data uses different data types when you bought further tables on food world
 sJSONDataType=$($JQBIN -r '.datablock.tables | type' $FARMDATAFILE)
 for iTable in {0..4}; do
  # Munchies on unleased tables can still be claimed, do not skip iTable loop
  for iChair in 1 2; do
   if [ "$sJSONDataType" = "object" ]; then
    bMunchieReady=$($JQBIN '.datablock.tables."'${iTable}'"."chairs"."'${iChair}'".ready? == 1' $FARMDATAFILE)
   elif [ "$sJSONDataType" = "array" ]; then
    bMunchieReady=$($JQBIN '.datablock.tables['${iTable}']."chairs"."'${iChair}'".ready? == 1' $FARMDATAFILE)
   else
    echo "Error: Unknown JSON datatype: ${sJSONDataType}" >&2
    break 2
   fi
   if [ "$bMunchieReady" = "true" ]; then
    echo "Munchie available at table $((iTable + 1)), chair ${iChair}, claiming it..."
    SendAJAXFoodworldRequest "action=cash&id=0&table=${iTable}&chair=${iChair}"
   fi
  done
 done
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
 local iAnimalsHealedCount=$($JQBIN '.updateblock.farmersmarket.vet.info.role_count | tonumber' $FARMDATAFILE)
 local iAnimals2HealCount=$($JQBIN '.updateblock.farmersmarket.vet.info.role_count_max | tonumber' $FARMDATAFILE)
 # we're not using updated farm data at this point, but a treatment has just been finished
 # that's why we're calculating with one less treatment
 iAnimals2HealCount=$((iAnimals2HealCount - 1))
 if [ $iAnimals2HealCount -eq $iAnimalsHealedCount ]; then
  local iVetJob=$(get_ConfigValue restartvetjob)
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
  local sCare=$(get_ConfigValue care${sSlot})
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
 local iPID=$(get_ConfigValue racecowslot${iSlot})
 local sSlotType=$($JQBIN -r '.updateblock.farmersmarket.cowracing.data.cowslots["'${iSlot}'"] | type' $FARMDATAFILE 2>/dev/null)
 if [ "$sSlotType" = "number" ]; then
  if ! check_CowIsPvP ${iSlot}; then
   SLOTREMAIN=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'${iSlot}'"].feed_remain?' $FARMDATAFILE 2>/dev/null)
   if [ "$SLOTREMAIN" = "null" ]; then
    echo "Feeding race cow in slot ${iSlot}..."
    SendAJAXFarmRequest "pid=${iPID}&slot=${iSlot}&mode=cowracing_feedCow"
   else
    check_TimeRemaining '.updateblock.farmersmarket.cowracing.data.cows["'${iSlot}'"].feed_remain?'
   fi
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
 local iCowLevel
 local aSlots=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cowslots | keys | .[] | tonumber' $FARMDATAFILE 2>/dev/null)
 for iSlot in $aSlots; do
  if check_TimeRemaining '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"]?.race_remain'; then
   if grep -q "excluderank1cow = 1" $CFGFILE && check_CowRanked1st $iSlot; then
    echo "Skipping training race for cow ranked 1st in slot $iSlot"
    continue
   fi
   if check_CowIsPvP ${iSlot}; then
    echo "Skipping PvP signed up cow in slot $iSlot"
    continue
   fi
   iCowLevel=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].level' $FARMDATAFILE)
   if [ $iCowLevel -gt 1 ]; then
    # remove all equipment from cow
    remove_CowEquipment $iSlot
    sEnvironment=$($JQBIN -r '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].lanestatus' $FARMDATAFILE 2>/dev/null)
    for sBodyPart in head body foot; do
     # find/equip best equipment for the cow, buy non-coin equipment if possible
     iEquipmentID=$(get_CowEquipmentID $sBodyPart $sEnvironment)
     if [ "$iEquipmentID" = "-1" ]; then
      continue
     fi
     # equip it
     SendAJAXFarmRequest "id=${iEquipmentID}&slot=${iSlot}&mode=cowracing_equipitem"
    done
   # start the race
   sleep 1
  fi
  echo "Starting cow training race in slot ${iSlot}..."
  SendAJAXFarmRequestOverwrite "type=pve&slot=${iSlot}&mode=cowracing_startrace" && sleep 3
  # put equipment back into stock
  remove_CowEquipment $iSlot
  fi
 done
 # refresh farm data
 GetFarmData $FARMDATAFILE
}

function check_CowRacePvP {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 if check_QueueSleep ${iFarm}/${iPosition}/${iSlot}; then
  return
 fi
 local iCowSlot=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 local sIsPvP
 local bTimeThreshold
 local sEnvironment
 local sBodyPart
 sIsPvP=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows | .[] | select(.ispvp == "1").ispvp' $FARMDATAFILE)
 if [ -n "$sIsPvP" ]; then
  echo "You have already signed up for the PvP cow race"
  return
 fi
 # give player enough time to sign up in case he chooses to override the bot
 bTimeThreshold=$($JQBIN '.updateblock.farmersmarket.cowracing.pvp.racedayremain < 7200' $FARMDATAFILE)
 if [ "$bTimeThreshold" = "false" ]; then
  return
 fi
 if ! check_CowRanked1st $iCowSlot; then
  echo "The cow you chose isn't ranked 1st!"
  return
 fi
 if check_CowSuspended $iCowSlot; then
  echo "The cow you chose has been temporarily suspended from PvP racing"
  return
 fi
 # ready to rock
 remove_CowEquipment $iCowSlot
 sEnvironment=$($JQBIN -r '.updateblock.farmersmarket.cowracing.pvp.lanestatus' $FARMDATAFILE 2>/dev/null)
 for sBodyPart in head body foot; do
  iEquipmentID=$(get_CowEquipmentID $sBodyPart $sEnvironment)
  if [ "$iEquipmentID" = "-1" ]; then
   continue
  fi
  SendAJAXFarmRequest "id=${iEquipmentID}&slot=${iCowSlot}&mode=cowracing_equipitem"
 done
 sleep 1
 echo "Signing up cow in slot ${iCowSlot} for the next PvP race..."
 # we cannot remove the eqiupment here
 SendAJAXFarmRequest "slot=${iCowSlot}&mode=cowracing_registercowpvp" && sleep 3
 update_queue ${iFarm} ${iPosition} ${iSlot}
 GetFarmData $FARMDATAFILE
}

function remove_CowEquipment {
 # does what the name suggests. mind that this function overwrites $FARMDATAFILE !
 local iSlot=$1
 local sBodyPart
 local bItemEquipped
 local iSuspendedCowSlot
 for sBodyPart in head body foot; do
  bItemEquipped=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'${iSlot}'"].slot_'${sBodyPart}' != "0"' $FARMDATAFILE)
  if [ "$bItemEquipped" = "true" ]; then
   SendAJAXFarmRequestOverwrite "type=${sBodyPart}&slot=${iSlot}&mode=cowracing_unequipitem" && sleep 1
  fi
 done
 # call again if PvP race cow is still wearing items
 iSuspendedCowSlot=$($JQBIN -r '.updateblock.farmersmarket.cowracing.data.cows | .[] | select(.suspendpvp == "1" and (.slot_head != "0" or .slot_body != "0" or .slot_foot != "0")).slot' $FARMDATAFILE)
 if [ -n "$iSuspendedCowSlot" ]; then
  remove_CowEquipment $iSuspendedCowSlot
 fi
}

function get_CowEquipmentID {
 local sBodyPart=$1
 local sEnvironment=$2
 local iEquipmentID=-1
 case "$sBodyPart:$sEnvironment" in
  head:normal)
     iEquipmentID=$(check_CowEquipmentAvailability "17 1")
     ;;
  head:rain)
     iEquipmentID=$(check_CowEquipmentAvailability "2 16")
     ;;
  head:cold)
     iEquipmentID=$(check_CowEquipmentAvailability "4 16")
     ;;
  head:heat)
     iEquipmentID=$(check_CowEquipmentAvailability "17 5")
     ;;
  head:mud)
     iEquipmentID=$(check_CowEquipmentAvailability "17 3")
     ;;
  body:normal)
     iEquipmentID=$(check_CowEquipmentAvailability "21 11")
     ;;
  body:rain)
     iEquipmentID=$(check_CowEquipmentAvailability "14 20")
     ;;
  body:cold)
     iEquipmentID=$(check_CowEquipmentAvailability "21 13")
     ;;
  body:heat)
     iEquipmentID=$(check_CowEquipmentAvailability "12 20")
     ;;
  body:mud)
     iEquipmentID=$(check_CowEquipmentAvailability "21 15")
     ;;
  foot:normal)
     iEquipmentID=$(check_CowEquipmentAvailability "19 6")
     ;;
  foot:rain)
     iEquipmentID=$(check_CowEquipmentAvailability "19 9")
     ;;
  foot:cold)
     iEquipmentID=$(check_CowEquipmentAvailability "10 18")
     ;;
  foot:heat)
     iEquipmentID=$(check_CowEquipmentAvailability "19 8")
     ;;
  foot:mud)
     iEquipmentID=$(check_CowEquipmentAvailability "7 18")
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
  iKey=$($JQBIN -r '[.updateblock.farmersmarket.cowracing.data.items | .[] | select(.type == "'${iItem}'" and .stock == "1").id][0]' $FARMDATAFILE)
  if [ "$iKey" != "null" ]; then
   echo $iKey
   return
  fi
 done
 # nothing suitable in stock, let's try and buy something that fits
 iKey=$(get_CowEquipment "$iSearchPattern")
 echo $iKey
}

function get_CowEquipment {
 local iSearchPattern="$1"
 local iItem
 local iKey
 local bIsMoneyItem
 for iItem in $iSearchPattern; do
  bIsMoneyItem=$($JQBIN '.updateblock.farmersmarket.cowracing.config.items["'${iItem}'"].money? | type == "number"' $FARMDATAFILE)
  if [ "$bIsMoneyItem" = "true" ]; then
   echo "Buying cow equipment #${iItem}..." >&2
   SendAJAXFarmRequestOverwrite "id=${iItem}&slot=1&mode=cowracing_buyitem" && sleep 1
   # nicer would be to use the correct slot no.
   iKey=$($JQBIN '[.updateblock.farmersmarket.cowracing.data.items | .[] | select(.type == "'${iItem}'")][0]?.id | tonumber' $FARMDATAFILE)
   # at this point it should be safe to use this construct. but just to be even safer... ;)
   if [ "$iKey" != "null" ] && [ -n "$iKey" ]; then
    echo $iKey
    return
#   else
#    echo "DEBUG: cow equipment was bought, but iKey could not be read!" >&2
#    echo "DEBUG: iKey value is $iKey" >&2
#    echo "DEBUG: saving FARMDATAFILE for later analysis" >&2
#    cp $FARMDATAFILE ${FARMDATAFILE}.debug
   fi
  fi
 done
 echo "-1"
}

function check_CowRanked1st {
 # returns true if a cow is ranked 1st
 local iSlot=$1
 local bCowIsRanked1st=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].ladder.rank == 1' $FARMDATAFILE)
 if [ "$bCowIsRanked1st" = "true" ]; then
  return 0
 fi
 return 1
}

function check_CowIsPvP {
 # returns true if a cow has signed up for a PvP race
 local iSlot=$1
 local bCowIsPvP=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].ispvp == "1"' $FARMDATAFILE)
 if [ "$bCowIsPvP" = "true" ]; then
  return 0
 fi
 return 1
}

function check_CowSuspended {
 # returns true if a cow has been suspended from PvP racing
 local iSlot=$1
 local bCowSuspended=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].suspendpvp == "1"' $FARMDATAFILE)
 if [ "$bCowSuspended" = "true" ]; then
  return 0
 fi
 return 1
}

function harvest_MegaField {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iHarvestDevice=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 local iPlot
 local aPlots
 local iVehicleBought=0
 # check for 2x2 harvest device
 case "$iHarvestDevice" in
  5|7|9|10)
     harvest_MegaField2x2 ${iFarm} ${iPosition} ${iSlot} ${iHarvestDevice}
     update_queue ${iFarm} ${iPosition} ${iSlot}
     iHarvestDevice=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
     case "$iHarvestDevice" in
      5|7|9|10)
         echo "You need a 1x1 device after the 2x2 one - cannot continue"
         return
         ;;
     esac
     ;;
 esac
 iHarvestDelay=$(get_MegaFieldHarvesterDelay $iHarvestDevice)
 if [ $iHarvestDelay -eq 0 ]; then
  echo "Stopping work on Mega Field!"
  return
 fi
 aPlots=$($JQBIN '.updateblock.megafield.area | tostream | select(length == 2)  as [$key,$value] | if $key[-1] == "remain" and $value < 0 then ($key[-2] | tonumber) else empty end' $FARMDATAFILE)
 for iPlot in $aPlots; do
  iVehicleBought=$(check_MegaFieldEmptyHarvestDevice $iHarvestDevice $iVehicleBought)
  echo -n "Harvesting Mega Field plot ${iPlot}..."
  SendAJAXFarmRequestOverwrite "mode=megafield_tour&farm=1&position=1&set=${iPlot},|&vid=${iHarvestDevice}"
  echo "delaying ${iHarvestDelay} seconds"
  sleep ${iHarvestDelay}s
  # plant instantly
  start_MegaField${NONPREMIUM}
 done
 if check_RipePlotOnMegaField; then
  harvest_MegaField ${FARM} ${POSITION} 0
 fi
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
  iFreePlots=$(get_MegaFieldFreePlotsCount)
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
   iSafetyCount=$((iSafetyCount + 1))
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
 local iPointsNeededToStart=$((iSlotLevel * 1000000))
 # amount needs to be calculated using "round to nearest"
 # changed to "round up" 08.11.2015 (old foobar/2, new foobar-1)
 local iAmount=$(((iPointsNeededToStart + (iPointsPerGood - 1)) / iPointsPerGood))
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
 local iAnimalID
 GetInnerInfoData $TMPFILE $iFarm $iPosition innerinfos
 local aAnimalIDs=$($JQBIN '.datablock[1].farmis | .[] | select(.data.remain < 0 and .data.remain != null).data.animalid' $TMPFILE)
 for iAnimalID in $aAnimalIDs; do
  iSlot=$($JQBIN '.datablock[1].ponys | .[] | select(.animalid == "'$iAnimalID'").data.position' $TMPFILE)
  SendAJAXFarmRequest "mode=pony_crop&farm=${iFarm}&position=${iPosition}&id=${iSlot}"
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
  sBlocked=$($JQBIN '.datablock[1].ponys["'${iSlot}'"] | select(.block == null and .data.farmi == null).data.position' $TMPFILE)
  if [ -n "$sBlocked" ]; then
   # slot is unblocked and idle...
   iPony=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].animalid | tonumber' $TMPFILE)
   # refill food dispenser
   iFood=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].data.feed' $TMPFILE)
   iFood=$((iMaxFood - iFood))
   SendAJAXFarmRequest "mode=pony_feed&farm=${iFarm}&position=${iPosition}&id=${iSlot}&pos=${iSlot}&amount=${iFood}"
   # find a farmie
   if [ $iSlot -ge 2 ]; then
    update_queue ${iFarm} ${iPosition} 0
    if check_QueueSleep ${iFarm}/${iPosition}/0; then
     echo "Set to sleep"
     return
    fi
   fi
   iDuration=$(sed '2q;d' ${iFarm}/${iPosition}/0)
   iFarmie=$($JQBIN '.datablock[1].farmis | .[] | select(.status == "0" and .type == "'$iDuration'").id | tonumber' $TMPFILE)
   if [ -z "$iFarmie" ]; then
    # something went wrong. bail out.
    return
   fi
   SendAJAXFarmRequest "mode=pony_setfarmi&farm=${iFarm}&position=${iPosition}&farmi=${iFarmie}&pony=${iPony}"
   # check for pony energy bar...
   if grep -q "useponyenergybar = 1" $CFGFILE; then
    iEnergyBarCount=$((iDuration / 2))
    sleep 2
    SendAJAXFarmRequest "mode=pony_speedup&farm=${iFarm}&position=${iPosition}&id=${iSlot}&pos=${iSlot}&amount=${iEnergyBarCount}"
   fi
  fi
 done
}

function start_Butterflies {
 local iSlot=$1
 SendAJAXFarmRequest "slot=${iSlot}&mode=butterfly_carebreed"
}

function check_Farmies {
 local sFarmieType=$1
 local aFarmies
 local iID
 case "$sFarmieType" in
  farmie)
     aFarmies=$($JQBIN '.updateblock.farmis[0] | .[] | .id | tonumber' $FARMDATAFILE)
     for iID in $aFarmies; do
      echo "Sending farmie with ID ${iID} away..."
      SendAJAXFarmRequest "mode=sellfarmi&farm=1&position=1&id=${iID}&farmi=${iID}&status=2"
     done
     ;;
  flowerfarmie)
     aFarmies=$($JQBIN '.updateblock.farmersmarket.farmis | .[] | .id | tonumber' $FARMDATAFILE)
     for iID in $aFarmies; do
      echo "Sending flower farmie with ID ${iID} away..."
      SendAJAXFarmRequest "mode=handleflowerfarmi&farm=1&position=1&id=${iID}&farmi=${iID}&status=2"
     done
     ;;
  forestryfarmie)
     aFarmies=$($JQBIN '.datablock[5] | .[] | .farmiid | tonumber' $FARMDATAFILE)
     for iID in $aFarmies; do
      echo "Sending forestry farmie with ID ${iID} away..."
      SendAJAXForestryRequest "action=kickfarmi&productid=${iID}"
     done
     ;;
  munchie)
     aFarmies=$($JQBIN '.datablock.farmis | .[] | .id | tonumber' $FARMDATAFILE)
     for iID in $aFarmies; do
      echo "Sending munchie with ID ${iID} away..."
      SendAJAXFoodworldRequest "action=kick&id=${iID}&table=0&chair=0"
     done
     ;;
 esac
}

function check_VehiclePosition {
 local iFarm=$1
 local iRoute=$2
 local iVehicle
 local iCurrentVehiclePos
 echo -n "Transport vehicle for route $iRoute is "
 iVehicle=$(get_ConfigValue vehiclemgmt${iFarm})
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
 local iPID
 local iPIDCount
 local iSafetyCount
 local iCropValue
 local sCart=
 local iTransportCount=0
 local iVehicleSlotsUsed=0
 local iPIDMin
 local iPIDMax
 local aPIDs
 local iFilledFieldCount
 local iVehicleCapacity=$($JQBIN '.updateblock["map"]["config"]["vehicles"]["'${iVehicle}'"]["capacity"]' $FARMDATAFILE)
 local iVehicleSlotCount=$($JQBIN '.updateblock["map"]["config"]["vehicles"]["'${iVehicle}'"]["products"]' $FARMDATAFILE)
 local iFieldsOnFarmCount=$(get_FieldsOnFarmCount $iFarm)
 local aPositions=$($JQBIN '.updateblock.farms.farms["'${iFarm}'"] | .[] | select(.buildingid == "1" and .status == "1").position | tonumber' $FARMDATAFILE)
 echo -n "Calculating transport count for route ${iRoute}..."
 case $iFarm in
  5) iPIDMin=351
     iPIDMax=361
     ;;
  6) iPIDMin=700
     iPIDMax=709
     ;;
  7) echo -e "\nAuto transport off farm 7 is not supported"
     #iPIDMin=1
     #iPIDMax=128
     return
     ;;
 esac
 aPIDs=$($JQBIN '.updateblock.stock.stock["'${iFarm}'"] | .[] | .[] | select((.pid | tonumber) >= '${iPIDMin}' and (.pid | tonumber) <= '${iPIDMax}').pid | tonumber' $FARMDATAFILE)
 for iPID in $aPIDs; do
  echo -n "."
  iPIDCount=$($JQBIN '.updateblock.stock.stock["'${iFarm}'"] | .[] | .[] | select(.pid == "'${iPID}'").amount | tonumber' $FARMDATAFILE)
  iSafetyCount=$(get_ProductCountFittingOnField $iPID)
  # do we have multiple fields on the current farm?
  # are they filled with crop we want to transport off?
  iFilledFieldCount=$(get_FilledFieldCount $iFarm $iPID "$aPositions")
  iSafetyCount=$((iSafetyCount * (iFieldsOnFarmCount - iFilledFieldCount)))
  if [ $iSafetyCount -lt 5 ]; then
   iSafetyCount=5
  fi
  iPIDCount=$((iPIDCount - iSafetyCount))
  if [ $iPIDCount -le 0 ]; then
   continue
  fi
  iTransportCount=$((iTransportCount + iPIDCount))
  if [ $iTransportCount -ge $iVehicleCapacity ]; then
   iCropValue=$((iTransportCount - iVehicleCapacity))
   iPIDCount=$((iPIDCount - iCropValue))
   iVehicleSlotsUsed=$((iVehicleSlotsUsed + 1))
   sCart=${sCart}${iVehicleSlotsUsed},${iPID},${iPIDCount}_
   echo -e "\nSending $((iTransportCount - iCropValue)) items to main farm..."
   SendAJAXFarmRequest "mode=map_sendvehicle&farm=${iFarm}&position=1&route=${iRoute}&vehicle=${iVehicle}&cart=${sCart}"
   return
  fi
  iVehicleSlotsUsed=$((iVehicleSlotsUsed + 1))
  sCart=${sCart}${iVehicleSlotsUsed},${iPID},${iPIDCount}_
  if [ $iVehicleSlotsUsed -eq $iVehicleSlotCount ]; then
   echo -e "\nSending partially loaded vehicle to main farm (no slots left)..."
   SendAJAXFarmRequest "mode=map_sendvehicle&farm=${iFarm}&position=1&route=${iRoute}&vehicle=${iVehicle}&cart=${sCart}"
   return
  fi
 done
 if [ $iTransportCount -lt 0 ]; then
  iTransportCount=0
 fi
 if ! check_QueueSleep city2/trans2${iFarm}/0; then
  echo -e "\nSending vehicle back empty (Queue is still busy)..."
  SendAJAXFarmRequest "mode=map_sendvehicle&farm=${iFarm}&position=1&route=${iRoute}&vehicle=${iVehicle}&cart="
 else
  echo -e "\n$iTransportCount/$iVehicleCapacity items available for transport on route ${iRoute}, no transport started"
 fi
}

function get_ProductCountFittingOnField {
 local iPID=$1
 local iPIDDim_x=$(echo $aDIM_X | $JQBIN '."'${iPID}'" | tonumber')
 local iPIDDim_y=$(echo $aDIM_Y | $JQBIN '."'${iPID}'" | tonumber')
 echo $((120 / (iPIDDim_x * iPIDDim_y)))
}

function get_FieldsOnFarmCount {
 local iFarm=$1
 local iFieldsOnFarm=$($JQBIN '.updateblock.farms.farms["'${iFarm}'"] | .[] | select(.buildingid == "1" and .status == "1").position' $FARMDATAFILE | wc -l)
 echo $iFieldsOnFarm
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
 local sOldIFS=$IFS
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
  IFS=$sOldIFS
  iProduct=$1
  iProductCount=$2
  iTransportCount=$((iTransportCount + iProductCount))
  if [ $iTransportCount -gt $iVehicleCapacity ]; then
   echo "Transport to farm ${iFarm} stopped due to vehicle overload"
   return
  fi
  iVehicleSlotsUsed=$((iVehicleSlotsUsed + 1))
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
  for iCount in $(seq 0 $((iActivePowerUps - 1))); do
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
 local iTool=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
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
 local bHasRipePlots=$($JQBIN '[.datablock[1] | .[] | select(.phase? == 4 and (.buildingid == "v" or .buildingid == "ex" or .buildingid == "alpin"))][0] | type == "object"' $TMPFILE)
 if [ "$bHasRipePlots" = "true" ]; then
  return 0
 fi
 return 1
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
 local bHasNegatives=$($JQBIN '[.updateblock.megafield.area | .[] | select(.remain < 0)][0] | type == "object"' $FARMDATAFILE)
 if [ "$bHasNegatives" = "true" ]; then
  return 0
 fi
 return 1
}

function get_UnlockedMegaFieldPlotCount {
 local iUnlockedPlots=$($JQBIN '.updateblock.megafield.area_free | length' $FARMDATAFILE)
 # we always have a positive number here
 echo $iUnlockedPlots
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
 local bDurability=$($JQBIN '.updateblock.megafield.vehicles["'${iHarvestDevice}'"]?.durability | type == "number"' $FARMDATAFILE)
 # if no vehicle is available, the query returns an empty array which can't be indexed
 # hence the -z test. don't remove it :)
 if [ "$bDurability" = "false" ] || [ -z "$bDurability" ]; then
  if [ $iVehicleBought -eq 0 ]; then
   # buy a brand new one if empty
   echo "Buying new vehicle #${iHarvestDevice}..." >&2
   SendAJAXFarmRequest "mode=megafield_vehicle_buy&farm=1&position=1&id=${iHarvestDevice}&vid=${iHarvestDevice}"
   echo 1
   return
  else
   # sending to STDERR - otherwise the text would be part of the return value
   echo "Not buying new vehicle since it's already been bought this iteration!" >&2
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
 local iPIDOnBusyPlots
 local iProductSlot=$1
 local iNeededPID=$($JQBIN '.updateblock.megafield.job.products['$iProductSlot'].need' $FARMDATAFILE)
 local iHavePID=$($JQBIN '.updateblock.megafield.job.products['$iProductSlot'].have' $FARMDATAFILE)
 local iPID=$($JQBIN '.updateblock.megafield.job.products['$iProductSlot'].pid' $FARMDATAFILE)
 local iSeeminglyNeeded=$((iNeededPID - iHavePID))
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
 iPIDOnBusyPlots=$($JQBIN '.updateblock.megafield.area | .[] | select(.pid == '$iPID').pid' $FARMDATAFILE | wc -l)
 echo $((iSeeminglyNeeded - iPIDOnBusyPlots))
 # in theory, this amount can't be less than zero
}

function get_MegaFieldFreePlotsCount {
 local iTotalPlots=$($JQBIN '.updateblock.megafield.area_free | length' $FARMDATAFILE)
 local iBusyPlots=$($JQBIN '.updateblock.megafield.area | length' $FARMDATAFILE)
 echo $((iTotalPlots - iBusyPlots))
}

function MegaFieldPlantNP {
 local iPID=$1
 local iFreePlots=$2
 local iCount=1
 local iCount2=0
 local bPlotOccupied
 local iUnlockedPlotsCount=$(get_UnlockedMegaFieldPlotCount)
 while [ "$iCount" -le "$iFreePlots" ]; do
   while [ "$iCount2" -lt "$iUnlockedPlotsCount" ]; do
    sUnlockedPlotName=$($JQBIN '.updateblock.megafield.area_free | keys['$iCount2'] | tonumber' $FARMDATAFILE)
    bPlotOccupied=$($JQBIN '.updateblock.megafield.area["'$sUnlockedPlotName'"]? | type == "object"' $FARMDATAFILE)
    # if all the plots are free, the query returns an empty array which can't be indexed
    # hence the -z test. don't remove it ;)
    if [ "$bPlotOccupied" = "false" ] || [ -z "$bPlotOccupied" ]; then
     # plot is free, plant stuff on it
     echo "Planting item ${iPID} on Mega Field plot ${sUnlockedPlotName}..."
     SendAJAXFarmRequestOverwrite "mode=megafield_plant&farm=1&position=1&set=${sUnlockedPlotName}_${iPID}|"
     iCount2=$((iCount2 + 1))
     break
    fi
    iCount2=$((iCount2 + 1))
   done
  iCount=$((iCount + 1))
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
 if [ $iHarvestDelay -eq 0 ]; then
  echo "Stopping work on Mega Field!"
  return
 fi
 while (true); do
  if [ $iPlot -gt 87 ]; then
   return
  fi
  iVehicleBought=$(check_MegaFieldEmptyHarvestDevice $iHarvestDevice $iVehicleBought)
  if ! ((iPlot % 11)); then
   iPlot=$((iPlot + 1))
   # prevent harvesting of last column
  fi
  if check_TimeRemaining '.updateblock.megafield.area["'$iPlot'"]?.remain'; then
   if check_TimeRemaining '.updateblock.megafield.area["'$((iPlot + 1))'"]?.remain'; then
    if check_TimeRemaining '.updateblock.megafield.area["'$((iPlot + 11))'"]?.remain'; then
     if check_TimeRemaining '.updateblock.megafield.area["'$((iPlot + 12))'"]?.remain'; then
      echo -n "Harvesting Mega Field plots ${iPlot}, $((iPlot + 1)), $((iPlot + 11)), $((iPlot + 12))..."
      SendAJAXFarmRequestOverwrite "mode=megafield_tour&farm=1&position=1&set=${iPlot},$((iPlot + 1)),$((iPlot + 11)),$((iPlot + 12)),|&vid=${iHarvestDevice}"
      echo "delaying ${iHarvestDelay} seconds"
      sleep ${iHarvestDelay}s
      # plant instantly
      start_MegaField${NONPREMIUM}
      iPlot=$((iPlot + 2))
      continue
     else
      iPlot=$((iPlot + 1))
      continue
     fi
    else
     iPlot=$((iPlot + 1))
     continue
    fi
   else
    iPlot=$((iPlot + 2))
    continue
   fi
  fi
 iPlot=$((iPlot + 1))
 done
}

function get_AnimalQueueLength {
 local iAnimalQueueLength=$($JQBIN '.updateblock.farmersmarket.vet.animals.queue | length' $FARMDATAFILE)
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
 local sResult=$($JQBIN '.datablock[1] | .[] | select(.teil_nr? == "'$iPlot'") | type == "object"' $TMPFILE)
 if [ -z "$sResult" ]; then
  return 0
 else
  return 1
 fi
}

function get_FilledFieldCount {
 # returns the number of fields completely filled with a certain product
 local iFarm=$1
 local iPID=$2
 local aPositions="$3"
 local iPosition
 local iPIDCount
 local iFilledFields=0
 local sTmpFile
 for iPosition in $aPositions; do
  sTmpFile="${TMPFILE}-${iFarm}-${iPosition}"
  if ! [ -f "$sTmpFile" ]; then
   GetInnerInfoData "$sTmpFile" $iFarm $iPosition gardeninit
  fi
  iPIDCount=$($JQBIN '.datablock[1] | map([select(.teil_nr? and .inhalt == "'${iPID}'")]) | [.[] | select(length > 0)] | length' "$sTmpFile")
  if [ $iPIDCount -eq 120 ]; then
   iFilledFields=$((iFilledFields + 1))
  fi
 done
 echo $iFilledFields
}

function check_QueueCount {
 local iFarm=$1
 local iPosition=$2
 local iBuildingID=$3
 local iQueuesInFS=$(get_QueueCountInFS $iFarm $iPosition)
 local iMaxQueueCount=$(get_MaxQueuesForBuildingID $iBuildingID)
 local iQueuesInGame
 if [ $iQueuesInFS -gt $iMaxQueueCount ]; then
  echo "Reducing position $iPosition to $iMaxQueueCount Queue(s)..."
  reduce_QueuesOnPosition $iFarm $iPosition $iMaxQueueCount
  iQueuesInFS=$(get_QueueCountInFS $iFarm $iPosition)
 fi
 # queues are capped to the max. possible value
 # from here we'll handle multi-q buildings
 case "$iBuildingID" in
  13|14|16|21) iQueuesInGame=$(get_QueueCountFromInnerInfo $iFarm $iPosition)
      ;;
  20) iQueuesInGame=$(get_QueueCount20 $iFarm $iPosition)
      ;;
   *) iQueuesInGame=1
      ;;
 esac
 if [ "$iQueuesInFS" -lt "$iQueuesInGame" ]; then
  echo "Adding $((iQueuesInGame - iQueuesInFS)) Queue(s) to position $iPosition..."
  add_QueuesToPosition $iFarm $iPosition $iQueuesInFS $iQueuesInGame
 fi
 if [ "$iQueuesInFS" -gt "$iQueuesInGame" ]; then
  echo "Reducing position $iPosition to $iQueuesInGame Queue(s)..."
  reduce_QueuesOnPosition $iFarm $iPosition $iQueuesInGame
 fi
}

function get_QueueCountInFS {
 local iFarm=$1
 local iPosition=$2
 local iQueueCount
 iQueueCount=$(ls -ld ${iFarm}/${iPosition}/* | wc -l)
 echo $iQueueCount
}

function get_MaxQueuesForBuildingID {
 local iBuildingID=$1
 case "$iBuildingID" in
  13|14|16|20|21)
     echo 3
     ;;
  *)
     echo 1
     ;;
 esac
}

function reduce_QueuesOnPosition {
 local iFarm=$1
 local iPosition=$2
 local iMaxQ=$3
 local iQueueCount=$(ls -ld ${iFarm}/${iPosition}/* | wc -l)
 local iQDel=$((iQueueCount - iMaxQ))
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
   iSlots=$((iSlots + 1))
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
   iSlots=$((iSlots + 1))
  fi
 done
 echo $iSlots
}

function add_QueuesToPosition {
 local iFarm=$1
 local iPosition=$2
 local iQueuesInFS=$3
 local iQueuesInGame=$4
 local iQueuesToAdd=$((iQueuesInGame - iQueuesInFS))
 # we'll assume queue '0' already exists
 if [ $iQueuesToAdd -eq 2 ] || ([ $iQueuesInFS -eq 2 ] && [ $iQueuesToAdd -eq 1 ]); then
  echo -e "sleep\nsleep" > ${iFarm}/${iPosition}/2
 fi
 if [ $iQueuesInFS -eq 1 ]; then
  echo -e "sleep\nsleep" > ${iFarm}/${iPosition}/1
 fi
}

function redeemPuzzlePartsPacks {
 local iPackCount
 local iCount
 local iCount2
 local iType
 iPackCount=$($JQBIN '.updateblock.farmersmarket.pets.packs | length' $FARMDATAFILE)
 if [ $iPackCount -gt 0 ]; then
  for iCount in $(seq 0 $((iPackCount - 1))); do
   iType=$($JQBIN '.updateblock.farmersmarket.pets.packs | keys['$iCount'] | tonumber' $FARMDATAFILE)
   iPackCount=$($JQBIN '.updateblock.farmersmarket.pets.packs["'$iType'"] | tonumber' $FARMDATAFILE)
   echo "Redeeming $iPackCount puzzle parts pack(s) of type ${iType}..."
   for iCount2 in $(seq 1 $iPackCount); do
    SendAJAXFarmRequest "mode=pets_open_pack&type=${iType}"
   done
  done
 fi
}

function check_PanBonus {
 # function by jbond47, update by maiblume & jbond47
 GetPanData "$FARMDATAFILE"
 local iToday=$($JQBIN '.datablock[11].today' $FARMDATAFILE)
 local iSheepCount=$($JQBIN '.datablock[11].collections.heros | length' $FARMDATAFILE)
 local iLastBonus
 local bValue
 # Hero Sheep Bonus
 if [ $iSheepCount -eq 12 ]; then # requires all 12 super sheep
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
 iSheepCount=$($JQBIN '.datablock[11].collections.horror | length' $FARMDATAFILE)
 if [ $iSheepCount -eq 9 ]; then # requires all 9 horror sheep
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
 iSheepCount=$($JQBIN '.datablock[11].collections.sport | length' $FARMDATAFILE)
 if [ $iSheepCount -eq 9 ]; then # requires all 9 sport sheep
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
 iSheepCount=$($JQBIN '.datablock[11].collections.beach | length' $FARMDATAFILE)
 if [ $iSheepCount -eq 9 ]; then # requires all 9 beach sheep
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
 iSheepCount=$($JQBIN '.datablock[11].collections.fantasy | length' $FARMDATAFILE)
 if [ $iSheepCount -eq 9 ]; then # requires all 9 fantasy sheep
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
 local aKeys
 local iKey
 aKeys=$($JQBIN '.updateblock.farmersmarket.butterfly.data.free | tostream | select(length == 2) as [$key,$value] | if $key[-1] == "last" and ($value < '$iToday' or $value == null) then ($key[-2] | tonumber) else empty end' $FARMDATAFILE)
 if [ -n "$aKeys" ]; then
  if [ "$NONPREMIUM" != "NP" ]; then
   # premium
   echo "Collecting butterfly points bonus..."
   SendAJAXFarmRequest "mode=butterfly_click_all"
   return
  else
   # non-premium
   for iKey in $aKeys; do
    echo "Collecting points bonus from butterfly type ${iKey}..."
    SendAJAXFarmRequest "id=${iKey}&mode=butterfly_click"
   done
  fi
 fi
}

function check_DogBonus {
 local bDogExists=$($JQBIN '.updateblock.menue.farmdog == 1' $FARMDATAFILE)
 local bDogDone=$($JQBIN '.updateblock.menue.farmdog_harvest == 1' $FARMDATAFILE)
 if [ "$bDogExists" = "true" ] && [ "$bDogDone" = "false" ]; then
  echo "not yet claimed, activating it..."
  SendAJAXFarmRequest "mode=dogbonus&farm=1&position=0"
  # reduce pause time by 300 secs after claiming the dogs' time bonus
  PAUSETIME=$((PAUSETIME - 300))
 else
  echo "already claimed"
 fi
}

function check_DonkeyBonus {
 local bDonkeyExists=$($JQBIN '.updateblock.menue.donkey == 1' $FARMDATAFILE)
 if [ "$bDonkeyExists" = "true" ]; then
  echo -n "Checking if it's time for the daily donkey bonus..."
  if [ $SECONDS -gt 86400 ] || [ $DONKEYCLAIMED -eq 0 ]; then
   echo "it is, claiming it..."
   SendAJAXFarmRequest "mode=dailydonkey&farm=1&position=1"
   SECONDS=0
   DONKEYCLAIMED=1
  else
   echo "it's not"
  fi
 fi
}

function check_PuzzleParts {
 local bPartsAvailable=$($JQBIN '.updateblock.farmersmarket.pets.daily == 1' $FARMDATAFILE)
 if [ "$bPartsAvailable" = "true" ]; then
  echo "available, buying it..."
  SendAJAXFarmRequest "mode=pets_buy_parts&id=1&amount=1"
 else
  echo "already bought"
 fi
}

function check_Lottery {
 GetLotteryData $FARMDATAFILE
 local iLot
 local bLotstatus=$($JQBIN '.datablock[2] == 0' $FARMDATAFILE)
 if [ "$bLotstatus" = "true" ]; then
  iLot=$(get_ConfigValue dolot)
  echo -n "not yet claimed, getting it"
  SendAJAXCityRequest "city=2&mode=newlot"
  if [ $iLot -eq 2 ]; then
   echo " and trading it for an instant-win..."
   sleep 1
   SendAJAXCityRequest "city=2&mode=lotgetprize"
  else
   echo "..."
  fi
 else
  echo "already claimed"
 fi
}

function check_DeliveryEvent {
 local iPointsNeeded
 local iPointsAvailable
 local bDeliveryEventRunning=$($JQBIN '.updateblock.menue.deliveryevent != 0' $FARMDATAFILE)
 if [ "$bDeliveryEventRunning" = "false" ]; then
  return
 fi
 iPointsNeeded=$($JQBIN '.updateblock.menue.deliveryevent.config.spots | .[] | select(.points <= 250).points' $FARMDATAFILE)
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

function check_CalendarEvent {
 local iDay
 local iEventDaysCount
 local bPresentCollected
 GetCalendarData $TMPFILE
 iDay=$($JQBIN '.datablock.day?' $TMPFILE)
 if ! [ $iDay -gt 0 ] 2>/dev/null; then
  # no valid value for the current event day no.
  return
 fi
 iEventDaysCount=$($JQBIN '.datablock.config.fields | length' $TMPFILE)
 if [ $iDay -gt $iEventDaysCount ]; then
  echo "Event period is over, deactivating feature..."
  sed -i 's/docalendarevent = 1/docalendarevent = 0/' $CFGFILE
  return
 fi
 bPresentCollected=$($JQBIN '.datablock.data.days["'${iDay}'"]? | type == "object"' $TMPFILE)
 if [ "$bPresentCollected" = "true" ]; then
  echo "already collected"
  return
 fi
 echo "not yet claimed, opening door no. ${iDay}..."
 SendAJAXFarmRequest "field=${iDay}&mode=calendar_openfield"
}

function check_LoginBonus {
 local iLoginCount=$($JQBIN '.updateblock.menue.loginbonus.data.count?' $FARMDATAFILE)
 local bLoginBonusDone=$($JQBIN '.updateblock.menue.loginbonus.data.rewards["'$iLoginCount'"].done > 0' $FARMDATAFILE)
 local bLoginBonusActive=$($JQBIN '.updateblock.menue.loginbonus.data.bonus.remain > 0' $FARMDATAFILE)
 local iPID
 if [ "$bLoginBonusDone" = "false" ]; then
  if [ $iLoginCount -eq 7 ] && [ "$bLoginBonusActive" = "false" ]; then
   iPID=$(get_ConfigValue dologinbonus)
   echo "not yet claimed, activating points bonus for plant #${iPID}..."
   SendAJAXFarmRequest "pid=${iPID}&mode=loginbonus_setplant"
  else
   if [ $iLoginCount -le 6 ]; then
    echo "not yet claimed, getting it for day ${iLoginCount}..."
    SendAJAXFarmRequest "day=${iLoginCount}&mode=loginbonus_getreward"
   else
    echo "not claiming it yet since points bonus is still active"
   fi
  fi
 else
  echo "already claimed"
 fi
}

function check_FruitStall {
 local iSlot=$1
 local iPID=$(get_ConfigValue fruitstallslot${iSlot})
 local iLevel
 local iAmount
 local iCurrentEpoch
 # rumours say the regular fruit stall farmie interval is 1800 secs ;)
 local iFarmieInterval=1800
# local bDelayBooster=$($JQBIN '.updateblock.map.stall.data["1"].booster.delay.remain? | type == "number"' $FARMDATAFILE)
# if [ "$bDelayBooster" = "true" ];then
#  iFarmieInterval=900
# fi
 local iLastFarmieEpoch
 local iNextFarmieEpoch
 local iSecsToNextFarmie
 local sSlotType=$($JQBIN -r '.updateblock.map.stall.data | type' $FARMDATAFILE 2>/dev/null)
 if [ "$sSlotType" = "object" ]; then
  # ANY reward ready for pickup?
  local sSlotType=$($JQBIN -r '.updateblock.map.stall.data["1"].reward | type' $FARMDATAFILE 2>/dev/null)
  if [ "$sSlotType" = "object" ]; then
   echo "Collecting fruit stall reward..."
   SendAJAXFarmRequestOverwrite "position=1&mode=stall_get_reward" && sleep 1
  fi
  sSlotType=$($JQBIN -r '.updateblock.map.stall.data["1"].slots["'${iSlot}'"].amount? | type' $FARMDATAFILE 2>/dev/null)
  if [ "$sSlotType" != "number" ]; then
   # refill slot
   iLevel=$($JQBIN '.updateblock.map.stall.data["1"].level' $FARMDATAFILE)
   iAmount=$($JQBIN '.updateblock.map.stall.config.level["'${iLevel}'"].fillsum' $FARMDATAFILE)
   echo "Posting ${iAmount} items to fruit stall slot ${iSlot}..."
   SendAJAXFarmRequest "position=1&slot=${iSlot}&pid=${iPID}&amount=${iAmount}&mode=stall_fill_slot"
  fi
  # boosters are not taken into account - or are they? ;)
  iLastFarmieEpoch=$($JQBIN -r '.updateblock.map.stall.data["1"].farmi_last' $FARMDATAFILE)
  iNextFarmieEpoch=$((iLastFarmieEpoch + iFarmieInterval))
  iCurrentEpoch=$(date +"%s")
  iSecsToNextFarmie=$((iNextFarmieEpoch - iCurrentEpoch))
  if [ $iSecsToNextFarmie -gt 0 ] 2>/dev/null && [ $iSecsToNextFarmie -lt $PAUSETIME ] 2>/dev/null; then
   PAUSETIME=$iSecsToNextFarmie
   PAUSECORRECTEDAT=$(date +"%s")
  fi
 fi
}

function check_ActiveGuildJobForPlayer {
 local iActiveGuildJob=$($JQBIN '.updateblock.job.guild_job_data | length' $FARMDATAFILE)
 if [ $iActiveGuildJob -gt 0 ]; then
  # guild job is running and player is taking part
  return 0
 fi
 return 1
}

function check_LoginNews {
 # checks for news to be displayed upon login
 # marks it/them as read
 # this prevents news popups in running browser sessions
 local iNews
 local aNews=$($JQBIN -r '.updateblock.menue.news? | .[]? | select(.login == "1").nnr' $FARMDATAFILE)
 # you've guessed it: globbing is needed here :)
 for iNews in $aNews; do
  # echo "Marking news #${iNews} as read..."
  SendAJAXMainRequest "nnr=${iNews}&opt1=1&action=setnewsunread"
 done
}

function check_TimeRemaining {
 # returns true if a zero or negative timer is found
 # and sets new PAUSETIME if applicable
 local sFilter="$1"
 sFilter="$sFilter | if . == 0 then 0 elif (. | length) > 0 and . < 0 then 0 elif (. | length) > 0 and . < $PAUSETIME then . else empty end"
 # this expression returns 0 if a zero / negative value or the value itself if it's between 0 and $PAUSETIME
 # in all other cases, there's no return value
 local iRemaining=$($JQBIN "$sFilter" $FARMDATAFILE)
 if [ -z "$iRemaining" ]; then
  return 1
 fi
 if [ $iRemaining -eq 0 ]; then
  return 0
 fi
 PAUSETIME=$iRemaining
 PAUSECORRECTEDAT=$(date +"%s")
 return 1
}

function get_ConfigValue {
 local sConfigItem=$1
 local sConfigLine=$(grep $sConfigItem $CFGFILE)
 local sTokens=( $sConfigLine )
 echo ${sTokens[2]}
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
