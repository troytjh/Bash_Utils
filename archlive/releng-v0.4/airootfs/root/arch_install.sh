#!/bin/bash

RED='\033[0;31m'

swap()
{
    mem=`grep MemTotal /proc/meminfo | awk '{print $2}'`
    if [ "$mem" -lt "1000000" ]; then
        swap=$mem
    else
        swap=$(bc <<< "scale=0; sqrt($mem)")
    fi
    swap=${swap}/1000 # convert KiB to MiB
    swap=${swap}+300  # add efi offset
    swap="${swap}MiB" # append unit
    parted -a optimal $1 mkpart "swap partition" linux-swap 300MiB $swap
    parted -a optimal $1 mkpart "root partition" ext4 $swap 100%
}

swap_hybrid()
{
    mem=`grep MemTotal /proc/meminfo | awk '{print $2}'`
	if [ "$mem" -lt "1000000" ]; then
        swap=$mem*2
    else
	    swap=$mem+$(bc <<< "scale=0; sqrt($mem)")
	fi
	swap=${swap}/1000 # convert KiB to MiB
	swap=${swap}+300  # add efi offset
	swap="${swap}MiB" # append unit
	parted -a optimal $1 mkpart "swap partition" linux-swap 300MiB $swap
	parted -a optimal $1 mkpart "root partition" ext4 $swap 100%
}

partition_GPT()
{
	parted -a optimal $1 mklabel gpt mkpart "EFI system partition"  fat32 1MiB 300MiB
	#parted -a optimal ${1}2
	
	#EFI="${1}1"
	#parted -a optimal $EFI mkpart

    printf "Include Space for Hybrid Sleep? [Y,n]"
	read hybr
	case $hybr in
	    y|Y|*)
		    swap_hybrid $1;;
		n|N)
		    swap $1;;
    esac
	
	mount ${1}3 /mnt
	mount ${1}1 /mnt/boot
	mkswap ${1}2
	swapon ${1}2
}

partition_MBR()
{

}

partition_auto()
{
	printf "Available Block Devices: \n"
	lsblk
	printf "Select Block Device: "
	read root
	root="/dev/$root"
	if [ ! -b "$root" ]; then
	    echo -e "${RED}Block device does not exist"
		exit
	fi

	printf "MBR or EFI Partition Scheme: "
	read boot
	case $boot in
	    efi|EFI)
		    partition_GPT $root;;
	    mbr|MBR)
		    partition_MBR $root;;
	    *)
		    exit;;
    esac

}

partition_man()
{
    printf "Mount root to /mnt and enter 'cont' to continue\n"
	read $ans
	case $ans in
        cont) 
            continue;;
		*) 
			exit;;
    esac
	if mountpoint /mnt; then
	
	else
	    echo -e "${RED}Mount point /mnt is does not exist"
		exit
	fi
}

partition() 
{
    printf "Configure Partition Scheme\n"
    printf "Use automatic or manual partitioning [A/m]: "
	read $part
	case $part in
	    a|A)
		    partition_auto;;
	    m|M)
		    partition_man;;
		*)
			partition_auto;;
    esac
}

MNT=/mnt
partition

pacstrap /mnt base base-devel linux linux-firmware
sed -i "/\[multilib\]/,/Include/"'s/^#//' /mnt/etc/pacman.conf

cp -r /root/.ssh /mnt/root
cp -r /root/configs/* $MNT/etc

genfstab -U /mnt >> /mnt/etc/fstab

cp chroot_install.sh /mnt/root
cp -r pkg /mnt/root
cp -R aur /mnt/root
arch-chroot /mnt bash /root/chroot_install.sh

