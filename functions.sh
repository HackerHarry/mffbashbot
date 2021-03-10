# Functions file for My Free Farm Bash Bot
# Copyright 2016-21 Harun "Harry" Basalamah
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

function getFarmData {
 local sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXFARM}mode=getfarms&farm=1&position=0"
}

function getForestryData {
 local sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXFOREST}action=initforestry"
}

function getFoodWorldData {
 local sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXFOOD}action=foodworld_init&id=0&table=0&chair=0"
}

function getLotteryData {
 sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXCITY}city=2&mode=initlottery"
}

function getWindMillData {
 local sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXCITY}city=2&mode=windmillinit"
}

function getPanData {
 local sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXFARM}mode=showpan&farm=1&position=0"
}

function getInnerInfoData {
 local sFile=$1
 local iFarm=$2
 local iPosition=$3
 local sMode=$4
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXFARM}mode=${sMode}&farm=${iFarm}&position=${iPosition}"
}

function getOlympiaData {
 sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXMAIN}action=olympia_init"
}

function getCalendarData {
 sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXFARM}mode=calendar_init"
}

function getMerchantData {
 local sFile=$1
 wget -nv -T10 -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "${AJAXCITY}shopid=1&mode=shopinit"
}

function doFarm {
 # read function from queue file
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 if checkQueueSleep ${iFarm}/${iPosition}/${iSlot}; then
  echo "Set to sleep"
  return
 fi
 local sFunction=$(head -1 ${iFarm}/${iPosition}/${iSlot})
 # now we should know which function to call
 harvest${sFunction} ${iFarm} ${iPosition} ${iSlot}
 start${sFunction}${NONPREMIUM} ${iFarm} ${iPosition} ${iSlot}
 updateQueue ${iFarm} ${iPosition} ${iSlot}
}

function harvestStable {
 local iFarm=$1
 local iPosition=$2
 sendAJAXFarmRequest "mode=inner_crop&farm=${iFarm}&position=${iPosition}"
}

function startStable {
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
 sendAJAXFarmRequest $sAJAXSuffix
}

function startStableNP {
 startStable $1 $2
}

function harvestKnittingMill {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iRealSlot=$(getRealSlotName $iFarm $iPosition $iSlot)
 sendAJAXFarmRequest "position=${iPosition}&mode=crop&slot=${iRealSlot}&farm=${iFarm}"
}

function startKnittingMill {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iRealSlot=$(getRealSlotName $iFarm $iPosition $iSlot)
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
 sendAJAXFarmRequest $sAJAXSuffix
}

function startKnittingMillNP {
 startKnittingMill $1 $2 $3
}

function harvestOilMill {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # slot index in oil mill doesn't always match slot "name"
 local iRealSlot=$(getRealSlotName $iFarm $iPosition $iSlot)
 # oil mills use slots 1, 2 and 3 instead of 0, 1... FFS
 sendAJAXFarmRequest "position=${iPosition}&mode=crop&slot=${iRealSlot}&farm=${iFarm}"
}

function startOilMill {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # oil mills use slots 1, 2 and 3 FFS
 # Special Oil Mill takes one parameter
 local iPID=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 # PIDs start at 1 for this building type
 iPID=$((iPID - 115))
 local iRealSlot=$(getRealSlotName $iFarm $iPosition $iSlot)
 # do the mill
 sendAJAXFarmRequest "position=${iPosition}&oil=${iPID}&mode=start&slot=${iRealSlot}&farm=${iFarm}"
}

function startOilMillNP {
 startOilMill $1 $2 $3
}

 function harvestTeaFactory {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iRealSlot=$(getRealSlotName $iFarm $iPosition $iSlot)
 sendAJAXFarmRequest "position=${iPosition}&mode=crop&slot=${iRealSlot}&farm=${iFarm}"
}

function startTeaFactory {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 # PIDs start at 1 for this building type
 iPID=$((iPID - 749))
 # this only works cuz the farm data isn't updated in between harvesting and planting (!)
 local iRealSlot=$(getRealSlotName $iFarm $iPosition $iSlot)
 sendAJAXFarmRequest "farm=${iFarm}&position=${iPosition}&slot=${iRealSlot}&item=${iPID}&mode=start"
}

function startTeaFactoryNP {
 startTeaFactory $1 $2 $3
}

function harvestFactory {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 iSlot=$((iSlot + 1))
# sendAJAXFarmRequest "mode=getadvancedcrop&farm=${iFarm}&position=${iPosition}"
 sendAJAXFarmRequest "mode=harvestproduction&farm=${iFarm}&position=${iPosition}&id=${iSlot}&slot=${iSlot}"
}

function startFactory {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # Factory takes one parameter
 local iPID=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 # factory data changed on Apr 7th 2020
 case "$iPID" in
  # mayo kitchen, cheese diary, wool spinning mill and sweets kitchen
  # 9,10,11 and 12 are kept for convenience, will be removed in the future
  9|10|11|12|25|27|28|30)
    iPID=1
    ;;
  # 21,110 and 151 are kept for convenience, will be removed in the future
  21|110|151|144|111|152|820)
    iPID=2
    ;;
  821)
    iPID=3
    ;;
  822)
    iPID=4
    ;;
  823)
    iPID=5
    ;;
  824)
    iPID=6
    ;;
  *)
    logToFile "startFactory: Unknown PID"
    return
    ;;
 esac
 iSlot=$((iSlot + 1))
 local sAJAXSuffix="farm=${iFarm}&position=${iPosition}&slot=${iSlot}&item=${iPID}&mode=start"
 if [ "$GUILDJOB" = true ]; then
  local sAJAXSuffix="${sAJAXSuffix}&guildjob=1"
  GUILDJOB=false
 fi
 # start the factory
 sendAJAXFarmRequest $sAJAXSuffix
}

function startFactoryNP {
 startFactory $1 $2 $3
}

function harvestFarm {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 sendAJAXFarmRequest "mode=cropgarden&farm=${iFarm}&position=${iPosition}"
}

function startFarm {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # Farm takes one parameter
 local iPID=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 # start the farm
 sendAJAXFarmRequest "mode=autoplant&farm=${iFarm}&position=${iPosition}&id=${iPID}&product=${iPID}"
 # water the farm
 sendAJAXFarmRequest "mode=watergarden&farm=${iFarm}&position=${iPosition}"
}

function startFarmNP {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # fetch garden data
 getInnerInfoData $TMPFILE $iFarm $iPosition gardeninit
 local iProduct=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 # shellcheck disable=SC2090
 local iProductDim_x=$(echo $aDIM_X | $JQBIN -r '."'${iProduct}'"')
 # shellcheck disable=SC2090
 local iProductDim_y=$(echo $aDIM_Y | $JQBIN -r '."'${iProduct}'"')
 local iPlot=1
 local iCache=0
 local iCacheFlag=0
 local sData="mode=garden_plant&farm=${iFarm}&position=${iPosition}&"
 local sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
 while (true); do
  if [ $iPlot -gt 120 ]; then
   if [ $iCacheFlag -eq 1 ]; then
    sendAJAXFarmRequest "${sData}cid=${iPosition}"
    sendAJAXFarmRequest "${sDataWater}"
    iCacheFlag=0
    iCache=0
   fi
   if ! checkRipePlotOnField $iFarm $iPosition; then
    getFarmData $FARMDATAFILE
    return
   fi
   # there's more to harvest on this very field
   harvestFarm $iFarm $iPosition $iSlot
   getInnerInfoData $TMPFILE $iFarm $iPosition gardeninit
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
   sendAJAXFarmRequest "${sData}cid=${iPosition}"
   sendAJAXFarmRequest "${sDataWater}"
   iCacheFlag=0
   iCache=0
  fi
  if ! checkRipePlotOnField $iFarm $iPosition; then
   getFarmData $FARMDATAFILE
   return
  fi
  harvestFarm $iFarm $iPosition $iSlot
  getInnerInfoData $TMPFILE $iFarm $iPosition gardeninit
  iPlot=1
 fi
 if ! getFieldPlotReadiness $iPlot ; then
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
   sendAJAXFarmRequest "${sData}cid=${iPosition}"
   sendAJAXFarmRequest "${sDataWater}"
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
 if ! getFieldPlotReadiness $((iPlot + 1)); then
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
   sendAJAXFarmRequest "${sData}cid=${iPosition}"
   sendAJAXFarmRequest "${sDataWater}"
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
 if ! getFieldPlotReadiness $((iPlot + 12)); then
  iPlot=$((iPlot + 1))
  continue
 fi
 if ! getFieldPlotReadiness $((iPlot + 13)); then
  iPlot=$((iPlot + 1))
  continue
 fi
 sData="${sData}pflanze[]=${iProduct}&feld[]=${iPlot}&felder[]=${iPlot},$((iPlot + 1)),$((iPlot + 12)),$((iPlot + 13))&"
 sDataWater="${sDataWater}feld[]=${iPlot}&felder[]=${iPlot},$((iPlot + 1)),$((iPlot + 12)),$((iPlot + 13))&"
 iCacheFlag=1
 iCache=$((iCache + 1))
 if [ $iCache -eq 5 ]; then
  sendAJAXFarmRequest "${sData}cid=${iPosition}"
  sendAJAXFarmRequest "${sDataWater}"
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

function waterField {
 local iFarm=$1
 local iPosition=$2
 sendAJAXFarmRequest "mode=watergarden&farm=${iFarm}&position=${iPosition}"
}

function waterFieldNP {
 # this function only supports completely filled fields of the same crop size
 local iFarm=$1
 local iPosition=$2
 getInnerInfoData $TMPFILE $iFarm $iPosition gardeninit
 local iProductDim_x=$($JQBIN '.datablock[1]["1"].x' $TMPFILE)
 local iProductDim_y=$($JQBIN '.datablock[1]["1"].y' $TMPFILE)
 local sDataWater="mode=garden_water&farm=${iFarm}&position=${iPosition}&"
 local iPlot=1
 local iCache=0
 local iCacheFlag=0
 while (true); do
  if [ $iPlot -gt 120 ]; then
   if [ $iCacheFlag -eq 1 ]; then
    sendAJAXFarmRequest "${sDataWater}"
    getFarmData $FARMDATAFILE
    return
   fi
  getFarmData $FARMDATAFILE
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
    sendAJAXFarmRequest "${sDataWater}"
    getFarmData $FARMDATAFILE
    return
   else
    getFarmData $FARMDATAFILE
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
   sendAJAXFarmRequest "${sDataWater}"
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
   sendAJAXFarmRequest "${sDataWater}"
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
  sendAJAXFarmRequest "${sDataWater}"
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

function doForestry {
 local sFile=$1
 local iSurplus
 local sFunction=$(head -1 ${sFile}/${sFile}/${sFile})
 if checkQueueSleep ${sFile}/${sFile}/${sFile}; then
  echo "Set to sleep"
  return
 fi
 local iLogCapacity=$($JQBIN '.datablock[2]["1"].capacity' $FARMDATAFILE)
 local iPID=$($JQBIN -r '.datablock[1][0].productid' $FARMDATAFILE)
 local iAmountToHarvest=$($JQBIN -r '.datablock[1] | .[] | select(.productid == "'${iPID}'" and .remain == 0).productid' $FARMDATAFILE | wc -l)
 # log's PIDs are different from the seed's PIDs
  case "$iPID" in
   [1-5]) iPID=$((iPID + 20))
          ;;
       *) iPID=$((iPID + 19))
          ;;
  esac
 local iAmountInStock=$($JQBIN -r '.updateblock["forestry_stock"]["'${iPID}'"]' $FARMDATAFILE)
 # test for stock overflow
 iSurplus=$((iAmountInStock + iAmountToHarvest - iLogCapacity))
 if [ $iSurplus -gt 0 ]; then
  if grep -q "trimlogstock = 1" $CFGFILE; then
   echo "Destroying $iSurplus items of log type #${iPID}"
   sendAJAXForestryRequest "action=schredder&productid=${iPID}&amount=${iSurplus}"
  else
   logToFile "doForestry: max. capacity reached, not harvesting"
   return
  fi
 fi
 harvest${sFunction}
 start${sFunction} ${sFile}/${sFile}/${sFile}
 updateQueue ${sFile} ${sFile} ${sFile}
}

