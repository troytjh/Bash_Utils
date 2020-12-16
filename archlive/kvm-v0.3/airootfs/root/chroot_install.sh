#!/bin/bash

# Install packages
pacman -Sy
pacman -S --needed - < /root/pkg/core
pacman -S --needed - < /root/pkg/base
pacman -S --needed - < /root/pkg/base-kde
pacman -S --needed - < /root/pkg/extra
pacman -S --needed - < /root/pkg/fonts

# Configure Time/Lang
ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime
hwclock --systohc
sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen
locale-gen

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
systemctl enable dhcpcd
systemctl enable reflector
systemctl enable reflector.timer
systemctl enable sshd
