<?php
// Language file for My Free Farm Bash Bot (front end)
// Copyright 2016-23 Harun "Harry" Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// For license see LICENSE file
//
if (file_exists($gamepath . "/config.ini"))
 $configContents = parse_ini_file($gamepath . "/config.ini");
else
 if (empty($_POST["language"]))
  $configContents['lang'] = "";
 else
  $configContents['lang'] = $_POST["language"];
$translations_available = ['de', 'en', 'bg', 'pl'];
$lang = $configContents['lang'];
// fallback to german if lang is unsupported or missing
if (!in_array($lang, $translations_available))
 $lang = 'de';
include 'lang/lang.' . $lang . '.php';
?>
