# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set term to xterm so that vim has syntax highlighting in tmux when used tmux from root on remote via ssh
export TERM="xterm-256color"

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
    alias ls='ls --color=auto'
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

export OLD_PS1=$PS1
# export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;31m\]$(__git_ps1)\[\e[m\]\$ '

function parse_git_dirty {
  [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}
export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;31m\]$(parse_git_branch)\[\e[m\]\$ '

# Open tmux on shell open
# if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
#     exec tmux new-session -A -s ${USER} >/dev/null 2>&1
# fi

# Default editor. Use nvim if installed, else vim if installed
if command -v nvim >/dev/null 2>&1; then 
    export EDITOR="nvim"
elif command -v vim >/dev/null 2>&1; then 
    export EDITOR="vim"
fi

# Home dir git alias
alias {dotfiles,dot}='/usr/bin/git --git-dir=$HOME/repos/dotfiles.git --work-tree=$HOME'
alias {dotnvim,dot-nvim}='/usr/bin/git -C ~/.config/nvim'

# Stuff for react native android dev
export JAVA_HOME=/usr/lib/jvm/jdk-23.0.1

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Nvim
export PATH="$PATH:/opt/nvim-linux64/bin:$HOME/opt/nvim-linux64/bin"

# Remote list for scripts
export WPH_REMOTES="dev,wp3,wp4,bastion,wafmaster,wph,tripletex,afk,avvir,kleins,krydra,upk,bfkstats,flightpark,entercard"

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.fzfrc ] && export FZF_DEFAULT_OPTS_FILE="$HOME/.fzfrc"

# Command for man help pages. Use nvim if installed, else vim if installed
if command -v nvim >/dev/null 2>&1; then 
    export MANPAGER="nvim +Man!"
elif command -v vim >/dev/null 2>&1; then 
    export MANPAGER="vim -M +MANPAGER - "
fi

# Cargo (Rust) stuff
export PATH="$PATH:$HOME/.cargo/bin/"

# Git shortcuts
alias gs="git status"
alias gss='git status -s -b' # git status short with branch
alias gl="git log"
alias gls="git log --oneline" # think "git log short"
alias glg="git log --graph"
alias gc="git commit -m"
alias gca="git commit --amend"
# Think "git previous". does git show with input parameter of the target number commit back from HEAD. Defaults to 0, and accepts arguments if and only if the target number is given.
gp() {
    target=${1-0} # if arg 1 not given; default to 0.
    shift 1
    git show HEAD~$target $@
}
# Git diff with fuzzy file search
gd() {
    pattern=$1
    shift 1
    git diff "*$pattern*" $@
}
# Git add with fuzzy file search
ga() {
    pattern=$1
    shift 1
    git add "*$pattern*" $@
}

### PROJECT SHORTCUTS FOR EASE
alias fpapp="cd ~/work/local/flightpark/flightparkapp/"
alias woo-vipps="cd ~/work/local/sites/lassevippsdev/wp-content/plugins/woo-vipps/"
