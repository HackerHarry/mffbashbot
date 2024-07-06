<?php
// Data file for My Free Farm Bash Bot (front end)
// Copyright 2016-24 Harry Basalamah
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

// monster fruit
$megafruitObjects = array("water", "light", "fertilize");
$monsterlist = array();
if (isset($farmdata["updateblock"]["farmersmarket"]["megafruit"]["objects"])) {
    for ($objIndex = 0; $objIndex < 3; $objIndex++) {
        $arr = $farmdata["updateblock"]["farmersmarket"]["megafruit"]["objects"][$megafruitObjects[$objIndex]];
        for ($count = 0; $count < count($arr); $count++)
            $monsterlist[$arr[$count]["oid"]] = $arr[$count]["name"];
        }
}

// foodworld
$foodworldproductlist = array();
if (isset($fooddata["datablock"]["products"])) {
    $arr = $fooddata["datablock"]["products"];
    while (current($arr)) {
        $i = key($arr);
        $arr2 = $arr[$i]["out"];
        current($arr2);
        $objIndex = key($arr2);
        $foodworldproductlist[$i] = $productlist[$objIndex];
        next($arr);
    }
}

// megafield vehicles
$megafieldvehicleslist = array();
if (isset($farmdata["updateblock"]["megafield"]["vehicle_slots"])) {
    $arr = $farmdata["updateblock"]["megafield"]["vehicle_slots"];
    while (current($arr)) {
        $i = key($arr);
        $megafieldvehicleslist[$i] = $arr[$i]["name"];
        next($arr);
    }
}
?>
