<?php
// This file is part of My Free Farm Bash Bot (front end)
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
@ini_set('zlib.output_compression', 0);
@ini_set('implicit_flush', 1);
for ($i = 0; $i < ob_get_level(); $i++)
 ob_end_flush();
ob_implicit_flush(1);
if (empty($_POST["username"])) {
 print "1;<h4><font color=\"darkred\">Please select/enter a farm name</font></h4>\n";
 exit(1);
}
strpos($_POST["username"], ' ') === false ? $username = $_POST["username"] : $username = rawurlencode($_POST["username"]);
include 'functions.php';
include 'config.php';
include 'lang.php';
if (empty($_POST["server"])) {
 print "1;<h4><font color=\"darkred\">" . $strings['selectserver'] . "</font></h4>\n";
 exit(1);
}
$server = $_POST["server"];
if (empty($_POST["password"])) {
 print "1;<h4><font color=\"darkred\">" . $strings['enterpw'] . "</font></h4>\n";
 exit(1);
}
$password = $_POST["password"];
echo "1;<h4><font color=\"yellow\">" . $strings['pleasewait'] . "</font></h4>;";
ob_flush();
flush();
if (empty($_POST["language"])) {
 // this is a logon request
 system("script/logonandgetfarmdata.sh " . $username . " " . $password . " " . $server . " " . $lang, $retval);
 if ( $retval == 0 ) {
  print "0;<h4><font color=\"lime\">" . $strings['logonsuccess'] . "</font></h4>;";
  ob_flush();
  flush();
  print "<form name=\"jump2farm\" method=\"post\" action='showfarm.php'>";
  print "<input type=\"hidden\" name=\"username\" value=\"" . $username . "\">";
  print "<input type=\"hidden\" name=\"farm\" value=\"1\">";
  print "<input type=\"hidden\" name=\"lang\" value=\"" . $lang . "\">";
  print "</form>";
 }
 else
  print "1;<h4><font color=\"darkred\">" . $strings['logonfailed'] . "</font></h4>\n";
}
else
{
 // this is an "add farm" request
 $lang = $_POST["language"];
 include 'config.php';
 system("script/addfarm.sh " . $password . " " . $server . " " . $lang . " " . $gamepath, $retval);
 if ( $retval == 0 ) {
  print "0;<h4><font color=\"lime\">" . $strings['farmadded'] . "</font></h4>;";
  ob_flush();
  flush();
  print "<form name=\"jump2farm\" method=\"get\" action='index.php'>";
  print "</form>";
 }
 else
  print "1;<h4><font color=\"darkred\">" . $strings['farmadditionfailed'] . "</font></h4>\n";
}
?>
