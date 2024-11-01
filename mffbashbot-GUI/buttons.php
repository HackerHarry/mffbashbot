<?php
// Buttons file for My Free Farm Bash Bot (front end)
// Copyright 2016-24 Harry Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// For license see LICENSE file
//
$togglesarray = [
"dodog" => "dogtoggle",
"dopuzzleparts" => "puzzlepartstoggle",
"redeempuzzlepacks" => "redeempuzzlepartstoggle",
"sendfarmiesaway" => "farmiestoggle",
"sendforestryfarmiesaway" => "forestryfarmiestoggle",
"sendmunchiesaway" => "munchiestoggle",
"sendflowerfarmiesaway" => "flowerfarmiestoggle",
"correctqueuenum" => "correctqueuenumtoggle",
"useponyenergybar" => "ponyenergybartoggle",
"dobutterflies" => "butterflytoggle",
"dodeliveryevent" => "deliveryeventtoggle",
"doolympiaevent" => "olympiaeventtoggle",
"docalendarevent" => "calendareventtoggle",
"dopentecostevent" => "pentecosteventtoggle",
"doseedbox" => "redeemdailyseedboxtoggle",
"dodonkey" => "donkeytoggle",
"docowrace" => "cowracetoggle",
"docowracepvp" => "cowracepvptoggle",
"excluderank1cow" => "excluderank1cowtoggle",
"dofoodcontest" => "foodcontesttoggle",
"doinfinitequest" => "infinitequesttoggle",
"trimlogstock" => "trimlogstocktoggle",
"removeweed" => "removeweedtoggle",
"harvestvine" => "harvestvinetoggle",
"harvestvineinautumn" => "harvestvineinautumntoggle",
"restartvine" => "restartvinetoggle",
"removevine" => "removevinetoggle",
"buyvinetillsunny" => "buyvinetillsunnytoggle",
"vinefullservice" => "vinefullservicetoggle",
"doinsecthotel" => "doinsecthoteltoggle",
"doeventgarden" => "doeventgardentoggle",
"dogreenhouse" => "greenhousetoggle"
];

$toggledesc = [
$strings['ben'],
$strings['puzzlepartpurchase'],
$strings['puzzlepartredeem'],
$strings['saynotofarmies'],
$strings['saynotoforestryfarmies'],
$strings['saynotomunchies'],
$strings['saynotoflowerfarmies'],
$strings['correctqueuenumber'],
$strings['useponyenergybar'],
$strings['butterflypointbonus'],
$strings['onehourdelivery'],
$strings['refillolympiaenergy'],
$strings['opencalendardoors'],
$strings['careforpeonybush'],
$strings['dailyseedboxredeem'],
$strings['waltraud'],
$strings['startcowrace'],
$strings['startcowracepvp'],
$strings['excluderank1cow'],
$strings['feedsecontestant'],
$strings['sendrosieshopping'],
$strings['trimlogstock'],
$strings['removeweed'],
$strings['harvestvine'],
$strings['harvestvineinautumn'],
$strings['restartvine'],
$strings['removevine'],
$strings['buyvinetillsunny'],
$strings['vinefullservice'],
$strings['doinsecthotel'],
$strings['doeventgarden'],
$strings['dogreenhouse']
];

$toggledesc_tt = [
$strings['ben-tt'],
$strings['puzzlepartpurchase-tt'],
$strings['puzzlepartredeem-tt'],
$strings['saynotofarmies-tt'],
$strings['saynotoforestryfarmies-tt'],
$strings['saynotomunchies-tt'],
$strings['saynotoflowerfarmies-tt'],
$strings['correctqueuenumber-tt'],
$strings['useponyenergybar-tt'],
$strings['butterflypointbonus-tt'],
$strings['onehourdelivery-tt'],
$strings['refillolympiaenergy-tt'],
$strings['opencalendardoors-tt'],
$strings['careforpeonybush-tt'],
$strings['dailyseedboxredeem-tt'],
$strings['waltraud-tt'],
$strings['startcowrace-tt'],
$strings['startcowracepvp-tt'],
$strings['excluderank1cow-tt'],
$strings['feedsecontestant-tt'],
$strings['sendrosieshopping-tt'],
$strings['trimlogstock-tt'],
$strings['removeweed-tt'],
$strings['harvestvine-tt'],
$strings['harvestvineinautumn-tt'],
$strings['restartvine-tt'],
$strings['removevine-tt'],
$strings['buyvinetillsunny-tt'],
$strings['vinefullservice-tt'],
$strings['doinsecthotel-tt'],
$strings['doeventgarden-tt'],
$strings['dogreenhouse-tt']
];

echo "<h1>{$strings['youareat']} {$farmFriendlyName["$farm"]}</h1>
<form name=\"venueselect\" method=\"post\" action=\"showfarm.php\" style=\"margin-bottom:5px;\">
<input type=\"hidden\" name=\"farm\" value=\"$farm\">
<input type=\"hidden\" name=\"username\" value=\"$username\">\n";
for ($i = 1; $i <= 10; $i++)
 echo "<input type=\"image\" src=\"image/navi_farm$i.png\" class=\"navilink\" title=\"$farmFriendlyName[$i]\" name=\"$i\" onclick=\"document.venueselect.farm.value = '$i'; this.form.submit();\">\n";
