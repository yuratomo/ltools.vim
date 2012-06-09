" FILE: Laltfile.vim
" AUTHOR:  yuratomo
" Last Modified: 28 Dec 2011.

if exists('g:Laltfile_loaded') && g:Laltfile_loaded == 1
  finish
endif

if !exists('g:Lcore_global_keymap_disable')
  nnoremap <c-tab> :Laltfile<CR>
endif
command! -nargs=0 Laltfile :call Laltfile#AlternateFile()

if !exists('g:Laltfile_mapping')
  let g:Laltfile_mapping = []
endif
call add(g:Laltfile_mapping, {'\.cpp$'           : '.h'           } )
call add(g:Laltfile_mapping, {'\.h$'             : '.cpp'         } )
call add(g:Laltfile_mapping, {'\.c$'             : '.h'           } )
call add(g:Laltfile_mapping, {'\.h$'             : '.c'           } )
call add(g:Laltfile_mapping, {'\.cxx$'           : '.h'           } )
call add(g:Laltfile_mapping, {'\.h$'             : '.cxx'         } )
call add(g:Laltfile_mapping, {'\.cc$'            : '.h'           } )
call add(g:Laltfile_mapping, {'\.h$'             : '.cc'          } )
call add(g:Laltfile_mapping, {'\.as$'            : '.mxml'        } )
call add(g:Laltfile_mapping, {'\.mxml$'          : '.as'          } )
call add(g:Laltfile_mapping, {'Logic\.as$'       : '.mxml'        } )
call add(g:Laltfile_mapping, {'\.mxml$'          : 'Logic.as'     } )
call add(g:Laltfile_mapping, {'Action.java$'     : 'Form.as'      } )
call add(g:Laltfile_mapping, {'Form.java$'       : 'Action.as'    } )
call add(g:Laltfile_mapping, {'Action.java$'     : 'ActionForm.as'} )
call add(g:Laltfile_mapping, {'ActionForm.java$' : 'Action.as'    } )
call add(g:Laltfile_mapping, {'\.aspx$'          : '.aspx.cs'     } )
call add(g:Laltfile_mapping, {'\.aspx.cs$'       : '.aspx'        } )
call add(g:Laltfile_mapping, {'\.aspx$'          : '.aspx.vb'     } )
call add(g:Laltfile_mapping, {'\.aspx.vb$'       : '.aspx'        } )
call add(g:Laltfile_mapping, {'\.xaml$'          : '.xaml.cs'     } )
call add(g:Laltfile_mapping, {'\.xaml.cs$'       : '.xaml'        } )
call add(g:Laltfile_mapping, {'\.js$'            : '.html'        } )
call add(g:Laltfile_mapping, {'\.js$'            : '.html'        } )
call add(g:Laltfile_mapping, {'\.html$'          : '.coffee'      } )
call add(g:Laltfile_mapping, {'\.coffee$'        : '.js'          } )
call add(g:Laltfile_mapping, {'\.js$'            : '.coffee'      } )
call add(g:Laltfile_mapping, {'\.coffe$'         : '.html'        } )

function! Laltfile#AlternateFile()
  let file =expand('%') 
  let exist = 0
  for map in g:Laltfile_mapping
    for [key, value] in items(map)
      if match(file, key) >= 0
        let alt_file = substitute(file, key, value, '')
        if filereadable(alt_file)
          if bufexists(alt_file)
            exe ':b '.alt_file
          else
            exe ':e '.alt_file
          endif
          let exist = 1
          break
        endif
      endif
    endfor
    if exist == 1
      break
    endif
  endfor
endfunction

let g:Laltfile_loaded = 1
