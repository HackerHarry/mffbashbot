<?php
// Header file for Harry's My Free Farm Bash Bot (front end)
// Copyright 2016-18 Harun "Harry" Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
print "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n";
print "<html>\n";
print "<head>\n";
print "<title>Harry's MFF Bash Bot - " . $farmFriendlyName["$farm"] . "</title>";
print "<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">\n";
print "<link href=\"css/bootstrap.css\" rel=\"stylesheet\" type=\"text/css\">\n";
print "<link href=\"css/mffbot.css\" rel=\"stylesheet\" type=\"text/css\">\n";
print "</head>\n";
print "<body id=\"main_body\" class=\"main_body\" onload=\"updateBotStatus()\">\n";

if (!isset($farm))
 $farm = 1;
if ($farm == "runbot") {
 exec("script/wakeupthebot.sh " . $gamepath);
 $farm = 1;
}
include 'JSfunctions.php';
$botver = file_get_contents($gamepath . "/../version.txt");
print "<nav class=\"navbar btn-dark bg-dark fixed-top\">\n";
print $botver . " -- " . $username . " -- " . $strings['lastbotiteration'] . ": <div id=\"lastruntime\" style=\"display:inline; font-weight: bold\">";
system("cat " . $gamepath . "/lastrun.txt");
print "</div> -- " . $strings['thebotis'] . " <div id=\"botstatus\" style=\"display:inline; font-weight: bold\">\n";
print "</div>\n";
if (version_compare($botver, $versionavailable) == -1) {
 print " -- ";
 print "<div id=\"updatenotification\" style=\"display:inline; font-weight: bold\">" . $strings['updateavailable'];
 print "<button id=\"updatebtn\" onclick=\"confirmUpdate()\">" . $strings['updateto'] . " " . $versionavailable . "</button>";
 print "<small> -- " . $strings['historyishere'] . "</small></div>";
}
print "</nav><br><br>\n";
?>
