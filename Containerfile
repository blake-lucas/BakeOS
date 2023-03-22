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

#Latest mesa drivers via copr repo
RUN wget https://copr.fedorainfracloud.org/coprs/xxmitsu/mesa-git/repo/fedora-"${FEDORA_MAJOR_VERSION}"/xxmitsu-mesa-git-fedora-"${FEDORA_MAJOR_VERSION}".repo -O /etc/yum.repos.d/_copr_mesa.repo
RUN rpm-ostree override --experimental replace --from repo=copr:copr.fedorainfracloud.org:xxmitsu:mesa-git mesa-dri-drivers

#Latest linux-firmware
RUN cd /tmp && git clone git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git && rm -rf /lib/firmware/* && mv /tmp/linux-firmware/* /lib/firmware/

#Nobara kernel and mutter (vrr patch) install
RUN rpm-ostree cliwrap install-to-root /
RUN wget https://copr.fedorainfracloud.org/coprs/gloriouseggroll/nobara/repo/fedora-"${FEDORA_MAJOR_VERSION}"/gloriouseggroll-nobara-fedora-"${FEDORA_MAJOR_VERSION}".repo -O /etc/yum.repos.d/_copr_nobara.repo
RUN rpm-ostree override remove kernel-devel-matched kernel-modules-extra && rpm-ostree override --experimental replace --from repo=copr:copr.fedorainfracloud.org:gloriouseggroll:nobara kernel kernel-core kernel-modules mutter

#COPY --from=docker.io/bketelsen/vanilla-os:v0.0.12 /usr/share/backgrounds/vanilla /usr/share/backgrounds/vanilla
#COPY --from=docker.io/bketelsen/vanilla-os:v0.0.12 /usr/share/gnome-background-properties/vanilla.xml /usr/share/gnome-background-properties/vanilla.xml

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

RUN cd /tmp/extensions && mkdir /etc/gnome-extensions && \
    for EXTENSION in *.zip; do \
        unzip "${EXTENSION}" -d "/etc/gnome-extensions/${EXTENSION%.*}"; \
    done
RUN sudo rm -rf /tmp/extensions
RUN chmod 755 /etc/gnome-extensions -R

ADD packages.json /tmp/packages.json
ADD build.sh /tmp/build.sh

RUN /tmp/build.sh && \
    pip install --prefix=/usr yafti && \
    systemctl unmask dconf-update.service && \
    systemctl enable dconf-update.service && \
    systemctl enable rpm-ostree-countme.service && \
    systemctl enable copy-gnome-exts.service && \
    chmod +x /etc/copy-gnome-exts.sh && \
    fc-cache -f /usr/share/fonts/ubuntu && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp
