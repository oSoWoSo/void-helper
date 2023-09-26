#!/bin/sh

# colors
bold=$(tput bold)
none=$(tput sgr0)

# variables
progname="Void Helper"
version="1.0.0"

echo; echo "$progname - Version: $version"
echo "Author: Raven (https://codeberg.org/ravendev)"
echo "Contributor: oSoWoSo (https://codeberg.org/oSoWoSo)"
echo "XBPS version: $(xbps-query -v --version | sed 's/GIT: UNSET//')"; echo

# root check
if [ "$(id -u)" != 0 ]; then
	if [ -f /usr/bin/sudo ]; then
		echo "${bold}INFO: Using sudo for root operations.${none}"
		root="sudo"
	elif [ -f /usr/bin/doas ]; then
		echo "${bold}INFO: Using doas for root operations.${none}"
		root="doas"
	fi
fi

# (01) Check for updates

echo; echo "${bold}*** Checking for updates ***${none}"; echo

$root xbps-install -Su

# (02) Install recommended packages

echo; echo "${bold}*** Installing recommended packages ***${none}"; echo

$root xbps-install -y smartmontools zstd xz bzip2 lz4 zip unzip man-db file nano

# (03) Install development packages

echo; read -p "Do you want to install packages needed for developing software? (y) " devtools
case $devtools in
	y )
	$root xbps-install -y autoconf automake bison m4 make libtool meson ninja optipng sassc
	;;
esac

# (04) Enable non-free repository

echo; read -p "Do you want to enable the non-free repository? (y) " add_repo
case $add_repo in
	y )
	$root xbps-install -y void-repo-nonfree

	echo; read -p "Do you want to install latest NVIDIA proprietary drivers? (y) " nvidia
	case $nvidia in
		y )
		test $(xbps-query -l | grep xf86-video-nouveau) -eq 0 && $root xbps-remove xf86-video-nouveau

		$root xbps-install -y nvidia
		;;
	esac
	;;
esac

# (05) Install shell

echo; echo "${bold}*** Installing a system shell ***${none}"; echo

echo "(1) Fish\n(2) ZSH\n(0) Leave the default (Bash)"

echo; read -p "What do you want to do? " shell
case $shell in
	1 )
	echo; echo "${bold}*** Installing Fish ***${none}"; echo

	$root xbps-install -y fish-shell
	$root usermod -s /usr/bin/fish $(id -un)
	;;

	2 )
	echo; echo "${bold}*** Installing ZSH ***${none}"; echo

	$root xbps-install -y zsh zsh-autosuggestions zsh-syntax-highlighting
	$root usermod -s /usr/bin/zsh $(id -un)
	;;

	0) continue ;;
esac

# (06) Configure a graphical environment

