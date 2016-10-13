<?php
// Functions file for Harrys My Free Farm Bash Bot (front end)
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
function CreateOptions() {
 global $productlist;
 foreach (func_get_args() as $i)
	print "<option value=\"" . $i . "\">" . $productlist[$i]  . "</option>\n";
}
function CreateOilOptions() {
 global $oillist;
 foreach (func_get_args() as $i)
        print "<option value=\"" . $i . "\">" . $oillist[$i]  . "</option>\n";
}
function CreateWoolOptions() {
 global $woollist;
 foreach (func_get_args() as $i)
        print "<option value=\"" . $i . "\">" . $woollist[$i]  . "</option>\n";
}
function CreateMonsterOptions() {
 global $monsterlist;
 foreach (func_get_args() as $i)
        print "<option value=\"" . $i . "\">" . $monsterlist[$i]  . "</option>\n";
}
function CreateForestryOptions() {
 global $forestryproductlist;
 foreach (func_get_args() as $i)
        print "<option value=\"" . $i . "\">" . $forestryproductlist[$i]  . "</option>\n";
}
function CreateFoodworldOptions() {
 global $foodworldproductlist;
 foreach (func_get_args() as $i)
        print "<option value=\"" . $i . "\">" . $foodworldproductlist[$i]  . "</option>\n";
}
function CreateMegaFieldOptions() {
 global $megafieldvehicleslist;
 foreach (func_get_args() as $i)
        print "<option value=\"" . $i . "\">" . $megafieldvehicleslist[$i]  . "</option>\n";
}
function CreateWindMillOptions() {
 global $windmillproductlist;
 foreach (func_get_args() as $i)
        print "<option value=\"" . $i . "\">" . $windmillproductlist[$i]  . "</option>\n";
}
function CreateSelectionsForBuildingID($BuildingID, $position) {
 print "<select id=\"itempos" . $position . "\" name=\"itempos" . $position . "\">\n";
 switch ($BuildingID) {
  case 1:
        // Acker
        CreateOptions(1, 2, 3, 4, 5, 6, 7, 8, 17, 18, 19, 20, 21, 22, 23, 24, 26, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 97, 104, 107, 108, 109, 112, 113, 114, 115, 126, 127, 128, 129, 153, 154, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case 2:
        // Hühnerstall
        CreateOptions(1, 2);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        print "<input id=\"amountpos" . $position . "\" name=\"amountpos" . $position . "\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 3:
        // Kuhstall
        CreateOptions(3, 4);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        print "<input id=\"amountpos" . $position . "\" name=\"amountpos" . $position . "\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 4:
        // Schafskoppel
        CreateOptions(5, 6);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        print "<input id=\"amountpos" . $position . "\" name=\"amountpos" . $position . "\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 5:
        // Imkerei
        CreateOptions(7, 8);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        print "<input id=\"amountpos" . $position . "\" name=\"amountpos" . $position . "\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 11:
        // Fischzucht
        CreateOptions(92, 93);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        print "<input id=\"amountpos" . $position . "\" name=\"amountpos" . $position . "\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 12:
        // Ziegenfarm
        CreateOptions(108, 109);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        print "<input id=\"amountpos" . $position . "\" name=\"amountpos" . $position . "\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 15:
        // Angorastall
        CreateOptions(153, 154);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        print "<input id=\"amountpos" . $position . "\" name=\"amountpos" . $position . "\" type=\"text\" maxlength=\"3\" size=\"3\">\n";
        break;
  case 16:
        // Strickerei
        CreateWoolOptions(1, 2, 3);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case 7:
        // Mayo-Küche
        CreateOptions(9, 21);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case 8:
        // Käserei
        CreateOptions(10, 110);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case 9:
        // Wollspinnerei
        CreateOptions(11, 151);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case 10:
        // Bonbonküche
        CreateOptions(12);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case 13:
        // Ölpresse
        CreateOilOptions(1, 2, 3, 4, 5, 6);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case 14:
        // Spezialölmanufaktur
        CreateOilOptions(7, 8, 9, 10);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case 19:
        // Fahrzeughalle
        CreateMegaFieldOptions(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case 20:
        // Biosprit-Anlage
        CreateOptions(1, 2, 3, 4, 5, 6, 7, 8, 17, 18, 19, 20, 21, 22, 23, 24, 26, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 108, 109, 112, 113, 114, 115, 126, 127, 128, 153, 154);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "flowerarea":
        // Blumenwiese
        CreateOptions(171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 998);
        // 998 is a self created item (!)
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "nursery":
        // Blumenwerkstatt
        CreateOptions(200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "monsterfruit":
        // Monsterfruchtzucht
        CreateMonsterOptions(1, 2, 3, 4, 5, 6, 7, 10, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "vet":
        // Tierarzt
        CreateOptions(300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 400, 401, 402, 403);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "pets":
        // Tieraufzucht
        CreateOptions(600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "sawmill":
        // Sägewerk
        CreateForestryOptions(41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "carpentry":
        // Schreinerei
        CreateForestryOptions(101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 143, 144, 146, 148, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "forestry":
        // Bäumerei
        CreateForestryOptions(1, 2, 3, 4, 5, 7, 8, 9);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "sodastall":
        // Getränkebude
        CreateFoodworldOptions(1, 2, 3, 4, 5, 6, 15, 16, 17, 49, 50, 51, 52, 53, 54);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "snackbooth":
        // Imbissbude
        CreateFoodworldOptions(7, 8, 9, 10, 11, 12, 13, 14, 18, 19, 20, 55, 56, 57, 58);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "pastryshop":
        // Konditorei
        CreateFoodworldOptions(21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 59, 60, 61, 62, 63, 64);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "icecreamparlour":
        // Eisdiele
        CreateFoodworldOptions(31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41 ,42, 43 ,44, 45, 46, 47, 48);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  case "windmill":
        // Mühle
        CreateWindMillOptions(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35);
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
  default:
        // nicht unterstuetzte auswahl
        print "<option value=\"sleep\">Sleep</option></select>\n";
        break;
	}
}
function GetQueueCount($gamepath, $farm, $position) {
 $retval = exec("ls -ld " . $gamepath . "/" . $farm . "/" . $position . "/* | wc -l");
 return $retval;
}
function PlaceQueueButtons($position, $QueueNum) {
 print"<td align=\"center\">";
 print "<input type=\"button\" value=\"&lt;&lt;\" onclick=\"insertOptionBefore(document.getElementById('itempos" . $position . "'), document.getElementById('qsel" . $position . $QueueNum . "'), (document.getElementById('amountpos" . $position . "')) ? document.getElementById('amountpos" . $position . "').value : void(0))\" title=\"Auswahl vor die Markierung in der Warteschlange setzen\" style=\"height:20px; width:22px; padding:0px\">";
 print "<input type=\"button\" value=\"X\" onclick=\"removeOptionSelected(document.getElementById('qsel" . $position . $QueueNum . "'))\" title=\"Markiertes Element in Warteschlange l&ouml;schen\" style=\"height:20px; width:22px; margin-left:3px; margin-right:3px\">";
 print "<input type=\"button\" value=\"&gt;&gt;\" onclick=\"appendOptionLast(document.getElementById('itempos" . $position . "'), document.getElementById('qsel" . $position . $QueueNum . "'), (document.getElementById('amountpos" . $position . "')) ? document.getElementById('amountpos" . $position . "').value : void(0))\" title=\"Auswahl ans Ende der Warteschlange setzen\" style=\"height:20px; width:22px; padding:0px\">";
 print "</td>";
}
function PlaceQueues($gamepath, $farm, $position, $QueueNum) {
 global $farmdata;
 print"<td align=\"center\">";
 print "<input type=\"hidden\" name=\"queue" . $QueueNum . "\" value=\"" . GetQueueName($gamepath, $farm, $position, $QueueNum) . "\">\n";
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
  case "windmill":
	$buildingType = "WindMill";
	break;
  case "forestry":
	$buildingType = "Tree";
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
 print "<input type=\"hidden\" name=\"BuildingType\" value=\"" . $buildingType . "\">\n"; 
 print "<select id=\"qsel" . $position . $QueueNum . "\" size=\"5\" multiple>";
 print CreateQueueList($gamepath, $farm, $position, GetQueueName($gamepath, $farm, $position, $QueueNum), $buildingType);
 print "</select>";
 print "</td>\n";
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
  case 19:
	return "MegaField";
	break;
  case 20:
	return "FuelStation";
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
 global $oillist;
 global $woollist;
 global $monsterlist;
 global $forestryproductlist;
 global $foodworldproductlist;
 global $megafieldvehicleslist;
 global $windmillproductlist;
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
   case "FuelStation":
   $queueItemFriendlyName = $productlist[intval($queueItem)];
   break;
   case "OilMill":
   $queueItemFriendlyName = $oillist[intval($queueItem)];
   break;
   case "KnittingMill":
   $queueItemFriendlyName = $woollist[intval($queueItem)];
   break;
   case "Stable":
   // first the item, then the amount
   $queueItemParts = explode(",", $queueItem);
   $queueItemFriendlyName = $queueItemParts[1] . " " . $productlist[$queueItemParts[0]];
   break;
   case "MonsterFruitHelper":
   $queueItemFriendlyName = $monsterlist[intval($queueItem)];
   break;
   case "ForestryBuilding":
   case "Tree":
   $queueItemFriendlyName = $forestryproductlist[intval($queueItem)];
   break;
   case "FoodWorldBuilding":
   $queueItemFriendlyName = $foodworldproductlist[intval($queueItem)];
   break;
   case "MegaField":
   $queueItemFriendlyName = $megafieldvehicleslist[intval($queueItem)];
   break;
   case "WindMill":
   $queueItemFriendlyName = $windmillproductlist[intval($queueItem)];
   break;
   default:
   $queueItemFriendlyName = "Sleep";
   break;
  }
 }
 $queueItem = str_replace("\n", '', $queueItem);
 print "<option value=\"" . $queueItem . "\">" . $queueItemFriendlyName . "</option>\n";
}
function saveConfig($filename, $queueData) {
// umask(0002); // VERY BAD IDEA .. since this applies to ALL threads ;)
 $fh = fopen($filename, "w");
 // skip first entry, we're using live data building type
 if ($fh)
  for ($itemcount = 1; $itemcount <= count($queueData); $itemcount++)
   fwrite($fh, $queueData[$itemcount - 1] . "\n");
// chmod($filename, 0775);
 fclose($fh);
}
?>
