#!/bin/bash
trap "echo; exit" INT
remotes=(dev wp3 wp4 bastion wafmaster wph tripletex afk avvir kleins krydra upk bfkstats flightpark)

# First argument is target remote. Comma-separated for multiple, defaults to all in $remotes array.
if [ -z "$1" ] || [ "$1" = "-a" ]; then
    target="--all"
else
    IFS=',' read -r -a target <<< "$1"
fi

# Remote username argument defaults to lasse
if [ -z "$2" ]; then
    user="lasse"
else
    user="$2"
fi

send_dotfiles() {
    local remote="$1"
    echo -e "Sending .dotfiles to $remote:/home/$user/ ..."
    scp /home/lasse/.bashrc /home/lasse/.tmux.conf /home/lasse/.vimrc "$remote:/home/$user/"

    # Install tmux tpm manager if not exists
    if ! ssh "$user@$remote" "test -d /home/$user/.tmux"; then
        echo -e "\nInstalling tmux tpm to $remote:/home/$user/ ..."
        ssh "$user@$remote" git clone https://github.com/tmux-plugins/tpm /home/$user/.tmux/plugins/tpm
    fi

    echo -e "\n$remote done!\n\n--------------\n"
}

# Send to all remotes
if [ "$target" = "--all" ]; then
    for remote in "${remotes[@]}"; do
        send_dotfiles "$remote"
    done
else
    for remote in "${target[@]}"; do
        send_dotfiles "$remote"
    done
fi