echo; read -p "Do you want to configure a graphical environment? (y) " linuxgui
case $linuxgui in
	y )
	echo; echo "${bold}*** Installing Xorg ***${none}"; echo

	$root xbps-install -y xorg-minimal mesa-dri

	echo; echo "(1) German\n(2) English (US)\n(3) English (UK)\n(4) French\n(5) Italian\n(6) Swedish\n(7) Norwegian"
	echo; read -p "Select a keyboard layout: " xkb
	case $xkb in
		1 ) continue ;;

		2 )
		sed -i 's/"de"/"us"/' xorg.conf.d/00-keyboard.conf
		;;

		3 )
		sed -i 's/"de"/"gb"/' xorg.conf.d/00-keyboard.conf
		;;

		4 )
		sed -i 's/"de"/"fr"/' xorg.conf.d/00-keyboard.conf
		;;

		5 )
		sed -i 's/"de"/"it"/' xorg.conf.d/00-keyboard.conf
		;;

		6 )
		sed -i 's/"de"/"se"/' xorg.conf.d/00-keyboard.conf
		;;

		7 )
		sed -i 's/"de"/"no"/' xorg.conf.d/00-keyboard.conf
		;;
	esac

	$root cp -r xorg.conf.d /etc/X11/

	# (07) Install a desktop environment

	echo; read -p "Do you want to install a desktop environment? (y) " desktopenv
	case $desktopenv in
		y )

		echo "(1) Xfce\n(2) MATE\n(3) GNOME\n(4) KDE Plasma\n(5) Budgie\n(6) Cinnamon\n(7) LXQt\n(0) None"

		echo; read -p "Which desktop do you want to install? " desktop
		case $desktop in
			1 )
			echo; echo "${bold}*** Installing Xfce ***${none}"; echo

			$root xbps-install -y xfce4-appfinder xfce4-battery-plugin xfce4-clipman-plugin xfce4-cpufreq-plugin \
				xfce4-cpugraph-plugin xfce4-dict xfce4-diskperf-plugin xfce4-fsguard-plugin xfce4-genmon-plugin \
				xfce4-notifyd xfce4-panel xfce4-panel-appmenu xfce4-places-plugin xfce4-power-manager \
				xfce4-pulseaudio-plugin xfce4-screensaver xfce4-screenshooter xfce4-session xfce4-settings \
				xfce4-taskmanager xfce4-terminal xfce4-whiskermenu-plugin xfce4-xkb-plugin Thunar thunar-volman \
				thunar-archive-plugin thunar-media-tags-plugin ristretto xarchiver mousepad xfwm4 xfdesktop \
				zathura zathura-pdf-poppler gvfs gvfs-mtp gvfs-gphoto2 xfce-polkit parole lightdm \
				lightdm-gtk3-greeter
			;;

			2 )
			echo; echo "${bold}*** Installing MATE ***${none}"; echo

			$root xbps-install -y mate-applets mate-backgrounds mate-calc mate-control-center mate-desktop \
				mate-icon-theme mate-indicator-applet mate-media mate-menus mate-notification-daemon \
				mate-panel mate-panel-appmenu mate-screensaver mate-session-manager mate-settings-daemon \
				mate-system-monitor mate-terminal mate-themes mate-tweak mate-utils mozo pluma caja \
				caja-image-converter caja-sendto caja-wallpaper caja-xattr-tags eom atril gvfs gvfs-mtp \
				gvfs-gphoto2 engrampa mate-power-manager mate-polkit lightdm lightdm-gtk3-greeter
			;;

			3 )
			echo; echo "${bold}*** Installing GNOME ***${none}"; echo

			$root xbps-install -y gnome-backgrounds gnome-calculator gnome-calendar gnome-characters \
				gnome-console gnome-control-center gnome-disk-utility gnome-screenshot gnome-session \
				gnome-shell gnome-system-monitor gnome-video-effects nautilus nautilus-sendto sushi gdm \
				evince eog eog-plugins gnome-text-editor
			;;

			4 )
			echo; echo "${bold}*** Installing KDE Plasma ***${none}"; echo

			$root xbps-install -y plasma-desktop plasma-disks plasma-firewall plasma-nm plasma-pa \
				plasma-systemmonitor plasma-thunderbolt plasma-wayland-protocols bluedevil breeze-gtk \
				dolphin gwenview okular ark kde-gtk-config5 kdegraphics-thumbnailers kdeplasma-addons5 \
				kgamma5 khelpcenter kinfocenter konsole kscreen kwalletmanager spectacle sddm-kcm sddm
			;;

			5 )
			echo; echo "${bold}*** Installing Budgie ***${none}"; echo

			$root xbps-install -y budgie-desktop budgie-control-center budgie-desktop-view \
				budgie-screensaver gnome-backgrounds gnome-terminal nautilus nautilus-sendto sushi \
			   	lightdm lightdm-gtk3-greeter gnome-system-monitor gnome-calculator gnome-calendar \
				gnome-characters gnome-disk-utility gedit gedit-plugins eog eog-plugins evince
			;;

			6 )
			echo; echo "${bold}*** Installing Cinnamon ***${none}"; echo

			$root xbps-install -y cinnamon nemo nemo-compare nemo-fileroller nemo-image-converter \
				nemo-preview gnome-system-monitor gnome-terminal gnome-screenshot gnome-disk-utility \
				gnome-keyring evince gvfs gvfs-mtp gvfs-gphoto2 file-roller gedit gedit-plugins \
				eog eog-plugins lightdm lightdm-gtk3-greeter
			;;

			7 )
			echo; echo "${bold}*** Installing LXQt ***${none}"; echo

			$root xbps-install -y lxqt-about lxqt-admin lxqt-archiver lxqt-build-tools lxqt-config \
				lxqt-globalkeys lxqt-openssh-askpass lxqt-panel lxqt-policykit lxqt-powermanagement \
				lxqt-qtplugin lxqt-runner lxqt-session lxqt-sudo lxqt-themes obconf-qt openbox \
				pcmanfm-qt lximage-qt FeatherPad qlipper qterminal lxqt-notificationd sddm
			;;

			0 ) continue ;;
		esac
		;;
	esac

	# (08) Install a window manager

	echo; read -p "Do you want to install a window manager? (y) " wman
	case $wman in
		y )

		echo "(1) i3wm (Xorg)\n(2) Openbox (Xorg)\n(3) Fluxbox (Xorg)\n(4) Bspwm (Xorg)\n(5) Herbstluftwm (Xorg)\n(6) IceWM (Xorg)\n(7) Awesome (Xorg)\n(8) JWM (Xorg)\n(9) DWM (Xorg)\n(10) Qtile (Xorg)\n(11) Sway (Wayland)\n(12) Wayfire (Wayland)\n(0) None"

		read -p "Which window manager do you want to install? " windowmanager
		case $windowmanager in
			1 )
			echo; echo "${bold}*** Installing i3wm ***${none}"; echo

			$root xbps-install -y i3 i3lock i3status dunst dmenu feh Thunar thunar-volman \
				thunar-archive-plugin thunar-media-tags-plugin xarchiver lm_sensors acpi \
				playerctl scrot htop arandr gvfs gvfs-mtp gvfs-gphoto2 xfce4-taskmanager \
				viewnior
			;;

			2 )
			echo; echo "${bold}*** Installing Openbox ***${none}"; echo

			$root xbps-install -y openbox obconf lxappearance dunst feh arandr pcmanfm \
				gvfs gvfs-mtp gvfs-gphoto2 lxtask scrot htop xarchiver viewnior
			;;

			3 )
			echo; echo "${bold}*** Installing Fluxbox ***${none}"; echo

			$root xbps-install -y fluxbox dunst feh arandr Thunar thunar-volman \
				thunar-archive-plugin thunar-media-tags-plugin gvfs gvfs-mtp gvfs-gphoto2 \
				scrot htop xarchiver viewnior
			;;

			4 )
			echo; echo "${bold}*** Installing Bspwm ***${none}"; echo

			$root xbps-install -y bspwm sxhkd dunst feh dmenu arandr Thunar thunar-volman \
				thunar-archive-plugin thunar-media-tags-plugin gvfs gvfs-mtp gvfs-gphoto2 \
				scrot htop xarchiver viewnior
			;;

			5 )
			echo; echo "${bold}*** Installing Herbstluftwm ***${none}"; echo

			$root xbps-install -y herbstluftwm dunst feh dmenu arandr Thunar thunar-volman \
				thunar-archive-plugin thunar-media-tags-plugin gvfs gvfs-mtp gvfs-gphoto2 \
				scrot htop xarchiver viewnior
			;;

			6 )
			echo; echo "${bold}*** Installing IceWM ***${none}"; echo

			$root xbps-install -y icewm dunst feh dmenu arandr Thunar thunar-volman \
				thunar-archive-plugin thunar-media-tags-plugin gvfs gvfs-mtp gvfs-gphoto2 \
				scrot htop xarchiver viewnior
			;;

			7 )
			echo; echo "${bold}*** Installing Awesome ***${none}"; echo

			$root xbps-install -y awesome vicious dunst feh arandr Thunar thunar-volman \
				thunar-archive-plugin thunar-media-tags-plugin gvfs gvfs-mtp gvfs-gphoto2 \
				scrot htop xarchiver viewnior
			;;

			8 )
			echo; echo "${bold}*** Installing JWM ***${none}"; echo

			$root xbps-install -y jwm dunst feh dmenu arandr Thunar thunar-volman \
				thunar-archive-plugin thunar-media-tags-plugin gvfs gvfs-mtp gvfs-gphoto2 \
				scrot htop xarchiver viewnior
			;;

			9 )
			echo; echo "${bold}*** Installing DWM ***${none}"; echo

			$root xbps-install -y dwm dunst feh dmenu arandr Thunar thunar-volman \
				thunar-archive-plugin thunar-media-tags-plugin gvfs gvfs-mtp gvfs-gphoto2 \
				scrot htop xarchiver viewnior
			;;

			10 )
			echo; echo "${bold}*** Installing Qtile ***${none}"; echo

			$root xbps-install -y python3 python3-pip python3-setuptools python3-wheel \
				python3-virtualenv-clone python3-dbus python3-gobject pango pango-devel \
				libffi-devel xcb-util-cursor gdk-pixbuf

			pip install qtile

			$root xbps-install -y feh arandr Thunar thunar-volman thunar-archive-plugin \
				thunar-media-tags-plugin gvfs gvfs-mtp gvfs-gphoto2 scrot htop xarchiver \
				viewnior
			;;

			11 )
			echo; echo "${bold}*** Installing Sway ***${none}"; echo

			$root xbps-install -y sway swaybg swayidle swaylock azote grimshot \
				Waybar gvfs gvfs-mtp gvfs-gphoto2 htop wofi wayclip
			;;

			12 )
			echo; echo "${bold}*** Installing Wayfire ***${none}"; echo

			$root xbps-install -y wayfire grim gvfs gvfs-mtp gvfs-gphoto2 htop wofi \
				azote wayclip shotman
			;;

			0) continue ;;
		esac
		;;
	esac

	#
	# (09) Install a terminal emulator
	#

	echo; echo "${bold}*** Installing a terminal emulator ***${none}"; echo

	echo "(1) Alacritty\n(2) XTerm\n(3) LXTerminal\n(4) Yakuake\n(5) Sakura\n(6) Kitty\n(0) None"

	echo; read -p "Which terminal emulator do you want to install? " terminal
	case $terminal in
		1 )
		echo; echo "${bold}*** Installing Alacritty ***${none}"; echo

		$root xbps-install -y alacritty alacritty-terminfo
		;;

		2 )
		echo; echo "${bold}*** Installing XTerm ***${none}"; echo

		$root xbps-install -y xterm
		;;

		3 )
		echo; echo "${bold}*** Installing LXTerminal ***${none}"; echo

		$root xbps-install -y lxterminal
		;;

		4 )
		echo; echo "${bold}*** Installing Yakuake ***${none}"; echo

		$root xbps-install -y yakuake
		;;

		5 )
		echo; echo "${bold}*** Installing Sakura ***${none}"; echo

		$root xbps-install -y sakura
		;;

		6 )
		echo; echo "${bold}*** Installing Kitty ***${none}"; echo

		$root xbps-install -y kitty kitty-terminfo
		;;

		0 ) continue ;;
	esac

	#
	# (10) Install a terminal text editor
	#

	echo; echo "${bold}*** Installing a terminal text editor ***${none}"; echo

	echo "(1) Emacs\n(2) Micro\n(3) Vim\n(4) Neovim\n(5) Joe\n(0) None"

	echo; read -p "Which terminal text editor do you want to install? " editor
	case $editor in
		1 )
		echo; echo "${bold}*** Installing Emacs NOX ***${none}"; echo

		$root xbps-install -y emacs
		;;

		2 )
		echo; echo "${bold}*** Installing Micro ***${none}"; echo

		$root xbps-install -y micro
		;;

		3 )
		echo; echo "${bold}*** Installing Vim ***${none}"; echo

		$root xbps-install -y vim
		;;

		4)
		echo; echo "${bold}*** Installing Neovim ***${none}"; echo

		$root xbps-install -y neovim
		;;

		5 )
		echo; echo "${bold}*** Installing Joe ***${none}"; echo

		$root xbps-install -y joe
		;;

		0 ) continue ;;
	esac

	#
	# (11) Install a graphical text editor
	#

	echo; echo "${bold}*** Installing a graphical text editor ***${none}"; echo

	echo "(1) Geany\n(2) Gedit\n(3) Kate\n(4) LeafPad\n(5) Mousepad\n(6) Code-OSS\n(7) Notepadqq\n(8) Bluefish\n(9) Emacs gtk3\n(10) Emacs x11\n(11) Qemacs\n(12) Vile\n(13) Zile\n(14) Gvim\n(15) Kakoune\n(0) None"

	echo; read -p "Which graphical text editor do you want to install? " geditor
	case $geditor in
		1 )
		echo; echo "${bold}*** Installing Geany ***${none}"; echo

		$root xbps-install -y geany geany-plugins geany-plugins-extra
		;;

		2 )
		echo; echo "${bold}*** Installing Gedit ***${none}"; echo

		$root xbps-install -y gedit gedit-plugins
		;;

		3 )
		echo; echo "${bold}*** Installing Kate ***${none}"; echo

		$root xbps-install -y kate5
		;;

		4 )
		echo; echo "${bold}*** Installing LeafPad ***${none}"; echo

		$root xbps-install -y leafpad
		;;

		5 )
		echo; echo "${bold}*** Installing Mousepad ***${none}"; echo

		$root xbps-install -y mousepad
		;;

		6 )
		echo; echo "${bold}*** Installing VSCodium ***${none}"; echo

		$root xbps-install -y vscode
		;;

		7 )
		echo; echo "${bold}*** Installing Notepadqq ***${none}"; echo

		$root xbps-install -y notepadqq
		;;

		8 )
		echo; echo "${bold}*** Installing Bluefish ***${none}"; echo

		$root xbps-install -y bluefish
		;;

		9 )
		echo; echo "${bold}*** Installing the GTK3 version of Emacs ***${none}"; echo

		$root xbps-install -y emacs-gtk3
		;;

		10 )
		echo; echo "${bold}*** Installing the X11 version of Emacs ***${none}"; echo

		$root xbps-install -y emacs-x11
		;;

		11 )
		echo; echo "${bold}*** Installing QEmacs ***${none}"; echo

		$root xbps-install -y qemacs
		;;

		12 )
		echo; echo "${bold}*** Installing Vile ***${none}"; echo

		$root xbps-install -y vile
		;;

		13 )
		echo; echo "${bold}*** Installing Zile ***${none}"; echo

		$root xbps-install -y zile
		;;

		14 )
		echo; echo "${bold}*** Installing GVim ***${none}"; echo

		$root xbps-install -y gvim
		;;

		15 )
		echo; echo "${bold}*** Installing Kakoune ***${none}"; echo

		$root xbps-install -y kakoune
		;;

		0 ) continue ;;
	esac

	#
	# (12) Install a web browser
	#

	echo; echo "${bold}*** Installing a web browser ***${none}"; echo

	echo "(1) Firefox\n(2) Firefox ESR\n(3) Chromium\n(4) qutebrowser\n(5) Falkon\n(6) Epiphany\n(7) Badwolf\n(0) None"

	echo; read -p "Which web browser do you want to install? " browser
	case $browser in
		1 )
		echo; echo "${bold}*** Installing Firefox ***${none}"; echo

		$root xbps-install -y firefox firefox-i18n-en-US firefox-i18n-de
		;;

		2 )
		echo; echo "${bold}*** Installing Firefox ESR ***${none}"; echo

		$root xbps-install -y firefox-esr firefox-esr-i18n-en-US firefox-esr-i18n-de
		;;

		3 )
		echo; echo "${bold}*** Installing Chromium ***${none}"; echo

		$root xbps-install -y chromium
		;;

		4 )
		echo; echo "${bold}*** Installing Qutebrowser ***${none}"; echo

		$root xbps-install -y qutebrowser
		;;

		5 )
		echo; echo "${bold}*** Installing Falkon ***${none}"; echo

		$root xbps-install -y falkon
		;;

		6 )
		echo; echo "${bold}*** Installing Epiphany ***${none}"; echo

		$root xbps-install -y epiphany
		;;

		7 )
		echo; echo "${bold}*** Installing Badwolf ***${none}"; echo

		$root xbps-install -y badwolf
		;;

		0 ) continue ;;
	esac

	#
	# (13) Install a media player
	#

	echo; echo "${bold}*** Installing a media player ***${none}"; echo

	echo "(1) mpv\n(2) VLC Media Player\n(3) Parole (from Xfce)\n(4) Totem (from GNOME)\n(5) Dragon Player (from KDE)\n(0) None"

	echo; read -p "Which media player do you want install? " mediaplayer
	case $mediaplayer in
		1 )
		echo; echo "${bold}*** Installing mpv ***${none}"; echo

		$root xbps-install -y mpv
		;;

		2 )
		echo; echo "${bold}*** Installing VLC Media Player ***${none}"; echo

		$root xbps-install -y vlc
		;;

		3 )
		echo; echo "${bold}*** Installing Parole ***${none}"; echo

		$root xbps-install -y parole
		;;

		4 )
		echo; echo "${bold}*** Installing Totem ***${none}"; echo

		$root xbps-install -y totem
		;;

		5 )
		echo; echo "${bold}*** Installing Dragon Player ***${none}"; echo

		$root xbps-install -y dragon-player
		;;

		0 ) continue ;;
	esac

	#
	# (14) Install an office suite
	#

	echo; echo "${bold}*** Installing an office suite ***${none}"; echo

	echo "(1) LibreOffice (GTK)\n(2) LibreOffice (Qt)\n(3) OnlyOffice (Flatpak)\n(0) None"

	echo; read -p "Which office suite do you want to install? " officesuite
	case $officesuite in
		1 )
		echo; echo "${bold}*** Installing LibreOffice (GTK) ***${none}"; echo

		$root xbps-install -y libreoffice-writer libreoffice-calc libreoffice-impress \
			libreoffice-draw libreoffice-gnome
		;;

		2 )
		echo; echo "${bold}*** Installing LibreOffice (Qt) ***${none}"; echo

		$root xbps-install -y libreoffice-writer libreoffice-calc libreoffice-impress \
			libreoffice-draw libreoffice-kde
		;;

		3 )
		echo; echo "${bold}*** Installing OnlyOffice ***${none}"; echo

		$root flatpak install org.onlyoffice.desktopeditors
		;;
	esac

	#
	# (15) Install graphic design programs
	#

	echo; echo "${bold}*** Installing graphic design programs ***${none}"; echo

	echo "(1) GIMP\n(2) Inkscape\n(3) Krita\n(4) GIMP + Inkscape\n(5) Krita + Inkscape\n(0) None"

	echo; read -p "Which graphic design programs do you want to install? " graphic
	case $graphic in
		1 )
		echo; echo "${bold}*** Installing GIMP ***${none}"; echo

		$root xbps-install -y gimp
		;;

		2 )
		echo; echo "${bold}*** Installing Inkscape ***${none}"; echo

		$root xbps-install -y inkscape
		;;

		3 )
		echo; echo "${bold}*** Installing Krita ***${none}"; echo

		$root xbps-install -y krita
		;;

		4 )
		echo; echo "${bold}*** Installing GIMP and Inkscape ***${none}"; echo

		$root xbps-install -y gimp inkscape
		;;

		5 )
		echo; echo "${bold}*** Installing Krita + Inkscape ***${none}"; echo

		$root xbps-install -y krita inkscape
		;;

		0 ) continue ;;
	esac

	#
	# (16) Install container or virtual machine programs
	#

	echo; echo "${bold}*** Installing container or virtual machine programs ***${none}"; echo

	echo "(1) QEMU + Virt Manager\n(2) QEMU (without GUI)\n(3) Docker\n(4) Kubernetes\n(5) Docker + Kubernetes\n(6) Linux Containers (LXC/LXD)\n(0) None"

	echo; read -p "Which container or virtual machine program do you want to install? " virtcnt
	case $virtcnt in
		1 )
		echo; echo "${bold}*** Installing QEMU + Virt Manager ***${none}"; echo

		$root xbps-install -y qemu libvirt virt-manager virt-manager-tools
		;;

		2 )
		echo; echo "${bold}*** Installing QEMU (without GUI) ***${none}"; echo

		$root xbps-install -y qemu libvirt
		;;

		3 )
		echo; echo "${bold}*** Installing Docker ***${none}"; echo

		$root xbps-install -y docker docker-cli
		;;

		4 )
		echo; echo "${bold}*** Installing Kubernetes ***${none}"; echo

		$root xbps-install -y kubernetes
		;;

		5 )
		echo; echo "${bold}*** Installing Docker and Kubernetes ***${none}"; echo

		$root xbps-install -y docker docker-cli kubernetes
		;;

		6 )
		echo; echo "${bold}*** Installing Linux Containers (LXC/LXD) ***${none}"; echo

		$root xbps-install -y lxc lxd
		;;

		0 ) continue ;;
	esac

	#
	# (17) Install a backup program
	#

	echo; echo "${bold}*** Installing a backup program ***${none}"; echo

	echo "(1) Borg Backup\n(2) Timeshift\n(3) Deja-dup\n(0) None"

	echo; read -p "Which backup program do you want to install? " backup
	case $backup in
		1 )
		echo; echo "${bold}*** Installing Borg Backup ***${none}"; echo

		$root xbps-install -y borg
		;;

		2 )
		echo; echo "${bold}*** Installing Timeshift ***${none}"; echo

		$root xbps-install -y timeshift
		;;

		3 )
		echo; echo "${bold}*** Installing Deja-dup ***${none}"; echo

		$root xbps-install -y deja-dup
		;;

		0 ) continue ;;
	esac
	;;
