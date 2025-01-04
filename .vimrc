""" SETTINGS
set mouse=a

" Global and relative line numbers  
set nu
set rnu

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set smartindent

set wrap

set nohlsearch
set incsearch

set termguicolors

set scrolloff=8

set updatetime=500
""" STOP SETTINGS

""" REMAPS
let mapleader = " "
" Map moving selected lines 
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Map leader-w to write file
nnoremap <leader>w :w<enter>

" Map FZF fuzzy file finder for only vim
if !has('nvim')
    nnoremap <leader>ff :FZF<enter>
endif

" Map C-d and C-u to also center cursor at middle of screen 
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Map explorer
nnoremap <leader>fe :Ex<enter>

" Fully map ctrl-c to esc (default not the exact same)
inoremap  <C-c> <ESC>
vnoremap  <C-c> <ESC>

" Greatest remap ever: replace visual selection without copying the replaced stuff into buffer
vnoremap <leader>p "_dP

" Yank to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" Delete to system clipboard
nnoremap <leader>d "+d
vnoremap <leader>d "+d
nnoremap <leader>D "+D

" Start replacing word you're on
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Make file executable
nnoremap <leader>x <cmd>silent exec "!chmod +x %"<CR><C-l>

" Next and prev buffer
nnoremap <leader>n :bn<enter>
nnoremap <leader>p :bp<enter>

""" END REMAPS

" Only for regular vim:
if !has('nvim')
	" plugin manager vim-plug
	let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
	if empty(glob(data_dir . '/autoload/plug.vim'))
		silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif

	call plug#begin()
	Plug 'tpope/vim-sensible'
	Plug 'girishji/vimcomplete' 
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'haishanh/night-owl.vim'
	Plug 'prabirshrestha/vim-lsp'
	Plug 'mattn/vim-lsp-settings'
	Plug 'prabirshrestha/asyncomplete.vim'
	Plug 'prabirshrestha/asyncomplete-lsp.vim'
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
		setlocal signcolumn=yes
		if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
		nmap <buffer> gd <plug>(lsp-definition)
		nmap <buffer> gs <plug>(lsp-document-symbol-search)
		nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
		nmap <buffer> gr <plug>(lsp-references)
		nmap <buffer> gi <plug>(lsp-implementation)
		nmap <buffer> gt <plug>(lsp-type-definition)
		nmap <buffer> <leader>rn <plug>(lsp-rename)
		nmap <buffer> [g <plug>(lsp-previous-diagnostic)
		nmap <buffer> ]g <plug>(lsp-next-diagnostic)
		nmap <buffer> K <plug>(lsp-hover)
		nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
		nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

		let g:lsp_format_sync_timeout = 1000
		autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

		" refer to doc to add more commands
	endfunction

	augroup lsp_install
		au!
		" call s:on_lsp_buffer_enabled only for languages that has the server registered.
		autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
	augroup END
	""" END LSP STUFF
endif

