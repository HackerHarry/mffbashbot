<?php
// Server-sent events file for My Free Farm Bash Bot (front end)
// Copyright 2016-24 Harry Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// For license see LICENSE file
//
if (!isset($username))
 strpos($_GET["username"], ' ') === false ? $username = $_GET["username"] : $username = rawurlencode($_GET["username"]);
include 'config.php';
include 'lang.php';

header("Content-Type: text/event-stream");
while (1) {
 echo "event: botstatus\n";
 if (file_exists($gamepath . "/../updateInProgress"))
  echo "data: <font color=\"yellow\">{$strings['botisupdating']}</font>\n\n";
 else
  if (file_exists($gamepath . "/isactive.txt"))
   echo "data: <font color=\"red\">{$strings['botisactive']}</font>\n\n";
  else
   echo "data: <font color=\"lime\">{$strings['botisidle']}</font>\n\n";

 echo "event: lastbotruntime\ndata: ";
 system("cat " . $gamepath . "/lastrun.txt");
 echo "\n\n";

 if (file_exists($gamepath . "/lasterror.txt")) {
  echo "event: lastboterror\ndata: <font color=\"yellow\">";
  system("cat " . $gamepath . "/lasterror.txt");
  echo "</font>\n\n";
 }
// else
//  echo "event: lastboterror\ndata: noerror\n\n";
// one-shot errors might escape the players attention. that's why this hasn't
// been implemented

 while (ob_get_level() > 0)
  ob_end_flush();
 flush();

 if (connection_aborted())
  break;

 sleep(10);
}