esac

#
# (19) Configure audio
#

echo; echo "${bold}*** Configuring Audio ***${none}"; echo

echo "(1) ALSA\n(2) PulseAudio\n(3) Pipewire\n(0) None"

echo; read -p "Which audio software do you want to install? " audio
case $audio in
	1 )
	echo; echo "${bold}*** Configuring ALSA ***${none}"; echo

	$root xbps-install -y alsa-utils apulse
	$root usermod -aG audio $(id -un)
	;;

	2 )
	echo; echo "${bold}*** Installing PulseAudio ***${none}"; echo

	$root xbps-install -y pulseaudio pulseaudio-utils pamixer alsa-plugins-pulseaudio
	$root usermod -aG audio $(id -un)
	;;

	3 )
	echo; echo "${bold}*** Installing PipeWire ***${none}"; echo

	$root xbps-install -y pipewire wireplumber libspa-bluetooth

	$root mkdir -p /etc/pipewire/pipewire.conf.d
	$root ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
	$root ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
	;;

	0 ) continue ;;
esac

#
# (20) Configure network management
#

echo; echo "${bold}*** Configuring network management ***${none}"; echo

echo "(1) Network Manager\n(2) dhcpcd + wpa_supplicant\n(3) dhcpcd + IWD\n(0) None"

