My dotfiles for linux and some other usefull stuff, managed my stow (symlink manager) and git.

# Dependencies
```bash
sudo apt install git stow
```
Stow is a soft dependency, as the install script will manually make the necessary symlinks, however stow is still recommended for ease of install and maintenance.

# Installation
## ssh (recommended)
```bash
git clone --recursive git@github.com:LassePladsen/dotfiles.git ~/repos/dotfiles &&
~/repos/dotfiles/install &&
~/.fzf/install
```
## https
```bash
git clone --recursive https://github.com/LassePladsen/dotfiles.git ~/repos/dotfiles &&
~/repos/dotfiles/install &&
~/.fzf/install
```
