<?php
// Show venue file for My Free Farm Bash Bot (front end)
// Copyright 2016-21 Harun "Harry" Basalamah
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
if (!isset($_POST["farm"]))
 header("Location: index.php");
$farm = $_POST["farm"];
strpos($_POST["username"], ' ') === false ? $username = $_POST["username"] : $username = rawurlencode($_POST["username"]);
include 'config.php';
include 'lang.php';
include 'functions.php';
include 'farmdata.php';
include 'header.php';
include 'buttons.php';

switch ($farm) {
 case "city2":
  $position = [0 => ["windmill", $strings['mill'], "windmill"], 1 => ["trans25", $strings['trans25'], "trans25"], 2 => ["trans26", $strings['trans26'], "trans26"], 3 => ["powerups", $strings['powerups'], "powerups"], 4 => ["tools", $strings['tools'], "tools"], 5 => ["trans27", $strings['trans27'], "trans27"]];
  break;
 case "foodworld":
  $position = [0 => ["sodastall", $foodworldBuildingFriendlyName[0], "1"], 1 => ["snackbooth", $foodworldBuildingFriendlyName[1], "2"], 2 => ["pastryshop", $foodworldBuildingFriendlyName[2], "3"], 3 => ["icecreamparlour", $foodworldBuildingFriendlyName[3], "4"]];
  break;
 case "forestry":
  $position = [0 => ["sawmill", $forestryBuildingFriendlyName[0], "1"], 1 => ["carpentry", $forestryBuildingFriendlyName[1], "2"], 2 => ["forestry", $forestryBuildingFriendlyName[2], "forestry"]];
  break;
 case "farmersmarket":
  $position = [0 => ["flowerarea", "", "flowerarea"], 1 => ["nursery", "", "nursery"], 2 => ["monsterfruit", "", "monsterfruit"], 3 => ["pets", "", "pets"], 4 => ["vet", "", "vet"]];
  break;
 case "farmersmarket2":
  $position = [0 => ["cowracing", "", "cowracing"], 1 => ["fishing", "", "fishing"]];
  break;
 default:
  exit("1");
}

for ($pc = 0; $pc < 3; $pc++) {
 if (!isset($position[$pc]))
  continue;
 $iNumQueues = GetQueueCount($gamepath, $farm, $position[$pc][2]);
 print "<table id=\"t{$position[$pc][0]}\" class=\"queuetable\" border=\"1\">";
 print "<tr><th colspan=\"$iNumQueues\">";
 if ((preg_match('/^farmersmarket/', $farm) ? $farmdata["updateblock"][$farm == "farmersmarket2" ? "farmersmarket" : "$farm"]["pos"][$farm == "farmersmarket" ? $pc + 1 : $pc + 8]["name"] : $position[$pc][1]))
  print (preg_match('/^farmersmarket/', $farm) ? $farmdata["updateblock"][$farm == "farmersmarket2" ? "farmersmarket" : "$farm"]["pos"][$farm == "farmersmarket" ? $pc + 1 : $pc + 8]["name"] : $position[$pc][1]) . "</th>";
 else
  print "{$strings['notavailable']}</th>";
 print "</tr><tr>";
 print "<td align=\"center\" colspan=\"$iNumQueues\"><form name=\"selpos{$position[$pc][0]}\" action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
 CreateSelectionsForBuildingID($position[$pc][0], $position[$pc][2]);
 print "</form></td>";
 print "</tr><tr>";
 for ($i = 1; $i <= $iNumQueues; $i++) {
  print "<td align=\"center\">\n";
  print "<form action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
  PlaceQueueButtons($position[$pc][2], $i);
  print "</form></td>";
 }
 print "</tr><tr>";
 // queues
 print"<td align=\"center\" colspan=\"$iNumQueues\">";
 print "<form name=\"queue{$position[$pc][0]}\" id=\"queue{$position[$pc][0]}\" action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
 for ($i = 1; $i <= $iNumQueues; $i++)
  PlaceQueues($gamepath, $farm, $position[$pc][2], $i);
 print "</form></td>";
 print "</tr></table>";
}
print "<div style=\"clear:both\"></div>";
print "<br>";
print "<form name=\"save_form\" id=\"saveConfig_form\" method=\"post\" action=\"save.php\" style=\"display: inline-block; margin-right: 2em\">";
print "<button class=\"btn btn-success btn-sm\" name=\"save\" onclick=\"return saveConfig()\">" . $strings['save'] . "</button>";
print "</form>{$strings['insert-multiplier']}&nbsp;<input id=\"multi\" type=\"text\" maxlength=\"2\" size=\"1\" value=\"1\" pattern=\"[0-9]{1,2}\"><br><br>\n";

for ($pc = 3; $pc < count($position); $pc++) {
 $iNumQueues = GetQueueCount($gamepath, $farm, $position[$pc][2]);
 print "<table id=\"t{$position[$pc][0]}\" class=\"queuetable\" border=\"1\">";
 // farmers' market uses a different source for its friendly name
 print "<tr><th colspan=\"$iNumQueues\">";
 if ((preg_match('/^farmersmarket/', $farm) ? $farmdata["updateblock"]["$farm"]["pos"][$farm == "farmersmarket" ? $pc + 1 : $pc + 8]["name"] : $position[$pc][1]))
  print (preg_match('/^farmersmarket/', $farm) ? $farmdata["updateblock"]["$farm"]["pos"][$farm == "farmersmarket" ? $pc + 1 : $pc + 8]["name"] : $position[$pc][1]) . "</th>";
 else
  print "{$strings['notavailable']}</th>";
 print "</tr><tr>";
 print "<td align=\"center\" colspan=\"$iNumQueues\"><form name=\"selpos{$position[$pc][0]}\" action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
 CreateSelectionsForBuildingID($position[$pc][0], $position[$pc][2]);
 print "</form></td>";
 print "</tr><tr>";
 for ($i = 1; $i <= $iNumQueues; $i++) {
  print "<td align=\"center\">\n";
  print "<form action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
  PlaceQueueButtons($position[$pc][2], $i);
  print "</form></td>";
 }
 print "</tr><tr>";
 print"<td align=\"center\" colspan=\"$iNumQueues\">";
 print "<form name=\"queue{$position[$pc][0]}\" id=\"queue{$position[$pc][0]}\" action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
 for ($i = 1; $i <= $iNumQueues; $i++)
  PlaceQueues($gamepath, $farm, $position[$pc][2], $i);
 print "</form></td>";
 print "</tr></table>";
}
?>
 </body>
</html>
