" ====== vundle config begin ======
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" required for vundle
filetype off

" vundle config
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" vundle bundles
" original repos on github
" NERDTree
Bundle 'scrooloose/nerdtree'
" Surround
Bundle 'tpope/vim-surround' 
" sparkup
Bundle 'rstacruz/sparkup'
" auto-pairs
Bundle 'vim-scripts/Auto-Pairs'
" CtrlP
Bundle 'kien/ctrlp.vim'
" Solarized Color Scheme
Bundle 'altercation/vim-colors-solarized'

" use filetype on - required for vundle
filetype plugin indent on

" ====== vundle config end ======

" use syntax on
syntax on
" show possible command suggestions
set showcmd
" use vim defaults - required for vundle
set nocompatible
" always show status line
set ls=2
" numbers of spaces of tab character
set tabstop=4
" convert tabs to spaces
set expandtab
" numbers of spaces to autoindent
set shiftwidth=4
" keep 3 lines when scrolling
set scrolloff=3
" display incomplete commands
set showcmd
" highlight searches
set hlsearch
" do incremental searching
set incsearch
" show the cursor position all the time
set ruler
" turn off error beep/flash
set visualbell t_vb=
" turn off visual bell
set novisualbell
" do not keep a backup file
set nobackup
" show line numbers
set number
" ignore case when searching
set ignorecase
" show title in console title bar
set title
" smoother changes
set ttyfast
" last lines in document sets vim mode
set modeline
" number lines checked for modelines
set modelines=3
" Abbreviate messages
set shortmess=atI
" dont jump to first character when paging
set nostartofline
" move freely between files
set whichwrap=b,s,h,l,<,>,[,]
" always set autoindenting on
set autoindent
" smart indent
set smartindent
" no c-indent
set nocindent
" toggle raw past
set pastetoggle=<F2>
" show mode
set showmode
" better command-line completion
set wildmenu
" ignore binary and swap files when searching for files using CtrlP
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class
" set colorscheme (solarized)
" colorscheme desert
set background=dark
colorscheme solarized

" press F2 to save a file opened in RO mode
:noremap <F2> :w ! sudo tee %<CR>
" press F3 to toggle formatted paste
nnoremap <F3> :set invpaste paste?<CR>
" press F4 to toggle highlighting on/off.
:noremap <F4> :noh<CR>
" press F5 to toggle numbering
nnoremap <F5> :set nonumber!<CR>

" switching between tabs
" press Ctrl+Left , Ctrl+Right to switch tabs
:map <C-Left> :tabp<CR>
:map <C-Right> :tabn<CR>

" NerdTree
map <silent> <C-n> :NERDTreeToggle<CR>

" XML Pretty format
" au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"

" FileType Specific
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd Filetype css setlocal ts=2 sts=2 sw=2
autocmd Filetype velocity setlocal ts=2 sts=2 sw=2
