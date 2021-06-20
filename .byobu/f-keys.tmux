source $BYOBU_PREFIX/share/byobu/keybindings/f-keys.tmux

# patch to allow for F12 behave like S-F12
bind-key -n S-F12 source $BYOBU_CONFIG_DIR/f-keys.tmux.disable \; display-message "Byobu F-keys: DISABLED"
bind-key -n F12 source $BYOBU_CONFIG_DIR/f-keys.tmux.disable \; display-message "Byobu F-keys: DISABLED"
