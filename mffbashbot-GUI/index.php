<?php
// Index file for Harrys My Free Farm Bash Bot (front end)
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
include 'functions.php';
?>
<html>
 <head>
  <title>Harrys MFF Bash Bot - Anmeldung</title>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link href="css/mffbot.css" rel="stylesheet" type="text/css">
 </head>
 <body id="main_body" class="main_body">
<h1>Konto w&auml;hlen...</h1>
<br><br>
<form name="logon" method="post" action="validate.php">
<br>Server&nbsp;
<select name="server"><option value="1">1</option><option value="2">2</option>
<option value="3">3</option><option value="4">4</option><option value="5">5</option>
<option value="6">6</option><option value="7">7</option><option value="8">8</option>
<option value="9">9</option><option value="10">10</option><option value="11">11</option>
<option value="12">12</option><option value="13">13</option><option value="14">14</option>
<option value="15">15</option><option value="16">16</option><option value="17">17</option>
<option value="18">18</option><option value="19">19</option><option value="20">20</option>
<option value="21">21</option><option value="22">22</option><option value="23">23</option>
<option value="24">24</option><option value="25">25</option></select><br>
Benutzername&nbsp;
<select name="username">
<?php
system("cd /home/pi/mffbashbot; ls -d */ | tr -d '/' | sed -e 's/^\\(.*\\)$/<option>\\1<\\/option>/'");
?>
</select><br>
Passwort
&nbsp;<input type="password" name="password"><br>
<input type="submit" value="GIB STOFF!">
</form>
</body>
</html>
