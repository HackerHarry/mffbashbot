<?php
// Show farm file for Harrys My Free Farm Bash Bot (front end)
// Copyright 2016 Harun "Harry" Basalamah
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
?>
<html>
 <head>
  <title>Harrys MFF Bash Bot - Farm</title>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link href="css/mffbot.css" rel="stylesheet" type="text/css">
 </head>
 <body id="main_body" class="main_body" onload="window.setTimeout(updateBotStatus, 30000)">
<?php
$farm=$_POST["farm"];
$username=$_POST["username"];
include 'gamepath.php';
include 'functions.php';
include 'buttons.php';
include 'farmdata.php';

// headings
for ($position = 1; $position <= 3; $position++) {
 $iNumQueues = GetQueueCount($gamepath, $farm, $position);
 print "<table name=\"" . $position . "\" style=\"float:left; margin-right:20px;\" border=\"1\">";
 print "<tr><th colspan=\"" . $iNumQueues . "\">" . $farmdata["updateblock"]["farms"]["farms"]["$farm"]["$position"]["name"] . "</th>";
 print "</tr><tr>";
 print "<td align=\"center\" colspan=\"" . $iNumQueues . "\"><form name=\"selpos" . $position . "\" style=\"margin-bottom:0\">";
 CreateSelectionsForBuildingID($farmdata["updateblock"]["farms"]["farms"]["$farm"]["$position"]["buildingid"], $position);
 print "</td>";
 print "</tr><tr>";
// buttons
 for ($i = 1; $i <= $iNumQueues; $i++)
  PlaceQueueButtons($position, $i);
 print "</form>";
 print "</tr><tr>";
// queues
 print "<form name=\"queue" . $position . "\" id=\"queue" . $position . "\" style=\"margin-bottom:0\">";
 for ($i = 1; $i <= $iNumQueues; $i++)
  PlaceQueues($gamepath, $farm, $position, $i);
 print "</form>";
 print "</tr></table>";
}
print "<div style=\"clear:both\"></div>";
print "<br>";
print "<form name=\"save_form\" id=\"saveConfig_form\" method=\"post\" action=\"save.php\">";
print "<input type=\"submit\" name=\"save\" value=\"Speichern\" onclick=\"return saveConfig()\">";
print "<br><br>";

for ($position = 4; $position <= 6; $position++) {
 $iNumQueues = GetQueueCount($gamepath, $farm, $position);
 print "<table name=\"" . $position . "\" style=\"float:left; margin-right:20px;\" border=\"1\">";
 print "<tr><th colspan=\"" . $iNumQueues . "\">" . $farmdata["updateblock"]["farms"]["farms"]["$farm"]["$position"]["name"] . "</th>";
 print "</tr><tr>";
 print "<td align=\"center\" colspan=\"" . $iNumQueues . "\"><form id=\"selpos" . $position . "\" name=\"selpos" . $position . "\" style=\"margin-bottom:0\">";
 CreateSelectionsForBuildingID($farmdata["updateblock"]["farms"]["farms"]["$farm"]["$position"]["buildingid"], $position);
 print "</td>";
 print "</tr><tr>";
 for ($i = 1; $i <= $iNumQueues; $i++)
  PlaceQueueButtons($position, $i);
 print "</form>";
 print "</tr><tr>";
 print "<form name=\"queue" . $position . "\" id=\"queue" . $position . "\" style=\"margin-bottom:0\">";
 for ($i = 1; $i <= $iNumQueues; $i++)
 PlaceQueues($gamepath, $farm, $position, $i);
 print "</form>";
 print "</tr></table>";
}
?>
 </form>
 </body>
</html>
