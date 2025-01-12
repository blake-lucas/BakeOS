ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-silverblue}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-$BASE_IMAGE_NAME-$IMAGE_FLAVOR}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG IMAGE_TYPE="${IMAGE_TYPE}"
ARG IMAGE_FLAVOR="${IMAGE_TYPE}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

RUN echo flavor: $IMAGE_FLAVOR type: $IMAGE_TYPE name: $IMAGE_NAME

COPY etc /etc
COPY usr /usr
COPY tmp /tmp

#Nobara kernel, mesa, and mutter (vrr patch)
#RUN wget https://copr.fedorainfracloud.org/coprs/gloriouseggroll/nobara/repo/fedora-"${FEDORA_MAJOR_VERSION}"/gloriouseggroll-nobara-fedora-"${FEDORA_MAJOR_VERSION}".repo -O /etc/yum.repos.d/nobara.repo
#RUN if [ "$IMAGE_TYPE" != *"lts"* ] && [ "$IMAGE_FLAVOR" != *"nvidia"* ]; then \
#        rpm-ostree cliwrap install-to-root /; \
#        rpm-ostree override remove kernel kernel-core kernel-modules kernel-devel-matched kernel-modules-extra kernel-modules-core; \
#        rpm-ostree override --experimental replace kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra --from repo=nobara-baseos; \
#    fi

#If nvidia image, copy gdm.conf to disable Wayland
RUN if [ "$IMAGE_FLAVOR" == *"nvidia"* ] && [ "$BASE_IMAGE_NAME" == "silverblue" ]; then \
        echo "Disabling Wayland via gdm custom.conf"; \
        cat /tmp/gdm.conf; \
        cp -f /tmp/gdm.conf /etc/gdm/custom.conf; \
    fi

#Replace mesa stuff with git versions for images other than lts
RUN if [ "$IMAGE_TYPE" != "lts" ]; then \
        rpm-ostree override remove mesa-va-drivers-freeworld; \
        rpm-ostree override --experimental replace mesa-libglapi mesa-libxatracker mesa-dri-drivers mesa-libgbm mesa-libEGL mesa-libGL \
        mesa-filesystem mesa-vdpau-drivers mesa-vulkan-drivers --from repo=mesa-git; \
        rpm-ostree install mesa-va-drivers; \
    fi

#Use Rocky Linux Kernel, firmware, and mesa if "lts" image
RUN if [ "${IMAGE_TYPE}" == "lts" ]; then \
        rpm -qa | grep firmware; \
        rpm -qa | grep kernel; \
        rm -f /etc/yum.repos.d/nobara.repo; \
        #cliwarp needed for kernel replacement
        rpm-ostree cliwrap install-to-root /; \
        #Remove current kernel
        #rpm-ostree override --experimental replace kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-devel kernel-devel-matched kernel-headers --replace kernel-longterm kernel-longterm-core kernel-longterm-modules kernel-longterm-modules-extra --from repo='copr:copr.fedorainfracloud.org:kwizart:kernel-longterm-5.15'; \
    fi
#Split this into two RUNs since GitHub wasn't throwing errors on fails

COPY download-firmware.py /tmp/download-firmware.py

