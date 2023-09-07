#!/bin/bash

# optional components installation
my_swaywm_config=yes # set no if just want an empty swaywm setup
audio=yes # set no if do not want to use pipewire audio server
wireplumber=yes # set no if want to use pulseaudio-utils for pipewire audio management
thunar=yes # set no if do not want to use thunar file manager
nm=yes # set no if do not want to use network-manager for network interface management
nano_config=yes # set no if do not want to configure nano text editor
moz_enable=yes # set no if do not use firefox web browser

install () {
	# install swaywm and other packages
	sudo apt-get update && sudo apt-get upgrade -y
	sudo apt-get install sway swaybg swayidle swaylock xdg-desktop-portal-wlr xwayland foot suckless-tools \
		fonts-noto-color-emoji fonts-font-awesome mako-notifier libnotify-bin grim imagemagick nano less iputils-ping -y

	# use pipewire with wireplumber or pulseaudio-utils
	if [[ $audio == "yes" ]]; then
		if [[ $wireplumber == "yes" ]]; then
			sudo apt-get install pipewire pipewire-pulse wireplumber -y
		else
			sudo apt-get install pipewire pipewire-media-session pulseaudio pulseaudio-utils -y
		fi
	fi

	# optional install thunar and extra packages
	if [[ $thunar == "yes" ]]; then
		sudo apt-get install thunar gvfs gvfs-backends thunar-archive-plugin thunar-media-tags-plugin avahi-daemon -y
	fi

	# optional install NetworkManager
	if [[ $nm == yes ]]; then
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
			sudo systemctl disable networking.service
		fi
	fi

	# copy my swaywm and mako configuration
	if [[ $my_swaywm_config == "yes" ]]; then
		if [[ -d $HOME/.config/sway ]]; then mv $HOME/.config/sway $HOME/.config/sway_`date +%Y_%d_%m_%H_%M_%S`; fi
		if [[ -d $HOME/.config/mako ]]; then mv $HOME/.config/mako $HOME/.config/mako`date +%Y_%d_%m_%H_%M_%S`; fi
		mkdir -p $HOME/{Documents,Downloads,Music,Pictures,Videos}
		mkdir -p $HOME/.config/{sway,mako}
		cp -r ./config/sway/* $HOME/.config/sway/
		chmod +x $HOME/.config/sway/scripts/*.sh
		cp ./config/mako/config $HOME/.config/mako/
	fi

	# configure nano with line number
	if [[ $nano_config == "yes" ]]; then
		if [[ -f $HOME/.nanorc ]]; then mv $HOME/.nanorc $HOME/.nanorc_`date +%Y_%d_%m_%H_%M_%S`; fi
		cp /etc/nanorc $HOME/.nanorc
		sed -i 's/# set const/set const/g' $HOME/.nanorc
	fi

	# enable firefox to run in wayland protocol
	if [[ $moz_enable == "yes" ]]; then
		if [[ -f $HOME/.profile ]]; then cp $HOME/.profile $HOME/.profile_`date +%Y_%d_%m_%H_%M_%S`; fi
		if [[ ! $(cat $HOME/.profile | grep "^[^#;]" | grep MOZ_ENABLE_WAYLAND=1 ) ]]; then
			echo -e "\nexport MOZ_ENABLE_WAYLAND=1\n" >> $HOME/.profile
		fi
	fi
}

printf "\n"
printf "Start installation!!!!!!!!!!!\n"
printf "88888888888888888888888888888\n"
printf "My Custom Swaywm Config : $my_swaywm_config\n"
printf "Pipewire                : $audio\n"
printf "Wireplumber             : $wireplumber\n"
printf "Thunar                  : $thunar\n"
printf "NetworkManager          : $nm\n"
printf "Nano's configuration    : $nano_config\n"
printf "MOZ_ENABLE_WAYLAND      : $moz_enable\n"
printf "88888888888888888888888888888\n"

while true; do
read -p "Do you want to proceed with above settings? (y/n) " yn
	case $yn in
		[yY] ) echo ok, we will proceed; install; echo "Remember to reboot system after installation!";
			break;;
		[nN] ) echo exiting...;
			exit;;
		* ) echo invalid response;;
	esac
done
