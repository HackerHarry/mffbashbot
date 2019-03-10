<?php
// Save functions file for My Free Farm Bash Bot (front end)
// Copyright 2016-19 Harun "Harry" Basalamah
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
strpos($_POST["username"], ' ') === false ? $username = $_POST["username"] : $username = rawurlencode($_POST["username"]);
include 'config.php';
include 'lang.php';

if (isset($_POST["queueContent"])) {
 $farmQueue = $_POST["queueContent"];
 $queue = explode("#", $farmQueue);
}

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
    $retval = saveConfig($filename, $slot1);
    if ($retval === false || $retval == 0) exit("1");
    if ($slot2) { // this should not be needed since we have at least 2 slots here
     $filename = $gamepath . "/" . $farm . "/" . $position . "/" . array_shift($slot2);
     $retval = saveConfig($filename, $slot2);
     if ($retval === false || $retval == 0) exit("1");
    }
    if (isset($slot3)) {
     $filename = $gamepath . "/" . $farm . "/" . $position . "/" . array_shift($slot3);
     $retval = saveConfig($filename, $slot3);
     if ($retval === false || $retval == 0) exit("1");
     unset($slot3);
     unset($slots[2]); // what was i thinking?
    }
    continue;
   }
  $slot1 = explode(" ", $queue[$position - 1]);
  $filename = $gamepath . "/" . $farm . "/" . $position . "/" . array_shift($slot1);
  $retval = saveConfig($filename, $slot1);
  if ($retval === false || $retval == 0) exit("1");
  }
 exit("0");
 break;

 case "farmersmarket":
 case "farmersmarket2":
 case "foodworld":
 case "forestry":
  $position = ["1", "2", "forestry"];
  $farm == "foodworld" ? $position = ["1", "2", "3", "4"] : '';
  $farm == "farmersmarket" ? $position = ["flowerarea", "nursery", "monsterfruit", "pets", "vet"] : '';
  $farm == "farmersmarket2" ? $position = ["cowracing"] : '';
  for ($poscount = 0; $poscount <= (count($position) - 1); $poscount++) {
   if (strrpos($queue[$poscount], "-") !== false) {
    $slots = explode("-", $queue[$poscount]); // handle 3 slots
    $slot1 = explode(" ", $slots[0]);
    $slot2 = explode(" ", $slots[1]);
    if (isset($slots[2]))
     $slot3 = explode(" ", $slots[2]);
    $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot1);
    $retval = saveConfig($filename, $slot1);
    if ($retval === false || $retval == 0) exit("1");
    $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot2);
    $retval = saveConfig($filename, $slot2);
    if ($retval === false || $retval == 0) exit("1");
    if (isset($slot3)) {
     $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot3);
     $retval = saveConfig($filename, $slot3);
     if ($retval === false || $retval == 0) exit("1");
     unset($slot3);
     unset($slots[2]); // in case we have a 2- or 1-slotter behind a 3-slotter
    }
    continue;
   }
   $slot1 = explode(" ", $queue[$poscount]);
   $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot1);
   $retval = saveConfig($filename, $slot1);
   if ($retval === false || $retval == 0) exit("1");
  }
 exit("0");
 break;

 case "city2":
  $position = ["windmill", "trans25", "trans26", "powerups", "tools"];
  for ($poscount = 0; $poscount < 5; $poscount++) {
   if (strrpos($queue[$poscount], "-") !== false) {
    $slots = explode("-", $queue[$poscount]); // handle 2 slots
    $slot1 = explode(" ", $slots[0]);
    $slot2 = explode(" ", $slots[1]);
    $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot1);
    $retval = saveConfig($filename, $slot1);
    if ($retval === false || $retval == 0) exit("1");
    $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot2);
    $retval = saveConfig($filename, $slot2);
    if ($retval === false || $retval == 0) exit("1");
    continue;
   }
   $slot1 = explode(" ", $queue[$poscount]);
   $filename = $gamepath . "/" . $farm . "/" . $position[$poscount] . "/" . array_shift($slot1);
   $retval = saveConfig($filename, $slot1);
   if ($retval === false || $retval == 0) exit("1");
  }
 exit("0");
 break;

 case "savemisc":
  include 'farmdata.php';
  global $configContents;
  // langugage, password and server-no. must be set manually in config.ini
  $configContents['carefood'] = $_POST["carefood"];
  $configContents['caretoy'] = $_POST["caretoy"];
  $configContents['careplushy'] = $_POST["careplushy"];
  $configContents['dodog'] = $_POST["dogtoggle"];
  $configContents['dolot'] = $_POST["lottoggle"];
  $configContents['dologinbonus'] = $_POST["loginbonus"];
  $configContents['vehiclemgmt5'] = $_POST["vehiclemgmt5"];
  $configContents['vehiclemgmt6'] = $_POST["vehiclemgmt6"];
  $configContents['restartvetjob'] = $_POST["vetjobdifficulty"];
  $configContents['dopuzzleparts'] = $_POST["puzzlepartstoggle"];
  $configContents['sendfarmiesaway'] = $_POST["farmiestoggle"];
  $configContents['sendforestryfarmiesaway'] = $_POST["forestryfarmiestoggle"];
  $configContents['sendmunchiesaway'] = $_POST["munchiestoggle"];
  $configContents['sendflowerfarmiesaway'] = $_POST["flowerfarmiestoggle"];
  $configContents['correctqueuenum'] = $_POST["correctqueuenumtoggle"];
  $configContents['useponyenergybar'] = $_POST["ponyenergybartoggle"];
  $configContents['redeempuzzlepacks'] = $_POST["redeempuzzlepartstoggle"];
  $configContents['dobutterflies'] = $_POST["butterflytoggle"];
  $configContents['dodeliveryevent'] = $_POST["deliveryeventtoggle"];
  $configContents['megafieldinstantplant'] = $_POST["megafieldplanttoggle"];
  $configContents['doolympiaevent'] = $_POST["olympiaeventtoggle"];
  $configContents['doseedbox'] = $_POST["redeemdailyseedboxtoggle"];
  $configContents['dodonkey'] = $_POST["donkeytoggle"];
  $configContents['docowrace'] = $_POST["cowracetoggle"];
  $configContents['excluderank1cow'] = $_POST["excluderank1cowtoggle"];
  $configContents['dofoodcontest'] = $_POST["foodcontesttoggle"];
  // clean up deprecated variables
  if (isset($configContents['racecowfood'])) unset($configContents['racecowfood']);
  if (isset($configContents['crslots2feed'])) unset($configContents['crslots2feed']);
  for ($i = 1; $i <= 13; $i++)
   $configContents['racecowslot' . $i] = $_POST["racecowslot" . $i];

  $filename = $gamepath . "/config.ini";
  $retval = writeINI($configContents, $filename);
  if ($retval === false || $retval == 0)
   exit("1");
  else
   exit("0");
  break;

 default:
  exit("1");
}
?>
