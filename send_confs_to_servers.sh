#!/bin/bash
trap "echo; exit" INT
servers=(dev wp3 wp4 bastion wafmaster wph tripletex afk avvir kleins krydra upk)

# First argument is target server. Comma-separated for multiple, defaults to all in $servers array.
if [ -z "$1" ]; then
    target="--all"
else
    IFS=',' read -r -a target <<< "$1"
fi

# Remote username argument defaults to lasse
if [ -z "$2" ] || [ "$2" = "--all" ]; then
    user="lasse"
else
    user="$2"
fi

send_configs() {
    local server="$1"
    echo -e "Sending configs to $server:/home/$user/ ..."
    scp /home/lasse/.bashrc /home/lasse/.tmux.conf /home/lasse/.vimrc "$server:/home/$user/"

    # Install tmux tpm manager if not exists
    if ! ssh "$user@$server" "test -d /home/$user/.tmux"; then
        echo -e "\nInstalling tmux tpm to $server:/home/$user/ ..."
        ssh "$user@$server" git clone https://github.com/tmux-plugins/tpm /home/$user/.tmux/plugins/tpm
    fi

    echo -e "\n$server done!\n\n--------------\n"
}

# Send to all servers
if [ "$target" = "--all" ]; then
    for server in "${servers[@]}"; do
        send_configs "$server"
    done
else
    for server in "${target[@]}"; do
        send_configs "$server"
    done
fi
