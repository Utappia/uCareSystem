<p align="center"><img src="https://raw.githubusercontent.com/Utappia/uCareSystem/master/repo-assets/ucaresystem-banner.png"></p>

![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/utappia/ucaresystem/total)
![GitHub commit activity](https://img.shields.io/github/commit-activity/t/utappia/ucaresystem)
![GitHub contributors](https://img.shields.io/github/contributors/utappia/ucaresystem)


<p align="center">
    <a href="https://www.gnu.org/licenses/gpl-3.0.en.html" target="_blank"><img src="https://img.shields.io/badge/license-GPLv3-blue.svg" alt="GNU GPL v3"></a>
    <a href="https://github.com/Utappia/uCareSystem/stargazers" target="_blank"><img src="https://img.shields.io/github/stars/utappia/ucaresystem.svg" alt="stars"></a>
<p align="center">
    <a href="https://donate.utappia.org/" target="_blank"><img src="https://img.shields.io/badge/Donate_to-uCareSystem-blue.svg" alt="Donate to project"></a>

# uCareSystem

uCareSystem is an all-in-one system update and maintenance application for Ubuntu and its derivatives. It provides a simple way to keep your system up-to-date and clean.

```
Name   : uCareSystem
License: GPL3 (http://www.gnu.org/licenses/gpl.html)
Author : Salih Emin
Email  : salih-emin(a)ubuntu.com
Date   : 25-02-2026 (first release 19-02-2009)
Version: 26.02.25
System : Ubuntu Linux and derivatives. With Deb, Snap or Flatpak. (Partial support for Debian and WSL2)
WebSite: http://utappia.org
```
## Sponsors of the previous development cycle (v26.01)

I am deeply grateful to the community members who supported the previous development cycle through donations or code contributions:

- W. Schreinemachers (Thanks for your continued support)
- Hewitt R.
- Monovel I.
- Stade M.

Every version has also a code name dedicated as a release honored to one of the contributors. For historical reference, you can check all [previous honored releases](https://github.com/Utappia/uCareSystem/blob/master/HONORED_RELEASES.md).


## Description

uCareSystem is an all-in-one, fully automated system update and maintenance tool for Ubuntu, Debian, Mint, Raspberry Pi OS, WSL2, and derivatives. It is designed for maximum reliability, user-friendliness, and cross-distro compatibility.

### Key Features

- Fully automated update, upgrade, and cleanup of system packages
- Robust pre-update health checks: interrupted installs, package locks (with retry logic), broken/held packages, disk space
- Snap and Flatpak update/cleanup (auto-detects and skips if not installed)
- Safe kernel cleanup: keeps current and one previous kernel (configurable)
- Cleans package cache, removes obsolete/orphan packages, and deletes config files of uninstalled packages
- Real-time output with colorized messages and progress countdowns
- Debug mode (`-x|--debug`): full tracing to log file, user notification, and safe cleanup
- Enhanced detection for systemd, WSL2, and container environments (safe daemon-reload)
- POSIX-compliant launcher with advanced terminal fallback logic (supports all major terminal emulators)
- All scripts are fully [shellcheck](https://www.shellcheck.net/) compliant
- Runtime test matrix with Docker, LXD, and VM scenarios (logs for each run)

---

![ucaresystem-color](https://github.com/user-attachments/assets/6f5171c2-5a64-465b-b794-920e225ce7f7)


## Installation

You can install uCareSystem in two ways:

### 1. Automatic installation (recommended)

This one-liner will update your package list, install `jq` and `curl` if needed, download the latest `.deb` to `/tmp`, and install it:

```bash
sudo apt update && sudo apt install -y jq curl && cd /tmp && \
url="$(curl -fsSL -A 'uCareSystem-installer' https://api.github.com/repos/utappia/ucaresystem/releases/latest | jq -r '.assets[] | select(.name | test("^ucaresystem-core_.*\\.deb$")) | .browser_download_url' | head -n1)" && \
[ -n "$url" ] && curl -fL -A 'uCareSystem-installer' "$url" -o ucaresystem-core_latest.deb && \
sudo apt install ./ucaresystem-core_latest.deb
```

> **Note:**
> Installing from `/tmp` as shown above avoids the unsandboxed download warning.

### 2. Manual download and installation

1. Download the latest `.deb` package from the [releases page](https://github.com/utappia/ucaresystem/releases)
2. Install the package:

   ```bash
   sudo apt install ./ucaresystem-core_*.deb
   ```

> If you install the package from your home or Downloads directory, you may see a warning about “Download is performed unsandboxed as root... Permission denied for user '_apt'.” This is normal and does not affect the installation. To avoid the warning, move the `.deb` file to `/tmp` or another directory readable by all users before installing.

Both installation methods will:

- Install the uCareSystem core package
- Check if the Utappia repository exists in your system
- If the repository is not found, it will automatically:
  - Add the Utappia repository for future updates
  - Add the repository signing key


## Usage

On Desktop environments, *uCareSystem* creates a launcher icon in your Applications menu. Just search for `ucare` and click the icon to start the default maintenance tasks. The launcher is fully POSIX-compliant and supports all major terminal emulators, with robust fallback logic for maximum compatibility across desktop environments.

Alternatively, you can invoke it through the terminal with various options/flags:

```
ucaresystem-core
```

### Common options

- Show version:
   ```
   ucaresystem-core -v
   ```
- Read the manual:
   ```
   man ucaresystem-core
   ```
- Shutdown after maintenance:
   ```
   ucaresystem-core -s
   ```
- Upgrade to next Ubuntu release:
   ```
   ucaresystem-core -u
   ```
- Upgrade to next development (rolling) release:
   ```
   ucaresystem-core -d
   ```
- Upgrade from EOL Ubuntu to next supported release:
   ```
   ucaresystem-core -eol
   ```
- Enable debug mode (tracing to log file):
   ```
   ucaresystem-core -x
   ```
   > After completion, the debug log file will be saved as `~/ucaresystem-debug-<date>.log` (in your home directory). If your home directory cannot be determined, it will be saved in `/tmp`.

For all available options, run:

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
   sudo rm /etc/apt/sources.list.d/utappia*
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

*Please* do not use master branch for code contribution. *Use the develop branch for forking and pull requests*.

---

For questions, support, and community discussions, visit the [uCareSystem Discussion Forum](https://github.com/Utappia/uCareSystem/discussions).
