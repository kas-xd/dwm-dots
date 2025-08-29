#!/bin/bash

while true; do
    # Date & time
    date_time=$(date "+%a %d, %H:%M:%S")

    # Volume (requires `pamixer` or `amixer`)
    volume=$(pamixer --get-volume-human)

    # RAM usage
    ram=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')

    # CPU load
    cpu=$(awk '{u=$2+$4; t=$2+$4+$5} NR==1{pu=u; pt=t; next} {printf "%.1f%%", (u-pu)/(t-pt)*100}' <(grep 'cpu ' /proc/stat) <(sleep 0.5; grep 'cpu ' /proc/stat))

    # Build the status string
    xsetroot -name "VOL: $volume | RAM: $ram | CPU: $cpu | $date_time"

    sleep 0.5
done

