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
AJAXFARM="http://s${MFFSERVER}.myfreefarm.de/ajax/farm.php?rid=${RID}&"
AJAXFOREST="http://s${MFFSERVER}.myfreefarm.de/ajax/forestry.php?rid=${RID}&"
AJAXFOOD="http://s${MFFSERVER}.myfreefarm.de/ajax/foodworld.php?rid=${RID}&"
AJAXCITY="http://s${MFFSERVER}.myfreefarm.de/ajax/city.php?rid=${RID}&"

function ctrl_c {
 echo "Caught CTRL-C - Trying to log off..."
 wget -nv -a $LOGFILE --output-document=/dev/null --user-agent="$AGENT" --load-cookies $COOKIEFILE "$LOGOFFURL"
 echo "<font color=\"green\">inaktiv</font>" > "$STATUSFILE"
 exit 1
}

function GetFarmData {
 sFile=$1
 wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.de/ajax/farm.php?rid=${RID}&mode=getfarms&farm=1&position=0"
}

function GetForestryData {
 sFile=$1
 wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.de/ajax/forestry.php?rid=${RID}&action=initforestry"
}

function GetFoodWorldData {
 sFile=$1
 wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.de/ajax/foodworld.php?action=foodworld_init&id=0&table=0&chair=0&rid=${RID}"
}

#function GetMenuUpdateData {
# sFile=$1
# wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.de/menu-update.php"
#}

function GetLotteryData {
 sFile=$1
 wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.de/ajax/city.php?rid=${RID}&city=2&mode=initlottery"
}

function GetWindMillData {
 sFile=$1
 wget -nv -a $LOGFILE --output-document=$sFile --user-agent="$AGENT" --load-cookies $COOKIEFILE "http://s${MFFSERVER}.myfreefarm.de/ajax/city.php?rid=${RID}&city=2&mode=windmillinit"
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
 sFunction=$(head -1 ${iFarm}/${iPosition}/${iSlot})
 # now we should know which function to call
 harvest_${sFunction} ${iFarm} ${iPosition} ${iSlot}
 start_${sFunction} ${iFarm} ${iPosition} ${iSlot}
 update_queue ${iFarm} ${iPosition} ${iSlot}
}

function harvest_Stable {
 iFarm=$1
 iPosition=$2
 SendAJAXFarmRequest "mode=inner_crop&farm=${iFarm}&position=${iPosition}"
}

