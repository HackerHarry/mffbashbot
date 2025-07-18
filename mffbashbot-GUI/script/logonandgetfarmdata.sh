#!/bin/bash
# This script is part of My Free Farm Bash Bot (front end)
# Logon to MFF and load farm info
# Copyright 2016-25 Harry Basalamah
#
# For license see LICENSE file

# variable 1 is mandatory
: ${1:?No MFF username provided}

# as are 2, 3 and 4
: ${2:?No MFF password provided}
: ${3:?No MFF server provided}
: ${4:?No language provided}

# variables
MFFUSER=$1
MFFPASS=$2
MFFSERVER=$3
MFFLANG=$4
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
LOGFILE=/tmp/mffbot-$$.log
OUTFILE=/tmp/mffbottemp-$$.html
COOKIEFILE=/tmp/mffcookies-$$.txt
FARMDATAFILE=/tmp/farmdata-${MFFUSER}.txt
FOREDATAFILE=/tmp/forestdata-${MFFUSER}.txt
FOODDATAFILE=/tmp/fooddata-${MFFUSER}.txt
VERSIONAVAILABLE=/tmp/mffbot-version-available.txt
PRODUCTS=/tmp/products-${MFFLANG}.txt
FORESTRYPRODUCTS=/tmp/forestryproducts-${MFFLANG}.txt
FORMULAS=/tmp/formulas-${MFFLANG}.txt
EVTGARDENCROP=/tmp/eventgardencrop-${MFFLANG}.txt
MFFSTRINGS=/tmp/mffstrings-${MFFLANG}.txt

# remove lingering cookies
rm $COOKIEFILE 2>/dev/null
NANOVALUE=$(echo $(($(date +%s%N)/1000000)))
LOGOFFURL="https://s${MFFSERVER}.${DOMAIN}/main.php?page=logout&logoutbutton=1"
POSTURL="https://www.${DOMAIN}/ajax/createtoken2.php?n=${NANOVALUE}"
AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:137.0) Gecko/20100101 Firefox/137.0"
POSTDATA="server=${MFFSERVER}&username=${MFFUSER}&password=${MFFPASS}&ref=&retid="
VERURL="https://raw.githubusercontent.com/HackerHarry/mffbashbot/master/version.txt"

# get a logon token
MFFTOKEN=$(wget -v -o $LOGFILE --output-document=- --user-agent="$AGENT" --post-data="$POSTDATA" --keep-session-cookies --save-cookies $COOKIEFILE "$POSTURL" | sed -e 's/\[1,"\(.*\)"\]/\1/g' | sed -e 's/\\//g')
wget -v -o $LOGFILE --output-document=$OUTFILE --user-agent="$AGENT" --keep-session-cookies --save-cookies $COOKIEFILE "$MFFTOKEN"
# get our RID
RID=$(grep -om1 '[a-z0-9]\{32\}' $OUTFILE)
if [ -z "$RID" ]; then
 # alert PHP...
 exit 1
fi
# create list of available products
grep 'var produkt_name =' $OUTFILE | sed  's/\tvar produkt_name = //' | sed 's/,};/,\"998\":\"Bonus\",\"2886\":\"Auto\"}/' | tr -d ['\\'] >$PRODUCTS
# create list of available forestry products
grep 'var produkt_name_forestry =' $OUTFILE | sed  's/\tvar produkt_name_forestry = //' | sed 's/,};/}/' | tr -d ['\\'] >$FORESTRYPRODUCTS
# create list of available formulas abusing FARMDATAFILE ;)
grep 'var formulas = eval' $OUTFILE | sed "s/\tvar formulas = eval('\[//" | sed "s/\]');//" >$FARMDATAFILE
echo -n "{" >$FORMULAS
for iCount in {1..35}; do
 echo -n "\"${iCount}\":\"" >>$FORMULAS
 jq -j '."'$iCount'"["2"]' $FARMDATAFILE >>$FORMULAS
 echo -n "\"," >>$FORMULAS
done
echo "}" >>$FORMULAS
# PHP is allergic to that last comma...
sed -i 's/,}/}/' $FORMULAS
# create list of available event garden crop
grep 'var products_eventgarden =' $OUTFILE | sed  's/var products_eventgarden = //'  | sed 's/};/}/' | jq '[. | to_entries[] | { (.key): .value.name }] | add' >$EVTGARDENCROP

# strings
# we need to preserve single quotes (') within strings
iMaxFarm=10
sValue=$(grep "var farmname = " $OUTFILE | sed "s/var farmname = //" | tr -d '\\;\r' | sed "s/^'//;s/'$//")
jData='{"farmFriendlyName":{},"forestryBuildingFriendlyName":[],"foodworldBuildingFriendlyName":[],"farmersmarket2BuildingFriendlyName":[]}'
for n in $(seq 1 $iMaxFarm); do
 jData=$(echo $jData | jq --compact-output '.farmFriendlyName["'$n'"]="'"$sValue $n"'"')
