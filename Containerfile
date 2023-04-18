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
#RUN wget https://copr.fedorainfracloud.org/coprs/gloriouseggroll/nobara/repo/fedora-"${FEDORA_MAJOR_VERSION}"/gloriouseggroll-nobara-fedora-"${FEDORA_MAJOR_VERSION}".repo -O /etc/yum.repos.d/nobara.repo
#Only replace kernel for Main image since Nvidia driver builds are too much of a pain for me to figure out right now
#RUN if ! rpm -qa | grep -qw kmod-nvidia; then rpm-ostree override remove kernel-devel-matched kernel-modules-extra kernel-modules-core; fi
#RUN if ! rpm -qa | grep -qw kmod-nvidia; then rpm-ostree override --experimental replace kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra --from repo=nobara-baseos; fi

#Only replace stuff with Nobara versions if image is F37 or lower
RUN if [ "${FEDORA_MAJOR_VERSION}" -le 37 ]; then \
        rpm-ostree override --experimental replace mesa-libglapi mesa-libxatracker mesa-dri-drivers mesa-libgbm mesa-libEGL mesa-libGL \
        mesa-filesystem mesa-vdpau-drivers mesa-vulkan-drivers mesa-va-drivers-freeworld mutter --from repo=nobara-baseos; \
    fi
#Delete /etc/yum.repos.d/nobara.repo if image is F38 or higher
RUN if [ "${FEDORA_MAJOR_VERSION}" -ge 38 ]; then \
        rm -f /etc/yum.repos.d/nobara.repo; \
    fi

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

#Download AppimageLauncher RPM. Package is installed via build.sh and packages.json.
RUN wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm -qO /tmp/appimagelauncher.rpm

#RustDesk download. Install is handled by build.sh and is at the top of the packages.json file.
RUN wget https://github.com/rustdesk/rustdesk/releases/download/nightly/rustdesk-1.2.0-0.x86_64-fedora28-centos8.rpm -qO /tmp/rustdesk.rpm

#NextShot download and install
RUN git clone -b master https://github.com/dshoreman/nextshot.git && \
    cd nextshot && \
    make install && \
    rm -rf /nextshot

#GNOME extensions
RUN mkdir /tmp/extensions && \
    wget https://extensions.gnome.org/extension-data/arcmenuarcmenu.com.v43.shell-extension.zip                          -qO /tmp/extensions/arcmenu@arcmenu.com.zip                          && \
    wget https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v46.shell-extension.zip       -qO /tmp/extensions/appindicatorsupport@rgcjonas.gmail.com.zip       && \
    wget https://extensions.gnome.org/extension-data/wireless-hidchlumskyvaclav.gmail.com.v10.shell-extension.zip        -qO /tmp/extensions/wireless-hid@chlumskyvaclav.gmail.com.zip        && \
    wget https://extensions.gnome.org/extension-data/dash-to-paneljderose9.github.com.v55.shell-extension.zip            -qO /tmp/extensions/dash-to-panel@jderose9.github.com.zip            && \
    wget https://extensions.gnome.org/extension-data/windowIsReady_Removernunofarrucagmail.com.v19.shell-extension.zip   -qO /tmp/extensions/windowIsReady_Remover@nunofarruca@gmail.com.zip  && \
    wget https://extensions.gnome.org/extension-data/panoelhan.io.v19.shell-extension.zip                                -qO /tmp/extensions/pano@elhan.io.zip                                && \
    wget https://extensions.gnome.org/extension-data/tiling-assistantleleat-on-github.v39.shell-extension.zip            -qO /tmp/extensions/tiling-assistant@leleat-on-github.zip            && \
    wget https://extensions.gnome.org/extension-data/quick-settings-tweaksqwreey.v17.shell-extension.zip                 -qO /tmp/extensions/quick-settings-tweaks@qwreey.zip                 && \
    wget https://extensions.gnome.org/extension-data/dingrastersoft.com.v54.shell-extension.zip                          -qO /tmp/extensions/ding@rastersoft.com.zip

RUN cd /tmp/extensions && mkdir /etc/gnome-extensions && \
    for EXTENSION in *.zip; do \
        unzip "${EXTENSION}" -q -d "/etc/gnome-extensions/${EXTENSION%.*}"; \
    done && \
    sudo rm -rf /tmp/extensions && \
    chmod 755 /etc/gnome-extensions -R

#ZSH plugins. See /etc/skel.d/.oh-my-zsh/templates/zshrc.zsh-template for default zshrc
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /etc/skel.d/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /etc/skel.d/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    chmod 755 /etc/skel.d -R

#Download latest gdu and move to /usr/bin per the instructions at https://github.com/dundee/gdu#installation
RUN curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz && chmod +x gdu_linux_amd64 && mv gdu_linux_amd64 /usr/bin/gdu

#Download latest Mullvad RPM and install it - This also doesn't work, install it manually
#RUN mkdir /var/opt && \
#    wget https://mullvad.net/download/app/rpm/latest/ -O /tmp/mullvad.rpm && \
#    rpm-ostree install /tmp/mullvad.rpm && \
#    mv "/var/opt/Mullvad VPN" "/usr/lib/Mullvad VPN"

ADD packages.json /tmp/packages.json
ADD build.sh /tmp/build.sh

RUN /tmp/build.sh && \
    #Install yafti setup thing
    pip install --prefix=/usr yafti && \
    #Remove the gnome-terminal-nautilus package.
    rpm-ostree override remove gnome-terminal-nautilus && \
    #Install nautilus-open-any-terminal system wide.
    pip install --prefix=/usr nautilus-open-any-terminal && \
    glib-compile-schemas /usr/share/glib-2.0/schemas && \
    systemctl unmask dconf-update.service && \
    systemctl enable dconf-update.service && \
    systemctl enable rpm-ostree-countme.service && \
    systemctl enable bakeos-everyboot.service && \
    systemctl enable rustdesk && \
    systemctl enable sshd && \
    chmod +x /etc/profile.d/bakeos-everyboot.sh && \
    fc-cache -f /usr/share/fonts/ubuntu && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp