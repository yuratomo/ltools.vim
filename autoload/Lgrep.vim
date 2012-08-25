" FILE: Lgrep.vim
" AUTHOR:  yuratomo

let g:Lgrep#status = 'no start'
let g:Lgrep#last_file = ''

function! Lgrep#do(...)
  let g:Lgrep#last_file = getcwd()
  let g:Lgrep#temp_file = tempname()
  silent exe '!start /MIN cmd /c TITLE Lgrep' . v:servername . ' & ' 
    \ . &grepprg . ' ' . join(a:000,' ') . '>' . g:Lgrep#temp_file . ' & '
    \ . $vim . '\gvim --cmd "call remote_expr(' . "'" . v:servername . "','" . "GrepPostProc()" . "'".')" --cmd ":q" --'
  let g:Lgrep#status = 'processing now'
  call s:ShwoStatus()
  silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
  silent exec g:Lgrep_hilight
endfunction

function! GrepPostProc()
  let g:Lgrep#status = 'grep end'
  call Lgrep#UpdateQuickFix()
  call s:ShwoStatus()
endfunction

function! Lgrep#CancelGrep()
  silent exe '!start /b cmd /c taskkill /T /F /FI "WINDOWTITLE eq Lgrep'.v:servername.'" & taskkill /T /F /FI "WINDOWTITLE eq ŠÇ—ŽÒ:  Lgrep'.v:servername.'*"'
  let g:Lgrep#status = 'canceled'
  call Lgrep#UpdateQuickFix()
  call s:ShwoStatus()
endfunction

function! Lgrep#UpdateQuickFix()
  if exists('g:Lgrep#temp_file')
    exe 'cd '.g:Lgrep#last_file
    exe 'cgetfile '.g:Lgrep#temp_file
    if g:Lgrep_AutoUpdateQuickFix == 1
      copen
    endif
    if g:Lgrep#status == 'grep end'
      call s:clear()
      highlight clear StatusLine
      silent exec s:slhlcmd
      redraw
    endif
  endif
endfunction

function s:clear()
  if exists('g:Lgrep#temp_file')
    call delete(g:Lgrep#temp_file)
    unlet g:Lgrep#temp_file
  endif
endfunction

function! s:ShwoStatus()
  echo g:Lgrep#status
  redraw
endfunction

function! s:GetHighlight(hi)
  redir => hl
    silent exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

let g:Lgrep_loaded = 1
