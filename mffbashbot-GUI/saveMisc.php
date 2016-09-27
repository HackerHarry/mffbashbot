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
include 'gamepath.php';

// Dog
if ($dogtoggle == "on") {
 touch($gamepath . "/dodog.txt");
 chgrp($gamepath . "/dodog.txt", "pi");
 chmod($gamepath . "/dodog.txt", 0664);
}
else
 unlink($gamepath . "/dodog.txt");

// Lottery
if ($lottoggle == "on") {
 touch($gamepath . "/dolot.txt");
 chgrp($gamepath . "/dolot.txt", "pi");
 chmod($gamepath . "/dolot.txt", 0664);
}
else
 unlink($gamepath . "/dolot.txt");

if ($vehiclemgmt != "sleep") {
 file_put_contents($gamepath . "/vehiclemgmt.txt", $vehiclemgmt . "\n");
 chgrp($gamepath . "/vehiclemgmt.txt", "pi");
 chmod($gamepath . "/vehiclemgmt.txt", 0664);
}
else
  unlink($gamepath . "/vehiclemgmt.txt");
?>
