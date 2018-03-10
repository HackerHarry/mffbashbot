<?php
// Index file for Harry's My Free Farm Bash Bot (front end)
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
include 'functions.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
  <title>Harry's MFF Bash Bot - Log on</title>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link href="css/bootstrap.css" rel="stylesheet" type="text/css">
  <link href="css/mffbot.css" rel="stylesheet" type="text/css">
 </head>
 <body id="main_body" class="main_body text-center">
  <script type="text/javascript">
   function validateLogon() {
    var sUser = document.forms.logon.username.value;
    var sPass = document.forms.logon.password.value;
    var iServer = document.forms.logon.server.value;
    var sData = "username=" + sUser + "&server=" + iServer + "&password=" + sPass;
    xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
     if (xhttp.readyState != null && (xhttp.readyState < 3 || xhttp.status != 200))
      return
     parts = xhttp.responseText.split(";");
     if (parts[2])
      if (parts[2] == 0) {
       document.getElementById("logonstatus").innerHTML = parts[3] + parts[4];
       document.forms.jump2farm.submit();
       return;
      }
      else if (parts[2] == 1) {
       document.getElementById("logonstatus").innerHTML = parts[3];
       return;
      }
     if (parts[0] == 1)
      document.getElementById("logonstatus").innerHTML = parts[1];
    }
    xhttp.open("POST", "validate.php", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send(sData);
    return false;
   }

   function setFarmNo(farmname) {
   var farmno = [];
<?php
$username = "./";
include 'gamepath.php';
system('cd ' . $gamepath . ' ; for farm in $(ls -d */ | tr -d \'/\'); do echo -n "   farmno[\"$farm\"] = "; grep server $farm/config.ini | awk \'{ printf "%i", $3 }\'; echo ";"; done');
unset($username);
?>
   document.forms.logon.serverdummy.options[farmno[farmname]].selected = true;
   document.forms.logon.server.value = farmno[farmname];
   return true;
   }
  </script>
  <h1>Harry's My Free Farm Bash Bot</h1>
  <div class="form-group">
   <div class="offset-sm-5 col-sm-2">
    <a class="btn btn-outline-dark btn-sm" href="http://myfreefarm-berater.forumprofi.de/forumdisplay.php?fid=15" role="button">Forum</a>
   </div>
  </div>
  <div id="logonstatus"><br></div>
  <form name="logon" method="post" action="">
   <div class="form-group">
    <div class="offset-sm-5 col-sm-2">
     <select name="serverdummy" class="form-control" disabled><option value="0">Server</option><option value="1">1</option><option value="2">2</option>
     <option value="3">3</option><option value="4">4</option><option value="5">5</option>
     <option value="6">6</option><option value="7">7</option><option value="8">8</option>
     <option value="9">9</option><option value="10">10</option><option value="11">11</option>
     <option value="12">12</option><option value="13">13</option><option value="14">14</option>
     <option value="15">15</option><option value="16">16</option><option value="17">17</option>
     <option value="18">18</option><option value="19">19</option><option value="20">20</option>
     <option value="21">21</option><option value="22">22</option><option value="23">23</option>
     <option value="24">24</option><option value="25">25</option></select>
    </div>
   </div>
   <input type="hidden" name="server" value="0">
   <div class="form-group">
    <div class="offset-sm-5 col-sm-2">
     <select name="username" class="form-control" onchange="return setFarmNo(document.forms.logon.username.options[document.forms.logon.username.options.selectedIndex].value);">
     <option value="0" selected>Farm</option>
<?php
$username = "./";
include 'gamepath.php';
system("cd " . $gamepath . " ; ls -d */ | tr -d '/' | sed -e 's/^\\(.*\\)$/     <option>\\1<\\/option>/'");
unset($username);
?>
     </select>
    </div>
   </div>
   <div class="form-group">
    <div class="offset-sm-5 col-sm-2">
     <input class="form-control" type="password" name="password" placeholder="Password">
    </div>
   </div>
   <button type="submit" class="btn btn-lg btn-danger" value="submit" onclick="return validateLogon();">Start !</button>
  </form>
 </body>
</html>