echo; read -p "Which network management software do you want to install? " netmngmt
case $netmngmt in
	1 )
	echo; echo "${bold}*** Installing Network Manager ***${none}"; echo

	$root xbps-install -y NetworkManager
	;;

	2 )
	echo; echo "${bold}*** Installing dhcpcd + wpa_supplicant ***${none}"; echo

	$root xbps-install -y dhcpcd wpa_supplicant
	;;

	3 )
	echo; echo "${bold}*** Installing dhcpcd + IWD ***${none}"; echo

	$root xbps-install -y dhcpcd iwd
	;;

	0 ) continue ;;
esac

#
# (21) Configure Bluetooth
#

echo; read -p "Do you want to configure Bluetooth? (y) " bluetooth
case $bluetooth in
	y )
	echo; echo "${bold}*** Installing Bluez ***${none}"; echo

	$root xbps-install -y bluez
	$root usermod -aG bluetooth $(id -un)

	echo; read -p "Do you want to manage Bluetooth devices graphically? (y) " bluetoothgui
	case $bluetoothgui in
		y )
		echo; echo "${bold}*** Installing Blueman ***${none}"; echo

		$root xbps-install -y blueman
		;;
	esac
	;;
esac

#
# (22) Configure Printing
#

echo; read -p "Do you want to install software needed for printing? (y) " printer
case $printer in
	y )
	echo; echo "${bold}*** Installing CUPS ***${none}"; echo

	$root xbps-install -y cups cups-pk-helper cups-pdf cups-filters
	$root usermod -aG lpadmin $(id -un)

	echo; read -p "Do you have a HP printer? (y) " hpprinter
	case $hpprinter in
		y )
		echo; echo "${bold}*** Installing HPLIP ***${none}"; echo

		$root xbps-install -y hplip
		;;
	esac

	echo; read -p "Do you have a Samsung or Xerox printer? (y) " smprinter
	case $smprinter in
		y )
		echo; echo "${bold}*** Installing Splix ***${none}"; echo

		$root xbps-install -y splix
		;;
	esac
	;;
