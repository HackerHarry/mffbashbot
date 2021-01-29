<?php
// Data file for My Free Farm Bash Bot (front end)
// Copyright 2016-21 Harun "Harry" Basalamah
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
$versionavailable = file_get_contents("/tmp/mffbot-version-available.txt");
($JSON = file_get_contents("/tmp/farmdata-" . $username . ".txt")) ===  false ? header("Location: index.php") : $farmdata = (json_decode($JSON, true));
($JSON = file_get_contents("/tmp/products-" . $lang . ".txt")) ===  false ? header("Location: index.php") : $productlist = (json_decode($JSON, true));
($JSON = file_get_contents("/tmp/forestryproducts-" . $lang . ".txt")) ===  false ? header("Location: index.php") : $forestryproductlist = (json_decode($JSON, true));
($JSON = file_get_contents("/tmp/fooddata-" . $username . ".txt")) ===  false ? header("Location: index.php") : $fooddata = (json_decode($JSON, true));
($JSON = file_get_contents("/tmp/formulas-" . $lang . ".txt")) ===  false ? header("Location: index.php") : $windmillproductlist = (json_decode($JSON, true));
?>
