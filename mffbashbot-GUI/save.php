<?php
// Save functions file for Harry's My Free Farm Bash Bot (front end)
// Copyright 2016-17 Harun "Harry" Basalamah
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
include 'functions.php';
$farm = $_POST["farm"];
$username = $_POST["username"];
include 'gamepath.php';
include 'lang.php';
$farmQueue = $_POST["queueContent"];
$queue = explode("#", $farmQueue);

switch ($farm) {
 case 1:
 case 2:
 case 3:
 case 4:
 case 5:
 case 6:
  // Normal farms
  for ($position = 1; $position <= 6; $position++) {
   if (strrpos($queue[$position - 1], "-") !== false) {
    $slots = explode("-", $queue[$position - 1]); // we have more than 1 slot
    $slot1 = explode(" ", $slots[0]);
    $slot2 = explode(" ", $slots[1]);
    if (isset($slots[2]))
     $slot3 = explode(" ", $slots[2]);
    $filename = $gamepath . "/" . $farm . "/" . $position . "/" . array_shift($slot1);
    saveConfig($filename, $slot1); // feed it filename and data to write
    if ($slot2) { // this should not be needed since we have at least 2 slots here
     $filename = $gamepath . "/" . $farm . "/" . $position . "/" . array_shift($slot2);
     saveConfig($filename, $slot2);
    }
    if (isset($slot3)) {
     $filename = $gamepath . "/" . $farm . "/" . $position . "/" . array_shift($slot3);
     saveConfig($filename, $slot3);
    }
    continue;
   }
  $slot1 = explode(" ", $queue[$position - 1]);
  $filename = $gamepath . "/" . $farm . "/" . $position . "/" . array_shift($slot1);
  saveConfig($filename, $slot1);
  }
 break;

 case "farmersmarket":
 case "foodworld":
 case "forestry":
  $position = ["1", "2", "forestry"];
  $farm == "foodworld" ? $position = ["1", "2", "3", "4"] : '';
  $farm == "farmersmarket" ? $position = ["flowerarea", "nursery", "monsterfruit", "pets", "vet"] : '';
  for ($poscount = 0; $poscount <= (count($position) - 1); $poscount++) {
   if (strrpos($queue[$poscount], "-") !== false) {
    $slots = explode("-", $queue[$poscount]); // handle 3 slots
    $slot1 = explode(" ", $slots[0]);
    $slot2 = explode(" ", $slots[1]);
    if (isset($slots[2]))
     $slot3 = explode(" ", $slots[2]);
    $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot1);
    saveConfig($filename, $slot1);
    $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot2);
    saveConfig($filename, $slot2);
    if (isset($slot3)) {
     $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot3);
     saveConfig($filename, $slot3);
     unset($slot3);
     unset($slots[2]); // in case we have a 2- or 1-slotter behind a 3-slotter
    }
    continue;
   }
   $slot1 = explode(" ", $queue[$poscount]);
   $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot1);
   saveConfig($filename, $slot1);
  }
 break;

 case "city2":
  $position = ["windmill", "trans25", "trans26", "powerups"];
  for ($poscount = 0; $poscount < 4; $poscount++) {
   if (strrpos($queue[$poscount], "-") !== false) {
    $slots = explode("-", $queue[$poscount]); // handle 2 slots
    $slot1 = explode(" ", $slots[0]);
    $slot2 = explode(" ", $slots[1]);
    $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot1);
    saveConfig($filename, $slot1); // feed it filename and data to write
    $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot2);
    saveConfig($filename, $slot2);
    continue;
   }
   $slot1 = explode(" ", $queue[$poscount]);
   $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot1);
   saveConfig($filename, $slot1);
  }
 break;
 
 default:
  print "<html><head><title>Harrys MFF Bash Bot</title>";
  print "<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">";
  print "</head><body bgcolor=\"#FE2A21\"><h1>" . $strings['errorsavinggamedata'] . "</h1></body></html>";
}
?>
