" FILE: Lmru.vim
" AUTHOR:  yuratomo
" Last Modified: 31 Jan 2012.
" Version: 0.0.1

if exists('g:Lmru_loaded') && g:Lmru_loaded == 1
  finish
endif
if !exists('g:Lcore_loaded') || g:Lcore_loaded == 0
  runtime plugin/Lcore.vim
endif

let g:Lmru_title = Lcore#RegistPlugin('Lmru')
if !exists("g:Lmru_max_count")
  let g:Lmru_max_count = 100
endif
if !exists("g:Lmru_file")
  let g:Lmru_file = $home.'\\.vim_mru'
endif
let g:Lmru_list = []
let g:Lmru_sort = 0
let g:Lmru_initialize = 0

command! -nargs=? Lmru :call Lmru#Show(<f-args>)

augroup Lmru
  autocmd!
  autocmd VimEnter * call Lmru#Load()
  autocmd VimLeave * call Lmru#Save()
  autocmd BufRead  * call Lmru#Regist()
  autocmd BufWritePost * call Lmru#Regist()
augroup END

function! Lmru#Show(...)
  call Lcore#Close()
  if exists("a:1")
    let g:Lcore_refine_word = a:1
  endif
  exe ':topleft new '.g:Lmru_title
  exe ':res '.g:Lcore_line_num
  call Lmru#Update()
  call Lcore#HilightTitle()
  syn match mruDirHilight /^.*\\/
  syn match mruExtHilight       /\.\w*$/
  call Lcore#CommonSetting()
endfunction

function! Lmru#Update()
  setlocal modifiable
  if g:Lmru_sort == 1
    let list = sort(copy(g:Lmru_list))
  else
    let list = copy(g:Lmru_list)
  endif
  call Lcore#Refine(list)
  call Lcore#Clear()
  call Lcore#Show(list)
  call Lcore#SetCursorTop()
  setlocal nomodifiable
endfunction

function! Lmru#Regist()
  call Lmru#Load()
  let line = expand('%:p')
  let pos = index(g:Lmru_list, line)
  if pos >= 0
    call remove(g:Lmru_list, pos)
  elseif len(g:Lmru_list) >= g:Lmru_max_count
    call remove(g:Lmru_list, len(g:Lmru_list)-1)
  endif
  call insert(g:Lmru_list, line, 0)
  call Lmru#Save()
endfunction

function! Lmru#Open(line)
  wincmd p
  exe ':e '.a:line
endfunction

function! Lmru#Delete()
  let pos = index(g:Lmru_list, getline('.'))
  if pos >= 0
    call remove(g:Lmru_list, pos)
  endif
  setl modifiable
  delete
  setl nomodifiable
endfunction

function! Lmru#Sort()
  let g:Lmru_sort = !g:Lmru_sort
  call Lmru#Update()
endfunction

function! Lmru#Load()
  if g:Lmru_initialize == 0
    let g:Lmru_initialize = 1
  endif
  if filereadable(g:Lmru_file)
    let g:Lmru_list = filter(readfile(g:Lmru_file), "v:val != ''")
  endif
  hi link mruDirHilight Statement
  hi link mruExtHilight Comment
endfunction

function! Lmru#Save()
  call writefile(g:Lmru_list, g:Lmru_file)
endfunction

let g:Lmru_loaded = 1