function start_Stable {
 # get parameters from line 2
 # since stable takes two parameters, we need to split 'em
 local iFarm=$1
 local iPosition=$2
 local aParams=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 IFS=,
 set -f
 set -- $aParams
 unset IFS
 set +f
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

function harvest_KnittingMill {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 SendAJAXFarmRequest "position=${iPosition}&mode=crop&slot=$((iSlot+1))&farm=${iFarm}"
}

function start_KnittingMill {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # Knitting Mill takes one parameter
 local iGood=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 local sAJAXSuffix="position=${iPosition}&item=${iGood}&mode=start&slot=$((iSlot+1))&farm=${iFarm}"
 if [ "$GUILDJOB" = true ]; then
  local sAJAXSuffix="${sAJAXSuffix}&guildjob=1"
  GUILDJOB=false
 fi
 # do the knitting
 SendAJAXFarmRequest $sAJAXSuffix
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
 local iGood=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 local iRealSlot=$(get_RealSlotName $iFarm $iPosition $iSlot)
 # do the mill
 SendAJAXFarmRequest "position=${iPosition}&oil=${iGood}&mode=start&slot=${iRealSlot}&farm=${iFarm}"
}

function harvest_Factory {
 iFarm=$1
 iPosition=$2
 iSlot=$3
 SendAJAXFarmRequest "mode=getadvancedcrop&farm=${iFarm}&position=${iPosition}"
}

function start_Factory {
 local iFarm=$1
 local iPosition=$2
 local iSlot=$3
 # Factory takes one parameter
 local iGood=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 local sAJAXSuffix="mode=setadvancedproduction&farm=${iFarm}&position=${iPosition}&id=${iGood}&product=${iGood}"
 if [ "$GUILDJOB" = true ]; then
  local sAJAXSuffix="${sAJAXSuffix}&guildjob=1"
  GUILDJOB=false
 fi
 # start the factory
 SendAJAXFarmRequest $sAJAXSuffix
}

function harvest_Farm {
 iFarm=$1
 iPosition=$2
 iSlot=$3
 SendAJAXFarmRequest "mode=cropgarden&farm=${iFarm}&position=${iPosition}"
}

function start_Farm {
 iFarm=$1
 iPosition=$2
 iSlot=$3
 # Farm takes one parameter
 iGood=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 # start the farm
 SendAJAXFarmRequest "mode=autoplant&farm=${iFarm}&position=${iPosition}&id=${iGood}&product=${iGood}"
 # water the farm
 SendAJAXFarmRequest "mode=watergarden&farm=${iFarm}&position=${iPosition}"
}

function DoForestry {
 # read stuff from queue file
 # code iss a bit cheesy due to laziness ;)
 sFile=$1
 sFunction=$(head -1 ${sFile}/${sFile}/${sFile})
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
 iGood=$(sed '2q;d' ${sFile})
 # plant trees
 SendAJAXForestryRequest "action=autoplant&productid=${iGood}"
 water_Tree
}

function water_Tree {
 # water trees
 SendAJAXForestryRequest "action=water"
}

function harvest_ForestryBuilding {
 iPosition=$2
 iSlot=$3
 SendAJAXForestryRequest "action=cropproduction&position=${iPosition}&slot=${iSlot}"
}

function start_ForestryBuilding {
  sFarm=$1
  iPosition=$2
  iSlot=$3
  # this building needs one parameter
  iGood=$(sed '2q;d' ${sFarm}/${iPosition}/${iSlot})
  SendAJAXForestryRequest "action=startproduction&position=${iPosition}&productid=${iGood}&slot=${iSlot}"
  }

function harvest_FoodWorldBuilding {
 iPosition=$2
 iSlot=$3
 SendAJAXFoodworldRequest "action=crop&id=0&table=${iPosition}&chair=${iSlot}"
}

function start_FoodWorldBuilding {
 sFarm=$1
 iPosition=$2
 iSlot=$3
 # this building needs one parameter
 iGood=$(sed '2q;d' ${sFarm}/${iPosition}/${iSlot})
 SendAJAXFoodworldRequest "action=production&id=${iGood}&table=${iPosition}&chair=${iSlot}"
}

function DoFarmersMarket {
 sFarm=$1
 sPosition=$2
 iSlot=$3
 if check_QueueSleep ${sFarm}/${sPosition}/${iSlot}; then
  echo "Set to sleep."
  return
 fi
 sFunction=$(head -1 ${sFarm}/${sPosition}/${iSlot})
 harvest_${sFunction} ${sFarm} ${sPosition} ${iSlot}
 start_${sFunction} ${sFarm} ${sPosition} ${iSlot}
 update_queue ${sFarm} ${sPosition} ${iSlot}  
}

function harvest_FlowerArea {
 # harvest flowers
 SendAJAXFarmRequest "mode=flowerarea_harvest_all&farm=1&position=1"
}

function start_FlowerArea {
 sFarm=$1
 sPosition=$2
 iSlot=$3
 iGood=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 if [ "$iGood" = "998" ]; then
  iGood=$($JQBIN '.updateblock.farmersmarket.flower_bonus.pid' $FARMDATAFILE)
 fi
 SendAJAXFarmRequest "mode=flowerarea_autoplant&farm=1&position=1&set=0&pid=${iGood}"
 # water the flowers
 SendAJAXFarmRequest "mode=flowerarea_water_all&farm=1&position=1"
}

function harvest_Nursery {
 iSlot=$3
 SendAJAXFarmRequest "mode=nursery_harvest&farm=1&position=1&id=1&slot=${iSlot}"
}

function start_Nursery {
 sFarm=$1
 sPosition=$2
 iSlot=$3
 iGood=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 SendAJAXFarmRequest "mode=nursery_startproduction&farm=1&position=1&id=${iGood}&pid=${iGood}&slot=${iSlot}"
}

function DoFarmersMarketFlowerPots {
 iSlot=$1
 SendAJAXFarmRequest "mode=flowerslot_water&farm=1&position=1&set=${iSlot}:1,"
}

function harvest_MonsterFruitHelper {
 :
}

function start_MonsterFruitHelper {
 sFarm=$1
 sPosition=$2
 iSlot=$3
 iGood=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 SendAJAXFarmRequest "mode=megafruit_buyobject&farm=1&position=1&id=${iGood}&oid=${iGood}"
}

function DoFoodContestCashDesk {
 SendAJAXFarmRequest "mode=foodcontest_merchpin&farm=1&position=1"
}

function DoFoodContestAudience {
 iBlock=$1
 sPinType=$2
 SendAJAXFarmRequest "mode=foodcontest_pincache&farm=1&position=1&id=1_${sPinType},&value=${iBlock}_${sPinType},"
}

function DoFoodContestFeeding {
 SendAJAXFarmRequest "mode=foodcontest_feed&farm=1&position=1"
}

function harvest_Vet {
 local iSlot=$3
 SendAJAXFarmRequest "mode=vet_harvestproduction&farm=1&position=1&id=${iSlot}&slot=${iSlot}&pos=1"
}

function start_Vet {
 local sFarm=$1
 local sPosition=$2
 local iSlot=$3
 local iGood=$(sed '2q;d' ${sFarm}/${sPosition}/${iSlot})
 SendAJAXFarmRequest "mode=vet_startproduction&farm=1&position=1&id=${iSlot}&slot=${iSlot}&pid=${iGood}&pos=1"
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

function harvest_MegaField {
 iFarm=$1
 iPosition=$2
 iSlot=$3
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
   SendAJAXMegaFieldRequest "mode=megafield_tour&farm=1&position=1&set=${iPlotnum},|&vid=${iHarvestDevice}"
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
   MegaFieldPlant $iPID $iFreePlots
   GetFarmData $FARMDATAFILE
   # exit function
   return
  fi
  MegaFieldPlant $iPID $amountToGo
  # call function again since there are still free plots
  GetFarmData $FARMDATAFILE
  start_MegaField
 done
 GetFarmData $FARMDATAFILE
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
 local iGood=$(sed '2q;d' ${iFarm}/${iPosition}/${iSlot})
 iSlot=$iRealSlot
 # get points per good
 local iPointsPerGood=$($JQBIN '.updateblock.farms.farms["'${iFarm}'"]["'${iPosition}'"].data.data.slots["'${iSlot}'"].products["'${iGood}'"].points' $FARMDATAFILE)
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
 SendAJAXFarmRequest "mode=fuelstation_entry&farm=${iFarm}&position=${iPosition}&id=${iSlot}&amount=${iAmount}&slot=${iSlot}&pid=${iGood}"
}

function harvest_WindMill {
 SendAJAXCityRequest "city=2&mode=windmillcrop&slot=1"
}

function start_WindMill {
 local iGood=$(sed '2q;d' city2/windmill/0)
 SendAJAXCityRequest "city=2&mode=windmillstartproduction&formula=${iGood}&slot=1"
}

function check_VehicleFullLoad {
 local iVehicle=$1
 local iFarm=$2
 local iProduct
 local iProductCount
 local iSafetyCount
 local iCount
 local sCart=
 local iTransportCount=0
 local iVehicleSlotsUsed=0
 local iVehicleCapacity=$(get_VehicleCapacity $iVehicle)
 local iVehicleSlotCount=$(get_VehicleSlotCount $iVehicle)
 local iFieldsOnFarmNum=$(get_FieldsOnFarmNum $iFarm)
 local iItemCount=$($JQBIN '.updateblock.stock.tempstock|.[]|."'${iFarm}'"' $FARMDATAFILE | wc -l)
 # at the time of writing, the temp stock only exists on farm 5
 # if this changes, and this is likely if you look at the data structure,
 # this function WILL FAIL
 for iCount in $(seq 0 $((iItemCount-1))); do
  iProduct=$($JQBIN '.updateblock.stock.tempstock|keys['${iCount}']|tonumber' $FARMDATAFILE)
  iProductCount=$($JQBIN '.updateblock.stock.tempstock["'${iProduct}'"]["'${iFarm}'"]|tonumber' $FARMDATAFILE)
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
   SendAJAXFarmRequest "mode=map_sendvehicle&farm=${iFarm}&position=1&route=1&vehicle=${iVehicle}&cart=${sCart}"
   return
  fi
  iVehicleSlotsUsed=$((iVehicleSlotsUsed+1))
  sCart=${sCart}${iVehicleSlotsUsed},${iProduct},${iProductCount}_
  if [ $iVehicleSlotsUsed -eq $iVehicleSlotCount ]; then
   echo "Sending partially loaded vehicle to main farm (no slots left)..."
   SendAJAXFarmRequest "mode=map_sendvehicle&farm=${iFarm}&position=1&route=1&vehicle=${iVehicle}&cart=${sCart}"
   return
  fi
 done
 if [ $iTransportCount -lt 0 ]; then
  $iTransportCount=0
 fi
 echo "$iTransportCount/$iVehicleCapacity items available for transport, no transport started"
}

function get_VehicleCapacity {
 local iVehicle=$1
 case "$iVehicle" in
   1) echo 125
      ;;
   2) echo 750
      ;;
   3) echo 2500
      ;;
   4) echo 1000
      ;;
   5) echo 20000
      ;;
   *) echo "Unknown vehicle in get_VehicleCapacity()" >&2
      echo 0
      ;;
 esac
}

