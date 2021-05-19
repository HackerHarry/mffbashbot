<?php
// Buttons file for My Free Farm Bash Bot (front end)
// Copyright 2016-21 Harun "Harry" Basalamah
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
"removeweed" => "removeweedtoggle"
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
$strings['removeweed']
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
$strings['removeweed-tt']
];

print "<h1>{$strings['youareat']} {$farmFriendlyName["$farm"]}</h1>";
print "<form name=\"venueselect\" method=\"post\" action=\"showfarm.php\" style=\"margin-bottom:5px;\">\n";
print "<input type=\"hidden\" name=\"farm\" value=\"$farm\">\n";
print "<input type=\"hidden\" name=\"username\" value=\"$username\">\n";
for ($i = 1; $i <= 7; $i++)
 print "<input type=\"image\" src=\"image/navi_farm$i.png\" class=\"navilink\" title=\"$farmFriendlyName[$i]\" name=\"$i\" onclick=\"document.venueselect.farm.value = '$i'; this.form.submit();\">\n";
print "<input type=\"image\" src=\"image/farmersmarket.png\" class=\"navilink\" title=\"{$farmFriendlyName['farmersmarket']}\" name=\"farmersmarket\" onclick=\"document.venueselect.farm.value='farmersmarket'; document.venueselect.action='showvenue.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/farmersmarket2.png\" class=\"navilink\" title=\"{$farmFriendlyName['farmersmarket2']}\" name=\"farmersmarket2\" onclick=\"document.venueselect.farm.value='farmersmarket2'; document.venueselect.action='showvenue.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/forestry.png\" class=\"navilink\" title=\"{$farmFriendlyName['forestry']}\" name=\"forestry\" onclick=\"document.venueselect.farm.value='forestry'; this.form.action='showvenue.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/foodworld.png\" class=\"navilink\" title=\"{$farmFriendlyName['foodworld']}\" name=\"foodworld\" onclick=\"document.venueselect.farm.value='foodworld'; this.form.action='showvenue.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/navi_city2.png\" class=\"navilink\" title=\"{$farmFriendlyName['city2']}\" name=\"city2\" onclick=\"document.venueselect.farm.value='city2'; this.form.action='showvenue.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/runbot.png\" class=\"navilink\" name=\"runbot\" title=\"{$strings['forcebotstart']}\" onclick=\"document.venueselect.farm.value='runbot'; this.form.submit()\">&nbsp;\n";
print "<input type=\"button\" name=\"logon\" class=\"btn btn-warning btn-sm logonbtn\" value=\"{$strings['logon']}\" onclick=\"this.form.action='index.php'; this.form.submit()\">\n";
print "<br><br>\n";