function harvestTree {
 # harvest all trees
 sendAJAXForestryRequest "action=cropall"
}

function startTree {
 local sFile=$1
 local iPID=$(sed '2q;d' ${sFile})
 # plant trees
 sendAJAXForestryRequest "action=autoplant&productid=${iPID}"
 if checkCanWaterTrees; then
  waterTree
 fi
}

function waterTree {
 # water trees
 sendAJAXForestryRequest "action=water"
}

function harvestForestryBuilding {
 local iPosition=$2
 local iSlot=$3
 sendAJAXForestryRequest "action=cropproduction&position=${iPosition}&slot=${iSlot}"
}

function startForestryBuilding {
 local sFarm=$1
 local iPosition=$2
 local iSlot=$3
 # this building needs one parameter
 local iPID=$(sed '2q;d' ${sFarm}/${iPosition}/${iSlot})
 sendAJAXForestryRequest "action=startproduction&position=${iPosition}&productid=${iPID}&slot=${iSlot}"
}

function startForestryBuildingNP {
 startForestryBuilding $1 $2 $3
}

function harvestFoodWorldBuilding {
 local iPosition=$2
 local iSlot=$3
 sendAJAXFoodworldRequest "action=crop&id=0&table=${iPosition}&chair=${iSlot}"
}

function startFoodWorldBuilding {
 local sFarm=$1
 local iPosition=$2
 local iSlot=$3
 # this building needs one parameter
 iPID=$(sed '2q;d' ${sFarm}/${iPosition}/${iSlot})
 sendAJAXFoodworldRequest "action=production&id=${iPID}&table=${iPosition}&chair=${iSlot}"
}

function startFoodWorldBuildingNP {
 startFoodWorldBuilding $1 $2 $3
}

function checkMunchiesAtTables {
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
    logToFile "checkMunchiesAtTables: Unknown JSON data type: ${sJSONDataType}"
    break 2
   fi
   if [ "$bMunchieReady" = "true" ]; then
    echo "Munchie available at table $((iTable + 1)), chair ${iChair}, claiming it..."
    sendAJAXFoodworldRequest "action=cash&id=0&table=${iTable}&chair=${iChair}"
   fi
  done
 done
}

function checkMunchies {
# unused function. sits munchie down if there's enough goods for him
 local iID
 local aIDs
 local iPID
 local aPIDs
 local aTables
 local iTable
 local iChair
 local iAmountNeeded
 local iAmountInStock
 local bCanSit
 # get Munchies with status 0
 aIDs=$($JQBIN -r '.datablock.farmis | .[] | select(.status == "0").id' $FARMDATAFILE)
 for iID in $aIDs; do
  bCanSit="true"
  aPIDs=$($JQBIN -r '.datablock.farmis | .[] | select(.id == "'${iID}'").products | to_entries[] | .key' $FARMDATAFILE)
  for iPID in $aPIDs; do
   iAmountInStock=$(getPIDAmountFromStock $iPID 1)
   iAmountNeeded=$($JQBIN '.datablock.farmis | .[] | select(.id == "'${iID}'").products["'${iPID}'"]' $FARMDATAFILE)
   if [ $iAmountInStock -lt $iAmountNeeded ]; then
    bCanSit="false"
    break
   fi
  done
  if [ "$bCanSit" = "false" ]; then
   continue
  fi
  # get tables that are neither locked or blocked
  aTables=$($JQBIN -r '.datablock.tables | .[] | select(.block != 1 and .locked != 1).id' $FARMDATAFILE)
  for iTable in $aTables; do
   # find a free chair - the logical or for .id is needed cuz the source data is inconsistent as of 11/2019
   iChair=$($JQBIN 'first(.datablock.tables | .[] | select(.id == '${iTable}' or .id == "'${iTable}'").chairs| tostream | select(length == 2)  as [$key, $value] | if ($key[0] | tonumber < 3) and $value == [] then $key[-1] | tonumber else empty end)' $FARMDATAFILE)
   if [ -n "$iChair" ]; then
    echo "Sitting munchie with ID ${iID} down at table ${iTable}, chair ${iChair}..."
    # table indices start at 0
    iTable=$((iTable - 1))
    sendAJAXFoodworldRequest "action=dropped&id=${iID}&table=${iTable}&chair=${iChair}"
    sleep 2
    break
   fi
  done
  if [ -z "$iChair" ]; then
   echo "No free seat found for munchie with ID ${iID}"
  fi
 done
}

function doFarmersMarket {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 if checkQueueSleep ${sFarm}/${sPosition}/${iSlot}; then
  echo "Set to sleep"
  return
 fi
 local sFunction=$(head -1 ${sFarm}/${sPosition}/${iSlot})
 harvest${sFunction} ${sFarm} ${sPosition} ${iSlot}
 start${sFunction} ${sFarm} ${sPosition} ${iSlot}
 if [ $SKIPQUEUEUPDATE -eq 1 ]; then
  SKIPQUEUEUPDATE=0
  return
 fi
 updateQueue ${sFarm} ${sPosition} ${iSlot}
}

function harvestFlowerArea {
 # harvest flowers
 if [ "$NONPREMIUM" = "NP" ]; then
  harvestFlowerAreaNP
  return
 fi
 sendAJAXFarmRequest "mode=flowerarea_harvest_all&farm=1&position=1"
}

function harvestFlowerAreaNP {
 # this function only supports the same flower in all spots
 local iPID=$($JQBIN -r '.updateblock.farmersmarket.flower_area["1"].pid' $FARMDATAFILE)
 local iCount
 local sData="mode=flowerarea_harvest&farm=1&position=1&set="
 for iCount in {1..36}; do
  sData=${sData}${iCount}:${iPID},
 done
 sendAJAXFarmRequest $sData
}

function startFlowerArea {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 if [ "$iPID" = "998" ]; then
  # bonus plant?
  iPID=$($JQBIN '.updateblock.farmersmarket.flower_bonus.pid' $FARMDATAFILE)
 fi
 if [ "$NONPREMIUM" = "NP" ]; then
  startFlowerAreaNP $iPID
  return
 fi
 sendAJAXFarmRequest "mode=flowerarea_autoplant&farm=1&position=1&set=0&pid=${iPID}"
 # water the flowers
 sendAJAXFarmRequest "mode=flowerarea_water_all&farm=1&position=1"
}

function startFlowerAreaNP {
 local iPID=$1
 local iCount
 local sData="mode=flowerarea_plant&farm=1&position=1&set="
 local sDataWater="mode=flowerarea_water&farm=1&position=1&set="
 for iCount in {1..36}; do
  sData=${sData}${iCount}:${iPID},
  sDataWater=${sDataWater}${iCount}:${iPID},
 done
 sendAJAXFarmRequest $sData
 sendAJAXFarmRequest $sDataWater
}

function harvestNursery {
 local iSlot=$3
 sendAJAXFarmRequest "mode=nursery_harvest&farm=1&position=1&id=1&slot=${iSlot}"
}

function startNursery {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 sendAJAXFarmRequest "mode=nursery_startproduction&farm=1&position=1&id=${iPID}&pid=${iPID}&slot=${iSlot}"
}

function doFarmersMarketFlowerPots {
 local iPID
 local iSlot
 # find withered arrangements
 local aSlots=$($JQBIN '.updateblock.farmersmarket.flower_slots.slots | tostream | select(length == 2) as [$key,$value] | if $key[-1] == "remain" and $value < 0 then ($key[-2] | tonumber) else empty end' $FARMDATAFILE)
 for iSlot in $aSlots; do
  iPID=$(getConfigValue flowerarrangementslot${iSlot})
  if [ $iPID -ne 0 ]; then
   sendAJAXFarmRequest "mode=flowerslot_remove&farm=1&position=1&set=${iSlot}:1,"
   sleep 1
   echo "Planting arrangement ${iPID} to flower pot ${iSlot}..."
   sendAJAXFarmRequest "mode=flowerslot_plant&farm=1&position=1&set=${iSlot}:${iPID},"
  fi
 done
 # water pots in need
 aSlots=$($JQBIN '.updateblock.farmersmarket.flower_slots.slots | tostream | select(length == 2) as [$key,$value] | if $key[-1] == "waterremain" and ($value < 1800 and $value > 0) then ($key[-2] | tonumber) else empty end' $FARMDATAFILE)
 for iSlot in $aSlots; do
  iPID=$($JQBIN -r '.updateblock.farmersmarket.flower_slots.slots["'${iSlot}'"].pid' $FARMDATAFILE)
  # skip watering of special flowers (214 and up)
  if [ $iPID -le 213 ]; then
   # skip plants that don't need water anymore
   if [ -n "$($JQBIN '.updateblock.farmersmarket.flower_slots.slots["'${iSlot}'"] | select(.remain != .waterremain)' $FARMDATAFILE)" ]; then
    echo "Watering flower pot ${iSlot}..."
    sendAJAXFarmRequest "mode=flowerslot_water&farm=1&position=1&set=${iSlot}:1,"
   fi
  fi
 done
}

function harvestMonsterFruitHelper {
 :
}

function startMonsterFruitHelper {
 sFarm=$1
 sPosition=$2
 iSlot=$3
 iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 sendAJAXFarmRequest "mode=megafruit_buyobject&farm=1&position=1&id=${iPID}&oid=${iPID}"
}

function doFoodContestCashDesk {
 sendAJAXFarmRequest "mode=foodcontest_merchpin&farm=1&position=1"
}

function doFoodContestAudience {
 local iBlock=$1
 local sPinType=$2
 sendAJAXFarmRequest "mode=foodcontest_pincache&farm=1&position=1&id=1_${sPinType},&value=${iBlock}_${sPinType},"
}

function doFoodContestFeeding {
 sendAJAXFarmRequest "mode=foodcontest_feed&farm=1&position=1"
}

function harvestPets {
 local iSlot=$3
 sendAJAXFarmRequest "mode=pets_harvest_production&slot=${iSlot}&position=1"
}

function startPets {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 sendAJAXFarmRequest "mode=pets_start_production&slot=${iSlot}&pid=${iPID}"
}

function harvestVet {
 local iSlot=$3
 sendAJAXFarmRequest "mode=vet_harvestproduction&farm=1&position=1&id=${iSlot}&slot=${iSlot}&pos=1"
}

function startVet {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 sendAJAXFarmRequest "mode=vet_startproduction&farm=1&position=1&id=${iSlot}&slot=${iSlot}&pid=${iPID}&pos=1"
}

function doFarmersMarketAnimalTreatment {
 local iSlot=$1
 local iAnimalID
 local aQueue
 local sTreatmentSet=
 local iDiseaseID
 local iFastestCure
 sendAJAXFarmRequest "mode=vet_endtreatment&farm=1&position=1&id=${iSlot}&slot=${iSlot}"
 if ! grep -q "restartvetjob = 0" $CFGFILE && grep -q "restartvetjob = " $CFGFILE; then
  checkVetJobDone
 fi
 if getAnimalQueueLength; then
  # queue is empty, return
  return
 fi
 # get animal ID from queue holding status 0
 iAnimalID=$($JQBIN -r 'first(.updateblock.farmersmarket.vet.animals.queue | .[] | select(.status == "0").id)' $FARMDATAFILE)
 # place it in slot
 sendAJAXFarmRequest "mode=vet_setslot&farm=1&position=1&id=${iSlot}&slot=${iSlot}&aid=${iAnimalID}"
 # isolate deseases for animal ID
 aQueue=$($JQBIN '.updateblock.farmersmarket.vet.animals.queue["'${iAnimalID}'"].diseases | .[] | .id?' $FARMDATAFILE)
 for iDiseaseID in $aQueue; do
  # find fastest cure for disease
  iFastestCure=$(getAnimalsFastestCureForDisease $iDiseaseID)
  sTreatmentSet=${sTreatmentSet}${iDiseaseID}_${iFastestCure},
 done
 # start treatment
 sendAJAXFarmRequest "mode=vet_starttreatment&farm=1&position=1&id=${iSlot}&slot=${iSlot}&set=${sTreatmentSet}"
 getFarmData $FARMDATAFILE
}

