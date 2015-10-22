" Vim color scheme
"
" Name:        paq-minimal.vim
" Maintainer:  Andrew Petelin <adrianopol@rbox.me>
" License:     public domain
"
" 256 color table: http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html

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

" python: docstring
" \%(\) :: https://neovim.io/doc/user/pattern.html#%2F%5C%25(%5C)
" \@<= :: https://neovim.io/doc/user/pattern.html#%2F%5C%40%3C%3D
au FileType python syntax region Comment
  \ start=/\%(:\n\s*\|\n\|\%^\)\@<=\z('''\|"""\)/ end=/\z1/ keepend
  \ contains=pythonEscape,pythonTodo,@Spell

if has("gui_running")
  hi Normal              guifg=#eeeeee guibg=#1c1c1c

  hi Cursor              guibg=#fbe1fc
  hi CursorColumn        guibg=#292929
  hi CursorLine          guibg=#222222
  hi CursorLineNr        guifg=#777777 gui=bold
  hi LineNr              guifg=#444444 guibg=#0d0d0d
  hi Search              guibg=#ffff00
  "hi Title               guifg=#ff1975 gui=NONE
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

  hi Comment             guifg=#626262 gui=NONE
  hi Error               guifg=#ffffff guibg=#990000 gui=NONE

  hi DiffAdd             guifg=#e6e1dc guibg=#144212 gui=NONE
  hi DiffDelete          guifg=#e6e1dc guibg=#660000 gui=NONE
  hi DiffText            guifg=#ffffff guibg=#ff0000 gui=NONE
end

hi Normal   ctermfg=255 ctermbg=234
hi Comment  ctermfg=241 ctermbg=NONE
hi LineNr   ctermfg=238 ctermbg=0

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
hi! link Title              Normal
hi! link Type               Normal

hi! link xmlEndTag          Normal
hi! link xmlTag             Normal
hi! link xmlTagName         Normal

hi! link htmlTag            xmlTag
hi! link htmlTagName        xmlTagName
hi! link htmlEndTag         xmlEndTag

hi! link htmlBold           Normal
hi! link htmlEndTag         Normal
hi! link htmlH1             Normal
hi! link htmlH2             Normal
hi! link htmlH3             Normal
hi! link htmlH4             Normal
hi! link htmlH5             Normal
hi! link htmlH6             Normal
hi! link htmlItalic         Normal
hi! link htmlLink           Normal

hi! link markdownError      Normal

if has('nvim')
  hi StatusLine   term=bold,reverse cterm=bold,reverse gui=bold,reverse

  hi LineNr       guifg=#444444 guibg=#000000
  hi Normal       guifg=White   guibg=#1e1e1e
  hi Todo         guifg=Black   guibg=DarkYellow  cterm=bold gui=bold
  hi Comment      guifg=#666666
endif
