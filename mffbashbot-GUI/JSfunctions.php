<?php
// Dynamic JavaScript for Harrys My Free Farm Bash Bot (front end)
// Copyright 2016-17 Harun "Harry" Basalamah
// some parts shamelessly stolen and adapted from
// http://www.mredkj.com/tutorials/tutorial005.html
// quoting Keith Jenci: "Code marked as public domain is without copyright, and can be used without restriction."
// and
// https://developer.mozilla.org/en/docs/Web/API/notification
// quoting MDM: "Code samples added on or after August 20, 2010 are in the public domain. No licensing notice is necessary, but if you need one, you can [...]"
// :)
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

echo <<<EOT
<script type="text/javascript">

function sanityCheck(elSel, elSelDest, amountpos) {
 if (elSel.options[elSel.selectedIndex].value == "sleep" && amountpos > 0) {
  alert("{$strings['nonsense']}");
  return false;
 }
 if (elSel.options[elSel.selectedIndex].value != "sleep" && amountpos < 1) {
  alert("{$strings['missingamount']}");
  return false;
 }
 if (elSel.id == "itemposmonsterfruit") {
  if (elSel.selectedIndex >= 1 && elSel.selectedIndex <= 7 && !(elSelDest.id == "qselmonsterfruit3")) {
   alert("{$strings['wrongqueue']}");
   return false;
  }
  if (elSel.selectedIndex >= 8 && elSel.selectedIndex <= 14 && !(elSelDest.id == "qselmonsterfruit2")) {
   alert("{$strings['wrongqueue']}");
   return false;
  }
  if (elSel.selectedIndex >= 15 && !(elSelDest.id == "qselmonsterfruit1")) {
   alert("{$strings['wrongqueue']}");
   return false;
  }
 }
 return true;
}

function insertOptionBefore(elSel, elSelDest, amountpos)
{
 if (!sanityCheck(elSel, elSelDest, amountpos))
  return false;
 if (elSel.selectedIndex >= 0) {
  var elOptNew = document.createElement('option');
  if (amountpos > 0) {
   elOptNew.text = amountpos + " " + elSel.options[elSel.selectedIndex].text;
   elOptNew.value = elSel.options[elSel.selectedIndex].value + "," + amountpos;
  } else {
   elOptNew.text = elSel.options[elSel.selectedIndex].text;
   elOptNew.value = elSel.options[elSel.selectedIndex].value;
  }
  var elOptOld = elSelDest.options[elSelDest.selectedIndex];
  try {
   elSelDest.add(elOptNew, elOptOld); // standards compliant; doesn't work in IE
  }
  catch(ex) {
   elSelDest.add(elOptNew, elSel.selectedIndex); // IE only
  }
 }
}

function appendOptionLast(elSel, elSelDest, amountpos)
{
 if (!sanityCheck(elSel, elSelDest, amountpos))
  return false;
 var elOptNew = document.createElement('option');
 if (amountpos > 0) {
  elOptNew.text = amountpos + " " + elSel.options[elSel.selectedIndex].text;
  elOptNew.value = elSel.options[elSel.selectedIndex].value + "," + amountpos;
 } else {
  elOptNew.text = elSel.options[elSel.selectedIndex].text;
  elOptNew.value = elSel.options[elSel.selectedIndex].value;
 }
 try {
  elSelDest.add(elOptNew, null); // standards compliant; doesn't work in IE
 }
 catch(ex) {
  elSelDest.add(elOptNew); // IE only
 }
}

function removeOptionSelected(elSelDest)
{
 for (var i = elSelDest.length - 1; i>=0; i--) {
  if (elSelDest.options[i].selected) {
   elSelDest.remove(i);
  }
 }
}

function updateBotStatus() {
 var sUser = document.venueselect.username.value;
 var sData = "username=" + sUser;
 xhttp = new XMLHttpRequest();
 xhttp.onreadystatechange = function() {
  if (xhttp.readyState == 4 && xhttp.status == 200)
   document.getElementById("botstatus").innerHTML = xhttp.responseText;
 }
 xhttp.open("POST", "getbotstatus.php", true);
 xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
 xhttp.send(sData);
 
 xhttp2 = new XMLHttpRequest();
 xhttp2.onreadystatechange = function() {
  if (xhttp2.readyState == 4 && xhttp.status == 200)
   document.getElementById("lastruntime").innerHTML = xhttp2.responseText;
 }
 xhttp2.open("POST", "getlastruntime.php", true);
 xhttp2.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
 xhttp2.send(sData);
 
 window.setTimeout(updateBotStatus, 30000);
}

function saveMisc() {
 var sUser = document.venueselect.username.value;
 var sData = "username=" + sUser + "&dogtoggle=";
 document.getElementById('dogtoggle').checked ? sData += "1&lottoggle=" : sData += "0&lottoggle=";

 var v = document.getElementById("lottoggle");
 sData += v.options[v.selectedIndex].value + "&vehiclemgmt5=";
 
 var v = document.getElementById("vehiclemgmt5");
 sData += v.options[v.selectedIndex].value + "&vehiclemgmt6=";
 
 var v = document.getElementById("vehiclemgmt6");
 sData += v.options[v.selectedIndex].value + "&carefood=";

 var v = document.getElementById("carefood");
 sData += v.options[v.selectedIndex].value + "&caretoy=";

 var v = document.getElementById("caretoy");
 sData += v.options[v.selectedIndex].value + "&careplushy=";

 var v = document.getElementById("careplushy");
 sData += v.options[v.selectedIndex].value + "&puzzlepartstoggle=";

 document.getElementById('puzzlepartstoggle').checked ? sData += "1&farmiestoggle=" : sData += "0&farmiestoggle=";
 document.getElementById('farmiestoggle').checked ? sData += "1&forestryfarmiestoggle=" : sData += "0&forestryfarmiestoggle=";
 document.getElementById('forestryfarmiestoggle').checked ? sData += "1&munchiestoggle=" : sData += "0&munchiestoggle=";
 document.getElementById('munchiestoggle').checked ? sData += "1&flowerfarmiestoggle=" : sData += "0&flowerfarmiestoggle=";
 document.getElementById('flowerfarmiestoggle').checked ? sData += "1&correctqueuenumtoggle=" : sData += "0&correctqueuenumtoggle=";
 document.getElementById('correctqueuenumtoggle').checked ? sData += "1&ponyenergybartoggle=" : sData += "0&ponyenergybartoggle=";
 document.getElementById('ponyenergybartoggle').checked ? sData += "1&redeempuzzlepartstoggle=" : sData += "0&redeempuzzlepartstoggle=";
 document.getElementById('redeempuzzlepartstoggle').checked ? sData += "1&butterflytoggle=" : sData += "0&butterflytoggle=";
 document.getElementById('butterflytoggle').checked ? sData += "1&deliveryeventtoggle=" : sData += "0&deliveryeventtoggle=";
 document.getElementById('deliveryeventtoggle').checked ? sData += "1&megafieldplanttoggle=" : sData += "0&megafieldplanttoggle=";
 document.getElementById('megafieldplanttoggle').checked ? sData += "1" : sData += "0";

 xhttp = new XMLHttpRequest();
 xhttp.open("POST", "saveMisc.php", false);
 xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
 xhttp.send(sData);

 displaySavedNote();
 return false;
}