print "<button class=\"btn btn-outline-dark btn-sm\" id=\"optbtn\" onclick=\"showHideOptions('optionspane'); return false;\">{$strings['options']}...</button>\n";
print "<button class=\"btn btn-outline-dark btn-sm\" id=\"opt2btn\" onclick=\"showHideOptions('options2pane'); return false;\">{$strings['moreoptions']}...</button>\n";
print "<button class=\"btn btn-outline-dark btn-sm\" id=\"flowerarrangementsbtn\" onclick=\"showHideOptions('flowerarrangementspane'); return false;\">{$strings['flowerarrangements']}...</button>\n";
print "<button class=\"btn btn-outline-dark btn-sm\" id=\"cowslotsbtn\" onclick=\"showHideOptions('racecowslotspane'); return false;\">{$strings['racecowslots']}...</button>\n";
print "<button class=\"btn btn-outline-dark btn-sm\" id=\"autobuybtn\" onclick=\"showHideOptions('autobuypane'); return false;\">{$strings['stockmgmt']}...</button>\n";
print "<button class=\"btn btn-outline-dark btn-sm\" id=\"butterflybtn\" onclick=\"showHideOptions('butterflybuypane'); return false;\">{$strings['butterflies']}...</button>\n";
print "<hr>\n";
// toggles
print "<div id=\"optionspane\" style=\"display:none;\">";
print "<table id=\"opttbl\" style=\"float:left;\" border=\"1\">";
print "<caption>{$strings['options']}</caption>\n";
for ($i = 0; $i < count($togglesarray); $i++) {
 $savedkey=key($togglesarray);
 $toggle=$togglesarray[$savedkey];
 print "<tr><td><span title='$toggledesc_tt[$i]'>\n";
 print "<label class=\"switch\">\n";
 print "<input type=\"checkbox\" id=\"$toggle\" name=\"$toggle\" onchange=\"saveMisc();\" value=\"1\">\n";
 print "<span class=\"slider round\"></span></label>$toggledesc[$i]\n";
 print "</span></td></tr>\n";
 next($togglesarray);
}
print "</td></tr></table>\n";
print "</div>\n";
// more options
print "<div id=\"options2pane\" style=\"display:none;\">";
print "<table id=\"opttbl2\" style=\"float:left;\" border=\"1\">";
print "<caption>{$strings['moreoptions']}</caption>\n";
print "<tr><td>";
print "<select id=\"lottoggle\" name=\"lottoggle\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"lot0\">Sleep</option>\n";
print "<option value=\"1\" id=\"lot1\">{$strings['lot']}</option>\n";
print "<option value=\"2\" id=\"lot2\">{$strings['instantwin']}</option></select>&nbsp;{$strings['collectdaily']}\n";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"loginbonus\" name=\"loginbonus\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"o0\">Sleep</option>\n";
CreateOptionsWithIDfromArray($farmdata["updateblock"]["menue"]["loginbonus"]["products"]);
print "</select>&nbsp;{$strings['collectloginbonus']}\n";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"vehiclemgmt5\" name=\"vehiclemgmt5\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"vehicle0\">Sleep</option>\n";
print "<option value=\"1\" id=\"vehicle1\">{$strings['sheepcart']}</option>\n";
print "<option value=\"2\" id=\"vehicle2\">{$strings['tractor']}</option>\n";
print "<option value=\"3\" id=\"vehicle3\">{$strings['lorry']}</option>\n";
print "<option value=\"4\" id=\"vehicle4\">{$strings['sportscar']}</option>\n";
print "<option value=\"5\" id=\"vehicle5\">{$strings['truck']}</option></select>&nbsp;{$strings['autotransport5']}";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"vehiclemgmt6\" name=\"vehiclemgmt6\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"vehicle0\">Sleep</option>\n";
print "<option value=\"6\" id=\"vehicle6\">{$strings['dogsled']}</option>\n";
print "<option value=\"7\" id=\"vehicle7\">{$strings['atv']}</option>\n";
print "<option value=\"8\" id=\"vehicle8\">{$strings['snowgroomer']}</option>\n";
print "<option value=\"9\" id=\"vehicle9\">{$strings['helicopter']}</option>\n";
print "<option value=\"10\" id=\"vehicle10\">{$strings['hotairballoon']}</option></select>&nbsp;{$strings['autotransport6']}";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"vehiclemgmt7\" name=\"vehiclemgmt7\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"vehicle0\">Sleep</option>\n";
print "<option value=\"11\" id=\"vehicle11\">{$strings['coach']}</option>\n";
print "<option value=\"12\" id=\"vehicle12\">{$strings['tuktuk']}</option>\n";
print "<option value=\"13\" id=\"vehicle13\">{$strings['sprinter']}</option>\n";
print "<option value=\"14\" id=\"vehicle14\">{$strings['drone']}</option>\n";
print "<option value=\"15\" id=\"vehicle15\">{$strings['airplane']}</option></select>&nbsp;{$strings['autotransport7']}";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"transO7\" name=\"transO7\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"tO70\">Sleep</option>\n";
CreateOptionsWithID("tO7", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 91, 97, 104, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 151, 152, 153, 154, 155, 156, 157, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834);
print "</select>&nbsp;{$strings['autotransportO7']}";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"vetjobdifficulty\" name=\"vetjobdifficulty\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"vjdiff0\">Sleep</option>\n";
print "<option value=\"1\" id=\"vjdiff1\">{$strings['vetjobeasy']}</option>\n";
print "<option value=\"2\" id=\"vjdiff2\">{$strings['vetjobmedium']}</option>\n";
print "<option value=\"3\" id=\"vjdiff3\">{$strings['vetjobhard']}</option></select>&nbsp;{$strings['restartvetjob']}\n";
print "</td></tr>";
// fruit stall slots
print "<tr><th>{$strings['fruitstallslots']} 1</th></tr>\n";
for ($i = 1; $i <= 4; $i++) {
 print "<tr><td>";
 print "<select id=\"fruitstallslot$i\" name=\"fruitstallslot$i\" onchange=\"saveMisc();\">";
 print "<option value=\"0\" id=\"fs0\">Sleep</option>\n";
 // indizes, die bereits als "o"-wert existieren dürfen nicht mit verschiedenem index erneut erzeugt werden
 // daher bekommt der obststand ein eigenes präfix
 CreateOptionsWithID("fs", 1, 2, 3, 4, 5, 6, 7, 8, 17, 18, 19, 20, 21, 22, 23, 24, 26, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 108, 109, 112, 113, 114, 115, 126, 127, 128, 153, 154, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834);
 print "</select>&nbsp;{$strings['slot']}&nbsp;$i";
 print "</td></tr>";
}
print "<tr><th>{$strings['fruitstallslots']} 2</th></tr>\n";
for ($i = 1; $i <= 3; $i++) {
 print "<tr><td>";
 print "<select id=\"fruitstall2slot$i\" name=\"fruitstall2slot$i\" onchange=\"saveMisc();\">";
 print "<option value=\"0\" id=\"2fs0\">Sleep</option>\n";
 CreateOptionsWithID("2fs", 1, 2, 3, 4, 5, 6, 7, 8, 17, 18, 19, 20, 21, 22, 23, 24, 26, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 108, 109, 112, 113, 114, 115, 126, 127, 128, 153, 154, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834);
 print "</select>&nbsp;{$strings['slot']}&nbsp;$i";
 print "</td></tr>";
}
if ($farmdata["updateblock"]["farmersmarket"]["pos"][4]["name"]) {
 print "<tr><th>{$farmdata["updateblock"]["farmersmarket"]["pos"][4]["name"]}</th></tr>\n";
 print "<tr><td>";
 print "<select id=\"carefood\" name=\"carefood\" onchange=\"saveMisc();\">";
 // dirty coding so getElementById() can find id "o0"
 print "<option value=\"0\" id=\"o0\">Sleep</option>\n";
 // einzigartige indizes, bekommen das präfix "o"
 CreateOptionsWithID("o", 600, 601, 602, 603, 604, 605, 606, 607, 608, 609);
 print "</select>&nbsp;{$strings['satisfyfoodneed']}";
 print "</td></tr>";
 print "<tr><td>";
 print "<select id=\"caretoy\" name=\"caretoy\" onchange=\"saveMisc();\">";
 print "<option value=\"0\" id=\"caretoy0\">Sleep</option>\n";
 CreateOptionsWithID("o", 630, 631, 632, 633, 634, 635, 636, 637, 638, 639);
 print "</select>&nbsp;{$strings['satisfytoyneed']}";
 print "</td></tr>";
 print "<tr><td>";
 print "<select id=\"careplushy\" name=\"careplushy\" onchange=\"saveMisc();\">";
 print "<option value=\"0\" id=\"careplushy0\">Sleep</option>\n";
 CreateOptionsWithID("o", 660, 661, 662, 663, 664, 665, 666, 667, 668, 669);
 print "</select>&nbsp;{$strings['satisfyplushyneed']}";
 print "</td></tr>\n";
} else {
 print "<tr><th>{$strings['notavailable']}</th></tr>\n";
}
if ($farmdata["updateblock"]["farmersmarket"]["pos"][9]["name"]) {
 print "<tr><th>{$farmdata["updateblock"]["farmersmarket"]["pos"][9]["name"]}</th></tr>\n";
 if ($farmdata["updateblock"]["farmersmarket"]["fishing"]) {
  print "<tr><td>";
  print "<select id=\"speciesbait1\" name=\"speciesbait1\" onchange=\"saveMisc();\">";
  print "<option value=\"0\" id=\"sb10\">Sleep</option>\n";
  CreateOptionsWithID("sb1", 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911);
  print "</select>&nbsp;{$strings['speciesbait']} {$strings['slot']} 1";
  print "</td></tr>\n";
  print "<tr><td>";
  print "<select id=\"raritybait1\" name=\"raritybait1\" onchange=\"saveMisc();\">";
  print "<option value=\"0\" id=\"rb10\">Sleep</option>\n";
  CreateOptionsWithID("rb1", 912, 913, 914, 915, 916, 917, 918, 919, 920, 921);
  print "</select>&nbsp;{$strings['raritybait']} {$strings['slot']} 1";
  print "</td></tr>\n";
  print "<tr><td>";
  print "<select id=\"fishinggear1\" name=\"fishinggear1\" onchange=\"saveMisc();\">";
  print "<option value=\"0\" id=\"fg10\">Sleep</option>\n";
  CreateFishingGearOptions("fg1", 1, 2, 3, 4, 5, 6);
  print "</select>&nbsp;{$strings['fishinggear']} {$strings['slot']} 1";
  print "</td></tr>\n";
  print "<tr><td>";
  print "<select id=\"speciesbait2\" name=\"speciesbait2\" onchange=\"saveMisc();\">";
  print "<option value=\"0\" id=\"sb20\">Sleep</option>\n";
  CreateOptionsWithID("sb2", 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911);
  print "</select>&nbsp;{$strings['speciesbait']} {$strings['slot']} 2";
  print "</td></tr>\n";
  print "<tr><td>";
  print "<select id=\"raritybait2\" name=\"raritybait2\" onchange=\"saveMisc();\">";
  print "<option value=\"0\" id=\"rb20\">Sleep</option>\n";
  CreateOptionsWithID("rb2", 912, 913, 914, 915, 916, 917, 918, 919, 920, 921);
  print "</select>&nbsp;{$strings['raritybait']} {$strings['slot']} 2";
  print "</td></tr>\n";
  print "<tr><td>";
  print "<select id=\"fishinggear2\" name=\"fishinggear2\" onchange=\"saveMisc();\">";
  print "<option value=\"0\" id=\"fg20\">Sleep</option>\n";
  CreateFishingGearOptions("fg2", 1, 2, 3, 4, 5, 6);
  print "</select>&nbsp;{$strings['fishinggear']} {$strings['slot']} 2";
  print "</td></tr>\n";
  print "<tr><td>";
  print "<select id=\"speciesbait3\" name=\"speciesbait3\" onchange=\"saveMisc();\">";
  print "<option value=\"0\" id=\"sb30\">Sleep</option>\n";
  CreateOptionsWithID("sb3", 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911);
  print "</select>&nbsp;{$strings['speciesbait']} {$strings['slot']} 3";
  print "</td></tr>\n";
  print "<tr><td>";
  print "<select id=\"raritybait3\" name=\"raritybait3\" onchange=\"saveMisc();\">";
  print "<option value=\"0\" id=\"rb30\">Sleep</option>\n";
  CreateOptionsWithID("rb3", 912, 913, 914, 915, 916, 917, 918, 919, 920, 921);
  print "</select>&nbsp;{$strings['raritybait']} {$strings['slot']} 3";
  print "</td></tr>\n";
  print "<tr><td>";
  print "<select id=\"fishinggear3\" name=\"fishinggear3\" onchange=\"saveMisc();\">";
  print "<option value=\"0\" id=\"fg30\">Sleep</option>\n";
  CreateFishingGearOptions("fg3", 1, 2, 3, 4, 5, 6);
  print "</select>&nbsp;{$strings['fishinggear']} {$strings['slot']} 3";
  print "</td></tr>\n";
  print "<tr><td>";
  print "<select id=\"preferredbait1\" name=\"preferredbait1\" onchange=\"saveMisc();\">";
  print "<option value=\"0\" id=\"pb10\">Sleep</option>\n";
  CreateOptionsWithID("pb1", 901, 903, 904, 905, 906, 907, 908, 909, 910, 911, 913, 915, 916, 917, 918, 919, 920, 921);
  print "</select>&nbsp;{$strings['preferredbait']} {$strings['slot']} 1";
  print "</td></tr>\n";
  print "<tr><td>";
  print "<select id=\"preferredbait2\" name=\"preferredbait2\" onchange=\"saveMisc();\">";
  print "<option value=\"0\" id=\"pb20\">Sleep</option>\n";
  CreateOptionsWithID("pb2", 901, 903, 904, 905, 906, 907, 908, 909, 910, 911, 913, 915, 916, 917, 918, 919, 920, 921);
  print "</select>&nbsp;{$strings['preferredbait']} {$strings['slot']} 2";
  print "</td></tr>\n";
  print "<tr><td>";
  print "<select id=\"preferredbait3\" name=\"preferredbait3\" onchange=\"saveMisc();\">";
  print "<option value=\"0\" id=\"pb30\">Sleep</option>\n";
  CreateOptionsWithID("pb3", 901, 903, 904, 905, 906, 907, 908, 909, 910, 911, 913, 915, 916, 917, 918, 919, 920, 921);
  print "</select>&nbsp;{$strings['preferredbait']} {$strings['slot']} 3";
  print "</td></tr>\n";
 } else {
  print "<tr><th>{$strings['notavailable']}</th></tr>";
 }
} else {
 print "<tr><th>{$strings['notavailable']}</th></tr>";
}
print "</table>\n";
print "</div>\n";
// race cow slots
print "<div id=\"racecowslotspane\" style=\"display:none;\">";
print "<table id=\"racecowslotstbl\" style=\"float:left;\" border=\"1\">";
print "<caption>{$strings['racecowslots']}</caption>\n";
for ($i = 1; $i <= 15; $i++) {
 print "<tr><td>";
 print "<select id=\"racecowslot$i\" name=\"racecowslot$i\" onchange=\"saveMisc();\">";
 print "<option value=\"0\" id=\"racecowslot0\">Sleep</option>\n";
 CreateOptionsWithID("o", 800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819);
 print "</select>&nbsp;{$strings['slot']}&nbsp;$i";
 print "</td></tr>";
}
print "</table>\n";
print "</div>\n";
// auto-buy
print "<div id=\"autobuypane\" style=\"display:none;\">";
print "<table id=\"autobuytbl\" style=\"float:left;\" border=\"1\">";
print "<caption>{$strings['stockmgmt']}</caption>\n";
print "<tr><td colspan=\"8\">";
print "<select id=\"autobuyrefillto\" name=\"autobuyrefillto\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"autobuyrefillto0\">Sleep</option>\n";
print "<option value=\"1000\" id=\"autobuyrefillto1000\">1000</option>\n";
print "<option value=\"2000\" id=\"autobuyrefillto2000\">2000</option>\n";
print "<option value=\"3000\" id=\"autobuyrefillto3000\">3000</option>\n";
print "<option value=\"4000\" id=\"autobuyrefillto4000\">4000</option>\n";
print "<option value=\"5000\" id=\"autobuyrefillto5000\">5000</option>\n";
print "<option value=\"10000\" id=\"autobuyrefillto10000\">10000</option>\n";
print "<option value=\"20000\" id=\"autobuyrefillto20000\">20000</option>\n";
print "</select>&nbsp;{$strings['buyatmerchant']}";
print "</td></tr>";
$buyableGoods = [ 1, 2, 3, 4, 5, 6, 7, 8, 17, 18, 19, 20, 21, 22, 23, 24, 26, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 108, 109, 112, 113, 114, 115, 126, 127, 128, 153, 154, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834 ];
for ($i = 0; $i < count($buyableGoods); $i++) {
 print "<tr>";
 for ($j = 0; $j <= 7; $j++) {
  if (isset($buyableGoods[$i])) {
   print "<td>";
   print "<input type=\"checkbox\" id=\"autobuyitem$buyableGoods[$i]\" name=\"autobuyitem$buyableGoods[$i]\" onchange=\"saveMisc();\" value=\"$buyableGoods[$i]\">&nbsp;{$productlist[$buyableGoods[$i]]}\n";
   print "</td>";
   $i++;
  }
 }
 $i--;
 print "</tr>";
}
print "</table>\n";
print "</div>\n";
// flower arrangement slots
print "<div id=\"flowerarrangementspane\" style=\"display:none;\">";
print "<table id=\"flowerarrangementslotstbl\" style=\"float:left;\" border=\"1\">";
print "<caption>{$strings['flowerarrangements']}</caption>\n";
for ($i = 1; $i <= 17; $i++) {
 print "<tr><td>";
 print "<select id=\"flowerarrangementslot$i\" name=\"flowerarrangementslot$i\" onchange=\"saveMisc();\">";
 print "<option value=\"0\" id=\"flowerarrangementslot0\">Sleep</option>\n";
 CreateOptionsWithID("o", 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221);
 print "</select>&nbsp;{$strings['slot']}&nbsp;$i";
 print "</td></tr>";
}
print "</table>\n";
print "</div>\n";
// butterflies
print "<div id=\"butterflybuypane\" style=\"display:none;\">";
print "<table id=\"autobuytbl\" style=\"float:left;\" border=\"1\">";
print "<caption>{$strings['butterflies']}</caption>\n";
if ($farmdata["updateblock"]["farmersmarket"]["butterfly"]) {
 $numButterflies = 35;
 for ($i = 1; $i <= $numButterflies; $i++) {
  print "<tr>";
  for ($j = 0; $j <= 4; $j++) {
   if (isset($farmdata["updateblock"]["farmersmarket"]["butterfly"]["config"]["butterflies"]["$i"]["name"])) {
    print "<td>";
    print "<input type=\"checkbox\" id=\"btfly$i\" name=\"btfly$i\" onchange=\"saveMisc();\" value=\"$i\">&nbsp;{$farmdata["updateblock"]["farmersmarket"]["butterfly"]["config"]["butterflies"]["$i"]["name"]}\n";
    print "</td>";
    $i++;
   }
  }
  $i--;
  print "</tr>";
 }
} else {
 print "<th>{$strings['notavailable']}</th>";
}
print "</table>\n";
print "</div>\n";
print "</form>\n";

