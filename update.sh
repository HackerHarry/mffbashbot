#!/usr/bin/env bash
# Update handler for My Free Farm Bash Bot
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

#variables
BOTGUIROOT=/var/www/html/mffbashbot
LCONF=/etc/lighttpd/lighttpd.conf
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
STATUSFILE=isactive.txt
SPIN[0]="-"
SPIN[1]="\\"
SPIN[2]="|"
SPIN[3]="/"
if ! uname -a | grep -qi "cygwin"; then
 SUDO=sudo
fi

cd
touch mffbashbot/updateInProgress
rm -f mffbashbot/updateTrigger

if [ -d ~/mffbashbot ]; then
 cd ~/mffbashbot
 for FARMNAME in $(ls -d */ | tr -d '/'); do
  if [ -e "$FARMNAME"/"$STATUSFILE" ]; then
   echo -n "Waiting for farm $FARMNAME to finish its iteration...${SPIN[0]}"
   while [ -e "$FARMNAME"/"$STATUSFILE" ]; do
    for S in "${SPIN[@]}"; do
     echo -ne "\b$S"
     sleep 0.25
    done
   done
  echo -ne "\bdone\n"
  fi
 done
fi

cd
echo "Updating My Free Farm Bash Bot..."
rm -f master.zip 2>/dev/null
rm -rf mffbashbot-master 2>/dev/null
wget -nv "https://github.com/HackerHarry/mffbashbot/archive/master.zip"

echo "Unpacking the archive..."
unzip -q master.zip

echo "Updating bot files..."
cp -f mffbashbot-master/* mffbashbot
# just in case...
chmod 775 mffbashbot
if [ -d ~/mffbashbot ]; then
 cd ~/mffbashbot
 for FARMNAME in $(ls -d */ | tr -d '/'); do
  INDEX=0
  cd $FARMNAME
  echo "Checking farm $FARMNAME for missing directories..."
  while [ $INDEX -lt $NUMDIRS ]; do # there's a similar construct in addfarm.sh in the GUI section!
   if ! [ -d "${DIRS[$INDEX]}" ]; then # don't forget about it when you're updating this part
    echo "Creating directory ${DIRS[$INDEX]}"
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
  cd ..
 done
fi

cd ~/mffbashbot

echo "(Re)Setting permissions..."
find . -type d -exec chmod 775 2>/dev/null {} +
find . -type f -exec chmod 664 2>/dev/null {} +
chmod +x *.sh

echo "Updating GUI files..."
cd ~/mffbashbot-master
$SUDO rm -rf $BOTGUIROOT
$SUDO mv mffbashbot-GUI $BOTGUIROOT
$SUDO chmod +x $BOTGUIROOT/script/*.sh
$SUDO sed -i 's/\/pi\//\/'$USER'\//' $BOTGUIROOT/config.php

# see if lighttpd.conf needs patching
if ! grep -qe 'server\.stream-response-body\s\+=\s\+1' $LCONF; then
 echo "Configuring lighttpd..."
 echo "server.stream-response-body = 1" | $SUDO tee --append $LCONF > /dev/null
 if [ -n "$SUDO" ]; then
  $SUDO /etc/init.d/lighttpd restart
 else
  echo "Restarting lighttpd..."
  pkill lighttpd
  sleep 3
  /usr/sbin/lighttpd -f '$LCONF'
 fi
fi

# create .screenrc if it's missing
if [ ! -f ~/.screenrc ]; then
 echo 'hardstatus alwayslastline
hardstatus string "%{.bW}%-w%{.rW}%n %t%{-}%+w %=%{..G} %H %{..Y}"' >~/.screenrc
fi

echo "Done!"
cd
# delete updateTrigger in case someone pressed the update button in the meantime
rm -f mffbashbot/updateTrigger 2>/dev/null
rm -f mffbashbot/updateInProgress master.zip
rm -rf mffbashbot-master
