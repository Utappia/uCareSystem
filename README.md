<p align="center"><img src="https://raw.githubusercontent.com/Utappia/uCareSystem/master/assets/ucaresystem-image-banner.png"></p>

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
	Date   : 28-07-2024 (first release 19-02-2009)
	Version: 24.07.28
	System : Ubuntu Linux and derivatives. With Deb, Snap or Flatpak. (Partial support for Debian and WSL2) 
	WebSite: http://utappia.org

## Sponsors of the previous development cycle (v24.06)

With version 24.06 of uCareSystem, I added a section to acknowledge the people who supported the development of the previous cycle. This addition was warmly received by the community, and I can't express enough gratitude to those who donated during the previous development cycle:

- P. Loughman (the legend! I wish you the best, my friend)
- E. Dennis
- L. Alexander
- I. Eleftherios
- W. Shreinemachers

## Description:

In summary, uCareSystem automatically performs the following maintenance processes without the need for user interference. :

- Updates the list of available packages
- Downloads and installs the available updates
- Downloads and installs Snap Package updates (It's skiped if Snap is not installed)
- Removes Old Snap revisions to free up space
- Downloads and installs Flatpak Package updates (It's skiped if Flatpak is not installed)
- Removes unused Flatpak packages to free up space
- Checks if there are older Linux kernels on the system and removes them. However it keeps the current and one previous version of the kernel.
- Cleans the cache of the downloaded packages
- Removes obsolete packages
- Removes orphan packets
- Deletes package configuration files from packages that have been uninstalled by you
- If there is a required reboot, it will inform you with the packeages that requested for a system reboot
                                          
## Usage

uCareSystem creates an launcher icon in your Applications menu. Just search your applications manu for `ucare`. When you click it, it performs the default maintenance by automatically launching a terminal. 

Alternatively, you can invoke it through terminal with various options/flags. The default system updates and maintenace for Ubuntu / Debian / Linux Mint (and derivatives) :
```
sudo ucaresystem-core
```
If you want to shutdown your system after using the uCareSystem you can use the `-s` option :
```
sudo ucaresystem-core -s
```
When the next available release is availabe for Ubuntu (and official flavors) you can upgrade with `-u`:
```	
sudo ucaresystem-core -u
```
If you are a tester, developer, or simply an enthusiast, you can upgrade to the next development cycle of Ubuntu (and official flavors) with `-d` which actually turns your Ubuntu into a rolling release distribution:
```
sudo ucaresystem-core -d
```
If your Ubuntu (and official flavors) has reached the EOL support you can upgrade to the next supported release with `-eol`:
```
sudo ucaresystem-core -eol
```
For information about all the availabe options / flags, start ucaresystem-core with `-h` option :
```
sudo ucaresystem-core -h
```