#Yeah I couldn't get this stupid firmware package replacement stuff working so I just brute force it by extracting the .rpm itself lol
#Latest linux-firmware from Rocky Linux 9 is downloaded via download-firmware.py
#linux-firmware git is copied first to cover any firmware stuff the Rocky package is missing.
COPY rocky-firmware.sh /tmp/rocky-firmware.sh
RUN if [ "${IMAGE_TYPE}" == "lts" ]; then \
        rm -rf /lib/firmware/*; \
        cd /tmp; \
        git clone git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git; \
        mv /tmp/linux-firmware/* /lib/firmware/; \
        rpm-ostree install python3-pip; \
        chmod +x ./rocky-firmware.sh && ./rocky-firmware.sh; \
    fi

#Delete /etc/yum.repos.d/nobara.repo if image is F38 or higher
RUN if [ "${FEDORA_MAJOR_VERSION}" -ge 38 ]; then \
        rm -f /etc/yum.repos.d/nobara.repo; \
    fi

##Latest linux-firmware on images other than lts
#RUN if [ "$IMAGE_TYPE" != "lts" ]; then \
#        cd /tmp; \
#        git clone git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git; \
#        rm -rf /lib/firmware/*; \
#        mv /tmp/linux-firmware/* /lib/firmware/; \
#    fi

#Download AppimageLauncher RPM. Package is installed via build.sh and packages.json.
RUN wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm -qO /tmp/appimagelauncher.rpm

#RustDesk download. Install is handled by build.sh and is at the top of the packages.json file.
RUN wget https://github.com/rustdesk/rustdesk/releases/download/1.2.3/rustdesk-1.2.3-0.x86_64.rpm -qO /tmp/rustdesk.rpm

#NextShot download and install
#RUN git clone -b master https://github.com/dshoreman/nextshot.git && \
#    cd nextshot && \
#    make install && \
#    rm -rf /nextshot
#Make install seems to be broken so just download the latest binary instead
RUN wget https://github.com/dshoreman/nextshot/releases/latest/download/nextshot -qO /usr/bin/nextshot && chmod +x /usr/bin/nextshot

#GNOME extensions
RUN if [ "${BASE_IMAGE_NAME}" == "silverblue" ]; then \
        mkdir /tmp/extensions && \
        wget https://extensions.gnome.org/extension-data/arcmenuarcmenu.com.v44.shell-extension.zip                          -qO /tmp/extensions/arcmenu@arcmenu.com.zip                          ; \
        wget https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v53.shell-extension.zip       -qO /tmp/extensions/appindicatorsupport@rgcjonas.gmail.com.zip       ; \
        wget https://extensions.gnome.org/extension-data/wireless-hidchlumskyvaclav.gmail.com.v11.shell-extension.zip        -qO /tmp/extensions/wireless-hid@chlumskyvaclav.gmail.com.zip        ; \
        wget https://extensions.gnome.org/extension-data/dash-to-paneljderose9.github.com.v56.shell-extension.zip            -qO /tmp/extensions/dash-to-panel@jderose9.github.com.zip            ; \
        wget https://extensions.gnome.org/extension-data/panoelhan.io.v19.shell-extension.zip                                -qO /tmp/extensions/pano@elhan.io.zip                                ; \
        wget https://extensions.gnome.org/extension-data/tiling-assistantleleat-on-github.v40.shell-extension.zip            -qO /tmp/extensions/tiling-assistant@leleat-on-github.zip            ; \
        wget https://extensions.gnome.org/extension-data/quick-settings-tweaksqwreey.v17.shell-extension.zip                 -qO /tmp/extensions/quick-settings-tweaks@qwreey.zip                 ; \
        wget https://extensions.gnome.org/extension-data/dingrastersoft.com.v56.shell-extension.zip                          -qO /tmp/extensions/ding@rastersoft.com.zip                          ; \
        git clone https://github.com/nunofarruca/WindowIsReady_Remover.git                                                       /tmp/WindowIsReady_Remover                                       ; \
    fi
#Part 2
RUN if [ "${BASE_IMAGE_NAME}" == "silverblue" ]; then \
        cd /tmp/extensions; \
        mkdir /etc/gnome-extensions; \
        rm -f /tmp/WindowIsReady_Remover/README.md; \
        mv /tmp/WindowIsReady_Remover/windowIsReady_Remover@nunofarruca@gmail.com /etc/gnome-extensions/; \
        for EXTENSION in *.zip; do \
            unzip -q "${EXTENSION}" -d "/etc/gnome-extensions/${EXTENSION%.*}"; \
        done; \
        rm -rf /tmp/extensions; \
        chmod 755 /etc/gnome-extensions -R; \
    fi

#ZSH plugins. See /etc/skel.d/.oh-my-zsh/templates/zshrc.zsh-template for default zshrc
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /etc/skel.d/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /etc/skel.d/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    chmod 755 /etc/skel.d -R

#Download latest gdu and move to /usr/bin per the instructions at https://github.com/dundee/gdu#installation
RUN curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz && chmod +x gdu_linux_amd64 && mv gdu_linux_amd64 /usr/bin/gdu

#Download WoeUSB binary and dump to /usr/bin/woeusb
RUN wget https://github.com/WoeUSB/WoeUSB/releases/download/v5.2.4/woeusb-5.2.4.bash -qO /usr/bin/woeusb && chmod +x /usr/bin/woeusb

#GTK3 Adawait theme
RUN wget https://github.com/lassekongo83/adw-gtk3/releases/download/v4.6/adw-gtk3v4-6.tar.xz -O /tmp/adw-gtk3.tar.xz && \
    sudo tar -xvf /tmp/adw-gtk3.tar.xz -C /usr/share/themes

#If building silverblue image, install additional stuffs
#RUN if [ "${BASE_IMAGE_NAME}" == "silverblue" ]; then \
#        rpm-ostree install  adw-gtk3-theme \
#                            gnome-tweaks \
#                            raw-thumbnailer \
#                            yaru-theme \
#                            gnome-shell-extension-appindicator \
#                            gnome-shell-extension-blur-my-shell \
#                            gnome-shell-extension-caffeine \
#                            gnome-shell-extension-gsconnect \
#                            gnome-text-editor \
#                            nautilus-gsconnect; \
#    fi

COPY packages.json /tmp/packages.json
COPY build.sh /tmp/build.sh

RUN /tmp/build.sh && \
    #Install yafti setup thing
    pip install --prefix=/usr yafti && \
    #pip install --prefix=/usr nautilus-open-any-terminal && \
    glib-compile-schemas /usr/share/glib-2.0/schemas && \
    systemctl unmask dconf-update.service && \
    systemctl enable dconf-update.service && \
    #Install Docker over Podman due to crun permission denied bs I don't want to keep resetting containers
    systemctl enable docker.service && \
    systemctl enable rpm-ostree-countme.service && \
    systemctl enable bakeos-everyboot.service && \
    systemctl enable tailscaled.service && \
    systemctl disable rustdesk && \
    systemctl enable sshd && \
    chmod +x /etc/profile.d/bakeos-everyboot.sh && \
    fc-cache -f /usr/share/fonts/ubuntu && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    rm -rf /tmp/* /var/* && \
    echo "After build.sh: $(sha256sum /lib/firmware/amd-ucode/microcode_amd.bin.xz)" && \
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp
