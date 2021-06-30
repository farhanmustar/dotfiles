" Vim Simple Note Plugin.
" Simple note will open note file based on file extension.

" Plugin Start
function s:simple_note_is_enabled()
  let g:SimpleNoteDir = get(g:, 'SimpleNoteDir', '')
  if (g:SimpleNoteDir == '')
    return v:false
  endif

  if !isdirectory(expand(g:SimpleNoteDir))
    echoerr('SimpleNote: dir does not exist')
    return v:false
  endif

  return v:true
endfunction

function s:simple_note_get_dir()
  return fnamemodify(expand(g:SimpleNoteDir), ':p:h')
endfunction

function s:simple_note(ft, mods)
  if s:simple_note_is_enabled() == v:false
    return
  endif

  execute a:mods.' split | edit '.s:simple_note_get_dir().'/'.(a:ft == '' ? '' : 'note.'.fnameescape(a:ft))
endfunction

function s:simple_note_complete(arg, line, cur)
  if s:simple_note_is_enabled() == v:false
    return ''
  endif
  let comp = globpath(s:simple_note_get_dir(), 'note.*')
  let comp = substitute(comp, '[^\n]*note.', '', '')
  return comp
endfunction

command! -nargs=? -complete=custom,s:simple_note_complete SN call s:simple_note(<q-args>, <q-mods>)
nnoremap <expr> <Leader>sn ":SN <C-r>=fnamemodify(expand('%'), ':e')<CR><CR>"
