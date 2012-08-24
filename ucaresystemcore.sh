#!/bin/bash
#
#
#_______________________________________________
#THIS IS THE Terminal Version of uCareSystem
#_______________________________________________
# Name   : uCareSystem Core
# Licence: GPL2 (http://www.gnu.org/licenses/gpl.html)
# Author : Salih Emin
# WebSite: http://ucaresystem.blogspot.com
# Email  : salihemin (at) about.me 
# Date   : 24-08-2012 (first release 19-02-2009)
# Version: 1.0 (based on the obsolete 2ClickUpdate Core v6.0)
# System : Debian Linux and Ubuntu Linux
# Description:
#This simple script will automatically refresh your package list, download and install 
#updates (if there are any),
#remove any remaining packages and configuration files without interference.
#
## Script starts here

DIR=$HOME
UCARE_FOLDER=$DIR/.ucaresystem
PWD=`pwd`


# Checking if the user has run the script with "sudo" or not
if [ $EUID -ne 0 ] ; then
    clear
    echo ""
    echo "This script must be run as root. Now I will just exit..." 1>&2
    echo ""
    sleep 2
    exit 1
fi

clear
echo "_______________________________________________________"
echo "                                                       "
echo "            uCareSystem Core v1.0                      "
echo "                 ~  ''  ~                              "
echo "                                                       "
echo " Welcome to all-in-one System Update and maintenance   "
echo " assistant app.                                        "
echo "                                                       "
echo " Note that the next time just open terminal and type:  "
echo "                                                       "
echo "              sudo updatecore                          "
echo "                                                       "
echo "  to run uCareSystem.				     "
echo "                                                       "
echo " This simple script will automatically         	     "
echo " refresh your packagelist, download and                "                                      
echo " install updates (if there are any) , remove any       "                                          
echo " remaining packages and configuration files and        "
echo " free up any unused disk space without any need of     "
echo " interference.      				     "      
echo "_______________________________________________________"
echo
echo " uCareSystem Core will start in 5 seconds... "		

sleep 6

echo "#########################"
echo "          Started"
echo "#########################"
echo
## Installation to run on the first run of the script. ONLY on the first run of the script!
if [ -f /usr/bin/updatecore ]
   then
	echo "ucaresystemcore is on your system"
   else 
	mkdir $UCARE_FOLDER;
	cp $PWD/ucaresystemcore.sh $UCARE_FOLDER;
	sudo ln -s $UCARE_FOLDER/ucaresystemcore.sh /usr/bin/updatecore;
fi

#start of commented old code for review
: <<'END'
firstrun=0
firstrun=1
if [ $firstrun -gt 0 ]
then
  sed -i '/firstrun=1/d' 2clickUpdateCore
   if [ -f /usr/bin/speed_apt.CORE.module ]
   then
       echo "Speed APT module found"
       echo ""
       sleep 1
   else
       echo "Speed APT module not found"
       echo ""
       sleep 1
       sudo apt-get -y install axel deborphan
       sudo chmod +x speed_apt.CORE.module
       sudo cp speed_apt.CORE.module /usr/bin
       echo "##################################"
       echo "Finished installing the APT module"
       echo "##################################"
       echo ""
       sleep 1
  fi
  if [ -f /usr/bin/2clickUpdateCore ]
   then
       echo "2clickUpdateCore found"
       echo ""
       sleep 1
   else
       echo "2clickUpdateCore not found"
       echo ""
       sleep 1
       sudo apt-get -y install axel deborphan
       sudo chmod +x 2clickUpdateCore
       sudo cp 2clickUpdateCore /usr/bin
       echo "####################################"
       echo "Finished installing 2clickUpdateCore"
       echo "####################################"
       echo ""
       sleep 1
  fi
fi
END
#end of commented old code for review

## Updates package lists    
sudo apt-get -y update;
echo
echo "###############################"
echo "Finished updating package lists"
echo "###############################"
sleep 1

## Updates packages and libraries
echo
#sudo /usr/bin/speed_apt.CORE.module -y --force-yes --allow-unauthenticated upgrade;
sudo apt-get -y upgrade;
echo
echo "###############################################"
echo "Finished updating packages and system libraries"
echo "###############################################"
sleep 1
echo

## Removes unneeded packages
sudo apt-get -y autoremove;
echo
echo "###################################"
echo "Finished removing unneeded packages"
echo "###################################"
sleep 1
echo

## Removes unused config files
if [ -f /usr/bin/deborphan ]
   then
       echo "Deborphan found"
       echo ""
       sleep 1
   else
       echo "Deborphan not found"
       echo ""
       sleep 1
       sudo apt-get -y install deborphan
       echo "Finished installing Deborphan"
       echo ""
       sleep 1
fi
sudo deborphan -n --find-config | xargs sudo apt-get -y purge; 
echo
echo "#####################################"
echo "Finished removing unused config files"
echo "#####################################"
sleep 1
echo

## Removes package files that can no longer be downloaded and everything except the lock file in /var/cache/apt/archives, including directories.
sudo apt-get -y autoclean; sudo apt-get -y clean;
echo
echo "######################################"
echo " Cleaned downloaded temporary packages"
echo "######################################"
echo 

sync #  Synchronize data on disk with system memory 
echo 
echo "#########################"
echo "   Data synced to Disk"
echo "#########################"
echo 3 > /proc/sys/vm/drop_caches # Free pagecache, dentries and inodes
echo
echo "#########################"
echo "  Ram freed fom garbage"
echo "#########################"
echo
sleep 2
echo "#########################"
echo "          Done"
echo "#########################"
## End of script
