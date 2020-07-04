<?php
// Buttons file for My Free Farm Bash Bot (front end)
// Copyright 2016-20 Harun "Harry" Basalamah
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
"doseedbox" => "redeemdailyseedboxtoggle",
"dodonkey" => "donkeytoggle",
"docowrace" => "cowracetoggle",
"excluderank1cow" => "excluderank1cowtoggle",
"dofoodcontest" => "foodcontesttoggle",
"doinfinitequest" => "infinitequesttoggle"
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
$strings['dailyseedboxredeem'],
$strings['waltraud'],
$strings['startcowrace'],
$strings['excluderank1cow'],
$strings['feedsecontestant'],
$strings['sendrosieshopping']
];

print "<h1>" . $strings['youareat'] . " " . $farmFriendlyName["$farm"] . "</h1>";
print "<form name=\"venueselect\" method=\"post\" action=\"showfarm.php\" style=\"margin-bottom:5px;\">\n";
print "<input type=\"hidden\" name=\"farm\" value=\"" . $farm . "\">\n";
print "<input type=\"hidden\" name=\"username\" value=\"" . $username . "\">\n";
for ($i = 1; $i <= 7; $i++)
 print "<input type=\"image\" src=\"image/navi_farm" . $i . ".png\" class=\"navilink\" title=\"" . $farmFriendlyName[$i] . "\" name=\"" . $i . "\" onclick=\"document.venueselect.farm.value = '" . $i . "'; this.form.submit();\">\n";
