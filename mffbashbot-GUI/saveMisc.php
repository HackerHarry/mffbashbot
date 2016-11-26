<?php
// Save misc stuff file for Harrys My Free Farm Bash Bot (front end)
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
$username = $_POST["username"];
$dogtoggle = $_POST["dogtoggle"];
$lottoggle = $_POST["lottoggle"];
$vehiclemgmt = $_POST["vehiclemgmt"];
$carefood = $_POST["carefood"];
$caretoy = $_POST["caretoy"];
$careplushy = $_POST["careplushy"];
$puzzlepartstoggle = $_POST["puzzlepartstoggle"];
$farmiestoggle = $_POST["farmiestoggle"];
$forestryfarmiestoggle = $_POST["forestryfarmiestoggle"];
$munchiestoggle = $_POST["munchiestoggle"];

include 'gamepath.php';
include 'functions.php';
include 'farmdata.php';
global $configContents;

// langugage, password and server-no. must be set manually in config.ini
$configContents['carefood'] = $carefood;
$configContents['caretoy'] = $caretoy;
$configContents['careplushy'] = $careplushy;
$configContents['dodog'] = $dogtoggle;
$configContents['dolot'] = $lottoggle;
$configContents['vehiclemgmt'] = $vehiclemgmt;
$configContents['dopuzzleparts'] = $puzzlepartstoggle;
$configContents['sendfarmiesaway'] = $farmiestoggle;
$configContents['sendforestryfarmiesaway'] = $forestryfarmiestoggle;
$configContents['sendmunchiesaway'] = $munchiestoggle;

$filename = $gamepath . "/config.ini";
writeINI($configContents, $filename);
?>
