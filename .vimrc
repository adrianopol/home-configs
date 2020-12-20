syntax on
colorscheme paq-minimal
if &diff
  colorscheme blue
endif
" execute pathogen#infect()

set nocompatible

set history=500
set shiftwidth=2  " the number of space characters inserted for indentation
set tabstop=2     " number of spaces that a <Tab> in the file counts for
set expandtab     " to insert space characters whenever the tab key is pressed
set smarttab      " delete tab, not a single space when pressing backspace
set autoindent    " use the indent from the previous line

set statusline=%F%m%r%h%w\ \ hex=\%2B\ \ pos=%02p%%\ \ line=%03l/%03L\ \ col=%v
let &statusline.='  V=%{abs(line(".") - line("v")) + 1}'
set laststatus=2  " tells when the last window also has a status line
set scrolloff=1   " n lines to the cursor when moving vertically

set incsearch
set hlsearch
set noignorecase
"set mouse=a
set sessionoptions=blank,buffers,folds,help,options,sesdir,tabpages,winpos,winsize

" encryption
set cm=blowfish2  " best (requires >=vim-7.4.399)
"set viminfo=
"set nobackup
"set nowritebackup

let g:leave_my_textwidth_alone = 1 " fix for Gentoo :)
let g:omni_sql_no_default_maps = 1 " disable sql omni completion
let g:NERDTreeNodeDelimiter = "\u00a0" " remove '^G' when syntax is off

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

" remove trailing spaces
nnoremap <F4> :%s/\s\+$//e<CR>

" toggle hidden characters
nnoremap <F5> :set list!<CR>

" duplicate tab
nnoremap <C-Enter> :tab split<CR>
" open tag in new tab
"nnoremap <C-Enter> <C-w><C-]><C-w>T

" goto definition (if only one), or show a list of possible definitions (if
" many)
nnoremap <C-]> g<C-]>

" tabs
"nnoremap <C-S-t> :tabnew<CR>
"inoremap <C-S-t> <Esc>:tabnew<CR>
"inoremap <C-S-w> <Esc>:tabclose<CR>
" move tabs
noremap <C-S-PageUp>   :tabmove -1<CR>
noremap <C-S-PageDown> :tabmove +1<CR>

"----- Language-specific settings -----"

let html_use_css = 1 " the ':%TOhtml' command generates html without <font> tags

" Disable auto-commention
au FileType * setl fo-=r

" File types
au BufRead,BufNewFile *.scala               setl ft=scala
au BufRead,BufNewFile *.tex                 setl ft=tex
au BufRead,BufNewFile *.vala,*.vapi         setl ft=vala
au BufRead,BufNewFile SConstruct,SConscript setl ft=python
au BufRead,BufNewFile *.1c                  setl ft=bsl

au FileType asciidoc,markdown setl textwidth=120
"au FileType cpp       setl cc=101
au FileType d         setl noexpandtab shiftwidth=2 tabstop=2
au FileType go        setl noexpandtab shiftwidth=4 tabstop=4 nowrap
au FileType make      setl noexpandtab shiftwidth=8 tabstop=8
au FileType markdown  setl formatoptions-=l

" Go
"let g:go_fmt_autosave = 0
"let g:go_fmt_fail_silently = 1
let g:go_highlight_functions = 1
let g:go_highlight_structs = 1

" Prevent vim from reading boost include files
set include=^\\s*#\\s*include\ \\(<boost/\\)\\@!
"
"" map tab key to function
"imap <silent> <Tab> <C-r>=CleverTabs(4)<cr>

if has('gui_running')
  "TODO
  "if &diff
  "  set lines=999 columns=999
  "endif
  colorscheme paq-minimal
  set number
  set numberwidth=5

  set guifont=xos4\ Terminus\ 9

  set showtabline=2

  " Hide menubar, toolbar, scrollbars
  set guioptions-=m
  set guioptions-=T
  set guioptions-=l
  set guioptions-=L
  "set guioptions-=r
  set guioptions-=R

  map <S-Insert> <MiddleMouse>
endif
