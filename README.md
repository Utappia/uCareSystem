<p align="center"><img src="https://raw.githubusercontent.com/Utappia/uCareSystem/master/modules/ucaresystem-image-banner.png"></p>

<p align="center">
    <a href="https://www.gnu.org/licenses/gpl-3.0.en.html" target="_blank"><img src="https://img.shields.io/badge/license-GPLv3-blue.svg" alt="GNU GPL v3"></a>
    <a href="https://github.com/Utappia/uCareSystem/stargazers" target="_blank"><img src="https://img.shields.io/github/stars/utappia/ucaresystem.svg" alt="stars"></a>
<p align="center">
    <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=SATQ6Y9S3UCSG" target="_blank"><img src="https://img.shields.io/badge/Donate-PayPal-yellow.svg" alt="Donate to project"></a>
 
 

# uCareSystem

	Name   : uCareSystem
	License: GPL3 (http://www.gnu.org/licenses/gpl.html)
	Author : Salih Emin
	Email  : salih-(a)-utappia.org
	Date   : 05-03-2020 (first release 19-02-2009)
	Version: 20.03.0
	System : Ubuntu Linux and derivatives. Partial support for Debian (Not tested every flavor)
	WebSite: http://utappia.org

## Description:

	_**Note**: please use only **ucaresystem-core**. uCareSystem is the GUI version and currently it is not maintained and
	not up to date with the features that are integrated in ucaresystem-core._

In summary, ucaresystem Core automatically performs the following maintenance processes without any need of user interference :

- Updates the list of available packages
- Downloads and installs the available updates
- Checks if there are older Linux kernels on the system and removes them. However it keeps the current and one previous version of the kernel.
- Cleans the cache of the downloaded packages
- Removes obsolete packages
- Removes orphan packets
- Deletes package configuration files from packages that have been uninstalled by you.
                                          
## Usage

uCareSystem-core creates an launcher icon in your Applications menu. When you click it, it performs the default maintenance by automatically launching a terminal. 

Alternativelly, you can invoke it throu terminal with variours parameters/ flags. The default system updates and maintenace for Ubuntu / debian / Linux Mint (and derivatives) :

	sudo ucaresystem-core

When the next available release is availabe for Ubuntu (and official flavors) you can upgrade with '-u':
	
	sudo ucaresystem-core -u

If you are a tester, developer, or simply an enthusiast, you can upgrade to the next development cycle of Ubuntu (and official flavors) with '-d':

	sudo ucaresystem-core -d

If your Ubuntu (and official flavors) has reached the EOL support you can upgrade to the next supported release with '-eol':
	
	sudo ucaresystem-core -eol

For information about all the availabe parameters / flags, start ucaresystem-core with '-h' parameter :

	sudo ucaresystem-core -h

