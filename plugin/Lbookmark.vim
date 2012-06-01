" FILE: Lbookmark.vim
" AUTHOR:  yuratomo
" Last Modified: 31 Jan 2012.
" Version: 0.0.1

if exists('g:Lbookmark_loaded') && g:Lbookmark_loaded == 1
  finish
endif
if !exists('g:Lcore_loaded') || g:Lcore_loaded == 0
  runtime plugin/Lcore.vim
endif

let g:Lbookmark_title = Lcore#RegistPlugin('Lbookmark')
if !exists("g:Lbookmark_file")
  let g:Lbookmark_file = $home.'\\.vim_bookmark'
endif
let g:Lbookmark_list = []
let g:Lbookmark_sort = 0

command! -nargs=? Lbookmark :call Lbookmark#Show()
command! -nargs=0 LRegistBookmark :call Lbookmark#Regist()

function! Lbookmark#Show()
  call Lcore#Close()
  if exists("a:1")
    let g:Lcore_refine_word = a:1
  endif
  exe ':topleft new '.g:Lbookmark_title
  exe ':res '.g:Lcore_line_num
  call Lbookmark#Load()
  call Lbookmark#Update()
  call Lcore#HilightTitle()
  syn match LbookmarkDirHilight  /.*\\/
  syn match LbookmarkExtHilight  /\.\w*$/
  syn match LbookmarkNameHilight /^[^\[]\{32\}/
  hi link LbookmarkDirHilight  Statement
  hi link LbookmarkExtHilight  Comment
  hi link LbookmarkNameHilight String
  call Lcore#CommonSetting()
  nnoremap <buffer> r :call Lbookmark#Rename()<CR>
endfunction

function! Lbookmark#Update()
  setlocal modifiable
  if g:Lbookmark_sort == 1
    let list = sort(copy(g:Lbookmark_list))
  else
    let list = copy(g:Lbookmark_list)
  endif
  call Lcore#Refine(list)
  call Lcore#Clear()
  call Lcore#Show(list)
  call Lcore#SetCursorTop()
  setlocal nomodifiable
endfunction

function! Lbookmark#Regist(...)
  if a:0 == 1
    let target = a:1
  else
    let target = expand('%:p')
  endif
  let name = input('Input bookmark name for "'. target .'":', '')
  if name == ''
    return
  endif
  let line = printf('%-32s', name).target
  let pos = index(g:Lbookmark_list, line)
  if pos >= 0
    call remove(g:Lbookmark_list, pos)
  endif
  call insert(g:Lbookmark_list, line, 0)
  call Lbookmark#Save()
endfunction

function! Lbookmark#Open(line)
  wincmd p
  exe ':e '.a:line[32:]
endfunction

function! Lbookmark#Delete()
  let pos = index(g:Lbookmark_list, getline('.'))
  if pos >= 0
    call remove(g:Lbookmark_list, pos)
  endif
  setlocal modifiable
  delete
  setlocal nomodifiable
  call Lbookmark#Save()
endfunction

function! Lbookmark#Rename()
  let pos = index(g:Lbookmark_list, getline('.'))
  if pos != -1
    let name = input('Input bookmark name:', split(g:Lbookmark_list[pos][0:31], ' ')[0])
    let g:Lbookmark_list[pos] = printf('%-32s', name).g:Lbookmark_list[pos][32:]
  endif
  let cl = line('.')
  let cc = col('.')
  call Lbookmark#Update()
  call cursor(cl,cc)
  call Lbookmark#Save()
endfunction

function! Lbookmark#Sort()
  let g:Lbookmark_sort = !g:Lbookmark_sort
  call Lbookmark#Update()
endfunction

function! Lbookmark#Load()
  if filereadable(g:Lbookmark_file)
    let g:Lbookmark_list = readfile(g:Lbookmark_file)
  endif
endfunction

function! Lbookmark#Save()
  call writefile(g:Lbookmark_list, g:Lbookmark_file)
endfunction

let g:Lbookmark_loaded = 1
