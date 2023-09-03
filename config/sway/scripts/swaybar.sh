#!/bin/bash

# custom emoji
cpu_emoji=🍟
mem_emoji=🥓
#date_emoji=🕘
#net_emoji=🌐
#net_emoji=📡

# current date
#date_formatted=$(date "+%a %F %H:%M")
date_formatted=$(date "+%R%p")
if [[ `date +%H` -lt 12 ]]; then
	date_emoji=☀️
elif [[ `date +%H` -lt 18 ]]; then
	date_emoji=🕒
else
	date_emoji=🌜
fi

# check volume level and status vis pipewire and wireplumber
if [[ -n $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d ' ' -f 3 | sed 's/^.//;s/.$//') ]]; then
	volume_emoji=🔇
	volume_level="MUTED"
else
	volume_emoji=🔊
	volume_level=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d ' ' -f 2 | awk '{printf "%2.0f%%\n", 100 * $1}')
fi

# check total cpu usage and temp
cpu_usage="$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%
cpu_temp=$(< /sys/class/thermal/thermal_zone0/temp)
cpu_temp=$(($cpu_temp/1000))

# check total memory usage
#mem_usage="$(free | grep Mem | awk '{printf "%2.0f%%\n", $3/$2 * 100}')"
mem_usage="$(free -h | awk 'NR==2 {print $3}')"

# check network connection
#net_info="$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p') ($(ip -o route get to 8.8.8.8 | awk '{print $5}'))"
ping -q -w 1 -c 1 `ip r | grep default | grep -v linkdown | cut -d ' ' -f 3` > /dev/null && \
	net_info="$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p') ($(ip -o route get to 8.8.8.8 | awk '{print $5}'))" net_emoji=🛜 \
	|| net_info="Disconnected" net_emoji=⛔

# Returns the battery status: "Full", "Discharging", or "Charging".
if [[ -d /sys/class/power_supply/BAT0 ]]; then
	battery_status=$(cat /sys/class/power_supply/BAT0/status)
	battery_capacity=$(cat /sys/class/power_supply/BAT0/capacity)
	if [[ $battery_status == "FULL" ]]; then
		battery_emoji=🔌
	elif [[ $battery_status == "Discharging" ]]; then
		if [[ $battery_capacity -lt 20 ]]; then notify-send -u critical "Battery capacity less than 20%"; fi
		battery_emoji=🪫
	else
		battery_emoji=🔋
	fi
fi

# output to swaybar
if [[ -d /sys/class/power_supply/BAT0 ]]; then
	echo $cpu_emoji $cpu_usage $cpu_temp°C $mem_emoji $mem_usage $net_emoji $net_info $battery_emoji $battery_status $battery_capacity% $volume_emoji $volume_level $date_emoji $date_formatted
else
	echo $cpu_emoji $cpu_usage $cpu_temp°C $mem_emoji $mem_usage $net_emoji $net_info $volume_emoji $volume_level $date_emoji $date_formatted
fi
