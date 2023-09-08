#!/bin/bash

# optional components installation
my_swaywm_config=yes # set no if just want an empty swaywm setup
audio=yes # set no if do not want to use pipewire audio server
wireplumber=yes # set no if want to use pulseaudio-utils for pipewire audio management
extra_pkg=yes # set no if do not want to install the extra packages
nm=yes # set no if do not want to use network-manager for network interface management
nano_config=yes # set no if do not want to configure nano text editor
autostart_sway=yes # set no to not autostart swaywm once TUI

install () {
	# install swaywm and other packages
	sudo apt-get update && sudo apt-get upgrade -y
	sudo apt-get install sway swaybg swayidle swaylock xdg-desktop-portal-wlr xwayland foot suckless-tools \
		fonts-noto-color-emoji fonts-font-awesome mako-notifier libnotify-bin grim imagemagick nano less iputils-ping \
		adwaita-icon-theme papirus-icon-theme qt5ct grimshot xdg-utils -y

	# use pipewire with wireplumber or pulseaudio-utils
	if [[ $audio == "yes" ]]; then
		if [[ $wireplumber == "yes" ]]; then
			sudo apt-get install pipewire pipewire-pulse wireplumber -y
		else
			sudo apt-get install pipewire pipewire-media-session pulseaudio pulseaudio-utils -y
		fi
	fi

	# optional to insstall the extra packages
	if [[ $extra_pkg == "yes" ]]; then
		sudo apt-get install thunar gvfs gvfs-backends thunar-archive-plugin thunar-media-tags-plugin avahi-daemon \
			lximage-qt geany -y
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

	# enable autostart swaywm after TUI login
	sudo cp ./config/start_swaywm.sh /usr/local/bin/start_swaywm.sh
	sudo chmod +x /usr/local/bin/start_swaywm.sh
	if [[ $autostart_sway == "yes" ]]; then
		if [[ -f $HOME/.bashrc ]]; then cp $HOME/.bashrc $HOME/.bashrc_`date +%Y_%d_%m_%H_%M_%S`; fi
		echo -e '\n#If running from tty1 start sway\n[ "$(tty)" = "/dev/tty1" ] && /usr/local/bin/start_swaywm.sh' >> $HOME/.bashrc
	fi

	# configure gtk theme for sway/wayland
	mkdir -p $HOME/.config/gtk-3.0
	cp ./config/settings.ini $HOME/.config/gtk3.0/settings.ini

	# create default application mimeapps.list
	mkdir -p $HOME/.config
	cp ./config/mimeapps.list $HOME/.config/mimeapps.list
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
printf "Autostart SwayWM        : $autostart_sway\n"
printf "88888888888888888888888888888\n"

while true; do
read -p "Do you want to proceed with above settings? (y/n) " yn
	case $yn in
		[yY] ) echo ok, we will proceed; install; echo "Remember to reboot system after the installation!";
			break;;
		[nN] ) echo exiting...;
			exit;;
		* ) echo invalid response;;
	esac
done