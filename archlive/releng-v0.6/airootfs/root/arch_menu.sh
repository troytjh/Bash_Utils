#!/usr/bin/env bash

menu()
{
    echo 'Install menu:'
    options=("Setup" "Base" "Packages" "AUR Packages" "Post Setup" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Setup")
                bash 0-setup.sh
                menu
                ;;
            "Base")
                bash 1-base.sh
                menu
                ;;

            "Packages")
                bash 2-software-pacman.sh
                menu
                ;;

            "AUR Packages")
                bash 3-software-aur.sh
                menu
                ;;

            "Post Setup")
                bash 4-post-install.sh
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