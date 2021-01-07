#!/usr/bin/env bash

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