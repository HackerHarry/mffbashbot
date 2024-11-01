<?php
// Dynamic JavaScript for My Free Farm Bash Bot (front end)
// Copyright 2016-24 Harry Basalamah
// some parts shamelessly stolen and adapted from
// http://www.mredkj.com/tutorials/tutorial005.html
// quoting Keith Jenci: "Code marked as public domain is without copyright, and can be used without restriction."
// and
// https://developer.mozilla.org/en/docs/Web/API/notification
// quoting MDM: "Code samples added on or after August 20, 2010 are in the public domain. No licensing notice is necessary, but if you need one, you can [...]"
// :)
//
// For license see LICENSE file
//

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
  if (elSel.selectedIndex >= 1 && elSel.selectedIndex <= 12 && !(elSelDest.id == "qselmonsterfruit3")) {
   alert("{$strings['wrongqueue']}");
   return false;
  }
  if (elSel.selectedIndex >= 13 && elSel.selectedIndex <= 24 && !(elSelDest.id == "qselmonsterfruit2")) {
   alert("{$strings['wrongqueue']}");
   return false;
  }
  if (elSel.selectedIndex >= 25 && !(elSelDest.id == "qselmonsterfruit1")) {
   alert("{$strings['wrongqueue']}");
   return false;
  }
 }
 return true;
}

function multiplierIsValid(multiplier) {
 if (multiplier >= 1 && multiplier <= 99)
  return true;
 else
  return false;
}