esac

#
# (23) Configure Notebook Power Saving
#

echo; read -p "Do you use Void Linux on a notebook? (y) " notebook
case $notebook in
	y )
	echo; echo "${bold}*** Installing TLP for power saving ***${none}"; echo

	$root xbps-install -y tlp
	;;
esac

#
# (24) Configure NFS for sharing files
#

echo; read -p "Do you want to install NFS for file sharing? (y) " nfs
case $nfs in
	y )
	echo; echo "${bold}*** Installing NFS support ***${none}"; echo

	$root xbps-install nfs-utils sv-netmount
	;;

esac

#
# (25) Enable services
#

if [ -d /etc/sv/dbus ]; then
	if [ ! -L /var/service/dbus ]; then
		echo; echo "${magenta}*** Enabling D-Bus service ***${none}"; echo
		$root ln -sv /etc/sv/dbus /var/service/
	fi
fi

if [ -d /etc/sv/NetworkManager ]; then
	if [ ! -L /var/service/NetworkManager ]; then
		echo; echo "${magenta}*** Enabling NetworkManager service ***${none}"; echo
		$root ln -sv /etc/sv/NetworkManager /var/service/
	fi
fi

if [ -d /etc/sv/iwd ]; then
	if [ -L /etc/sv/wpa_supplicant ]; then
		$root rm /var/service/wpa_supplicant
	fi

	if [ ! -L /var/service/iwd ]; then
		echo; echo "${magenta}*** Enabling IWD service ***${none}"; echo
		$root ln -sv /etc/sv/iwd /var/service/
	fi