done

aVars=("t_farmers_market = "
"t_feature_name.forestry = "
"t_feature_name.foodworld = "
"var cityname2 = ")

aStringVars=( farmersmarket
forestry
foodworld
city2 )

iIndex=0
for STR in "${aVars[@]}"; do
 sValue=$(grep "$STR" $OUTFILE | sed "s/$STR//" | tr -d '\\;\r' | sed "s/^'//;s/'$//")
 jData=$(echo $jData | jq --compact-output '.farmFriendlyName["'${aStringVars[$iIndex]}'"]="'"$sValue"'"')
 iIndex=$((++iIndex))
done
# Bauernmarkt 2
sValue=$(grep "t_farmers_market = " $OUTFILE | sed "s/t_farmers_market = //" | tr -d '\\;\r' | sed "s/^'//;s/'$//")
jData=$(echo $jData | jq --compact-output '.farmFriendlyName["farmersmarket2"]="'"$sValue"' 2"')
# Baumerei
# zuerst das sägewerk
jTemp=$(grep "var forestry_bld = " $OUTFILE | sed "s/var forestry_bld = //" | tr -d ';')
sValue=$(echo $jTemp | jq '.["1"]' | sed -e 's/<[^>]*>//g')
# element einem array hinzufügen
jData=$(echo $jData | jq '.forestryBuildingFriendlyName |= . + ['"$sValue"']')
# schreinerei
sValue=$(echo $jTemp | jq '.["2"]' | sed -e 's/<[^>]*>//g')
jData=$(echo $jData | jq '.forestryBuildingFriendlyName |= . + ['"$sValue"']')
# zuletzt die baumerei
sValue=$(grep "t_feature_name.forestry = " $OUTFILE | sed "s/t_feature_name.forestry = //" | tr -d '\\;\r' | sed "s/^'//;s/'$//")
jData=$(echo $jData | jq '.forestryBuildingFriendlyName |= . + ["'"$sValue"'"]')
unset jTemp
# picknickarea
aVars=("t_foodworld_pos1 = "
"t_foodworld_pos2 = "
"t_foodworld_pos4 = "
"t_foodworld_pos3 = ")

for STR in "${aVars[@]}"; do
 sValue=$(grep "$STR" $OUTFILE | sed "s/$STR//" | tr -d '\\;\r' | sed "s/^'//;s/'$//")
 jData=$(echo $jData | jq '.foodworldBuildingFriendlyName |= . + ["'"$sValue"'"]')
done

# bauernmarkt 2
aVars=("t_feature_name.cowracing = "
"t_feature_name.fishing = "
"t_feature_name.scouts = ")

for STR in "${aVars[@]}"; do
 sValue=$(grep "$STR" $OUTFILE | sed "s/$STR//" | tr -d '\\;\r' | sed "s/^'//;s/'$//")
 jData=$(echo $jData | jq '.farmersmarket2BuildingFriendlyName |= . + ["'"$sValue"'"]')
done

echo $jData | jq '.' >$MFFSTRINGS

# get farm status
wget -v -o "$LOGFILE" --output-document="$FARMDATAFILE" --user-agent="$AGENT" --load-cookies "$COOKIEFILE" "https://s${MFFSERVER}.${DOMAIN}/ajax/farm.php?rid=${RID}&mode=getfarms&farm=1&position=0"
aNEWS=$(jq -r '.updateblock.menue.news? | .[]? | select(.login == "1").nnr' $FARMDATAFILE)
# mark news as read
for iNEWS in $aNEWS; do
 wget -v -o "$LOGFILE" --output-document=/dev/null --user-agent="$AGENT" --load-cookies "$COOKIEFILE" "https://s${MFFSERVER}.${DOMAIN}/ajax/main.php?rid=${RID}&nnr=${iNEWS}&opt1=1&action=setnewsunread"
done
wget -v -o "$LOGFILE" --output-document="$FOREDATAFILE" --user-agent="$AGENT" --load-cookies "$COOKIEFILE" "https://s${MFFSERVER}.${DOMAIN}/ajax/forestry.php?rid=${RID}&action=initforestry"
wget -v -o "$LOGFILE" --output-document="$FOODDATAFILE" --user-agent="$AGENT" --load-cookies "$COOKIEFILE" "https://s${MFFSERVER}.${DOMAIN}/ajax/foodworld.php?action=foodworld_init&id=0&table=0&chair=0&rid=${RID}"

# logoff
# i don't really care, if all this succeeds or not
# user will notice if something goes wrong.
wget -v -o "$LOGFILE" --output-document=/dev/null --user-agent="$AGENT" --load-cookies "$COOKIEFILE" "$LOGOFFURL"

# get latest version number from repository
wget -v -o "$LOGFILE" --output-document="$VERSIONAVAILABLE" --user-agent="$AGENT" "$VERURL"
rm $COOKIEFILE $OUTFILE $LOGFILE
exit 0
