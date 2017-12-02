#!/bin/bash
# This script is part of Harrys My Free Farm Bash Bot (front end)
# Logon to MFF and load farm info
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

# as are 2, 3 and 4
: ${2:?No MFF password provided}
: ${3:?No MFF server provided}
: ${4:?No language provided}

# variables
MFFUSER=$1
MFFPASS=$2
MFFSERVER=$3
TLD=$4
if [ "$TLD" = "en" ]; then
 TLD=com
fi
LOGFILE=/tmp/mffbot-$$.log
OUTFILE=/tmp/mffbottemp-$$.html
COOKIEFILE=/tmp/mffcookies-$$.txt
FARMDATAFILE=/tmp/farmdata-${MFFUSER}.txt
FOREDATAFILE=/tmp/forestdata-${MFFUSER}.txt
FOODDATAFILE=/tmp/fooddata-${MFFUSER}.txt
VERSIONAVAILABLE=/tmp/mffbot-version-available.txt

# remove lingering cookies
rm $COOKIEFILE 2>/dev/null
NANOVALUE=$(echo $(($(date +%s%N)/1000000)))
LOGOFFURL="http://s${MFFSERVER}.myfreefarm.${TLD}/main.php?page=logout&logoutbutton=1"
POSTURL="https://www.myfreefarm.${TLD}/ajax/createtoken2.php?n=${NANOVALUE}"
AGENT="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:54.0) Gecko/20100101 Firefox/55.0"
POSTDATA="server=${MFFSERVER}&username=${MFFUSER}&password=${MFFPASS}&ref=and&retid="
VERURL="https://raw.githubusercontent.com/HackerHarry/mffbashbot/master/version.txt"

# get a logon token
MFFTOKEN=$(wget -v -o $LOGFILE --output-document=- --user-agent="$AGENT" --post-data="$POSTDATA" --keep-session-cookies --save-cookies $COOKIEFILE "$POSTURL" | sed -e 's/\[1,"\(.*\)"\]/\1/g' | sed -e 's/\\//g')
wget -v -o $LOGFILE --output-document=$OUTFILE --user-agent="$AGENT" --keep-session-cookies --save-cookies $COOKIEFILE "$MFFTOKEN"
# get our RID
RID=$(grep -om1 '[a-z0-9]\{32\}' $OUTFILE)

# get farm status
wget -v -o "$LOGFILE" --output-document="$FARMDATAFILE" --user-agent="$AGENT" --load-cookies "$COOKIEFILE" "http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/farm.php?rid=${RID}&mode=getfarms&farm=1&position=0"
wget -v -o "$LOGFILE" --output-document="$FOREDATAFILE" --user-agent="$AGENT" --load-cookies "$COOKIEFILE" "http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/forestry.php?rid=${RID}&action=initforestry"
wget -v -o "$LOGFILE" --output-document="$FOODDATAFILE" --user-agent="$AGENT" --load-cookies "$COOKIEFILE" "http://s${MFFSERVER}.myfreefarm.${TLD}/ajax/foodworld.php?action=init&id=0&table=0&chair=0&rid=${RID}"

# logoff
# i don't really care, if all this succeeds or not
# user will notice if something goes wrong.
wget -v -o "$LOGFILE" --output-document=/dev/null --user-agent="$AGENT" --load-cookies "$COOKIEFILE" "$LOGOFFURL"
rm $COOKIEFILE $OUTFILE $LOGFILE

# get latest version number from repository
wget -v -o "$LOGFILE" --output-document="$VERSIONAVAILABLE" --user-agent="$AGENT" "$VERURL"
