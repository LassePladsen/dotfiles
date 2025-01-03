set mouse=a
let mapleader = " "

" Global and relative line numbers  
set number
set relativenumber

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" List your plugins here
Plug 'tpope/vim-sensible'
Plug 'girishji/vimcomplete' 
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'haishanh/night-owl.vim'

call plug#end()

"""" COLORSCHEME
" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
 set termguicolors
endif

" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

syntax enable
colorscheme night-owl

" To enable the lightline theme
let g:lightline = { 'colorscheme': 'nightowl' }
""" END COLORSCHEME


" Map moving selected lines 
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Map leader-w to write file
nnoremap <leader>w :w<enter>

" Map FZF fuzzy file finder
nnoremap <C-p> :FZF<enter>

" Map C-d and C-u to also center cursor at middle of screen 
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Map explorer
nnoremap <leader>fe :Ex<enter>

" Fully map ctrl-c to esc (default not the exact same)
inoremap  <C-c> <ESC>
vnoremap  <C-c> <ESC>

" Greatest remap ever: replace without copying the deleted stuff into buffer
vnoremap <leader>p "_dP

" Yank to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" Start replacing word you're on
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Make file executable
nnoremap <leader>x <cmd>silent exec "!chmod +x %"<CR><C-l>
