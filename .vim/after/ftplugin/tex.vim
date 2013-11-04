" (Soft) wrap lines and set j,k to move between visual lines.
set wrap lbr
map j gj
map k gk
set noautoindent
set nolist
set nocursorline        "Don't underline the current line.
set colorcolumn=""      "Don't highlight any columns
set display+=lastline   "Don't display '@' when line is cutoff
set spell               "Spell check
set softtabstop=2       "indent 2 columns/spaces when in insert mode
set tabstop=2           "tabs indent 2 columns
set shiftwidth=2        "indent 2 columns when using automatic reindentation
set expandtab
