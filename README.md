# My SwayWM Setup

I want to test out wayland and this is my Sway WM setup on Ubuntu 22.04/23.04 and Debian 12.

I test this installation script using Ubuntu 22.04/23.04 and Debian 12 minimal based installation.

![image](https://github.com/hat3ph/my_swaywm_setup/assets/88069788/a81f6dfa-e2b1-4b55-9553-6221a6c0ec6a)

## Installation
Simply clone the repository and run `setup.sh` to start the installation:
```
sudo apt-get install nano git
git clone https://github.com/hat3ph/my_swaywm_setup.git
cd my_swaywm_setup
chmod +x setup.sh
./setup.sh
```
*Note that super user priviledges are needed to run the installation script.*

Before start the installation, recommend to check out `setup.sh` and disable/enable which components to install.

By default, it will auto install the sway wm packages. If your Ubuntu/Debian base OS is using the minimal server ISO installation, recommend to install all to have a proper functional system. 
```
# optional components installation
my_swaywm_config=yes
# set no if do not want to use pipewire audio server
audio=yes
# set no if do not want to install the extra packages
extra_pkg=yes
# set no if do not want to use network-manager for network interface management
nm=yes
# set no if do not want to configure nano text editor
nano_config=no
# set no to not autostart swaywm once TUI
autostart_sway=yes
```
## Login Manager
SDDM work on sway but I notice it will pull xorg packages as dependency. So I just configure to auto run sway after TUI login.
If you want to use your prefered login manager, set `autostart_sway=no` and install your login manager manually afterward.

## GTK & QT Theming
For GTK, use `lxappearance` to change GTK applications theme. Remember to restart sway config for it to take effect.

For QT, use `qt5ct` to change QT applications theme.

## Ubuntu 22.04 Bugs (Can ignore this if using Ubuntu 23.04 or Debian 12)
- Ubuntu 22.04 come with wireplumber-0.4.8 that do not have the get-volume function. Until the updated version of wireplumber is available for Ubuntu 22.04, I will use pulseaudio-utils instead for audio management.

![image](https://github.com/hat3ph/my_swaywm_setup/assets/88069788/7795728c-f461-40a5-95cb-9aca3c99ca72)

- Ubuntu 22.04 come with mako-notifier-1.6 that have some problem with [apparmor permission](https://github.com/emersion/mako/issues/257#issuecomment-1638776704).
Run below command with a reboot afterward shoud fix it.
```
sudo ln -s /etc/apparmor.d/fr.emersion.Mako /etc/apparmor.d/disable/
```
## Customization
I have split the sway default configuration to individual files under  `$HOME/.config/sway/config.d/`. Edit `$HOME/.config/sway/config` to include or exclude any individual configuration files. 

Pls refer to [sway man page](https://man.archlinux.org/man/sway.5) for more info.

 ## Credit
- [dmenu configuration](https://smarttech101.com/dmenu-what-it-is-and-how-i-use-it/)
- [sway-on-ubuntu](https://llandy3d.github.io/sway-on-ubuntu/extra/)
- [Swaybar example](https://unix.stackexchange.com/questions/473788/simple-swaybar-example)
- [Daniel W Armstong](https://www.dwarmstrong.org/sway/)
- [Sway's Wiki](https://github.com/swaywm/sway/wiki)
- [Awesome Font v4 emoji](https://fontawesome.com/v4/cheatsheet/)
- [emoji1](https://github.com/dln/wofi-emoji/blob/master/wofi-emoji)
- [emoji2](https://gist.github.com/Sebas-h/36ad7fa40c39a28ba00dedd2cf1d4e8e)
- [emoji3](https://git.sr.ht/~earboxer/dotfiles/tree/master/item/.config/sxmo/hooks/sxmo_hook_icons.sh)
