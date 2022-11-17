" Vim Simple Note Plugin.
" Simple note will open note file based on file extension.

" Plugin Start
function! s:SimpleNotePrintError(msg)
    execute 'normal! \<Esc>'
    echohl ErrorMsg
    echomsg a:msg
    echohl None
endfunction

function! s:SimpleNoteIsEnabled()
  let g:SimpleNoteDir = get(g:, 'SimpleNoteDir', '')
  if (g:SimpleNoteDir == '')
    return v:false
  endif

  if !isdirectory(expand(g:SimpleNoteDir))
    call s:SimpleNotePrintError('SimpleNote: dir does not exist')
    return v:false
  endif

  return v:true
endfunction

function! s:SimpleNoteGetDir()
  return fnamemodify(expand(g:SimpleNoteDir), ':p:h')
endfunction

function! s:SimpleNoteComplete(arg, line, cur)
  if s:SimpleNoteIsEnabled() == v:false
    return ''
  endif
  let comp = globpath(s:SimpleNoteGetDir(), 'note.*')
  let comp = substitute(comp, '[^\n]*note.', '', '')
  return comp
endfunction

function! s:SimpleNoteOpenBuffer(mods, buff)
  execute a:mods.' split | edit '.a:buff.' | setlocal bufhidden=delete nobuflisted'
endfunction

function! s:SimpleNoteOpenTodo(mods)
  let g:SimpleNoteTODOFile = get(g:, 'SimpleNoteTODOFile', '')
  if (g:SimpleNoteTODOFile == '')
    call s:SimpleNotePrintError('SimpleNote: todo dir does not exist')
    return
  endif
  call s:SimpleNoteOpenBuffer(a:mods, g:SimpleNoteTODOFile)
endfunction

function! s:SimpleNote(ft, mods)
  if a:ft == 'todo'
    call s:SimpleNoteOpenTodo(a:mods)
    return
  endif

  if s:SimpleNoteIsEnabled() == v:false
    return
  endif

  call s:SimpleNoteOpenBuffer(a:mods, s:SimpleNoteGetDir().'/'.(a:ft == '' ? '' : 'note.'.fnameescape(a:ft)))
endfunction

command! -nargs=? -complete=custom,s:SimpleNoteComplete SN call s:SimpleNote(<q-args>, <q-mods>)
nnoremap <silent> <expr> <Leader>sn ":SN <C-r>=fnamemodify(expand('%'), ':e')? fnamemodify(expand('%'), ':e') : &filetype<CR><CR>"
nnoremap <silent> <expr> <Leader>nn ":SN todo<CR>"