function checkVetJobDone {
 local iAnimalsHealedCount=$($JQBIN -r '.updateblock.farmersmarket.vet.info.role_count' $FARMDATAFILE)
 local iAnimals2HealCount=$($JQBIN -r '.updateblock.farmersmarket.vet.info.role_count_max' $FARMDATAFILE)
 # we're not using updated farm data at this point, but a treatment has just been finished
 # that's why we're calculating with one less treatment
 iAnimals2HealCount=$((iAnimals2HealCount - 1))
 if [ $iAnimals2HealCount -eq $iAnimalsHealedCount ]; then
  local iVetJob=$(getConfigValue restartvetjob)
  echo "Restarting vets' treatment with difficulty ${iVetJob}..."
  sleep 2
  sendAJAXFarmRequest "mode=vet_setrole&farm=1&position=1&id=${iVetJob}&role=${iVetJob}"
 fi
}

function doFarmersMarketPetCare {
 local sSlot=$1
 # get config data
 if grep -q "care${sSlot} = 0" $CFGFILE; then
  echo "Pet's $sSlot care is set to sleep"
 else
  local sCare=$(getConfigValue care${sSlot})
  sendAJAXFarmRequest "mode=pets_care&set=${sCare},${sCare},${sCare}"
 fi
}

function harvestCowRacing {
 local iSlot=$3
 sendAJAXFarmRequest "slot=${iSlot}&position=1&mode=cowracing_harvestproduction"
}

function startCowRacing {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 sendAJAXFarmRequest "slot=${iSlot}&pid=${iPID}&mode=cowracing_startproduction"
}

function checkRaceCowFeeding {
 local iSlot=$1
 local iPID=$(getConfigValue racecowslot${iSlot})
 local sSlotType=$($JQBIN -r '.updateblock.farmersmarket.cowracing.data.cowslots["'${iSlot}'"] | type' $FARMDATAFILE 2>/dev/null)
 if [ "$sSlotType" = "number" ]; then
  if ! checkCowIsPvP ${iSlot}; then
   SLOTREMAIN=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'${iSlot}'"].feed_remain?' $FARMDATAFILE 2>/dev/null)
   if [ "$SLOTREMAIN" = "null" ]; then
    echo "Feeding race cow in slot ${iSlot}..."
    sendAJAXFarmRequest "pid=${iPID}&slot=${iSlot}&mode=cowracing_feedCow"
   else
    checkTimeRemaining '.updateblock.farmersmarket.cowracing.data.cows["'${iSlot}'"].feed_remain?'
   fi
  fi
 else
  echo "There seems to be no cow in slot ${iSlot}!"
 fi
}

function checkCowRace {
 local iSlot
 local sEnvironment
 local sBodyPart
 local iEquipmentID
 local iCowLevel
 local aSlots=$($JQBIN -r '.updateblock.farmersmarket.cowracing.data.cowslots | keys | .[]' $FARMDATAFILE 2>/dev/null)
 for iSlot in $aSlots; do
  if checkTimeRemaining '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"]?.race_remain'; then
   if grep -q "excluderank1cow = 1" $CFGFILE && checkCowRanked1st $iSlot; then
    echo "Skipping training race for cow ranked 1st in slot $iSlot"
    continue
   fi
   if checkCowIsPvP ${iSlot}; then
    echo "Skipping PvP signed up cow in slot $iSlot"
    continue
   fi
   iCowLevel=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].level' $FARMDATAFILE)
   if [ $iCowLevel -gt 1 ]; then
    # remove all equipment from cow
    removeCowEquipment $iSlot
    sEnvironment=$($JQBIN -r '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].lanestatus' $FARMDATAFILE 2>/dev/null)
    for sBodyPart in head body foot; do
     # find/equip best equipment for the cow, buy non-coin equipment if possible
     iEquipmentID=$(getCowEquipmentID $sBodyPart $sEnvironment)
     if [ "$iEquipmentID" = "-1" ]; then
      continue
     fi
     # equip it
     sendAJAXFarmRequest "id=${iEquipmentID}&slot=${iSlot}&mode=cowracing_equipitem"
    done
   # start the race
   sleep 1
  fi
  echo "Starting cow training race in slot ${iSlot}..."
  sendAJAXFarmRequestOverwrite "type=pve&slot=${iSlot}&mode=cowracing_startrace" && sleep 3
  # put equipment back into stock
  removeCowEquipment $iSlot
  fi
 done
 # refresh farm data
 getFarmData $FARMDATAFILE
}

function checkCowRacePvP {
 local bTimeThreshold
 local sEnvironment
 local sBodyPart
 local sIsPvP=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows | .[] | select(.ispvp == "1").ispvp' $FARMDATAFILE)
 if [ -n "$sIsPvP" ]; then
  echo "You have already signed up for the PvP cow race"
  return
 fi
 # give player enough time to sign up in case he chooses to override the bot
 bTimeThreshold=$($JQBIN '.updateblock.farmersmarket.cowracing.pvp.racedayremain < 5400' $FARMDATAFILE)
 if [ "$bTimeThreshold" = "false" ]; then
  return
 fi
 local iCow=0
 local iCowProspect=0
 local iCowRating
 local iCowSlot
 local iEquipmentID
 local aCows=$($JQBIN -r '.updateblock.farmersmarket.cowracing.data.cows | keys | .[]' $FARMDATAFILE)
 sEnvironment=$($JQBIN -r '.updateblock.farmersmarket.cowracing.pvp.lanestatus' $FARMDATAFILE)
 for iCowSlot in $aCows; do
  if ! checkCowRanked1st $iCowSlot; then
#   echo "DEBUG: cow in slot $iCowSlot isn't ranked 1st"
   continue
  fi
  if checkCowSuspended $iCowSlot; then
#   echo "DEBUG: cow in slot $iCowSlot has been temporarily suspended"
   continue
  fi
  iCowRating=$(getCowRating $iCowSlot $sEnvironment)
  if [ $iCowRating -gt $iCowProspect ]; then
   iCowProspect=$iCowRating
   iCow=$iCowSlot
#   echo "DEBUG: current prospect is cow in slot $iCow"
  fi
 done
 if [ $iCow -eq 0 ]; then
  logToFile "checkCowRacePvP: No suitable cow available for PvP cow race"
  return
 fi
 # ready to rock
 iCowSlot=$iCow
 removeCowEquipment $iCowSlot
 for sBodyPart in head body foot; do
  iEquipmentID=$(getCowEquipmentID $sBodyPart $sEnvironment)
  if [ "$iEquipmentID" = "-1" ]; then
   logToFile "checkCowRacePvP: Could not get equipment for your cow's $sBodyPart"
   continue
  fi
  sendAJAXFarmRequest "id=${iEquipmentID}&slot=${iCowSlot}&mode=cowracing_equipitem"
 done
 sleep 1
 echo "Signing up cow in slot ${iCowSlot} for the next PvP race..."
 # we cannot remove the eqiupment here
 sendAJAXFarmRequest "slot=${iCowSlot}&mode=cowracing_registercowpvp" && sleep 3
 getFarmData $FARMDATAFILE
}

function getCowRating {
 local iSlot=$1
 local sEnvironment=$2
 local iCowRating
 local iCowLevel
 local iCowType
 local iCowSpeed
 local sCowAdv
 local sCowDisadv
 local iCowLevelSpeed
 iCowLevel=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].level' $FARMDATAFILE)
 iCowType=$($JQBIN -r '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].type' $FARMDATAFILE)
 iCowSpeed=$($JQBIN '.updateblock.farmersmarket.cowracing.config.cows["'$iCowType'"].speed' $FARMDATAFILE)
 sCowAdv=$($JQBIN -r '.updateblock.farmersmarket.cowracing.config.cows["'$iCowType'"].racetype_pro' $FARMDATAFILE)
 sCowDisadv=$($JQBIN -r '.updateblock.farmersmarket.cowracing.config.cows["'$iCowType'"].racetype_con' $FARMDATAFILE)
 iCowLevelSpeed=$($JQBIN '.updateblock.farmersmarket.cowracing.config.level["'$iCowLevel'"].speed' $FARMDATAFILE)
 iCowRating=$(awk 'BEGIN{print ('${iCowSpeed}' + '${iCowLevelSpeed}') * 100}')
 # since i don't know the exact values for (dis)advantage, i'll define them as (-)3.75%
 if [ "$sEnvironment" = "$sCowAdv" ]; then
  iCowRating=$(awk 'BEGIN{print int('${iCowRating}' * 1.0375 * 100)}')
  echo $iCowRating
  return
 elif [ "$sEnvironment" = "$sCowDisadv" ]; then
  iCowRating=$(awk 'BEGIN{print int('${iCowRating}' * 0.9625 * 100)}')
  echo $iCowRating
  return
 fi
 echo $((iCowRating * 100))
}

function removeCowEquipment {
 # does what the name suggests. mind that this function overwrites $FARMDATAFILE !
 local iSlot=$1
 local sBodyPart
 local bItemEquipped
 local iSuspendedCowSlot
 for sBodyPart in head body foot; do
  bItemEquipped=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'${iSlot}'"].slot_'${sBodyPart}' != "0"' $FARMDATAFILE)
  if [ "$bItemEquipped" = "true" ]; then
   sendAJAXFarmRequestOverwrite "type=${sBodyPart}&slot=${iSlot}&mode=cowracing_unequipitem" && sleep 1
  fi
 done
 # call again if PvP race cow is still wearing items
 iSuspendedCowSlot=$($JQBIN -r '.updateblock.farmersmarket.cowracing.data.cows | .[] | select(.suspendpvp == "1" and (.slot_head != "0" or .slot_body != "0" or .slot_foot != "0")).slot' $FARMDATAFILE)
 if [ -n "$iSuspendedCowSlot" ]; then
  removeCowEquipment $iSuspendedCowSlot
 fi
}

function getCowEquipmentID {
 local sBodyPart=$1
 local sEnvironment=$2
 local iEquipmentID=-1
 case "$sBodyPart:$sEnvironment" in
  head:normal)
     iEquipmentID=$(checkCowEquipmentAvailability "17 1")
     ;;
  head:rain)
     iEquipmentID=$(checkCowEquipmentAvailability "2 16")
     ;;
  head:cold)
     iEquipmentID=$(checkCowEquipmentAvailability "4 16")
     ;;
  head:heat)
     iEquipmentID=$(checkCowEquipmentAvailability "17 5")
     ;;
  head:mud)
     iEquipmentID=$(checkCowEquipmentAvailability "17 3")
     ;;
  body:normal)
     iEquipmentID=$(checkCowEquipmentAvailability "21 11")
     ;;
  body:rain)
     iEquipmentID=$(checkCowEquipmentAvailability "14 20")
     ;;
  body:cold)
     iEquipmentID=$(checkCowEquipmentAvailability "21 13")
     ;;
  body:heat)
     iEquipmentID=$(checkCowEquipmentAvailability "12 20")
     ;;
  body:mud)
     iEquipmentID=$(checkCowEquipmentAvailability "21 15")
     ;;
  foot:normal)
     iEquipmentID=$(checkCowEquipmentAvailability "19 6")
     ;;
  foot:rain)
     iEquipmentID=$(checkCowEquipmentAvailability "19 9")
     ;;
  foot:cold)
     iEquipmentID=$(checkCowEquipmentAvailability "10 18")
     ;;
  foot:heat)
     iEquipmentID=$(checkCowEquipmentAvailability "19 8")
     ;;
  foot:mud)
     iEquipmentID=$(checkCowEquipmentAvailability "7 18")
     ;;
 esac
 echo "$iEquipmentID"
}

function checkCowEquipmentAvailability {
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
 iKey=$(getCowEquipment "$iSearchPattern")
 echo $iKey
}

