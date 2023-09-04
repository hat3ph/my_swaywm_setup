#!/bin/bash

# install sway and other packages
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install sway swaybg swayidle swaylock xdg-desktop-portal-wlr xwayland foot suckless-tools pipewire \
    wireplumber fonts-noto-color-emoji fonts-font-awesome mako-notifier libnotify-bin grim nano less -y

# optional install extra packages
extra_pkgs=yes
if [[ $extra_pkgs == "yes" ]]; then
    sudo apt-get install thunar gvfs gvfs-backends thunar-archive-plugin thunar-media-tags-plugin avahi-daemon \
        copyq featherpad -y
fi

# optional install NetworkManager
nm_install=yes
if [[ $nm_install == yes ]]; then
	sudo apt-get install network-manager -y
	if [[ -n "$(uname -a | grep Ubuntu)" ]]; then
		for file in `find /etc/netplan/* -maxdepth 0 -type f -name *.yaml`; do
  			sudo mv $file $file.bak
		done
		echo -e "# Let NetworkManager manage all devices on this system\nnetwork:\n  version: 2\n  renderer: NetworkManager" | \
            sudo tee /etc/netplan/01-network-manager-all.yaml
	else
		sudo cp /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.bak
		sudo sed -i 's/managed=false/managed=true/g' /etc/NetworkManager/NetworkManager.conf
        sudo mv /etc/network/interfaces /etc/network/interfaces.bak
        sudo cp ./config/interfaces /etc/network/interfaces
	fi
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
if [[ -f $HOME/.profile ]]; then cp $HOME/.profile $HOME/.profile_`date +%Y_%d_%m_%H_%M_%S`; fi
if [[ ! $(cat $HOME/.profile | grep "^[^#;]" | grep MOZ_ENABLE_WAYLAND=1 ) ]]; then
    echo -e "\nexport MOZ_ENABLE_WAYLAND=1\n" >> $HOME/.profile
fi
