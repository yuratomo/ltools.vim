let s:Lfiler_title = 'Lfiler'
let b:Lfiler_pwd = ''
let s:Lfiler_dir_lines = []
let s:Lfiler_file_mark_row     = 35
let s:Lfiler_dir_file_row      = 36
let s:Lfiler_dir_filetype_row  = 21
let s:Lfiler_dir_filetype_erow = 25
let s:Lfiler_dir_end_index     = 0
let s:Lfiler_refine_prefix = 'refine'
let s:Lfiler_refine_word = ''

let s:Lfiler_sort = {
  \ 'title'       : '',
  \ 'prefix'      : 'sort',
  \ 'options'     : [ 'N', 'S', 'D', 'E', 'R' ],
  \ 'option_len'  : 0,
  \ 'option_max'  : 4,
  \ 'option_name' : [ 'name', 'size', 'date', 'extension', 'reverse' ],
  \ 'current'     : 0,
  \ }
let s:Lfiler_confirm = {
  \ 'delete' : 'Delete selected files? [y/n]:',
  \ 'find'   : 'Please input file pattern?:',
  \ 'paste'  : 'Paste yanked-files to current directory? [y/n]:',
  \ 'move'   : 'Move yanked-files to current directory? [y/n]:',
  \ 'jump'   : 'cd ',
  \ }
let s:Lfiler_yank = {
  \ 'title'       : '<< yanked files >>',
  \ 'start_index' : 0,
  \ 'mark_row'    : 2,
  \ 'mode'        : 1,
  \ 'fold'        : 0,
  \ }
let s:Lfiler_find = {
  \ 'title'       : '<< find files >>',
  \ 'start_index' : 0,
  \ 'mark_row'    : 2,
  \ 'mode'        : 4,
  \ 'fold'        : 0,
  \}
let s:Lfiler_bookmark = {
  \ 'title'       : '<< bookmark files >>',
  \ 'start_index' : 0,
  \ 'mark_row'    : 2,
  \ 'mode'        : 2,
  \ 'fold'        : 0,
  \ }

function! Lfiler#do(...)
  if exists('a:2') && !isdirectory(a:2)
    exe ':cd '. b:Lfiler_pwd
    return
  endif

  let id = 1
  while buflisted(s:Lfiler_title.'-'.id)
    let id += 1
  endwhile
  let bufname = s:Lfiler_title.'-'.id
  if a:1 == 1
    silent edit `=bufname`
  else
    silent sp `=bufname`
  endif
  setlocal bt=nofile noswf cursorline nomodifiable nowrap hidden

  if exists('a:2')
    if a:2[0] == '\'
      exe ':cd '.substitute(a:2, '\\','\\\\','g')
    else
      exe ':cd '.a:2
    endif
  endif

  augroup LFiler
    au BufLeave <buffer> silent! call Lfiler#BufLeave()
  augroup END

  call Lfiler#Update(0,1)
  call Lfiler#KeyMapping()
  setf Lfiler
endfunction

function! Lfiler#BufLeave()
  let b:Lfiler_pwd = s:getCurDir()
endfunction

function! Lfiler#KeyMapping()
  nnoremap <buffer> <CR>      :call Lfiler#Open(0)<CR>
  nnoremap <buffer> <S-CR>    :call Lfiler#Open(1)<CR>
  nnoremap <buffer> <space>   :call Lfiler#Mark(1)<CR>
  vnoremap <buffer> <space>   :call Lfiler#Mark(1)<CR>
  nnoremap <buffer> <s-space> :call Lfiler#Mark(-1)<CR>
  nnoremap <buffer> a         :call Lfiler#ToggleMarkAllItem()<CR>
  nnoremap <buffer> b         :call Lfiler#RegstBookmark()<CR>
  nnoremap <buffer> B         :call Lfiler#MoveToDirBottom()<CR>
  nnoremap <buffer> C         :call Lfiler#CreateFolder()<CR>
  nnoremap <buffer> D         :call Lfiler#DeleteFile()<CR>
  nnoremap <buffer> f         :call Lfiler#FindFile()<CR>
  nnoremap <buffer> F         :call Lfiler#DiffFile()<CR>
  nnoremap <buffer> i         :call Lfiler#EnterRefineMode()<CR>
  nnoremap <buffer> J         :call Lfiler#Jump()<CR>
  nnoremap <buffer> p         :call Lfiler#PasteFile(0)<CR>
  nnoremap <buffer> P         :call Lfiler#PasteFile(1)<CR>
  nnoremap <buffer> q         :call Lfiler#Close()<CR>
  nnoremap <buffer> r         :call Lfiler#Rename()<CR>
  nnoremap <buffer> s         :call Lfiler#ChangeSortMode()<CR>
  nnoremap <buffer> t         :call Lfiler#Open(2)<CR>
  nnoremap <buffer> T         :call Lfiler#MoveToDirTop()<CR>
  nnoremap <buffer> u         :call Lfiler#Update(1,1)<CR>
  nnoremap <buffer> x         :call Lfiler#Execute()<CR>
  nnoremap <buffer> y         :call Lfiler#YankFile()<CR>
  nnoremap <buffer> <BS>      :call Lfiler#Upper()<CR>
  nnoremap <buffer> <F1>      :call Lfiler#Help()<CR>
  inoremap <buffer> <tab>     <ESC>:call Lfiler#UpdateRefineWord()<CR>
  inoremap <buffer> <CR>      <ESC>:call Lfiler#UpdateRefineWord()<CR><ESC>j
  inoremap <buffer> <space>   <space><ESC>:call Lfiler#UpdateRefineWord()<CR>
