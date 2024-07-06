<?php
// Functions file for My Free Farm Bash Bot (front end)
// Copyright 2016-24 Harry Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// For license see LICENSE file
//
function CreateOptions() {
 global $productlist;
 foreach (func_get_args() as $i)
	echo "<option value=\"$i\">$productlist[$i]</option>\n";
}
function CreateOptionsWithID() {
 global $productlist;
 $arr = func_get_args();
 $prefix = array_shift($arr);
 foreach ($arr as $i)
	echo "<option id=\"$prefix$i\" value=\"$i\">$productlist[$i]</option>\n";
}
function CreateOptionsWithIDfromArray($arr) {
 global $productlist;
 foreach ($arr as $i)
	echo "<option id=\"o$i\" value=\"$i\">$productlist[$i]</option>\n";
}
function CreateMonsterOptions() {
 global $monsterlist;
 if (isset($monsterlist[1]))
    foreach (func_get_args() as $i)
        echo "<option value=\"$i\">$monsterlist[$i]</option>\n";
}
function CreateForestryOptions() {
 global $forestryproductlist;
 foreach (func_get_args() as $i)
  echo "<option value=\"$i\">$forestryproductlist[$i]</option>\n";
}
function CreateFoodworldOptions() {
 global $foodworldproductlist;
 if (isset($foodworldproductlist[1]))
    foreach (func_get_args() as $i)
        echo "<option value=\"$i\">$foodworldproductlist[$i]</option>\n";
}
function CreateMegaFieldOptions() {
 global $megafieldvehicleslist;
 if (isset($megafieldvehicleslist[1]))
    foreach (func_get_args() as $i)
        echo "<option value=\"$i\">$megafieldvehicleslist[$i]</option>\n";
}
function CreateWindMillOptions() {
 global $windmillproductlist;
 foreach (func_get_args() as $i)
  echo "<option value=\"$i\">$windmillproductlist[$i]</option>\n";
}
function CreatePonyFarmOptions() {
 global $ponyfarmproductlist;
 foreach (func_get_args() as $i)
  echo "<option value=\"$i\">$ponyfarmproductlist[$i]</option>\n";
}
function CreateFishingGearOptions() {
 global $farmdata;
 $arr = func_get_args();
 $prefix = array_shift($arr);
 foreach ($arr as $i)
	echo "<option id=\"$prefix$i\" value=\"$i\">{$farmdata["updateblock"]["farmersmarket"]["fishing"]["config"]["items"][$i]["name"]}</option>\n";
}
function CreateEventGardenOptions() {
 global $eventgardenproductlist;
 foreach (func_get_args() as $i)
  echo "<option value=\"$i\">$eventgardenproductlist[$i]</option>\n";
}
function CreateSelectionsForBuildingID($BuildingID, $position) {
 echo "<select id=\"itempos$position\" name=\"itempos$position\">\n";
 switch ($BuildingID) {
  case 1:
        // Acker
        echo "<option value=\"sleep\">Sleep</option>\n";
        global $farm;
        if ($farm == 5)
         CreateOptions(351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361);
        else
        if ($farm == 6)
         CreateOptions(700, 701, 702, 703, 704, 705, 706, 707, 708, 709);
        else
        if ($farm == 8)
         CreateOptions(950, 951, 952, 953, 954, 955, 956, 957);
        else
         CreateOptions(1, 2, 3, 4, 5, 6, 7, 8, 17, 18, 19, 20, 21, 22, 23, 24, 26, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 97, 104, 107, 108, 109, 112, 113, 114, 115, 126, 127, 128, 129, 153, 154, 158, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834);
        echo "</select>\n";
        break;
  case 2:
        // Hühnerstall
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(1, 2);
        echo "</select>
        <input id=\"amountpos$position\" name=\"amountpos$position\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 3:
        // Kuhstall
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(3, 4);
        echo "</select>
        <input id=\"amountpos$position\" name=\"amountpos$position\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 4:
        // Schafskoppel
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(5, 6);
        echo "</select>
        <input id=\"amountpos$position\" name=\"amountpos$position\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 5:
        // Imkerei
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(7, 8);
        echo "</select>
        <input id=\"amountpos$position\" name=\"amountpos$position\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 11:
        // Fischzucht
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(92, 93);
        echo "</select>
        <input id=\"amountpos$position\" name=\"amountpos$position\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 12:
        // Ziegenfarm
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(108, 109);
        echo "</select>
        <input id=\"amountpos$position\" name=\"amountpos$position\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 15:
        // Angorastall
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(153, 154);
        echo "</select>
        <input id=\"amountpos$position\" name=\"amountpos$position\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 16:
        // Strickerei
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(155, 156, 157);
        echo "</select>\n";
        break;
  case 7:
        // Mayo-Küche
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(25, 144);
        echo "</select>\n";
        break;
  case 8:
        // Käserei
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(27, 111);
        echo "</select>\n";
        break;
  case 9:
        // Wollspinnerei
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(28, 152);
        echo "</select>\n";
        break;
  case 10:
        // Bonbonküche
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(30, 820, 821, 822, 823, 824);
        echo "</select>\n";
        break;
  case 13:
        // Ölpresse
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(116, 117, 118, 119, 120, 121);
        echo "</select>\n";
        break;
  case 14:
        // Spezialölmanufaktur
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(122, 123, 124, 125);
        echo "</select>\n";
        break;
  case 18:
        // Ponyhof
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreatePonyFarmOptions(2, 4, 8);
        echo "</select>\n";
        break;
  case 19:
        // Fahrzeughalle
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateMegaFieldOptions(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        echo "</select>\n";
        break;
  case 20:
        // Biosprit-Anlage
        echo "<option value=\"sleep\">Sleep</option>\n";
        global $farm;
        global $farmdata;
        CreateOptionsWithIDfromArray(array_keys($farmdata["updateblock"]["farms"]["farms"]["$farm"]["$position"]["data"]["data"]["slots"]["1"]["products"]));
        echo "</select>\n";
        break;
  case 21:
        // Teeverfeinerung
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(750, 751, 752, 753, 754, 755, 756, 757, 758, 759);
        echo "</select>\n";
        break;
  case 23:
        // Sushi-Bar
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(970, 971, 972, 973, 974, 975, 976, 977, 978, 979, 980, 981, 982, 983, 984, 985);
        echo "</select>\n";
        break;
  case "flowerarea":
        // Blumenwiese
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 998);
        // 998 is a self created item (!)
        echo "</select>\n";
        break;
  case "nursery":
        // Blumenwerkstatt
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221);
        echo "</select>\n";
        break;
  case "monsterfruit":
        // Monsterfruchtzucht
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateMonsterOptions(1, 2, 3, 4, 5, 6, 7, 27, 28, 29, 30, 31, 10, 11, 12, 13, 14, 15, 16, 32, 33, 34, 35, 36, 20, 21, 22, 23, 24, 25, 26, 37, 38, 39, 40, 41);
        echo "</select>\n";
        break;
  case "vet":
        // Tierarzt
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 400, 401, 402, 403);
        echo "</select>\n";
        break;
  case "cowracing":
        // Kuh-Rennstall
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819);
        echo "</select>\n";
        break;
  case "fishing":
        // Anglerhütte
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911, 912, 913, 914, 915, 916, 917, 918, 919, 920, 921, 922, 923);
        echo "</select>\n";
        break;
  case "scouts":
        // Pfadfinder
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007);
        echo "</select>\n";
        break;
  case "pets":
        // Tieraufzucht
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669);
        echo "</select>\n";
        break;
  case "sawmill":
        // Sägewerk
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateForestryOptions(41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67);
        echo "</select>\n";
        break;
  case "carpentry":
        // Schreinerei
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateForestryOptions(101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 143, 144, 146, 148, 149, 150, 151, 152, 153, 154, 155, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215);
        echo "</select>\n";
        break;
  case "forestry":
        // Bäumerei
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateForestryOptions(1, 2, 3, 4, 5, 7, 8, 9, 10);
        echo "</select>\n";
        break;
  case "sodastall":
        // Getränkebude
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateFoodworldOptions(1, 2, 3, 4, 5, 6, 15, 16, 17, 49, 50, 51, 52, 53, 54);
        echo "</select>\n";
        break;
  case "snackbooth":
        // Imbissbude
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateFoodworldOptions(7, 8, 9, 10, 11, 12, 13, 14, 18, 19, 20, 55, 56, 57, 58);
        echo "</select>\n";
        break;
  case "pastryshop":
        // Konditorei
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateFoodworldOptions(21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 59, 60, 61, 62, 63, 64);
        echo "</select>\n";
        break;
  case "icecreamparlour":
        // Eisdiele
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateFoodworldOptions(31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41 ,42, 43 ,44, 45, 46, 47, 48);
        echo "</select>\n";
        break;
  case "windmill":
  case "powerups":
        // Mühle/Power-Ups
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateWindMillOptions(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35);
        echo "</select>\n";
        break;
  case "trans25":
  case "trans26":
  case "trans27":
  case "trans28":
  case "trans29":
        // Transport -> Farms 5 - 9
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateOptions(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20, 21, 22, 23, 24, 26, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 92, 93, 97, 104, 107, 108, 109, 110, 111, 112, 113, 114, 115, 126, 127, 128, 129, 151, 152, 153, 154, 155, 156, 157, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834, 950, 951, 952, 953, 954, 955, 956, 957);
        echo "</select>
        <input id=\"amountpos$position\" name=\"amountpos$position\" type=\"text\" maxlength=\"5\" size=\"5\">\n";
        break;
  case "tools":
        // Werkzeuge
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateForestryOptions(200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215);
        echo "</select>\n";
        break;
  case "eventgarden":
        // Event-Acker
        echo "<option value=\"sleep\">Sleep</option>\n";
        CreateEventGardenOptions("pentecost1", "pentecost5", "pentecost2", "pentecost6", "pentecost3", "pentecost7", "pentecost4", "pentecost8", "waterbattle1", "waterbattle2", "waterbattle3", "waterbattle4", "waterbattle5", "icedeliveryevent1", "icedeliveryevent2", "icedeliveryevent3", "tinkergame1", "tinkergame2", "tinkergame3", "tinkergame4", "tinkergame5", "tinkergame6", "invasion1", "invasion2", "invasion3", "giftdeliveryevent1", "giftdeliveryevent2", "giftdeliveryevent3", "olympia1", "olympia2", "olympia3", "cropaction1", "cropaction2", "cropaction3", "cropaction4", "cropaction5", "rainbowevent1", "rainbowevent2", "rainbowevent3", "rainbowevent4", "rainbowevent5", "collectevent1", "collectevent2", "collectevent3", "collectevent4", "collectevent5");
        echo "</select>\n";
        break;
  default:
        // nicht unterstuetzte auswahl
        echo "<option value=\"sleep\">Sleep</option></select>\n";
        break;
	}
}
function GetQueueCount($gamepath, $farm, $position) {
 $retval = exec("ls -ld " . $gamepath . "/" . $farm . "/" . $position . "/* | wc -l");
 return $retval;
}
function PlaceQueueButtons($position, $QueueNum) {
 global $strings;
 echo "<input type=\"image\" src=\"image/rewind.png\" class=\"queuebtn\" onclick=\"return insertOptionBefore(document.getElementById('itempos$position'), document.getElementById('qsel$position$QueueNum'), (document.getElementById('amountpos$position')) ? document.getElementById('amountpos$position').value : void(0))\" title=\"{$strings['placebefore']}\">
 <input type=\"image\" src=\"image/close.png\" class=\"queuebtn\" onclick=\"return removeOptionSelected(document.getElementById('qsel$position$QueueNum'))\" ondblclick=\"return removeOptionAll(document.getElementById('qsel$position$QueueNum'))\" title=\"{$strings['deletequeueitem']}\">
 <input type=\"image\" src=\"image/fastforward.png\" class=\"queuebtn\" onclick=\"return appendOptionLast(document.getElementById('itempos$position'), document.getElementById('qsel$position$QueueNum'), (document.getElementById('amountpos$position')) ? document.getElementById('amountpos$position').value : void(0))\" title=\"{$strings['placeatend']}\">\n";
}
function PlaceQueues($gamepath, $farm, $position, $QueueNum) {
 global $farmdata;
 echo "<input type=\"hidden\" name=\"queue$QueueNum\" value=\"" . GetQueueName($gamepath, $farm, $position, $QueueNum) . "\">\n";
 switch ($position) {
  case "flowerarea":
	$buildingType = "FlowerArea";
	break;
  case "nursery":
	$buildingType = "Nursery";
	break;
  case "monsterfruit":
	$buildingType = "MonsterFruitHelper";
	break;
  case "vet":
	$buildingType = "Vet";
	break;
  case "pets":
	$buildingType = "Pets";
	break;
  case "cowracing":
	$buildingType = "CowRacing";
	break;
  case "fishing":
	$buildingType = "Fishing";
	break;
  case "scouts":
	$buildingType = "Scouts";
	break;
  case "windmill":
	$buildingType = "WindMill";
	break;
  case "forestry":
	$buildingType = "Tree";
	break;
  case "trans25":
  case "trans26":
  case "trans27":
  case "trans28":
  case "trans29":
	$buildingType = "AutoTrans";
	break;
  case "powerups":
	$buildingType = "PowerUps";
	break;
  case "tools":
	$buildingType = "Tools";
	break;
  case "eventgarden":
	$buildingType = "EventGarden";
	break;
  case "1": // this has to be the last case before the default!
  case "2": // otherwise it would mess up buildings found in "1" ,"2", "3" and "4" folders
  case "3":
  case "4":
  if ($farm === "forestry") {
    $buildingType = "ForestryBuilding";
  break;
  }
	if ($farm === "foodworld") {
	 $buildingType = "FoodWorldBuilding";
  break;
	}
  default:
  $buildingType = GetBuildingTypeForBuildingID($farmdata["updateblock"]["farms"]["farms"]["$farm"]["$position"]["buildingid"]);
  break;
 }
 echo "<input type=\"hidden\" name=\"BuildingType\" value=\"$buildingType\">
 <select id=\"qsel$position$QueueNum\" size=\"5\" multiple>";
 echo CreateQueueList($gamepath, $farm, $position, GetQueueName($gamepath, $farm, $position, $QueueNum), $buildingType);
 echo "</select>";
}
function GetQueueName($gamepath, $farm, $position, $QueueNum) {
 $retval=exec("ls -1 " . $gamepath . "/" . $farm . "/" . $position . "/ | head -" . $QueueNum . " | tail -1");
 return $retval;
}
function GetBuildingTypeForBuildingID($buildingID) {
 switch ($buildingID) {
  case 1:
	return "Farm";
	break;
  case 2:
  case 3:
  case 4:
  case 5:
  case 11:
  case 12:
  case 15:
	return "Stable";
	break;
  case 7:
  case 8:
  case 9:
  case 10:
	return "Factory";
	break;
  case 13:
  case 14:
	return "OilMill";
	break;
  case 16:
	return "KnittingMill";
	break;
  case 18:
	return "PonyFarm";
	break;
  case 19:
	return "MegaField";
	break;
  case 20:
	return "FuelStation";
	break;
  case 21:
	return "TeaFactory";
	break;
  case 23:
	return "SushiBar";
	break;
  default:
	return "unsupported";
  }
}
function CreateQueueList($gamepath, $farm, $position, $queueName, $buildingType) {
 $filename = $gamepath . "/" . $farm . "/" . $position . "/" . $queueName;
 $fh = fopen($filename, "r");
 // skip first entry, we're using live data building type
 if ($fh)
  $queueItem = fgets($fh, 64);
 while (($queueItem = fgets($fh, 64)) !== false)
  CreateOptionForQueueList($queueItem, $buildingType);
 fclose($fh);
}
function CreateOptionForQueueList($queueItem, $buildingType) {
 global $productlist;
 global $monsterlist;
 global $forestryproductlist;
 global $foodworldproductlist;
 global $megafieldvehicleslist;
 global $windmillproductlist;
 global $ponyfarmproductlist;
 global $eventgardenproductlist;
 if ($queueItem == "sleep\n")
  $queueItemFriendlyName = "Sleep";
 else {
  switch ($buildingType) {
   case "Farm":
   case "Factory":
   case "FlowerArea":
   case "Nursery":
   case "Pets":
   case "Vet":
   case "CowRacing":
   case "Fishing":
   case "Scouts":
   case "FuelStation":
   case "TeaFactory":
   case "SushiBar":
   case "KnittingMill":
   case "OilMill":
   $queueItemFriendlyName = $productlist[intval($queueItem)];
   break;
   case "Stable":
   case "AutoTrans":
   // first the item, then the amount
   $queueItemParts = explode(",", $queueItem);
   $queueItemFriendlyName = $queueItemParts[1] . " " . $productlist[$queueItemParts[0]];
   break;
   case "MonsterFruitHelper":
   $queueItemFriendlyName = $monsterlist[intval($queueItem)];
   break;
   case "ForestryBuilding":
   case "Tree":
   case "Tools":
   $queueItemFriendlyName = $forestryproductlist[intval($queueItem)];
   break;
   case "FoodWorldBuilding":
   $queueItemFriendlyName = $foodworldproductlist[intval($queueItem)];
   break;
   case "MegaField":
   $queueItemFriendlyName = $megafieldvehicleslist[intval($queueItem)];
   break;
   case "WindMill":
   case "PowerUps":
   $queueItemFriendlyName = $windmillproductlist[intval($queueItem)];
   break;
   case "PonyFarm":
   $queueItemFriendlyName = $ponyfarmproductlist[intval($queueItem)];
   break;
   case "EventGarden":
   $queueItemFriendlyName = $eventgardenproductlist[rtrim($queueItem)];
   break;
   default:
   $queueItemFriendlyName = "Sleep";
   break;
  }
 }
 $queueItem = str_replace("\n", '', $queueItem);
 echo "<option value=\"$queueItem\">$queueItemFriendlyName</option>\n";
}
function saveConfig($filename, $queueData) {
 if (!$handle = fopen($filename, 'w'))
  return false;
 // skip first entry, we're using live data building type
 for ($itemcount = 1; $itemcount <= count($queueData); $itemcount++)
  $result = fwrite($handle, $queueData[$itemcount - 1] . "\n");
 fclose($handle);
 return $result;
}
function writeINI($configData, $filename) {
 $data2write = "";
 foreach ($configData as $configItem => $iValue)
  $data2write .= $configItem . " = " . (is_numeric($iValue) ? $iValue : "'" . $iValue . "'") . "\n";
 if (!$handle = fopen($filename, 'w'))
  return false;
 $result = fwrite($handle, $data2write);
 fclose($handle);
 return $result;
}
?>
