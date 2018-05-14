" ====== vundle config begin ======
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

" required for vundle
set nocompatible
filetype off

" If vundle is not installed, do it first
if (!isdirectory(expand("$HOME/.vim/bundle/Vundle.vim")))
    call system(expand("mkdir -p $HOME/.vim/bundle/Vundle.vim"))
    call system(expand("git clone https://github.com/VundleVim/Vundle.vim $HOME/.vim/bundle/Vundle.vim"))
    echo 'Vundle was freshly installed. Run :PluginInstall to install all plugins'
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

" begin vundle
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" vundle plugins
" nerdtree 
Plugin 'scrooloose/nerdtree'
" Surround
Plugin 'tpope/vim-surround' 
" sparkup
Plugin 'rstacruz/sparkup'
" auto-pairs
Plugin 'vim-scripts/Auto-Pairs'
" CtrlP
Plugin 'kien/ctrlp.vim'
" Solarized Color Scheme
Plugin 'altercation/vim-colors-solarized'
" Syntastic
Plugin 'scrooloose/syntastic'
" vim-less
Plugin 'groenewege/vim-less'
" YouCompleteMe
Plugin 'Valloric/YouCompleteMe'
" Velocity
Plugin 'lepture/vim-velocity'
" JS Beautify
Plugin 'einars/js-beautify'
Plugin 'maksimr/vim-jsbeautify'
" Gradle
Plugin 'tfnico/vim-gradle'
" TOML
Plugin 'cespare/vim-toml'
" Dockerfile
Plugin 'ekalinin/Dockerfile.vim'
" vim-orgmode
Plugin 'jceb/vim-orgmode'
" vim-speeddating
Plugin 'tpope/vim-speeddating'
" Syntax Range
Plugin 'vim-scripts/SyntaxRange'
" utl.vim
Plugin 'vim-scripts/utl.vim'
" Calendar
Plugin 'mattn/calendar-vim'
" Ruby
Plugin 'vim-ruby/vim-ruby'
" endwise
Plugin 'tpope/vim-endwise'
" vim-markdown
Plugin 'tpope/vim-markdown'

 
" end of vundle
call vundle#end()

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
" Always show statusline
set laststatus=2
" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256"
" Set fold options
set foldmethod=indent
set foldlevel=20
" Clipboard
set clipboard=unnamed

" set colorscheme solarized/desert
if filereadable("$HOME/.vim/bundle/vim-colors-solarized/colors/solarized.vim")
    colorscheme solarized
else
    colorscheme desert
endif
set background=dark

" press F2 to save a file opened in RO mode
noremap <F2> :w ! sudo tee %<CR>
" press F3 to toggle formatted paste
nnoremap <F3> :set invpaste paste?<CR>
" press F4 to toggle highlighting on/off.
noremap <F4> :noh<CR>
" press F5 to toggle numbering
nnoremap <F5> :set nonumber!<CR>
" press F6 to JsBeautify
map <F6> :call JsBeautify()<cr>
" press F7 to insert current local date timestamp
nnoremap <F7> "=strftime("%Y-%m-%d %I:%M %p")<CR>P
inoremap <F7> <C-R>=strftime("%Y-%m-%d %I:%M %p")<CR>

" switching between tabs
" press Ctrl+Left , Ctrl+Right to switch tabs
:map <C-Left> :tabp<CR>
:map <C-Right> :tabn<CR>

" XML Pretty format
" au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"

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
function! StartUp()
    if 0 == argc()
        " Start     NERDTree
        NERDTree
        " Go to previous (last accessed) window
        wincmd p
    end
endfunction
autocmd VimEnter * call StartUp()

" vimdiff
if &diff
    colorscheme evening
endif

" vim-orgmode
let g:org_todo_keywords=['TODO', 'IN_PROGRESS', 'BLOCKED', '|', 'DONE']
let g:org_tag_column=400

" Mac crontab fix
autocmd filetype crontab setlocal nobackup nowritebackup

" Ruby
au FileType ruby setl sw=2 sts=2 et

" Markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'java']

