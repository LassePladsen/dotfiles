My dotfiles for linux and some other useful stuff, managed my stow (symlink manager) and git.

# Dependencies
```bash
sudo apt install git stow
```
Stow is only a soft dependency, as the install script will attempt to manually make the necessary symlinks, however stow is still recommended since its more robust and easy to use and maintan. 

# Full installation
## ssh (recommended)
```bash
git clone --recursive git@github.com:LassePladsen/dotfiles.git ~/repos/dotfiles && (
~/repos/dotfiles/install 
~/.fzf/install
)
```
## https
```bash
git clone --recursive https://github.com/LassePladsen/dotfiles.git ~/repos/dotfiles && (
~/repos/dotfiles/install
~/.fzf/install
)
```

# Minimum size install
## ssh (recommended)
```bash
git clone git@github.com:LassePladsen/dotfiles.git ~/repos/dotfiles &&
~/repos/dotfiles/install -m
```
## https
```bash
git clone https://github.com/LassePladsen/dotfiles.git ~/repos/dotfiles &&
~/repos/dotfiles/install -m
```
