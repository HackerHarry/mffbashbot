<?php
// Data file for Harrys My Free Farm Bash Bot (front end)
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
$JSONfarmdata = file_get_contents("/tmp/farmdata-" . $username . ".txt");
$farmdata = (json_decode($JSONfarmdata, true));
$JSONproductlist = file_get_contents("data/productlist.txt");
$productlist = (json_decode($JSONproductlist, true));
$JSONforestryproductlist = file_get_contents("data/forestryproductlist.txt");
$forestryproductlist = (json_decode($JSONforestryproductlist, true));
$oillist = [ 1 => "Mais&ouml;l", 2 => "Sonnenblumen&ouml;l", 3 => "Raps&ouml;l", 4 => "K&uuml;rbis&ouml;l", 5 => "Walnuss&ouml;l", 6 => "Oliven&ouml;l", 7 => "Knoblauch&ouml;l", 8 => "Chilli&ouml;l", 9 => "Basilikum&ouml;l", 10 => "Steinpilz&ouml;l" ];
$woollist = [ 1 => "Wollsocken", 2 => "Wollschal", 3 => "Wollm&uuml;tze" ];
$monsterlist = [ 1 => "Wassereimer", 2 => "Gießkanne", 3 => "Gartenschlauch", 4 => "Sprenkler", 5 => "Automatische Gießanlage", 6 => "Quellwasser", 7 => "Solar-Bew&auml;sserung", 10 => "Gl&uuml;hlampe", 11 => "Kronleuchter", 12 => "Halogenstrahler", 13 => "UV-Lampe", 14 => "Tageslichtlampe", 15 => "Biolampe", 16=> "LED Pflanzenlampe", 20 => "Einfacher D&uuml;nger", 21 => "Kraftd&uuml;nger", 22 => "Speziald&uuml;nger", 23 => "Wachstumsverst&auml;rker", 24 => "Extremd&uuml;nger", 25 => "Deluxed&uuml;nger", 26 => "Biod&uuml;nger" ];
$JSONfooddata = file_get_contents("/tmp/fooddata-" . $username . ".txt");
$fooddata = (json_decode($JSONfooddata, true));
$foodworldproductlist = [ 1 => "Karottensaft", 2 => "Tomatensaft", 3 => "Erdbeermilch", 4 => "Radieschenmilch", 5 => "Karottensaft mit Kräutern", 6 => "Tomatensaft mit Kräutern", 15 => "Himbeersaft", 16 => "Brombeermilch", 17 => "Apfelsaft", 7 => "Gegrillter Mais", 8 => "Knüppelbrot", 9 => "Spinatknüppelbrot", 10 => "Gurkensalat", 11 => "Tomatensalat", 12 => "Pommes mit Ketchup", 13 => "Pommes mit Mayo", 14 => "Pommes rot/weiß", 18 => "Zucchinigratin", 19 => "Italienischer Salat", 20 => "Kürbissuppe", 21 => "Karottenkuchen", 22 => "Erdbeerkuchen", 23 => "Zwiebelkuchen", 24 => "Butterhörnchen", 25 => "Bienenstich", 26 => "Käsekuchen", 27 => "Kirschtorte", 28 => "Walnusssahnerolle", 29 => "Kräuterkuchen", 30 => "Olivenbrot",31 => "Erdbeereis", 32 => "Himbeereis", 33 => "Johannisbeer-Sorbet", 34 => "Brombeereis", 35 => "Mirabelleneis", 36 => "Apfel-Sorbet", 37 => "Kirscheis", 38 => "Ananas-Sorbet", 39 => "Bananeneis", 40 => "Drachenfruchteis", 41 => "Kokosnusseis", 42 => "Kumquateis", 43 => "Limetten-Sorbet", 44 => "Litschieis", 45 => "Mangoeis", 46 => "Maracuja-Sorbet", 47 => "Papayaeis", 48 => "Sternfruchteis", 49 => "Bananenmilch", 50 => "Grüner Smoothie", 51 => "Exotischer Shake", 52 => "Pina Colada", 53 => "Kokos-Milchshake", 54 => "Zitrus-Drink", 55 => "Löwenzahnsalat", 56 => "Kohlauflauf", 57 => "Pilzsuppe", 58 => "Hawaii-Toast", 59 => "Birnen-Auflauf", 60 => "Zwetschgenkuchen", 61 => "Limettentorte", 62 => "Mango-Maracuja-Torte", 63 => "Bananenkuchen", 64 => "Rhabarberkuchen" ];
$megafieldvehicleslist = [ 1 => "Ernte-Fuhrwerk", 2 => "Ernte-Gespann", 3 => "Mechanische Erntemaschine", 4 => "Dampfbetriebene Erntemaschine", 5 => "Fl&uuml;gelerntemaschine", 6 => "Traktor", 7 => "Automatische Erntemaschine", 8 => "Pr&auml;zisions-Erntemaschine", 9 => "Computer&uuml;berwachte Erntemaschine", 10 => "Ernt-O-Mat-2000" ];
$JSONwindmillproductlist = file_get_contents("data/formulas.txt");
$windmillproductlist = (json_decode($JSONwindmillproductlist, true));
?>
