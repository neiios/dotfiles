#!/bin/bash

currentTime=$(date --rfc-3339='seconds')
language=$(swaymsg -t get_inputs | jq 'map(select(has("xkb_active_layout_name")))[0].xkb_active_layout_name')

echo "${currentTime} - ${language}"
