#!/bin/bash
#Create and change ownership of autostart and extension folders since they apparently don't exist by default.
for user in /var/home/*; do mkdir $user/.config/autostart && mkdir $user/.local/share/gnome-shell/extensions && chown $(basename $user):$(basename $user) $user/.config/autostart $user/.local/share/gnome-shell/extensions -R; done

#If a users local extensions folder doesn't have all the extensions in /etc/gnome-extensions, copy them and dump a script to their autostart folder to enable on login. If the user has all the extensions in their extension folder, the script will do nothing other than delete itself on login each time.
for ext in /etc/gnome-extensions/*; do for user in /var/home/*; do if [ ! -d "$user/.local/share/gnome-shell/extensions/$(basename $ext)" ]; then cp -r "$ext" "$user/.local/share/gnome-shell/extensions/" && echo "gnome-extensions enable $(basename $ext)" >> $user/.config/autostart/enable-extensions.sh && chmod +x $user/.config/autostart/enable-extensions.sh; fi; done done && for user in /var/home/*; do echo "rm -f $user/.config/autostart/enable-extensions.sh" >> $user/.config/autostart/enable-extensions.sh; done