// set saved options
print "<script type=\"text/javascript\">\n";

global $configContents;
$expectedKeys = [ 'carefood', 'caretoy', 'careplushy', 'dodog', 'dologinbonus',
'dolot', 'vehiclemgmt5', 'vehiclemgmt6', 'vehiclemgmt7', 'dopuzzleparts', 'sendfarmiesaway',
'sendforestryfarmiesaway', 'sendmunchiesaway', 'sendflowerfarmiesaway', 'transO7',
'correctqueuenum', 'useponyenergybar', 'redeempuzzlepacks', 'dobutterflies',
'dodeliveryevent', 'doolympiaevent', 'dopentecostevent', 'doseedbox', 'docowracepvp', 'trimlogstock',
'dodonkey', 'docowrace', 'excluderank1cow', 'dofoodcontest', 'restartvetjob',
'docalendarevent', 'doinfinitequest', 'racecowslot1', 'racecowslot2', 'racecowslot3',
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
'fishinggear3', 'preferredbait1', 'preferredbait2', 'preferredbait3', 'removeweed' ];
// make sure missing options don't mess up the options' display
for ($i = 0; $i < count($expectedKeys); $i++)
 if (!isset($configContents[$expectedKeys[$i]]))
  $configContents[$expectedKeys[$i]] = '0';

$savedValue = $configContents['carefood'];
print "if (document.getElementById('carefood') !== null)\n";
print " document.getElementById('carefood').selectedIndex = document.getElementById('o$savedValue').index;\n";
$savedValue = $configContents['caretoy'];
print "if (document.getElementById('caretoy') !== null)\n";
print " document.getElementById('caretoy').selectedIndex = document.getElementById('o$savedValue').index;\n";
$savedValue = $configContents['careplushy'];
print "if (document.getElementById('careplushy') !== null)\n";
print " document.getElementById('careplushy').selectedIndex = document.getElementById('o$savedValue').index;\n";
$savedValue = $configContents['dologinbonus'];
print "document.getElementById('loginbonus').selectedIndex = document.getElementById('o$savedValue').index;\n";
$savedValue = $configContents['vehiclemgmt5'];
$savedValue = "vehicle" . $savedValue;
print "document.getElementById('vehiclemgmt5').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['vehiclemgmt6'];
$savedValue = "vehicle" . $savedValue;
print "document.getElementById('vehiclemgmt6').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['vehiclemgmt7'];
$savedValue = "vehicle" . $savedValue;
print "document.getElementById('vehiclemgmt7').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['transO7'];
$savedValue = "tO7" . $savedValue;
print "document.getElementById('transO7').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['restartvetjob'];
$savedValue = "vjdiff" . $savedValue;
print "document.getElementById('vetjobdifficulty').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['dolot'];
$savedValue = "lot" . $savedValue;
print "document.getElementById('lottoggle').selectedIndex = document.getElementById('$savedValue').index;\n";
$savedValue = $configContents['autobuyrefillto'];
$savedValue = "autobuyrefillto" . $savedValue;
print "document.getElementById('autobuyrefillto').selectedIndex = document.getElementById('$savedValue').index;\n";

