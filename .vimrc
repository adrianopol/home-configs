syntax on
execute pathogen#infect()

set nocompatible

set history=50
set shiftwidth=2  " the number of space characters inserted for indentation
set tabstop=2     " number of spaces that a <Tab> in the file counts for
set expandtab     " to insert space characters whenever the tab key is pressed
set smarttab      " delete tab, not a single space when pressing backspace
set autoindent    " use the indent from the previous line

set statusline=%F%m%r%h%w\ [HEX=\%02B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2  " tells when the last window also has a status line
set scrolloff=1   " n lines to the curor when moving vertically

set incsearch
set hlsearch
set noignorecase

let g:leave_my_textwidth_alone = 1 " fix for Gentoo :)

set sessionoptions=blank,help,tabpages

"set mouse=a

"---------- Mappings ----------"

" Keep visual mode after indention
vnoremap < <gv
vnoremap > >gv

" 1. Invert the 'paste' option, and show its value.
" 2. The same in insert mode (but insert mode mappings only apply when 'paste' is off).
" 3. Allow press <F2> when in insert mode, to turn 'paste' off.
" See http://vim.wikia.com/wiki/Toggle_auto-indenting_for_code_paste
nnoremap <F2> :set invpaste paste?<CR>
inoremap <F2> <C-O><F2>
set pastetoggle=<F2>

" fuzzy finder
nnoremap <F3> :FufCoverageFile<CR>

" remove trailing spaces
nnoremap <F4> :%s/\s\+$//e<CR>

" toggle hidden characters
nnoremap <F5> :set list!<CR>

" open with cp1251
nnoremap <F12> :e ++enc=cp1251<CR>

" open tag in new tab
nnoremap <C-Enter> <C-w><C-]><C-w>T

" move tabs
noremap <C-S-PageUp>   :tabmove -1<CR>
noremap <C-S-PageDown> :tabmove +1<CR>

" Return to the left-side tab after closing the current one
" (http://vim.wikia.com/wiki/Have_focus_on_left_tab_after_tabclose)

"----- Language-specific settings -----"

let html_use_css = 1 " the ':%TOhtml' command generates html without <font> tags

" Disable auto-commention
au FileType * setl fo-=r

" File types
au BufRead,BufNewFile *.djhtml set ft=htmldjango
au BufRead,BufNewFile *.rs set ft=rust
au BufRead,BufNewFile *.scala set ft=scala
au BufRead,BufNewFile *.tex set ft=tex
au BufRead,BufNewFile *.vala,*.vapi set ft=vala
au BufRead,BufNewFile SConstruct,SConscript set ft=python

au FileType asciidoc setlocal textwidth=100
au FileType d setlocal noexpandtab shiftwidth=2 tabstop=2
au FileType go,make setlocal noexpandtab shiftwidth=4 tabstop=4

" Go
"let g:go_fmt_autosave = 0
"let g:go_fmt_fail_silently = 1
let g:go_highlight_functions = 1
let g:go_highlight_structs = 1

" Prevent vim from reading boost include files
set include=^\\s*#\\s*include\ \\(<boost/\\)\\@!

"" CleverTabs v1.0.2: Martin Spevak 2008 (tabs only on the line beginning)
"" (http://www.vim.org/scripts/script.php?script_id=2308)
"function! CleverTabs(shiftwidth)
"  let line = getline('.')[:col('.')-2]
"  if col('.') == 1 || line =~ '^\t*$' || line =~ '^$'
"    let z = "\t"
"  else
"    let space = ""
"    let shiftwidth = a:shiftwidth
"    let shiftwidth = shiftwidth - ((virtcol('.')-1) % shiftwidth)
"
"    while shiftwidth > 0
"      let shiftwidth = shiftwidth - 1
"      let space = space . ' '
"    endwhile
"
"    let z = space
"  endif
"
"  return z
"endfunction "CleverTabs
"
"" map tab key to function
"imap <silent> <Tab> <C-r>=CleverTabs(4)<cr>

if has('gui_running')
  colorscheme paq
  set number
  set numberwidth=5

  set guifont=Terminus\ 9

  set showtabline=2

  " Hide menubar, toolbar, scrollbars
  set guioptions-=m
  set guioptions-=T
  set guioptions-=l
  set guioptions-=L
  set guioptions-=R
  set guioptions-=r

  map <S-Insert> <MiddleMouse>
endif
