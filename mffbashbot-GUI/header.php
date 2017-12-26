<?php
// Header file for Harry's My Free Farm Bash Bot (front end)
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
print "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n";
print "<html>\n";
print "<head>\n";
print "<title>Harrys MFF Bash Bot - " . $farmFriendlyName["$farm"] . "</title>";
print "<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">\n";
print "<link href=\"css/mffbot.css\" rel=\"stylesheet\" type=\"text/css\">\n";
print "</head>\n";
print "<body id=\"main_body\" class=\"main_body\" onload=\"window.setTimeout(updateBotStatus, 30000)\">\n";
?>