endfunction

function! Lfiler#Help()
  echo '---------------------- HLEP ---------------------------'
  echo '<CR>    open cursor-file'
  echo '<S-CR>  open cursor-file at split window'
  echo '<space> mark file under the cursor'
  echo 'a       toggle selection of all items'
  echo 'b       regist bookmark'
  echo 'B       move to bottom of file list'
  echo 'C       create folder'
  echo 'D       delete file and list and bookmark'
  echo 'f       find file'
  echo 'F       diff yanked-file'
  echo 'i       enter refine mode'
  echo 'J       change directory (jump)'
  echo 'p       paste yanked-files to current directory'
  echo 'P       move yanked-files to current directory'
  echo 'q       exit'
  echo 'r       rename cursor-file'
  echo 's       change sort mode'
  echo 't       open cursor-file at new tab'
  echo 'T       move to top of file list'
  echo 'u       update list'
  echo 'x       execute cursor-file'
  echo 'y       yank marked-files'
  echo '<BS>    move upper directory'
  echo ''
endfunction

function! Lfiler#Update(holdcur, issue_cmd)
  if a:holdcur == 1
    let cl = line('.')
    let cc = col('.')
  endif
  setlocal modifiable

  let pwd = s:getCurDir()
  % delete _
  let opt = s:getSortOptionParam()
  if pwd[0:1] == '\\' "for unc
    let opt = ' '.pwd
  endif
  if a:issue_cmd == 1 || empty(s:Lfiler_dir_lines)
    let s:Lfiler_dir_lines = split(system('dir '.opt), '\n')
  endif
  let ww = winwidth(0)
  call setline(1, printf('%-' . ww . 's', s:Lfiler_dir_lines[3][1:] . ' [F1: help]') . ".")
  call setline(2, s:Lfiler_sort.title.s:Lfiler_refine_word)
  let dirline = []
  if s:getFileName(s:Lfiler_dir_lines[5]) == '.'
    let dirline = s:Lfiler_dir_lines[6:]
  else
    let dirline = s:Lfiler_dir_lines[5:]
  endif
  if s:Lfiler_refine_word != ''
    call filter(dirline, "s:refine_filter(v:val)")
  endif
  call setline(3, dirline)
  let curpos = 3+len(dirline)
  let s:Lfiler_dir_end_index = curpos - 3

  let curpos = s:appendList(curpos, s:Lfiler_yank)
  let curpos = s:appendList(curpos, s:Lfiler_bookmark)
  let curpos = s:appendList(curpos, s:Lfiler_find)

  if a:holdcur == 0
    call cursor(3,37)
  else
    call cursor(cl,cc)
  endif
  setlocal nomodifiable
endfunction

function! Lfiler#Open(mode)
  let line = getline('.')
  if !s:isAvailableLine(line)
    if line[s:Lfiler_dir_file_row : ] == '..'
      call  Lfiler#Upper()
    endif
    return
  endif
  let pwd  = s:getCurDir()
  let dir  = s:getDirType(line)
  let item = s:getFileName(line)
  if a:mode == 2
    tabedit `=item`
    tabp
    return
  endif
  if dir == '<DIR>' || dir == '<SYML'
    exe ':cd '.pwd.item
    call Lfiler#Update(0,1)
  else
    if a:mode == 0
      let bn = bufnr('%')
      edit `=item`
      exec ':silent bd '.bn
    elseif a:mode == 1
      rightbelow new `=item`
    endif
  endif
