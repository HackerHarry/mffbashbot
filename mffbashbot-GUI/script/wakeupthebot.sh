#!/bin/bash
# This script is part of Harrys My Free Farm Bash Bot (front end)
# Kills the sleep command in order to make the bot do an iteration.
# Requires the account that the web server runs under to be able to kill as su
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
: ${1:?No game path provided}
if ! uname -a | grep -qi "cygwin"; then
 SUDO=sudo
fi
GAMEPATH=$1
PIDFILE=bashpid.txt
PID2KILL=$(cat $GAMEPATH/$PIDFILE)
$SUDO /bin/kill $(pgrep -P $PID2KILL sleep)
sleep 2s
