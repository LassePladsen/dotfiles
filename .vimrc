set ignorecase
set smartcase " only case insensitive when searching with only lowercase. using upper case makes it case sensitive

let g:remoteSession = ($SSH_CLIENT != "" || $SSH_TTY != "" || system("hostname") !~ "lasse") " For some settings that should not activate on remotes (ssh)

""" SETTINGS 
set mouse=a

" So :find can search recursively
set path+=**

set list " show trailing spaces as '-' and non-breakable space as '+' (idk)

" Case insensitive file and dir completions
set wildignorecase

" Global and relative line numbers  
set nu
set rnu

" set foldmethod=syntax

" set tabstop=4 " apparently recommended leaving this default (8) and instead using the other settings correctly
set expandtab
set shiftwidth=4
set softtabstop=-1 " use value of shiftwidth
set smarttab " always use shiftwidth
set smartindent
set autoindent

set wrap
set breakindent " wrap starts at same indentation
set scrolloff=10

set nohlsearch
set incsearch

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

set updatetime=250

if g:remoteSession 
    set noundofile
else 
    set undofile
    " Save on ctrl s. Disabled on remote because ctrl-s is freeze terminal... This can be
    " disabled https://edmondscommerce.github.io/linux/prevent-ctrl-plus-s-freezing-your-terminal.html. 
    nnoremap <C-s> :w<enter>
    " Enter normal mode and save on ctrl s
    inoremap <C-s> <ESC>:w<enter>
    vnoremap <C-s> <ESC>:w<enter>
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
let netrw_liststyle=0 

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
nnoremap <leader><Esc>c :set nu! rnu!<CR>

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

" J (append below line to end of current line) keeps cursor at same position
nnoremap J mzJ`z

" Insert newline on cursor, keep cursor position. (Opposite of J)
" warning: control maps cant assert between capital and lower character (C-j and C-J will be the same)
nnoremap <C-j> hmza<CR><ESC>`z

" Map moving selected lines 
" nnoremap <M-j> :m .+1<CR>==
" nnoremap <M-k> :m .-2<CR>==
" inoremap <M-j> <Esc>:m .+1<CR>==gi
" inoremap <M-k> <Esc>:m .-2<CR>==gi
" vnoremap <M-j> :m '>+1<CR>gv=gv
" vnoremap <M-k> :m '<-2<CR>gv=gv

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
if g:remoteSession 
    nmap <leader>y <Plug>OSCYankOperator
    nmap <leader>yy <leader>y_
    nmap <leader>Y <leader>y$
    vmap <leader>y <Plug>OSCYankVisual
else 
    nnoremap <leader>y "+y
    vnoremap <leader>y "+y
    nnoremap <leader>Y "+y$
endif

" Delete to system clipboard
nnoremap <leader>d "+d
vnoremap <leader>d "+d
" nnoremap <leader>D "+d$

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

" quickfix
nnoremap <M-.> :cnext<CR>
nnoremap <M-,> :cprev<CR>
nnoremap <leader>cn :cn<CR>
nnoremap <leader>cp :cp<CR>
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

" Replace inside/outside next bracket/paranthesis only on current line (to the
" right of cursor). This is to fix
" replacing the parent bracket when trying to target current line.

" Replace inside/around brackets (current line only)
nnoremap <leader>ci( :call FindAndChange('(', 'ci(')<CR>
nnoremap <leader>ci[ :call FindAndChange('[', 'ci[')<CR>
nnoremap <leader>ci{ :call FindAndChange('{', 'ci{')<CR>
nnoremap <leader>ca( :call FindAndChange('(', 'ca(')<CR>
nnoremap <leader>ca[ :call FindAndChange('[', 'ca[')<CR>
nnoremap <leader>ca{ :call FindAndChange('{', 'ca{')<CR>

" Visual select inside/around brackets (current line only)
nnoremap <leader>vi( :call FindAndChange('(', 'vi(')<CR>
nnoremap <leader>vi[ :call FindAndChange('[', 'vi[')<CR>
nnoremap <leader>vi{ :call FindAndChange('{', 'vi{')<CR>
nnoremap <leader>va( :call FindAndChange('(', 'va(')<CR>
nnoremap <leader>va[ :call FindAndChange('[', 'va[')<CR>
nnoremap <leader>va{ :call FindAndChange('{', 'va{')<CR>

function! FindAndChange(bracket, command)
    let line = getline('.')
    let col = col('.')
    
    " Search for the bracket to the right of cursor on current line
    let found_pos = -1
    for i in range(col - 1, len(line) - 1)
        if line[i] == a:bracket
            let found_pos = i + 1  " Convert to 1-indexed column
            break
        endif
    endfor
    
    " If found, move to it and execute the command
    if found_pos > 0
        call cursor(line('.'), found_pos)
        execute 'normal! ' . a:command
    else
        echo 'No ' . a:bracket . ' found to the right on current line'
    endif
endfunction


""" DEBUGPRINT for filetypes
function! DebugPrintLP()
    let line = getline('.')
    let word = expand('<cword>')
    
    echo 'filetype is ' . &filetype
    if &filetype == 'php'
        execute "normal! oerror_log('LP " . word . ": ' . print_r($" . word . ", true));"
    elseif &filetype =~ '\v^(javascript|typescript|javascriptreact|typescriptreact)$'
        execute "normal! oconsole.log('LP " . word . ": ', " . word . ");"
    elseif &filetype == 'python'
        execute "normal! oprint('LP " . word . ": ', " . word . ")"
    else
        echo "Debug print not supported for filetype: " . &filetype . ". Add it to your .vimrc!"
    endif
