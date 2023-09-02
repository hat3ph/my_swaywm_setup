#!/bin/bash

#echo -e "poweroff\nreboot\nsuspend" | dmenu -i -nb "#EBCB8B" -nf "#2E3440" -sb "#2E3440" -sf "#EBCB8B" -p "Power Options:" | xargs systemctl
echo -e "poweroff\nreboot\nsuspend" | $HOME/.config/sway/scripts/my_dmenu.sh -p "Power Options:" | xargs systemctl
