<p align="center"><img src="https://raw.githubusercontent.com/Utappia/uCareSystem/master/repo-assets/ucaresystem-image-banner.png"></p>

<p align="center">
    <a href="https://www.gnu.org/licenses/gpl-3.0.en.html" target="_blank"><img src="https://img.shields.io/badge/license-GPLv3-blue.svg" alt="GNU GPL v3"></a>
    <a href="https://github.com/Utappia/uCareSystem/stargazers" target="_blank"><img src="https://img.shields.io/github/stars/utappia/ucaresystem.svg" alt="stars"></a>
<p align="center">
    <a href="https://www.paypal.com/donate/?hosted_button_id=SATQ6Y9S3UCSG" target="_blank"><img src="https://img.shields.io/badge/Donate-PayPal-yellow.svg" alt="Donate to project"></a>
 
# uCareSystem

uCareSystem is an all-in-one system update and maintenance application for Ubuntu and its derivatives. It provides a simple way to keep your system up-to-date and clean.

	Name   : uCareSystem
	License: GPL3 (http://www.gnu.org/licenses/gpl.html)
	Author : Salih Emin
	Email  : salih-emin(a)ubuntu.com
	Date   : 17-07-2025 (first release 19-02-2009)
	Version: 25.07.17
	System : Ubuntu Linux and derivatives. With Deb, Snap or Flatpak. (Partial support for WSL2) 
	WebSite: http://utappia.org

## Sponsors of the previous development cycle (v25.06)

With version 24.06 of uCareSystem, I added a section to acknowledge the people who supported the development of the previous cycle. This addition was warmly received by the community, and I can't express enough gratitude to those who donated during the previous development cycle:

- W. Schreinemachers (Thanks for your continued support)
- K. A. Gkountras (Jemadux)

## Description:

In summary, uCareSystem performs the following list of maintenance tasks automatically and without the need for user interference. :

- Updates the list of available packages
- Downloads and installs the available updates
- Downloads and installs Snap Package updates (It's skipped if Snap is not installed)
- Removes Old Snap revisions to free up space
- Downloads and installs Flatpak Package updates (It's skipped if Flatpak is not installed)
- Removes unused Flatpak packages to free up space
- Checks if there are older Linux kernels on the system and removes them. However it keeps the current and one previous version of the kernel. Also you can specify the number of kernels to keep
- Cleans the cache of the downloaded packages
- Removes obsolete packages
- Removes orphan packages
- Deletes package configuration files from packages that have been uninstalled by you
- If there is a need for a system reboot, it will inform you and it will provide the list of packages that requested that system reboot

![ucaresystem-color](https://github.com/user-attachments/assets/6f5171c2-5a64-465b-b794-920e225ce7f7)

## Installation

1. Download the latest .deb package from the [releases page](https://github.com/utappia/ucaresystem/releases)
2. Install the package:
   ```bash
   sudo apt install ./ucaresystem-core_*.deb
   ```
The installer will:
- Install the uCareSystem core package
- Check if the Utappia repository exists in your system
- If the repository is not found, it will automatically:
  - Add the Utappia repository for future updates
  - Add the repository signing key


## Usage

uCareSystem creates a launcher icon in your Applications menu. Just search your applications menu for `ucare`. If you click the icon, it starts performing the default maintenance tasks. 

Alternatively, you can invoke it through terminal with various options/flags. The default system updates and maintenance for Ubuntu / Debian / Linux Mint (and derivatives) :
```
ucaresystem-core
```
If you want to shutdown your system after using the uCareSystem you can use the `-s` option :
```
ucaresystem-core -s
```
When the next available release is available for Ubuntu (and official flavors) you can upgrade with `-u`:
```	
ucaresystem-core -u
```
If you are a tester, developer, or simply an enthusiast, you can upgrade to the next development cycle of Ubuntu (and official flavors) with `-d` which actually turns your Ubuntu into a rolling release distribution:
```
ucaresystem-core -d
```
If your Ubuntu (and official flavors) has reached the EOL support you can upgrade to the next supported release with `-eol`:
```
ucaresystem-core -eol
```
For information about all the available options / flags, start ucaresystem-core with `-h` option :
```
ucaresystem-core -h
```
## Uninstallation

To completely remove uCareSystem and its repository:

1. Remove the package:
   ```bash
   sudo apt autoremove ucaresystem-core
   ```

2. (Optional) Remove the repository and its signing key:
   ```bash
   sudo rm /etc/apt/sources.list.d/utappia*.list
   sudo rm /etc/apt/keyrings/utappia*.gpg
   ```
   If you keep the repository and its signing key you can reinstall ucaresystem-core without downloading the *.deb package but instead by `apt install ucaresystem-core`.

3. Update package lists:
   ```bash
   sudo apt update
   ```

## Code contribution

If you have an idea and want to contribute code:

1. Open an Issue describing what you want to fix/change/enhance
2. From the branches button, change the "master" to "develop" branch
3. Start coding and once you are done, create a pull request that you want to be merged to the "develop" branch

Please do not use master branch for code contribution. Use the develop branch for forking and pull requests
