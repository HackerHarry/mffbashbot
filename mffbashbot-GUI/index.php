<?php
// Index file for Harry's My Free Farm Bash Bot (front end)
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
include 'functions.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
  <title>Harrys MFF Bash Bot - Log on</title>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link href="css/mffbot.css" rel="stylesheet" type="text/css">
 </head>
 <body id="main_body" class="main_body">
<h1>Log on...</h1>
<small>Remember to set your user data in config.ini</small>
<br><br>
<form name="logon" method="post" action="validate.php">
<table id="logontbl" style="float:left; margin-right:20px;" border="1">
<tr><td align="left">Server</td>
<td align="left">
<select name="server"><option value="1">1</option><option value="2">2</option>
<option value="3">3</option><option value="4">4</option><option value="5">5</option>
<option value="6">6</option><option value="7">7</option><option value="8">8</option>
<option value="9">9</option><option value="10">10</option><option value="11">11</option>
<option value="12">12</option><option value="13">13</option><option value="14">14</option>
<option value="15">15</option><option value="16">16</option><option value="17">17</option>
<option value="18">18</option><option value="19">19</option><option value="20">20</option>
<option value="21">21</option><option value="22">22</option><option value="23">23</option>
<option value="24">24</option><option value="25">25</option></select>
</td></tr>
<tr><td align="left">
User name
</td><td align="left">
<select name="username">
<?php
$username = "./";
include 'gamepath.php';
system("cd " . $gamepath . " ; ls -d */ | tr -d '/' | sed -e 's/^\\(.*\\)$/<option>\\1<\\/option>/'");
unset($username);
?>
</select>
</td></tr>
<tr><td align="left">
Password
</td><td align="left">
<input type="password" name="password">
</td></tr>
<tr><td colspan="2" align="center">
<input type="submit" value="GO!">
</td></tr>
</table>
</form>
</body>
</html>
