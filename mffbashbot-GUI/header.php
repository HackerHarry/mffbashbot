<?php
// Header file for My Free Farm Bash Bot (front end)
// Copyright 2016-24 Harry Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// For license see LICENSE file
//
echo "<!DOCTYPE html>
<html>
<head>
<title>My Free Farm Bash Bot - {$farmFriendlyName["$farm"]}</title>
<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">
<link href=\"https://fonts.googleapis.com/css?family=Open+Sans&display=swap\" rel=\"stylesheet\">
<link href=\"css/bootstrap.css\" rel=\"stylesheet\" type=\"text/css\">
<link href=\"css/mffbot.css\" rel=\"stylesheet\" type=\"text/css\">
</head>
<body id=\"main_body\" class=\"main_body\" onload=\"updateBotStatus()\">\n";

if (!isset($farm))
 $farm = 1;
if ($farm == "runbot") {
 exec("script/wakeupthebot.sh " . $gamepath);
 $farm = 1;
}
include 'JSfunctions.php';
$botver = file_get_contents($gamepath . "/../version.txt");
echo "<nav class=\"navbar btn-dark bg-dark fixed-top\">
$botver -- $username -- {$strings['lastbotiteration']}: <div id=\"lastruntime\" style=\"display:inline; font-weight: bold\">";
system("cat " . $gamepath . "/lastrun.txt");
echo "</div> -- {$strings['thebotis']} <div id=\"botstatus\" style=\"display:inline; font-weight: bold\">
</div>\n";
if (version_compare($botver, $versionavailable) == -1) {
 echo " -- 
 <div id=\"updatenotification\" style=\"display:inline; font-weight: bold\">{$strings['updateavailable']}
 <button id=\"updatebtn\" onclick=\"confirmUpdate()\">{$strings['updateto']} $versionavailable</button>
 <small> -- {$strings['historyishere']}</small></div>";
}
echo "</nav><br><br>\n";
// i know... this bottom bar shouldn't be in this file...
echo "<nav id=\"bottombar\" class=\"navbar btn-dark bg-dark fixed-bottom\" style=\"display: none\">
{$strings['lasterror']}: <div id=\"lasterror\" style=\"display: inline\"></div>
</nav>\n";
?>
