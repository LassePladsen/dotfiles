#!/bin/bash
pane_path=$(tmux display-message -p '#{pane_current_path}')
cd "$pane_path" || exit
lazygit
