#!/usr/bin/env bash

RED='\033[0;31m'

swap()
{
    mem=`grep MemTotal /proc/meminfo | awk '{print $2}'`
    if [ "$mem" -lt "1000000" ]; then
        swap=$mem
    else
        swap=$(bc <<< "scale=0; sqrt($mem)")
    fi
    let "swap=${swap}/1000" # convert KiB to MiB
}

swap_hybrid()
{
    mem=`grep MemTotal /proc/meminfo | awk '{print $2}'`
    if [ "$mem" -lt "1000000" ]; then
        let "swap=$mem*2"
    else
        let "swap=$mem+$(bc <<< "scale=0; sqrt($mem)")"
    fi
    let "swap=${swap}/1000" # convert KiB to MiB
}

partition_GPT()
{
    parted -a optimal $1 mklabel gpt

    printf "Include Space for Hybrid Sleep? [Y,n] "
    read hybr
    case $hybr in
        y|Y|*)
            swap_hybrid $1;;
        n|N)
            swap $1;;
    esac

    let "swap=${swap}+300"  # add efi offset
    swap="${swap}MiB"

    parted -a optimal $1 mkpart 'EFI' fat32 1MiB 300MiB &> /dev/null
    parted -a optimal $1 set 1 esp on &> /dev/null
    parted -a optimal $1 mkpart "SWAP" linux-swap 300MiB $swap &> /dev/null
    parted -a optimal $1 mkpart "ROOT" ext4 $swap 100%

    mkfs.vfat -F32 ${1}1
    mkswap ${1}2
    mkfs.ext4 ${1}3

    parted $1 print

    mkdir /mnt &> /dev/null
    mount -v -t ext4 ${1}3 /mnt
    mkdir /mnt/boot &> /dev/null
    mount -v -t vfat ${1}1 /mnt/boot
    swapon ${1}2
}

partition_MBR()
{
    parted -a optimal $1 mklabel msdos

    printf "Include Space for Hybrid Sleep? [Y,n] "
    read hybr
    case $hybr in
        y|Y|*)
            swap_hybrid $1;;
        n|N)
            swap $1;;
    esac

    let "swap=${swap}+1"  # add efi offset
    swap="${swap}MiB"

    parted -a optimal $1 mkpart primary linux-swap 1MiB $swap &> /dev/null
    parted -a optimal $1 mkpart primary ext4 $swap 100%

	mkswap ${1}1
    swapon ${1}1

	mkfs.ext4 ${1}2
    mkdir /mnt &> /dev/null
    mount -v -t ext4 ${1}2 /mnt
}

partition_auto()
{
    echo "-------------------------------------------------"
    echo "-------select your disk to format----------------"
    echo "-------------------------------------------------"
    lsblk
    echo "Please enter disk: (example /dev/sda)"
    read DISK
    if [ ! -b "$DISK" ]; then
        echo -e "${RED}Block device does not exist"
        exit
    fi

    echo "MBR or EFI Partition Scheme:"
    read BOOT
    case $BOOT in
        efi|EFI)
            partition_GPT $DISK;;
        mbr|MBR)
            partition_MBR $DISK;;
        *)
            exit;;
    esac

}

partition_man()
{
    echo "Mount root to /mnt and enter 'cont' to continue"
    read ans
    case $ans in
        cont)
            if !(mountpoint /mnt); then
                echo -e "${RED}Mount point /mnt does not exist"
                exit
			fi;;
        *) 
            exit;;
    esac
}

partition() 
{
    echo "Configure Partition Scheme"
    printf "Use automatic or manual partitioning [A/m]: "
    read part
    case $part in
        a|A)
            partition_auto;;
        m|M)
            partition_man;;
        *)
            partition_auto;;
    esac
}


timedatectl set-ntp true

MNT=/mnt
partition

echo "--------------------------------------"
echo "-- Arch Install on Main Drive       --"
echo "--------------------------------------"
pacstrap /mnt base base-devel linux linux-firmware vim sudo --noconfirm --needed
sed -i "/\[multilib\]/,/Include/"'s/^#//' /mnt/etc/pacman.conf

cp -r /root/.ssh /mnt/root
cp -r /root/configs/* $MNT

genfstab -U /mnt >> /mnt/etc/fstab

cp chroot_install.sh /mnt/root
cp -r pkg /mnt/root
cp -R aur /mnt/root
arch-chroot /mnt bash /root/chroot_install.sh

