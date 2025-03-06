#!/bin/bash
UUID="uuid here"
DEVICE=$(blkid -U $UUID)
echo 0 > /sys/block/$(basename $DEVICE)/queue/rotational