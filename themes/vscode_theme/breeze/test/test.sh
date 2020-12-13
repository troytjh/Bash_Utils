#!/bin/bash

LINUX_CUSTOM=/home/troytjh/.cache/build/linux-mainline-custom

cd $LINUX_CUSTOM
#if [ -d linux-mainline ]; then
#	cd linux-mainline
#	git stash
#	git stash clear
#	git pull
#
#	cd src/linux-mainline
#	git stash
#	git stash clear
#	cd ../..
#else
#	git clone --depth 1 https://aur.archlinux.org/linux-mainline.git
#	cd linux-mainline
#fi
cd linux-mainline
pkgver=`awk '/^pkgver/ {print $1}' PKGBUILD | awk -F'=' '{print $2}'`
pkgrel=`awk '/^pkgrel/ {print $1}' PKGBUILD | awk -F'=' '{print $2}'`
srcname=linux-mainline-$pkgver
patch PKGBUILD < ../mkpkg.patch
patch -b config < ../config.patch
mkdir src
cp ../OpenRGB.patch .
sed -i 's/pkgbase=linux-mainline/pkgbase=linux-mainline-custom/g' PKGBUILD
updpkgsums

makepkg --verifysource

build () {
	printf "\nPackages to build\n\n"; printf "$srcname\n\n"
	printf "Build?[y,n] "
	read ans
	case $ans in 
		y|Y)    printf "\n";
			prepare
			makepkg -s;
			install ;;

       		n|N) 	printf "\n";
			clean ;;

       		*) 	printf "\n" ;;
	esac;
}

prepare () {
	pkgbase=`awk '/^pkgbase/ {print $1}' PKGBUILD | awk -F'=' '{print $2}'`
	pkgrel=`awk '/^pkgrel/ {print $1}' PKGBUILD | awk -F'=' '{print $2}'`
	sed -ie '/source=/a \ \ OpenRGB.patch' PKGBUILD
	updpkgsums
	
	cat PKGBUILD | awk '/^source/,/)/ {print $0}'
	echo ${source[@]}
	cd src/linux-mainline/

	local src
	for src in "${source[@]}"; do
	    src="${src%%::*}"
	    src="${src##*/}"
    	[[ $src = *.patch ]] || continue
    	echo "Applying patch $src..."
    	patch -Np1 < "../$src"
	done

	cd ../..
}

install () {
	printf "\nPackages to install\n\n" 
	echo `ls linux-mainline-custom-$pkgver-$pkgrel-x86_64.pkg.tar.zst | awk -F'-x86_64.pkg' '{print $1}'`; printf "\n";
	printf ":: Proceed with installation? [y,n] "
	read ans
	case $ans in 
		y|Y) 	printf "\n"; 
			yay -U linux-mainline-custom-$pkgver-$pkgrel-x86_64.pkg.tar.zst \
				linux-mainline-custom-headers-$pkgver-$pkgrel-x86_64.pkg.tar.zst;
			clean ;;

       		n|N) 	printf "\n" ;
			clean ;;

       		*) 	printf "\n" ;
			clean ;;
	esac;
}

clean () {
	printf "\nClean packages? [y,n] "
	read ans
	case $ans in 
		y|Y) 	printf "\n"; 
			rm *.pkg.tar.zst ;;
	
		*)	printf "\n" ;;
	esac;
}

build
