<?php
// Bot action file for My Free Farm Bash Bot (front end)
// Copyright 2016-23 Harun "Harry" Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// For license see LICENSE file
//
if (!isset($username))
 strpos($_POST["username"], ' ') === false ? $username = $_POST["username"] : $username = rawurlencode($_POST["username"]);
$action = $_POST["action"];
include 'config.php';
include 'lang.php';
// all that's left is the update trigger.
switch ($action) {
 case "triggerupdate":
  $username = "./";
  include 'config.php';
  $filename = $gamepath . "updateTrigger";
  touch($filename);
  // force bot iteration
  unset ($username);
  strpos($_POST["username"], ' ') === false ? $username = $_POST["username"] : $username = rawurlencode($_POST["username"]);
  $gamepath .= $username;
  exec("script/wakeupthebot.sh " . $gamepath);
 default:
  exit($strings['error']);
}
?>