endfunction

function! Lfiler#Close()
  silent bd
endfunction

function! Lfiler#Mark(direct) range
  call s:markItem(a:firstline, a:lastline, s:getMarkRow(a:firstline))
  call cursor(line('.')+a:direct,col('.'))
endfunction

function! Lfiler#ToggleMarkAllItem()
  let [start, end, midx, mode] = s:getListInfoUnderCursor()
  call s:markItem(start, end, midx)
endfunction

function! Lfiler#YankFile()
  let pwd = s:getCurDir()
  let [ files, mode ] = s:getSelectedFiles()
  if !exists("s:Lfiler_yank.files")
    let s:Lfiler_yank.files = []
  endif
  for file in files
    if file[1:2] == ':\'
      let fpath = file
    else
      let fpath = pwd.file
    endif
    if index(s:Lfiler_yank.files, fpath) == -1
      call add(s:Lfiler_yank.files, fpath)
    endif
  endfor
  call Lfiler#Update(1,0)
endfunction

function! Lfiler#DiffFile()
  if len(s:Lfiler_yank.files) > 4
    echo "4個以上のファイルのDIFFは取れません。"
    return
  endif
  let bn = bufwinnr('%')
  exec ':diffoff!'
  for file in s:Lfiler_yank.files
    exec 'rightbelow vsp '.file
    diffthis
  endfor
  exec ':'.bn.'wincmd w'
  exec ':silent bd'
endfunction

function! Lfiler#PasteFile(mode)
  if a:mode == 0
    let ans = s:quest(s:Lfiler_confirm.paste, '', '[yn]')
  else
    let ans = s:quest(s:Lfiler_confirm.move, '', '[yn]')
  endif
  if ans != 'y'
    return
  endif

  for file in s:Lfiler_yank.files
    if a:mode == 1
      let cmd = 'move /Y'
      let dest_append = ''
    elseif isdirectory(file)
      let cmd = 'xcopy /E /I /F /H /Y'
      let s = strridx(file, "\\")
      exe 'let dest_append = file[s+1:]'
    else
      let cmd = 'copy /Y'
      let dest_append = ''
    endif
    echo system(cmd.' '.shellescape(file).' '.shellescape(s:getCurDir().dest_append))
  endfor
  unlet s:Lfiler_yank.files
  call Lfiler#Update(1,1)
endfunction

function! Lfiler#Rename()
  let line = getline('.')
  if !s:isAvailableLine(line)
    return
  endif
  let item = s:getFileName(line)
  let dest = input('Rename from '.item.' to ...', item, 'file')
  let dest = substitute(dest, '\\ ', ' ', "g")
  echo dest
  if dest == '' || dest == item
    return
  endif
  call rename(item, dest)
  call Lfiler#Update(1,1)
endfunction

function! Lfiler#CreateFolder()
  let dest = input('Create folder name : ', '')
  let dest = substitute(dest, '\\ ', ' ', "g")
  if dest == ''
    return
  endif
  echo system('mkdir '.dest)
  call Lfiler#Update(1,1)
endfunction

function! Lfiler#DeleteFile()
  if line('.') == 2
    let s:Lfiler_refine_word = ''
    call Lfiler#Update(1,0)
    return
  endif
  let [ files, mode ] = s:getSelectedFiles()
  if empty(files)
    return
  endif
  if mode == 0
    echo "[delete items]"
    for file in files
      echo ' - '.file
    endfor
    if s:quest(s:Lfiler_confirm.delete, '', '[yn]') != 'y'
      return
    endif
  endif

  for file in files
    if mode == 0
      let pwd = s:getCurDir()
      if isdirectory(pwd.file)
        echo system('rmdir /S /Q '.shellescape(pwd.file))
      else
        call delete(file)
      endif
      call Lfiler#Update(1,1)
    elseif mode == s:Lfiler_yank.mode
      if exists("s:Lfiler_yank.files")
        call remove(s:Lfiler_yank.files, index(s:Lfiler_yank.files, file))
      endif
    elseif mode == s:Lfiler_bookmark.mode
      if exists("s:Lfiler_bookmark.files")
        call remove(s:Lfiler_bookmark.files, index(s:Lfiler_bookmark.files, file))
      endif
    elseif mode == s:Lfiler_find.mode
      if exists("s:Lfiler_find.files")
        call remove(s:Lfiler_find.files, index(s:Lfiler_find.files, file))
      endif
    endif
  endfor

  if exists("s:Lfiler_yank.files") && empty(s:Lfiler_yank.files)
    unlet s:Lfiler_yank.files
  endif
  if exists("s:Lfiler_find.files") && empty(s:Lfiler_find.files)
    unlet s:Lfiler_find.files
  endif
  if exists("s:Lfiler_bookmark.files") && empty(s:Lfiler_bookmark.files)
    unlet s:Lfiler_bookmark.files
  endif
  if mode == s:Lfiler_bookmark.mode
    call Lfiler#SaveBookmark()
  endif

  call Lfiler#Update(1,0)
