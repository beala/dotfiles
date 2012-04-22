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
"Turn on highlighting, and highlight current line with grey.
set cursorline
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
" ,-[arrow key] adjusts split window size.
nnoremap <leader><Right> :vertical res +5<cr>
nnoremap <leader><Left> :vertical res -5<cr>
nnoremap <leader><Up> :res +5<cr>
nnoremap <leader><Down> :res -5<cr>
" Remap leader to ,
" ,f for commandT
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
" Powerline config
let g:Powerline_symbols = 'fancy'
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors
set laststatus=2
" TagbarToggle config
nmap <leader>t :TagbarToggle<CR>
