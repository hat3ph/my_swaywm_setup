#!/bin/bash

# install sway and other packages
sudo apt-get install sway swaybg swayidle swaylock xdg-desktop-portal-wlr xwayland foot suckless-tools pipewire wireplumber fonts-noto-color-emoji mako-notifier libnotify-bin grim thunar gvfs gvfs-backends thunar-archive-plugin thunar-media-tags-plugin -y

# copy my swaywm and mako configuration
mkdir -p $HOME/.config/{sway,mako}
cp -r ./config/sway/* $HOME/.config/sway/
chmod +x $HOME/.config/sway/scripts/*.sh
cp ./config/mako/config $HOME/.config/mako/

cat >> $HOME/.profile << 'EOF'

export MOZ_ENABLE_WAYLAND=1
EOF

# setup my customer bash alias
cat >> $HOME/.bashrc << 'EOF'

alias temps='watch -n 1 sensors amdgpu-* drivetemp-* k10temp-* asus_wmi_sensors-*'
alias syslog='tail -f /var/log/syslog'
EOF
