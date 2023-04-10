#!/bin/bash
#I'm not a bash expert so no bully pls

#Run the following stuff for every user under /var/home (default path)
for user in /var/home/*; do
  #Create folders that don't exist by default
  mkdir -p $user/.config/autostart
  mkdir -p $user/.config/rustdesk
  mkdir -p $user/.config/Nextcloud
  mkdir -p $user/.local/share/gnome-shell/extensions

  #If the user doesn't have a justfile, copy the one from /etc/skel.d
  if [ ! -f "$user/.justfile" ];
    then cp -r "/etc/skel.d/.justfile" "$user/.justfile"
  fi;

  #If a user doesn't have a .zshrc, change the default shell and copy ohmyzsh plugins and such
  if [ ! -f "$user/.zshrc" ];
    then cp -r "/etc/skel.d/.oh-my-zsh" "$user/" && cp "/etc/skel.d/.zshrc" "$user/.zshrc" && usermod -s /usr/bin/zsh $(basename $user)
  fi;

  #Copy rustdesk server config to each users profile
  if [ ! -f "$user/.config/rustdesk/RustDesk2.toml" ];
    then cp -r "/etc/skel.d/.config/rustdesk/RustDesk2.toml" "$user/.config/rustdesk/RustDesk2.toml"
  fi;

  #Copy NextCloud config to each users profile. This disables crash reporting and enables monochrome icons
  if [ ! -f "$user/.config/Nextcloud/nextcloud.cfg" ];
    then cp -r "/etc/skel.d/.config/Nextcloud/nextcloud.cfg" "$user/.config/Nextcloud/nextcloud.cfg"
  fi;

  #Copy GNOME extensions if they don't exist for the user. If the user disables the extension, the folder is still present and won't be automatically enabled again.
  #Uninstalling extensions will probably force enable it again though
  for ext in /etc/gnome-extensions/*; do
      if [ ! -d "$user/.local/share/gnome-shell/extensions/$(basename $ext)" ];
        then cp -r "$ext" "$user/.local/share/gnome-shell/extensions/"
        echo "gnome-extensions enable $(basename $ext)" >> $user/.config/autostart/bakeos-everyboot.sh
        chmod +x $user/.config/autostart/bakeos-everyboot.sh
      fi;
  done

  #Add lines to script to set default Nautilus terminal stuff via https://github.com/Stunkymonkey/nautilus-open-any-terminal
  echo "gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal blackbox" >> $user/.config/autostart/bakeos-everyboot.sh
  echo "gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true" >> $user/.config/autostart/bakeos-everyboot.sh
  echo "gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak user" >> $user/.config/autostart/bakeos-everyboot.sh

  #Not sure where these come from and I'm too lazy to figure it out so just delete them lol
  echo "rm -f $user/Desktop/network.desktop $user/Desktop/user-home.desktop $user/Desktop/trash-can.desktop $user/Desktop/computer.desktop" >> $user/.config/autostart/bakeos-everyboot.sh

  #Add a line for the script to delete itself after being run
  echo "rm -f $user/.config/autostart/bakeos-everyboot.sh && rm -f $user/.config/autostart/bakeos-everyboot.desktop" >> $user/.config/autostart/bakeos-everyboot.sh

  #GNOME won't directly run a .sh so make a .desktop for the script
  echo "[Desktop Entry]" > $user/.config/autostart/bakeos-everyboot.desktop
  echo "Name=bakeos-everyboot" >> $user/.config/autostart/bakeos-everyboot.desktop
  echo "Exec=$user/.config/autostart/bakeos-everyboot.sh" >> $user/.config/autostart/bakeos-everyboot.desktop
  echo "Terminal=false" >> $user/.config/autostart/bakeos-everyboot.desktop
  echo "Type=Application" >> $user/.config/autostart/bakeos-everyboot.desktop
  echo "X-GNOME-Autostart-enabled=true" >> $user/.config/autostart/bakeos-everyboot.desktop

  #Set ownership of justfile, zsh stuff, autostart and extension folders for each user profile
  chown $(basename $user):$(basename $user) $user/.config/autostart $user/.local/share/gnome-shell/extensions $user/.config/rustdesk $user/.config/Nextcloud $user/.justfile $user/.oh-my-zsh $user/.zshrc -R
  chmod +x $user/.config/autostart/bakeos-everyboot.sh $user/.config/autostart/bakeos-everyboot.desktop
done