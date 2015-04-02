" ====== vundle config begin ======
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" required for vundle
filetype off

" If vundle is not installed, do it first
if (!isdirectory(expand("$HOME/.vim/bundle/vundle")))
    call system(expand("mkdir -p $HOME/.vim/bundle"))
    call system(expand("git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/vundle"))
    echoerr 'Vundle was freshly installed. You should run :BundleInstall'
endif

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
" Syntastic
Bundle 'scrooloose/syntastic'
" vim-less
Bundle 'groenewege/vim-less'
" YouCompleteMe
Bundle 'Valloric/YouCompleteMe'
" Velocity
Bundle "lepture/vim-velocity"
" JS Beautify
Bundle 'einars/js-beautify'
Bundle 'maksimr/vim-jsbeautify'

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
" show mode
set showmode
" better command-line completion
set wildmenu
" set colorscheme solarized/desert
if filereadable("$HOME/.vim/bundle/vim-colors-solarized/colors/solarized.vim")
    colorscheme solarized
else
    colorscheme desert
endif
set background=dark

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


" XML Pretty format
" au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"

" FileType Specific
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd Filetype css setlocal ts=2 sts=2 sw=2
autocmd Filetype velocity setlocal ts=2 sts=2 sw=2
autocmd Filetype less setlocal ts=2 sts=2 sw=2

" Plugin specific config
" Ctrl-P
" ignore binary and swap files when searching for files using CtrlP
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class,*.git
" mark eclipse projects as CtrlP root
let g:ctrlp_root_markers = ['.project']
" use silver searcher (apt-get install silversearcher-ag)
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

" hql as sql
au BufRead,BufNewFile *.hql set filetype=sql

" NerdTree
map <silent> <C-n> :NERDTreeToggle<CR>

" JsBeautify
map <F6> :call JsBeautify()<cr>

" vimdiff
if &diff
    colorscheme evening
endif"

" powerline
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
" Always show statusline
set laststatus=2
" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256"
