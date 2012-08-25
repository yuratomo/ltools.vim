if version < 700 || exists("b:Ltaglist_syntax")
  finish
endif

runtime! syntax/cpp.vim

syn match LtaglistSeparator /|/
hi link LtaglistSeparator  Function

let b:Ltaglist_syntax = 1
