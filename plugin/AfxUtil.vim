" FILE: afxutil.vim
" AUTHOR:  yuratomo
" Last Modified: 2 Feb 2012.
" Version: 0.0.1

if exists('g:afxutil_loaded') && g:afxutil_loaded == 1
  finish
endif

if !exists('g:afxutil_afxpath')
  let g:afxutil_afxpath = 'C:\Program Files\afx\afxw.exe'
endif

command! -nargs=0 AfxOpen    :call Afxutil#Open('P', expand('%:p'))
command! -nargs=0 AfxOpenL   :call Afxutil#Open('L', expand('%:p'))
command! -nargs=0 AfxOpenR   :call Afxutil#Open('R', expand('%:p'))
command! -nargs=0 AfxCursor  :call Afxutil#Open('P', expand("<cfile>:p"))
command! -nargs=0 AfxCursorL :call Afxutil#Open('L', expand("<cfile>:p"))
command! -nargs=0 AfxCursorR :call Afxutil#Open('R', expand("<cfile>:p"))
command! -nargs=0 AfxFocus   :call Afxutil#Focus()
command! -nargs=* AfxGrep    :call Afxutil#Grep(<f-args>)
command! -nargs=* AfxGrep2   :call Afxutil#Grep2(<f-args>)

function! Afxutil#Open(option, file)
  exe 'silent !start '.shellescape(g:afxutil_afxpath).' -s -'.a:option.shellescape(a:file)
endfunction

function! Afxutil#Focus()
  exe 'silent !start '.shellescape(g:afxutil_afxpath).' -s'
endfunction

" open and focus to vim 
"gvim --cmd "call remote_foreground('afx')" --cmd "call remote_send('afx', '<c-\><c-N>:e xxx<RETURN>')" --cmd :q --

" focus to vim
"gvim --cmd "call remote_foreground('afx')" --cmd :q --

let g:afxutil_loaded = 1
