#!/bin/bash
# This script is part of My Free Farm Bash Bot (front end)
# Removes a farm from the bot folder
# Copyright 2016-23 Harun "Harry" Basalamah
#
# For license see LICENSE file

# return codes
# 0 all is cool
# 1 generic error
# 2 problem with password

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
 exit 1
fi
# variables
MFFUSER=$1
MFFPASS=$2
MFFSERVER=$3
GAMEPATH=$4
STARTSCRIPT="${GAMEPATH%$MFFUSER}"/../startallbots.sh
LCONF=/etc/lighttpd/lighttpd.conf

if ! [ -d "$GAMEPATH" ]; then
 # game path doesn't exist
 exit 1
fi

cd "$GAMEPATH"/.. || exit 1

# safety precaution
# have the user confirm deletion using the stored password
_PASS=$(grep password ${MFFUSER}/config.ini | awk '{ printf "%s", $3 }' | tr -d "'")
if [ -z "$_PASS" ] || [ "$_PASS" != "$MFFPASS" ]; then
 # empty or wrong password
 exit 2
fi

_SRV=$(grep server ${MFFUSER}/config.ini | awk '{ printf "%i", $3 }')
if [ $_SRV -ne $MFFSERVER ]; then
 # user has somehow managed to transmit the wrong server no. for this farm...
 exit 1
fi

if ! rm -rf "$GAMEPATH"; then
 # most likely a problem with permissions
 exit 1
fi

if ! uname -a | grep -qi "cygwin"; then
 ISLINUX=mostlikely
fi

# re-create the start script
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
echo "screen -DRS mffbashbot -X quit >/dev/null" >>$STARTSCRIPT
echo "sleep 3 && screen -wipe mffbashbot >/dev/null" >>$STARTSCRIPT
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
