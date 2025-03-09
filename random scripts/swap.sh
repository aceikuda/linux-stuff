#!/bin/bash

if [ `whoami` != root ]; then
    echo please run this script as root or via sudo
    exit
fi

echo -e "\nswapfile location [/]\nUSE -p FOR PARTITIONS."
read swaplocation;
swapfile=${swaplocation}/swap.img

if  [[ $1 = "-d" ]]; then

    if [ -f "$swapfile" ]; then # SWAPFILE exists
        sudo swapoff ${swapfile} && sudo rm ${swapfile}
        sudo sysctl vm.swappiness=0
        echo swapfile deleted
    elif # SWAPFILE does not exist
        [ -e "$swaplocation" ]; then # PARTITION exists
            sudo swapoff ${swaplocation}
            sudo sysctl vm.swappiness=0
            echo swap partition disabled
        else # PARTITION and SWAP no exist 3:
        echo swapfile does not exist
        sudo sysctl vm.swappiness=0
    fi

elif  [[ $1 = "-p" ]]; then

    if [ -e "$swaplocation" ]; then # exists
        sudo sysctl vm.swappiness=100
        sudo mkswap ${swaplocation} && sudo swapon ${swaplocation}
        echo swap partition found and enabled
    else # does not exist
        echo swap partition does not exist
    fi

else
    echo -e "\nswapfile size (gb)"
    read swapsize;
    echo -e "swappiness, 0 to 100"
    read swappiness;
    sudo fallocate -l ${swapsize}G ${swapfile}
    sudo chmod 600 ${swapfile}
    sudo sysctl vm.swappiness=${swappiness}
    sudo mkswap ${swapfile} && sudo swapon ${swapfile}
    echo ${swapsize}G swap added
fi