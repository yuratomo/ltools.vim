let g:Lcore_refine_word = ''
let s:Lcore_refine_prefix_len = len(g:Lcore_refine_prefix)
let s:Lcore_last_line = -1
let s:Lcore_cur_plugin = {}
let s:init = 0

if !exists("g:Lplugins_list")
  let g:Lplugins_list = []
endif

function! Lcore#initPlugin(title)
  let plugin = {
    \ 'title'   : a:title,
    \ 'items'   : [],
    \ 'is_sort' : 0,
    \ 'init'    : 0,
    \ }
  call add(g:Lplugins_list, plugin)
  return plugin
endfunction

function! s:prepare()
  nnoremap <buffer> <TAB>   :<c-u>call  Lcore#nextPlugin(0)<CR>
  nnoremap <buffer> <S-TAB> :<c-u>call  Lcore#nextPlugin(1)<CR>
  nnoremap <buffer> <S-CR>  :<c-u>call  Lcore#open()<CR>
  nnoremap <buffer> <CR>    :<c-u>call  Lcore#open()<CR>:call Lcore#close()<CR>
  nnoremap <buffer> J       j:<c-u>call Lcore#open()<CR>
  nnoremap <buffer> K       k:<c-u>call Lcore#open()<CR>
  nnoremap <buffer> u       :<c-u>call  Lcore#update()<CR>
  nnoremap <buffer> s       :<c-u>call  Lcore#sort()<CR>
  nnoremap <buffer> D       :<c-u>call  Lcore#delete()<CR>
  nnoremap <buffer> i       :<c-u>call  Lcore#EnterRefineMode()<CR>
  nnoremap <buffer> I       :<c-u>call  Lcore#EnterRefineMode()<CR>
  inoremap <buffer> <CR>    <ESC>:<c-u>call Lcore#UpdateRefineWord()<CR><ESC>0
  inoremap <buffer> <TAB>   <ESC>:<c-u>call Lcore#UpdateRefineWord()<CR>
  inoremap <buffer> <SPACE> <SPACE><ESC>:<c-u>call Lcore#UpdateRefineWord()<CR>
  inoremap <buffer> <BS>    <BS><ESC>:<c-u>call Lcore#UpdateRefineWord()<CR>
  setlocal bt=nofile noswf cursorline nowrap hidden
endfunction

function! Lcore#init()
  if s:init == 0
    let s:init = 1
    for pname in g:Lcore_plugins
      call {pname}#init()
    endfor
  endif
endfunction

function! Lcore#show(plugin, param)
  call Lcore#init()
  let s:Lcore_cur_plugin = a:plugin
  let g:Lcore_refine_word = a:param
  call Lcore#close()
  exe 'topleft new ' . printf(g:Lcore_title_format, a:plugin.title)
  exe 'res ' . g:Lcore_line_num
  call Lcore#update()
  call s:hilightTitle()
endfunction

function! Lcore#update()
  if exists('s:Lcore_cur_plugin.preproc')
    call s:Lcore_cur_plugin.preproc()
  endif

  let list = s:Lcore_cur_plugin.list()
  if g:Lcore_refine_word != ''
    call filter(list, "Lcore#refine_filter(v:val)")
  endif

  let header = '[[ '
  for plugin in g:Lplugins_list
    let header = header . ' ' . plugin.title
  endfor
  let header = header . ' ]]'

  setlocal modifiable
  call s:clear()
  call setline(1, header)
  call setline(2, g:Lcore_refine_prefix . g:Lcore_refine_word)
  call setline(3, list)
  setlocal nomodifiable

  call s:moveToTop()
  call s:prepare()

  if exists('s:Lcore_cur_plugin.postproc')
    call s:Lcore_cur_plugin.postproc()
  endif
endfunction

function! Lcore#open()
  if line('.') == 1
    return
  endif
  let line = getline('.')
  call s:Lcore_cur_plugin.open(line)
  if s:Lcore_last_line != line
    let s:Lcore_last_line = line
    wincmd p
  else
    call Lcore#close()
  endif
endfunction

function! Lcore#close()
  for plugin in g:Lplugins_list
    let bname = printf(g:Lcore_title_format, plugin.title)
    if bufexists(bname)
      try
        exe ':bd ' . bufnr(bname)
      catch /.*/
      endtry
    endif
  endfor
  call clearmatches()
  let g:Lcore_refine_word = ''
endfunction

function! Lcore#sort()
  let s:Lcore_cur_plugin.is_sort = !s:Lcore_cur_plugin.is_sort
  call Lcore#update()
endfunction

function! Lcore#delete()
  if line('.') == 1
    return
  endif
  let line = getline('.')
  call s:Lcore_cur_plugin.delete(line)
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
  call s:moveToTop()
  stopi
endfunction

function! Lcore#UpdateRefineWord()
  let title = getline(2)
  let last_word = g:Lcore_refine_word
  let g:Lcore_refine_word = title[ s:Lcore_refine_prefix_len : ]
  if last_word != g:Lcore_refine_word
    call Lcore#update()
  endif
  call Lcore#EnterRefineMode()
endfunction

function! s:clear()
  exe '%s/^.*$\n'
endfunction

function! s:moveToTop()
  call cursor(3,1)
endfunction

function! Lcore#nextPlugin(direct)
  let idx = index(g:Lplugins_list, s:Lcore_cur_plugin)
  if idx == -1
    return
  endif
  let idx = s:nextIndex(a:direct, idx)
  let s:Lcore_cur_plugin = g:Lplugins_list[idx]
  let s:Lcore_last_line = -1
  call Lcore#update()
  call s:hilightTitle()
endfunction

function! s:nextIndex(direct, idx)
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

function! s:hilightTitle()
  for plugin in g:Lplugins_list
    if plugin == s:Lcore_cur_plugin 
      exe 'syn keyword Lcore' . plugin.title . ' ' . plugin.title
      exe 'hi link Lcore' . plugin.title . ' Function'
    else
      exe 'hi link Lcore' . plugin.title . ' NONE'
    endif
  endfor
endfunction

