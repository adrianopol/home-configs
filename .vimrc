syntax on
colorscheme paq-minimal

""" plugins
" update: :PlugUpdate
" https://github.com/junegunn/vim-plug/wiki/faq#shouldnt-vim-plug-update-itself-on-plugupdate-like-vundle :
" > Manually clone vim-plug and symlink plug.vim to ~/.vim/autoload:
" >   mkdir -p ~/.vim/{autoload,plugged}
" >   git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug
" >   ln -s ~/.vim/plugged/vim-plug/plug.vim ~/.vim/autoload
" vim-plug
call plug#begin()
  Plug 'junegunn/vim-plug',       { 'tag': '*' } " using a tagged release; wildcard allowed

  Plug 'preservim/nerdtree',      { 'tag': '*' }
  Plug 'jlanzarotta/bufexplorer', { 'tag': '*' }

  " LSP; FIXME: too old; check alternatives
  "~Plug 'prabirshrestha/vim-lsp',  { 'commit': '04428c920002ac7cfacbecacb070a8af57b455d0' }
  "~Plug 'mattn/vim-lsp-settings',  { 'commit': 'ec38220cbcfbd9704294577f94ca80548f8ef57c' }

  "Plug 'fatih/vim-go',            { 'tag': '*' }
  "Plug 'mrcjkb/rustaceanvim',     { 'tag': '*' }
  "Plug 'davidhalter/jedi-vim',    { 'tag': '*' } " static analyzer
  "Plug 'jreybert/vimagit',        { 'commit': 'fc7eda97da4f8182c8abbe6ea7befbd789b8b935' }
call plug#end()

"~ """ vim-lsp
"~ if executable('pylsp')
"~   " pip install python-lsp-server
"~   au User lsp_setup call lsp#register_server({
"~     \ 'name': 'pylsp',
"~     \ 'cmd': {server_info->['pylsp']},
"~     \ 'allowlist': ['python'],
"~     \ })
"~ endif
"~
"~ """ LSP hotkeys
"~ " LSP hotkeys; see https://github.com/prabirshrestha/vim-lsp#registering-servers
"~ function! s:on_lsp_buffer_enabled() abort
"~   setlocal omnifunc=lsp#complete
"~   setlocal signcolumn=no
"~   if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
"~   " go back: C-o and C-i
"~   nmap <buffer> gd <plug>(lsp-definition)
"~   nmap <buffer> gs <plug>(lsp-document-symbol-search)
"~   nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
"~   nmap <buffer> gr <plug>(lsp-references)
"~   nmap <buffer> gi <plug>(lsp-implementation)
"~   nmap <buffer> gt <plug>(lsp-type-definition)
"~   nmap <buffer> <leader>rn <plug>(lsp-rename)
"~   nmap <buffer> [g <plug>(lsp-previous-diagnostic)
"~   nmap <buffer> ]g <plug>(lsp-next-diagnostic)
"~   nmap <buffer> K <plug>(lsp-hover)
"~   nmap <buffer> <F12> <plug>(lsp-document-format)
"~   nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
"~   nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
"~
"~   let g:lsp_format_sync_timeout = 1000
"~   "autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync') -- too slow
"~   " refer to doc to add more commands
"~ endfunction
"~
"~ " TODO: ???
"~ augroup lsp_install
"~   au!
"~   " call s:on_lsp_buffer_enabled only for languages that has the server registered.
"~   autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
"~ augroup END
"~
"~ " LSP: don't show extra information about completion:
"~ "set completeopt-=preview
"~
"~ """ vim-go
"~ let g:go_fmt_autosave = 0
"~ let g:go_fmt_fail_silently = 1
"~ let g:go_gopls_deep_completion = 1
"~ let g:go_highlight_functions = 1
"~ let g:go_highlight_structs = 1
"~ let g:go_imports_autosave = 0
"~ function! MyGoFmt()
"~   GoFmt
"~   GoImports
"~ endfunction
"~ nnoremap <F12> :call MyGoFmt()<CR>