function saveConfig() {

var sUser = document.venueselect.username.value;
var sFarm = document.venueselect.farm.value;
var sData = "username=" + sUser + "&farm=" + sFarm + "&queueContent=";

switch (sFarm) {
  case "forestry":
  case "farmersmarket":
  case "foodworld":
  case "city2":
  if (sFarm == "farmersmarket")
    var fmpos = ["flowerarea", "nursery", "monsterfruit", "pets", "vet"];
  if (sFarm == "forestry")
    var fmpos = ["sawmill", "carpentry", "forestry"];
  if (sFarm == "foodworld")
    var fmpos = ["sodastall", "snackbooth", "pastryshop", "icecreamparlour"];
  if (sFarm == "city2")
    var fmpos = ["windmill", "trans25", "trans26"];

for (k = 0; k <= (fmpos.length - 1); k++) {
// old (fmpos.length > 3 ? 3 : 2)
 var i = fmpos[k];
 sData += document.getElementById("queue" + i)[0].value + " "; // queue file name
 sData += document.getElementById("queue" + i)[1].value + " "; // building type
 for (j = 0; j < document.getElementById("queue" + i)[2].options.length; j++)
  sData += document.getElementById("queue" + i)[2][j].value + " "; // fill with queue items
 if (document.getElementById("queue" + i)[3] !== undefined) { // do we have a second queue?
  sData = sData.substring(0, sData.length - 1);
  sData += "-"; // mark the 2nd queue
  sData += document.getElementById("queue" + i)[3].value + " ";
  sData += document.getElementById("queue" + i)[4].value + " ";
  for (j = 0; j < document.getElementById("queue" + i)[5].options.length; j++)
   sData += document.getElementById("queue" + i)[5][j].value + " ";
 }
 if (document.getElementById("queue" + i)[6] !== undefined) { // do we have a third queue?
  sData = sData.substring(0, sData.length - 1);
  sData += "-"; // mark the 3rd queue
  sData += document.getElementById("queue" + i)[6].value + " ";
  sData += document.getElementById("queue" + i)[7].value + " ";
  for (j = 0; j < document.getElementById("queue" + i)[8].options.length; j++)
   sData += document.getElementById("queue" + i)[8][j].value + " ";
 }
 sData = sData.substring(0, sData.length - 1);
 sData += "#"; // exchange last space
}
  break;

default:
for (i = 1; i <= 6; i++) {
 sData += document.getElementById("queue" + i)[0].value + " "; // queue file name
 sData += document.getElementById("queue" + i)[1].value + " "; // building type
 for (j = 0; j < document.getElementById("queue" + i)[2].options.length; j++)
  sData += document.getElementById("queue" + i)[2][j].value + " "; // fill with queue items
 if (document.getElementById("queue" + i)[3] !== undefined) { // do we have a second queue?
  sData = sData.substring(0, sData.length - 1);
  sData += "-"; // mark the 2nd queue
  sData += document.getElementById("queue" + i)[3].value + " ";
  sData += document.getElementById("queue" + i)[4].value + " ";
  for (j = 0; j < document.getElementById("queue" + i)[5].options.length; j++)
   sData += document.getElementById("queue" + i)[5][j].value + " ";
 }
 if (document.getElementById("queue" + i)[6] !== undefined) { // do we have a third queue?
  sData = sData.substring(0, sData.length - 1);
  sData += "-"; // mark the 3rd queue
  sData += document.getElementById("queue" + i)[6].value + " ";
  sData += document.getElementById("queue" + i)[7].value + " ";
  for (j = 0; j < document.getElementById("queue" + i)[8].options.length; j++)
   sData += document.getElementById("queue" + i)[8][j].value + " ";
 }
 sData = sData.substring(0, sData.length - 1);
 sData += "#"; // exchange last space
 }
}
// strip lasat char
sData = sData.substring(0, sData.length - 1);
// save data via AJAX
xhttp = new XMLHttpRequest();
xhttp.open("POST", "save.php", false);
xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
xhttp.send(sData);
// display notification
displaySavedNote();
return false;
}

function displaySavedNote() {
 var options = {icon: 'image/mffbot.png'}
 if (!("Notification" in window))
  alert("{$strings['saved']}");
 else if (Notification.permission === "granted")
  var notification = new Notification("{$strings['saved']}", options);
 else if (Notification.permission !== 'denied') {
  Notification.requestPermission(function (permission) {
 if (permission === "granted")
  var notification = new Notification("{$strings['saved']}", options);
  });
 }
}

function showHideOptions() {
 var div = document.getElementById("optionspane");
 if (div.style.display !== "none") {
  div.style.display = "none";
  return false;
  }
 else {
  div.style.display = "inline-block";
  return false
  }
}

function confirmUpdate() {
 var cu = confirm("{$strings['confirmupdate']}");
 if (cu == true) {
  var sData = "username=" + document.venueselect.username.value;
  xhttp = new XMLHttpRequest();
  xhttp.open("POST", "triggerUpdate.php", true);
  xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  xhttp.send(sData);
  window.setTimeout(showCountdown, 250, 15);
  return false;
  }
 else
  return false;
}

function showCountdown(counter) {
 if (counter <= 0)
  window.location.href="/mffbashbot";
 else {
  document.getElementById("updatenotification").innerHTML = "Countdown: " + counter + " ";
  window.setTimeout(showCountdown, 1000, --counter);
 }
}
</script>

EOT;
?>
