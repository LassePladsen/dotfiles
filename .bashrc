# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
#

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# bash syntax highlight, autocompletion, QoL, and much more: https://github.com/akinomyoga/ble.sh
# also see bottom of this file for part 2
[[ -e "/home/lasse/.local/share/blesh/ble.sh" ]] && [[ $- == *i* ]] && source -- /home/lasse/.local/share/blesh/ble.sh --attach=none

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set term to xterm so that vim has syntax highlighting in tmux when used tmux from root on remote via ssh
# export TERM="xterm-256color"
# export TERM="tmux-256color" # test fix undercurl nvim in tmux. 2025-07-02

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -h'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -d $HOME/.nvm ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ -d $HOME/.pyenv ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"  
fi


############# CUSTOM #####################
### FUNCTIONS ###
# Ssh into a specific directory (note: this can also be configured in the ssh config)
function ssh-cd() {
    ssh -t $1 "cd $2 ; bash --login"
}
alias sshcd="ssh-cd"

# Returns 1 if command exists
function cmd-exists() {
    command -v $1 >/dev/null 2>&1
    return $?
}

# Recursive search and replace excluding .git directories, using find + sed
function sed-recursive() {
    if [ -z "$1" ]; then
	echo "Usage: sed_replace <replace_string>"
	echo "Example: sed_replace 's/wph/WPH/g"
    else
	find . \( -type d -name '.git*' -prune \) -o -type f -exec sed -i "$1" {} \;
    fi
}

# GIT FUNCTIONS
# Think "git previous". does git show with input parameter of the target number commit back from HEAD. Defaults to 0, and accepts arguments if and only if the target number is given.
function gp() {
    target=${1-0} # if arg 1 not given; default to 0.
    shift 1
    git show HEAD~$target $@
}
# Git diff with fuzzy file search
function gd() {
    pattern=$1
    shift 1
    git diff "*$pattern*" $@
}
# Git add with fuzzy file search
function ga() {
    pattern=$1
    shift 1
    git add "*$pattern*" $@
}
# Git restore with fuzzy file search
function gr() {
    pattern=$1
    shift 1
    git restore "*$pattern*" $@
}

# FZF
if [ -d ~/.fzf ]; then
    [ -e ~/.fzf.bash ] && source ~/.fzf.bash
    if [ -e ~/.fzfrc ]; then
	export FZF_DEFAULT_OPTS_FILE="$HOME/.fzfrc"
	export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden' # add dirs to search
    fi

    # Advanced customization of fzf options via _fzf_comprun function
    # - The first argument to the function is the name of the command.
    # - You should make sure to pass the rest of the arguments ($@) to fzf.
    _fzf_comprun() {
	local command=$1
	shift

	case "$command" in
	    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
	    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
	    ssh)          fzf --preview 'dig {}'                   "$@" ;;
	    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
	esac
    }

fi
### END FUNCTIONS ###


### PATHS AND ENVIRONMENT VARIABLES ### 
parse_git_dirty() {
  [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
}
parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}
export OLD_PS1=$PS1
# export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;31m\]$(__git_ps1)\[\e[m\]\$ '
# export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;31m\]$(parse_git_branch)\[\e[m\]\n\$ ' # remove \n to remove new line after path
export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\n\$ ' # claude version claiming to fix potential problems

export PATH="$PATH:/opt/nvim-linux64/bin:$HOME/opt/nvim-linux64/bin:/opt/nvim/bin:$HOME/opt/nvim/bin"
export PATH="$PATH:$HOME/.cargo/bin/"
export PATH="$PATH:$HOME/.local/bin/:$HOME/repos/dotfiles/.local/bin"
export PATH="$PATH:$HOME/go/bin/"

# Stuff for react native android dev
export JAVA_HOME=/usr/lib/jvm/jdk-23.0.1
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Remote list for scripts
export WPH_REMOTES="dev,wp3,wp4,bastion,wafmaster,wph,tripletex,afk,avvir,kleins,krydra,upk,bfkstats,flightpark,entercard"

# Composer global tools
export PATH="$PATH:$HOME/.config/composer/vendor/bin"

# only if nvim exists
if cmd-exists nvim; then 
    # Vim alias.. yolo
    alias vim="nvim"
    alias {vvim,oldvim}="/usr/bin/vim"

    # Default editor. Use nvim if installed, else vim if installed
    export EDITOR="nvim"
    # Command for man help pages. Use nvim if installed, else vim if installed
    export MANPAGER="nvim +Man!"
elif cmd-exists vim; then 
    export EDITOR="vim"
    export MANPAGER="vim -M +MANPAGER - "
fi
### END PATHS ### 

### ALIASES ###
# Typo aliases
alias {chomd,chodm,chmdo,chdmo,cmhod}="chmod"
alias {chwon,chonw,cwhon,cwohn}="chown"


alias {initsession,initsesh,sessioninit,seshinit,init-session,session-init}="~/scripts/session-init.sh"
alias ffind="find -type f -name "
cmd-exists lazygit && alias lg="lazygit"

# diff using delta
alias {olddiff,ddiff}="/usr/bin/diff --color"
cmd-exists kitty && alias diff="delta"

# Force Delta to use side-by-side, for use in git diff to not have to edit gitconfig every time
alias side-by-side="DELTA_FEATURES=+side-by-side"

