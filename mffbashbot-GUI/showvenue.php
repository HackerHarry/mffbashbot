<?php
// Show venue file for My Free Farm Bash Bot (front end)
// Copyright 2016-24 Harry Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// For license see LICENSE file
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
  $position = [0 => ["windmill", $strings['mill'], "windmill"], 1 => ["trans25", $strings['trans25'], "trans25"], 2 => ["trans26", $strings['trans26'], "trans26"], 3 => ["powerups", $strings['powerups'], "powerups"], 4 => ["tools", $strings['tools'], "tools"], 5 => ["trans27", $strings['trans27'], "trans27"], 6 => ["trans28", $strings['trans28'], "trans28"], 7 => ["trans29", $strings['trans29'], "trans29"], 8 => ["eventgarden", $strings['eventgarden'], "eventgarden"]];
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
  $position = [0 => ["cowracing", $farmersmarket2BuildingFriendlyName[0], "cowracing"], 1 => ["fishing", $farmersmarket2BuildingFriendlyName[1], "fishing"], 2 => ["scouts", $farmersmarket2BuildingFriendlyName[2], "scouts"]];
  break;
 default:
  exit("1");
}

for ($pc = 0; $pc < 3; $pc++) {
 if (!isset($position[$pc]))
  continue;
 $iNumQueues = GetQueueCount($gamepath, $farm, $position[$pc][2]);
 echo "<table id=\"t{$position[$pc][0]}\" class=\"queuetable\" border=\"1\">
 <tr><th colspan=\"$iNumQueues\">";
 if (($farm == "farmersmarket" ? $farmdata["updateblock"]["$farm"]["pos"][$pc + 1]["name"] : $position[$pc][1]))
  echo ($farm == "farmersmarket" ? $farmdata["updateblock"]["$farm"]["pos"][$pc + 1]["name"] : $position[$pc][1]) . "</th>";
 else
  echo "{$strings['notavailable']}</th>";
 echo "</tr><tr>
 <td align=\"center\" colspan=\"$iNumQueues\"><form name=\"selpos{$position[$pc][0]}\" action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
 CreateSelectionsForBuildingID($position[$pc][0], $position[$pc][2]);
 echo "</form></td>
 </tr><tr>";
 for ($i = 1; $i <= $iNumQueues; $i++) {
  echo "<td align=\"center\">
  <form action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
  PlaceQueueButtons($position[$pc][2], $i);
  echo "</form></td>";
 }
 echo "</tr><tr>";
 // queues
 echo "<td align=\"center\" colspan=\"$iNumQueues\">
 <form name=\"queue{$position[$pc][0]}\" id=\"queue{$position[$pc][0]}\" action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
 for ($i = 1; $i <= $iNumQueues; $i++)
  PlaceQueues($gamepath, $farm, $position[$pc][2], $i);
 echo "</form></td>
 </tr></table>";
}
echo "<div style=\"clear:both\"></div>
<br>
<form name=\"save_form\" id=\"saveConfig_form\" method=\"post\" action=\"save.php\" style=\"display: inline-block; margin-right: 2em\">
<button class=\"btn btn-success btn-sm\" name=\"save\" onclick=\"return saveConfig()\">" . $strings['save'] . "</button>
</form>{$strings['insert-multiplier']}&nbsp;<input id=\"multi\" type=\"text\" maxlength=\"2\" size=\"1\" value=\"1\" pattern=\"[0-9]{1,2}\"><br><br>\n";

for ($pc = 3; $pc < count($position); $pc++) {
 $iNumQueues = GetQueueCount($gamepath, $farm, $position[$pc][2]);
 echo "<table id=\"t{$position[$pc][0]}\" class=\"queuetable\" border=\"1\">";
 // farmers' market uses a different source for its friendly name
 echo "<tr><th colspan=\"$iNumQueues\">";
 if (($farm == "farmersmarket" ? $farmdata["updateblock"]["$farm"]["pos"][$pc + 1]["name"] : $position[$pc][1]))
  echo ($farm == "farmersmarket" ? $farmdata["updateblock"]["$farm"]["pos"][$pc + 1]["name"] : $position[$pc][1]) . "</th>";
 else
  echo "{$strings['notavailable']}</th>";
 echo "</tr><tr>
 <td align=\"center\" colspan=\"$iNumQueues\"><form name=\"selpos{$position[$pc][0]}\" action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
 CreateSelectionsForBuildingID($position[$pc][0], $position[$pc][2]);
 echo "</form></td>
 </tr><tr>";
 for ($i = 1; $i <= $iNumQueues; $i++) {
  echo "<td align=\"center\">
  <form action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
  PlaceQueueButtons($position[$pc][2], $i);
  echo "</form></td>";
 }
 echo "</tr><tr>
 <td align=\"center\" colspan=\"$iNumQueues\">
 <form name=\"queue{$position[$pc][0]}\" id=\"queue{$position[$pc][0]}\" action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
 for ($i = 1; $i <= $iNumQueues; $i++)
  PlaceQueues($gamepath, $farm, $position[$pc][2], $i);
 echo "</form></td>
 </tr></table>";
}
?>
 </body>
</html>
