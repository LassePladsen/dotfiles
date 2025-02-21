""" SETTINGS 
set mouse=a

" Global and relative line numbers  
set nu
set rnu

set softtabstop=4
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent
set wrap
set breakindent " wrap starts at same indentation
set scrolloff=10

set nohlsearch
set incsearch

set termguicolors
set updatetime=250

set ignorecase
set smartcase " only case insensitive when searching with only lowercase. using upper case makes it case sensitive
set signcolumn=yes

set undofile

" new splits locations
set splitright
set splitbelow

" display of certain whitespaces chars
" set list

" disable new line continuing comments
" set formatoptions-=r formatoptions-=o " this will be overwritten... do
" :verbose set formatoptions?
autocmd BufNewFile,BufRead * setlocal formatoptions-=ro " workaround

set cursorline
highlight CursorLine term=underline ctermbg=235 guibg=#112630

" Netrw file explorer
let g:netrw_banner=0 " disable help banner
let netrw_liststyle=3 " tree view

""" STOP SETTINGS

""" REMAPS
let mapleader = " "
let localmapleader = " "

" stop small delete 
nnoremap x "_x

" Save on ctrl s
nnoremap <C-s> :w<enter>

" Enter normal mode and save on ctrl s
inoremap <C-s> <ESC>:w<enter>
vnoremap <C-s> <ESC>:w<enter>

" J (append below line to end of current line) keeps cursor at same position
nnoremap J mpJ`p

" Opposite of J (split line into two without entering insert mode + enter + esc)
" warning: control maps cant assert between capital and lower character (j and J
" same)
nnoremap <C-j> hmpa<CR><ESC>`p

" Map moving selected lines 
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" unmap ZZ exit
nnoremap ZZ <nop>

" Map FZF fuzzy file finder for only vim
if !has('nvim')
    nnoremap <leader>sf :FZF<enter>
endif

" Map C-d and C-u to also center cursor at middle of screen 
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Map explorer
nnoremap <leader>se :Ex<enter>

" Fully map ctrl-c to esc (default not the exact same)
inoremap  <C-c> <ESC>
vnoremap  <C-c> <ESC>

" Greatest remap ever: replace visual selection from buffer, without copying the selection into buffer
vnoremap <leader>p "_dP
" Greatest remap ever: replace line with buffer, without copying old line into buffer 
nnoremap <leader>p "_ddP 

" Yank to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+y$

" Delete to system clipboard
nnoremap <leader>d "+d
vnoremap <leader>d "+d
nnoremap <leader>D "+d$

" Do search for word you're on
" Disable:  this is default on *
" nnoremap <leader>/ :/\<<C-r><C-w>\><enter>

" Start replacing word you're on
noremap <leader>* :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Make file executable
nnoremap <leader>x <cmd>silent exec "!chmod +x %"<CR><C-l>

" Next and prev buffer
nnoremap <leader>i :bn<enter>
nnoremap <leader>o :bp<enter>

" Faster terminal mode exit (apparantly wont work with all terminal
" emulators/tmux etc
tnoremap <Esc><Esc> <C-\><C-n>

" New tab from current file (:tab split)
nnoremap <C-w><C-t> :tab split<CR>

" Next and prev in quickfix menu
nnoremap <leader>cn :cn<CR>
nnoremap <leader>cp :cp<CR>
" Open and close quickfix menu
nnoremap <leader>cq :copen<CR>
nnoremap <leader>cQ :cclose<CR>

" Window sizes
nnoremap <M-+> <C-w>+
nnoremap <M--> <C-w>-
nnoremap <M-<> <C-w><
nnoremap <M->> <C-w>>

""" END REMAPS

" Only for regular vim:
if !has('nvim')
    " VIM EXCLUSIVE REMAPS
    " List buffers 
    nnoremap <leader><leader> :buffers<CR>
    " END REMAPS

    " plugin manager vim-plug
    let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
    if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    call plug#begin()
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-commentary'
    Plug 'girishji/vimcomplete' 
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'haishanh/night-owl.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'tpope/vim-surround'
    Plug 'bkad/CamelCaseMotion'
    Plug 'machakann/vim-highlightedyank'
    Plug 'jiangmiao/auto-pairs'
    Plug 'tpope/vim-commentary'
    Plug 'itchyny/lightline.vim'
    Plug 'phanviet/vim-monokai-pro'
    call plug#end()

    " Timeout for yank hightlight
    let g:highlightedyank_highlight_duration = 250

    " CamelcaseMotion default maps
    let g:camelcasemotion_key = '<leader>'

    """" COLORSCHEME
    " If you have vim >=8.0 or Neovim >= 0.1.5
    " if (has("termguicolors"))
	" set termguicolors
    " endif

    syntax enable
    " colorscheme night-owl
    colorscheme monokai_pro

    " " To enable the lightline theme
    let g:lightline = { 'colorscheme': 'monokai_pro' }
    """ END COLORSCHEME

    """ LSP STUFF
    if executable('pylsp')
	" pip install python-lsp-server
	au User lsp_setup call lsp#register_server({
		    \ 'name': 'pylsp',
		    \ 'cmd': {server_info->['pylsp']},
		    \ 'allowlist': ['python'],
		    \ })
    endif

    function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
	nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> <leader>ds <plug>(lsp-document-symbol-search)
	nmap <buffer> <leader>ws <plug>(lsp-workspace-symbol-search)
	nmap <buffer> gr <plug>(lsp-references)
	nmap <buffer> gi <plug>(lsp-implementation)
	nmap <buffer> gD <plug>(lsp-type-definition)
	nmap <buffer> <leader>rn <plug>(lsp-rename)
	nmap <buffer> [g <plug>(lsp-previous-diagnostic)
	nmap <buffer> ]g <plug>(lsp-next-diagnostic)
	nmap <buffer> K <plug>(lsp-hover)
	nnoremap <buffer> <expr><c-d> lsp#scroll(+4)
	nnoremap <buffer> <expr><c-u> lsp#scroll(-4)

	" Format document
	nnoremap <buffer> <F3> <plug>(lsp-document-format) 
	" Open diagnostics
	nnoremap <buffer> <F5> <plug>(lsp-document-diagnostics) 

	let g:lsp_format_sync_timeout = 1000
	autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

	" Reference highlight  (what cursor is on is highlighted) colors
	highlight lspReference guibg=darkgrey guifg=white

	" diagnostic higlight
	let g:lsp_diagnostics_virtual_text_enabled = 0 " disable virtual text for diagnostics (only worked on warnings, seems like no way to enable only for errors)


	" refer to doc to add more commands
    endfunction

    augroup lsp_install
	au!
	" call s:on_lsp_buffer_enabled only for languages that has the server registered.
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    augroup END

    " Autocomplete maps
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
    """ END LSP STUFF
endif

" Source man pager to use vim for man help pages
runtime ftplugin/man.vim

