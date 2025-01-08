#!/bin/bash
trap "echo; exit" INT
remotes=(dev wp3 wp4 bastion wafmaster wph tripletex afk avvir kleins krydra upk bfkstats flightpark entercard)

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
    echo -e "Sending .dotfiles to $remote:~$user/ ..."
    scp /home/lasse/.bashrc /home/lasse/.tmux.conf /home/lasse/.vimrc "$remote:~$user/"

    # Install tmux tpm manager if not exists
    if ! ssh "$user@$remote" "test -d ~$user/.tmux/plugins/tpm"; then
        echo -e "\nInstalling tmux tpm to $remote:~$user/ ..."
        ssh "$user@$remote" git clone https://github.com/tmux-plugins/tpm ~$user/.tmux/plugins/tpm
    fi

    # Install fzf if not exists
    if ! ssh "$user@$remote" "test -d ~$user/.fzf"; then
        echo -e "\nInstalling fzf to $remote:~$user/ ..."
        echo "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install" | ssh "$user@$remote"
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
