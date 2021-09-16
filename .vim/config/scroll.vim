" plugin plugin

hi link ScrollBar PmenuSel

" Scroll.Vim command
augroup scroll_vim
  autocmd!
  autocmd CursorMoved * call s:OnCursorMoved()
  autocmd WinLeave * call s:OnCursorHold()
  autocmd InsertEnter * call s:OnCursorHold()
augroup END

" Scrolling event checking need to improve..
function! s:OnCursorMoved() abort
  let l:winheight = winheight(winnr())
  let l:curheight = winline()
  let l:firstbufline = line('w0')

  if (l:curheight <= 2 || l:curheight >= l:winheight - 1 || l:firstbufline != get(w:, 'firstbufline', -1))
    " maybe trigger autocmd (do..) here
    let w:firstbufline = line('w0')
    call s:OnDrawScroll()
  else
    call s:OnClearScroll()
  endif
endf

function! s:OnCursorHold() abort
  call s:OnClearScroll()
endf

function! s:OnDrawScroll() abort
  call s:OnClearScroll()
  call s:DrawScroll()
  let w:scroll_on = 1
endf

function! s:OnClearScroll() abort
  if !get(w:, 'scroll_on', 0)
    return
  endif
  call s:ClearScroll()
  let w:scroll_on = 0
endf

function! s:DrawScroll() abort
  " TODO: draw scroller background
  let l:winwidth = winwidth(winnr())
  let l:firstbufline = line('w0')
  let l:lastbufline = line('w$')

  let l:buflinecount = line('$')
  let l:winlinecount = winheight(winnr())

  let l:scrollthumbheight = max([l:winlinecount * l:winlinecount / l:buflinecount, 1])
  let l:scrollthumbfirstline = (l:firstbufline * l:winlinecount / l:buflinecount) + l:firstbufline
  let l:scrollthumblastline = l:scrollthumbfirstline + l:scrollthumbheight - 1

  let l:poss = map(range(l:scrollthumbfirstline, l:scrollthumblastline), {_, val -> [val, 1]})

  let l:poss_l = len(l:poss)
  let l:chunk_c = l:poss_l / 8 + 1
  let w:scroll_highlight = map(range(0, l:chunk_c), {_, val -> matchaddpos('ScrollBar', l:poss[val * 8: (val + 1) * 8], 100)})
endfunction

function! s:ClearScroll() abort
  let l:m = get(w:, 'scroll_highlight', [])
  if len(l:m) == 0
    return
  endif

  for val in l:m
    if val <= 0
      continue
    endif
    call matchdelete(val)
  endfor

  let w:scroll_highlight = []
endf
