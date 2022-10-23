#!/bin/bash

currentTime=$(date "+%F %T")
language=$(swaymsg -t get_inputs | jq 'map(select(has("xkb_active_layout_name")))[0].xkb_active_layout_name')

echo "${currentTime} - ${language}"
