#!/bin/bash

cd src

# Build stock packages
for package in yay; do
    cd "${package}"
	git pull
	cd ..
done

# Build packages
for package in yay tela-grub; do
    cd "${package}"
	rm -v *.pkg.tar.zst
	makepkg -s
	mv -v *.pkg.tar.zst ../../aur
	cd ..
done
