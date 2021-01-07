#!/usr/bin/env bash

PKGS=(
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