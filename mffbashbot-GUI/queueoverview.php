<?php
// Queue overview page for My Free Farm Bash Bot (front end)
// Read-only summary of every queue: what is in it and which item comes next.
// Copyright 2016-26 Harry Basalamah
//
// For license see LICENSE file
//
if (!isset($username)) {
 $u = isset($_POST["username"]) ? $_POST["username"] : (isset($_GET["username"]) ? $_GET["username"] : "");
 strpos($u, ' ') === false ? $username = $u : $username = rawurlencode($u);
}
if ($username === "") {
 header("Location: index.php");
 exit;
}
include 'config.php';
include 'lang.php';
include 'functions.php';
include 'farmdata.php'; // provides $productlist and the other product name lists

// resolve a single queue item to a friendly product name
// (mirrors CreateOptionForQueueList() in functions.php, but returns a string)
function queueItemName($queueItem, $buildingType) {
 global $productlist, $monsterlist, $forestryproductlist, $foodworldproductlist,
        $megafieldvehicleslist, $windmillproductlist, $ponyfarmproductlist, $eventgardenproductlist;
 $raw = rtrim($queueItem, "\r\n");
 if ($raw === "" || $raw === "sleep") return "Sleep";
 switch ($buildingType) {
  case "Farm": case "Factory": case "FlowerArea": case "Nursery": case "Pets":
  case "Vet": case "CowRacing": case "Fishing": case "Scouts": case "FuelStation":
  case "TeaFactory": case "SushiBar": case "SpiceHouse": case "JamFactory":
  case "KnittingMill": case "OilMill":
   return isset($productlist[intval($raw)]) ? $productlist[intval($raw)] : "ID $raw";
  case "Stable": case "AutoTrans":
   $p = explode(",", $raw);
   $nm = isset($productlist[$p[0]]) ? $productlist[$p[0]] : "ID {$p[0]}";
   return $nm . (isset($p[1]) ? " &times;{$p[1]}" : "");
  case "MonsterFruitHelper":
   return isset($monsterlist[intval($raw)]) ? $monsterlist[intval($raw)] : "ID $raw";
  case "ForestryBuilding": case "Tree": case "Tools":
   return isset($forestryproductlist[intval($raw)]) ? $forestryproductlist[intval($raw)] : "ID $raw";
  case "FoodWorldBuilding":
   return isset($foodworldproductlist[intval($raw)]) ? $foodworldproductlist[intval($raw)] : "ID $raw";
  case "MegaField":
   return isset($megafieldvehicleslist[intval($raw)]) ? $megafieldvehicleslist[intval($raw)] : "ID $raw";
  case "WindMill": case "PowerUps":
   return isset($windmillproductlist[intval($raw)]) ? $windmillproductlist[intval($raw)] : "ID $raw";
  case "PonyFarm":
   return isset($ponyfarmproductlist[intval($raw)]) ? $ponyfarmproductlist[intval($raw)] : "ID $raw";
  case "EventGarden":
   return isset($eventgardenproductlist[$raw]) ? $eventgardenproductlist[$raw] : "ID $raw";
  default:
   return "ID $raw";
 }
}

function areaLabel($area) {
 return ctype_digit($area) ? "Hof $area" : $area;
}

