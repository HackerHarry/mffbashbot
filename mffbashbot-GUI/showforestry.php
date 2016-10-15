<?php
// Show forestry file for Harrys My Free Farm Bash Bot (front end)
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
  <title>Harrys MFF Bash Bot - B&auml;umerei</title>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link href="css/mffbot.css" rel="stylesheet" type="text/css">
 </head>
 <body id="main_body" class="main_body" onload="window.setTimeout(updateBotStatus, 30000)">
<?php
$farm=$_POST["farm"];
$username=$_POST["username"];
include 'gamepath.php';
include 'functions.php';
include 'farmdata.php';
include 'buttons.php';


$position = [0 => ["sawmill", "S&auml;gewerk", "1"], 1 => ["carpentry", "Schreinerei", "2"], 2 => ["forestry", "B&auml;umerei", "forestry"]];

for ($pc = 0; $pc <= 2; $pc++) {
 $iNumQueues = GetQueueCount($gamepath, $farm, $position[$pc][2]);
 print "<table name=\"" . $position[$pc][0] . "\" style=\"float:left; margin-right:20px;\" border=\"1\">";
 print "<tr><th colspan=\"" . $iNumQueues . "\">" . $position[$pc][1] . "</th>";
 print "</tr><tr>";
 print "<td align=\"center\" colspan=\"" . $iNumQueues . "\"><form name=\"selpos" . $position[$pc][0] . "\" style=\"margin-bottom:0\">";
 CreateSelectionsForBuildingID($position[$pc][0], $position[$pc][2]);
 print "</td>";
 print "</tr><tr>";
 for ($i = 1; $i <= $iNumQueues; $i++)
  PlaceQueueButtons($position[$pc][2], $i);
 print "</form>";
 print "</tr><tr>";
 // queues
 print "<form name=\"queue" . $position[$pc][0] . "\" id=\"queue" . $position[$pc][0] . "\" style=\"margin-bottom:0\">";
 for ($i = 1; $i <= $iNumQueues; $i++)
  PlaceQueues($gamepath, $farm, $position[$pc][2], $i);
 print "</form>";
 print "</tr></table>";
}
print "<div style=\"clear:both\"></div>";
print "<br>";
print "<form name=\"save_form\" id=\"saveConfig_form\" method=\"post\" action=\"save.php\">";
print "<input type=\"submit\" name=\"save\" value=\"Speichern\" onclick=\"return saveConfig()\">";
print "<br><br>";
?>
 </form>
 </body>
</html>
