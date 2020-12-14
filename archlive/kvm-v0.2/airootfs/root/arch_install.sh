#!/bin/bash
MNT=/mnt

pacstrap /mnt base base-devel linux linux-firmware
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /mnt/etc/pacman.conf

# Setup /etc configs
cp /etc/nsswitch.conf $MNT/etc
cp -r /etc/xdg/reflector $MNT/etc/xdg

# FIXME: move to chroot (systemctl enable)
cp -r /etc/systemd/system/reflector.service.d $MNT/etc/systemd/system
mkdir $MNT/etc/systemd/system/{sockets.target.wants,timers.target.wants}
cp /etc/systemd/system/multi-user.target.wants/{iwd.service,reflector.service,sshd.service} $MNT/etc/systemd/system/multi-user.target.wants
cp /etc/systemd/system/timers.target.wants/reflector.timer $MNT/etc/systemd/system/timers.target.wants

cp -r /root/.ssh $MNT/root
cp -r /root/configs/* $MNT/etc

genfstab -U /mnt >> /mnt/etc/fstab

cp chroot_install.sh /mnt/root
cp -r pkg /mnt/root
arch-chroot /mnt bash /root/chroot_install.sh
