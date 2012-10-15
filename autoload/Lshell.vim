let g:Lshell#title_prefix = 'Lshell'

function! Lshell#open(...)
  if exists('b:shell')
    call Lshell#close()
  endif

  if !exists('g:loaded_vimproc')
    echoerr "Lshell.vim is depend on vimproc. Please install it."
    return
  endif

  call Lshell#focusIn()

  let b:shell = {
    \ 'prompt'      : '>',
    \ 'lnum'        : 1,
    \ 'line'        : '',
    \ 'engine'      : {},
    \ 'pipe'        : {},
    \ }

  call Lshell#popen('cmd', [])
  call Lshell#insert()

  call s:default_keymap()
endfunction

function! Lshell#popen(cmd, params)
  if exists('b:shell.pipe')
    unlet b:shell.pipe
  endif

  if !executable(a:cmd)
    echoerr 'command not exists. (' . a:cmd . ')'
  endif

  let cmd_params = []
  call add(cmd_params, a:cmd)
  call extend(cmd_params, a:params)

  let b:shell.pipe = vimproc#popen3(cmd_params)
  call Lshell#read(1)
  if b:shell.pipe.stdout.eof
    let lines = split(b:shell.line, "\n")
    call setline(b:shell.lnum, lines)
    let b:shell.line = ''
    call cursor('$',0)
    return
  endif
endfunction

function! Lshell#close()
  if !exists('b:shell')
    return
  endif
  try
    call b:shell.engine.close()
    call b:shell.close()
  catch /.*/
  endtry
  unlet b:shell.engine
  unlet b:shell.pipe
  unlet b:shell
  sign unplace *
endfunction

function! Lshell#command()
  if !exists('b:shell.engine')
    return
  endif
  call s:command()
endfunction

function! Lshell#focusIn()
  if !exists('b:shell.engine')
    return
  endif

  let b:shell.old_winnum = winnr()
  let winnum = winnr('$')
  for winno in range(1, winnum)
    let bufname = bufname(winbufnr(winno))
    if bufname =~ g:Lshell#title_prefix
       exe winno . "wincmd w"
       return
    endif
  endfor

  " if not exist Lshell window, then create new window.
  let id = 1
  while buflisted(g:Lshell#title_prefix.id)
    let id += 1
  endwhile
  let bufname = g:Lshell#title_prefix.id
  new
  silent edit `=bufname`
  setlocal bt=nofile noswf nowrap hidden nolist

  augroup Lshell
    au!
    exe 'au BufDelete <buffer> call Lshell#close()'
  augroup END

endfunction

function! s:command()
  let line = getline('$')
  let last = matchend(line, b:shell.prompt)
  if last != -1
    call Lshell#write(2, line[ last : ])
    call Lshell#read(1)
    if b:shell.pipe.stdout.eof
      let lines = split(b:shell.line, "\n")
      call setline(b:shell.lnum, lines)
      let b:shell.line = ''
      return
    endif
  endif
  call Lshell#insert()
  retur ''
endfunction

function! Lshell#insert()
  inoremap <buffer><CR> <ESC>:stopi<CR>:call Lshell#command()<CR>
  inoremap <expr> <buffer> <TAB> Lshell#tab()
  inoremap <expr> <buffer> <S-TAB> Lshell#stab()
  call cursor('$',0)
  start!
endfunction

function! Lshell#read(output)
  while !b:shell.pipe.stdout.eof
    let res = b:shell.pipe.stdout.read()
    if res == ''
      let midx = matchend(b:shell.line, b:shell.prompt . '$')
      let lines = split(b:shell.line, "\n")

      if a:output == 1
        call setline(b:shell.lnum, lines)
        call cursor('$',0)
        let b:shell.lnum = b:shell.lnum + len(lines)
      endif
      redraw
      if midx != -1
        let b:shell.line = b:shell.line[ midx : ]
        if b:shell.line == ''
          break
        endif
      else
        let b:shell.line = ''
        sleep 10ms
      endif
      continue
    else
      let b:shell.line .= substitute(res, '\r', '', 'g')
    endif
  endwhile
endfunction

function! Lshell#write(output, cmd)
  let cmd = a:cmd
  call b:shell.pipe.stdin.write(cmd . "\n")
  if a:output == 1
    call setline(b:shell.lnum-1, getline('$') . cmd)
    call cursor('$',0)
  endif
  return ''
endfunction

function! Lshell#control(n)
  call Lshell#write(2, nr2char(a:n))
  call Lshell#read(1)
  retur ''
endfunction

function! Lshell#tab()
  call feedkeys("\<c-n>", 'n')
  retur ''
endfunction

function! Lshell#stab()
  call feedkeys("\<c-p>", 'n')
  retur ''
endfunction

function! s:default_keymap()
endfunction

