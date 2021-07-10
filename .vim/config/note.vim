" Vim Simple Note Plugin.
" Simple note will open note file based on file extension.

" Plugin Start
function s:simple_note_print_error(msg)
    execute 'normal! \<Esc>'
    echohl ErrorMsg
    echomsg a:msg
    echohl None
endfunction

function s:simple_note_is_enabled()
  let g:SimpleNoteDir = get(g:, 'SimpleNoteDir', '')
  if (g:SimpleNoteDir == '')
    return v:false
  endif

  if !isdirectory(expand(g:SimpleNoteDir))
    call s:simple_note_print_error('SimpleNote: dir does not exist')
    return v:false
  endif

  return v:true
endfunction

function s:simple_note_get_dir()
  return fnamemodify(expand(g:SimpleNoteDir), ':p:h')
endfunction

function s:simple_note_complete(arg, line, cur)
  if s:simple_note_is_enabled() == v:false
    return ''
  endif
  let comp = globpath(s:simple_note_get_dir(), 'note.*')
  let comp = substitute(comp, '[^\n]*note.', '', '')
  return comp
endfunction

function s:simple_note_open_buffer(mods, buff)
  execute a:mods.' split | edit '.a:buff.' | setlocal bufhidden=delete'
endfunction

function s:simple_note_open_todo(mods)
  let g:SimpleNoteTODOFile = get(g:, 'SimpleNoteTODOFile', '')
  if (g:SimpleNoteTODOFile == '')
    call s:simple_note_print_error('SimpleNote: todo dir does not exist')
    return
  endif
  call s:simple_note_open_buffer(a:mods, g:SimpleNoteTODOFile)
endfunction

function s:simple_note(ft, mods)
  if a:ft == 'todo'
    call s:simple_note_open_todo(a:mods)
    return
  endif

  if s:simple_note_is_enabled() == v:false
    return
  endif

  call s:simple_note_open_buffer(a:mods, s:simple_note_get_dir().'/'.(a:ft == '' ? '' : 'note.'.fnameescape(a:ft)))
endfunction

command! -nargs=? -complete=custom,s:simple_note_complete SN call s:simple_note(<q-args>, <q-mods>)
nnoremap <expr> <Leader>sn ":SN <C-r>=fnamemodify(expand('%'), ':e')<CR><CR>"
nnoremap <expr> <Leader>nn ":SN todo<CR>"