fi

if [ -d /etc/sv/bluetoothd ]; then
	if [ ! -L /var/service/bluetoothd ]; then
		echo; echo "${magenta}*** Enabling Bluetooth service ***${none}"; echo
		$root ln -sv /etc/sv/bluetoothd /var/service/
	fi
fi

if [ -d /etc/sv/cupsd ]; then
	if [ ! -L /var/service/cupsd ]; then
		echo; echo "${magenta}*** Enabling CUPS service ***${none}"; echo
		$root ln -sv /etc/sv/cupsd /var/service/
	fi
fi

if [ -d /etc/sv/smartd ]; then
	if [ ! -L /var/service/smartd ]; then
		echo; echo "${magenta}*** Enabling S.M.A.R.T service ***${none}"; echo
		$root ln -sv /etc/sv/smartd /var/service/
	fi
fi

if [ -d /etc/sv/tlp ]; then
	if [ ! -L /var/service/tlp ]; then
		echo; echo "${magenta}*** Enabling TLP service ***${none}"; echo
		$root ln -sv /etc/sv/tlp /var/service/
	fi
fi

if [ -d /etc/sv/statd ]; then
	if [ ! -L /var/service/statd ]; then
		echo; echo "${magenta}*** Enabling statd service ***${none}"; echo
		$root ln -sv /etc/sv/statd /var/service/
	fi
