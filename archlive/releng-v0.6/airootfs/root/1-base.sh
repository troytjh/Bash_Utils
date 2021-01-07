#!/usr/bin/env bash

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
        'plasma'
        'plasma-wayland-session'    
		'plasma-wayland-protocols'
	    'packagekit-qt5'	
		'xclip'                 # System Clipboard

    # --- Setup Desktop Apps
		'calibre'

    # --- Login Display Manager
        'efibootmgr'
        'grub'
	    'sddm'                   # Base Login Manager
    
    # --- Networking Setup
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
)

# Install packages
pacman -Sy

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

printf "\nEnter CPU Provider (intel/AMD): "
read CPU

# install microcode updates
if [[ $CPU = "intel" ]]; then
        pacman -S intel-ucode
elif [[$CPU = "AMD" ]]; then
        pacman -S amd-ucode
fi
