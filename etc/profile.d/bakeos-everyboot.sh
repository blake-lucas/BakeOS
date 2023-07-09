#!/bin/bash
#I'm not a bash expert so no bully pls

#Create folders that don't exist by default
mkdir -p ~/.config/autostart
mkdir -p ~/.config/rustdesk
#mkdir -p ~/.config/Nextcloud
mkdir -p ~/.local/share/gnome-shell/extensions

#If the user doesn't have a justfile, copy the one from /etc/skel.d
if [ ! -f ~/.justfile ];
  then cp -r "/etc/skel.d/.justfile" ~/.justfile
fi;

#If a user doesn't have ~/.oh-my-zsy, change the default shell and copy ohmyzsh plugins and such
if [ ! -d ~/.oh-my-zsh ];
  then cp -r "/etc/skel.d/.oh-my-zsh" ~/ && cp "/etc/skel.d/.zshrc" ~/.zshrc
fi;

#If users shell isn't found to be ZSH according to /etc/passwd, ask to change it

if [ ! -f ~/.disablezsh ]; then
  if [ -z "$(cat /etc/passwd | grep "$USER" | grep zsh)" ]; then
    echo "$USER's default shell is not ZSH according to /etc/passwd." && echo "You can disable this check with: touch ~/.disablezsh" && chsh -s $(which zsh) && echo "You may need to sign out and back in for this to apply."
  fi;
fi;

#Copy rustdesk server config to each users profile
if [ ! -f ~/.config/rustdesk/RustDesk2.toml ];
  then cp -r "/etc/skel.d/.config/rustdesk/RustDesk2.toml" ~/.config/rustdesk/RustDesk2.toml
fi;

#Copy NextCloud config to each users profile. This disables crash reporting and enables monochrome icons
#if [ ! -f "~/.config/Nextcloud/nextcloud.cfg" ];
#  then cp -r "/etc/skel.d/.config/Nextcloud/nextcloud.cfg" ~/.config/Nextcloud/nextcloud.cfg
#fi;

#Copy GNOME extensions if they don't exist for the user. If the user disables the extension, the folder is still present and won't be automatically enabled again.
#Uninstalling extensions will probably force enable it again though
if [ -n "$(gnome-shell --version)" ];
    then for ext in /etc/gnome-extensions/*; do
        if [ ! -d ~/.local/share/gnome-shell/extensions/"$(basename "$ext")" ];
          then cp -r "$ext" ~/.local/share/gnome-shell/extensions/
          gnome-extensions enable "$(basename "$ext")"
        fi;
    done
fi;

#Set ownership of justfile, zsh stuff, autostart and extension folders for each user profile
chown "$USER":"$USER" ~/.config/autostart ~/.local/share/gnome-shell/extensions ~/.config/rustdesk ~/.justfile ~/.oh-my-zsh ~/.zshrc -R

#Not sure where these come from and I'm too lazy to figure it out so just delete them lol
rm -f ~/Desktop/network.desktop ~/Desktop/user-home.desktop ~/Desktop/trash-can.desktop ~/Desktop/computer.desktop

## System-wide install for this doesn't work anymore - https://github.com/Stunkymonkey/nautilus-open-any-terminal/issues/86
##Run these to set default Nautilus terminal stuff via https://github.com/Stunkymonkey/nautilus-open-any-terminal
#gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal blackbox
#gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak user
#gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true