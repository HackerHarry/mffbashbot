# My Free Farm Bash Bot on macOS

This is a macOS port of the bot. macOS ships BSD versions of many Unix tools
and an ancient bash (3.2), so a few things differ from the Linux/Cygwin setup.
The bot itself needs no game-server changes — only the local tooling differs.

## 1. Install the dependencies (Homebrew)

macOS does not ship most of what the bot needs. Install [Homebrew](https://brew.sh)
first, then:

```bash
brew install bash php wget jq lighttpd screen
```

- **bash** – macOS `/bin/bash` is 3.2; the bot requires **≥ 4.3**. Make sure the
  Homebrew bash comes first in your `PATH` (add `"$(brew --prefix)/bin"` to the
  front of `PATH` in `~/.zprofile`), otherwise the version check fails.
- **php** – provides `php` and `php-cgi` (the GUI runs on PHP-CGI).
- **wget** – the bot talks to the game exclusively via `wget`. macOS only has
  `curl`, so `wget` must be installed.
- **jq** – JSON processing (needs ≥ 1.5; Homebrew is current).
- **lighttpd** – the local web server for the GUI.
- **screen** – ships with macOS, listed for completeness.

## 2. Put the bot in the right place

The generated start scripts hard-code `~/mffbashbot`, so the bot must live there:

```bash
mv /path/to/mffbashbot ~/mffbashbot
```

## 3. Run the installer

```bash
cd ~/mffbashbot
./install-macos.sh
```

It checks the dependencies, patches `mffbashbot-GUI/config.php` to the macOS home
layout (`/Users/<you>/…` instead of `/home/pi/…`), writes a self-contained
lighttpd config to `~/mffbashbot/lighttpd-macos.conf`, and creates
`~/startallbots.sh`.

Unlike the Linux installer it does **not** use `sudo`, does **not** move the GUI
into `/var/www`, and runs lighttpd as your own user on **port 8080** (no root
needed). The GUI is served straight from `~/mffbashbot/mffbashbot-GUI`.

## 4. Add a farm and start the bot

```bash
~/startallbots.sh          # starts the web GUI (lighttpd)
```

Open <http://localhost:8080>, add your farm. Adding a farm regenerates
`~/startallbots.sh` so that it also launches the bot in a `screen` session.

```bash
~/startallbots.sh          # now starts lighttpd + the bot
screen -r mffbashbot       # watch the bot (detach: Ctrl-A then D)
pkill lighttpd             # stop the web server when done
```

You can also add farms without the GUI, straight from the terminal:

```bash
cd ~/mffbashbot/mffbashbot-GUI
bash script/addfarm.sh 'YOURPASSWORD' 1 de "$HOME/mffbashbot/YOURFARMNAME"
```

(arguments: password, server number, language `de|en|bg|pl`, full game path;
quote the password so spaces/special characters survive).

## 5. Updating

The Linux `update.sh` flow does not apply on macOS. Update via git instead:

```bash
cd ~/mffbashbot && git pull && ./install-macos.sh
```

## What was changed for macOS

- **Portable in-place `sed`** – added a `sedInPlace` helper in `functions.sh`
  (BSD `sed` needs a backup-suffix argument that GNU `sed` does not) and used it
  in `mffbashbot.sh`; the same portable form is inlined in
  `mffbashbot-GUI/script/logonandgetfarmdata.sh`.
- **OS detection** – `addfarm.sh`, `removefarm.sh` and `wakeupthebot.sh` now
  recognise Darwin, skip the Linux-only `chgrp`/`stat`/`sudo` steps, and emit a
  macOS-appropriate lighttpd command into the generated start script.
- **`config.php`** – the installer rewrites the `/home/pi/mffbashbot/` base to
  your real macOS home (`/Users/<you>/mffbashbot/`).
- **`install-macos.sh`** – new Homebrew-based installer with a self-contained,
  sudo-free lighttpd config.
- **`update.sh`** – now detects macOS and points you to the git-based update.

## Behaviour change: sowing empty fields

Stock behaviour only harvests a ripe crop and then replants the next queued
crop, so a field that is **completely empty** (`production = null`) was never
sown — you had to plant the first crop by hand in the game. `mffbashbot.sh` now
also sows empty normal fields (`buildingid = 1`) from their queue: if a field
has no crop growing and its queue is not set to "sleep", the bot plants the
queued crop on the bare plots. Growing crops, stables and other buildings are
left untouched. This is platform-independent (helps on Linux/Windows too).

## Queue overview: `queue-status.sh`

Shows, per position/slot, what is currently queued and which item comes next.
Because the queue is stored on disk, this reflects the true state even after a
stop/restart.

```bash
./queue-status.sh              # the only farm, or lists farms if several
./queue-status.sh Phaynil      # a specific farm
./queue-status.sh Phaynil --all  # also show empty / sleeping / n/a positions
```

Example:

```
Hof 1
  Position 1  Slot 0  [Acker]  ► Radieschen
  Position 3  Slot 0  [Acker]  ► Erdbeeren  →  Tomaten ×50  →  Radieschen   [3 Einträge]
```

`►` marks the item planted next; the rest follow in rotation order. Names come
from `/tmp/products-<lang>.txt` (created on GUI login); without it, raw product
IDs are shown.

The same overview is available in the **web GUI**: the "Warteschlangen-Übersicht"
button in the top navbar opens `queueoverview.php`, a read-only page that lists
every queue across all areas with the next item marked `►` (and an "Alle
anzeigen" toggle for empty/sleeping positions).

`date +%s%N` (used for the login token) already returns real nanoseconds on
current macOS, so no change was needed there. If a future/older macOS `date`
lacks `%N` support, `brew install coreutils` and using `gdate` is the fallback.
