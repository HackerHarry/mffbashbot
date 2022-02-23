#!/bin/bash
# This script is part of My Free Farm Bash Bot (front end)
# Kills the sleep command in order to make the bot do an iteration.
# Requires the account that the web server runs under to be able to kill as su
# Copyright 2016-22 Harun "Harry" Basalamah
#
# For license see LICENSE file
#

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
