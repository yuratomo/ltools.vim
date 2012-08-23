let g:Ltselect_list = []

let s:plugin = Lcore#initPlugin('Ltselect')
function! Ltselect#init()
endfunction

function! Ltselect#do()
  call Lcore#show(s:plugin, join(a:000, ' '))
endfunction

function! s:plugin.preproc()
  setf cpp
endfunction

function! s:plugin.list()
  try
    redir => bufoutput
      silent tselect!
    redir END
  catch /.*/
    redir END
  endtry
  let g:Ltselect_list = split(substitute(bufoutput, '>', ' ', 'g'), '\n')[1:-2]
  return g:Ltselect_list
endfunction

function! s:plugin.open(line)
  let cl = line('.')
  for l in reverse(range(1, cl))
    let l = getline(cl)
    if l =~ '^ \{1,2\}\d'
      wincmd p
      let trnum = split(l, ' \+')[0]
      exe trnum . 'tr'
      break
    endif
  endfor
endfunction