fi

if [ -d /etc/sv/rpcbind ]; then
	if [ ! -L /var/service/rpcbind ]; then
		echo; echo "${magenta}*** Enabling rpcbind service ***${none}"; echo
		$root ln -sv /etc/sv/rpcbind /var/service/
	fi
fi

if [ -d /etc/sv/netmount ]; then
	if [ ! -L /var/service/netmount ]; then
		echo; echo "${magenta}*** Enabling netmount service ***${none}"; echo
		$root ln -sv /etc/sv/netmount /var/service/
	fi
fi

if [ -d /etc/sv/lightdm ]; then
	if [ ! -L /var/service/lightdm ]; then
		echo; echo "${magenta}*** Enabling LightDM service ***${none}"; echo
		$root ln -sv /etc/sv/lightdm /var/service/
	fi
fi

if [ -d /etc/sv/sddm ]; then
	if [ ! -L /var/service/sddm ]; then
		echo; echo "${magenta}*** Enabling SDDM service ***${none}"; echo
		$root ln -sv /etc/sv/sddm /var/service/
	fi
fi

if [ -d /etc/sv/gdm ]; then
	if [ ! -L /var/service/gdm ]; then
		echo; echo "${magenta}*** Enabling GDM service ***${none}"; echo
		$root ln -sv /etc/sv/gdm /var/service/
	fi
fi

echo; echo "${bold}*** CONFIGURATION FINISHED. ENJOY VOID LINUX :) ***${none}"
