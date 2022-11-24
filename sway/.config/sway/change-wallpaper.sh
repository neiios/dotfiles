#!/bin/bash

# changes sway wallpaper based on the time of day
# should be run together with a systemd timer

function error() {
  echo "${1:-"Unknown Error"}" 1>&2
  exit 1
}

# create variables
currentHour=$(date "+%H")
wallpaperDir="${HOME}/.local/share/wallpapers"

cd "${wallpaperDir}" || error "Wallpaper directory doesn't exist."

# based on time
filename=$(find . -type f | sed 's/^\.\///g' | grep -E -- "\b${currentHour}\b")

# random
# filename=$(find . -type f | sed 's/^\.\///g' | shuf --head-count=1)

# get pid of old swaybg process
if pidof swaybg; then pid=($(pidof swaybg)); fi

# launch new swaybg
swaybg -i "${wallpaperDir}/${filename}" -m fill -o '*' &
disown

# wait to avoid grey screen
sleep 5

# remove old background
if [[ ! ${#pid[@]} -eq 0 ]]; then kill "${pid[@]}"; fi
