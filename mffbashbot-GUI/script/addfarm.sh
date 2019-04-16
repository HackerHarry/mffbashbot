#!/bin/bash
# This script is part of My Free Farm Bash Bot (front end)
# Adds a farm to the bot folder
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

# variables
MFFPASS=$1
MFFSERVER=$2
MFFLANG=$3
GAMEPATH=$4
STARTSCRIPT="$GAMEPATH"/../../startallbots.sh
LCONF=/etc/lighttpd/lighttpd.conf
CONFIGTEXT="lang = 'de'
server = 1
password = 'p455w0rd'
carefood = 0
caretoy = 0
careplushy = 0
dodog = 0
dolot = 0
vehiclemgmt5 = 0
vehiclemgmt6 = 0
dopuzzleparts = 0
sendfarmiesaway = 0
sendforestryfarmiesaway = 0
sendmunchiesaway = 0
sendflowerfarmiesaway = 0
correctqueuenum = 0
useponyenergybar = 0
redeempuzzlepacks = 0
dobutterflies = 0
dodeliveryevent = 0
megafieldinstantplant = 0
doolympiaevent = 0
doseedbox = 0
dodonkey = 0
restartvetjob = 0
docowrace = 0
dofoodcontest = 1
racecowslot1 = 0
racecowslot2 = 0
racecowslot3 = 0
racecowslot4 = 0
racecowslot5 = 0
racecowslot6 = 0
racecowslot7 = 0
racecowslot8 = 0
racecowslot9 = 0
racecowslot10 = 0
racecowslot11 = 0
racecowslot12 = 0
racecowslot13 = 0
dologinbonus = 0
excluderank1cow = 0
docowracepvp = 0
docalendarevent = 0"

if ! uname -a | grep -qi "cygwin"; then
 ISLINUX=mostlikely
fi
INDEX=0

if [ -d "$GAMEPATH" ]; then
 exit 1
else
 mkdir -m775 "$GAMEPATH"
fi

DIRS=( 1/1
1/2
1/3
1/4
1/5
1/6
2/1
2/2
2/3
2/4
2/5
2/6
3/1
3/2
3/3
3/4
3/5
3/6
4/1
4/2
4/3
4/4
4/5
4/6
5/1
5/2
5/3
5/4
5/5
5/6
6/1
6/2
6/3
6/4
6/5
6/6
city2/powerups
city2/trans25
city2/trans26
city2/tools
city2/cowracepvp
city2/windmill
farmersmarket/flowerarea
farmersmarket/monsterfruit
farmersmarket/nursery
farmersmarket/pets
farmersmarket/vet
farmersmarket2/cowracing
foodworld/1
foodworld/2
foodworld/3
foodworld/4
forestry/1
forestry/2
forestry/forestry )
NUMDIRS=${#DIRS[*]}

# create config.ini
# substitute a couple of values
if [ "$MFFLANG" != "de" ]; then
 CONFIGTEXT=$(echo "$CONFIGTEXT" | sed "s/lang = 'de'/lang = '$MFFLANG'/")
fi
if [ $MFFSERVER -ne 1 ]; then
 CONFIGTEXT=$(echo "$CONFIGTEXT" | sed "s/server = 1/server = $MFFSERVER/")
fi
# we'll just assume the password is NOT "p455w0rd" ;)
CONFIGTEXT=$(echo "$CONFIGTEXT" | sed "s/password = 'p455w0rd'/password = '$MFFPASS'/")
echo -e "$CONFIGTEXT" > $GAMEPATH/config.ini

# create files and folders
cd $GAMEPATH || exit 1
while [ $INDEX -lt $NUMDIRS ]; do
 if ! [ -d "${DIRS[$INDEX]}" ]; then
  mkdir -p "${DIRS[$INDEX]}"
  case "${DIRS[$INDEX]}" in
   *powerups)
     touch ${DIRS[$INDEX]}/0
     touch ${DIRS[$INDEX]}/1
     ;;
   *windmill | *nursery | foodworld/1 | foodworld/2 | foodworld/3 | foodworld/4 | forestry/1 | forestry/2)
     touch ${DIRS[$INDEX]}/1
     touch ${DIRS[$INDEX]}/2
     ;;
   *monsterfruit)
     touch ${DIRS[$INDEX]}/fertilize
     touch ${DIRS[$INDEX]}/light
     touch ${DIRS[$INDEX]}/water
     ;;
   *pets | *vet | *cowracing)
     touch ${DIRS[$INDEX]}/1
     touch ${DIRS[$INDEX]}/2
     touch ${DIRS[$INDEX]}/3
     ;;
   forestry/forestry)
     touch ${DIRS[$INDEX]}/forestry
     ;;
   *)
     touch ${DIRS[$INDEX]}/0
     ;;
  esac
 fi
 INDEX=$((INDEX+1))
done
# these are usually created as www-data
if [ "$ISLINUX" = "mostlikely" ]; then
 # find out GUID of mffbashbot folder
 _GROUP=$(stat -c '%G' "$GAMEPATH"/../)
 find "$GAMEPATH" -type f -exec chmod 664 {} +
 find "$GAMEPATH" -type d -exec chmod 775 {} +
 chgrp -R $_GROUP "$GAMEPATH"
fi

# re-create the start script
cd "$GAMEPATH"/..
aFARMS=($(ls -d */ | tr -d '/'))
COUNT=1
FARMCOUNT=${#aFARMS[*]}

if [ "$ISLINUX" = "mostlikely" ]; then
 echo '#!/usr/bin/env bash
sudo /etc/init.d/lighttpd start' >$STARTSCRIPT
else
 echo '#!/usr/bin/env bash
/usr/sbin/lighttpd -f '$LCONF >$STARTSCRIPT
fi
echo "screen -DRS mffbashbot -X quit && sleep 3 >/dev/null" >>$STARTSCRIPT
echo "echo \"Starting farm ${aFARMS[0]}...\"" >>$STARTSCRIPT
echo "screen -dmS mffbashbot -t ${aFARMS[0]} bash -c 'cd ~/mffbashbot; ./mffbashbot.sh ${aFARMS[0]}'" >>$STARTSCRIPT
if [ $FARMCOUNT -ge 1 ]; then
 while [ $COUNT -lt $FARMCOUNT ]; do
  echo "sleep 20" >>$STARTSCRIPT
  echo "echo \"Starting farm ${aFARMS[$COUNT]}...\"" >>$STARTSCRIPT
  echo "screen -DRS mffbashbot -X screen -t ${aFARMS[$COUNT]} bash -c 'cd ~/mffbashbot; ./mffbashbot.sh ${aFARMS[$COUNT]}'" >>$STARTSCRIPT
  COUNT=$((COUNT + 1))
 done
fi
echo "screen -r mffbashbot" >>$STARTSCRIPT
exit 0
