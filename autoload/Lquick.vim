let s:plugin = Lcore#initPlugin('Lquick')
let g:Lquick_update = 0

function! Lquick#init()
  augroup Lquick
    au!
    au QuickFixCmdPost * call Lquick#update()
  augroup END
  if !hlexists('LquickSelect')
    hi LquickSelect  guibg=NONE guifg=NONE gui=BOLD,Underline
  endif
endfunction
call Lquick#init()

function! Lquick#update()
  let g:Lquick_update = 1
endfunction

function! Lquick#do(...)
  call Lcore#show(s:plugin, join(a:000, ' '))
endfunction

function! s:plugin.postproc()
  if exists('g:Lquick_ext')
    exe 'setf ' . g:Lquick_ext
  endif
endfunction

function! s:plugin.list()
  if g:Lquick_update == 0 && exists('s:Lquick_list')
    return s:Lquick_list
  endif

  let g:Lquick_pwd  = expand('%:p:h')
  let s:Lquick_list = []
  let first = 1
  let qflist = getqflist()
  for item in qflist
    call add(s:Lquick_list, bufname(item.bufnr).'|'.item.lnum.'|'.item.text)
    if first == 1
      let first = 0
      let name = bufname(item.bufnr)
      let g:Lquick_ext = name[strridx(name,".")+1:]
    endif
  endfor

  let g:Lquick_update = 0
  return s:Lquick_list
endfunction

function! s:plugin.open(line)
  let parts = split(a:line, '|')
  wincmd p
  if g:Lquick_pwd != expand('%:p:h')
    exe 'cd '.g:Lquick_pwd
  endif
  exe ':e +'.parts[1].' '.parts[0]
  normal zz
  call clearmatches()
  call matchadd('LquickSelect', '\%' . parts[1] . 'l')
endfunction