print "<input type=\"image\" src=\"image/farmersmarket.png\" class=\"navilink\" title=\"" . $farmFriendlyName['farmersmarket'] . "\" name=\"farmersmarket\" onclick=\"document.venueselect.farm.value='farmersmarket'; document.venueselect.action='showvenue.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/farmersmarket2.png\" class=\"navilink\" title=\"" . $farmFriendlyName['farmersmarket2'] . "\" name=\"farmersmarket2\" onclick=\"document.venueselect.farm.value='farmersmarket2'; document.venueselect.action='showvenue.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/forestry.png\" class=\"navilink\" title=\"" . $farmFriendlyName['forestry'] . "\" name=\"forestry\" onclick=\"document.venueselect.farm.value='forestry'; this.form.action='showvenue.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/foodworld.png\" class=\"navilink\" title=\"" . $farmFriendlyName['foodworld'] . "\" name=\"foodworld\" onclick=\"document.venueselect.farm.value='foodworld'; this.form.action='showvenue.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/navi_city2.png\" class=\"navilink\" title=\"" . $farmFriendlyName['city2'] . "\" name=\"city2\" onclick=\"document.venueselect.farm.value='city2'; this.form.action='showvenue.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/runbot.png\" class=\"navilink\" name=\"runbot\" title=\"" . $strings['forcebotstart'] . "\" onclick=\"document.venueselect.farm.value='runbot'; this.form.submit()\">&nbsp;\n";
print "<input type=\"button\" name=\"logon\" class=\"btn btn-warning btn-sm logonbtn\" value=\"" . $strings['logon'] . "\" onclick=\"this.form.action='index.php'; this.form.submit()\">\n";
print "<br>";
// misc options
print "<div id=\"optionspane\" style=\"display:none;\">";
print "<table id=\"opttbl\" style=\"float:left;\" border=\"1\">";
print "<tr><th>" . $strings['options'] . "</th></tr>";
for ($i = 0; $i < count($togglesarray); $i++) {
 $savedkey=key($togglesarray);
 $toggle=$togglesarray[$savedkey];
 print "<tr><td>\n";
 print "<label class=\"switch\">\n";
 print "<input type=\"checkbox\" id=\"" . $toggle . "\" name=\"" . $toggle . "\" onchange=\"saveMisc();\" value=\"1\">\n";
 print "<span class=\"slider round\"></span></label>$toggledesc[$i]\n";
 print "</td></tr>\n";
 next($togglesarray);
}
print "<tr><td>";
print "<select id=\"lottoggle\" name=\"lottoggle\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"lot0\">Sleep</option>\n";
print "<option value=\"1\" id=\"lot1\">" . $strings['lot'] . "</option>\n";
print "<option value=\"2\" id=\"lot2\">" . $strings['instantwin'] . "</option></select>&nbsp;" . $strings['collectdaily'] . "\n";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"loginbonus\" name=\"loginbonus\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"o0\">Sleep</option>\n";
CreateOptionsWithIDfromArray($farmdata["updateblock"]["menue"]["loginbonus"]["products"]);
print "</select>&nbsp;" . $strings['collectloginbonus'] . "\n";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"vehiclemgmt5\" name=\"vehiclemgmt5\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"vehicle0\">Sleep</option>\n";
print "<option value=\"1\" id=\"vehicle1\">" . $strings['sheepcart'] . "</option>\n";
print "<option value=\"2\" id=\"vehicle2\">" . $strings['tractor'] . "</option>\n";
print "<option value=\"3\" id=\"vehicle3\">" . $strings['lorry'] . "</option>\n";
print "<option value=\"4\" id=\"vehicle4\">" . $strings['sportscar'] . "</option>\n";
print "<option value=\"5\" id=\"vehicle5\">" . $strings['truck'] . "</option></select>&nbsp;" . $strings['autotransport5'];
print "</td></tr>";
print "<tr><td>";
print "<select id=\"vehiclemgmt6\" name=\"vehiclemgmt6\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"vehicle0\">Sleep</option>\n";
print "<option value=\"6\" id=\"vehicle6\">" . $strings['dogsled'] . "</option>\n";
print "<option value=\"7\" id=\"vehicle7\">" . $strings['atv'] . "</option>\n";
print "<option value=\"8\" id=\"vehicle8\">" . $strings['snowgroomer'] . "</option>\n";
print "<option value=\"9\" id=\"vehicle9\">" . $strings['helicopter'] . "</option>\n";
print "<option value=\"10\" id=\"vehicle10\">" . $strings['hotairballoon'] . "</option></select>&nbsp;" . $strings['autotransport6'];
print "</td></tr>";
print "<tr><td>";
print "<select id=\"vehiclemgmt7\" name=\"vehiclemgmt7\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"vehicle0\">Sleep</option>\n";
print "<option value=\"11\" id=\"vehicle11\">" . $strings['coach'] . "</option>\n";
print "<option value=\"12\" id=\"vehicle12\">" . $strings['tuktuk'] . "</option>\n";
print "<option value=\"13\" id=\"vehicle13\">" . $strings['sprinter'] . "</option>\n";
print "<option value=\"14\" id=\"vehicle14\">" . $strings['drone'] . "</option>\n";
print "<option value=\"15\" id=\"vehicle15\">" . $strings['airplane'] . "</option></select>&nbsp;" . $strings['autotransport7'];
print "</td></tr>";
print "<tr><td>";
print "<select id=\"vetjobdifficulty\" name=\"vetjobdifficulty\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"vjdiff0\">Sleep</option>\n";
print "<option value=\"1\" id=\"vjdiff1\">" . $strings['vetjobeasy'] . "</option>\n";
print "<option value=\"2\" id=\"vjdiff2\">" . $strings['vetjobmedium'] . "</option>\n";
print "<option value=\"3\" id=\"vjdiff3\">" . $strings['vetjobhard'] . "</option></select>&nbsp;" . $strings['restartvetjob'] . "\n";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"carefood\" name=\"carefood\" onchange=\"saveMisc();\">";
// dirty coding so getElementById() can find id "o0"
print "<option value=\"0\" id=\"o0\">Sleep</option>\n";
// einzigartige indizes, bekommen das präfix "o"
CreateOptionsWithID("o", 600, 601, 602, 603, 604, 605, 606, 607, 608, 609);
print "</select>&nbsp;" . $strings['satisfyfoodneed'];
print "</td></tr>";
print "<tr><td>";
print "<select id=\"caretoy\" name=\"caretoy\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"caretoy0\">Sleep</option>\n";
CreateOptionsWithID("o", 630, 631, 632, 633, 634, 635, 636, 637, 638, 639);
print "</select>&nbsp;" . $strings['satisfytoyneed'];
print "</td></tr>";
print "<tr><td>";
print "<select id=\"careplushy\" name=\"careplushy\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"careplushy0\">Sleep</option>\n";
CreateOptionsWithID("o", 660, 661, 662, 663, 664, 665, 666, 667, 668, 669);
print "</select>&nbsp;" . $strings['satisfyplushyneed'];
print "</td></tr></table>\n";
print "</div>\n";
// race cow slots
print "<div id=\"racecowslotspane\" style=\"display:none;\">";
print "<table id=\"racecowslotstbl\" style=\"float:left;\" border=\"1\">";
print "<tr><th>" . $strings['racecowslots'] . "</th></tr>\n";
for ($i = 1; $i <= 13; $i++) {
 print "<tr><td>";
 print "<select id=\"racecowslot" . $i . "\" name=\"racecowslot" . $i . "\" onchange=\"saveMisc();\">";
 print "<option value=\"0\" id=\"racecowslot0\">Sleep</option>\n";
 CreateOptionsWithID("o", 800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819);
 print "</select>&nbsp;" . $strings['slot'] . "&nbsp;" . $i;
 print "</td></tr>";
}
print "</table>\n";
print "</div>\n";
// fruit stall slots
print "<div id=\"fruitstallspane\" style=\"display:none;\">";
print "<table id=\"fruitstallslotstbl\" style=\"float:left;\" border=\"1\">";
print "<tr><th>" . $strings['fruitstallslots'] . "</th></tr>\n";
for ($i = 1; $i <= 4; $i++) {
 print "<tr><td>";
 print "<select id=\"fruitstallslot" . $i . "\" name=\"fruitstallslot" . $i . "\" onchange=\"saveMisc();\">";
 print "<option value=\"0\" id=\"fs0\">Sleep</option>\n";
 // indizes, die bereits als "o"-wert existieren dürfen nicht mit verschiedenem index erneut erzeugt werden
 // daher bekommt der obststand ein eigenes präfix
 CreateOptionsWithID("fs", 1, 2, 3, 4, 5, 6, 7, 8, 17, 18, 19, 20, 21, 22, 23, 24, 26, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 108, 109, 112, 113, 114, 115, 126, 127, 128, 153, 154, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834);
 print "</select>&nbsp;" . $strings['slot'] . "&nbsp;" . $i;
 print "</td></tr>";
}
print "</table>\n";
print "</div>\n";
// auto-buy
print "<div id=\"autobuypane\" style=\"display:none;\">";
print "<table id=\"autobuytbl\" style=\"float:left;\" border=\"1\">";
print "<tr><th colspan=\"8\">" . $strings['stockmgmt'] . "</th></tr>\n";
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
print "</select>&nbsp;" . $strings['buyatmerchant'];
print "</td></tr>";
$buyableGoods = [ 1, 2, 3, 4, 5, 6, 7, 8, 17, 18, 19, 20, 21, 22, 23, 24, 26, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 108, 109, 112, 113, 114, 115, 126, 127, 128, 153, 154, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834 ];
for ($i = 0; $i < count($buyableGoods); $i++) {
 print "<tr>";
 for ($j = 0; $j <= 7; $j++) {
  if (isset($buyableGoods[$i])) {
   print "<td>";
   print "<input type=\"checkbox\" id=\"autobuyitem" . $buyableGoods[$i] . "\" name=\"autobuyitem" . $buyableGoods[$i] . "\" onchange=\"saveMisc();\" value=\"" . $buyableGoods[$i] . "\">&nbsp;" . $productlist[$buyableGoods[$i]] . "\n";
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
print "<tr><th>" . $strings['flowerarrangements'] . "</th></tr>\n";
for ($i = 1; $i <= 17; $i++) {
 print "<tr><td>";
 print "<select id=\"flowerarrangementslot" . $i . "\" name=\"flowerarrangementslot" . $i . "\" onchange=\"saveMisc();\">";
 print "<option value=\"0\" id=\"flowerarrangementslot0\">Sleep</option>\n";
 CreateOptionsWithID("o", 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221);
 print "</select>&nbsp;" . $strings['slot'] . "&nbsp;" . $i;
 print "</td></tr>";
}
print "</table>\n";
print "</div>\n";

print "</form><button class=\"btn btn-outline-dark btn-sm\" id=\"optbtn\" onclick=\"showHideOptions('optionspane');\">" . $strings['options'] . "...</button>\n";
print "<button class=\"btn btn-outline-dark btn-sm\" id=\"flowerarrangementsbtn\" onclick=\"showHideOptions('flowerarrangementspane');\">" . $strings['flowerarrangements'] . "...</button>\n";
print "<button class=\"btn btn-outline-dark btn-sm\" id=\"cowslotsbtn\" onclick=\"showHideOptions('racecowslotspane');\">" . $strings['racecowslots'] . "...</button>\n";
print "<button class=\"btn btn-outline-dark btn-sm\" id=\"fruitstallslotsbtn\" onclick=\"showHideOptions('fruitstallspane');\">" . $strings['fruitstallslots'] . "...</button>\n";
print "<button class=\"btn btn-outline-dark btn-sm\" id=\"autobuybtn\" onclick=\"showHideOptions('autobuypane');\">" . $strings['stockmgmt'] . "...</button>\n";
print "<hr>\n";
// set saved options
print "<script type=\"text/javascript\">\n";

global $configContents;
$expectedKeys = [ 'carefood', 'caretoy', 'careplushy', 'dodog', 'dologinbonus',
'dolot', 'vehiclemgmt5', 'vehiclemgmt6', 'vehiclemgmt7', 'dopuzzleparts', 'sendfarmiesaway',
'sendforestryfarmiesaway', 'sendmunchiesaway', 'sendflowerfarmiesaway',
'correctqueuenum', 'useponyenergybar', 'redeempuzzlepacks', 'dobutterflies',
'dodeliveryevent', 'doolympiaevent', 'doseedbox',
'dodonkey', 'docowrace', 'excluderank1cow', 'dofoodcontest', 'restartvetjob',
'docalendarevent', 'doinfinitequest', 'racecowslot1', 'racecowslot2', 'racecowslot3',
'racecowslot4', 'racecowslot5', 'racecowslot6', 'racecowslot7', 'racecowslot8',
'racecowslot9', 'racecowslot10', 'racecowslot11', 'racecowslot12',
'racecowslot13', 'fruitstallslot1', 'fruitstallslot2', 'fruitstallslot3',
'fruitstallslot4', 'autobuyitems', 'autobuyrefillto', 'flowerarrangementslot1',
'flowerarrangementslot2', 'flowerarrangementslot3', 'flowerarrangementslot4',
'flowerarrangementslot5', 'flowerarrangementslot6', 'flowerarrangementslot7',
'flowerarrangementslot8', 'flowerarrangementslot9', 'flowerarrangementslot10',
'flowerarrangementslot11', 'flowerarrangementslot12', 'flowerarrangementslot13',
'flowerarrangementslot14', 'flowerarrangementslot15', 'flowerarrangementslot16',
'flowerarrangementslot17' ];
// make sure missing options don't mess up the options' display
for ($i = 0; $i < count($expectedKeys); $i++)
 if (!isset($configContents[$expectedKeys[$i]]))
  $configContents[$expectedKeys[$i]] = '0';

$savedValue = $configContents['carefood'];
print "document.getElementById('carefood').selectedIndex = document.getElementById('o" . $savedValue . "').index;\n";
$savedValue = $configContents['caretoy'];
print "document.getElementById('caretoy').selectedIndex = document.getElementById('o" . $savedValue . "').index;\n";
$savedValue = $configContents['careplushy'];
print "document.getElementById('careplushy').selectedIndex = document.getElementById('o" . $savedValue . "').index;\n";
$savedValue = $configContents['dologinbonus'];
print "document.getElementById('loginbonus').selectedIndex = document.getElementById('o" . $savedValue . "').index;\n";
$savedValue = $configContents['vehiclemgmt5'];
$savedValue = "vehicle" . $savedValue;
print "document.getElementById('vehiclemgmt5').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";
$savedValue = $configContents['vehiclemgmt6'];
$savedValue = "vehicle" . $savedValue;
print "document.getElementById('vehiclemgmt6').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";
$savedValue = $configContents['vehiclemgmt7'];
$savedValue = "vehicle" . $savedValue;
print "document.getElementById('vehiclemgmt7').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";
$savedValue = $configContents['restartvetjob'];
$savedValue = "vjdiff" . $savedValue;
print "document.getElementById('vetjobdifficulty').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";
$savedValue = $configContents['dolot'];
$savedValue = "lot" . $savedValue;
print "document.getElementById('lottoggle').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";
$savedValue = $configContents['autobuyrefillto'];
$savedValue = "autobuyrefillto" . $savedValue;
print "document.getElementById('autobuyrefillto').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";

reset($togglesarray);
for ($i = 0; $i < count($togglesarray); $i++) {
 $savedkey=key($togglesarray);
 $toggle=$togglesarray[$savedkey];
 $savedValue = $configContents[$savedkey];
 if ($savedValue == '1')
  print "document.getElementById('" . $toggle . "').checked = true;\n";
 next($togglesarray);
}

for ($i = 1; $i <= 13; $i++) {
$savedValue = $configContents['racecowslot' . $i];
print "document.getElementById('racecowslot" . $i . "').selectedIndex = document.getElementById('o" . $savedValue . "').index;\n";
}

for ($i = 1; $i <= 4; $i++) {
$savedValue = $configContents['fruitstallslot' . $i];
print "document.getElementById('fruitstallslot" . $i . "').selectedIndex = document.getElementById('fs" . $savedValue . "').index;\n";
}

for ($i = 1; $i <= 17; $i++) {
$savedValue = $configContents['flowerarrangementslot' . $i];
print "document.getElementById('flowerarrangementslot" . $i . "').selectedIndex = document.getElementById('o" . $savedValue . "').index;\n";
}

$savedValue = explode(" ", $configContents['autobuyitems']);
for ($i = 0; $i < count($savedValue); $i++)
 print "document.getElementById('autobuyitem" . $savedValue[$i] . "').checked = true;\n";
print "</script>\n";
?>
