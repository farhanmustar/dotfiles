" diff text object
let g:textobj_diff_no_default_key_mappings = 1
augroup difffttextobj
  autocmd!
  autocmd FileType diff,git call <SID>difftextobjMap()
augroup END

function! s:difftextobjMap()
  xmap <buffer> gj <Plug>(textobj-diff-hunk-n)
  omap <buffer> gj <Plug>(textobj-diff-hunk-n)
  nmap <buffer> gj <Plug>(textobj-diff-hunk-n)
  xmap <buffer> gk <Plug>(textobj-diff-hunk-p)
  omap <buffer> gk <Plug>(textobj-diff-hunk-p)
  nmap <buffer> gk <Plug>(textobj-diff-hunk-p)
  xmap <buffer> gJ <Plug>(textobj-diff-file-n)
  omap <buffer> gJ <Plug>(textobj-diff-file-n)
  nmap <buffer> gJ <Plug>(textobj-diff-file-n)
  xmap <buffer> gK <Plug>(textobj-diff-file-p)
  omap <buffer> gK <Plug>(textobj-diff-file-p)
  nmap <buffer> gK <Plug>(textobj-diff-file-p)
endfunction

augroup fugitivetextobj
  autocmd!
  autocmd FileType fugitive call <SID>fugitivetextobjMap()
augroup END

function! s:fugitivetextobjMap()
  nmap <buffer> gj ]c
  nmap <buffer> gk [c
  nmap <buffer> gJ ]m
  nmap <buffer> gK [m
endfunction

call textobj#user#plugin('customdiff', {
\   'diffchanges': {
\     'sfile': expand('<sfile>'),
\     'select-a-function': 's:difftextobj',
\     'select-a': 'ad',
\     'select-i-function': 's:difftextobj',
\     'select-i': 'id',
\   },
\ })

function! s:difftextobj()
	let end = line('$')
	let cur = line('.')

	let mInside = getbufline('%', cur)->match('^[+-]') != -1
	let cur = cur + 1
  let start = 0

  " find tail_pos
	while cur <= end
		let curMatched = getbufline('%', cur)->match('^[+-]') != -1
    if !mInside && curMatched
      let start = cur
      let mInside = 1
    endif

    if mInside && !curMatched
      break
    endif
		
    let cur = cur + 1
	endwhile

  if !mInside
    return 0
  endif

  let end = cur - 1

  if !start
    let cur = line('.') - 1
    while cur > 0
      let curMatched = getbufline('%', cur)->match('^[+-]')!= -1
      if !curMatched
        break
      endif
      let cur = cur - 1
    endwhile
    let start = cur + 1
  endif

  execute start
  normal! 0
  let head_pos = getpos('.')

  execute end
  normal! $
  let tail_pos = getpos('.')

  return ['V', head_pos, tail_pos]
endfunction
