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

#COPY --from=docker.io/bketelsen/vanilla-os:v0.0.12 /usr/share/backgrounds/vanilla /usr/share/backgrounds/vanilla
#COPY --from=docker.io/bketelsen/vanilla-os:v0.0.12 /usr/share/gnome-background-properties/vanilla.xml /usr/share/gnome-background-properties/vanilla.xml

#APX install - https://github.com/Vanilla-OS/apx
#COPY --from=docker.io/bketelsen/apx:latest /usr/bin/apx /usr/bin/apx
#COPY --from=docker.io/bketelsen/apx:latest /etc/apx/config.json /etc/apx/config.json
#COPY --from=docker.io/bketelsen/apx:latest /usr/share/apx /usr/share/apx
RUN wget https://github.com/Vanilla-OS/apx/releases/latest/download/apx_Linux_x86_64.tar.gz -O /tmp/apx_Linux_x86_64.tar.gz
RUN tar xzvf /tmp/apx_Linux_x86_64.tar.gz --directory /tmp/
RUN mv /tmp/apx /usr/bin/apx
RUN ln -s /usr/bin/apx /usr/share/apx
RUN mkdir /etc/apx
RUN wget https://raw.githubusercontent.com/Vanilla-OS/apx/main/config/config.json -O /etc/apx/config.json

#GNOME extensions
#RUN git clone https://github.com/vchlum/wireless-hid.git && cd wireless-hid && pwd && ls && glib-compile-schemas schemas && gnome-extensions pack --force --extra-source=LICENSE --extra-source=README.md --extra-source=CHANGELOG.md --extra-source=ui --extra-source=wirelesshid.js --extra-source=prefs.css && mv "wireless-hid@chlumskyvaclav.gmail.com.shell-extension.zip" "wireless-hid@chlumskyvaclav.gmail.com.zip" && gnome-extensions install wireless-hid@chlumskyvaclav.gmail.com.zip
#Wireless HID
#RUN wget https://github.com/brunelli/gnome-shell-extension-installer/releases/latest/download/gnome-shell-extension-installer && chmod +x ./gnome-shell-extension-installer && ./gnome-shell-extension-installer 4228 43 --yes
ADD https://extensions.gnome.org/extension-data/arcmenuarcmenu.com.v43.shell-extension.zip                                  /tmp/extensions/arcmenu@arcmenu.com.zip
ADD https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v46.shell-extension.zip               /tmp/extensions/appindicatorsupport@rgcjonas.gmail.com.zip
ADD https://extensions.gnome.org/extension-data/wireless-hidchlumskyvaclav.gmail.com.v10.shell-extension.zip                /tmp/extensions/wireless-hid@chlumskyvaclav.gmail.com.zip
ADD https://extensions.gnome.org/extension-data/dash-to-paneljderose9.github.com.v55.shell-extension.zip                    /tmp/extensions/dash-to-panel@jderose9.github.com

RUN cd /tmp/extensions && \
    for EXTENSION in *.zip; do \
        unzip "${EXTENSION}" -d "/usr/share/gnome-shell/extensions/${EXTENSION%.*}"; \
    done
RUN sudo rm -rf /tmp/extensions

#RUN wget https://copr.fedorainfracloud.org/coprs/kylegospo/gnome-vrr/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-gnome-vrr-fedora-"${FEDORA_MAJOR_VERSION}".repo -O /etc/yum.repos.d/_copr_kylegospo-gnome-vrr.repo
#RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:kylegospo:gnome-vrr mutter gnome-control-center gnome-control-center-filesystem

ADD packages.json /tmp/packages.json
ADD build.sh /tmp/build.sh

RUN /tmp/build.sh && \
    pip install --prefix=/usr yafti && \
    systemctl unmask dconf-update.service && \
    systemctl enable dconf-update.service && \
    systemctl enable rpm-ostree-countme.service && \
    fc-cache -f /usr/share/fonts/ubuntu && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp
