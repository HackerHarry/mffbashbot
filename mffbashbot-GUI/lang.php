<?php
// Language file for Harry's My Free Farm Bash Bot (front end)
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
$configContents = parse_ini_file($gamepath . "/config.ini");
$translations_available = ['de', 'en', 'bg'];
$lang=$configContents['lang'];
// fallback to german if lang is unsupported or missing
if (!in_array($lang, $translations_available))
 $lang='de';
include_once 'lang/lang.' . $lang . '.php';
?>
