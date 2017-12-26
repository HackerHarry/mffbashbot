<?php
// Save misc stuff file for Harry's My Free Farm Bash Bot (front end)
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
$username = $_POST["username"];

include 'gamepath.php';
include 'functions.php';
include 'farmdata.php';
global $configContents;

// langugage, password and server-no. must be set manually in config.ini
$configContents['carefood'] = $_POST["carefood"];
$configContents['caretoy'] = $_POST["caretoy"];
$configContents['careplushy'] = $_POST["careplushy"];
$configContents['dodog'] = $_POST["dogtoggle"];
$configContents['dolot'] = $_POST["lottoggle"];
$configContents['vehiclemgmt5'] = $_POST["vehiclemgmt5"];
$configContents['vehiclemgmt6'] = $_POST["vehiclemgmt6"];
$configContents['dopuzzleparts'] = $_POST["puzzlepartstoggle"];
$configContents['sendfarmiesaway'] = $_POST["farmiestoggle"];
$configContents['sendforestryfarmiesaway'] = $_POST["forestryfarmiestoggle"];
$configContents['sendmunchiesaway'] = $_POST["munchiestoggle"];
$configContents['sendflowerfarmiesaway'] = $_POST["flowerfarmiestoggle"];
$configContents['correctqueuenum'] = $_POST["correctqueuenumtoggle"];
$configContents['useponyenergybar'] = $_POST["ponyenergybartoggle"];
$configContents['redeempuzzlepacks'] = $_POST["redeempuzzlepartstoggle"];
$configContents['dobutterflies'] = $_POST["butterflytoggle"];
$configContents['dodeliveryevent'] = $_POST["deliveryeventtoggle"];
$configContents['megafieldinstantplant'] = $_POST["megafieldplanttoggle"];
$configContents['doolympiaevent'] = $_POST["olympiaeventtoggle"];
$configContents['doseedbox'] = $_POST["redeemdailyseedboxtoggle"];

$filename = $gamepath . "/config.ini";
writeINI($configContents, $filename);
?>
