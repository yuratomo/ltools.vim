let s:count = 1

function! Lsearch#Search(...)
  if !exists('b:Lsearch_data')
    call s:prepare()
  endif
  if exists('b:Lsearch_data.keyword') && b:Lsearch_data.keyword == join(a:000, ' ')
    call s:clean()
    unlet b:Lsearch_data.keyword
    return
  endif
  let b:Lsearch_data.keyword = join(a:000, ' ')
  call Lsearch#Refresh()
  redraw
endfunction

function! Lsearch#Refresh()
  call s:clean()
  if exists('b:Lsearch_data')
    let b:Lsearch_data.id = matchadd('LsearchSelect', b:Lsearch_data.keyword)
  endif
endfunction

function! Lsearch#BufWinLeave()
  call s:clean()
endfunction

function! Lsearch#BufWinEnter()
  call Lsearch#Refresh()
endfunction

function! Lsearch#Clear()
  call s:clean()
  if exists('b:Lsearch_data')
    unlet b:Lsearch_data
  endif
  augroup Lsearch
    au!
  augroup END
  redraw
endfunction

function! s:prepare()
  let b:Lsearch_data = {}
  if !hlexists('LsearchSelect')
    hi LsearchSelect  guibg=#3030A0 guifg=NONE gui=BOLD
  endif
  augroup Lsearch
    au!
    au BufWinEnter <buffer> silent! call Lsearch#BufWinEnter()
    au BufWinLeave <buffer> silent! call Lsearch#BufWinLeave()
  augroup END
endfunction

function! s:clean()
  if exists('b:Lsearch_data.id')
    call matchdelete(b:Lsearch_data.id)
    unlet b:Lsearch_data.id
  endif
endfunction