endfunction

function! Lfiler#FindFile()
  let ans = s:quest(s:Lfiler_confirm.find, '*', '')
  if ans == ''
    return
  endif
  let s:Lfiler_find.files = split(system('dir /s /b '.ans), '\n')
  call Lfiler#Update(1,0)
endfunction

function! Lfiler#Execute()
  let pwd = s:getCurDir()
  let line = getline('.')
  if !s:isAvailableLine(line)
    return
  endif
  let item = s:getFileName(line)
  exe ':silent ! start '.pwd.item
endfunction

function! Lfiler#ChangeSortMode()
  let s:Lfiler_sort.current += 1
  if s:Lfiler_sort.current >= s:Lfiler_sort.option_max
    let s:Lfiler_sort.current = 0
  endif
  call s:updateSortOptionTitle()
  call Lfiler#Update(1,1)
endfunction

function! Lfiler#Upper()
  cd ..
  call Lfiler#Update(0,1)
endfunction

function! Lfiler#Jump()
  let ans = s:quest(s:Lfiler_confirm.jump, expand('%:p:h'), '')
  if ans == ''
    return
  endif
  cd `=ans`
  call Lfiler#Update(0,1)
endfunction

function! Lfiler#LoadBookmark(list)
  let s:Lfiler_bookmark.files = a:list
endfunction

function! Lfiler#RegstBookmark()
  let pwd = s:getCurDir()
  let [ files, mode ] = s:getSelectedFiles()
  for file in files
    if file[1:2] == ':\'
      let fpath = file
    else
      let fpath = pwd . file
    endif
    call Lbookmark#registBookmark(fpath)
  endfor
  call Lfiler#Update(1,0)
endfunction

function! Lfiler#MoveToDirBottom()
  call cursor(s:Lfiler_dir_end_index, s:Lfiler_dir_file_row+1)
endfunction

function! Lfiler#MoveToDirTop()
  call cursor(3, s:Lfiler_dir_file_row+1)
endfunction

function! Lfiler#EnterRefineMode()
  call cursor(2,1)
  setl modifiable
  au! InsertLeave * call Lfiler#LeaveRefineMode()
  start!
endfunction

function! Lfiler#LeaveRefineMode()
  call Lfiler#UpdateRefineWord()
  setl nomodifiable
  au! InsertLeave *
  stopi
endfunction

function! Lfiler#UpdateRefineWord()
  let line = getline(2)
  let last_word = s:Lfiler_refine_word
  let s:Lfiler_refine_word = line[s:Lfiler_sort.option_len : ]
  if last_word != s:Lfiler_refine_word
    call Lfiler#Update(0,0)
  endif
  call Lfiler#EnterRefineMode()
endfunction

function! s:getListInfoUnderCursor()
  let cl = line('.')
  if cl >= s:Lfiler_find.start_index
    let start = s:Lfiler_find.start_index
    let end = '$'
    let midx = s:Lfiler_find.mark_row
    let mode = s:Lfiler_find.mode
  elseif cl >= s:Lfiler_bookmark.start_index
    let start = s:Lfiler_bookmark.start_index
    let end = s:Lfiler_find.start_index - 1
    let midx = s:Lfiler_bookmark.mark_row
    let mode = s:Lfiler_bookmark.mode
  elseif cl >= s:Lfiler_yank.start_index
    let start = s:Lfiler_yank.start_index
    let end = s:Lfiler_bookmark.start_index -1
    let midx = s:Lfiler_yank.mark_row
    let mode = s:Lfiler_yank.mode
  else 
    let start = 1
    let end = s:Lfiler_yank.start_index
    let midx = s:Lfiler_file_mark_row
    let mode = 0
  endif
  return [start, end, midx, mode]
