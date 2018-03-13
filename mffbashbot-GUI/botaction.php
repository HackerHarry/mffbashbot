<?php
// Bot action file for Harry's My Free Farm Bash Bot (front end)
// Copyright 2016-18 Harun "Harry" Basalamah
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
if (!isset($username))
 $username = $_POST["username"];
$action =  $_POST["action"];
include_once 'gamepath.php';
include_once 'lang.php';

switch ($action) {
 case "getbotstatus":
  if (file_exists($gamepath . "/../updateInProgress"))
   print "<font color=\"yellow\">" . $strings['botisupdating'] . "</font>";
  else
   if (file_exists($gamepath . "/isactive.txt"))
    print "<font color=\"red\">" . $strings['botisactive'] . "</font>";
   else
    print "<font color=\"lime\">" . $strings['botisidle'] . "</font>";
   break;
 case "getlastruntime":
  system("cat " . $gamepath . "/lastrun.txt");
  break;
 case "triggerupdate":
  $username = "./";
  include 'gamepath.php';
  $filename = $gamepath . "updateTrigger";
  touch($filename);
  // force bot iteration
  unset ($username);
  $username = $_POST["username"];
  $gamepath .= $username;
  exec("script/wakeupthebot.sh " . $gamepath);
 default:
  exit($strings['error']);
}
?>
