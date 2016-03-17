#!/usr/bin/env bash
#
#
#_______________________________________________
#THIS IS THE Terminal Version of uCareSystem
#_______________________________________________
# Name   : uCareSystem Core
# Licence: GPL3 (http://www.gnu.org/licenses/gpl.html)
# Author : Salih Emin
# WebSite: http://utappia.org
# Email  : salihemin-(at)-about.me 
# Date   : 16-03-2016 (first release 19-02-2009)
# Version: 3.0 (based on the obsolete 2ClickUpdate Core v6.0)
# System : Debian Linux and Ubuntu Linux
# Description:
#This simple script will automatically refresh your package list, download and install 
#updates (if there are any),
#remove any remaining packages and configuration files without interference.
#
## Script starts here


# Checking if the user has run the script with "sudo" or not
if [ $EUID -ne 0 ] ; then
    clear
    echo ""
    echo "uCareSystem Core must be run as root. Now I will just exit..." 1>&2
    echo ""
    sleep 2
    exit 1
fi

clear
echo "_______________________________________________________"
echo "                                                       "
echo "            uCareSystem Core v3.0                      "
echo "                 ~  ''  ~                              "
echo "                                                       "
echo " Welcome to all-in-one System Update and maintenance   "
echo " assistant app.                                        "
echo "                                                       "
echo "                                                       "
echo " This simple script will automatically         	     "
echo " refresh your packagelist, download and                "                                      
echo " install updates (if there are any), remove any old    "                                          
echo " kernels, obsolete packages and configuration files    "
echo " to free up disk space, without any need of user       "
echo " interference.                    				     "      
echo "_______________________________________________________"
echo
echo " uCareSystem Core will start in 5 seconds... "		

sleep 6

echo "#########################"
echo "          Started"
echo "#########################"
echo

## Updates package lists    
sudo apt update;
echo
echo "###############################"
echo "Finished updating package lists"
echo "###############################"
sleep 1

## Updates packages and libraries
sudo apt -y full-upgrade;
echo
echo "###############################################"
echo "Finished updating packages and system libraries"
echo "###############################################"
sleep 1
echo

## Removes unneeded packages
sudo apt-get -y --purge autoremove;
echo
echo "###################################"
echo "Finished removing unneeded packages"
echo "###################################"
sleep 1
echo

# purge-old-kernels - remove old kernel packages
#    Copyright (C) 2012 Dustin Kirkland <kirkland -(at)- ubuntu.com>
#
#    Authors: Dustin Kirkland <kirkland-(at)-ubuntu.com>
#             Kees Cook <kees-(at)-ubuntu.com>
# 
# NOTE: This script will ALWAYS keep the currently running kernel
# NOTE: Default is to keep 2 more, user overrides with --keep N
KEEP=2
# NOTE: Any unrecognized option will be passed straight through to apt
APT_OPTS=
while [ ! -z "$1" ]; do
	case "$1" in
		--keep)
			# User specified the number of kernels to keep
			KEEP="$2"
			shift 2
		;;
		*)
			APT_OPTS="$APT_OPTS $1"
			shift 1
		;;
	esac
done

# Build our list of kernel packages to purge
CANDIDATES=$(ls -tr /boot/vmlinuz-* | head -n -${KEEP} | grep -v "$(uname -r)$" | cut -d- -f2- | awk '{print "linux-image-" $0 " linux-headers-" $0}' )
for c in $CANDIDATES; do
	dpkg-query -s "$c" >/dev/null 2>&1 && PURGE="$PURGE $c"
done

if [ -z "$PURGE" ]; then
	echo "No kernels are eligible for removal"
fi

sudo apt $APT_OPTS remove -y --purge $PURGE;

echo
echo "###################################"
echo "Finished removing old kernels"
echo "###################################"
sleep 1
echo
## Removes unused config files
sudo deborphan -n --find-config | xargs sudo apt-get -y --purge autoremove; 
echo
echo "#####################################"
echo "Finished removing unused config files"
echo "#####################################"
sleep 1
echo

## Removes package files that can no longer be downloaded and everything except 
# the lock file in /var/cache/apt/archives, including directories.
sudo apt-get -y autoclean; sudo apt-get -y clean;
echo
echo "######################################"
echo " Cleaned downloaded temporary packages"
echo "######################################"
echo 

sleep 2
echo "#########################"
echo "          Done"
echo "#########################"
## End of script
