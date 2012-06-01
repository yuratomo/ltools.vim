" FILE: Lcore.vim
" AUTHOR:  yuratomo
" Last Modified: 31 Jan 2012.
" Version: 0.0.1

if exists('g:Lcore_loaded') && g:Lcore_loaded == 1
  finish
endif

let g:Lcore_title_format = "-- %s --"
let g:Lcore_refine_word = ''
let g:Lcore_refine_prefix = 'refine='
let g:Lcore_refine_prefix_len = len(g:Lcore_refine_prefix)
let g:Lcore_last_line = -1

if !exists('g:Lcore_line_num')
  let g:Lcore_line_num = 20
endif

if !exists("g:Lplugins_list")
  let g:Lplugins_list = []
endif

command! -nargs=0 Lclose :call Lcore#Close()

function! Lcore#RegistPlugin(prefix)
  call add(g:Lplugins_list, a:prefix)
  return printf(g:Lcore_title_format, a:prefix)
endfunction

function! Lcore#CommonSetting()
  nnoremap <buffer> <TAB>   :call  Lcore#NextPlugin(0)<CR>
  nnoremap <buffer> <S-TAB> :call  Lcore#NextPlugin(1)<CR>
  nnoremap <buffer> <S-CR>  :call  Lcore#Open()<CR>:call Lcore#Close()<CR>
  nnoremap <buffer> <CR>    :call  Lcore#Open()<CR>:call Lcore#Close()<CR>
  nnoremap <buffer> o       :call  Lcore#Open()<CR>
  nnoremap <buffer> J       j:call Lcore#Open()<CR>
  nnoremap <buffer> K       k:call Lcore#Open()<CR>
  nnoremap <buffer> u       :call  Lcore#CallFunction('Show','')<CR>
  nnoremap <buffer> s       :call  Lcore#CallFunction('Sort','')<CR>
  nnoremap <buffer> D       :call  Lcore#CallFunction('Delete','')<CR>
  nnoremap <buffer> q       :call  Lcore#Close()<CR>
  nnoremap <buffer> i       :call  Lcore#EnterRefineMode()<CR>
  nnoremap <buffer> I       :call  Lcore#EnterRefineMode()<CR>
  inoremap <buffer> <CR>    <ESC>:call  Lcore#UpdateRefineWord()<CR><ESC>0
  inoremap <buffer> <TAB>   <ESC>:call  Lcore#UpdateRefineWord()<CR>
  inoremap <buffer> <SPACE> <SPACE><ESC>:call  Lcore#UpdateRefineWord()<CR>
  inoremap <buffer> <BS>    <BS><ESC>:call  Lcore#UpdateRefineWord()<CR>
  setlocal bt=nofile noswf cursorline nowrap hidden
endfunction

function! Lcore#NextPlugin(direct)
  let idx = 0
  for plugin in g:Lplugins_list
    let bname = printf(g:Lcore_title_format, plugin)
    if bname == bufname('%')
      break
    endif
    let idx = idx + 1
  endfor
  let idx = s:NextIndex(a:direct, idx)

  let success = 0
  while success == 0
    exe 'silent call 'g:Lplugins_list[idx].'#Show()'
    let bname = printf(g:Lcore_title_format, g:Lplugins_list[idx])
    if bname == bufname('%')
      break
    endif
    let idx = s:NextIndex(a:direct, idx)
  endwhile
  let g:Lcore_last_line = -1
endfunction

function! Lcore#HilightTitle()
  for plugin in g:Lplugins_list
    let bname = printf(g:Lcore_title_format, plugin)
    if bname == bufname('%')
      exe 'syn keyword Lcore'.plugin.' '.plugin
      exe 'hi def link Lcore'.plugin.' Function'
      break
    else
      exe 'hi clear Lcore'.plugin
    endif
  endfor
endfunction

function! Lcore#SetCursorTop()
  call cursor(3,1)
endfunction

function! s:NextIndex(direct, idx)
  let idx = a:idx
  if a:direct == 0
    let idx = idx + 1
  else 
    let idx = idx - 1
  endif
  if idx < 0
    let idx = len(g:Lplugins_list) - 1
  endif
  if idx >= len(g:Lplugins_list)
    let idx = 0
  endif
  return idx
endfunction

function! Lcore#CallFunction(func_name, param)
  for plugin in g:Lplugins_list
    let bname = printf(g:Lcore_title_format, plugin)
    if bname == bufname('%')
      let param = ''
      if a:param != ''
        let param = "'".substitute(a:param, "'", " ", "g")."'"
      endif
      exe 'silent call '.plugin.'#'.a:func_name.'('.param.')'
      break
    endif
  endfor
endfunction

function! Lcore#Open()
  if line('.') == 1
    return
  endif
  let line = getline('.')
  call Lcore#CallFunction('Open', line)
  if g:Lcore_last_line != line
    let g:Lcore_last_line = line
    wincmd p
  else
    call Lcore#Close()
  endif
endfunction

function! Lcore#refine_filter(line)
  let words = split(g:Lcore_refine_word, ' ')
  for word in words
    if match(a:line, word) < 0
      return 0
    endif
  endfor
  return 1
endfunction

function! Lcore#Refine(lines)
  if g:Lcore_refine_word == ''
    return
  endif
  call filter(a:lines, "Lcore#refine_filter(v:val)")
endfunction

function! Lcore#Show(list)
  let title = '[[ '.join(g:Lplugins_list, ' ').' ]]'
  call setline(1, title)
  call setline(2, g:Lcore_refine_prefix.g:Lcore_refine_word)
  call setline(3, a:list)
endfunction

function! Lcore#Clear()
  exe '%s/^.*$\n'
endfunction

function! Lcore#Close()
  for plugin in g:Lplugins_list
    let bname = printf(g:Lcore_title_format, plugin)
    if bufexists(bname)
      try
        exe ':bd '.bufnr(bname)
      catch /.*/
      endtry
    endif
  endfor
  let g:Lcore_refine_word = ''
endfunction

function! Lcore#EnterRefineMode()
  call cursor(2,1)
  setl modifiable
  au! InsertLeave * call Lcore#LeaveRefineMode()
  start!
endfunction

function! Lcore#LeaveRefineMode()
  call Lcore#UpdateRefineWord()
  setl nomodifiable
  au! InsertLeave *
  call Lcore#SetCursorTop()
  stopi
endfunction

function! Lcore#UpdateRefineWord()
  let title = getline(2)
  let last_word = g:Lcore_refine_word
  exe 'let g:Lcore_refine_word = title['.g:Lcore_refine_prefix_len.':]'
  if last_word != g:Lcore_refine_word
    call Lcore#CallFunction('Update', '')
  endif
  call Lcore#EnterRefineMode()
endfunction

let g:Lcore_loaded = 1
