#!/usr/bin/env bash

RED='\033[0;31m'
NC='\033[0m'

if [ "$(stat -c %d:%i /)" == "$(stat -c %d:%i /proc/1/root/.)" ]; then
    if !(mountpoint /mnt &> /dev/null); then
                echo -e "${RED}Mount point /mnt does not exist${NC}"
                exit
	fi
    
    arch-chroot /mnt
fi

echo -e "\nINSTALLING AUR SOFTWARE\n"

cd "${HOME}"

echo "CLOING: YAY"
git clone "https://aur.archlinux.org/yay.git"

cd ${HOME}/yay
makepkg -si

PKGS=()

yay -Sy

for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done