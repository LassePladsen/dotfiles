My dotfiles for linux and some other usefull stuff, managed my stow (symlink manager) and git.

# Dependencies
```bash
sudo apt install git stow
```

# Installation
Git via. ssh (recommended)
```bash
git clone --recursive git@github.com:LassePladsen/dotfiles.git ~/repos/dotfiles &&
cd ~/repos/dotfiles &&
stow . -t ~ --adopt &&
git restore . &&
~/.fzf/install
```
Git via. https
```bash
git clone --recursive https://github.com/LassePladsen/dotfiles.git ~/repos/dotfiles &&
cd ~/repos/dotfiles &&
stow . -t ~ --adopt &&
git restore . &&
~/.fzf/install
```
