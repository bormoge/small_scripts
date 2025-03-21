#!/bin/bash

unset YES_FLAG
unset CLEAN_FLAG
unset GRUB_FLAG
unset FWUPD_FLAG
unset OFFLINE_FLAG

for arg in "$@"; do
    case $arg in
        -y)
            printf "\n\nYES_FLAG set\n\n"
            YES_FLAG="-y"
            ;;
        -clean)
            printf "\n\nCLEAN_FLAG set\n\n"
            CLEAN_FLAG="-clean"
            ;;
        -grub)
            printf "\n\nGRUB_FLAG set\n\n"
            GRUB_FLAG="-grub"
            ;;
	-fwupd)
            printf "\n\nFWUPD_FLAG set\n\n"
            FWUPD_FLAG="-fwupd"
            ;;
	-offline)
            printf "\n\nOFFLINE_FLAG set\n\n"
            OFFLINE_FLAG="-offline"
            ;;
    esac
done

## Experimental FWUPD flag:
if [ -n "$FWUPD_FLAG" ] && [ "$FWUPD_FLAG" == "-fwupd" ]; then
    printf "Updating BIOS using fwupd...\n\n"
    fwupdmgr get-devices
    fwupdmgr refresh
    fwupdmgr get-updates
    fwupdmgr update
    printf "Exiting script...\n\n"
    exit 0
fi

## Offline Update
if [ -n "$OFFLINE_FLAG" ] && [ "$OFFLINE_FLAG" == "-offline" ]; then
    printf "Offline update using dnf-offline...\n\n"
    dnf upgrade --offline
    dnf offline reboot
    ## dnf offline reboot --poweroff
    exit 0
fi

printf "\n\nUpdating package list...\n\n"
dnf check-update

printf "\n\nUpdating packages...\n\n"

if [ -z "$YES_FLAG" ]; then
    printf "Using default...\n\n"
    dnf upgrade
    flatpak update
    ## flatpak update --user
else
    printf "Using YES_FLAG...\n\n"
    dnf upgrade ${YES_FLAG}
    flatpak update ${YES_FLAG}
    ## flatpak update ${YES_FLAG} --user
fi

if [ -n "$CLEAN_FLAG"  ] && [ "$CLEAN_FLAG" == "-clean" ]; then
    printf "\n\nCleaning up packages...\n\n"
    printf "Using CLEAN_FLAG...\n\n"
    dnf autoremove
    dnf clean all

    printf "\n\nRemoving Flatpak packages...\n\n"
    if [ -z "$YES_FLAG" ]; then
        printf "Using default...\n\n"
        flatpak uninstall --unused
	## flatpak uninstall --user --unused
    else
        printf "Using YES_FLAG...\n\n"
        flatpak uninstall ${YES_FLAG} --unused
	## flatpak uninstall ${YES_FLAG} --user --unused
    fi
fi

if [ -n "$GRUB_FLAG"  ] && [ "$GRUB_FLAG" == "-grub" ]; then
    printf "\n\nInvoking GRUB2...\n\n"
    printf "Using GRUB_FLAG...\n\n"
    # grub2-mkconfig --version
    grub2-mkconfig -o /boot/grub2/grub.cfg
    printf "Exiting script...\n\n"
    exit 0
fi

printf "\n\nSystem update complete!\n\n"
