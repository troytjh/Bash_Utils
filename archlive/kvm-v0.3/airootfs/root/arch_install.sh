#!/bin/bash
MNT=/mnt

pacstrap /mnt base base-devel linux linux-firmware
sed -i "/\[multilib\]/,/Include/"'s/^#//' /mnt/etc/pacman.conf

cp -r /root/.ssh $MNT/root
cp -r /root/configs/* $MNT/

genfstab -U /mnt >> /mnt/etc/fstab

cp chroot_install.sh /mnt/root
cp -r pkg /mnt/root
cp -r aur /mnt/root
arch-chroot /mnt bash /root/chroot_install.sh