if cmd-exists kitty && cmd-exists kitten && [ "xterm-kitty" = "$TERM" ]; then
    kitten_ssh_with_fallback() {
	kitten ssh "$@" 
	if [ "$?" == "255" ]; then 
	    echo "Kitten ssh failed, falling back to regular ssh... " && /usr/bin/ssh "$@"
	fi
    }
    alias ssh="kitten_ssh_with_fallback"
    alias {oldssh,sssh}="/usr/bin/ssh"

    # Kitten diff does not work in tmux
    if [[ -z "$TMUX" ]]; then
	# alias diff="kitten diff"
	alias {diffkitty,diffkitten,difftoolkitty,difftoolkitten,kittendiff,kittydiff,kittydifftool,kittendifftool}="git difftool --no-symlinks --dir-diff --tool=kitty"
    # else 
	# alias diff="diff --color"
    fi
fi
if cmd-exists btop; then 
    alias htop="btop"
    alias {hhtop,oldhtop}="/usr/bin/htop"
fi
if cmd-exists bat; then 
    alias cat="bat"
    alias {oldcat,ccat}="/usr/bin/cat"
fi
if cmd-exists duf; then 
    alias df="duf"
    alias {olddf,ddf}="/usr/bin/df"
fi

# PROJECTS 
alias {fp,flightpark}="cd ~/work/local/flightpark/"
alias fpapp="cd ~/work/local/flightpark/flightparkapp/"
alias {fpappreset,fpappreinstall}="~/work/local/flightpark/flightparkapp/scripts/android/uninstall-on-physical.sh; ~/work/local/flightpark/flightparkapp/scripts/android/install-apk-physical.sh"
alias nsb="cd ~/work/local/nsb/"
alias {vipps,woo-vipps}="cd ~/work/local/sites/lassevippsdev/wp-content/plugins/woo-vipps/payment"
alias {remotevipps,sshvipps,vippsremote,vippsssh}="cd ~/work/remote/area51/woo-vipps/payment"
alias {ea,eaccounting}="cd ~/work/local/tripletex/eaccounting/"
alias {tt,tripletex}="cd ~/work/local/tripletex/"
alias {nvimhome,homenvim,nvimconf,nvimplugins}="cd ~/.config/nvim/lua/"
alias {nvimlsp,vimlsp}="vim ~/.config/nvim/lua/plugins/novscode/lsp/nvim-lspconfig.lua"
alias {nxtapp,nxtapps,nextcloudapp,nextcloudapps}="cd ~/work/local/nextcloud/apps/"

# GIT ALIASES
alias {gdt,dt,gitdifftool,difftool,difftoolgit}="git difftool"
alias gs="git status"
alias gss='git status -s -b' # git status short with branch
alias gl="git log"
alias gls="git log --oneline" # think "git log short"
alias glg="git log --graph"
alias gc="git commit -m"
alias gca="git commit --amend"

# DOTFILES GIT ALIASES
# alias {dotfiles,dot}='/usr/bin/git --git-dir=$HOME/repos/dotfiles.git --work-tree=$HOME -C $HOME'
alias {dotfiles,dot}='/usr/bin/git -C ~/repos/dotfiles'
alias {dotnvim,dot-nvim}='/usr/bin/git -C ~/.config/nvim'
alias ds='/usr/bin/git -C ~/repos/dotfiles status'
alias dss='/usr/bin/git -C ~/repos/dotfiles status -s -b'
alias dl='/usr/bin/git -C ~/repos/dotfiles log'
alias dls="/usr/bin/git -C ~/repos/dotfiles log --oneline" # think "git log short"
alias dlg="/usr/bin/git -C ~/repos/dotfiles log --graph"
alias dc="/usr/bin/git -C ~/repos/dotfiles commit -m"
alias dca="/usr/bin/git -C ~/repos/dotfiles commit --amend"
### END ALIASES ###

### OPTIONS ###
# set -o vi # vi motions in bash...
if [[ "${HOSTNAME,,}" == *"lasse"* ]]; then
    xset r rate 200 33 # keyboard repeat delay and rate
    cmd-exists zoxide && eval "$(zoxide init --cmd cd bash)"
fi


# make command edit (ctrl-x + ctrl-e) not auto execute on quit
_edit_wo_executing() {
    local editor="${EDITOR:-nano}"
    tmpf="$(mktemp)"
    printf '%s\n' "$READLINE_LINE" > "$tmpf"
    "$editor" "$tmpf"
    READLINE_LINE="$(<"$tmpf")"
    READLINE_POINT="${#READLINE_LINE}"
    rm -f "$tmpf"  # -f for those who have alias rm='rm -i'
}

bind -x '"\C-x\C-e":_edit_wo_executing'

# if cmd-exists eza; then
#     alias ls='eza --icons=always --group-directories-first'
#     alias ll='eza -laah --icons=always --group-directories-first'
# fi

cmd-exists setxkbmap && setxkbmap -option "nbsp:none" # disable horrible 'non-breakable' space that causes compiler errors and such on alt-gr + space. 
### END OPTIONS ###

[[ -f "$HOME/.cargo/env" ]] &&  . "$HOME/.cargo/env"

# if in wsl, need to start ssh-agent and add keys. Workaround for weirdness
if [[ $(uname -r) =~ WSL ]]; then
    eval `ssh-agent -s`
    ssh-add 
fi

# bash syntax highlight, autocompletion, QoL, and much more: https://github.com/akinomyoga/ble.sh
# source ~/.local/share/blesh/ble.sh # OLD VER
# also see top of this file for part 1 sourcing
[[ -e "/home/lasse/.local/share/blesh/ble.sh" ]] && [[ ! ${BLE_VERSION-} ]] || ble-attach
