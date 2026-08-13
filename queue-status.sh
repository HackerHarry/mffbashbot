#!/usr/bin/env bash
# Queue overview for My Free Farm Bash Bot
# Shows, per position/slot, what is currently queued and which item comes next.
#
# The queue lives on disk in <farm>/<area>/<position>/<slot> files:
#   line 1     = building type (Farm, Stable, ...)
#   line 2     = the item planted NEXT  (marked with the arrow below)
#   line 3+    = the following items, in order
# After planting, the bot rotates the head to the end, so line 2 always shows
# the current position in the rotation. This state survives a stop/restart.
#
# Usage: ./queue-status.sh [farmname] [--all]
#   no farmname   -> use the only farm, or list the available ones
#   --all         -> also show empty / sleeping / unsupported positions

ARROW="►"

BOTROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$BOTROOT" || exit 1

SHOWALL=0
FARM=""
for arg in "$@"; do
 case "$arg" in
  --all) SHOWALL=1 ;;
  *)     FARM="$arg" ;;
 esac
done

# collect farms (directories containing a config.ini)
farms=()
for d in */; do [ -f "${d}config.ini" ] && farms+=("${d%/}"); done
if [ ${#farms[@]} -eq 0 ]; then
 echo "Keine Farm gefunden in $BOTROOT"
 exit 1
fi
if [ -z "$FARM" ]; then
 if [ ${#farms[@]} -eq 1 ]; then
  FARM="${farms[0]}"
 else
  echo "Verfügbare Farmen: ${farms[*]}"
  echo "Aufruf: $0 <farmname> [--all]"
  exit 0
 fi
fi
if [ ! -d "$FARM" ] || [ ! -f "$FARM/config.ini" ]; then
 echo "Farm '$FARM' nicht gefunden."
 exit 1
fi

LANG_MFF=$(grep -E "^lang"   "$FARM/config.ini" | head -1 | tr -d " '" | cut -d= -f2)
SERVER=$(grep -E "^server" "$FARM/config.ini" | head -1 | tr -d " "  | cut -d= -f2)
PRODFILE="/tmp/products-${LANG_MFF}.txt"

# map a product id to its name (falls back to the raw id)
name_for() {
 local id="$1" n=""
 if [ -f "$PRODFILE" ]; then
  n=$(jq -r --arg id "$id" '.[$id] // empty' "$PRODFILE" 2>/dev/null)
 fi
 if [ -n "$n" ]; then echo "$n"; else echo "ID $id"; fi
}

# translate the building type on line 1 to a readable label
type_label() {
 case "$1" in
  Farm)        echo "Acker" ;;
  Stable)      echo "Stall" ;;
  unsupported) echo "n/a"   ;;
  *)           echo "$1"    ;;
 esac
}

echo "Farm: $FARM   (Server $SERVER, Sprache $LANG_MFF)"
if [ ! -f "$PRODFILE" ]; then
 echo "Hinweis: $PRODFILE fehlt -> es werden nur Produkt-IDs angezeigt."
 echo "         (Einmal in der Web-GUI einloggen erzeugt die Namensliste.)"
fi
echo "Legende: $ARROW = wird als Nächstes gepflanzt; danach in Reihenfolge."
echo

current_area=""
shown=0

# slot files sit exactly three levels below the farm dir: <area>/<pos>/<slot>
while IFS= read -r slotfile; do
 [ -n "$slotfile" ] || continue
 rel="${slotfile#"$FARM"/}"          # e.g. 1/3/0
 area="${rel%%/*}"                   # 1
 rest="${rel#*/}"                    # 3/0
 pos="${rest%%/*}"                   # 3
 slot="${rest#*/}"                   # 0

 btype=$(head -1 "$slotfile" 2>/dev/null)
 # queue = every line from 2 onwards
 mapfile_lines=$(tail -n +2 "$slotfile" 2>/dev/null)

 # decide whether this entry is "active"
 first_item=$(printf '%s\n' "$mapfile_lines" | head -1)
 if [ "$SHOWALL" -ne 1 ]; then
  if [ "$btype" = "unsupported" ] || [ -z "$first_item" ] || [ "$first_item" = "sleep" ]; then
   continue
  fi
 fi

 # area header
 if [ "$area" != "$current_area" ]; then
  if [[ "$area" =~ ^[0-9]+$ ]]; then
   echo "Hof $area"
  else
   echo "$area"
  fi
  current_area="$area"
 fi

 label=$(type_label "$btype")

 # build the queue string
 if [ -z "$first_item" ] || [ "$first_item" = "sleep" ]; then
  queuestr="(leer / Sleep)"
 else
  queuestr=""
  idx=0
  while IFS= read -r item; do
   [ -n "$item" ] || continue
   pid="${item%%,*}"
   amount=""
   [ "$item" != "$pid" ] && amount=" ×${item#*,}"
   pname=$(name_for "$pid")
   if [ $idx -eq 0 ]; then
    queuestr="$ARROW ${pname}${amount}"
   else
    queuestr="$queuestr  →  ${pname}${amount}"
   fi
   idx=$((idx + 1))
  done <<EOF
$mapfile_lines
EOF
  [ $idx -gt 1 ] && queuestr="$queuestr   [${idx} Einträge]"
 fi

 printf "  Position %-2s Slot %-2s [%-5s]  %s\n" "$pos" "$slot" "$label" "$queuestr"
 shown=$((shown + 1))
done < <(find "$FARM" -mindepth 3 -maxdepth 3 -type f 2>/dev/null | sort -t/ -k2,2 -k3,3n -k4,4)

if [ "$shown" -eq 0 ]; then
 echo "Keine belegten Warteschlangen. (Mit --all auch leere/schlafende Positionen anzeigen.)"
fi
