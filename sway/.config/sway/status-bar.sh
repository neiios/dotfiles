#!/bin/bash

currentTime=$(date "+%F %H:%M")
language=$(swaymsg -t get_inputs | jq 'map(select(has("xkb_active_layout_name")))[0].xkb_active_layout_name')

echo "${currentTime} - ${language}"
