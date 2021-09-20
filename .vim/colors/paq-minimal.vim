" Vim color scheme
"
" Name:        paq-minimal.vim
" Maintainer:  Andrew Petelin <adrianopol@gmail.com>
" License:     public domain

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "paq-minimal"

" match trailing whitespace, except when typing at the end of a line
hi ExtraWhitespace ctermbg=red guibg=red
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/

if has("gui_running")
  hi Normal              guifg=#f7f2ed guibg=#191919

  hi Cursor              guibg=#fbe1fc
  hi CursorColumn        guibg=#292929
  hi CursorLine          guibg=#222222
  hi CursorLineNr        guifg=#777777 gui=bold term=bold ctermfg=14
  hi LineNr              guifg=#444444 guibg=#0d0d0d
  hi Search              guibg=#ffff00
  hi Visual              guibg=#3b3b3b

  " line used for closed folds
  hi Folded              guifg=#f6f3e8 guibg=#444444 gui=NONE

  " directory names and other special names in listings
  hi Directory           guifg=#a5c261 gui=NONE

  " normal item in popup
  hi Pmenu               guifg=#f6f3e8 guibg=#444444 gui=NONE
  " selected item in popup
  hi PmenuSel            guifg=#000000 guibg=#a5c261 gui=NONE
  " scrollbar in popup
  hi PMenuSbar           guibg=#5a647e gui=NONE
  " thumb of the scrollbar in the popup
  hi PMenuThumb          guibg=#aaaaaa gui=NONE

  hi Comment             guifg=#696969 gui=NONE
  hi Error               guifg=#ffffff guibg=#990000 gui=NONE

  hi Title               guifg=#ff1975 gui=NONE

  hi DiffAdd             guifg=#e6e1dc guibg=#144212 gui=NONE
  hi DiffDelete          guifg=#e6e1dc guibg=#660000 gui=NONE
  hi DiffText            guifg=#ffffff guibg=#ff0000 gui=NONE

  hi xmlTag              guifg=#e8bf6a gui=NONE
  hi xmlTagName          guifg=#e8bf6a gui=NONE
  hi xmlEndTag           guifg=#e8bf6a gui=NONE

  hi link htmlTag        xmlTag
  hi link htmlTagName    xmlTagName
  hi link htmlEndTag     xmlEndTag
end

" disable highlight for all other types
hi! link Character          Normal
hi! link Constant           Normal
hi! link Delimiter          Normal
hi! link Function           Normal
hi! link Identifier         Normal
hi! link Number             Normal
hi! link PreProc            Normal
hi! link Special            Normal
hi! link SpecialChar        Normal
hi! link SpecialComment     Normal
hi! link Statement          Normal
hi! link String             Normal
hi! link Type               Normal

" python: docstring
au FileType python syntax region Comment start=/^\s*r\?"""/ end=/"""/
