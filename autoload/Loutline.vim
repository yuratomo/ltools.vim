let s:plugin = Lcore#initPlugin('Loutline')
function! Loutline#init()
  let g:Loutline_last_file = ''
endfunction

function! Loutline#do()
  call Lcore#show(s:plugin, join(a:000, ' '))
endfunction

function! s:plugin.preproc()
  wincmd p
  let g:Loutline_ext   = expand('%:e')
  let g:Loutline_file  = expand('%:p')
  let g:Loutline_cline = line('.')
  wincmd p
  exe 'setl ft=' . g:Loutline_ext
endfunction

function! s:plugin.postproc()
  if exists('g:Loutline_first_pos')
    call cursor(g:Loutline_first_pos, 0)
  endif
endfunction

function! s:plugin.list()
  if !has_key(g:Loutline_mapping, g:Loutline_ext) || !exists('g:Loutline_file')
    return []
  endif

  let g:Loutline_first_pos = 2
  let idx = 2
  if g:Loutline_last_file == g:Loutline_file
    for item in s:plugin.items
      let idx = idx + 1
      let l = split(item, ' ')[0]
      if g:Loutline_cline > l
        let g:Loutline_first_pos = idx
      else
        break
      endif
    endfor
    return s:plugin.items
  endif
  let g:Loutline_last_file = g:Loutline_file

  let s:plugin.items = []
  let total = 1
  let lines = readfile(g:Loutline_file)
  for line in lines
    if match(line, g:Loutline_mapping[g:Loutline_ext]) >= 0
      call add(s:plugin.items, printf("%6d", total) . ' ' . line)
      let idx = idx + 1
      if g:Loutline_cline > total
        let g:Loutline_first_pos = idx
      endif
    endif
    let total = total + 1
  endfor
  return s:plugin.items
endfunction

function! s:plugin.open(line)
  wincmd p
  if expand('%:p') != g:Loutline_last_file
    exe ':e +' . split(a:line, ' ')[0] . ' ' . g:Loutline_last_file
  endif
  normal zt
endfunction

function! s:plugin.delete(line)
endfunction

let g:Loutline_loaded = 1