$showall = isset($_GET["all"]) || (isset($_POST["all"]));
?>
<!DOCTYPE html>
<html>
 <head>
  <title>My Free Farm Bash Bot - Warteschlangen-Übersicht</title>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link href="css/bootstrap.css" rel="stylesheet" type="text/css">
  <link href="css/mffbot.css" rel="stylesheet" type="text/css">
  <style>
   .qov { border-collapse: collapse; margin: 0 auto; }
   .qov th, .qov td { padding: 5px 12px; border: 1px solid #bbb; vertical-align: top; }
   .qov th { background: #343a40; color: #fff; }
   .qov tr.area td { background: #e9ecef; font-weight: bold; }
   .qnext { font-weight: bold; }
   .qbadge { background: #2e7d32; color: #fff; border-radius: 3px; padding: 0 5px; margin-right: 5px; }
   .qsep { color: #999; }
   .qidle { color: #999; }
  </style>
 </head>
 <body class="main_body" style="padding: 1.5em">
  <h3 style="text-align:center"><?php echo htmlspecialchars($username); ?> &ndash; Warteschlangen-Übersicht</h3>
  <p style="text-align:center">
   <a class="btn btn-outline-dark btn-sm" href="javascript:history.back()">&larr; Zurück</a>
   <?php if ($showall): ?>
    <a class="btn btn-outline-dark btn-sm" href="queueoverview.php?username=<?php echo rawurlencode($username); ?>">Nur belegte</a>
   <?php else: ?>
    <a class="btn btn-outline-dark btn-sm" href="queueoverview.php?username=<?php echo rawurlencode($username); ?>&amp;all=1">Alle anzeigen</a>
   <?php endif; ?>
  </p>
  <p style="text-align:center"><span class="qbadge">►</span> = wird als Nächstes gepflanzt; danach in Reihenfolge.</p>
  <table class="qov">
   <tr><th>Position</th><th>Slot</th><th>Typ</th><th>Warteschlange</th></tr>
<?php
$slotfiles = glob($gamepath . "/*/*/*");
if ($slotfiles === false) $slotfiles = array();
sort($slotfiles);

$rows = 0;
$currentArea = null;
foreach ($slotfiles as $file) {
 if (!is_file($file)) continue;
 $rel = substr($file, strlen($gamepath) + 1); // area/position/slot
 $parts = explode("/", $rel);
 if (count($parts) !== 3) continue;
 list($area, $position, $slot) = $parts;

 $lines = @file($file, FILE_IGNORE_NEW_LINES);
 if ($lines === false || count($lines) === 0) continue;
 $buildingType = $lines[0];
 $queue = array_slice($lines, 1);

 // determine head + build display list
 $items = array();
 foreach ($queue as $ln) {
  if (trim($ln) === "") continue;
  $items[] = $ln;
 }

 $isActive = (count($items) > 0 && rtrim($items[0]) !== "sleep" && $buildingType !== "unsupported");
 if (!$showall && !$isActive) continue;

 if ($area !== $currentArea) {
  echo "<tr class=\"area\"><td colspan=\"4\">" . htmlspecialchars(areaLabel($area)) . "</td></tr>\n";
  $currentArea = $area;
 }

 if (count($items) === 0 || $buildingType === "unsupported") {
  $qstr = "<span class=\"qidle\">" . ($buildingType === "unsupported" ? "n/a" : "leer / Sleep") . "</span>";
 } else {
  $rendered = array();
  $first = true;
  foreach ($items as $it) {
   $nm = queueItemName($it, $buildingType);
   if ($first) {
    $rendered[] = "<span class=\"qnext\"><span class=\"qbadge\">&#9658;</span>" . $nm . "</span>";
    $first = false;
   } else {
    $rendered[] = $nm;
   }
  }
  $qstr = implode(" <span class=\"qsep\">&rarr;</span> ", $rendered);
  if (count($rendered) > 1) $qstr .= " <span class=\"qsep\">[" . count($rendered) . "]</span>";
 }

 $typeLabel = $buildingType === "Farm" ? "Acker" : ($buildingType === "Stable" ? "Stall" : $buildingType);
 echo "<tr><td>" . htmlspecialchars($position) . "</td><td>" . htmlspecialchars($slot) .
      "</td><td>" . htmlspecialchars($typeLabel) . "</td><td>" . $qstr . "</td></tr>\n";
 $rows++;
}
if ($rows === 0)
 echo "<tr><td colspan=\"5\" style=\"text-align:center\">Keine belegten Warteschlangen. (&bdquo;Alle anzeigen&ldquo; zeigt auch leere Positionen.)</td></tr>";
?>
  </table>
 </body>
</html>
