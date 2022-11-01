<?php
// Save functions file for My Free Farm Bash Bot (front end)
// Copyright 2016-22 Harun "Harry" Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// For license see LICENSE file
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
 case 7:
 case 8:
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
    $filename = $gamepath . "/" . $farm . "/" . $position . "/" . array_shift($slot2);
    $retval = saveConfig($filename, $slot2);
    if ($retval === false || $retval == 0) exit("1");
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
  $farm == "farmersmarket2" ? $position = ["cowracing", "fishing", "scouts"] : '';
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
  $position = ["windmill", "trans25", "trans26", "powerups", "tools", "trans27", "trans28"];
  for ($poscount = 0; $poscount < 7; $poscount++) {
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
  $configContents['carefood'] = $_POST["carefood"];
  $configContents['caretoy'] = $_POST["caretoy"];
  $configContents['careplushy'] = $_POST["careplushy"];
  $configContents['dodog'] = $_POST["dogtoggle"];
  $configContents['dolot'] = $_POST["lottoggle"];
  $configContents['dologinbonus'] = $_POST["loginbonus"];
  $configContents['vehiclemgmt5'] = $_POST["vehiclemgmt5"];
  $configContents['vehiclemgmt6'] = $_POST["vehiclemgmt6"];
  $configContents['vehiclemgmt7'] = $_POST["vehiclemgmt7"];
  $configContents['vehiclemgmt8'] = $_POST["vehiclemgmt8"];
  $configContents['transO5'] = $_POST["transO5"];
  $configContents['transO6'] = $_POST["transO6"];
  $configContents['transO7'] = $_POST["transO7"];
  $configContents['transO8'] = $_POST["transO8"];
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
  $configContents['doolympiaevent'] = $_POST["olympiaeventtoggle"];
  $configContents['dopentecostevent'] = $_POST["pentecosteventtoggle"];
  $configContents['doseedbox'] = $_POST["redeemdailyseedboxtoggle"];
  $configContents['dodonkey'] = $_POST["donkeytoggle"];
  $configContents['docowrace'] = $_POST["cowracetoggle"];
  $configContents['docowracepvp'] = $_POST["cowracepvptoggle"];
  $configContents['excluderank1cow'] = $_POST["excluderank1cowtoggle"];
  $configContents['dofoodcontest'] = $_POST["foodcontesttoggle"];
  $configContents['docalendarevent'] = $_POST["calendareventtoggle"];
  $configContents['autobuyrefillto'] = $_POST["autobuyrefillto"];
  $configContents['doinfinitequest'] = $_POST["infinitequesttoggle"];
  $configContents['trimlogstock'] = $_POST["trimlogstocktoggle"];
  $configContents['removeweed'] = $_POST["removeweedtoggle"];
  $configContents['buyvinetillsunny'] = $_POST["buyvinetillsunnytoggle"];
  $configContents['harvestvine'] = $_POST["harvestvinetoggle"];
  $configContents['harvestvineinautumn'] = $_POST["harvestvineinautumntoggle"];
  $configContents['restartvine'] = $_POST["restartvinetoggle"];
  $configContents['removevine'] = $_POST["removevinetoggle"];
  $configContents['weathermitigation'] = $_POST["weathermitigation"];
  $configContents['summercut'] = $_POST["summercut"];
  $configContents['wintercut'] = $_POST["wintercut"];
  $configContents['vinedefoliation'] = $_POST["vinedefoliation"];
  $configContents['vinefertiliser'] = $_POST["vinefertiliser"];
  $configContents['vinewater'] = $_POST["vinewater"];
  $configContents['vinefullservice'] = $_POST["vinefullservicetoggle"];
  $configContents['sushibarsoup'] = $_POST["sushibarsoup"];
  $configContents['sushibarsalad'] = $_POST["sushibarsalad"];
  $configContents['sushibarsushi'] = $_POST["sushibarsushi"];
  $configContents['sushibardessert'] = $_POST["sushibardessert"];
  $configContents['scoutfood'] = $_POST["scoutfood"];
  $configContents['doinsecthotel'] = $_POST["doinsecthoteltoggle"];

  // clean up deprecated variables
  // if (isset($configContents['megafieldinstantplant'])) unset($configContents['megafieldinstantplant']);
  // if (isset($configContents['crslots2feed'])) unset($configContents['crslots2feed']);
  for ($i = 1; $i <= 15; $i++)
   $configContents['racecowslot' . $i] = $_POST["racecowslot" . $i];
  for ($i = 1; $i <= 4; $i++) {
   $configContents['fruitstallslot' . $i] = $_POST["fruitstallslot" . $i];
   if ($i == 4)
    break;
   $configContents['fruitstall2slot' . $i] = $_POST["fruitstall2slot" . $i];
  }
  if (!empty($_POST["autobuyitems"]))
   $configContents['autobuyitems'] = str_replace(",", " ", $_POST["autobuyitems"]);
  else
   $configContents['autobuyitems'] = 0;
  for ($i = 1; $i <= 17; $i++)
   $configContents['flowerarrangementslot' . $i] = $_POST["flowerarrangementslot" . $i];
  for ($i = 1; $i <= 3; $i++) {
   $configContents['speciesbait' . $i] = $_POST["speciesbait" . $i];
   $configContents['raritybait' . $i] = $_POST["raritybait" . $i];
   $configContents['fishinggear' . $i] = $_POST["fishinggear" . $i];
   $configContents['preferredbait' . $i] = $_POST["preferredbait" . $i];
  }
  if (!empty($_POST["autobuybutterflies"]))
   $configContents['autobuybutterflies'] = str_replace(",", " ", $_POST["autobuybutterflies"]);
  else
   $configContents['autobuybutterflies'] = 0;

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
