<?php
// Login validation file for Harrys My Free Farm Bash Bot (front end)
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
?>
<html>
 <head>
  <title>Harrys MFF Bot - Anmeldungspr&uuml;fung</title>
 </head>
 <body bgcolor="#4E7AB1">
<?php
include 'functions.php';
print "<h1>Bitte warten...</h1>";
print ("<br>");
$username=$_POST["username"];
$password=$_POST["password"];
$server=$_POST["server"];
// logon and get farm data
system("script/logonandgetfarmdata.sh " . $username . " " . $password . " " . $server);
$JSONfarmdata = file_get_contents("/tmp/farmdata-" . $username . ".txt");
$JSONforestdata = file_get_contents("/tmp/forestdata-" . $username . ".txt");
$JSONfooddata = file_get_contents("/tmp/fooddata-" . $username . ".txt");

system("grep -q 'datablock' /tmp/fooddata-" . $username . ".txt", $retval);
if ( $retval == 0 ) {
//        header("Location: showfarm.php");
//        die();
	print "<form name=\"jump2farm\" method=\"post\" action='showfarm.php'>";
	print "<input type=\"hidden\" name=\"username\" value=\"" . $username . "\">";
	print "<input type=\"hidden\" name=\"farm\" value=\"1\">";
	print "</form>"; 
	print "<script type=\"text/javascript\">";
	print "document.jump2farm.submit();";
	print "</script>"; }
else
	print "Anmeldung fehlgeschlagen!";
?>
 </body>
</html>
