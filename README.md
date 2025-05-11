My dotfiles for linux and some other usefull stuff, managed my stow (symlink manager) and git.

# Dependencies
```bash
sudo apt install git stow
```

# Installation
Git via ssh (recommended)
```bash
git clone git@github.com:LassePladsen/dotfiles.git ~/repos/dotfiles &&
cd ~/repos/dotfiles &&
stow . -t ~ --adopt &&
git restore .
```
Git via https
```bash
git clone https://github.com/LassePladsen/dotfiles.git ~/repos/dotfiles &&
cd ~/repos/dotfiles &&
stow . -t ~ --adopt &&
git restore .
```
