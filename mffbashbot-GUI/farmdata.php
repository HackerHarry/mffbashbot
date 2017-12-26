<?php
// Data file for Harry's My Free Farm Bash Bot (front end)
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
include_once 'lang.php';
$versionavailable=file_get_contents("/tmp/mffbot-version-available.txt");
$JSONfarmdata = file_get_contents("/tmp/farmdata-" . $username . ".txt");
if ($JSONfarmdata === false)
 header("Location: index.php");
$farmdata = (json_decode($JSONfarmdata, true));
$JSONproductlist = file_get_contents("data/" . $lang . "/productlist.txt");
$productlist = (json_decode($JSONproductlist, true));
$JSONforestryproductlist = file_get_contents("data/" . $lang . "/forestryproductlist.txt");
$forestryproductlist = (json_decode($JSONforestryproductlist, true));
$JSONfooddata = file_get_contents("/tmp/fooddata-" . $username . ".txt");
if ($JSONfooddata === false)
 header("Location: index.php");
$fooddata = (json_decode($JSONfooddata, true));
$JSONwindmillproductlist = file_get_contents("data/" . $lang . "/formulas.txt");
$windmillproductlist = (json_decode($JSONwindmillproductlist, true));
include_once 'data/' . $lang . '/monsterlist.php';
include_once 'data/' . $lang . '/foodworldproductlist.php';
include_once 'data/' . $lang . '/megafieldvehicleslist.php';
include_once 'data/' . $lang . '/hackdurations.php';
// might be redundant
$configContents = parse_ini_file($gamepath . "/config.ini");
?>
