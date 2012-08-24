" FILE: Lgrep.vim
" AUTHOR:  yuratomo
" 
" [USAGE]
"
"  grep start:
"   :Lgrep /s keyword filepattern
"
"  grep cancel:
"   :LgrepCancel
"
"  show grep status:
"   :LgrepStatus
"
"  update quickfix list:
"   :LgrepUpdate
"

if !has('win32')
  echoerr 'Lgrep can not load.' | finish
endif
if exists('g:Lgrep_loaded') && g:Lgrep_loaded == 1
  finish
endif
if !exists('g:Lgrep_AutoUpdateQuickFix')
  let g:Lgrep_AutoUpdateQuickFix = 1
endif
if !exists('g:Lgrep_hilight')
  let g:Lgrep_hilight = 'highlight StatusLine guifg=#FFFFFF guibg=#FF0000 gui=none'
endif

command! -nargs=* Lgrep :call Lgrep#do(<f-args>)
command! -nargs=0 LgrepUpdate :call Lgrep#UpdateQuickFix()
command! -nargs=0 LgrepCancel :call Lgrep#CancelGrep()
command! -nargs=0 LgrepStatus :call Lgrep#ShowStatus()

let g:Lgrep_loaded = 1
