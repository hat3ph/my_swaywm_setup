#!/bin/bash

# custom emoji
cpu_emoji=🍟
mem_emoji=🥓
date_emoji=🕘
#net_emoji=🌐
#net_emoji=📡

# current date
#date_formatted=$(date "+%a %F %H:%M")
date_formatted=$(date "+%R")

# check volume level and status vis pipewire and wireplumber
if [[ -n $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d ' ' -f 3 | sed 's/^.//;s/.$//') ]]; then
	volume_emoji=🔇
	volume_level="MUTED"
else
	volume_emoji=🔊
	volume_level=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d ' ' -f 2 | awk '{printf "%2.0f%%\n", 100 * $1}')
fi

# check total cpu usage
cpu_usage="$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%

# check total memory usage
mem_usage="$(free | grep Mem | awk '{printf "%2.0f%%\n", $3/$2 * 100}')"

# check network connection
#net_info="$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p') ($(ip -o route get to 8.8.8.8 | awk '{print $5}'))"
ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && net_info="$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p') ($(ip -o route get to 8.8.8.8 | awk '{print $5}'))" net_emoji=🛜 || net_info="Disconnected" net_emoji=⛔

# Returns the battery status: "Full", "Discharging", or "Charging".
if [[ -d /sys/class/power_supply/BAT0 ]]; then
	battery_status=$(cat /sys/class/power_supply/BAT0/status)
	if [[ $battery_status == "Discharging" ]] || [[ $battery_status == "Charging" ]]; then
		battery_emoji=🪫
	else
		battery_emoji=🔋
	fi
else
	battery_emoji=🔌
	battery_status="AC"
fi

# output to swaybar
if [[ -d /sys/class/power_supply/BAT0 ]]; then
	echo $cpu_emoji $cpu_usage $mem_emoji $mem_usage $net_emoji $net_info $battery_emoji $battery_status $volume_emoji $volume_level $date_emoji $date_formatted
else
	echo $cpu_emoji $cpu_usage $mem_emoji $mem_usage $net_emoji $net_info $volume_emoji $volume_level $date_emoji $date_formatted
fi