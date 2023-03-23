ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-silverblue}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-$BASE_IMAGE_NAME-$IMAGE_FLAVOR}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

COPY etc /etc
COPY usr /usr

#Nobara kernel, mesa, and mutter (vrr patch)
RUN rpm-ostree cliwrap install-to-root /
RUN wget https://copr.fedorainfracloud.org/coprs/gloriouseggroll/nobara/repo/fedora-"${FEDORA_MAJOR_VERSION}"/gloriouseggroll-nobara-fedora-"${FEDORA_MAJOR_VERSION}".repo -O /etc/yum.repos.d/_copr_nobara.repo
#Only replace kernel for Main image since Nvidia driver builds are too much of a pain for me to figure out right now
RUN if ! rpm -qa | grep -qw kmod-nvidia; then rpm-ostree override remove kernel-devel-matched kernel-modules-extra; fi
RUN if ! rpm -qa | grep -qw kmod-nvidia; then rpm-ostree override --experimental replace kernel kernel-core kernel-modules --from repo=copr:copr.fedorainfracloud.org:gloriouseggroll:nobara; fi
RUN rpm-ostree override --experimental replace mesa-libglapi mesa-libxatracker mesa-dri-drivers mesa-libgbm mesa-libEGL mesa-libGL \
    mesa-filesystem mesa-vdpau-drivers mesa-vulkan-drivers mesa-va-drivers-freeworld mutter --from repo=copr:copr.fedorainfracloud.org:gloriouseggroll:nobara

#Latest linux-firmware
RUN cd /tmp && git clone git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git && rm -rf /lib/firmware/* && mv /tmp/linux-firmware/* /lib/firmware/

#Manual download of APX instead maybe
#RUN wget https://github.com/Vanilla-OS/apx/releases/latest/download/apx_Linux_x86_64.tar.gz -O /tmp/apx_Linux_x86_64.tar.gz
#RUN tar xzvf /tmp/apx_Linux_x86_64.tar.gz --directory /tmp/
#RUN mv /tmp/apx /usr/bin/apx
#RUN ln -s /usr/bin/apx /usr/share/apx
#RUN mkdir /etc/apx
#RUN wget https://raw.githubusercontent.com/Vanilla-OS/apx/main/config/config.json -O /etc/apx/config.json
#Doesn't work lol. Lets just use the dudes build for now
#APX install - https://github.com/Vanilla-OS/apx
COPY --from=docker.io/bketelsen/apx:latest /usr/bin/apx /usr/bin/apx
COPY --from=docker.io/bketelsen/apx:latest /etc/apx/config.json /etc/apx/config.json
COPY --from=docker.io/bketelsen/apx:latest /usr/share/apx /usr/share/apx

#RustDesk download. Install is handled by build.sh and is at the top of the packages.json file.
RUN wget https://github.com/rustdesk/rustdesk/releases/download/nightly/rustdesk-1.2.0-0.x86_64-fedora28-centos8.rpm -O /tmp/rustdesk.rpm

#GNOME extensions
#RUN git clone https://github.com/vchlum/wireless-hid.git && cd wireless-hid && pwd && ls && glib-compile-schemas schemas && gnome-extensions pack --force --extra-source=LICENSE --extra-source=README.md --extra-source=CHANGELOG.md --extra-source=ui --extra-source=wirelesshid.js --extra-source=prefs.css && mv "wireless-hid@chlumskyvaclav.gmail.com.shell-extension.zip" "wireless-hid@chlumskyvaclav.gmail.com.zip" && gnome-extensions install wireless-hid@chlumskyvaclav.gmail.com.zip
#Wireless HID
#RUN wget https://github.com/brunelli/gnome-shell-extension-installer/releases/latest/download/gnome-shell-extension-installer && chmod +x ./gnome-shell-extension-installer && ./gnome-shell-extension-installer 4228 43 --yes
ADD https://extensions.gnome.org/extension-data/arcmenuarcmenu.com.v43.shell-extension.zip                                  /tmp/extensions/arcmenu@arcmenu.com.zip
ADD https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v46.shell-extension.zip               /tmp/extensions/appindicatorsupport@rgcjonas.gmail.com.zip
ADD https://extensions.gnome.org/extension-data/wireless-hidchlumskyvaclav.gmail.com.v10.shell-extension.zip                /tmp/extensions/wireless-hid@chlumskyvaclav.gmail.com.zip
ADD https://extensions.gnome.org/extension-data/dash-to-paneljderose9.github.com.v55.shell-extension.zip                    /tmp/extensions/dash-to-panel@jderose9.github.com.zip
ADD https://extensions.gnome.org/extension-data/windowIsReady_Removernunofarrucagmail.com.v19.shell-extension.zip           /tmp/extensions/windowIsReady_Remover@nunofarruca@gmail.com.zip
ADD https://extensions.gnome.org/extension-data/panoelhan.io.v19.shell-extension.zip                                        /tmp/extensions/clipboard-indicator@tudmotu.com.zip
ADD https://extensions.gnome.org/extension-data/tiling-assistantleleat-on-github.v39.shell-extension.zip                    /tmp/extensions/tiling-assistant@leleat-on-github.zip
ADD https://extensions.gnome.org/extension-data/dingrastersoft.com.v54.shell-extension.zip                                  /tmp/extensions/ding@rastersoft.com.zip

RUN cd /tmp/extensions && mkdir /etc/gnome-extensions && \
    for EXTENSION in *.zip; do \
        unzip "${EXTENSION}" -d "/etc/gnome-extensions/${EXTENSION%.*}"; \
    done
RUN sudo rm -rf /tmp/extensions
RUN chmod 755 /etc/gnome-extensions -R

#ZSH plugins. See /etc/skel.d/.oh-my-zsh/templates/zshrc.zsh-template for default zshrc
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /etc/skel.d/.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /etc/skel.d/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN chmod 755 /etc/skel.d -R

#Download latest gdu and move to /usr/bin per the instructions at https://github.com/dundee/gdu#installation
RUN curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz && chmod +x gdu_linux_amd64 && mv gdu_linux_amd64 /usr/bin/gdu

#Set GDM theme/background - Doesn't actually work lol
#RUN git clone --depth=1 --single-branch https://github.com/realmazharhussain/gdm-tools.git && cd gdm-tools && ./install.sh && set-gdm-theme -s default /usr/share/backgrounds/gnome/blobs-l.svg

ADD packages.json /tmp/packages.json
ADD build.sh /tmp/build.sh

RUN /tmp/build.sh && \
    pip install --prefix=/usr yafti && \
    systemctl unmask dconf-update.service && \
    systemctl enable dconf-update.service && \
    systemctl enable rpm-ostree-countme.service && \
    systemctl enable bakeos-everyboot.service && \
    chmod +x /etc/profile.d/bakeos-everyboot.sh && \
    fc-cache -f /usr/share/fonts/ubuntu && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp