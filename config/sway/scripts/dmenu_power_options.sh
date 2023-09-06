#!/bin/bash

# my custom dmenu power options
echo -e "poweroff\nreboot\nsuspend" | $HOME/.config/sway/scripts/my_dmenu.sh -p "Power Options:" | xargs systemctl