function getCowEquipment {
 local iSearchPattern="$1"
 local iItem
 local iKey
 local bIsMoneyItem
 for iItem in $iSearchPattern; do
  bIsMoneyItem=$($JQBIN '.updateblock.farmersmarket.cowracing.config.items["'${iItem}'"].money? | type == "number"' $FARMDATAFILE)
  if [ "$bIsMoneyItem" = "true" ]; then
   echo "Buying cow equipment #${iItem}..." >&2 # this is very ugly.
   sendAJAXFarmRequestOverwrite "id=${iItem}&slot=1&mode=cowracing_buyitem" && sleep 1
   # nicer would be to use the correct slot no.
   iKey=$($JQBIN -r '[.updateblock.farmersmarket.cowracing.data.items | .[] | select(.type == "'${iItem}'")][0]?.id' $FARMDATAFILE)
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

function checkCowRanked1st {
 # returns true if a cow is ranked 1st
 local iSlot=$1
 local bCowIsRanked1st=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].ladder.rank == 1' $FARMDATAFILE)
 if [ "$bCowIsRanked1st" = "true" ]; then
  return 0
 fi
 return 1
}

function checkCowIsPvP {
 # returns true if a cow has signed up for a PvP race
 local iSlot=$1
 local bCowIsPvP=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].ispvp == "1"' $FARMDATAFILE)
 if [ "$bCowIsPvP" = "true" ]; then
  return 0
 fi
 return 1
}

function checkCowSuspended {
 # returns true if a cow has been suspended from PvP racing
 local iSlot=$1
 local bCowSuspended=$($JQBIN '.updateblock.farmersmarket.cowracing.data.cows["'$iSlot'"].suspendpvp == "1"' $FARMDATAFILE)
 if [ "$bCowSuspended" = "true" ]; then
  return 0
 fi
 return 1
}

function harvestFishing {
 local iSlot=$3
 sendAJAXFarmRequest "slot=${iSlot}&position=1&mode=fishing_harvestproduction"
}

function startFishing {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 if ! grep -q "preferredbait${iSlot} = 0" $CFGFILE && grep -q "preferredbait${iSlot} = " $CFGFILE; then
  # player has a food preference
  local iPreferredPID=$(getConfigValue preferredbait${iSlot})
  local iNeededItem=$($JQBIN -r '.updateblock.farmersmarket.fishing.config.products["'${iPreferredPID}'"].needs.items | keys[0]' $FARMDATAFILE)
  local iNeededAmount=$($JQBIN '.updateblock.farmersmarket.fishing.config.products["'${iPreferredPID}'"].needs.items["'${iNeededItem}'"]' $FARMDATAFILE)
  local iAmountInStock=$($JQBIN '.updateblock.farmersmarket.fishing.data.stock["'${iNeededItem}'"]?' $FARMDATAFILE)
  if [ "$iAmountInStock" != "null" ]; then
   if [ $iAmountInStock -ge $iNeededAmount ]; then
    echo "Producing a preferred item..."
    iPID=$iPreferredPID
    SKIPQUEUEUPDATE=1
   fi
  fi
 fi
 sendAJAXFarmRequest "slot=${iSlot}&pid=${iPID}&mode=fishing_startproduction"
}

function doFisherman {
 local iSlot=$1
 local iSpeciesbait=$(getConfigValue speciesbait${iSlot})
 local iRaritybait=$(getConfigValue raritybait${iSlot})
 local iFishinggear=$(getConfigValue fishinggear${iSlot})
 local iItem
 local bIsMoneyItem
 local sSelection
 sendAJAXFarmRequestOverwrite "slot=${iSlot}&mode=fishing_finish_fishing" && sleep 1
 iItem=$($JQBIN -r '[.updateblock.farmersmarket.fishing.data.items | .[]? | select(.type == "'${iFishinggear}'" and .stock == "1").id][0]' $FARMDATAFILE)
 if [ "$iItem" == "null" ]; then
  # no item available, buy it, if it's not a coin-item
  bIsMoneyItem=$($JQBIN '.updateblock.farmersmarket.fishing.config.items["'${iFishinggear}'"].money? | type == "number"' $FARMDATAFILE)
  if [ "$bIsMoneyItem" = "false" ]; then
   logToFile "doFisherman: refusing to buy coin item"
   return
  fi
  echo "Buying fishing gear #${iFishinggear}..."
  sendAJAXFarmRequestOverwrite "id=${iFishinggear}&mode=fishing_shop_buy" && sleep 1
  iItem=$($JQBIN -r '[.updateblock.farmersmarket.fishing.data.items | .[] | select(.type == "'${iFishinggear}'" and .stock == "1").id][0]' $FARMDATAFILE)
 fi
 # request requires encoded JSON data
 # sSelection=$(echo '{"category":'${iSpeciesbait}',"rarity":'${iRaritybait}',"item":'${iItem}'}' | jq -r @uri)
 sSelection="%7B%22category%22%3A${iSpeciesbait}%2C%22rarity%22%3A${iRaritybait}%2C%22item%22%3A${iItem}%7D"
 echo "Starting fishing session in slot ${iSlot}..."
 sendAJAXFarmRequest "slot=${iSlot}&selection=${sSelection}&mode=fishing_start_fishing"
 getFarmData $FARMDATAFILE
}

function harvestMegaField {
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
     harvestMegaField2x2 ${iFarm} ${iPosition} ${iSlot} ${iHarvestDevice}
     updateQueue ${iFarm} ${iPosition} ${iSlot}
     iHarvestDevice=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
     case "$iHarvestDevice" in
      5|7|9|10)
         echo "You need a 1x1 device after the 2x2 one - cannot continue"
         return
         ;;
     esac
     ;;
 esac
 iHarvestDelay=$(getMegaFieldHarvesterDelay $iHarvestDevice)
 if [ $iHarvestDelay -eq 0 ]; then
  echo "Stopping work on Mega Field!"
  return
 fi
 aPlots=$($JQBIN '.updateblock.megafield.area | tostream | select(length == 2)  as [$key,$value] | if $key[-1] == "remain" and $value < 0 then ($key[-2] | tonumber) else empty end' $FARMDATAFILE)
 for iPlot in $aPlots; do
  iVehicleBought=$(checkMegaFieldEmptyHarvestDevice $iHarvestDevice $iVehicleBought)
  if [ $iVehicleBought -eq 2 ]; then
   return
  fi
  echo -n "Harvesting Mega Field plot ${iPlot}..."
  sendAJAXFarmRequestOverwrite "mode=megafield_tour&farm=1&position=1&set=${iPlot},|&vid=${iHarvestDevice}"
  echo "delaying ${iHarvestDelay} seconds"
  sleep ${iHarvestDelay}s
  # plant instantly
  startMegaField${NONPREMIUM} 1
 done
 if checkRipePlotOnMegaField; then
  harvestMegaField ${FARM} ${POSITION} 0
 fi
}

function startMegaField {
 local iSafetyCount=$1
 if [ -z "$iSafetyCount" ]; then
  return
  # no need to run through since insta-plant is default now.
  # calling functions deliver a value for iSafetyCount
 fi
 local iProductSlot
 local iPID
 local iAmountToGo
 local iAmount
 local iFreePlots
 if [ $iSafetyCount -gt 4 ] 2>/dev/null; then
  echo "Exiting startMegaField after four cycles!"
  return
 fi
 for iProductSlot in 0 1 2; do
  if ! checkMegaFieldProductIsHarvestable $iProductSlot ; then
   continue
  fi
  # here we've got a product that is harvestable
  iPID=$($JQBIN '.updateblock.megafield.job.products['$iProductSlot'].pid' $FARMDATAFILE)
  iAmount=$($JQBIN '.updateblock.megafield.job.products['$iProductSlot'].amount' $FARMDATAFILE)
  iAmountToGo=$(getMegaFieldAmountToGoInSlot $iProductSlot)
  if [ "$iAmountToGo" = "0" ]; then
   continue
   # no need to plant more
  fi
  iFreePlots=$(getMegaFieldFreePlotsCount)
  if [ $iFreePlots -eq 0 ]; then
   # no free plots, no need to plant
   return
  fi
  # plant
  if [ $iFreePlots -lt $iAmountToGo ]; then
   if checkMegaFieldPIDAmount $iPID $iFreePlots $iAmount; then
    # plant on all free plots
    megaFieldPlant${NONPREMIUM} $iPID $iFreePlots
   else
    echo "startMegaField: Cannot plant! Not enough crop in stock!"
   fi
   return
  fi
  if checkMegaFieldPIDAmount $iPID $iAmountToGo $iAmount; then
   megaFieldPlant${NONPREMIUM} $iPID $iAmountToGo
  else
   echo "startMegaField: Cannot plant! Not enough crop in stock!"
   return
  fi
  # call function again since there are still free plots
  iSafetyCount=$((iSafetyCount + 1))
  startMegaField $iSafetyCount
 done
}

function startMegaFieldNP {
 startMegaField
}

function checkMegaFieldPIDAmount {
 local iPID=$1
 local iFreePlots=$2
 local iAmount=$3
 local iAmountInStock=$(getPIDAmountFromStock $iPID 1)
 local iAmountNeeded=$((iFreePlots * iAmount))
 if [ $iAmountInStock -ge $iAmountNeeded ]; then
  return 0
 fi
 return 1
}

function harvestFuelStation {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iRealSlot=$(getRealSlotName $iFarm $iPosition $iSlot)
 sendAJAXFarmRequest "mode=fuelstation_harvest&farm=${iFarm}&position=${iPosition}&id=${iRealSlot}&slot=${iRealSlot}"
}

function startFuelStation {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iRealSlot=$(getRealSlotName $iFarm $iPosition $iSlot)
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
 sendAJAXFarmRequest "mode=fuelstation_entry&farm=${iFarm}&position=${iPosition}&id=${iSlot}&amount=${iAmount}&slot=${iSlot}&pid=${iPID}"
}

function startFuelStationNP {
 startFuelStation $1 $2 $3
}

function harvestWindMill {
 local iSlot=$3
 sendAJAXCityRequest "city=2&mode=windmillcrop&slot=${iSlot}"
}

function startWindMillNP {
 startWindMill $1 $2 $3
}

function startWindMill {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iPID=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 sendAJAXCityRequest "city=2&mode=windmillstartproduction&formula=${iPID}&slot=${iSlot}"
}

function doInfiniteQuest {
 local iCount
 local iPIDCount
 local aPID=()
 local aAmount=()
 local iTotalProductsNeeded=$($JQBIN '.updateblock.queststatus.infinite.data.quest.products | keys | length' $FARMDATAFILE)
 for iCount in $(seq 0 $((iTotalProductsNeeded - 1))); do
  # see if player has enuff in stock
  aPID+=($($JQBIN -r '.updateblock.queststatus.infinite.data.quest.products | keys['${iCount}']' $FARMDATAFILE))
  aAmount+=($($JQBIN '.updateblock.queststatus.infinite.data.quest.products["'${aPID[$iCount]}'"]' $FARMDATAFILE))
  iPIDCount=$(getPIDAmountFromStock ${aPID[$iCount]} 1)
  if [ $iPIDCount -lt ${aAmount[$iCount]} ]; then
   echo "Not enough goods for infinite quest"
   return 1
  fi
 done
 echo "Doing infinite quest..."
 for iCount in $(seq 0 $((iTotalProductsNeeded - 1))); do
  sendAJAXFarmRequest "pid=${aPID[$iCount]}&amount=${aAmount[$iCount]}&mode=infinitequestline_questentry"
 done
}

function harvestPonyFarm {
 local iFarm=$1
 local iPosition=$2
 local iSlot
 local iAnimalID
 getInnerInfoData $TMPFILE $iFarm $iPosition innerinfos
 local aAnimalIDs=$($JQBIN '.datablock[1].farmis | .[] | select(.data.remain < 0 and .data.remain != null).data.animalid' $TMPFILE)
 for iAnimalID in $aAnimalIDs; do
  iSlot=$($JQBIN '.datablock[1].ponys | .[] | select(.animalid == "'$iAnimalID'").data.position' $TMPFILE)
  sendAJAXFarmRequest "mode=pony_crop&farm=${iFarm}&position=${iPosition}&id=${iSlot}"
 done
}

function startPonyFarmNP {
 startPonyFarm $1 $2
}

