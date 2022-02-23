<?php
// Data file for My Free Farm Bash Bot (front end)
// Copyright 2016-22 Harun "Harry" Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// For license see LICENSE file
//
$versionavailable = file_get_contents("/tmp/mffbot-version-available.txt");
($JSON = file_get_contents("/tmp/farmdata-" . $username . ".txt")) ===  false ? header("Location: index.php") : $farmdata = (json_decode($JSON, true));
($JSON = file_get_contents("/tmp/products-" . $lang . ".txt")) ===  false ? header("Location: index.php") : $productlist = (json_decode($JSON, true));
($JSON = file_get_contents("/tmp/forestryproducts-" . $lang . ".txt")) ===  false ? header("Location: index.php") : $forestryproductlist = (json_decode($JSON, true));
($JSON = file_get_contents("/tmp/fooddata-" . $username . ".txt")) ===  false ? header("Location: index.php") : $fooddata = (json_decode($JSON, true));
($JSON = file_get_contents("/tmp/formulas-" . $lang . ".txt")) ===  false ? header("Location: index.php") : $windmillproductlist = (json_decode($JSON, true));
?>
