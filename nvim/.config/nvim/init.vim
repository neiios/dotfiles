set nocompatible
" filetype detection and syntax highlighting
if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" indentation
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab

set backspace=indent,eol,start " non-retarded backspace
set complete-=i " do not scan included files

set nrformats-=octal " dont consider octal number format as a valid number

" search
set incsearch " dont press enter when searching
set hlsearch " highlight search matches
" map F2 to disable search highlight
if maparg('<F2>', 'n') ==# ''
  nnoremap <F2> :set hlsearch!<CR>
endif

set laststatus=2 " show status bar even when only one vim window is open
set ruler " show cursor position
set wildmenu " show possible completion above the command line
set scrolloff=8 " have n lines above and below cursor at all times
set sidescrolloff=8 " minimum number of characters to the left and right of the cursor
set display+=lastline " dot replace a very long line with @
set encoding=utf-8 " use utf-8 for the output show in the terminal
set fileencoding=utf-8 " use utf-8 for file writing
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+ " specify how characters are displayed with :list command
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276')) " fix for the fish enjoyers
  set shell=/usr/bin/env\ bash
endif

set autoread " update the file if it was changed elsewhere

if &history < 1000 " set history to 1000 if its less
  set history=1000
endif
if &tabpagemax < 50 " set maximum tab count to 50
  set tabpagemax=50
endif
if !empty(&viminfo) " prepend viminfo with ! 
  set viminfo^=!
endif

" disable saving of options, mapping and global values for sessions and views
set sessionoptions-=options
set viewoptions-=options

" load matchit.vim, but only if the user hasn't installed a newer version
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" russian layout in normal mode
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" relative line numbers
set number
set relativenumber
" enable mouse support (do you really need it though?)
set mouse=a
" always use system clipboard for copy and paste
" buggy on gnome wayland
set clipboard+=unnamedplus
vnoremap Y "+y
nnoremap Y "+y
" use persistent undo
set undofile 
" save swap, backup and undo file in /tmp
set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//
set ignorecase " ignore case in search patters
set updatetime=500 " used by some plugins
" override the default window positions when splitting
set splitbelow
set splitright
" disable leader key timeout and reduce escape sequence wait
set notimeout
set ttimeoutlen=10
set nowrap " disable line wrap
" dont insert a comment on the next line automatically
autocmd FileType * set formatoptions-=cro

set iskeyword-=_

syntax on " enable syntax highlighting when running vim
colorscheme desert

" code below should only be run inside neovim
if has("nvim")
  " load the main configuration file
  lua require('nvim')
endif