function get_VehicleSlotCount {
 local iVehicle=$1
 case "$iVehicle" in
   1) echo 2
      ;;
   2) echo 6
      ;;
   3) echo 10
      ;;
   4) echo 3
      ;;
   5) echo 16
      ;;
   *) echo "Unknown vehicle in get_VehicleSlotCount()" >&2
      echo 0
      ;;
 esac
}

function get_ProductCountFittingOnField {
 local iProduct=$1
 local aProduct_x='{"351":"2","352":"2","353":"2","354":"2","355":"1","356":"2","357":"1","358":"2","359":"2","360":"2","361":"2"}'
 local aProduct_y='{"351":"1","352":"1","353":"2","354":"2","355":"1","356":"2","357":"1","358":"2","359":"2","360":"1","361":"2"}'
 local iProductDim_x=$(echo $aProduct_x | $JQBIN '."'${iProduct}'"|tonumber')
 local iProductDim_y=$(echo $aProduct_y | $JQBIN '."'${iProduct}'"|tonumber')
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
  if [ $iBuildingID -eq 1 -a $bStatus -eq 1 ]; then
   # building is a field and is active
   iFieldsOnFarm=$((iFieldsOnFarm+1))
  fi
 done
 echo $iFieldsOnFarm
}

function update_queue {
 iFarm=$1
 iPosition=$2
 iSlot=$3
 # re-order the queue if any
 sInfile=${iFarm}/${iPosition}/${iSlot}
 sTmpfile=/tmp/mff-q-$$
 iLines=$(cat $sInfile | wc -l)
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
 $JQBIN -e '.updateblock.megafield.job_start' $FARMDATAFILE >/dev/null 2>&1
 if [ $? -ne 1 -a $? -ne 4 ]; then
  # check for job start
  if [[ $($JQBIN '.updateblock.megafield.job_start' $FARMDATAFILE | wc -c) -gt 4 ]]; then
   return 0
  fi
 fi
 return 1
}

