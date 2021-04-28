#!/usr/bin/env bash

RED='\033[0;31m'
NC='\033[0m'

menu()
{
    echo 'Install menu:'
    options=("Setup" "Base" "Packages" "AUR Packages" "Post Setup" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Setup")
                bash /root/0-setup.sh
                menu
                ;;
            "Base")
                if [ "$(stat -c %d:%i /)" == "$(stat -c %d:%i /proc/1/root/.)" ]; then
                    if !(mountpoint /mnt &> /dev/null); then
                        echo -e "${RED}Mount point /mnt does not exist${NC}"
                        exit
	                fi
    
                    arch-chroot /mnt bash /root/1-base.sh
                else
                    bash /root/1-base.sh
                fi
                menu
                ;;

            "Packages")
                if [ "$(stat -c %d:%i /)" == "$(stat -c %d:%i /proc/1/root/.)" ]; then
                    if !(mountpoint /mnt &> /dev/null); then
                        echo -e "${RED}Mount point /mnt does not exist${NC}"
                        exit
	                fi
    
                    arch-chroot /mnt bash /root/2-software-pacman.sh
                else
                    bash /root/2-software-pacman.sh
                fi
                menu
                ;;

            "AUR Packages")
                if [ "$(stat -c %d:%i /)" == "$(stat -c %d:%i /proc/1/root/.)" ]; then
                    if !(mountpoint /mnt &> /dev/null); then
                        echo -e "${RED}Mount point /mnt does not exist${NC}"
                        exit
	                fi
    
                    arch-chroot /mnt bash /root/3-software-aur.sh
                else
                    bash /root/3-software_aur.sh
                fi
                menu
                ;;

            "Post Setup")
                if [ "$(stat -c %d:%i /)" == "$(stat -c %d:%i /proc/1/root/.)" ]; then
                    if !(mountpoint /mnt &> /dev/null); then
                        echo -e "${RED}Mount point /mnt does not exist${NC}"
                        exit
	                fi
    
                    arch-chroot /mnt bash /root/4-post-install.sh
                else
                    bash /root/4-post-install.sh
                fi
                menu
                ;;

            "Quit")
                echo "Quit"
                exit
                ;;   
        esac
    done
}
menu