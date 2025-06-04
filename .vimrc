let g:remoteSession = ($SSH_CLIENT != "") " For some settings that should not activate on remotes (ssh)

""" SETTINGS 
set mouse=a

" So :find can search recursively
set path+=**

" Case insensitive file and dir completions
set wildignorecase

" Global and relative line numbers  
set nu
set rnu

" set foldmethod=syntax

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

set undofile
if g:remoteSession
    set noundofile
endif

" new splits locations
set splitright
set splitbelow

" auto change dir to current file
" set autochdir

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

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

""" STOP SETTINGS

""" REMAPS
let mapleader = " "
let localmapleader = " "

" toggle line numbers on Alt-c (NB: default vim in gnome terminal cant
" differenciate escape-c to alt-c ...)
nnoremap <Esc>c :set nu! rnu!<CR>

" stop small delete 
nnoremap x "_x

" jump to start of root function/method. Now works for not only first column,
" nice for react components
function! JumpToRootFunction()
    execute "normal! ?{\<CR>w99[{"
endfunction
nnoremap [[ :call JumpToRootFunction()<CR>
nnoremap <leader>[ :call JumpToRootFunction()<CR>
" Jump to the end of function
nnoremap <leader>] :call JumpToRootFunction()<CR>%

" read help on [[ -> scroll down to sections. Dont really use this
nnoremap ][ /}<CR>b99]}
nnoremap ]] j0[[%/{<CR>
nnoremap [] k$][%?}<CR>

" Save on ctrl s
nnoremap <C-s> :w<enter>

" Enter normal mode and save on ctrl s
inoremap <C-s> <ESC>:w<enter>
vnoremap <C-s> <ESC>:w<enter>

" J (append below line to end of current line) keeps cursor at same position
nnoremap J mzJ`z

" Insert newline on cursor, keep cursor position. (Opposite of J)
" warning: control maps cant assert between capital and lower character (C-j and C-J will be the same)
nnoremap <C-j> hmza<CR><ESC>`z

" Map moving selected lines 
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" unmap ZZ exit
nnoremap ZZ <nop>

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
" Disable:  this is default on *. upwards is #
" nnoremap <leader>/ :/\<<C-r><C-w>\><enter>

" Start replacing word you're on
noremap <leader>* :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>

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

" Select whole file
nnoremap <leader><C-a> ggVG

" Outputs comment signature with date in unix format like: LP 2025-04-10
nnoremap <leader># :execute "normal! aLP " . strftime("%Y-%m-%d")<CR>
""" END REMAPS

" Only for regular vim:
if !has('nvim')
    set signcolumn=yes

    " VIM EXCLUSIVE REMAPS
    " File explorer in current parent dir on -
    nnoremap - :Ex<CR>

    " Fzf binds
    nnoremap <leader>sf :FZF<enter> " file finder
    nnoremap <leader><leader> :Buffers<CR> 
    nnoremap <leader>sg :BLines<CR> " grep current file
    nnoremap <leader>sm :Marks<CR> 
    nnoremap <leader>sj :Jumps<CR> 
    nnoremap <leader>s. :History<CR> 
    nnoremap <leader>s: :History:<CR> 
    nnoremap <leader>s/ :History/<CR> 
    nnoremap <leader>sc :Commits<CR> 
    nnoremap <leader>sk :Maps<CR> " search keybindings/maps
    nnoremap <leader>sh :Helptags<CR> " search help
    " END REMAPS

    " plugin manager vim-plug
    " Potentially install it 
    let path = '~/.vim/autoload/plug.vim'
    if empty(glob(path))
        silent execute '!curl -fLo ' .path. ' --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    call plug#begin()
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-commentary'
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
    Plug 'itchyny/lightline.vim'
    Plug 'phanviet/vim-monokai-pro'
    " Only load vimcomplete if Vim version >= 9.1.0646
    if has('vim9script') && v:version >= 901 && has('patch-9.1.0646')
        Plug 'girishji/vimcomplete'
    endif
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

    " Git files fuzzy search
    nnoremap <leader>st :Git<CR>
    """ END LSP STUFF

    """ CUSTOM COMMANDS
    " Manually close popup when it bugs out... see https://github.com/vim/vim/issues/5744 by 
    command PopupClose :call popup_close(win_getid())
    """ END CUSTOM COMMANDS
endif

" Source man pager to use vim for man help pages
runtime ftplugin/man.vim

""" AUTOCOMMANDS
" Set php commenstring from default /* */ to //
autocmd FileType php setlocal commentstring=//\ %s
"""END AUTOCOMMANDS


