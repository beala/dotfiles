call pathogen#infect()          "setup pathogen
call pathogen#helptags()        "create help tags
set nocompatible
syntax enable
set encoding=utf-8
set showcmd                     "display incomplete commands
filetype plugin indent on       "load filetype plugins + indentation
filetype on
set autoindent                  "copy indent from row above
set number                      "turn on line numbers
set ruler                       "enable line and column number count
"" Whitespace
set nowrap                      "don't wrap lines
set softtabstop=4               "indent 4 columns/spaces when in insert mode
set tabstop=4                   "tabs indent 4 columns
set shiftwidth=4                "indent 4 columns when using automatic reindentation
set expandtab                   "use spaces, not tabs
set backspace=indent,eol,start  "backspace through everything in insert mode
set list                        "show invisible characters
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<   "reaplce invisibles with this shit

"" Searching
set hlsearch                    "highlight search
set incsearch                   "incremental search
set ignorecase                  "ignore case of search
set smartcase                   "unless they contains at least one cap
"" Moving between windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" use comma as <Leader> key instead of backslash
let mapleader=","
" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap $$ <C-R>=expand('%:h').'/'<cr>

" ,f for commandT
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>
