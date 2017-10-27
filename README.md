# uCareSystem

Name   : uCareSystem
License: GPL3 (http://www.gnu.org/licenses/gpl.html)
Author : Salih Emin
Email  : salihemin (at) about.me 
Date   : 27-10-2017
Version: 4.1
System : Ubuntu or Debian derivatives (Not tested every flavor)
WebSite: http://utappia.org

## Description:

	Note: please use only ucaresystem-core. uCareSystem is the GUI version and currently it is not maintained and
	not up to date with the features that are integrated in ucaresystem-core.

uCaresytems system has the following features:         
This simple app will automatically         	     
 
- refresh your packagelist, 
- download and install updates (if there are any),
- remove any old kernels that came from updates,
- remove obsolete packages and their configuration files to free up disk space

without any need of user interference                                           

## Usage

Default system updates and maintenace for Ubuntu / debian / Linux Mint (and derivatives) :

	sudo ucaresystem-core

When the next available release is availabe for Ubuntu (and official flavors) you can upgrade with '-u':
	
	sudo ucaresystem-core -u

If you are a tester, developer, or simply an enthusiast, you can upgrade to the next development cycle of Ubuntu (and official flavors) with '-d':

	sudo ucaresystem-core -d

If your Ubuntu (and official flavors) has reached the EOL support you can upgrade to the next supported release with '-eol':
	
	sudo ucaresystem-core -eol

For usage start ucaresystem-core with '-h' parameter :

	sudo ucaresystem-core -h         

