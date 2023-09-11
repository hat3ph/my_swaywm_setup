#!/bin/bash

# my custom dmenu power options
#echo -e "poweroff\nreboot\nsuspend" | $HOME/.config/sway/scripts/my_dmenu.sh -p "Power Options:" | xargs systemctl

choice=`echo -e "0: Logout\n1: Shutdown\n2: Reboot\n3: Suspend\n4: Cancel" | $HOME/.config/sway/scripts/my_dmenu.sh -p "Power Options:" | cut -d ':' -f 1`

# execute the choice in background
case "$choice" in
  #0) swaymsg exit & ;;
  #1) systemctl poweroff & ;;
  #2) systemctl suspend & ;;
  #3) systemctl reboot & ;;
  0) swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' \
    -B 'Yes, exit sway' 'swaymsg exit' & ;;
  1) swaynag -t warning -m 'You pressed the shutdown shortcut. Do you really want to shutdown your system?' \
    -B 'Yes, systemctl poweroff' 'swaymsg exit' & ;;
  2) swaynag -t warning -m 'You pressed the reboot shortcut. Do you really want to reboot your system?' \
    -B 'Yes, systemctl reboot' 'swaymsg exit' & ;;
  3) swaynag -t warning -m 'You pressed the suspend shortcut. Do you really want to suspend your system?' \
    -B 'Yes, systemctl suspend' 'swaymsg exit' & ;;
  4) exit ;;
esac