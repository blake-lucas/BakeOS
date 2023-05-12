# BakeOS

[![build-bakeos](https://github.com/blake-lucas/BakeOS/actions/workflows/build.yml/badge.svg)](https://github.com/blake-lucas/BakeOS/actions/workflows/build.yml)

A customized Silverblue image built with the following tweaks:
 - APX package manager
 - AppimageLauncher installed
 - Black Box terminal as default (including Nautilus "Open Terminal here" right click menu) 
 - Distrobox installed
 - Aliases for APX - ex. ddnf install, aapt install, ddnf run, etc
 - Mesa drivers from Nobara (for F37 image)
 - Mutter VRR patch from Nobara
 - Automatically installed and configured GNOME extensions (see list of extensions and settings below)
 - Multiple CLI utilities preinstalled - htop, btop, nvtop, gdu, iotop, sysstat, nethogs, net-tools, smem, screen, etc
 - Latest linux-firmware from git
 - ZSH installed and preconfigured with plugins/theme (more similar to Manjaro's ZSH config)
 - Latest Nvidia driver installed on Nvidia image
 - RustDesk installed and configured to use my relay server (rustdesk.blakelucas.com)
 - NextCloud client and Nautilus extension installed - Monochrome icons used by default
 - NextShot installed and bound to print (GNOME screenshot bound to shift+print)
 - Ubuntu's Yaru theme/fonts installed and configured
 - Automatic Flatpak and system updates daily
 
 GNOME extensions installed and their tweaks:
  - ArcMenu - Windows 7-esque start menu, slightly taller than default to allow for more pins.
  - Dash to Panel - Centered taskbar, similar to Windows 11. Spacing between tray icons reduced. Click to preview multiple instead of cycle.
  - Appindicator Support - Brings back tray icon support
  - Wireless HID - Shows battery info for wireless devices
  - Window Is Ready Notification Remover - Makes notifications suck a lot less for apps like Signal or FileZilla
  - Pano - Fancy clipboard manager
  - Tiling Assistant - Implements Windows-like tiling functionality
  - Desktop Icons NG - Adds desktop icon functionality. Home and Trash are hidden by default.
  - Blur my Shell - Pretty
  - GSConnect - Pair your phone with your PC for handy stuff

Currently you'll need to have Fedora Silverblue installed to rebase to this image (see below). Premade ISOs will be provided as soon as the custom image feature lands in the Fedora installer.

# Usage

1. Download and install [Fedora Silverblue](https://silverblue.fedoraproject.org/download)
1. After you reboot you should [pin the working deployment](https://docs.fedoraproject.org/en-US/fedora-silverblue/faq/#_about_using_silverblue) so you can safely rollback. (sudo ostree admin pin 0)
1. [AMD/Intel GPU users only] Open a terminal and rebase the OS to this image:

        sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/blake-lucas/bakeos:stable

1. [Nvidia GPU users only] Open a terminal and rebase the OS to this image:

        sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/blake-lucas/bakeos-nvidia:stable
        
1. AMD/Intel can reboot and be finished. If you're on Nvidia, reboot, login, and run:
        
        just set-kargs

1. Last thing, I'd recommend running the following once your drivers are working:

        just apx-init - Creates APX containers and tweaks a few things
        just apx-nvidia (or apx-amd/apx-intel) - This sets up video accel in APX containers

1. To revert back:

        sudo rpm-ostree rebase fedora:fedora/37/x86_64/silverblue

1. [Test image, not recommended] The "latest" tag follows the latest Fedora release (currently 38) and may lack full testing. Note that this doesn't include Nobara's Mutter VRR patch yet:

        sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/blake-lucas/bakeos:latest
        OR
        sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/blake-lucas/bakeos-nvidia:latest

1. [LTS image, older PC/VM use only really] -lts images use Rocky Linux's firmware and kernel (on Main image once I finish testing). Firmware from linux-firmware git is used for images missing in Rocky's firmware package.

        sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/blake-lucas/bakeos-lts:latest
        sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/blake-lucas/bakeos-lts:stable
        sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/blake-lucas/bakeos-nvidia-lts:latest
        sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/blake-lucas/bakeos-nvidia-lts:stable

Check the [Silverblue documentation](https://docs.fedoraproject.org/en-US/fedora-silverblue/) for instructions on how to use rpm-ostree. 
I build date tags as well, so if you want to rebase to a particular day's release you can use the version number and date to boot off of that specific image:
  
    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/blake-lucas/bakeos:37-20230310 

The `latest` tag will automatically point to the latest build. 

# Features

**This image heavily utilizes _cloud-native concepts_.** 

System updates are image-based and automatic. Applications are logically seperated from the system by using Flatpaks, and the CLI experience is contained within OCI containers: 

- GNOME Software with Flathub
    - Use a familiar software center UI to install graphical software
- Built-in Ubuntu user space (this hasn't been implemented yet)
    - Official Ubuntu LTS cloud image 
      - `Ctrl`-`Alt`-`u` - will launch an Ubuntu image inside a terminal via [Distrobox](https://github.com/89luca89/distrobox), your home directory will be transparently mounted
      - A [BlackBox terminal](https://www.omgubuntu.co.uk/2022/07/blackbox-gtk4-terminal-emulator-for-gnome) is used just for this configuration
      - Use this container for your typical CLI needs or to install software that is not available via Flatpak or Fedora 
      - Refer to the [Distrobox documentation](https://distrobox.privatedns.org/#distrobox) for more information on using and configuring custom images
    - GNOME Terminal
      - `Ctrl`-`Alt`-`t` - will launch a host-level GNOME Terminal if you need to do host-level things in Fedora (you shouldn't need to do much).   
- Cloud Native Tools
    - [Podman-Docker](https://github.com/containers/podman) - Automatically aliases the `docker` command to `podman`
- Nix-powered Development Experience (Alpha) 
    - Powered by [Zero-to-Nix](https://zero-to-nix.com/) - thanks Determinate Systems!
    - Run `/usr/bin/ublue-nix-install` to get started
    - This feature is experimental and not considered ready for production. It is for experienced users only, here be dragons
- Quality of Life Improvements
    - systemd shutdown timers adjusted to 15 seconds
    - [Just](https://github.com/casey/just) task runner for post-install automation tasks
- Built on top of the the [uBlue main image](https://github.com/ublue-os/main) 
  - Extra udev rules for game controllers and [other devices](https://github.com/ublue-os/config) included out of the box
  - All multimedia codecs included
  - System designed for automatic staging of updates
    - If you've never used an image-based Linux before just use your computer normally
    - Don't overthink it, just shut your computer off when you're not using it

### Applications

- Mozilla Firefox, Mozilla Thunderbird, Extension Manager, Libreoffice, Pika Backup, FontDownloader, Flatseal, and the Celluloid Media Player
- Core GNOME Applications installed from Flathub
  - GNOME Calculator, Calendar, Characters, Connections, Contacts, Evince, Firmware, Logs, Maps, NautilusPreviewer, TextEditor, Weather, baobab, clocks, eog, and font-viewer
- All applications installed per user instead of system wide, similar to openSUSE MicroOS. Thanks for the inspiration Team Green!

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/blake-lucas/bakeos
    
## Building Locally

1. Clone this repository and cd into the working directory

       git clone https://github.com/blake-lucas/bakeos.git
       cd bakeos

1. Make modifications if desired
    
1. Build the image (Note that this will download and the entire image)

       podman build . -t bakeos
    
1. [Podman push](https://docs.podman.io/en/latest/markdown/podman-push.1.html) to a registry of your choice.
1. Rebase to your image to wherever you pushed it:

       sudo rpm-ostree rebase ostree-unverified-registry:whatever/bakeos:latest
   
## Frequently Asked Questions

> What about codecs?

Everything you need is included.

> How do I get my GNOME back to normal Fedora defaults?

We set the default dconf keys in `/etc/dconf/db/local`, removing those keys and updating the database will take you back to the fedora default: 

    sudo rm -f /etc/dconf/db/local
    sudo dconf update
    
If you prefer a vanilla GNOME installation check out [silverblue-main](https://github.com/ublue-os/main) or [silverblue-nvidia](https://github.com/ublue-os/nvidia) for a more upstream experience.

Should I trust you?

> No
