My dotfiles for linux and some other usefull stuff, managed my stow (symlink manager) and git.

# Dependencies
```bash
sudo apt install git stow
```

# Installation
## With stow
### ssh (recommended)
```bash
git clone --recursive git@github.com:LassePladsen/dotfiles.git ~/repos/dotfiles &&
cd ~/repos/dotfiles &&
stow . -t ~ --adopt &&
git restore . &&
~/.fzf/install
```
### https
```bash
git clone --recursive https://github.com/LassePladsen/dotfiles.git ~/repos/dotfiles &&
cd ~/repos/dotfiles &&
stow . -t ~ --adopt &&
git restore . &&
~/.fzf/install
```

## Without stow
### ssh (recommended)
```bash
git clone --recursive git@github.com:LassePladsen/dotfiles.git ~/repos/dotfiles &&
cd ~/repos/dotfiles &&
~/repos/dotfiles/scripts/make-symlinks.sh &&
~/.fzf/install
```
### https
```bash
git clone --recursive https://github.com/LassePladsen/dotfiles.git ~/repos/dotfiles &&
cd ~/repos/dotfiles &&
~/repos/dotfiles/scripts/make-symlinks.sh &&
~/.fzf/install
```