reset($togglesarray);
for ($i = 0; $i < count($togglesarray); $i++) {
 $savedkey=key($togglesarray);
 $toggle=$togglesarray[$savedkey];
 $savedValue = $configContents[$savedkey];
 if ($savedValue == '1')
  print "document.getElementById('$toggle').checked = true;\n";
 next($togglesarray);
}

for ($i = 1; $i <= 15; $i++) {
$savedValue = $configContents['racecowslot' . $i];
print "document.getElementById('racecowslot$i').selectedIndex = document.getElementById('o$savedValue').index;\n";
}

for ($i = 1; $i <= 4; $i++) {
$savedValue = $configContents['fruitstallslot' . $i];
print "document.getElementById('fruitstallslot$i').selectedIndex = document.getElementById('fs$savedValue').index;\n";
if ($i == 4)
 break;
$savedValue = $configContents['fruitstall2slot' . $i];
print "document.getElementById('fruitstall2slot$i').selectedIndex = document.getElementById('2fs$savedValue').index;\n";
}

for ($i = 1; $i <= 17; $i++) {
$savedValue = $configContents['flowerarrangementslot' . $i];
print "document.getElementById('flowerarrangementslot$i').selectedIndex = document.getElementById('o$savedValue').index;\n";
}

for ($i = 1; $i <= 3; $i++) {
 $savedValue = $configContents['speciesbait' . $i];
 print "if (document.getElementById('speciesbait$i') !== null)\n";
 print " document.getElementById('speciesbait$i').selectedIndex = document.getElementById('sb$i$savedValue').index;\n";
 $savedValue = $configContents['raritybait' . $i];
 print "if (document.getElementById('raritybait$i') !== null)\n";
 print " document.getElementById('raritybait$i').selectedIndex = document.getElementById('rb$i$savedValue').index;\n";
 $savedValue = $configContents['fishinggear' . $i];
 print "if (document.getElementById('fishinggear$i') !== null)\n";
 print " document.getElementById('fishinggear$i').selectedIndex = document.getElementById('fg$i$savedValue').index;\n";
 $savedValue = $configContents['preferredbait' . $i];
 print "if (document.getElementById('preferredbait$i') !== null)\n";
 print " document.getElementById('preferredbait$i').selectedIndex = document.getElementById('pb$i$savedValue').index;\n";
}

$savedValue = explode(" ", $configContents['autobuyitems']);
if ($savedValue[0] != '0')
 for ($i = 0; $i < count($savedValue); $i++)
  print "document.getElementById('autobuyitem$savedValue[$i]').checked = true;\n";

$savedValue = explode(" ", $configContents['autobuybutterflies']);
if ($savedValue[0] != '0')
 for ($i = 0; $i < count($savedValue); $i++)
  print "document.getElementById('btfly$savedValue[$i]').checked = true;\n";
print "</script>\n";
?>