function check_RipePlotOnMegaField {
 # returns true if a plot shows a negative remainder
 # propagates iPlot and sPlotName
 local iBusyPlots=$(get_MegaFieldBusyPlotsNum)
 iPlot=0
 while [ "$iPlot" -lt "$iBusyPlots" ]; do
  sPlotName=$(get_BusyMegaFieldPlotName $iPlot)
  if $JQBIN '.updateblock.megafield.area['${sPlotName}'].remain' $FARMDATAFILE | grep '-' >/dev/null; then
   return 0
  fi
  iPlot=$((iPlot+1))
 done
 return 1 
}

function get_BusyMegaFieldPlotNum {
 iBusyPlots=($($JQBIN '.updateblock.megafield.area|length' $FARMDATAFILE))
 return $iBusyPlots
}

function get_UnlockedMegaFieldPlotNum {
 iUnlockedPlots=($($JQBIN '.updateblock.megafield.area_free|length' $FARMDATAFILE))
 # we always have a positive number here
 echo $iUnlockedPlots
}

function get_BusyMegaFieldPlotName {
 local iPlotIndex=$1
 local sPlotName=($($JQBIN '.updateblock.megafield.area|keys|.['$iPlotIndex']' $FARMDATAFILE))
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
 if [ "$iDurability" = "null" -o -z "$iDurability" ]; then
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
 if get_BusyMegaFieldPlotNum ; then
  # no busy plots at all... return needed products
  echo $iSeeminglyNeeded
  return
 fi
 local iPIDOnBusyPlots=0
 for iPlot in $(seq 0 $((iBusyPlots-1))); do
  sPlotName=$(get_BusyMegaFieldPlotName $iPlot)
  # iBusyPlots came from get_BusyMegaFieldPlotNum
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

#function MegaFieldPlant {
# local iPID=$1
# local iFreePlots=$2
# local iCount=1
# local iCount2=0
# local iSafetyCount=0
# local iUnlockedPlotsCount=$(get_UnlockedMegaFieldPlotNum)
# while [ "$iCount" -le "$iFreePlots" ]; do
#   while [ "$iCount2" -lt "$iUnlockedPlotsCount" ]; do
#    sUnlockedPlotName=$($JQBIN '.updateblock.megafield.area_free|keys|.['$iCount2']' $FARMDATAFILE)
#    $JQBIN -e '.updateblock.megafield.area['$sUnlockedPlotName']' $FARMDATAFILE >/dev/null 2>&1
#    if [ $? -eq 1 -o $? -eq 4 ]; then
#     # plot is free, plant stuff on it
#     local iPlotnum=$(echo $sUnlockedPlotName | tr -d '"')
#     echo "Planting item ${iPID} on Mega Field plot ${iPlotnum}..."
#     SendAJAXMegaFieldRequest "mode=megafield_plant&farm=1&position=1&set=${iPlotnum}_${iPID}|"
#     # make sure we exit after 100 cycles when not enough crop in stock
#     iSafetyCount=$((iSafetyCount+1))
#     if [ $iSafetyCount -gt 99 ]; then
#      echo "Exiting MegaFieldPlant after 100 cycles! (Not enough crop in stock?)"
#      return
#     fi
#     break
#    fi
#    iCount2=$((iCount2+1))
#   done
#  iCount=$((iCount+1))
# done
#}

function MegaFieldPlant {
 # new function after changes made by upjers 09.02.2016
 local iPID=$1
 local iAmount=$2
 echo "Planting item ${iPID} on ${iAmount} Mega Field plot(s)..."
 SendAJAXMegaFieldRequest "mode=megafield_autoplant&farm=1&position=1&id=${iPID}&pid=${iPID}"
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

function SendAJAXFarmRequest {
 sAJAXSuffix=$1
 WGETREQ ${AJAXFARM}${sAJAXSuffix}
}

function SendAJAXMegaFieldRequest {
 sAJAXSuffix=$1
 wget -nv -a $LOGFILE --output-document=$FARMDATAFILE --user-agent="$AGENT" --load-cookies $COOKIEFILE ${AJAXFARM}${sAJAXSuffix}
 # need to keep farm data file up to date here
}

function SendAJAXForestryRequest {
 sAJAXSuffix=$1
 WGETREQ ${AJAXFOREST}${sAJAXSuffix}
}

function SendAJAXFoodworldRequest {
 sAJAXSuffix=$1
 WGETREQ ${AJAXFOOD}${sAJAXSuffix}
}

function SendAJAXCityRequest {
 sAJAXSuffix=$1
 WGETREQ ${AJAXCITY}${sAJAXSuffix}
}