endfunction

function! s:getSelectedFiles()
  let [start, end, midx, mode] = s:getListInfoUnderCursor()
  let lines = getline(start, end)
  let newlines = []
  let idx = 0
  for line in lines
    if line[midx] == '*'
      call add(newlines, s:getFileName(line))
    endif
    let idx = idx + 1
  endfor
  return [ newlines, mode ]
endfunction

function! s:refine_filter(line)
  if match(a:line, '\.\.') >= 0
    return 1
  endif
  let words = split(s:Lfiler_refine_word, ' ')
  for word in words
    if match(a:line, word) < 0
      return 0
    endif
  endfor
  return 1
endfunction

function! s:getCurDir()
  let pwd  = expand('%:p:h')
  if pwd[strlen(pwd)-1] != '\'
    let pwd = pwd . '\'
  endif
  return pwd
endfunction

function! s:getFileName(line)
  if a:line[0:1] == ' -'
    if a:line[37] == ':'
      return a:line[36:]
    else
      return a:line[3:]
    endif
  endif
  let dir  = s:getDirType(a:line)
  if dir == '<SYML'
    let pos = match(a:line, '\[.*\.*]')
    if pos > 2
      let pos -= 2
    endif
    return a:line[s:Lfiler_dir_file_row : pos]
  endif
  return a:line[s:Lfiler_dir_file_row : ]
endfunction

function! s:getDirType(line)
  return a:line[s:Lfiler_dir_filetype_row : s:Lfiler_dir_filetype_erow]
endfunction

function! s:isAvailableLine(line)
  if match(a:line, '[0-9]\{4\}') == 0
    if a:line[s:Lfiler_dir_file_row : ] == '..' || a:line[s:Lfiler_dir_file_row : ] == '.'
      return 0
    endif
    return 1
  endif
  if a:line[0:1] == ' -'
    return 1
  endif
  return 0
endfunction

function! s:getMarkRow(cl)
  if a:cl >= s:Lfiler_yank.start_index
    return s:Lfiler_yank.mark_row
  endif
  return s:Lfiler_file_mark_row
endfunction

function! s:getSortOptionParam()
  return '/OG'.s:Lfiler_sort.options[s:Lfiler_sort.current]
endfunction

function! s:quest(label, default, breakstr)
  let ans = ''
  while 1
    let ans = input(a:label, a:default)
    if match(ans, a:breakstr) != -1
      return ans
    endif
  endwhile
  return ans
endfunction

function! s:setline(num, line)
  call setline(a:num, a:line)
  return a:num+1
endfunction

function! s:markItem(start, end, midx) range
  setlocal modifiable
  let idx = a:start
  let lines = getline(a:start, a:end)
  let mark = ''
  for line in lines
    if !s:isAvailableLine(line)
      let idx = idx + 1
      continue
    endif
    if mark == ''
      if lines[idx - a:start][a:midx] == '*'
        let mark = ' '
      else
        let mark = '*'
      endif
    endif
    let idx = s:setline(idx, line[: a:midx-1].mark.line[a:midx+1 : ])
  endfor
  setlocal nomodifiable
endfunction

function! s:appendList(curpos, dict)
  let curpos = a:curpos
  let curpos = s:setline(curpos, '')
  let a:dict.start_index = curpos
  if !exists("a:dict.files") || len(a:dict.files) <= 0
    return curpos
  endif
  let fo_start = curpos 
  let curpos = s:setline(curpos, a:dict.title)
  if exists("a:dict.files")
    let files = copy(a:dict.files)
    if s:Lfiler_refine_word != ''
      call filter(files, "s:refine_filter(v:val)")
    endif
    for file in files
      let curpos = s:setline(curpos, ' - '.file)
    endfor
  endif
  if a:dict.fold == 1
    let fo_end = curpos - 1
    if fo_start < fo_end
      exe ':'.fo_start.','.fo_end.'fo'
    endif
  endif
  return curpos
endfunction

function! s:updateSortOptionTitle()
  let s:Lfiler_sort.title = s:Lfiler_sort.prefix.'='.s:Lfiler_sort.option_name[s:Lfiler_sort.current].' '.s:Lfiler_refine_prefix.'='
  let s:Lfiler_sort.option_len = len(s:Lfiler_sort.title)
endfunction
call s:updateSortOptionTitle()

