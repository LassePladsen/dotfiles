#!/usr/bin/bash
targets=(.bashrc .vimrc .inputrc .fzfrc .tmux.conf .fzf .tmux .config scripts)

dotfiles_path=$( cd "$(dirname "${BASH_SOURCE[1]}")" ; pwd -P )

# -f force flag: dont ask to replace files (still backups existing files for now)
force=0
if [[ -n $1 && $1 = "-f" ]]; then
    force=1
fi

for target in "${targets[@]}"; do
    echo "ln -s $dotfiles_path/$target ~/$target"
    ln -s $dotfiles_path/$target ~/$target > /dev/null 2>&1

    # If failed (file exists), ask to replace it after backup, unless force flag
    if [[  $? -ne 0 && $force -eq 0 ]]; then
        read -p "$target already exists... backup and replace it? (y/n) " -s -n 1 answer # wait for input, read one character in silent mode (dont echo typed chars)
        echo ""
    fi

    # Replace if they said yes or used -f flag
    if [[ $force -ne 0 || $answer = 'y' ]]; then
        mv ~/$target ~/$target.bkp
        ln -s $dotfiles_path/$target ~/$target > /dev/null 2>&1
    fi
done

