" diff text object
let g:textobj_diff_no_default_key_mappings = 1
augroup difffttextobj
  autocmd!
  autocmd FileType diff,git xmap <buffer> gj <Plug>(textobj-diff-hunk-n)
  autocmd FileType diff,git omap <buffer> gj <Plug>(textobj-diff-hunk-n)
  autocmd FileType diff,git nmap <buffer> gj <Plug>(textobj-diff-hunk-n)
  autocmd FileType diff,git xmap <buffer> gk <Plug>(textobj-diff-hunk-p)
  autocmd FileType diff,git omap <buffer> gk <Plug>(textobj-diff-hunk-p)
  autocmd FileType diff,git nmap <buffer> gk <Plug>(textobj-diff-hunk-p)
augroup END


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

  return ['v', head_pos, tail_pos]
endfunction
