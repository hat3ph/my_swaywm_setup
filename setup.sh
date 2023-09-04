#!/bin/bash

# install sway and other packages
sudo apt-get install sway swaybg swayidle swaylock xdg-desktop-portal-wlr xwayland foot suckless-tools pipewire \
    wireplumber fonts-noto-color-emoji fonts-font-awesome mako-notifier libnotify-bin grim nano less -y

# optional install extra packages
extra_pkgs=yes

if [[ $extra_pkgs == "yes" ]]; then
    sudo apt-get install thunar gvfs gvfs-backends thunar-archive-plugin thunar-media-tags-plugin avahi-daemon \
        copyq featherpad -y
fi

# copy my swaywm and mako configuration
if [[ -d $HOME/.config/sway ]]; then mv $HOME/.config/sway $HOME/.config/sway_`date +%Y_%d_%m_%H_%M_%S`; fi
if [[ -d $HOME/.config/mako ]]; then mv $HOME/.config/mako $HOME/.config/mako`date +%Y_%d_%m_%H_%M_%S`; fi
mkdir -p $HOME/.config/{sway,mako}
cp -r ./config/sway/* $HOME/.config/sway/
chmod +x $HOME/.config/sway/scripts/*.sh
cp ./config/mako/config $HOME/.config/mako/

# configure nano with line number
if [[ -f $HOME/.nanorc ]]; then mv $HOME/.nanorc $HOME/.nanorc_`date +%Y_%d_%m_%H_%M_%S`; fi
cp /etc/nanorc $HOME/.nanorc
sed -i 's/# set const/set const/g' $HOME/.nanorc

# enable firefox to run in wayland protocol
if [[ -f $HOME/.profile ]]; then mv $HOME/.profile $HOME/.profile_`date +%Y_%d_%m_%H_%M_%S`; fi
if [[ ! $(cat $HOME/.profile | grep "^[^#;]" | grep MOZ_ENABLE_WAYLAND=1 ) ]]; then
    printf "\nexport MOZ_ENABLE_WAYLAND=1\n"
fi
