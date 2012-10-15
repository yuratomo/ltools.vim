let s:plugin = Lcore#initPlugin('Ltaglist')
let s:Ltaglist_keyword = ''
let g:Ltaglist_update = 0

function! Ltaglist#init()
endfunction

function! Ltaglist#do(...)
  if exists('a:1')
    if a:1 != ''
      let g:Ltaglist_update = 1
      let s:Ltaglist_keyword = a:1
    endif
  else
    let g:Ltaglist_update = 1
    let s:Ltaglist_keyword = expand('<cword>')
  endif
  call Lcore#show(s:plugin, '')
endfunction

function! s:plugin.postproc()
  setf Ltaglist
endfunction

function! s:plugin.list()
  if g:Ltaglist_update == 0 && exists('s:Ltaglist_list')
    return s:Ltaglist_list
  endif

  let g:Ltaglist_pwd  = expand('%:p:h')
  let s:Ltaglist_list = []
  let first = 1
  for item in taglist(s:Ltaglist_keyword)
    let line = ''
    if exists('item.typeref')
      let typedef = item.typeref . ' '
    else
      let typedef = ''
    endif
    let line .= join( [ item.kind, typedef . item.name, item.filename, item.cmd ], '|')
    call add(s:Ltaglist_list, line)
  endfor
  let g:Ltaglist_update = 0
  return s:Ltaglist_list
endfunction

function! s:plugin.open(line)
  let parts = split(a:line, '|')
  wincmd p
  try
    exe 'cd ' . g:Ltaglist_pwd
    exe ':e +' . parts[3] . ' ' . parts[2]
    redraw
    normal zz
    call clearmatches()
    call matchadd('LcoreSelect', '\%' . parts[3] . 'l')
  catch /.*/
  endtry
endfunction

