default:
    @just --list
    
bios:
  systemctl reboot --firmware-setup

changelogs:
  rpm-ostree db diff --changelogs

distrobox-debian:
  echo 'Creating Debian distrobox ...'
  distrobox create --image quay.io/toolbx-images/debian-toolbox:unstable -n debian -Y

distrobox-opensuse:
  echo 'Creating openSUSE distrobox ...'
  distrobox create --image quay.io/toolbx-images/opensuse-toolbox:tumbleweed -n opensuse -Y
 
distrobox-ubuntu:
  echo 'Creating Ubuntu distrobox ...'
  distrobox create --image quay.io/toolbx-images/ubuntu-toolbox:22.04 -n ubuntu -Y

update:
  rpm-ostree update
  flatpak update -y
  distrobox upgrade -a
  
yafti:
  yafti /etc/yafti.yml

steam-mesa-git:
  systemctl --user set-environment FLATPAK_GL_DRIVERS=mesa-git
  systemctl --user restart flatpak-portal.service
  FLATPAK_GL_DRIVERS=mesa-git flatpak run com.valvesoftware.Steam

distrobox-init
  distrobox assemble create --file /etc/distrobox/assemble.ini

distrobox-init-nvidia
  distrobox assemble create --file /etc/distrobox/assemble-nvidia.ini

#apx-init:
#  apx init
#  apx update
#  apx upgrade -y
#  apx run sudo apt install git nano wget curl zip unzip software-properties-common language-pack-en -y
#  apx run sudo update-locale
#  echo "Package: *" > /tmp/99mozillateam
#  echo "Pin: release o=LP-PPA-mozillateam" >> /tmp/99mozillateam
#  echo "Pin-Priority: 1001" >> /tmp/99mozillateam
#  apx run sudo cp /tmp/99mozillateam /etc/apt/preferences.d/99mozillateam
#  apx run sudo add-apt-repository ppa:mozillateam/ppa -y
#  apx run sudo apt install firefox -y
#  apx --dnf init
#  apx --dnf update -y
#  apx --dnf run sudo dnf install git nano zip unzip curl wget -y
#  
#apx-nvidia:
#  apx --dnf run sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(cat /etc/fedora-release | awk '{print $3}').noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(cat /etc/fedora-release | awk '{print $3}').noarch.rpm -y
#  apx --dnf run sudo dnf install xorg-x11-drv-nvidia-libs.i686 akmod-nvidia -y
#  apx run sudo apt install software-properties-common -y
#  apx run sudo add-apt-repository multiverse -y
#  apx run sudo apt install nvidia-driver-$(nvidia-smi --query-gpu=driver_version --format=csv | tail -n +2 | cut -c -3) -y
#  
#apx-amd:
#  apx --dnf run sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(cat /etc/fedora-release | awk '{print $3}').noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(cat /etc/fedora-release | awk '{print $3}').noarch.rpm -y
#  apx --dnf run sudo dnf install xorg-x11-drv-amdgpu mesa-libGL.i686 mesa-dri-drivers.i686 -y
#  apx run sudo apt install software-properties-common -y
#  apx run sudo add-apt-repository multiverse -y
#  apx run sudo apt install mesa-utils mesa-utils-extra -y
#  
#apx-intel:
#  apx --dnf run sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(cat /etc/fedora-release | awk '{print $3}').noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(cat /etc/fedora-release | awk '{print $3}').noarch.rpm -y
#  apx --dnf run sudo dnf install xorg-x11-drv-intel mesa-libGL.i686 mesa-dri-drivers.i686 -y
#  apx run sudo apt install software-properties-common -y
#  apx run sudo add-apt-repository multiverse -y
#  apx run sudo apt install mesa-utils mesa-utils-extra -y

set-kargs:
    rpm-ostree kargs \
        --append=rd.driver.blacklist=nouveau \
        --append=modprobe.blacklist=nouveau \
        --append=nvidia-drm.modeset=1

enroll-secure-boot-key:
    sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der

test-cuda:
    podman run \
        --user 1000:1000 \
        --security-opt=no-new-privileges \
        --cap-drop=ALL \
        --security-opt label=type:nvidia_container_t  \
        docker.io/mirrorgooglecontainers/cuda-vector-add:v0.1

setup-firefox-flatpak-vaapi:
    flatpak override \
        --user \
        --filesystem=host-os \
        --env=LIBVA_DRIVER_NAME=nvidia \
        --env=LIBVA_DRIVERS_PATH=/run/host/usr/lib64/dri \
        --env=LIBVA_MESSAGING_LEVEL=1 \
        --env=MOZ_DISABLE_RDD_SANDBOX=1 \
        --env=NVD_BACKEND=direct \
        org.mozilla.firefox
