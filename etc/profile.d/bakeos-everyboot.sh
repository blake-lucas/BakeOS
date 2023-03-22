#!/bin/bash
#I'm not a bash expert so no bully pls

#Create autostart and extension folders since they apparently don't exist by default
for user in /var/home/*; do
  mkdir $user/.config/autostart && mkdir $user/.local/share/gnome-shell/extensions;
done

#If a users local extensions folder doesn't have all the extensions in /etc/gnome-extensions, copy them and dump a script to their autostart folder to enable on login. If the user has all the extensions in their extension folder, the script will do nothing other than delete itself on login each time.
for user in /var/home/*; do
  if [ ! -d "$user/justfile" ];
    then cp -r "/etc/skel.d/justfile" "$user/justfile"
  fi;
  for ext in /etc/gnome-extensions/*; do
      if [ ! -d "$user/.local/share/gnome-shell/extensions/$(basename $ext)" ];
        then cp -r "$ext" "$user/.local/share/gnome-shell/extensions/"
        echo "gnome-extensions enable $(basename $ext)" >> $user/.config/autostart/enable-extensions.sh
        chmod +x $user/.config/autostart/enable-extensions.sh;
      fi;
    done
done
for user in /var/home/*; do
  echo "rm -f $user/.config/autostart/enable-extensions.sh" >> $user/.config/autostart/enable-extensions.sh;
done

#If a user doesn't have a .zshrc, change the default shell and copy ohmyzsh plugins and such
for user in /var/home/*; do
  if [ ! -d "$user/.zshrc" ];
    then cp -r "/etc/skel.d/.oh-my-zsh" "$user/" && cp "/etc/skel.d/.zshrc" "$user/.zshrc" && usermod -s /usr/bin/zsh $(basename $user)
  fi;
done

#Create .desktop file under ~/.config/autostart because GNOME won't directly run a .sh
for user in /var/home/*; do
  echo "[Desktop Entry]" > $user/.config/autostart/enable-extensions.desktop
  echo "Name=Enable-Extensions" >> $user/.config/autostart/enable-extensions.desktop
  echo "Exec=$user/.config/autostart/enable-extensions.sh" >> $user/.config/autostart/enable-extensions.desktop
  echo "Terminal=false" >> $user/.config/autostart/enable-extensions.desktop
  echo "Type=Application" >> $user/.config/autostart/enable-extensions.desktop
  echo "X-GNOME-Autostart-enabled=true" >> $user/.config/autostart/enable-extensions.desktop;
done

#Set ownership of justfile, zsh stuff, autostart and extension folders for each user profile
for user in /var/home/*; do
  chown $(basename $user):$(basename $user) $user/.config/autostart $user/.local/share/gnome-shell/extensions $user/justfile $user/.oh-my-zsh -R;
done