echo "<input type=\"image\" src=\"image/farmersmarket.png\" class=\"navilink\" title=\"{$farmFriendlyName['farmersmarket']}\" name=\"farmersmarket\" onclick=\"document.venueselect.farm.value='farmersmarket'; document.venueselect.action='showvenue.php'; this.form.submit()\">
<input type=\"image\" src=\"image/farmersmarket2.png\" class=\"navilink\" title=\"{$farmFriendlyName['farmersmarket2']}\" name=\"farmersmarket2\" onclick=\"document.venueselect.farm.value='farmersmarket2'; document.venueselect.action='showvenue.php'; this.form.submit()\">
<input type=\"image\" src=\"image/forestry.png\" class=\"navilink\" title=\"{$farmFriendlyName['forestry']}\" name=\"forestry\" onclick=\"document.venueselect.farm.value='forestry'; this.form.action='showvenue.php'; this.form.submit()\">
<input type=\"image\" src=\"image/foodworld.png\" class=\"navilink\" title=\"{$farmFriendlyName['foodworld']}\" name=\"foodworld\" onclick=\"document.venueselect.farm.value='foodworld'; this.form.action='showvenue.php'; this.form.submit()\">
<input type=\"image\" src=\"image/navi_city2.png\" class=\"navilink\" title=\"{$farmFriendlyName['city2']}\" name=\"city2\" onclick=\"document.venueselect.farm.value='city2'; this.form.action='showvenue.php'; this.form.submit()\">
<input type=\"image\" src=\"image/runbot.png\" class=\"navilink\" name=\"runbot\" title=\"{$strings['forcebotstart']}\" onclick=\"document.venueselect.farm.value='runbot'; this.form.submit()\">&nbsp;
<input type=\"button\" name=\"logon\" class=\"btn btn-warning btn-sm logonbtn\" value=\"{$strings['logon']}\" onclick=\"this.form.action='index.php'; this.form.submit()\">
<br><br>\n";

echo "<button class=\"btn btn-outline-dark btn-sm\" id=\"optbtn\" onclick=\"showHideOptions('optionspane'); return false;\">{$strings['options']}...</button>
<button class=\"btn btn-outline-dark btn-sm\" id=\"opt2btn\" onclick=\"showHideOptions('options2pane'); return false;\">{$strings['moreoptions']}...</button>
<button class=\"btn btn-outline-dark btn-sm\" id=\"flowerarrangementsbtn\" onclick=\"showHideOptions('flowerarrangementspane'); return false;\">{$strings['flowerarrangements']}...</button>
<button class=\"btn btn-outline-dark btn-sm\" id=\"cowslotsbtn\" onclick=\"showHideOptions('racecowslotspane'); return false;\">{$strings['racecowslots']}...</button>
<button class=\"btn btn-outline-dark btn-sm\" id=\"autobuybtn\" onclick=\"showHideOptions('autobuypane'); return false;\">{$strings['stockmgmt']}...</button>
<button class=\"btn btn-outline-dark btn-sm\" id=\"butterflybtn\" onclick=\"showHideOptions('butterflybuypane'); return false;\">{$strings['butterflies']}...</button>
<hr>\n";
// toggles
echo "<div id=\"optionspane\" style=\"display:none;\">
<table id=\"opttbl\" style=\"float:left;\" border=\"1\">
<caption>{$strings['options']}</caption>\n";
for ($i = 0; $i < count($togglesarray); $i++) {
 $savedkey=key($togglesarray);
 $toggle=$togglesarray[$savedkey];
 echo "<tr><td><span title='$toggledesc_tt[$i]'>
 <label class=\"switch\">
 <input type=\"checkbox\" id=\"$toggle\" name=\"$toggle\" onchange=\"saveMisc();\" value=\"1\">
 <span class=\"slider round\"></span></label>$toggledesc[$i]
 </span></td></tr>\n";
 next($togglesarray);
}
// more options
echo "</table>
</div>
<div id=\"options2pane\" style=\"display:none;\">
<table id=\"opttbl2\" style=\"float:left;\" border=\"1\">
<caption>{$strings['moreoptions']}</caption>
<tr><td>
<select id=\"lottoggle\" name=\"lottoggle\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"lot0\">Sleep</option>
<option value=\"1\" id=\"lot1\">{$strings['lot']}</option>
<option value=\"2\" id=\"lot2\">{$strings['instantwin']}</option></select>&nbsp;{$strings['collectdaily']}
</td></tr>
<tr><td>
<select id=\"loginbonus\" name=\"loginbonus\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"o0\">Sleep</option>\n";
CreateOptionsWithIDfromArray($farmdata["updateblock"]["menue"]["loginbonus"]["products"]);
echo "</select>&nbsp;{$strings['collectloginbonus']}
</td></tr>
<tr><td>
<select id=\"vehiclemgmt5\" name=\"vehiclemgmt5\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"vehicle0\">Sleep</option>
<option value=\"1\" id=\"vehicle1\">{$strings['sheepcart']}</option>
<option value=\"2\" id=\"vehicle2\">{$strings['tractor']}</option>
<option value=\"3\" id=\"vehicle3\">{$strings['lorry']}</option>
<option value=\"4\" id=\"vehicle4\">{$strings['sportscar']}</option>
<option value=\"5\" id=\"vehicle5\">{$strings['truck']}</option></select>&nbsp;{$strings['autotransport5']}
</td></tr>
<tr><td>
<select id=\"vehiclemgmt6\" name=\"vehiclemgmt6\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"vehicle0\">Sleep</option>
<option value=\"6\" id=\"vehicle6\">{$strings['dogsled']}</option>
<option value=\"7\" id=\"vehicle7\">{$strings['atv']}</option>
<option value=\"8\" id=\"vehicle8\">{$strings['snowgroomer']}</option>
<option value=\"9\" id=\"vehicle9\">{$strings['helicopter']}</option>
<option value=\"10\" id=\"vehicle10\">{$strings['hotairballoon']}</option></select>&nbsp;{$strings['autotransport6']}
</td></tr>
<tr><td>
<select id=\"vehiclemgmt7\" name=\"vehiclemgmt7\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"vehicle0\">Sleep</option>
<option value=\"11\" id=\"vehicle11\">{$strings['coach']}</option>
<option value=\"12\" id=\"vehicle12\">{$strings['tuktuk']}</option>
<option value=\"13\" id=\"vehicle13\">{$strings['sprinter']}</option>
<option value=\"14\" id=\"vehicle14\">{$strings['drone']}</option>
<option value=\"15\" id=\"vehicle15\">{$strings['airplane']}</option></select>&nbsp;{$strings['autotransport7']}
</td></tr>
<tr><td>
<select id=\"vehiclemgmt8\" name=\"vehiclemgmt8\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"vehicle0\">Sleep</option>
<option value=\"16\" id=\"vehicle16\">{$strings['rowingboat']}</option>
<option value=\"17\" id=\"vehicle17\">{$strings['swampboat']}</option>
<option value=\"18\" id=\"vehicle18\">{$strings['barge']}</option>
<option value=\"19\" id=\"vehicle19\">{$strings['waterhelicopter']}</option>
<option value=\"20\" id=\"vehicle20\">{$strings['containership']}</option></select>&nbsp;{$strings['autotransport8']}
</td></tr>
<tr><td>
<select id=\"vehiclemgmt9\" name=\"vehiclemgmt9\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"vehicle0\">Sleep</option>
<option value=\"21\" id=\"vehicle21\">{$strings['draisine']}</option>
<option value=\"22\" id=\"vehicle22\">{$strings['steamtrain']}</option>
<option value=\"23\" id=\"vehicle23\">{$strings['diesellocomotive']}</option>
<option value=\"24\" id=\"vehicle24\">{$strings['expresstrain']}</option>
<option value=\"25\" id=\"vehicle25\">{$strings['freighttrain']}</option></select>&nbsp;{$strings['autotransport9']}
</td></tr>
<tr><td>
<select id=\"vehiclemgmt10\" name=\"vehiclemgmt10\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"vehicle0\">Sleep</option>
<option value=\"26\" id=\"vehicle26\">{$strings['moped']}</option>
<option value=\"27\" id=\"vehicle27\">{$strings['oxcart']}</option>
<option value=\"28\" id=\"vehicle28\">{$strings['lighttruck']}</option>
<option value=\"29\" id=\"vehicle29\">{$strings['suv']}</option>
<option value=\"30\" id=\"vehicle30\">{$strings['lorry']}</option></select>&nbsp;{$strings['autotransport10']}
</td></tr>
<tr><td>
<select id=\"transO5\" name=\"transO5\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"tO50\">Sleep</option>\n";
CreateOptionsWithID("tO5", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 91, 97, 104, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 151, 152, 153, 154, 155, 156, 157, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834);
echo "</select>&nbsp;{$strings['autotransportO5']}
</td></tr>
<tr><td>
<select id=\"transO6\" name=\"transO6\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"tO60\">Sleep</option>\n";
CreateOptionsWithID("tO6", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 91, 97, 104, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 151, 152, 153, 154, 155, 156, 157, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834);
echo "</select>&nbsp;{$strings['autotransportO6']}
</td></tr>
<tr><td>
<select id=\"transO7\" name=\"transO7\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"tO70\">Sleep</option>\n";
CreateOptionsWithID("tO7", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 91, 97, 104, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 151, 152, 153, 154, 155, 156, 157, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834);
echo "</select>&nbsp;{$strings['autotransportO7']}
</td></tr>
<tr><td>
<select id=\"transO8\" name=\"transO8\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"tO80\">Sleep</option>\n";
CreateOptionsWithID("tO8", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 91, 97, 104, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 151, 152, 153, 154, 155, 156, 157, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834, 950, 951, 952, 953, 954, 955, 956, 957, 970, 971, 972, 973, 974, 975, 976, 977, 978, 979, 980, 981, 982, 983, 984, 985);
echo "</select>&nbsp;{$strings['autotransportO8']}
</td></tr>
<tr><td>
<select id=\"transO9\" name=\"transO9\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"tO90\">Sleep</option>\n";
CreateOptionsWithID("tO9", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 91, 97, 104, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 151, 152, 153, 154, 155, 156, 157, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834);
echo "</select>&nbsp;{$strings['autotransportO9']}
</td></tr>
<tr><td>
<select id=\"transO10\" name=\"transO10\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"tO100\">Sleep</option>\n";
CreateOptionsWithID("tO10", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 91, 97, 104, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 151, 152, 153, 154, 155, 156, 157, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1114, 1115, 1116, 1117, 1118, 1119, 1120, 1121, 1122, 1123, 1124, 1125, 1126);
echo "</select>&nbsp;{$strings['autotransportO10']}
</td></tr>
<tr><td>
<select id=\"vetjobdifficulty\" name=\"vetjobdifficulty\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"vjdiff0\">Sleep</option>
<option value=\"1\" id=\"vjdiff1\">{$strings['vetjobeasy']}</option>
<option value=\"2\" id=\"vjdiff2\">{$strings['vetjobmedium']}</option>
<option value=\"3\" id=\"vjdiff3\">{$strings['vetjobhard']}</option></select>&nbsp;{$strings['restartvetjob']}
</td></tr>";
// sushi bar
echo "<tr><th>{$strings['sushibar']}</th></tr>
<tr><td>
<select id=\"sushibarsoup\" name=\"sushibarsoup\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"sushibarsoup0\">Sleep</option>\n";
CreateOptionsWithID("o", 974, 975, 976, 977);
echo "</select>&nbsp;{$strings['sushibarsoup']}
</td></tr>
<tr><td>
<select id=\"sushibarsalad\" name=\"sushibarsalad\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"sushibarsalad0\">Sleep</option>\n";
CreateOptionsWithID("o", 978, 979, 980, 981);
echo "</select>&nbsp;{$strings['sushibarsalad']}
</td></tr>
<tr><td>
<select id=\"sushibarsushi\" name=\"sushibarsushi\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"sushibarsushi0\">Sleep</option>\n";
CreateOptionsWithID("o", 970, 971, 972, 973);
echo "</select>&nbsp;{$strings['sushibarsushi']}
</td></tr>
<tr><td>
<select id=\"sushibardessert\" name=\"sushibardessert\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"sushibardessert0\">Sleep</option>\n";
CreateOptionsWithID("o", 982, 983, 984, 985);
echo "</select>&nbsp;{$strings['sushibardessert']}
</td></tr>";
// spice house oven
echo "<tr><th>{$strings['spicehouseoven']}</th></tr>
<tr><td>
<select id=\"ovenslot1\" name=\"ovenslot1\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"os0\">Sleep</option>\n";
CreateOptionsWithID("os", 113, 701, 703, 1100, 1101, 1102, 1103, 1104, 1105, 1106);
echo "</select>&nbsp;{$strings['slot']} 1
</td></tr>
<tr><td>
<select id=\"ovenslot2\" name=\"ovenslot2\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"2os0\">Sleep</option>\n";
CreateOptionsWithID("2os", 113, 701, 703, 1100, 1101, 1102, 1103, 1104, 1105, 1106);
echo "</select>&nbsp;{$strings['slot']} 2
</td></tr>
<tr><td>
<select id=\"ovenslot3\" name=\"ovenslot3\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"3os0\">Sleep</option>\n";
CreateOptionsWithID("3os", 113, 701, 703, 1100, 1101, 1102, 1103, 1104, 1105, 1106);
echo "</select>&nbsp;{$strings['slot']} 3
</td></tr>";
// fruit stall slots
echo "<tr><th>{$strings['fruitstallslots']} 1</th></tr>\n";
for ($i = 1; $i <= 4; $i++) {
 echo "<tr><td>
 <select id=\"fruitstallslot$i\" name=\"fruitstallslot$i\" onchange=\"saveMisc();\">
 <option value=\"0\" id=\"fs0\">Sleep</option>\n";
 // indizes, die bereits als "o"-wert existieren dürfen nicht mit verschiedenem index erneut erzeugt werden
 // daher bekommt der obststand ein eigenes präfix
 CreateOptionsWithID("fs", 1, 2, 3, 4, 5, 6, 7, 8, 17, 18, 19, 20, 21, 22, 23, 24, 26, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 108, 109, 112, 113, 114, 115, 126, 127, 128, 153, 154, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834);
 echo "</select>&nbsp;{$strings['slot']}&nbsp;$i
</td></tr>";
}
echo "<tr><th>{$strings['fruitstallslots']} 2</th></tr>\n";
for ($i = 1; $i <= 3; $i++) {
 echo "<tr><td>
 <select id=\"fruitstall2slot$i\" name=\"fruitstall2slot$i\" onchange=\"saveMisc();\">
 <option value=\"0\" id=\"2fs0\">Sleep</option>\n";
 CreateOptionsWithID("2fs", 1, 2, 3, 4, 5, 6, 7, 8, 17, 18, 19, 20, 21, 22, 23, 24, 26, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 108, 109, 112, 113, 114, 115, 126, 127, 128, 153, 154, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834);
 echo "</select>&nbsp;{$strings['slot']}&nbsp;$i
</td></tr>";
}
if ($farmdata["updateblock"]["farmersmarket"]["pos"][4]["name"]) {
 echo "<tr><th>{$farmdata["updateblock"]["farmersmarket"]["pos"][4]["name"]}</th></tr>
 <tr><td>
 <select id=\"carefood\" name=\"carefood\" onchange=\"saveMisc();\">\n";
 // dirty coding so getElementById() can find id "o0"
 echo "<option value=\"0\" id=\"o0\">Sleep</option>\n";
 // einzigartige indizes, bekommen das präfix "o"
 CreateOptionsWithID("o", 600, 601, 602, 603, 604, 605, 606, 607, 608, 609);
 echo "</select>&nbsp;{$strings['satisfyfoodneed']}
 </td></tr>
 <tr><td>
 <select id=\"caretoy\" name=\"caretoy\" onchange=\"saveMisc();\">
 <option value=\"0\" id=\"caretoy0\">Sleep</option>\n";
 CreateOptionsWithID("o", 630, 631, 632, 633, 634, 635, 636, 637, 638, 639);
 echo "</select>&nbsp;{$strings['satisfytoyneed']}
 </td></tr>
 <tr><td>
 <select id=\"careplushy\" name=\"careplushy\" onchange=\"saveMisc();\">
 <option value=\"0\" id=\"careplushy0\">Sleep</option>\n";
 CreateOptionsWithID("o", 660, 661, 662, 663, 664, 665, 666, 667, 668, 669);
 echo "</select>&nbsp;{$strings['satisfyplushyneed']}
 </td></tr>\n";
} else {
 echo "<tr><th>{$strings['notavailable']}</th></tr>\n";
}
if ($farmdata["updateblock"]["farmersmarket"]["pos"][9]["name"]) {
 echo "<tr><th>{$farmdata["updateblock"]["farmersmarket"]["pos"][9]["name"]}</th></tr>\n";
 if ($farmdata["updateblock"]["farmersmarket"]["fishing"]) {
  echo "<tr><td>
  <select id=\"speciesbait1\" name=\"speciesbait1\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"sb10\">Sleep</option>\n";
  CreateOptionsWithID("sb1", 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911, 922);
  echo "</select>&nbsp;{$strings['speciesbait']} {$strings['slot']} 1
  </td></tr>
  <tr><td>
  <select id=\"raritybait1\" name=\"raritybait1\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"rb10\">Sleep</option>\n";
  CreateOptionsWithID("rb1", 912, 913, 914, 915, 916, 917, 918, 919, 920, 921, 923);
  echo "</select>&nbsp;{$strings['raritybait']} {$strings['slot']} 1
  </td></tr>
  <tr><td>
  <select id=\"fishinggear1\" name=\"fishinggear1\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"fg10\">Sleep</option>\n";
  CreateFishingGearOptions("fg1", 1, 2, 3, 4, 5, 6);
  echo "</select>&nbsp;{$strings['fishinggear']} {$strings['slot']} 1
  </td></tr>
  <tr><td>
  <select id=\"speciesbait2\" name=\"speciesbait2\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"sb20\">Sleep</option>\n";
  CreateOptionsWithID("sb2", 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911, 922);
  echo "</select>&nbsp;{$strings['speciesbait']} {$strings['slot']} 2
  </td></tr>
  <tr><td>
  <select id=\"raritybait2\" name=\"raritybait2\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"rb20\">Sleep</option>\n";
  CreateOptionsWithID("rb2", 912, 913, 914, 915, 916, 917, 918, 919, 920, 921, 923);
  echo "</select>&nbsp;{$strings['raritybait']} {$strings['slot']} 2
  </td></tr>
  <tr><td>
  <select id=\"fishinggear2\" name=\"fishinggear2\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"fg20\">Sleep</option>\n";
  CreateFishingGearOptions("fg2", 1, 2, 3, 4, 5, 6);
  echo "</select>&nbsp;{$strings['fishinggear']} {$strings['slot']} 2
  </td></tr>
  <tr><td>
  <select id=\"speciesbait3\" name=\"speciesbait3\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"sb30\">Sleep</option>\n";
  CreateOptionsWithID("sb3", 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911, 922);
  echo "</select>&nbsp;{$strings['speciesbait']} {$strings['slot']} 3
  </td></tr>
  <tr><td>
  <select id=\"raritybait3\" name=\"raritybait3\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"rb30\">Sleep</option>\n";
  CreateOptionsWithID("rb3", 912, 913, 914, 915, 916, 917, 918, 919, 920, 921, 923);
  echo "</select>&nbsp;{$strings['raritybait']} {$strings['slot']} 3
  </td></tr>
  <tr><td>
  <select id=\"fishinggear3\" name=\"fishinggear3\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"fg30\">Sleep</option>\n";
  CreateFishingGearOptions("fg3", 1, 2, 3, 4, 5, 6);
  echo "</select>&nbsp;{$strings['fishinggear']} {$strings['slot']} 3
  </td></tr>
  <tr><td>
  <select id=\"preferredbait1\" name=\"preferredbait1\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"pb10\">Sleep</option>\n";
  CreateOptionsWithID("pb1", 901, 903, 904, 905, 906, 907, 908, 909, 910, 911, 913, 915, 916, 917, 918, 919, 920, 921, 922, 923, 2886);
  echo "</select>&nbsp;{$strings['preferredbait']} {$strings['slot']} 1
  </td></tr>
  <tr><td>
  <select id=\"preferredbait2\" name=\"preferredbait2\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"pb20\">Sleep</option>\n";
  CreateOptionsWithID("pb2", 901, 903, 904, 905, 906, 907, 908, 909, 910, 911, 913, 915, 916, 917, 918, 919, 920, 921, 922, 923, 2886);
  echo "</select>&nbsp;{$strings['preferredbait']} {$strings['slot']} 2
  </td></tr>
  <tr><td>
  <select id=\"preferredbait3\" name=\"preferredbait3\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"pb30\">Sleep</option>\n";
  CreateOptionsWithID("pb3", 901, 903, 904, 905, 906, 907, 908, 909, 910, 911, 913, 915, 916, 917, 918, 919, 920, 921, 922, 923, 2886);
  echo "</select>&nbsp;{$strings['preferredbait']} {$strings['slot']} 3
  </td></tr>\n";
 } else {
  echo "<tr><th>{$strings['notavailable']}</th></tr>";
 }
} else {
 echo "<tr><th>{$strings['notavailable']}</th></tr>";
}
if ($farmdata["updateblock"]["farmersmarket"]["pos"][10]["name"]) {
 echo "<tr><th>{$farmdata["updateblock"]["farmersmarket"]["pos"][10]["name"]}</th></tr>\n";
 if ($farmdata["updateblock"]["farmersmarket"]["vineyard"]) {
  echo "<tr><td>
  <select id=\"weathermitigation\" name=\"weathermitigation\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"wm0\">Sleep</option>
  <option value=\"1\" id=\"wm1\">50%</option>
  <option value=\"2\" id=\"wm2\">100%</option></select>&nbsp;{$strings['weathermitigation']}
  </td></tr>
  <tr><td>
  <select id=\"summercut\" name=\"summercut\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"sc0\">Sleep</option>
  <option value=\"middle\" id=\"scmiddle\">{$strings['middle']}</option>
  <option value=\"short\" id=\"scshort\">{$strings['short']}</option>
  <option value=\"long\" id=\"sclong\">{$strings['long']}</option></select>&nbsp;{$strings['summercut']}
  </td></tr>
  <tr><td>
  <select id=\"wintercut\" name=\"wintercut\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"wc0\">Sleep</option>
  <option value=\"middle\" id=\"wcmiddle\">{$strings['middle']}</option>
  <option value=\"short\" id=\"wcshort\">{$strings['short']}</option>
  <option value=\"long\" id=\"wclong\">{$strings['long']}</option></select>&nbsp;{$strings['wintercut']}
  </td></tr>
  <tr><td>
  <select id=\"vinedefoliation\" name=\"vinedefoliation\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"vd0\">Sleep</option>
  <option value=\"1\" id=\"vd1\">{$strings['leafstripping']}</option>
  <option value=\"2\" id=\"vd2\">{$strings['sproutremoval']}</option>
  <option value=\"3\" id=\"vd3\">{$strings['grapethinning']}</option></select>&nbsp;{$strings['applytoallvines']}
  </td></tr>
  <tr><td>
  <select id=\"vinefertiliser\" name=\"vinefertiliser\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"vf0\">Sleep</option>
  <option value=\"1\" id=\"vf1\">{$strings['standardfertiliser']}</option>
  <option value=\"2\" id=\"vf2\">{$strings['powerfertiliser']}</option>
  <option value=\"3\" id=\"vf3\">{$strings['specialfertiliser']}</option></select>&nbsp;{$strings['applytoallvines']}
  </td></tr>
  <tr><td>
  <select id=\"vinewater\" name=\"vinewater\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"vw0\">Sleep</option>
  <option value=\"1\" id=\"vw1\">{$strings['waterbucket']}</option>
  <option value=\"2\" id=\"vw2\">{$strings['wateringcan']}</option>
  <option value=\"3\" id=\"vw3\">{$strings['waterhose']}</option></select>&nbsp;{$strings['applytoallvines']}
  </td></tr>\n";
 } else {
  echo "<tr><th>{$strings['notavailable']}</th></tr>";
 }
} else {
 echo "<tr><th>{$strings['notavailable']}</th></tr>";
}
if ($farmdata["updateblock"]["farmersmarket"]["pos"][11]["name"]) {
 echo "<tr><th>{$farmdata["updateblock"]["farmersmarket"]["pos"][11]["name"]}</th></tr>\n";
 if ($farmdata["updateblock"]["farmersmarket"]["scouts"]) {
  echo "<tr><td>
  <select id=\"scoutfood\" name=\"scoutfood\" onchange=\"saveMisc();\">
  <option value=\"0\" id=\"o0\">Sleep</option>\n";
  CreateOptionsWithID("o", 1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007);
  echo "</select>&nbsp;{$strings['scouttaskfood']}
  </td></tr>\n";
 } else {
  echo "<tr><th>{$strings['notavailable']}</th></tr>";
 }
} else {
 echo "<tr><th>{$strings['notavailable']}</th></tr>";
}
// race cow slots
echo "</table>
</div>
<div id=\"racecowslotspane\" style=\"display:none;\">
<table id=\"racecowslotstbl\" style=\"float:left;\" border=\"1\">
<caption>{$strings['racecowslots']}</caption>\n";
for ($i = 1; $i <= 15; $i++) {
 echo "<tr><td>
 <select id=\"racecowslot$i\" name=\"racecowslot$i\" onchange=\"saveMisc();\">
 <option value=\"0\" id=\"racecowslot0\">Sleep</option>\n";
 CreateOptionsWithID("o", 800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819);
 echo "</select>&nbsp;{$strings['slot']}&nbsp;$i
 </td></tr>";
}
// auto-buy
echo "</table>
</div>
<div id=\"autobuypane\" style=\"display:none;\">
<table id=\"autobuytbl\" style=\"float:left;\" border=\"1\">
<caption>{$strings['stockmgmt']}</caption>
<tr><td colspan=\"8\">
<select id=\"autobuyrefillto\" name=\"autobuyrefillto\" onchange=\"saveMisc();\">
<option value=\"0\" id=\"autobuyrefillto0\">Sleep</option>
<option value=\"1000\" id=\"autobuyrefillto1000\">1000</option>
<option value=\"2000\" id=\"autobuyrefillto2000\">2000</option>
<option value=\"3000\" id=\"autobuyrefillto3000\">3000</option>
<option value=\"4000\" id=\"autobuyrefillto4000\">4000</option>
<option value=\"5000\" id=\"autobuyrefillto5000\">5000</option>
<option value=\"10000\" id=\"autobuyrefillto10000\">10000</option>
<option value=\"20000\" id=\"autobuyrefillto20000\">20000</option>
</select>&nbsp;{$strings['buyatmerchant']}
</td></tr>";
$buyableGoods = [ 1, 2, 3, 4, 5, 6, 7, 8, 17, 18, 19, 20, 21, 22, 23, 24, 26, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 108, 109, 112, 113, 114, 115, 126, 127, 128, 153, 154, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834 ];
for ($i = 0; $i < count($buyableGoods); $i++) {
 echo "<tr>";
 for ($j = 0; $j <= 7; $j++) {
  if (isset($buyableGoods[$i])) {
   echo "<td>
   <input type=\"checkbox\" id=\"autobuyitem$buyableGoods[$i]\" name=\"autobuyitem$buyableGoods[$i]\" onchange=\"saveMisc();\" value=\"$buyableGoods[$i]\">&nbsp;{$productlist[$buyableGoods[$i]]}
   </td>";
   $i++;
  }
 }
 $i--;
 echo "</tr>";
}
// flower arrangement slots
echo "</table>
</div>
<div id=\"flowerarrangementspane\" style=\"display:none;\">
<table id=\"flowerarrangementslotstbl\" style=\"float:left;\" border=\"1\">
<caption>{$strings['flowerarrangements']}</caption>\n";
for ($i = 1; $i <= 17; $i++) {
 echo "<tr><td>
 <select id=\"flowerarrangementslot$i\" name=\"flowerarrangementslot$i\" onchange=\"saveMisc();\">
 <option value=\"0\" id=\"flowerarrangementslot0\">Sleep</option>\n";
 CreateOptionsWithID("o", 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221);
 echo "</select>&nbsp;{$strings['slot']}&nbsp;$i
 </td></tr>";
}
// butterflies
echo "</table>
</div>
<div id=\"butterflybuypane\" style=\"display:none;\">
<table id=\"autobuytbl\" style=\"float:left;\" border=\"1\">
<caption>{$strings['butterflies']}</caption>\n";
if ($farmdata["updateblock"]["farmersmarket"]["butterfly"]) {
 $numButterflies = 35;
 for ($i = 1; $i <= $numButterflies; $i++) {
  echo "<tr>";
  for ($j = 0; $j <= 4; $j++) {
   if (isset($farmdata["updateblock"]["farmersmarket"]["butterfly"]["config"]["butterflies"]["$i"]["name"])) {
    echo "<td>
    <input type=\"checkbox\" id=\"btfly$i\" name=\"btfly$i\" onchange=\"saveMisc();\" value=\"$i\">&nbsp;{$farmdata["updateblock"]["farmersmarket"]["butterfly"]["config"]["butterflies"]["$i"]["name"]}
    </td>";
    $i++;
   }
  }
  $i--;
  echo "</tr>";
 }
} else {
 echo "<th>{$strings['notavailable']}</th>";
}
echo "</table>
</div>
</form>\n";

// set saved options
echo "<script type=\"text/javascript\">\n";

global $configContents;
$expectedKeys = [ 'carefood', 'caretoy', 'careplushy', 'dodog', 'dologinbonus',
'dolot', 'vehiclemgmt5', 'vehiclemgmt6', 'vehiclemgmt7', 'vehiclemgmt8', 'vehiclemgmt9',
'vehiclemgmt10', 'dopuzzleparts', 'sendfarmiesaway', 'sendforestryfarmiesaway',
'sendmunchiesaway', 'sendflowerfarmiesaway', 'transO5', 'transO6', 'transO7',
'transO8', 'transO9', 'transO10', 'correctqueuenum', 'useponyenergybar', 'redeempuzzlepacks',
'dobutterflies', 'dodeliveryevent', 'doolympiaevent', 'dopentecostevent',
'doseedbox', 'docowracepvp', 'trimlogstock', 'dodonkey', 'docowrace',
'excluderank1cow', 'dofoodcontest', 'restartvetjob', 'docalendarevent',
'doinfinitequest', 'racecowslot1', 'racecowslot2', 'racecowslot3',
'racecowslot4', 'racecowslot5', 'racecowslot6', 'racecowslot7', 'racecowslot8',
'racecowslot9', 'racecowslot10', 'racecowslot11', 'racecowslot12',
'racecowslot13', 'racecowslot14', 'racecowslot15', 'fruitstallslot1',
'fruitstallslot2', 'fruitstallslot3', 'fruitstallslot4', 'fruitstall2slot1',
'fruitstall2slot2', 'fruitstall2slot3', 'autobuyitems',
'autobuyrefillto', 'flowerarrangementslot1', 'flowerarrangementslot2',
'flowerarrangementslot3', 'flowerarrangementslot4', 'flowerarrangementslot5',
'flowerarrangementslot6', 'flowerarrangementslot7', 'flowerarrangementslot8',
'flowerarrangementslot9', 'flowerarrangementslot10', 'flowerarrangementslot11',
'flowerarrangementslot12', 'flowerarrangementslot13', 'flowerarrangementslot14',
'flowerarrangementslot15', 'flowerarrangementslot16', 'flowerarrangementslot17',
'autobuybutterflies', 'speciesbait1', 'speciesbait2', 'speciesbait3',
'raritybait1', 'raritybait2', 'raritybait3', 'fishinggear1', 'fishinggear2',
'fishinggear3', 'preferredbait1', 'preferredbait2', 'preferredbait3', 'removeweed',
'harvestvine', 'harvestvineinautumn', 'restartvine', 'removevine', 'weathermitigation',
'summercut', 'wintercut', 'vinedefoliation', 'vinefertiliser', 'vinewater',
'buyvinetillsunny', 'vinefullservice', 'sushibarsoup', 'sushibarsalad',
'sushibarsushi', 'sushibardessert', 'scoutfood', 'doinsecthotel', 'doeventgarden',
'dogreenhouse', 'ovenslot1', 'ovenslot2', 'ovenslot3'];
// make sure missing options don't mess up the options' display
for ($i = 0; $i < count($expectedKeys); $i++)
 if (!isset($configContents[$expectedKeys[$i]]))
  $configContents[$expectedKeys[$i]] = '0';

$savedValue = $configContents['carefood'];
echo "if (document.getElementById('carefood') !== null)
 document.getElementById('carefood').selectedIndex = document.getElementById('o$savedValue').index;\n";
$savedValue = $configContents['caretoy'];
echo "if (document.getElementById('caretoy') !== null)
 document.getElementById('caretoy').selectedIndex = document.getElementById('o$savedValue').index;\n";
$savedValue = $configContents['careplushy'];
echo "if (document.getElementById('careplushy') !== null)
 document.getElementById('careplushy').selectedIndex = document.getElementById('o$savedValue').index;\n";
$savedValue = $configContents['dologinbonus'];
echo "document.getElementById('loginbonus').selectedIndex = document.getElementById('o$savedValue').index;\n";
$savedValue = $configContents['vehiclemgmt5'];
$savedValue = "vehicle" . $savedValue;
echo "document.getElementById('vehiclemgmt5').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['vehiclemgmt6'];
$savedValue = "vehicle" . $savedValue;
echo "document.getElementById('vehiclemgmt6').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['vehiclemgmt7'];
$savedValue = "vehicle" . $savedValue;
echo "document.getElementById('vehiclemgmt7').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['vehiclemgmt8'];
$savedValue = "vehicle" . $savedValue;
echo "document.getElementById('vehiclemgmt8').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['vehiclemgmt9'];
$savedValue = "vehicle" . $savedValue;
echo "document.getElementById('vehiclemgmt9').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['vehiclemgmt10'];
$savedValue = "vehicle" . $savedValue;
echo "document.getElementById('vehiclemgmt10').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['transO5'];
$savedValue = "tO5" . $savedValue;
echo "document.getElementById('transO5').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['transO6'];
$savedValue = "tO6" . $savedValue;
echo "document.getElementById('transO6').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['transO7'];
$savedValue = "tO7" . $savedValue;
echo "document.getElementById('transO7').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['transO8'];
$savedValue = "tO8" . $savedValue;
echo "document.getElementById('transO8').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['transO9'];
$savedValue = "tO9" . $savedValue;
echo "document.getElementById('transO9').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['transO10'];
$savedValue = "tO10" . $savedValue;
echo "document.getElementById('transO10').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['restartvetjob'];
$savedValue = "vjdiff" . $savedValue;
echo "document.getElementById('vetjobdifficulty').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['dolot'];
$savedValue = "lot" . $savedValue;
echo "document.getElementById('lottoggle').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['autobuyrefillto'];
$savedValue = "autobuyrefillto" . $savedValue;
echo "document.getElementById('autobuyrefillto').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['weathermitigation'];
$savedValue = "wm" . $savedValue;
echo "if (document.getElementById('weathermitigation') !== null)
 document.getElementById('weathermitigation').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['summercut'];
$savedValue = "sc" . $savedValue;
echo "if (document.getElementById('summercut') !== null)
 document.getElementById('summercut').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['wintercut'];
$savedValue = "wc" . $savedValue;
echo "if (document.getElementById('wintercut') !== null)
 document.getElementById('wintercut').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['vinedefoliation'];
$savedValue = "vd" . $savedValue;
echo "if (document.getElementById('vinedefoliation') !== null)
 document.getElementById('vinedefoliation').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['vinefertiliser'];
$savedValue = "vf" . $savedValue;
echo "if (document.getElementById('vinefertiliser') !== null)
 document.getElementById('vinefertiliser').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['vinewater'];
$savedValue = "vw" . $savedValue;
echo "if (document.getElementById('vinewater') !== null)
 document.getElementById('vinewater').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['sushibarsoup'];
echo " document.getElementById('sushibarsoup').selectedIndex = document.getElementById('o$savedValue').index;\n";
$savedValue = $configContents['sushibarsalad'];
echo " document.getElementById('sushibarsalad').selectedIndex = document.getElementById('o$savedValue').index;\n";
$savedValue = $configContents['sushibarsushi'];
echo " document.getElementById('sushibarsushi').selectedIndex = document.getElementById('o$savedValue').index;\n";
$savedValue = $configContents['sushibardessert'];
echo " document.getElementById('sushibardessert').selectedIndex = document.getElementById('o$savedValue').index;\n";
$savedValue = $configContents['ovenslot1'];
echo " document.getElementById('ovenslot1').selectedIndex = document.getElementById('os$savedValue').index;\n";
$savedValue = $configContents['ovenslot2'];
echo " document.getElementById('ovenslot2').selectedIndex = document.getElementById('2os$savedValue').index;\n";
$savedValue = $configContents['ovenslot3'];
echo " document.getElementById('ovenslot3').selectedIndex = document.getElementById('3os$savedValue').index;\n";
$savedValue = $configContents['scoutfood'];
echo "if (document.getElementById('scoutfood') !== null)
 document.getElementById('scoutfood').selectedIndex = document.getElementById('o$savedValue').index;\n";

reset($togglesarray);
for ($i = 0; $i < count($togglesarray); $i++) {
 $savedkey=key($togglesarray);
 $toggle=$togglesarray[$savedkey];
 $savedValue = $configContents[$savedkey];
 if ($savedValue == '1')
  echo "document.getElementById('$toggle').checked = true;\n";
 next($togglesarray);
}

for ($i = 1; $i <= 15; $i++) {
$savedValue = $configContents['racecowslot' . $i];
echo "document.getElementById('racecowslot$i').selectedIndex = document.getElementById('o$savedValue').index;\n";
}

for ($i = 1; $i <= 4; $i++) {
$savedValue = $configContents['fruitstallslot' . $i];
echo "document.getElementById('fruitstallslot$i').selectedIndex = document.getElementById('fs$savedValue').index;\n";
if ($i == 4)
 break;
$savedValue = $configContents['fruitstall2slot' . $i];
echo "document.getElementById('fruitstall2slot$i').selectedIndex = document.getElementById('2fs$savedValue').index;\n";
}

for ($i = 1; $i <= 17; $i++) {
$savedValue = $configContents['flowerarrangementslot' . $i];
echo "document.getElementById('flowerarrangementslot$i').selectedIndex = document.getElementById('o$savedValue').index;\n";
}

for ($i = 1; $i <= 3; $i++) {
 $savedValue = $configContents['speciesbait' . $i];
 echo "if (document.getElementById('speciesbait$i') !== null)
  document.getElementById('speciesbait$i').selectedIndex = document.getElementById('sb$i$savedValue').index;\n";
 $savedValue = $configContents['raritybait' . $i];
 echo "if (document.getElementById('raritybait$i') !== null)
  document.getElementById('raritybait$i').selectedIndex = document.getElementById('rb$i$savedValue').index;\n";
 $savedValue = $configContents['fishinggear' . $i];
 echo "if (document.getElementById('fishinggear$i') !== null)
  document.getElementById('fishinggear$i').selectedIndex = document.getElementById('fg$i$savedValue').index;\n";
 $savedValue = $configContents['preferredbait' . $i];
 echo "if (document.getElementById('preferredbait$i') !== null)
  document.getElementById('preferredbait$i').selectedIndex = document.getElementById('pb$i$savedValue').index;\n";
}

$savedValue = explode(" ", $configContents['autobuyitems']);
if ($savedValue[0] != '0')
 for ($i = 0; $i < count($savedValue); $i++)
  echo "document.getElementById('autobuyitem$savedValue[$i]').checked = true;\n";

$savedValue = explode(" ", $configContents['autobuybutterflies']);
if ($savedValue[0] != '0')
 for ($i = 0; $i < count($savedValue); $i++)
  echo "document.getElementById('btfly$savedValue[$i]').checked = true;\n";
echo "</script>\n";
?>
