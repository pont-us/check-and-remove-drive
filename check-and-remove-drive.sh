#!/bin/bash

# Flush, unmount, fsck, and power down an external USB drive.
# Takes path to mount point as argument.

# Based on:
# https://linuxnorth.wordpress.com/2018/01/25/safely-removing-a-usb-drive-with-a-bash-script/

set -e  # Exit immediately if a command exits with a non-zero status
set -x  # Print commands and their arguments as they are executed

# Sync any cached writes
sync

# Strip trailing / (if present) from argument
mountpoint=${1%/}

# Identify the device name for the specified USB drive
usblongname=$(lsblk -l | grep $mountpoint)
usbname="${usblongname:0:4}"

# Unmount the drive
udisksctl unmount -b /dev/$usbname

# Check the filesystem
sudo fsck.ext4 -f /dev/$usbname

# Power off the drive
udisksctl power-off -b /dev/$usbname
