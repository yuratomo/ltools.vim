let s:count = 3

function! Lsearch#Search(...)
  if !exists('b:Lsearch_data')
    call s:prepare()
  endif
  if exists('b:Lsearch_data.0')
    for idx in reverse(range(s:count-1))
      if exists('b:Lsearch_data[idx]')
        let b:Lsearch_data[idx+1] = {}
        let b:Lsearch_data[idx+1].keyword = b:Lsearch_data[idx].keyword
      endif
    endfor
  endif
  let b:Lsearch_data.0 = {}
  let b:Lsearch_data.0.keyword = join(a:000, ' ')
  call Lsearch#Refresh()
  redraw
endfunction

function! Lsearch#Refresh()
  call s:clean()
  if exists('b:Lsearch_data')
    for idx in range(s:count)
      if exists('b:Lsearch_data[idx]')
        let b:Lsearch_data[idx].id = matchadd('LsearchSelect' . idx, b:Lsearch_data[idx].keyword)
      endif
    endfor
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
  if !hlexists('LsearchSelect0')
    hi LsearchSelect0  guibg=#3030A0 guifg=NONE gui=BOLD
  endif
  if !hlexists('LsearchSelect1')
    hi LsearchSelect1  guibg=#202080 guifg=NONE gui=NONE
  endif
  if !hlexists('LsearchSelect2')
    hi LsearchSelect2  guibg=#101040 guifg=NONE gui=NONE
  endif
  augroup Lsearch
    au!
    au BufWinEnter <buffer> silent! call Lsearch#BufWinEnter()
    au BufWinLeave <buffer> silent! call Lsearch#BufWinLeave()
  augroup END
endfunction

function! s:clean()
  if exists('b:Lsearch_data')
    for idx in range(s:count)
      if exists('b:Lsearch_data[idx].id')
        call matchdelete(b:Lsearch_data[idx].id)
      endif
    endfor
  endif
endfunction

