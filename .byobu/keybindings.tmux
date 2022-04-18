source $BYOBU_CONFIG_DIR/f-keys.tmux

unbind-key -n C-a
unbind-key -n C-s
unbind-key -n C-q
set -g prefix ^Q
set -g prefix2 ^Q
bind q send-prefix

bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

bind-key -n M-h select-pane -L
bind-key -n M-j select-pane -D
bind-key -n M-k select-pane -U
bind-key -n M-l select-pane -R
bind-key -n M-z resize-pane -Z

unbind p
bind p paste-buffer
bind Escape copy-mode
bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
bind-key -T copy-mode-vi 'y' send-keys -X copy-selection-and-cancel
