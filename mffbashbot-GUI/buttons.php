<?php
// Buttons file for Harrys My Free Farm Bash Bot (front end)
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
//include_once 'farmdata.php';

if ($farm == NULL)
 $farm = 1;
if ($farm == "runbot") {
 exec("script/wakeupthebot.sh " . $gamepath);
 $farm = 1;
}
$farmFriendlyName = ["1" => "Farm 1", "2" => "Farm 2", "3" => "Farm 3", "4" => "Farm 4", "5" => "Farm 5", "farmersmarket" => "der Bauernmarkt", "forestry" => "die B&auml;umerei", "foodworld" => "die Picknickarea", "city2" => "Teichlingen"];
print "<script type=\"text/javascript\" src=\"script/AJAXqueuefunctions.js\"></script>\n";
print "<small>";
system("cat " . $gamepath . "/../version.txt");
print " - " . $username . "</small>";
print "<h1>Dies ist " . $farmFriendlyName["$farm"] . "</h1>";
print "Letzte Laufzeit: <b><div id=\"lastruntime\" style=\"display:inline\">";
system("cat " . $gamepath . "/lastrun.txt");
print "</div></b> -- Der Bot ist gerade <b><div id=\"botstatus\" style=\"display:inline\">";
system("cat " . $gamepath . "/status.txt");
print "</div></b><form name=\"venueselect\" method=\"post\" action=\"showfarm.php\" style=\"margin-bottom:5px;\">\n";
print "<input type=\"hidden\" name=\"farm\" value=\"" . $farm . "\">\n";
print "<input type=\"hidden\" name=\"username\" value=\"" . $username . "\">";
for ($i = 1; $i < 6; $i++)
 print "<input type=\"image\" src=\"image/navi_farm" . $i . ".png\" class=\"navilink\" title=\"Farm " . $i . "\" name=\"" . $i . "\" onclick=\"document.venueselect.farm.value = '" . $i . "'; this.form.submit();\">\n";
print "<input type=\"image\" src=\"image/farmersmarket.png\" class=\"navilink\" title=\"Bauernmarkt\" name=\"farmersmarket\" onclick=\"document.venueselect.farm.value='farmersmarket'; document.venueselect.action='showfarmersmarket.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/forestry.png\" class=\"navilink\" title=\"B&auml;umerei\" name=\"forestry\" onclick=\"document.venueselect.farm.value='forestry'; this.form.action='showforestry.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/foodworld.png\" class=\"navilink\" title=\"Picknickarea\" name=\"foodworld\" onclick=\"document.venueselect.farm.value='foodworld'; this.form.action='showfoodworld.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/navi_city2.png\" class=\"navilink\" title=\"Teichlingen\" name=\"city2\" onclick=\"document.venueselect.farm.value='city2'; this.form.action='showcity2.php'; this.form.submit()\">\n";
print "<input type=\"button\" name=\"runbot\" value=\"BOT&#13;&#10;START\" title=\"Bot-Durchlauf erzwingen\" onclick=\"document.venueselect.farm.value='runbot'; this.form.submit()\" style=\"text-align:center;\">&nbsp;\n";
print "<input type=\"button\" name=\"logon\" value=\"Anmeldung\" onclick=\"this.form.action='index.php'; this.form.submit()\">\n";
print "<br>";
print "<div id=\"optionspane\" style=\"display:none;\">";
print "<table name=\"opttbl\" style=\"float:left;\" border=\"1\">";
print "<tr><th>Optionen</th></tr>";
print "<tr><td>";
print "<input type=\"checkbox\" id=\"dogtoggle\" name=\"dogtoggle\" onchange=\"saveMisc();\" value=\"1\">&nbsp;Ben t&auml;glich aktivieren";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"lottoggle\" name=\"lottoggle\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"lot0\">Sleep</option>\n";
print "<option value=\"1\" id=\"lot1\">Los</option>\n";
print "<option value=\"2\" id=\"lot2\">Sofortgewinn</option></select>&nbsp;t&auml;glich abholen\n";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"vehiclemgmt\" name=\"vehiclemgmt\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"vehicle0\">Sleep</option>\n";
print "<option value=\"1\" id=\"vehicle1\">Schafkarren</option>\n";
print "<option value=\"2\" id=\"vehicle2\">Traktor</option>\n";
print "<option value=\"3\" id=\"vehicle3\">LKW</option>\n";
print "<option value=\"4\" id=\"vehicle4\">Sportwagen</option>\n";
print "<option value=\"5\" id=\"vehicle5\">Truck</option></select>&nbsp;Automatische Transportfahrten";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"carefood\" name=\"carefood\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"0\">Sleep</option>\n";
CreateOptionsWithID(600, 601, 602, 603, 604, 605, 606, 607, 608, 609);
print "</select>&nbsp;Futterbed&uuml;rfnis stillen";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"caretoy\" name=\"caretoy\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"0\">Sleep</option>\n";
CreateOptionsWithID(630, 631, 632, 633, 634, 635, 636, 637, 638, 639);
print "</select>&nbsp;Spielzeugbed&uuml;rfnis stillen";
print "</td></tr>";
print "<tr><td>";
print "<select id=\"careplushy\" name=\"careplushy\" onchange=\"saveMisc();\">";
print "<option value=\"0\" id=\"0\">Sleep</option>\n";
CreateOptionsWithID(660, 661, 662, 663, 664, 665, 666, 667, 668, 669);
print "</select>&nbsp;Kuscheltierbed&uuml;rfnis stillen";
print "</td></tr></table>\n";
print "</div>\n";
print "</form><button id=\"optbtn\" onclick=\"showHideOptions();\">Optionen...</button>\n";
print "<hr>\n";
// set saved options
print "<script type=\"text/javascript\">\n";
global $configContents;
$savedValue = $configContents['carefood'];
print "document.getElementById('carefood').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";
$savedValue = $configContents['caretoy'];
print "document.getElementById('caretoy').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";
$savedValue = $configContents['careplushy'];
print "document.getElementById('careplushy').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";
$savedValue = $configContents['vehiclemgmt'];
$savedValue = "vehicle" . $savedValue;
print "document.getElementById('vehiclemgmt').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";
$savedValue = $configContents['dolot'];
$savedValue = "lot" . $savedValue;
print "document.getElementById('lottoggle').selectedIndex = document.getElementById('" . $savedValue . "').index;\n";
$savedValue = $configContents['dodog'];
if ($savedValue == '1')
 print "document.getElementById('dogtoggle').checked = true;\n";
print "</script>\n";
?>
