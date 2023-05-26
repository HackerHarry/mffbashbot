<?php
// Index file for My Free Farm Bash Bot (front end)
// Copyright 2016-23 Harun "Harry" Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// For license see LICENSE file
//
include 'functions.php';
?>
<!DOCTYPE html>
<html>
 <head>
  <title>My Free Farm Bash Bot - Log on</title>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
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
      return;
     parts = xhttp.responseText.split(";");
     if (parts[2])
      if (parts[2] == 0) {
       document.getElementById("logonstatus").innerHTML = parts[3] + parts[4];
       setTimeout(function(){ document.forms.jump2farm.submit(); }, 3000);
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
include 'config.php';
system('cd ' . $gamepath . ' ; for farm in $(ls -d */ | tr -d \'/\'); do echo -n "   farmno[\"$farm\"] = "; grep server $farm/config.ini | awk \'{ printf "%i", $3 }\'; echo ";"; done');
unset($username);
?>
   document.forms.logon.serverdummy.options[farmno[farmname]].selected = true;
   document.forms.logon.server.value = farmno[farmname];
   return true;
   }
  </script>
  <h1>My Free Farm Bash Bot</h1>
  <div class="form-group">
   <div class="offset-sm-5 col-sm-2">
    <a class="btn btn-outline-dark btn-sm" href="http://myfreefarm-berater.forumprofi.de/f15-Bash-Bot.html" role="button">Forum</a>
    <a class="btn btn-outline-dark btn-sm" href="addfarm.php" role="button">+ Farm</a>
    <a class="btn btn-outline-dark btn-sm" href="removefarm.php" role="button">- Farm</a>
<?php
if (file_exists("schmetterlings-rechner.html"))
 echo "    <a class=\"btn btn-outline-dark btn-sm\" href=\"schmetterlings-rechner.html\" role=\"button\">Schmetterlings-Rechner</a>";
if (file_exists("klubauftrag-mengenberechnung.html"))
 echo "    <a class=\"btn btn-outline-dark btn-sm\" href=\"klubauftrag-mengenberechnung.html\" role=\"button\">Klubauftrag Mengenberechnung</a>";
?>
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
include 'config.php';
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
