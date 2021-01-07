#!/bin/bash

PKGS=(

    # --- XORG Display Rendering
        'xorg'                  # Base Package
        'xterm'                 # Terminal for TTY
        'xorg-server'           # XOrg server
        'xorg-apps'             # XOrg apps group
        'xorg-xinit'            # XOrg init
        'xorg-xinput'           # Xorg xinput
        'mesa'                  # Open source version of OpenGL

    # --- Setup Desktop
        'plasma-desktop'               # KDE Plasma Desktop
        'plasma-wayland-session'    
		'plasma-wayland-protocols' 
		'xclip'                 # System Clipboard

    # --- Setup Desktop Apps
        'breeze-gtk'
		'calibre'
        'discover'
        'drkonqi'
        'kde-gtk-config'
        'kgamma5'
        'khotkeys'
        'kinfocenter'
        'ksysguard'
        'kwayland-integration'
        'kwrited'
        'plasma-browser-integration'
        'plasma-disks'
        'plasma-workspace-wallpapers'

    # --- Login Display Manager
        'grub'
	    'sddm'                   # Base Login Manager
        'sddm-kcm'
    # --- Networking Setup
        'plasma-nm'
	    'wpa_supplicant'            # Key negotiation for WPA wireless networks
        'dialog'                    # Enables shell scripts to trigger dialog boxex
    
    # --- Audio
        'alsa-utils'        # Advanced Linux Sound Architecture (ALSA) Components https://alsa.opensrc.org/
        'alsa-plugins'      # ALSA plugins
		'clementine'
        'pulseaudio'        # Pulse Audio sound components
        'pulseaudio-alsa'   # ALSA configuration for pulse audio
        'pavucontrol'       # Pulse Audio volume control
        'pnmixer'           # System tray volume control

    # --- Bluetooth
        'bluez'                 # Daemons for the bluetooth protocol stack
        'bluez-utils'           # Bluetooth development and debugging utilities
        'bluez-firmware'        # Firmwares for Broadcom BCM203x and STLC2300 Bluetooth chips
        'blueberry'             # Bluetooth configuration tool
        'pulseaudio-bluetooth'  # Bluetooth support for PulseAudio
    
    # --- Printers
        'avahi'
        'cups'                  # Open source printer drivers
        'cups-pdf'              # PDF support for cups
        'ghostscript'           # PostScript interpreter
        'gsfonts'               # Adobe Postscript replacement fonts
        'hplip'                 # HP Drivers
		'nss-mdns'
        'system-config-printer' # Printer setup  utility

    # SYSTEM --------------------------------------------------------------

    'linux-lts'             # Long term support kernel

    # KDE APPS ------------------------------------------------------------
    
	'ark'
    'audiocd-kio'
    'cantor'
    'cervisia'
    'dolphin'
    'dolphin-plugins'
    'ffmpegthumbs'
    'filelight'
    'gwenview'
    'k3b'
    'kaddressbook'
    'kalarm'
    'kalgebra'
    'kamera'
    'kamoso'
    'kcalc'
    'kcolorchooser'
    'kcron'
    'kdeconnect'
    'kdeplasma-addons'
    'kdialog'
    'keditbookmarks'
    'kfind'
    'kget'
    'kgpg'
    'kipi-plugins'
    'kmail'
    'konsole'
    'kontact'
    'korganizer'
    'ksystemlog'
    'ktimer'
    'okular'
    'partitionmanager'
    'spectacle'
    'svgpart'
    'sweeper'
    'telepathy-kde-send-file'
    'zeroconf-ioslave'

    # PRODUCTIVITY --------------------------------------------------------

    'libreoffice-still'
    'firefox'

    # TERMINAL UTILITIES --------------------------------------------------

    'bash-completion'       # Tab completion for Bash
    'cronie'                # cron jobs
    'curl'                  # Remote content retrieval
    'gtop'                  # System monitoring via terminal
    'htop'                  # Process viewer
    'neofetch'              # Shows system info when you launch terminal
    'ntp'                   # Network Time Protocol to set time via network.
    'numlockx'              # Turns on numlock in X11
    'openssh'               # SSH connectivity tools
    'p7zip'                 # 7z compression program
	'reflector'
    'rsync'                 # Remote file sync utility
    'speedtest-cli'         # Internet speed via terminal
    'terminus-font'         # Font package with some bigger fonts for login terminal
    'tlp'                   # Advanced laptop power management
    'unrar'                 # RAR compression program
    'unzip'                 # Zip compression program
    'wget'                  # Remote content retrieval
    'vim'                   # Terminal Editor
    'zip'                   # Zip compression program
    'zsh'                   # ZSH shell
    'zsh-completions'       # Tab completion for ZSH

    # DISK UTILITIES ------------------------------------------------------

    'autofs'                # Auto-mounter
    'dosfstools'            # DOS Support
    'exfat-utils'           # Mount exFat drives
    'gparted'               # Disk utility
    'ntfs-3g'               # Open source implementation of NTFS file system
    'parted'                # Disk utility
    'samba'                 # Samba File Sharing
    'smartmontools'         # Disk Monitoring

    # GENERAL UTILITIES ---------------------------------------------------

	'vscode'

    # DEVELOPMENT ---------------------------------------------------------

    'gedit'                 # Text editor
    'clang'                 # C Lang compiler
    'cmake'                 # Cross-platform open-source make system
    'code'                  # Visual Studio Code
    'electron'              # Cross-platform development using Javascript
    'git'                   # Version control system
    'gcc'                   # C/C++ compiler
    'glibc'                 # C libraries
    'python'                # Scripting language

    # MEDIA ---------------------------------------------------------------

    'kdenlive'              # Movie Render
    'vlc'

    # GRAPHICS AND DESIGN -------------------------------------------------

    'gcolor2'               # Colorpicker
    'gimp'                  # GNU Image Manipulation Program

    # PRODUCTIVITY --------------------------------------------------------

    'hunspell'              # Spellcheck libraries
    'hunspell-en'           # English spellcheck library

	# WINE ----------------------------------------------------------------

	'wine-staging'
	'winetricks'
)