function startPonyFarm {
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
  getInnerInfoData $TMPFILE $iFarm $iPosition innerinfos
  sBlocked=$($JQBIN '.datablock[1].ponys["'${iSlot}'"] | select(.block == null and .data.farmi == null).data.position' $TMPFILE)
  if [ -n "$sBlocked" ]; then
   # slot is unblocked and idle...
   iPony=$($JQBIN -r '.datablock[1].ponys["'${iSlot}'"].animalid' $TMPFILE)
   # refill food dispenser
   iFood=$($JQBIN '.datablock[1].ponys["'${iSlot}'"].data.feed' $TMPFILE)
   iFood=$((iMaxFood - iFood))
   sendAJAXFarmRequest "mode=pony_feed&farm=${iFarm}&position=${iPosition}&id=${iSlot}&pos=${iSlot}&amount=${iFood}"
   # find a farmie
   if [ $iSlot -ge 2 ]; then
    updateQueue ${iFarm} ${iPosition} 0
    if checkQueueSleep ${iFarm}/${iPosition}/0; then
     echo "Set to sleep"
     return
    fi
   fi
   iDuration=$(sed '2q;d' ${iFarm}/${iPosition}/0)
   iFarmie=$($JQBIN -r '.datablock[1].farmis | .[] | select(.status == "0" and .type == "'$iDuration'").id' $TMPFILE)
   if [ -z "$iFarmie" ]; then
    # something went wrong. bail out.
    return
   fi
   sendAJAXFarmRequest "mode=pony_setfarmi&farm=${iFarm}&position=${iPosition}&farmi=${iFarmie}&pony=${iPony}"
   # check for pony energy bar...
   if grep -q "useponyenergybar = 1" $CFGFILE; then
    iEnergyBarCount=$((iDuration / 2))
    sleep 2
    sendAJAXFarmRequest "mode=pony_speedup&farm=${iFarm}&position=${iPosition}&id=${iSlot}&pos=${iSlot}&amount=${iEnergyBarCount}"
   fi
  fi
 done
}

function startButterflies {
 local iSlot=$1
 sendAJAXFarmRequest "slot=${iSlot}&mode=butterfly_carebreed"
}

function checkButterflies {
 local aButterflies=$(getConfigValue autobuybutterflies)
 local iSlot=$1
 if [ $iSlot -ge 2 ]; then
  local bSlotExists=$($JQBIN '.updateblock.farmersmarket.butterfly.data.slots["'${iSlot}'"].time | type == "number"' $FARMDATAFILE)
  if [ "$bSlotExists" = "false" ]; then
   return
  fi
 fi
 local iMaxRepeat=10
 local iButterfly=$($JQBIN -r '.updateblock.farmersmarket.butterfly.data.breed["'${iSlot}'"]?.butterfly?' $FARMDATAFILE)
 if [ "$iButterfly" != "null" ] && [ -n "$iButterfly" ]; then
  # care_count1 is always 5 (needs 5 feedings to mature)
  local iMaxFeed=$($JQBIN '.updateblock.farmersmarket.butterfly.config.butterflies["'${iButterfly}'"].care_count2' $FARMDATAFILE)
  local iCurrentFeed=$($JQBIN -r '.updateblock.farmersmarket.butterfly.data.breed["'${iSlot}'"].count' $FARMDATAFILE)
  if [ $iCurrentFeed -lt 14 ]; then
   return
  fi
  local iReleaseValue
  # we're gonna release butterflies immediately BEFORE they reach the min. blossoms count
  case $iMaxFeed in
   10) iReleaseValue=15
       ;;
   15) iReleaseValue=19
       ;;
   20) iReleaseValue=24
       ;;
    *) logToFile "checkButterflies: Invalid iMaxFeed value"
       return
       ;;
  esac
  if [ $iCurrentFeed -ge $iReleaseValue ]; then
   echo "Releasing butterfly in slot ${iSlot}..."
   sendAJAXFarmRequestOverwrite "slot=${iSlot}&mode=butterfly_free"
   sleep 1
  else
   return
  fi
 fi
 echo -n "Trying to buy a butterfly in slot ${iSlot}..."
 while (true); do
  if [ $iMaxRepeat -eq 0 ]; then
   echo "failed"
   break
  fi
  if ! checkButterflyHouseSlotIsFree $iSlot; then
   break
  fi
#  echo "DEBUG: Buying egg for slot $iSlot ... Attempts left: $iMaxRepeat"
  echo -n "."
  sendAJAXFarmRequestOverwrite "slot=${iSlot}&id=2&mode=butterfly_startbreed"
  if checkButterflyMatch $iSlot "$aButterflies"; then
   sleep 1
   echo "success"
   getButterflyHouseDeco $iSlot
   break
  fi
#  echo "DEBUG: Removing egg..."
  sleep 1
  sendAJAXFarmRequestOverwrite "slot=${iSlot}&mode=butterfly_delete"
  iMaxRepeat=$((iMaxRepeat - 1))
  sleep 1
 done
}

function checkButterflyHouseSlotIsFree {
 # returns 0 (true) if slot is free
 local iSlot=$1
 local sSlotType
 sSlotType=$($JQBIN -r '.updateblock.farmersmarket.butterfly.data.breed["'${iSlot}'"]? | type' $FARMDATAFILE)
 if [ -z "$sSlotType" ] || [ "$sSlotType" = "null" ]; then
  return 0
 else
  return 1
 fi
}

function checkButterflyMatch {
 # returns 0 (true) if a desired butterfly was purchased
 local iSlot=$1
 local aButterfies=$2
 local iButterfly=$($JQBIN -r '.updateblock.farmersmarket.butterfly.data.breed["'${iSlot}'"]?.butterfly?' $FARMDATAFILE)
 local _iButterfly
 if [ "$iButterfly" = "null" ]; then
  logToFile "checkButterflyMatch: Error reading butterfly house slot ${iSlot}"
  return 1
 fi
 for _iButterfly in $aButterfies; do
  if [ $iButterfly -eq $_iButterfly ]; then
#   echo "DEBUG: Bought butterfly egg #${iButterfly} in slot ${iSlot}"
   return 0
  fi
 done
# echo "DEBUG: this butterfly is not welcome..."
 return 1
}

function getButterflyHouseDeco {
 local iSlot=$1
 local iButterfly=$($JQBIN -r '.updateblock.farmersmarket.butterfly.data.breed["'${iSlot}'"]?.butterfly?' $FARMDATAFILE)
 if [ "$iButterfly" = "null" ]; then
  # return if there's been an error
  return 0
 fi
 local bQuestIsString=$($JQBIN '.updateblock.farmersmarket.butterfly.data.last_questid? | type == "string"' $FARMDATAFILE)
 if [ "$bQuestIsString" = "false" ]; then
  logToFile "getButterflyHouseDeco: Cannot buy decoration"
  return
 fi
 local iQuest=$($JQBIN -r '.updateblock.farmersmarket.butterfly.data.last_questid?' $FARMDATAFILE)
 if [ $iQuest -lt 1 ]; then
  echo "You cannot buy any decoration (yet)"
  return
 fi
 if [ $iButterfly -ge 12 ] && [ $iButterfly -le 19 ]; then
  # Schmetterling ist tropisch
  if [ $iQuest -ge 35 ]; then
#   echo "DEBUG: Buying decoration for tropical butterfly..."
   sendAJAXFarmRequest "slot=${iSlot}&id=6&mode=butterfly_shopbuy"
   return
  else
   echo "You cannot buy decoration for tropical butterflies (yet)"
  fi
 fi
# echo "DEBUG: Brennessel kaufen..."
 sendAJAXFarmRequest "slot=${iSlot}&id=1&mode=butterfly_shopbuy"
}

function checkFarmies {
 local sFarmieType=$1
 local aFarmies
 local iID
 case "$sFarmieType" in
  farmie)
     aFarmies=$($JQBIN -r '.updateblock.farmis[0] | .[] | .id' $FARMDATAFILE)
     for iID in $aFarmies; do
      echo "Sending farmie with ID ${iID} away..."
      sendAJAXFarmRequest "mode=sellfarmi&farm=1&position=1&id=${iID}&farmi=${iID}&status=2"
     done
     ;;
  flowerfarmie)
     aFarmies=$($JQBIN -r '.updateblock.farmersmarket.farmis | .[] | .id' $FARMDATAFILE)
     for iID in $aFarmies; do
      echo "Sending flower farmie with ID ${iID} away..."
      sendAJAXFarmRequest "mode=handleflowerfarmi&farm=1&position=1&id=${iID}&farmi=${iID}&status=2"
     done
     ;;
  forestryfarmie)
     aFarmies=$($JQBIN -r '.datablock[5] | .[] | .farmiid' $FARMDATAFILE)
     for iID in $aFarmies; do
      echo "Sending forestry farmie with ID ${iID} away..."
      sendAJAXForestryRequest "action=kickfarmi&productid=${iID}"
     done
     ;;
  munchie)
     aFarmies=$($JQBIN -r '.datablock.farmis | .[] | .id' $FARMDATAFILE)
     for iID in $aFarmies; do
      echo "Sending munchie with ID ${iID} away..."
      sendAJAXFoodworldRequest "action=kick&id=${iID}&table=0&chair=0"
     done
     ;;
 esac
}

function checkVehiclePosition {
 local iFarm=$1
 local iRoute=$2
 local iVehicle
 local iCurrentVehiclePos
 echo -n "Transport vehicle for route $iRoute is "
 iVehicle=$(getConfigValue vehiclemgmt${iFarm})
 if ! $JQBIN -e '.updateblock.map.vehicles["'${iRoute}'"]["'${iVehicle}'"].remain' $FARMDATAFILE >/dev/null; then
  iCurrentVehiclePos=$($JQBIN -r '.updateblock.map.vehicles["'${iRoute}'"]["'$iVehicle'"].current' $FARMDATAFILE)
  if [ "$iCurrentVehiclePos" = "1" ]; then
   echo "on farm 1"
   checkSendGoodsOffMainFarm $iVehicle $iFarm $iRoute
  else
   echo "on farm $iCurrentVehiclePos"
   # check if sending a fully loaded vehicle is possible
   checkSendGoodsToMainFarm $iVehicle $iFarm $iRoute
  fi
 else
  echo "en route"
 fi
}

function checkSendGoodsToMainFarm {
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
 local iFieldsOnFarmCount=$(getFieldsOnFarmCount $iFarm)
 local aPositions=$($JQBIN -r '.updateblock.farms.farms["'${iFarm}'"] | .[] | select(.buildingid == "1" and .status == "1").position' $FARMDATAFILE)
 echo -n "Calculating transport count for route ${iRoute}..."
 case $iFarm in
  5) iPIDMin=351
     iPIDMax=361
     ;;
  6) iPIDMin=700
     iPIDMax=709
     ;;
  7) if ! grep -q "transO7 = 0" $CFGFILE && grep -q "transO7 = " $CFGFILE; then
      iPIDMin=$(getConfigValue transO7)
      iPIDMax=$iPIDMin
     else
      iPIDMin=998
      iPIDMax=998
     fi
     ;;
 esac
 aPIDs=$($JQBIN '.updateblock.stock.stock["'${iFarm}'"] | .[] | .[] | select((.pid | tonumber) >= '${iPIDMin}' and (.pid | tonumber) <= '${iPIDMax}').pid | tonumber' $FARMDATAFILE)
 for iPID in $aPIDs; do
  echo -n "."
  iPIDCount=$(getPIDAmountFromStock $iPID $iFarm)
  iSafetyCount=$(getProductCountFittingOnField $iPID)
  # do we have multiple fields on the current farm?
  # are they filled with crop we want to transport off?
  iFilledFieldCount=$(getFilledFieldCount $iFarm $iPID "$aPositions")
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
   sendAJAXFarmRequest "mode=map_sendvehicle&farm=${iFarm}&position=1&route=${iRoute}&vehicle=${iVehicle}&cart=${sCart}"
   return
  fi
  iVehicleSlotsUsed=$((iVehicleSlotsUsed + 1))
  sCart=${sCart}${iVehicleSlotsUsed},${iPID},${iPIDCount}_
  if [ $iVehicleSlotsUsed -eq $iVehicleSlotCount ]; then
   echo -e "\nSending partially loaded vehicle to main farm (no slots left)..."
   sendAJAXFarmRequest "mode=map_sendvehicle&farm=${iFarm}&position=1&route=${iRoute}&vehicle=${iVehicle}&cart=${sCart}"
   return
  fi
 done
 if [ $iTransportCount -lt 0 ]; then
  iTransportCount=0
 fi
 if ! checkQueueSleep city2/trans2${iFarm}/0; then
  echo -e "\nSending vehicle back empty (Queue is still busy)..."
  sendAJAXFarmRequest "mode=map_sendvehicle&farm=${iFarm}&position=1&route=${iRoute}&vehicle=${iVehicle}&cart="
 else
  echo -e "\n$iTransportCount/$iVehicleCapacity items available for transport on route ${iRoute}, no transport started"
 fi
}

