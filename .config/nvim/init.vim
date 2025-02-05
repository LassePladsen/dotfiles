set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Call init.lua
lua require('init')

if !empty(glob("~/.vimrc"))
    source ~/.vimrc
endif

