<?php
// This file is part of My Free Farm Bash Bot (front end)
// Copyright 2016-24 Harry Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// For license see LICENSE file
//
@ini_set('zlib.output_compression', 0);
@ini_set('implicit_flush', 1);
// for ($i = 0; $i < ob_get_level(); $i++)
while (ob_get_level() > 0)
 ob_end_flush();
ob_implicit_flush(true);
if (empty($_POST["username"])) {
 echo "1;<h4><font color=\"darkred\">Please select/enter a farm name</font></h4>\n";
 exit(1);
}
strpos($_POST["username"], ' ') === false ? $username = $_POST["username"] : $username = rawurlencode($_POST["username"]);
include 'functions.php';
include 'config.php';
include 'lang.php';
if (empty($_POST["server"])) {
 echo "1;<h4><font color=\"darkred\">{$strings['selectserver']}</font></h4>\n";
 exit(1);
}
$server = $_POST["server"];
if (empty($_POST["password"])) {
 echo "1;<h4><font color=\"darkred\">{$strings['enterpw']}</font></h4>\n";
 exit(1);
}
$password = $_POST["password"];
echo "1;<h4><font color=\"yellow\">{$strings['pleasewait']}</font></h4>;";
//ob_flush();
flush();
if (empty($_POST["language"]) && empty($_POST["action"])) {
 // this is a logon request
 system("script/logonandgetfarmdata.sh " . $username . " " . $password . " " . $server . " " . $lang, $retval);
 if ( $retval == 0 ) {
  echo "0;<h4><font color=\"lime\">{$strings['logonsuccess']}</font></h4>;";
//  ob_flush();
  flush();
  echo "<form name=\"jump2farm\" method=\"post\" action='showfarm.php'>
  <input type=\"hidden\" name=\"username\" value=\"$username\">
  <input type=\"hidden\" name=\"farm\" value=\"1\">
  <input type=\"hidden\" name=\"lang\" value=\"$lang\">
  </form>";
  exit(0);
 }
 else
  echo "1;<h4><font color=\"darkred\">{$strings['logonfailed']}</font></h4>\n";
  exit(1);
}

if (!empty($_POST["language"]) && empty($_POST["action"])) {
 // this is an "add farm" request
 $lang = $_POST["language"];
 include 'config.php';
 system("script/addfarm.sh " . $password . " " . $server . " " . $lang . " " . $gamepath, $retval);
 if ( $retval == 0 ) {
  echo "0;<h4><font color=\"lime\">{$strings['farmadded']}</font></h4>;";
//  ob_flush();
  flush();
  echo "<form name=\"jump2farm\" method=\"get\" action='index.php'>
  </form>";
 }
 else
  echo "1;<h4><font color=\"darkred\">{$strings['farmadditionfailed']}</font></h4>\n";
}
else {
 // this is a "remove farm" request
 if ($_POST["confirm"] !== "true") {
    echo "1;<h4><font color=\"darkred\">{$strings['checkconfirmbox']}</font></h4>\n";
    exit(1);
 }
 include 'config.php';
 system("script/removefarm.sh " . $username . " " . $password . " " . $server . " " . $gamepath, $retval);
 switch ($retval) {
 case 0:
        echo "0;<h4><font color=\"lime\">{$strings['farmremoved']}</font></h4>;";
//        ob_flush();
        flush();
        echo "<form name=\"jump2farm\" method=\"get\" action='index.php'>
        </form>";
        break;
 case 1:
        echo "1;<h4><font color=\"darkred\">{$strings['farmdeletionfailed']}</font></h4>\n";
//        ob_flush();
        flush();
        break;
 case 2:
        echo "1;<h4><font color=\"darkred\">{$strings['passwordmismatch']}</font></h4>\n";
//        ob_flush();
        flush();
        break;
 }
}
?>