function getProductCountFittingOnField {
 local iPID=$1
 # shellcheck disable=SC2090
 local iPIDDim_x=$(echo $aDIM_X | $JQBIN -r '."'${iPID}'"')
 # shellcheck disable=SC2090
 local iPIDDim_y=$(echo $aDIM_Y | $JQBIN -r '."'${iPID}'"')
 echo $((120 / (iPIDDim_x * iPIDDim_y)))
}

function getFieldsOnFarmCount {
 local iFarm=$1
 local iFieldsOnFarm=$($JQBIN '.updateblock.farms.farms["'${iFarm}'"] | .[] | select(.buildingid == "1" and .status == "1").position' $FARMDATAFILE | wc -l)
 echo $iFieldsOnFarm
}

function checkSendGoodsOffMainFarm {
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
  if checkQueueSleep city2/${iPosition}/0; then
   echo "Sending $iTransportCount items to farm ${iFarm}..."
   sendAJAXFarmRequest "mode=map_sendvehicle&farm=1&position=1&route=${iRoute}&vehicle=${iVehicle}&cart=${sCart}"
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
   sendAJAXFarmRequest "mode=map_sendvehicle&farm=1&position=1&route=${iRoute}&vehicle=${iVehicle}&cart=${sCart}"
   updateQueue city2 ${iPosition} 0
   return
  fi
  if [ $iVehicleSlotsUsed -eq $iVehicleSlotCount ]; then
   echo "Sending partially loaded vehicle to farm ${iFarm} (no slots left)..."
   sendAJAXFarmRequest "mode=map_sendvehicle&farm=1&position=1&route=${iRoute}&vehicle=${iVehicle}&cart=${sCart}"
   updateQueue city2 ${iPosition} 0
   return
  fi
  updateQueue city2 ${iPosition} 0
 done
}

function checkPowerUps {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 if checkQueueSleep ${iFarm}/${iPosition}/${iSlot}; then
  return
 fi
 local iActivePowerUp
 local iCount
 local iPowerUp=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 local iActivePowerUps=$($JQBIN '.updateblock.farms.powerups.active | keys | length' $FARMDATAFILE)
 if [ $iActivePowerUps -eq 0 ]; then
  echo "Activating power-up #${iPowerUp}..."
  sendAJAXFarmRequest "mode=activatepowerup&farm=1&position=1&id=${iPowerUp}&formula=${iPowerUp}"
  updateQueue ${iFarm} ${iPosition} ${iSlot}
  return
 else
  # there are active powerups
  for iCount in $(seq 0 $((iActivePowerUps - 1))); do
   iActivePowerUp=$($JQBIN -r '.updateblock.farms.powerups.active | keys['$iCount']' $FARMDATAFILE)
   if [ $iActivePowerUp -eq $iPowerUp ]; then
    echo "Requested power-up #${iPowerUp} is already in use"
    return
   fi
  done
  echo "Activating power-up #${iPowerUp}..."
  sendAJAXFarmRequest "mode=activatepowerup&farm=1&position=1&id=${iPowerUp}&formula=${iPowerUp}"
  updateQueue ${iFarm} ${iPosition} ${iSlot}
 fi
}

 function checkTools {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 if checkQueueSleep ${iFarm}/${iPosition}/${iSlot}; then
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
  sendAJAXGuildRequest "mode=job_set_tool&pid=${iTool}"
  updateQueue ${iFarm} ${iPosition} ${iSlot}
  return
 fi
}

function updateQueue {
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

function checkQueueSleep {
 local sFile=$1
 local sQueueItem=$(sed '2q;d' $sFile)
 if [ "$sQueueItem" = "sleep" ] || [ -z "$sQueueItem" ]; then
  return 0
 fi
 return 1
}

function checkCanWaterTrees {
 local bCanWaterTrees=$($JQBIN '.datablock[9]?' $FARMDATAFILE)
 if [ "$bCanWaterTrees" = "1" ]; then
  return 0
 else
  return 1
 fi
}

function checkRipePlotOnField {
 # returns true if at least one plot is ripe
 local iFarm=$1
 local iPosition=$2
 getInnerInfoData $TMPFILE $iFarm $iPosition gardeninit
 local bHasRipePlots=$($JQBIN '[.datablock[1] | .[] | select(.phase? == 4 and (.buildingid == "v" or .buildingid == "ex" or .buildingid == "alpin"))][0] | type == "object"' $TMPFILE)
 if [ "$bHasRipePlots" = "true" ]; then
  return 0
 fi
 return 1
}

function checkRunningMegaFieldJob {
 local iJobEnd=$($JQBIN -r '.updateblock.megafield.job_endtime' $FARMDATAFILE)
 local iJobStart=$($JQBIN -r '.updateblock.megafield.job_start' $FARMDATAFILE)
 if [ $iJobStart -gt 0 ] && [ $iJobEnd -eq 0 ]; then
  return 0
 fi
 return 1
}

function checkRipePlotOnMegaField {
 # returns true if a plot shows a negative remainder
 local bHasNegatives=$($JQBIN '[.updateblock.megafield.area | .[] | select(.remain < 0)][0] | type == "object"' $FARMDATAFILE)
 if [ "$bHasNegatives" = "true" ]; then
  return 0
 fi
 return 1
}

function getUnlockedMegaFieldPlotCount {
 local iUnlockedPlots=$($JQBIN '.updateblock.megafield.area_free | length' $FARMDATAFILE)
 # we always have a positive number here
 echo $iUnlockedPlots
}

function getMegaFieldHarvesterDelay {
 local iHarvestDevice=$1
 local iHarvesterDelay=$($JQBIN '.updateblock.megafield.vehicle_slots["'${iHarvestDevice}'"].duration // 0' $FARMDATAFILE)
 if [ $iHarvesterDelay -eq 0 ]; then
  logToFile "getMegaFieldHarvesterDelay: Unknown harvest device"
 fi
 echo $iHarvesterDelay
}

function checkMegaFieldEmptyHarvestDevice {
 local iHarvestDevice=$1
 local iVehicleBought=$2
 local bIsCoinItem
 local bDurability=$($JQBIN '.updateblock.megafield.vehicles["'${iHarvestDevice}'"]?.durability | type == "number"' $FARMDATAFILE)
 # if no vehicle is available, the query returns an empty array which can't be indexed
 # hence the -z test. don't remove it :)
 if [ "$bDurability" = "false" ] || [ -z "$bDurability" ]; then
  if [ $iVehicleBought -eq 0 ]; then
   bIsCoinItem=$($JQBIN '.updateblock.megafield.vehicle_slots["'${iHarvestDevice}'"].coins? | type == "number"' $FARMDATAFILE)
   if [ "$bIsCoinItem" = "true" ]; then
    logToFile "checkMegaFieldEmptyHarvestDevice: refusing to buy coin item"
    echo 2
    return
   fi
   # buy a brand new one if empty
   echo "Buying new vehicle #${iHarvestDevice}..." >&2 # this is very ugly.
   sendAJAXFarmRequest "mode=megafield_vehicle_buy&farm=1&position=1&id=${iHarvestDevice}&vid=${iHarvestDevice}"
   echo 1
   return
  else
   logToFile "checkMegaFieldEmptyHarvestDevice: Not buying new vehicle since it's already been bought this iteration!"
   echo 1
   return
  fi
 else
  echo 0
 fi
}

function checkMegaFieldProductIsHarvestable {
 local iProductSlot=$1
 local iIsHarvestable=$($JQBIN '.updateblock.megafield.job.products['$iProductSlot'].harvest' $FARMDATAFILE)
 if [ "$iIsHarvestable" = "1" ]; then
  return 0
 fi
 return 1
}

function getMegaFieldAmountToGoInSlot {
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

function getMegaFieldFreePlotsCount {
 local iTotalPlots=$($JQBIN '.updateblock.megafield.area_free | length' $FARMDATAFILE)
 local iBusyPlots=$($JQBIN '.updateblock.megafield.area | length' $FARMDATAFILE)
 echo $((iTotalPlots - iBusyPlots))
}

function megaFieldPlantNP {
 local iPID=$1
 local iFreePlots=$2
 local iCount=1
 local iCount2=0
 local bPlotOccupied
 local iUnlockedPlotsCount=$(getUnlockedMegaFieldPlotCount)
 while [ "$iCount" -le "$iFreePlots" ]; do
   while [ "$iCount2" -lt "$iUnlockedPlotsCount" ]; do
    sUnlockedPlotName=$($JQBIN -r '.updateblock.megafield.area_free | keys['$iCount2']' $FARMDATAFILE)
    bPlotOccupied=$($JQBIN '.updateblock.megafield.area["'$sUnlockedPlotName'"]? | type == "object"' $FARMDATAFILE)
    # if all the plots are free, the query returns an empty array which can't be indexed
    # hence the -z test. don't remove it ;)
    if [ "$bPlotOccupied" = "false" ] || [ -z "$bPlotOccupied" ]; then
     # plot is free, plant stuff on it
     echo "Planting item ${iPID} on Mega Field plot ${sUnlockedPlotName}..."
     sendAJAXFarmRequestOverwrite "mode=megafield_plant&farm=1&position=1&set=${sUnlockedPlotName}_${iPID}|"
     iCount2=$((iCount2 + 1))
     break
    fi
    iCount2=$((iCount2 + 1))
   done
  iCount=$((iCount + 1))
 done
}

function megaFieldPlant {
 # new premium function after changes made by upjers 09.02.2016
 local iPID=$1
 local iAmount=$2
 echo "Planting item ${iPID} on ${iAmount} Mega Field plot(s)..."
 sendAJAXFarmRequestOverwrite "mode=megafield_autoplant&farm=1&position=1&id=${iPID}&pid=${iPID}"
}

function harvestMegaField2x2 {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iHarvestDevice=$4
 local iPlot=1
 local iVehicleBought=0
 iHarvestDelay=$(getMegaFieldHarvesterDelay $iHarvestDevice)
 if [ $iHarvestDelay -eq 0 ]; then
  echo "Stopping work on Mega Field!"
  return
 fi
 while (true); do
  if [ $iPlot -gt 87 ]; then
   return
  fi
  iVehicleBought=$(checkMegaFieldEmptyHarvestDevice $iHarvestDevice $iVehicleBought)
  if [ $iVehicleBought -eq 2 ]; then
   return
  fi
  if ! ((iPlot % 11)); then
   iPlot=$((iPlot + 1))
   # prevent harvesting of last column
  fi
  if checkTimeRemaining '.updateblock.megafield.area["'$iPlot'"]?.remain'; then
   if checkTimeRemaining '.updateblock.megafield.area["'$((iPlot + 1))'"]?.remain'; then
    if checkTimeRemaining '.updateblock.megafield.area["'$((iPlot + 11))'"]?.remain'; then
     if checkTimeRemaining '.updateblock.megafield.area["'$((iPlot + 12))'"]?.remain'; then
      echo -n "Harvesting Mega Field plots ${iPlot}, $((iPlot + 1)), $((iPlot + 11)), $((iPlot + 12))..."
      sendAJAXFarmRequestOverwrite "mode=megafield_tour&farm=1&position=1&set=${iPlot},$((iPlot + 1)),$((iPlot + 11)),$((iPlot + 12)),|&vid=${iHarvestDevice}"
      echo "delaying ${iHarvestDelay} seconds"
      sleep ${iHarvestDelay}s
      # plant instantly
      startMegaField${NONPREMIUM} 1
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

function getAnimalQueueLength {
 local iAnimalQueueLength=$($JQBIN '.updateblock.farmersmarket.vet.animals.queue | length' $FARMDATAFILE)
 return $iAnimalQueueLength
}

function getAnimalsFastestCureForDisease {
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
   *) logToFile "getAnimalsFastestCureForDisease: Unknown disease id"
      echo 0
      ;;
 esac
}

function getRealSlotName {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 local iSlotName
 iSlotName=$($JQBIN -r '.updateblock.farms.farms["'${iFarm}'"]["'${iPosition}'"].production['${iSlot}'].slot' $FARMDATAFILE)
 echo $iSlotName
}

function getFieldPlotReadiness {
 # returns 0 if a plot is not occupied in any way
 local iPlot=$1
 local sResult=$($JQBIN '.datablock[1] | .[] | select(.teil_nr? == "'$iPlot'") | type == "object"' $TMPFILE)
 if [ -z "$sResult" ]; then
  return 0
 else
  return 1
 fi
}

function getFilledFieldCount {
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
   getInnerInfoData "$sTmpFile" $iFarm $iPosition gardeninit
  fi
  iPIDCount=$($JQBIN '.datablock[1] | map([select(.teil_nr? and .inhalt == "'${iPID}'")]) | [.[] | select(length > 0)] | length' "$sTmpFile")
  if [ $iPIDCount -eq 120 ]; then
   iFilledFields=$((iFilledFields + 1))
  fi
 done
 echo $iFilledFields
}

function checkQueueCount {
 local iFarm=$1
 local iPosition=$2
 local iBuildingID=$3
 local iQueuesInFS=$(getQueueCountInFS $iFarm $iPosition)
 local iMaxQueueCount=$(getMaxQueuesForBuildingID $iBuildingID)
 local iQueuesInGame
 if [ $iQueuesInFS -gt $iMaxQueueCount ]; then
  echo "Reducing position $iPosition to $iMaxQueueCount Queue(s)..."
  reduceQueuesOnPosition $iFarm $iPosition $iMaxQueueCount
  iQueuesInFS=$(getQueueCountInFS $iFarm $iPosition)
 fi
 # queues are capped to the max. possible value
 # from here we'll handle multi-q buildings
 case "$iBuildingID" in
  13|14|16|21) iQueuesInGame=$(getQueueCountFromInnerInfo $iFarm $iPosition)
      ;;
  20) iQueuesInGame=$(getQueueCount20 $iFarm $iPosition)
      ;;
   *) iQueuesInGame=1
      ;;
 esac
 if [ "$iQueuesInFS" -lt "$iQueuesInGame" ]; then
  echo "Adding $((iQueuesInGame - iQueuesInFS)) Queue(s) to position $iPosition..."
  addQueuesToPosition $iFarm $iPosition $iQueuesInFS $iQueuesInGame
 fi
 if [ "$iQueuesInFS" -gt "$iQueuesInGame" ]; then
  echo "Reducing position $iPosition to $iQueuesInGame Queue(s)..."
  reduceQueuesOnPosition $iFarm $iPosition $iQueuesInGame
 fi
}

