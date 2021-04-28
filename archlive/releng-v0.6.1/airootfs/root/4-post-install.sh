#!/usr/bin/env bash

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

if !(grep -Fxq "$USER ALL=(ALL) ALL" /etc/sudoers)
then
    sed -i "/^root ALL=(ALL) ALL/a $USER ALL=(ALL) ALL" /etc/sudoers
fi
pacman -U /root/aur/*.pkg.tar.zst

pacman -Syu

systemctl enable sddm
systemctl enable avahi-daemon
systemctl enable bluetooth
systemctl enable cups
systemctl enable NetworkManager
systemctl enable reflector
systemctl enable reflector.timer
