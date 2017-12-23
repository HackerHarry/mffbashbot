<?php
// Buttons file for Harrys My Free Farm Bash Bot (front end)
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
if (!isset($farm))
 $farm = 1;
if ($farm == "runbot") {
 exec("script/wakeupthebot.sh " . $gamepath);
 $farm = 1;
}
include 'JSfunctions.php';
$botver = file_get_contents($gamepath . "/../version.txt");
print "<small>" . $botver . " - " . $username . "</small>";
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
"megafieldinstantplant" => "megafieldplanttoggle",
"doseedbox" => "redeemdailyseedboxtoggle"
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
$strings['megafieldplantafterharvest'],
$strings['dailyseedboxredeem']
];

if (version_compare($botver, $versionavailable) == -1) {
 print " -- ";
 print "<div id=\"updatenotification\" style=\"display:inline; font-weight: bold\">" . $strings['updateavailable'];
 print "<button id=\"updatebtn\" onclick=\"confirmUpdate()\">" . $strings['updateto'] . " " . $versionavailable . "</button>";
 print "<small> -- " . $strings['historyishere'] . "</small></div>";
}
print "<h1>" . $strings['youareat'] . " " . $farmFriendlyName["$farm"] . "</h1>";
print $strings['lastbotiteration'] . ": <div id=\"lastruntime\" style=\"display:inline; font-weight: bold\">";
system("cat " . $gamepath . "/lastrun.txt");
print "</div> -- " . $strings['thebotis'] . " <div id=\"botstatus\" style=\"display:inline; font-weight: bold\">\n";
include 'getbotstatus.php';
print "</div><form name=\"venueselect\" method=\"post\" action=\"showfarm.php\" style=\"margin-bottom:5px;\">\n";
print "<input type=\"hidden\" name=\"farm\" value=\"" . $farm . "\">\n";
print "<input type=\"hidden\" name=\"username\" value=\"" . $username . "\">\n";
for ($i = 1; $i < 7; $i++)
 print "<input type=\"image\" src=\"image/navi_farm" . $i . ".png\" class=\"navilink\" title=\"" . $farmFriendlyName[$i] . "\" name=\"" . $i . "\" onclick=\"document.venueselect.farm.value = '" . $i . "'; this.form.submit();\">\n";
print "<input type=\"image\" src=\"image/farmersmarket.png\" class=\"navilink\" title=\"" . $farmFriendlyName['farmersmarket'] . "\" name=\"farmersmarket\" onclick=\"document.venueselect.farm.value='farmersmarket'; document.venueselect.action='showfarmersmarket.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/forestry.png\" class=\"navilink\" title=\"" . $farmFriendlyName['forestry'] . "\" name=\"forestry\" onclick=\"document.venueselect.farm.value='forestry'; this.form.action='showforestry.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/foodworld.png\" class=\"navilink\" title=\"" . $farmFriendlyName['foodworld'] . "\" name=\"foodworld\" onclick=\"document.venueselect.farm.value='foodworld'; this.form.action='showfoodworld.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/navi_city2.png\" class=\"navilink\" title=\"" . $farmFriendlyName['city2'] . "\" name=\"city2\" onclick=\"document.venueselect.farm.value='city2'; this.form.action='showcity2.php'; this.form.submit()\">\n";
print "<input type=\"button\" name=\"runbot\" value=\"BOT&#13;&#10;START\" title=\"" . $strings['forcebotstart'] . "\" onclick=\"document.venueselect.farm.value='runbot'; this.form.submit()\" style=\"text-align:center;\">&nbsp;\n";
print "<input type=\"button\" name=\"logon\" value=\"" . $strings['logon'] . "\" onclick=\"this.form.action='index.php'; this.form.submit()\">\n";
print "<br>";
// misc options
print "<div id=\"optionspane\" style=\"display:none;\">";
print "<table id=\"opttbl\" style=\"float:left;\" border=\"1\">";
print "<tr><th>" . $strings['options'] . "</th></tr>";
for ($i = 0; $i < count($togglesarray); $i++) {
 $savedkey=key($togglesarray);
 $toggle=$togglesarray[$savedkey];
 print "<tr><td>\n";
 print "<input type=\"checkbox\" id=\"" . $toggle . "\" name=\"" . $toggle . "\" onchange=\"saveMisc();\" value=\"1\">&nbsp;" . $toggledesc[$i] . "\n";
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
print "<select id=\"carefood\" name=\"carefood\" onchange=\"saveMisc();\">";
// dirty coding so getElementById() can find id "o0"
print "<option value=\"0\" id=\"o0\">Sleep</option>\n";
CreateOptionsWithID(600, 601, 602, 603, 604, 605, 606, 607, 608, 609);
print "</select>&nbsp;" . $strings['satisfyfoodneed'];
print "</td></tr>";
print "<tr><td>";
print "<select id=\"caretoy\" name=\"caretoy\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"caretoy0\">Sleep</option>\n";
CreateOptionsWithID(630, 631, 632, 633, 634, 635, 636, 637, 638, 639);
print "</select>&nbsp;" . $strings['satisfytoyneed'];
print "</td></tr>";
print "<tr><td>";
print "<select id=\"careplushy\" name=\"careplushy\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"careplushy0\">Sleep</option>\n";
CreateOptionsWithID(660, 661, 662, 663, 664, 665, 666, 667, 668, 669);
print "</select>&nbsp;" . $strings['satisfyplushyneed'];
print "</td></tr></table>\n";
print "</div>\n";
print "</form><button id=\"optbtn\" onclick=\"showHideOptions();\">" . $strings['options'] . "...</button>\n";
print "<hr>\n";
// set saved options
print "<script type=\"text/javascript\">\n";
global $configContents;
$savedValue = $configContents['carefood'];
print "document.getElementById('carefood').selectedIndex = document.getElementById('o" . $savedValue . "').index;\n";
$savedValue = $configContents['caretoy'];
print "document.getElementById('caretoy').selectedIndex = document.getElementById('o" . $savedValue . "').index;\n";
$savedValue = $configContents['careplushy'];
print "document.getElementById('careplushy').selectedIndex = document.getElementById('o" . $savedValue . "').index;\n";
$savedValue = $configContents['vehiclemgmt5'];
$savedValue = "vehicle" . $savedValue;
print "document.getElementById('vehiclemgmt5').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";
$savedValue = $configContents['vehiclemgmt6'];
$savedValue = "vehicle" . $savedValue;
print "document.getElementById('vehiclemgmt6').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";
$savedValue = $configContents['dolot'];
$savedValue = "lot" . $savedValue;
print "document.getElementById('lottoggle').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";

reset($togglesarray);
for ($i = 0; $i < count($togglesarray); $i++) {
 $savedkey=key($togglesarray);
 $toggle=$togglesarray[$savedkey];
 $savedValue = $configContents[$savedkey];
 if ($savedValue == '1')
  print "document.getElementById('" . $toggle . "').checked = true;\n";
 next($togglesarray);
}
print "</script>\n";
?>