function insertOptionBefore(elSel, elSelDest, amountpos) {
 if (!sanityCheck(elSel, elSelDest, amountpos))
  return false;
 elSelDest.style.minWidth = null;
 var multiplier = document.getElementById("multi").value;
 if (!multiplierIsValid(multiplier))
  multiplier = 1;
 for (var i = 0; i < multiplier; i++) {
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
 document.getElementById("multi").value = 1;
 return false;
}

function appendOptionLast(elSel, elSelDest, amountpos) {
 if (!sanityCheck(elSel, elSelDest, amountpos))
  return false;
 elSelDest.style.minWidth = null;
 var multiplier = document.getElementById("multi").value;
 if (!multiplierIsValid(multiplier))
  multiplier = 1;
 for (var i = 0; i < multiplier; i++) {
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
 document.getElementById("multi").value = 1;
 return false;
}

function removeOptionSelected(elSelDest) {
 for (var i = elSelDest.length - 1; i>=0; i--) {
  if (elSelDest.options[i].selected) {
   elSelDest.remove(i);
  }
 }
 return false;
}

function removeOptionAll(elSelDest) {
 var currentWidth = elSelDest.offsetWidth;
 elSelDest.style.minWidth = currentWidth + "px";
 for (var i = elSelDest.length - 1; i >= 0; i--)
  elSelDest.remove(0);
 return false;
}

function updateBotStatus() {
 var sUser = document.venueselect.username.value;
 var eSource = new EventSource('botSSE.php?username=' + sUser);
 eSource.onerror = function() {
  document.getElementById("botstatus").innerHTML = "[{$strings['pleasewait']}]";
 };
 eSource.addEventListener("botstatus", function(e) {
  document.getElementById("botstatus").innerHTML = e.data;
 }, false);
 eSource.addEventListener("lastbotruntime", function(e) {
  document.getElementById("lastruntime").innerHTML = e.data;
 }, false);
 eSource.addEventListener("lastboterror", function(e) {
//  if (e.data === "noerror") {
//   document.getElementById("bottombar").style.display = "none";
//   return;
//  }
  document.getElementById("lasterror").innerHTML = e.data;
  document.getElementById("bottombar").style.display = "block";
 }, false);
}

function saveMisc() {
 var i, j, v;
 var aOptions = ['lottoggle', 'loginbonus', 'vehiclemgmt5', 'vehiclemgmt6',
 'vehiclemgmt7', 'vehiclemgmt8', 'vehiclemgmt9', 'vehiclemgmt10', 'transO5', 'transO6', 'transO7',
 'transO8', 'transO9', 'transO10', 'vetjobdifficulty', 'carefood', 'caretoy', 'careplushy',
 'autobuyrefillto', 'weathermitigation', 'summercut', 'wintercut', 'vinedefoliation',
 'vinefertiliser', 'vinewater', 'sushibarsoup', 'sushibarsalad', 'sushibarsushi',
 'sushibardessert', 'scoutfood', 'ovenslot1', 'ovenslot2', 'ovenslot3'];
 var aToggles = ['puzzlepartstoggle', 'farmiestoggle', 'forestryfarmiestoggle',
 'munchiestoggle', 'flowerfarmiestoggle', 'correctqueuenumtoggle',
 'ponyenergybartoggle', 'redeempuzzlepartstoggle', 'butterflytoggle',
 'deliveryeventtoggle', 'olympiaeventtoggle', 'infinitequesttoggle',
 'cowracepvptoggle', 'redeemdailyseedboxtoggle', 'dogtoggle', 'donkeytoggle',
 'cowracetoggle', 'foodcontesttoggle', 'excluderank1cowtoggle',
 'calendareventtoggle', 'pentecosteventtoggle', 'trimlogstocktoggle', 'removeweedtoggle',
 'harvestvinetoggle', 'harvestvineinautumntoggle', 'restartvinetoggle', 'removevinetoggle',
 'buyvinetillsunnytoggle', 'vinefullservicetoggle', 'doinsecthoteltoggle', 'doeventgardentoggle',
 'greenhousetoggle'];
 var sUser = document.venueselect.username.value;
 var sData = "username=" + sUser + "&farm=savemisc";
// abusing farm parameter :)
 for (i = 0; i < aOptions.length; i++) {
  if (document.getElementById(aOptions[i]) !== null) {
   v = document.getElementById(aOptions[i]);
   sData += "&" + aOptions[i] + "=" + v.options[v.selectedIndex].value;
  } else {
   sData += "&" + aOptions[i] + "=0";
  }
 }
 for (i = 0; i < aToggles.length; i++) {
  document.getElementById(aToggles[i]).checked ? sData += "&" + aToggles[i] + "=1" : sData += "&" + aToggles[i] + "=0";
 }
 for (i = 1; i <= 17; i++) {
  v = document.getElementById("flowerarrangementslot" + i);
  sData += "&flowerarrangementslot" + i + "=" + v.options[v.selectedIndex].value;
 }
 for (i = 1; i <= 15; i++) {
  v = document.getElementById("racecowslot" + i);
  sData += "&racecowslot" + i + "=" + v.options[v.selectedIndex].value;
 }
 for (i = 1; i <= 4; i++) {
  v = document.getElementById("fruitstallslot" + i);
  sData += "&fruitstallslot" + i + "=" + v.options[v.selectedIndex].value;
  if (i == 4)
   break;
  v = document.getElementById("fruitstall2slot" + i);
  sData += "&fruitstall2slot" + i + "=" + v.options[v.selectedIndex].value;
 }
 var aFishingstuff = ['speciesbait', 'raritybait', 'fishinggear', 'preferredbait'];
 for (i = 1; i <= 3; i++) {
  for (j = 0; j < aFishingstuff.length; j++) {
   if (document.getElementById(aFishingstuff[j] + i) !== null) {
    v = document.getElementById(aFishingstuff[j] + i);
    sData += "&" + aFishingstuff[j] + i + "=" + v.options[v.selectedIndex].value;
   } else {
    sData += "&" + aFishingstuff[j] + i + "=0";
   }
  }
 }
 j = (document.querySelectorAll("[id*=autobuyitem]")).length;
 sData += "&autobuyitems=";
 for (i = 0; i < j; i++) {
  if (document.querySelectorAll("[id*=autobuyitem]")[i].checked)
   sData += (document.querySelectorAll("[id*=autobuyitem]"))[i].value + ",";
 }
 if (sData.substring(sData.length-1, sData.length) == ",")
  sData = sData.substring(0, sData.length - 1);
 j = (document.querySelectorAll("[id*=btfly]")).length;
 sData += "&autobuybutterflies=";
 if (j > 0) {
  for (i = 0; i < j; i++) {
   if (document.querySelectorAll("[id*=btfly]")[i].checked)
    sData += (document.querySelectorAll("[id*=btfly]"))[i].value + ",";
  }
 } else {
  sData += "0";
 }
 if (sData.substring(sData.length-1, sData.length) == ",")
  sData = sData.substring(0, sData.length - 1);

 AJAXsave(sData);
 return false;
}

function saveConfig() {
 var sUser = document.venueselect.username.value;
 var sFarm = document.venueselect.farm.value;
 var sData = "username=" + sUser + "&farm=" + sFarm + "&queueContent=";

 switch (sFarm) {
  case "forestry":
  case "farmersmarket":
  case "farmersmarket2":
  case "foodworld":
  case "city2":
   if (sFarm == "farmersmarket")
    var fmpos = ["flowerarea", "nursery", "monsterfruit", "pets", "vet"];
   if (sFarm == "farmersmarket2")
    var fmpos = ["cowracing", "fishing", "scouts"];
   if (sFarm == "forestry")
    var fmpos = ["sawmill", "carpentry", "forestry"];
   if (sFarm == "foodworld")
    var fmpos = ["sodastall", "snackbooth", "pastryshop", "icecreamparlour"];
   if (sFarm == "city2")
    var fmpos = ["windmill", "trans25", "trans26", "powerups", "tools", "trans27", "trans28", "trans29", "trans210", "eventgarden"];

   for (k = 0; k <= (fmpos.length - 1); k++) {
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
    sData += "#"; // replace last space
   }
  break;

  default:
   for (i = 1; i <= 6; i++) {
    sData += document.getElementById("queue" + i)[0].value + " ";
    sData += document.getElementById("queue" + i)[1].value + " ";
    for (j = 0; j < document.getElementById("queue" + i)[2].options.length; j++)
     sData += document.getElementById("queue" + i)[2][j].value + " ";
    if (document.getElementById("queue" + i)[3] !== undefined) {
     sData = sData.substring(0, sData.length - 1);
     sData += "-";
     sData += document.getElementById("queue" + i)[3].value + " ";
     sData += document.getElementById("queue" + i)[4].value + " ";
     for (j = 0; j < document.getElementById("queue" + i)[5].options.length; j++)
      sData += document.getElementById("queue" + i)[5][j].value + " ";
    }
    if (document.getElementById("queue" + i)[6] !== undefined) {
     sData = sData.substring(0, sData.length - 1);
     sData += "-";
     sData += document.getElementById("queue" + i)[6].value + " ";
     sData += document.getElementById("queue" + i)[7].value + " ";
     for (j = 0; j < document.getElementById("queue" + i)[8].options.length; j++)
      sData += document.getElementById("queue" + i)[8][j].value + " ";
    }
    sData = sData.substring(0, sData.length - 1);
    sData += "#";
   }
 }
// strip last char
 sData = sData.substring(0, sData.length - 1);
// save data via AJAX
 AJAXsave(sData);
 return false;
}

function displayNotification(sTitle, sBody, bConfirm, sTag) {
 var options = { icon: 'image/mffbot.png',
                body: sBody,
                requireInteraction: bConfirm,
                tag: sTag };
 if (!("Notification" in window))
  alert(sTitle);
 else if (Notification.permission === "granted")
  var notification = new Notification(sTitle, options);
 else if (Notification.permission !== "denied") {
  Notification.requestPermission(function (permission) {
 if (permission === "granted")
  var notification = new Notification(sTitle, options);
  });
 }
}

function showHideOptions(element) {
 var j = (document.querySelectorAll("[id*=pane]")).length, i;
 var div = document.getElementById(element);
 if (div.style.display !== "none") {
  div.style.display = "none";
  return false;
 }
 else {
  for (i = 0; i < j; i++) {
   // close all other panes
   div = document.getElementById((document.querySelectorAll("[id*=pane]"))[i].id);
   if (div.style.display !== "none")
    div.style.display = "none";
  }
  // all panes are closed, let's open the desired one
  (document.getElementById(element)).style.display = "inline-block";
  return false;
 }
}

function confirmUpdate() {
 var cu = confirm("{$strings['confirmupdate']}");
 if (cu == true) {
  var sData = "username=" + document.venueselect.username.value + "&action=triggerupdate";
  xhttp = new XMLHttpRequest();
  xhttp.open("POST", "botaction.php", true);
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

function AJAXsave(sData) {
 xhttp = new XMLHttpRequest();
 xhttp.onreadystatechange = function() {
 if (xhttp.readyState == 4 && xhttp.status == 200)
  if (xhttp.responseText == 0)
   displayNotification("{$strings['saveOK']}", "", false, "saveOK");
  else
   displayNotification("{$strings['error']}", "{$strings['saveNOK']}", true, "saveNOK");
 }
 xhttp.open("POST", "save.php", false);
 xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
 xhttp.send(sData);
}
</script>

EOT;
?>