function getQueueCountInFS {
 local iFarm=$1
 local iPosition=$2
 local iQueueCount
 iQueueCount=$(ls -ld ${iFarm}/${iPosition}/* | wc -l)
 echo $iQueueCount
}

function getMaxQueuesForBuildingID {
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

function reduceQueuesOnPosition {
 local iFarm=$1
 local iPosition=$2
 local iMaxQ=$3
 local iQueueCount=$(ls -ld ${iFarm}/${iPosition}/* | wc -l)
 local iQDel=$((iQueueCount - iMaxQ))
 rm $(ls -d1 ${iFarm}/${iPosition}/* | tail -${iQDel})
}

function getQueueCountFromInnerInfo {
 local iFarm=$1
 local iPosition=$2
 local iCount
 local iSlots=1
 local iBlocked
 getInnerInfoData $TMPFILE $iFarm $iPosition innerinfos
 # these buildings always have at least one slot. we'll check slots 2 and 3...
 for iCount in 2 3; do
  iBlocked=$($JQBIN '.datablock[1]["slots"]["'${iCount}'"].block?' $TMPFILE 2>/dev/null)
  if [ $iBlocked -eq 0 ]; then
   iSlots=$((iSlots + 1))
  fi
 done
 echo $iSlots
}

function getQueueCount20 {
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

function addQueuesToPosition {
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
   iType=$($JQBIN -r '.updateblock.farmersmarket.pets.packs | keys['$iCount']' $FARMDATAFILE)
   iPackCount=$($JQBIN -r '.updateblock.farmersmarket.pets.packs["'$iType'"]' $FARMDATAFILE)
   echo "Redeeming $iPackCount puzzle parts pack(s) of type ${iType}..."
   for iCount2 in $(seq 1 $iPackCount); do
    sendAJAXFarmRequest "mode=pets_open_pack&type=${iType}"
   done
  done
 fi
}

function checkPanBonus {
 # function by jbond47, update by maiblume & jbond47
 getPanData "$FARMDATAFILE"
 local iToday=$($JQBIN '.datablock["11"].today' $FARMDATAFILE)
 local iSheepCount=$($JQBIN '.datablock["11"].collections.heros | length' $FARMDATAFILE)
 local iLastBonus
 local bValue
 # Hero Sheep Bonus
 if [ $iSheepCount -eq 12 ]; then # requires all 12 super sheep
  iLastBonus=$($JQBIN '.datablock["11"].lastbonus.heros' $FARMDATAFILE)
  if [ $iLastBonus = "null" ]; then
   iLastBonus=0
  fi
  echo -n "Hero sheep..."
  if [ $iToday -gt $iLastBonus ]; then
   echo "available, claiming it..."
   sendAJAXFarmRequest "type=heros&mode=paymentitemcollection_bonus"
  else
   echo "already claimed"
  fi
 fi
 # Horror Sheep Bonus
 iSheepCount=$($JQBIN '.datablock["11"].collections.horror | length' $FARMDATAFILE)
 if [ $iSheepCount -eq 9 ]; then # requires all 9 horror sheep
  iLastBonus=$($JQBIN '.datablock["11"].lastbonus.horror' $FARMDATAFILE)
  if [ $iLastBonus = "null" ]; then
   iLastBonus=0
  fi
  echo -n "Horror sheep..."
  if [ $iToday -gt $iLastBonus ]; then
   echo "available, claiming it..."
   sendAJAXFarmRequest "type=horror&mode=paymentitemcollection_bonus"
  else
   echo "already claimed"
  fi
 fi
 # Sport Sheep Bonus
 iSheepCount=$($JQBIN '.datablock["11"].collections.sport | length' $FARMDATAFILE)
 if [ $iSheepCount -eq 9 ]; then # requires all 9 sport sheep
  iLastBonus=$($JQBIN '.datablock["11"].lastbonus.sport' $FARMDATAFILE)
  if [ $iLastBonus = "null" ]; then
   iLastBonus=0
  fi
  echo -n "Sport sheep..."
  if [ $iToday -gt $iLastBonus ]; then
   echo "available, claiming it..."
   sendAJAXFarmRequest "type=sport&mode=paymentitemcollection_bonus"
  else
   echo "already claimed"
  fi
 fi
 # Beach Sheep Bonus
 iSheepCount=$($JQBIN '.datablock["11"].collections.beach | length' $FARMDATAFILE)
 if [ $iSheepCount -eq 9 ]; then # requires all 9 beach sheep
  iLastBonus=$($JQBIN '.datablock["11"].lastbonus.beach' $FARMDATAFILE)
  if [ $iLastBonus = "null" ]; then
   iLastBonus=0
  fi
  echo -n "Beach sheep..."
  if [ $iToday -gt $iLastBonus ]; then
   echo "available, claiming it..."
   sendAJAXFarmRequest "type=beach&mode=paymentitemcollection_bonus"
  else
   echo "already claimed"
  fi
 fi
 # Fantasy Sheep Bonus
 iSheepCount=$($JQBIN '.datablock["11"].collections.fantasy | length' $FARMDATAFILE)
 if [ $iSheepCount -eq 9 ]; then # requires all 9 fantasy sheep
  iLastBonus=$($JQBIN '.datablock["11"].lastbonus.fantasy' $FARMDATAFILE)
  if [ $iLastBonus = "null" ]; then
   iLastBonus=0
  fi
  echo -n "Fantasy sheep..."
  if [ $iToday -gt $iLastBonus ]; then
   echo "available, claiming it..."
   sendAJAXFarmRequest "type=fantasy&mode=paymentitemcollection_bonus"
  else
   echo "already claimed"
  fi
 fi
 # Portal Rabbit Points
 bValue=$($JQBIN '.datablock["1"].gifts | has("289")' $FARMDATAFILE)
 if [ "$bValue" = "true" ]; then
  echo -n "Portal rabbit..."
  bValue=$($JQBIN '.datablock["1"].gifts."289" | has("giver")' $FARMDATAFILE)
  if [ "$bValue" = "true" ]; then
   echo "available, claiming it..."
   sendAJAXCityRequest "city=0&mode=giverpresent&id=289"
  else
   echo "already claimed"
  fi
 fi
 # Bug Rogers Points
 bValue=$($JQBIN '.datablock["1"].gifts | has("410")' $FARMDATAFILE)
 if [ "$bValue" = "true" ]; then
  echo -n "Bug Rogers..."
  bValue=$($JQBIN '.datablock["1"].gifts."410" | has("giver")' $FARMDATAFILE)
  if [ "$bValue" = "true" ]; then
   echo "available, claiming it..."
   sendAJAXCityRequest "city=0&mode=giverpresent&id=410"
  else
   echo "already claimed"
  fi
 fi
}

function checkStockRefill {
 local iPID
 local iCanBuyPID
 local iAmountInStock
 local iAmountToBuy
 local bRackIsPresent=$($JQBIN '.updateblock.stock.stock["1"] | type == "object"' $FARMDATAFILE)
 local aPIDs=$(getConfigValue autobuyitems)
 local iRefillAmount=$(getConfigValue autobuyrefillto)
 local iLowerThreshold=$((iRefillAmount / 2))
 # prevent unwanted purchase, i.e. in case of network problems
 if [ "$bRackIsPresent" = "false" ]; then
  # something is very wrong if rack 1 is missing
  # abort silently
  return
 fi
 for iPID in $aPIDs; do
  iAmountInStock=$(getPIDAmountFromStock $iPID 1)
  if [ $iAmountInStock -ge $iLowerThreshold ]; then
   continue
  fi
  # lower threshold reached, prepare purchase
  getMerchantData $TMPFILE
  iAmountToBuy=$((iRefillAmount - iAmountInStock))
  if [ $iAmountToBuy -eq $iRefillAmount ]; then
   # in order to prevent erroneous purchases, player needs to own at least one item
   logToFile "checkStockRefill: refusing to buy $iAmountToBuy items of item #${iPID}"
   continue
  fi
  # check, if player can buy the item
  iCanBuyPID=$($JQBIN '.datablock[1].products | .[] | select(.pid == '${iPID}').pid?' $TMPFILE)
  if [ -z "$iCanBuyPID" ]; then
   echo "Sorry, you cannot buy item #${iPID} yet"
   continue
  fi
  echo "Buying $iAmountToBuy of item #${iPID}..."
  sendAJAXCityRequest "shopid=1&mode=shopfire&cart=${iPID},${iAmountToBuy}"
  sleep 2
 done
}

function checkButterflyBonus {
 local iToday=$($JQBIN '.updateblock.farmersmarket.butterfly.data.today' $FARMDATAFILE)
 local aKeys
 local iKey
 aKeys=$($JQBIN '.updateblock.farmersmarket.butterfly.data.free | tostream | select(length == 2) as [$key,$value] | if $key[-1] == "last" and ($value < '$iToday' or $value == null) then ($key[-2] | tonumber) else empty end' $FARMDATAFILE)
 if [ -n "$aKeys" ]; then
  if [ "$NONPREMIUM" != "NP" ]; then
   # premium
   echo "Collecting butterfly points bonus..."
   sendAJAXFarmRequest "mode=butterfly_click_all"
   return
  else
   # non-premium
   for iKey in $aKeys; do
    echo "Collecting points bonus from butterfly type ${iKey}..."
    sendAJAXFarmRequest "id=${iKey}&mode=butterfly_click"
   done
  fi
 fi
}

function checkDogBonus {
 local bDogExists=$($JQBIN '.updateblock.menue.farmdog == 1' $FARMDATAFILE)
 local bDogDone=$($JQBIN '.updateblock.menue.farmdog_harvest == 1' $FARMDATAFILE)
 if [ "$bDogExists" = "true" ] && [ "$bDogDone" = "false" ]; then
  echo "not yet claimed, activating it..."
  sendAJAXFarmRequest "mode=dogbonus&farm=1&position=0"
  # reduce pause time by 300 secs after claiming the dogs' time bonus
  PAUSETIME=$((PAUSETIME - 300))
 else
  echo "already claimed"
 fi
}

function checkDonkeyBonus {
 local bDonkeyExists=$($JQBIN '.updateblock.menue.donkey == 1' $FARMDATAFILE)
 if [ "$bDonkeyExists" = "true" ]; then
  echo -n "Checking if it's time for the daily donkey bonus..."
  if [ $SECONDS -gt 86400 ] || [ $DONKEYCLAIMED -eq 0 ]; then
   echo "it is, claiming it..."
   sendAJAXFarmRequest "mode=dailydonkey&farm=1&position=1"
   SECONDS=0
   DONKEYCLAIMED=1
  else
   echo "it's not"
  fi
 fi
}

function checkPuzzleParts {
 local bPartsAvailable=$($JQBIN '.updateblock.farmersmarket.pets.daily == 1' $FARMDATAFILE)
 if [ "$bPartsAvailable" = "true" ]; then
  echo "available, buying it..."
  sendAJAXFarmRequest "mode=pets_buy_parts&id=1&amount=1"
 else
  echo "already bought"
 fi
}

function checkLottery {
 getLotteryData $FARMDATAFILE
 local iLot
 local bLotstatus=$($JQBIN '.datablock[2] == 0' $FARMDATAFILE)
 if [ "$bLotstatus" = "true" ]; then
  iLot=$(getConfigValue dolot)
  echo -n "not yet claimed, getting it"
  sendAJAXCityRequest "city=2&mode=newlot"
  if [ $iLot -eq 2 ]; then
   echo " and trading it for an instant-win..."
   sleep 1
   sendAJAXCityRequest "city=2&mode=lotgetprize"
  else
   echo "..."
  fi
 else
  echo "already claimed"
 fi
}

function checkDeliveryEvent {
 local iPointsNeeded
 local iPointsAvailable
 local bDeliveryEventRunning=$($JQBIN '.updateblock.menue.deliveryevent != 0' $FARMDATAFILE)
 if [ "$bDeliveryEventRunning" = "false" ]; then
  return
 fi
 iPointsNeeded=$($JQBIN '.updateblock.menue.deliveryevent.config.spots | .[] | select(.points <= 250).points' $FARMDATAFILE)
 if checkTimeRemaining '.updateblock.menue.deliveryevent.data.tour.remain'; then
  iPointsAvailable=$($JQBIN '.updateblock.menue.deliveryevent.data["points"]' $FARMDATAFILE)
  if [ $iPointsAvailable -ge $iPointsNeeded ] 2>/dev/null; then
   echo "Starting one-hour delivery tour..."
   sendAJAXFarmRequest "spot=playground&mode=deliveryevent_starttour"
  else
   echo "Not enough points to start delivery tour"
  fi
 fi
}

function checkOlympiaEvent {
 getOlympiaData $FARMDATAFILE
 local iBerriesNeeded=20
 local iBerriesAvailable
 local iEnergy
 local iOlympiayEventRemain=$($JQBIN '.datablock.remain?' $FARMDATAFILE)
 if [ $iOlympiayEventRemain -gt 0 ] 2>/dev/null; then
  iBerriesAvailable=$($JQBIN '.datablock.data.berries' $FARMDATAFILE)
  iEnergy=$($JQBIN '.datablock.energy' $FARMDATAFILE)
  if [ $iEnergy -lt 100 ] && [ $iBerriesAvailable -ge $iBerriesNeeded ]; then
   echo "Re-filling 10% energy..."
   sendAJAXMainRequest "amount=10&action=olympia_entry"
  fi
 fi
}

function checkCalendarEvent {
 local iDay
 local iEventDaysCount
 local bPresentCollected
 getCalendarData $TMPFILE
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
 sendAJAXFarmRequest "field=${iDay}&mode=calendar_openfield"
}

function checkLoginBonus {
 local iLoginCount=$($JQBIN '.updateblock.menue.loginbonus.data.count?' $FARMDATAFILE)
 local bLoginBonusDone=$($JQBIN '.updateblock.menue.loginbonus.data.rewards["'$iLoginCount'"].done > 0' $FARMDATAFILE)
 local bLoginBonusActive=$($JQBIN '.updateblock.menue.loginbonus.data.bonus.remain > 0' $FARMDATAFILE)
 local iPID
 if [ "$bLoginBonusDone" = "false" ]; then
  if [ $iLoginCount -eq 7 ] && [ "$bLoginBonusActive" = "false" ]; then
   iPID=$(getConfigValue dologinbonus)
   echo "not yet claimed, activating points bonus for plant #${iPID}..."
   sendAJAXFarmRequest "pid=${iPID}&mode=loginbonus_setplant"
  else
   if [ $iLoginCount -le 6 ]; then
    echo "not yet claimed, getting it for day ${iLoginCount}..."
    sendAJAXFarmRequest "day=${iLoginCount}&mode=loginbonus_getreward"
   else
    echo "not claiming it yet since points bonus is still active"
   fi
  fi
 else
  echo "already claimed"
 fi
}

function checkFruitStall {
 local iSlot=$1
 local iStall=$2
 local iTemp
 if [ $iStall -eq 2 ]; then
  iTemp=2
 fi
 local iPID=$(getConfigValue fruitstall${iTemp}slot${iSlot})
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
  local sSlotType=$($JQBIN -r '.updateblock.map.stall.data["'${iStall}'"].reward | type' $FARMDATAFILE 2>/dev/null)
  if [ "$sSlotType" = "object" ]; then
   echo "Collecting fruit stall ${iStall} reward..."
   sendAJAXFarmRequestOverwrite "position=${iStall}&mode=stall_get_reward" && sleep 1
  fi
  sSlotType=$($JQBIN -r '.updateblock.map.stall.data["'${iStall}'"].slots["'${iSlot}'"].amount? | type' $FARMDATAFILE 2>/dev/null)
  if [ "$sSlotType" != "number" ]; then
   # refill slot
   iLevel=$($JQBIN '.updateblock.map.stall.data["'${iStall}'"].level' $FARMDATAFILE)
   iAmount=$($JQBIN '.updateblock.map.stall.config.level["'${iStall}'"]["'${iLevel}'"].fillsum' $FARMDATAFILE)
   echo "Posting ${iAmount} items to fruit stall ${iStall}, slot ${iSlot}..."
   sendAJAXFarmRequest "position=${iStall}&slot=${iSlot}&pid=${iPID}&amount=${iAmount}&mode=stall_fill_slot"
  fi
  # boosters are not taken into account - or are they? ;)
  iLastFarmieEpoch=$($JQBIN -r '.updateblock.map.stall.data["'${iStall}'"].farmi_last' $FARMDATAFILE)
  iNextFarmieEpoch=$((iLastFarmieEpoch + iFarmieInterval))
  iCurrentEpoch=$(date +"%s")
  iSecsToNextFarmie=$((iNextFarmieEpoch - iCurrentEpoch))
  if [ $iSecsToNextFarmie -gt 0 ] 2>/dev/null && [ $iSecsToNextFarmie -lt $PAUSETIME ] 2>/dev/null; then
   PAUSETIME=$iSecsToNextFarmie
   PAUSECORRECTEDAT=$(date +"%s")
  fi
 fi
}

function checkActiveGuildJobForPlayer {
 local iActiveGuildJob=$($JQBIN '.updateblock.job.guild_job_data | length' $FARMDATAFILE)
 if [ $iActiveGuildJob -gt 0 ]; then
  # guild job is running and player is taking part
  return 0
 fi
 return 1
}

function removeWeed {
 local iFarm=$1
 local iPosition=$2
 local bIsActiveField
 local iPlot
 local aPlots
 bIsActiveField=$($JQBIN -r '.updateblock.farms.farms["'${iFarm}'"]["'${iPosition}'"] | .buildingid == "1" and .status == "1"' $FARMDATAFILE)
 if [ "$bIsActiveField" = "true" ]; then
  getInnerInfoData $TMPFILE $iFarm $iPosition gardeninit
  aPlots=$($JQBIN -r '.datablock[1] | .[]? | select(.buildingid? == "u").teil_nr?' $TMPFILE)
  if [ -n "$aPlots" ]; then
   echo -n "Removing weed on farm ${iFarm}, position ${iPosition}..."
   for iPlot in $aPlots; do
    sendAJAXFarmRequest "mode=garden_removeweed&farm=${iFarm}&position=${iPosition}&id=${iPlot}&tile=${iPlot}"
    echo -n "."
   done
   echo
  fi
 fi
}

function checkLoginNews {
 # checks for news to be displayed upon login
 # marks it/them as read
 # this prevents news popups in running browser sessions
 local iNews
 local aNews=$($JQBIN -r '.updateblock.menue.news? | .[]? | select(.login == "1").nnr' $FARMDATAFILE)
 # you've guessed it: globbing is needed here :)
 for iNews in $aNews; do
  # echo "Marking news #${iNews} as read..."
  sendAJAXMainRequest "nnr=${iNews}&opt1=1&action=setnewsunread"
 done
}

function checkTimeRemaining {
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

function getPIDAmountFromStock {
 # returns the amount of items found in stock on a given farm
 local iPID=$1
 local iFarm=$2
 local iPIDCount=$($JQBIN '(.updateblock.stock.stock["'${iFarm}'"] | .[] | .[] | select(.pid? == "'${iPID}'").amount | tonumber) // 0' $FARMDATAFILE)
 echo $iPIDCount
}

function getConfigValue {
 local sConfigItem=$1
 local sConfigLine=$(grep -m1 "$sConfigItem " $CFGFILE | tr -d "'")
 echo ${sConfigLine/$sConfigItem = /}
}

function sendAJAXFarmRequest {
 local sAJAXSuffix=$1
 WGETREQ ${AJAXFARM}${sAJAXSuffix}
}

function sendAJAXFarmRequestOverwrite {
 local sAJAXSuffix=$1
 wget -nv -T10 -a $LOGFILE --output-document=$FARMDATAFILE --user-agent="$AGENT" --load-cookies $COOKIEFILE ${AJAXFARM}${sAJAXSuffix}
 # need to keep farm data file up to date here
}

function sendAJAXForestryRequest {
 local sAJAXSuffix=$1
 WGETREQ ${AJAXFOREST}${sAJAXSuffix}
}

function sendAJAXFoodworldRequest {
 local sAJAXSuffix=$1
# keep food world status current. this shouldn't break anything
wget -nv -T10 -a $LOGFILE --output-document=$FARMDATAFILE --user-agent="$AGENT" --load-cookies $COOKIEFILE ${AJAXFOOD}${sAJAXSuffix}
}

function sendAJAXCityRequest {
 local sAJAXSuffix=$1
 WGETREQ ${AJAXCITY}${sAJAXSuffix}
}

function sendAJAXMainRequest {
 local sAJAXSuffix=$1
 WGETREQ ${AJAXMAIN}${sAJAXSuffix}
}

function sendAJAXGuildRequest {
 local sAJAXSuffix=$1
 WGETREQ ${AJAXGUILD}${sAJAXSuffix}
}

function logToFile {
 local sText="$1"
 echo "$(date '+%F %X') $sText" | tee -a $LOGFILE >&2
}