# Install packages
pacman -Sy

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

#pacman -S --needed - < /root/pkg/core
#pacman -S --needed - < /root/pkg/base
#pacman -S --needed - < /root/pkg/base-kde
#pacman -S --needed - < /root/pkg/fonts

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have " $nc" cores."
echo "-------------------------------------------------"
echo "Changing the makeflags for "$nc" cores."
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf

# Configure Time/Lang
ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime
hwclock --systohc
sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone America/Chicago
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_COLLATE="" LC_TIME="en_US.UTF-8"
localectl --no-ask-password set-keymap us

printf "\nEnter Hostname: "
read hostname
echo $hostname >> /etc/hostname

printf "Set root(admin) password\n"
passwd

printf "Enter CPU Provider (intel/AMD): "
read CPU

# install microcode updates
if [[ $CPU = "intel" ]]; then
        pacman -S intel-ucode
elif [[$CPU = "AMD" ]]; then
        pacman -S amd-ucode
fi

# Configure Bootloader
printf "\nEFI or MBR: "
read boot

if [[ $boot = "EFI" ]]; then
        printf "Enter efi directory: "
        read efi_dir
        grub-install --target=x86_64-efi --efi-directory=$efi_dir --bootloader-id=GRUB
elif [[ $boot = "MBR" ]]; then
        printf "Enter root drive:\n"
        read root_part
        grub-install --target=i386-pc $root_part
fi
grub-mkconfig -o /boot/grub/grub.cfg

# Configure 
printf "Create Local Account:\n"
printf "Enter Username: \n"
read USER

#print("Enter Password: ")

useradd -m -G wheel -s /bin/bash $USER
passwd $USER
sed -i "/^root ALL=(ALL) ALL/a $USER ALL=(ALL) ALL" /etc/sudoers

pacman -U /root/aur/*.pkg.tar.zst

pacman -Syu

systemctl enable sddm
systemctl enable avahi-daemon
systemctl enable avahi-daemon.socket
systemctl enable bluetooth
systemctl enable cups
systemctl enable cups.socket
systemctl enable cups.path
systemctl enable NetworkManager
systemctl enable reflector
systemctl enable reflector.timer
