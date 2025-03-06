#!/bin/bash

if [ `whoami` != root ]; then
    echo please run this script as root or via sudo
    exit
fi

echo -e "swapfile location [/]"
read swaplocation;

if  [[ $1 = "-d" ]]; then

    swapfile=${swaplocation}/swap.img
    if [ -f "$swapfile" ]; then # exists
        sudo swapoff ${swaplocation}/swap.img && sudo rm ${swaplocation}/swap.img
        sudo sysctl vm.swappiness=0
        echo swapfile deleted
    else # does not exist
        echo swapfile does not exist
        sudo sysctl vm.swappiness=0
    fi

else
    echo "swapfile size (gb)"
    read swapsize;
    sudo fallocate -l ${swapsize}G ${swaplocation}/swap.img
    sudo chmod 600 ${swaplocation}/swap.img
    sudo sysctl vm.swappiness=100
    sudo mkswap ${swaplocation}/swap.img && sudo swapon ${swaplocation}/swap.img
    echo ${swapsize}G swap added
fi