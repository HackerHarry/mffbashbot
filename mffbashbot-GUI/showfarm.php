<?php
// Show farm file for My Free Farm Bash Bot (front end)
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

// headings
for ($position = 1; $position <= 3; $position++) {
 $iNumQueues = GetQueueCount($gamepath, $farm, $position);
 echo "<table id=\"t$position\" class=\"queuetable\" border=\"1\">
 <tr><th colspan=\"$iNumQueues\">" . (!empty($farmdata["updateblock"]["farms"]["farms"]["$farm"]["$position"]["name"]) ? $farmdata["updateblock"]["farms"]["farms"]["$farm"]["$position"]["name"] : $strings['notavailable']) . "</th>
 </tr><tr>
 <td align=\"center\" colspan=\"$iNumQueues\"><form action=\"makeW3Chappy\" name=\"selpos$position\" style=\"margin-bottom:0\">";
 CreateSelectionsForBuildingID($farmdata["updateblock"]["farms"]["farms"]["$farm"]["$position"]["buildingid"], $position);
 echo "</form></td>
 </tr><tr>";
// buttons
 for ($i = 1; $i <= $iNumQueues; $i++) {
  echo "<td align=\"center\">
  <form action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
  PlaceQueueButtons($position, $i);
  echo "</form></td>";
 }
 echo "</tr><tr>";
// queues
 echo "<td align=\"center\" colspan=\"$iNumQueues\">
 <form name=\"queue$position\" id=\"queue$position\" action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
 for ($i = 1; $i <= $iNumQueues; $i++)
  PlaceQueues($gamepath, $farm, $position, $i);
 echo "</form></td>
 </tr></table>";
}
echo "<div style=\"clear:both\"></div>
<br>
<form name=\"save_form\" id=\"saveConfig_form\" method=\"post\" action=\"save.php\" style=\"display: inline-block; margin-right: 2em\">
<button class=\"btn btn-success btn-sm\" name=\"save\" onclick=\"return saveConfig()\">{$strings['save']}</button>
</form>{$strings['insert-multiplier']}&nbsp;<input id=\"multi\" type=\"text\" maxlength=\"2\" size=\"1\" value=\"1\" pattern=\"[0-9]{1,2}\"><br><br>\n";

for ($position = 4; $position <= 6; $position++) {
 $iNumQueues = GetQueueCount($gamepath, $farm, $position);
 echo "<table id=\"t$position\" class=\"queuetable\" border=\"1\">
 <tr><th colspan=\"$iNumQueues\">" . (!empty($farmdata["updateblock"]["farms"]["farms"]["$farm"]["$position"]["name"]) ? $farmdata["updateblock"]["farms"]["farms"]["$farm"]["$position"]["name"] : $strings['notavailable']) . "</th>
 </tr><tr>
 <td align=\"center\" colspan=\"$iNumQueues\"><form id=\"selpos$position\" name=\"selpos$position\" action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
 CreateSelectionsForBuildingID($farmdata["updateblock"]["farms"]["farms"]["$farm"]["$position"]["buildingid"], $position);
 echo "</form></td>
 </tr><tr>";
 for ($i = 1; $i <= $iNumQueues; $i++) {
  echo "<td align=\"center\">
  <form action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
  PlaceQueueButtons($position, $i);
  echo "</form></td>";
 }
 echo "</tr><tr>
 <td align=\"center\" colspan=\"$iNumQueues\">
 <form name=\"queue$position\" id=\"queue$position\" action=\"makeW3Chappy\" style=\"margin-bottom:0\">";
 for ($i = 1; $i <= $iNumQueues; $i++)
  PlaceQueues($gamepath, $farm, $position, $i);
 echo "</form></td>
 </tr></table>";
}
?>
 </body>
</html>
