#!/usr/bin/env bash

echo -e "\nINSTALLING AUR SOFTWARE\n"

echo "INSTALLING: YAY"
pacman -U /root/aur/*.pkg.tar.zst

PKGS=()

yay -Sy

for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done
