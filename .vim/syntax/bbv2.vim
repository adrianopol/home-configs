" Vim syntax file"
" Language:	Boost Build v2 (BBv2)
" Maintainer:	Anatoli Sakhnik (sakhnik на gmail крапка com)
" Last change:  v1.0 2008/03/26 10:00:00

syn case match

syn match bbv2Target "^\s*\(actions\|alias\|build-project\|constant\|exe\|explicit\|import\|install\|lib\|local\|make\|notfile\|path-constant\|project\|run\|searched-lib\|test-suite\|use-project\|using\|variant\)\>"
syn match bbv2Feature "\(<address-model>\|<cflags>\|<cxxflags>\|<debug-symbols>\|<define>\|<file>\|<include>\|<library>\|<link>\|<linkflags>\|<location>\|<name>\|<optimization>\|<runtime-debugging>\|<runtime-link>\|<search>\|<threading>\|<variant>\)"
syn match bbv2BuiltIn "\<\(glob\|glob-tree\|MATCH\|run\|SHELL\)\>"
syn match bbv2Variable "\$([^)]\+)"
syn match bbv2ProjectAttributes "source-location\|requirements\|default-build\|build-dir"
syn region bbv2Comment start="#" end="$"
"syn match bbv2String '\("[^"]*"\)\|\(\'[^\']*\'\)'
syn include @Shell syntax/sh.vim
syn region bbv2Actions start="^{$" end="^}$" keepend fold contains=@Shell

hi def link bbv2Comment Comment
hi def link bbv2Target Type
hi def link bbv2Feature Special
hi def link bbv2BuiltIn Keyword
hi def link bbv2Variable Identifier
hi def link bbv2ProjectAttributes Number
"hi def link bbv2String String