""" main

set history=500
set shiftwidth=2  " the number of space characters inserted for indentation
set tabstop=2     " number of spaces that a <Tab> in the file counts for
set expandtab     " to insert space characters whenever the tab key is pressed
set smarttab      " delete tab, not a single space when pressing backspace
set autoindent    " use the indent from the previous line
set nocindent
set indentexpr=
set incsearch
set hlsearch
set noignorecase
set number numberwidth=3
if has('nvim')
  set inccommand=
  "~set mouse=
  " '\]' : copy to X clipboard (was `"+y`)
  vnoremap <leader>] "+y
  nnoremap <leader>] "+y
  " '\[' : paste from X clipboard (was `"+p`)
  nnoremap <leader>[ "+p
  vnoremap <leader>[ "+p
else
  "set mouse=nvi
  set wildoptions=pum wildmenu " enable vertical menu like in nvim
endif

set statusline=%F%m%r%h%w\ \ hex=\%2B\ \ pos=%02p%%\ \ line=%03l/%03L\ \ col=%v
let &statusline.='  V=%{abs(line(".") - line("v")) + 1}'
set laststatus=2  " tells when the last window also has a status line
set scrolloff=1   " n lines to the cursor when moving vertically

set sessionoptions=blank,buffers,folds,help,options,sesdir,tabpages,winpos,winsize

""" other

" folding
set nofoldenable foldmethod=indent foldlevel=999

" fix for nixos:
set backspace=indent,eol,start

if !has('nvim') " no support in nvim
  "set cm=blowfish2   " best encryption method (requires >=vim-7.4.399)
  set cm=xchacha20v2  " You should use 'blowfish2', also to re-encrypt older files.
                      " The 'xchacha20' method provides better encryption, but it does
                      " not work with all versions of Vim.
  "set viminfo= nobackup nowritebackup " this is set in a `vim-crypt` alias
endif

let g:omni_sql_no_default_maps = 1 " disable sql omni completion
let g:NERDTreeNodeDelimiter = "\u00a0" " remove '^G' when syntax is off

"---------- Mappings ----------"

" keep visual mode after indention:
vnoremap < <gv
vnoremap > >gv

" - invert the 'paste' option, and show its value
" - the same in insert mode (but insert mode mappings only apply when 'paste' is off)
" - allow press <F2> when in insert mode, to turn 'paste' off
" (see http://vim.wikia.com/wiki/Toggle_auto-indenting_for_code_paste)
nnoremap <F2> :set invpaste paste?<CR>
inoremap <F2> <C-O><F2>
set pastetoggle=<F2>

" remove trailing spaces:
nnoremap <F4> :%s/\s\+$//e<CR>

" toggle hidden characters:
nnoremap <F5> :set list!<CR>

" duplicate tab:
nnoremap <C-Enter> :tab split<CR>

" move tabs
noremap <C-S-PageUp>   :tabmove -1<CR>
noremap <C-S-PageDown> :tabmove +1<CR>

" goto definition (if only one), or show a list of possible definitions (if many):
nnoremap <C-]> g<C-]>

"----- Language-specific settings -----"

let html_use_css = 1 " the ':%TOhtml' command generates html without <font> tags

" disable auto-commention:
au FileType * setl fo-=r

" file types:
au BufRead,BufNewFile *.vala,*.vapi         setl ft=vala
au BufRead,BufNewFile SConstruct,SConscript setl ft=python
au BufRead,BufNewFile *.1c                  setl ft=bsl

au FileType asciidoc,markdown setl textwidth=0
au FileType c,cpp,python  setl shiftwidth=4 tabstop=4 "cc=101
au FileType d             setl noexpandtab shiftwidth=2 tabstop=2
au FileType go            setl noexpandtab shiftwidth=4 tabstop=4 nowrap
au FileType make          setl noexpandtab shiftwidth=8 tabstop=8
au FileType markdown      setl shiftwidth=2 tabstop=2 formatoptions-=l

" prevent vim from reading boost include files:
set include=^\\s*#\\s*include\ \\(<boost/\\)\\@!

if has('gui_running')
  if hostname() == 'iota'
    set guifont=Terminus\ 9
  else
    set guifont=Terminus\ 10
  endif

  set showtabline=2

  " hide menubar, toolbar, scrollbars:
  set guioptions-=m
  set guioptions-=T
  set guioptions-=l
  set guioptions-=L
  "set guioptions-=r
  set guioptions-=R

  " fix for nixos:
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>
endif
