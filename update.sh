#!/bin/bash
# Update handler for Harrys My Free Farm Bash Bot
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

#variables
BOTGUIROOT=/var/www/html/mffbashbot
if ! uname -a | grep -qi "cygwin"; then
 SUDO=sudo
fi

cd
touch mffbashbot/updateInProgress
rm -f mffbashbot/updateTrigger

echo "Updating Harrys MFF Bash Bot..."
rm -f master.zip 2>/dev/null
rm -rf mffbashbot-master 2>/dev/null
wget -nv "https://github.com/HackerHarry/mffbashbot/archive/master.zip"

echo "Unpacking the archive..."
unzip -q master.zip

echo "Updating bot files..."
cp -f mffbashbot-master/* mffbashbot
# just in case...
chmod 775 mffbashbot
cd ~/mffbashbot

echo "(Re)Setting permissions..."
find . -type d -exec chmod 775 {} +
find . -type f -exec chmod 664 {} +
chmod +x *.sh

echo "Updating GUI files..."
cd ~/mffbashbot-master
$SUDO rm -rf $BOTGUIROOT
$SUDO mv mffbashbot-GUI $BOTGUIROOT
$SUDO chmod +x $BOTGUIROOT/script/*.sh
$SUDO sed -i 's/\/pi\//\/'$USER'\//' $BOTGUIROOT/gamepath.php

echo "Done!"
cd
# delete updateTrigger in case someone pressed the update button in the meantime
rm -f mffbashbot/updateTrigger 2>/dev/null
rm -f mffbashbot/updateInProgress master.zip
rm -rf mffbashbot-master