endfunction

nnoremap <leader>ld :call DebugPrintLP()<CR>
nnoremap <leader>dp :call DebugPrintLP()<CR>

" edits next file in rustlings (next number filename var4.rs -> var5.rs)
" Remap + to edit the next numbered file in sequence
if expand('%:p') =~ '/rustlings/'
    nnoremap + :call EditNextNumberedFile()<CR>
endif

function! EditNextNumberedFile()
    let current_file = expand('%:t')
    let current_dir = expand('%:p:h')
    let cwd = getcwd()
    
    " Extract the base name, number, and extension
    let match_result = matchlist(current_file, '\(.*\)\(\d\+\)\.\(.*\)')
    
    if empty(match_result)
        echo "Current file doesn't match pattern: name[number].extension"
        return
    endif
    
    let base_name = match_result[1]
    let current_number = str2nr(match_result[2])
    let extension = match_result[3]
    
    " Calculate next number and construct filename
    let next_number = current_number + 1
    let next_file = base_name . next_number . '.' . extension
    let next_path = current_dir . '/' . next_file
    
    " Check if the next file exists
    if filereadable(next_path)
        execute 'edit ' . fnameescape(next_path)
        echo "Editing: " . next_file
    else
        " File doesn't exist, try to find next directory
        call EditNextDirectoryFile(extension)
    endif
endfunction

function! EditNextDirectoryFile(extension)
    let cwd = getcwd()
    let current_dir = expand('%:p:h')
    let current_dir_name = fnamemodify(current_dir, ':t')
    
    " Extract current directory number (e.g., "01" from "01_variables")
    let dir_match = matchlist(current_dir_name, '^\(\d\+\)_\(.*\)')
    
    if empty(dir_match)
        echo "Current directory doesn't match pattern: [number]_[name]"
        return
    endif
    
    let current_dir_num = str2nr(dir_match[1])
    let next_dir_num = current_dir_num + 1
    
    " Get all directories in cwd that start with numbers
    let dirs = glob(cwd . '/' . printf('%02d', next_dir_num) . '_*', 0, 1)
    
    if empty(dirs)
        echo "No next directory found matching pattern: " . printf('%02d', next_dir_num) . "_*"
        return
    endif
    
    " Use the first matching directory
    let next_dir = dirs[0]
    let next_dir_name = fnamemodify(next_dir, ':t')
    
    " Extract step name from next directory (e.g., "loops" from "02_loops")
    let next_dir_match = matchlist(next_dir_name, '^\d\+_\(.*\)')
    
    if empty(next_dir_match)
        echo "Next directory doesn't match expected pattern"
        return
    endif
    
    let step_name = next_dir_match[1]
    let next_file = step_name . '1.' . a:extension
    let next_path = next_dir . '/' . next_file
    
    " Edit the next file
    execute 'edit ' . fnameescape(next_path)
    echo "Editing: " . next_dir_name . '/' . next_file
endfunction
""" END REMAPS

" Only for regular vim:
if !has('nvim')
    set signcolumn=yes

    " VIM EXCLUSIVE REMAPS
    " File explorer in current parent dir on -
    nnoremap - :Ex<CR>

    " Fzf binds
    " file finder
    nnoremap <leader>sf :FZF<enter> 
    nnoremap <leader><leader> :Buffers<CR> 
    " grep current file
    nnoremap <leader>s/ :BLines<CR> 
    nnoremap <leader>sm :Marks<CR> 
    nnoremap <leader>sj :Jumps<CR> 
    nnoremap <leader>s. :History<CR> 
    nnoremap <leader>s: :History:<CR> 
    nnoremap <leader>sc :Commits<CR> 
    " search keybindings/maps
    nnoremap <leader>sk :Maps<CR> 
    " search help
    nnoremap <leader>sh :Helptags<CR> 
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
    Plug 'tpope/vim-sleuth'
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
    Plug 'luochen1990/rainbow'
    let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
    Plug 'ojroques/vim-oscyank', {'branch': 'main'}

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
        " let g:lsp_diagnostics_virtual_text_enabled = 0 " disable virtual text for diagnostics (only worked on warnings, seems like no way to enable only for errors)


        " refer to doc to add more commands
    endfunction

    augroup lsp_install
        au!
        " call s:on_lsp_buffer_enabled only for languages that has the server registered.
        autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    augroup END

    " Autocomplete maps
    " inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <Tab>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

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
autocmd FileType smarty setlocal filetype=html
""""END AUTOCOMMANDS
