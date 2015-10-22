" Vim color scheme
"
" Name:        paq.vim
" Maintainer:  Andrew Petelin <adrianopol@gmail.com>
" License:     public domain
"
" Universal theme based on railscasts theme:
" http://www.vim.org/scripts/script.php?script_id=1995

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "paq"

" match trailing whitespace, except when typing at the end of a line
hi ExtraWhitespace      ctermbg=red guibg=red
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/

if has("gui_running")
  hi Normal             guifg=#f7f2ed guibg=#191919
  hi Cursor             guibg=#fbe1fc
  hi CursorColumn       guibg=#292929
  hi CursorLine         guibg=#222222
  hi CursorLineNr       guifg=#777777 gui=bold term=bold ctermfg=14
  hi LineNr             guifg=#444444 guibg=#0d0d0d
  hi Search             guibg=#ffff00
  hi Visual             guibg=#3b3b3b

  " Folds
  " -----
  " line used for closed folds
  hi Folded             guifg=#f6f3e8 guibg=#444444 gui=NONE

  " Misc
  " ----
  " directory names and other special names in listings
  hi Directory          guifg=#a5c261 gui=NONE

  " Popup Menu
  " ----------
  " normal item in popup
  hi Pmenu              guifg=#f6f3e8 guibg=#444444 gui=NONE
  " selected item in popup
  hi PmenuSel           guifg=#000000 guibg=#a5c261 gui=NONE
  " scrollbar in popup
  hi PMenuSbar          guibg=#5a647e gui=NONE
  " thumb of the scrollbar in the popup
  hi PMenuThumb         guibg=#aaaaaa gui=NONE

  hi Character          guifg=#d100ce gui=NONE
  hi Comment            guifg=#696969 gui=NONE
  hi Constant           guifg=#6d9cbe gui=NONE
  hi Delimiter          guifg=#519f50 gui=NONE
  hi Error              guifg=#ffffff guibg=#990000 gui=NONE
  hi Function           guifg=#00ebc4 gui=NONE
  hi Identifier         guifg=#b0b0ff gui=NONE
  hi Number             guifg=#ff2e2e gui=NONE
  hi PreProc            guifg=#1c86ff gui=NONE
  hi Special            guifg=#ffa500 gui=NONE
  hi SpecialChar        guifg=#ffa500 gui=NONE
  hi SpecialComment     guifg=#bababa gui=NONE
  hi Statement          guifg=#cc7833 gui=NONE
  hi String             guifg=#c261c0 gui=NONE
  hi Type               guifg=#2cdb00 gui=NONE

  hi Title              guifg=#ff1975 gui=NONE

  hi DiffAdd            guifg=#e6e1dc guibg=#144212 gui=NONE
  hi DiffDelete         guifg=#e6e1dc guibg=#660000 gui=NONE
  hi DiffText           guifg=#ffffff guibg=#ff0000 gui=NONE

  hi link htmlTag       xmlTag
  hi link htmlTagName   xmlTagName
  hi link htmlEndTag    xmlEndTag

  hi xmlTag             guifg=#e8bf6a gui=NONE
  hi xmlTagName         guifg=#e8bf6a gui=NONE
  hi xmlEndTag          guifg=#e8bf6a gui=NONE
end
