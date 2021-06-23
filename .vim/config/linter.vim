" Vim Linter Config

" Ale keymap
nnoremap <Leader>ss :ALESymbolSearch -relative <C-r><C-w><CR>
vnoremap <Leader>ss y:ALESymbolSearch -relative <C-r>"<CR>
nnoremap <Leader>rr :ALEFindReferences -relative<CR>
nnoremap <Leader>gd :ALEGoToDefinition<CR>
nnoremap <Leader>k :ALEHover<CR>

" Force Ale preview to open in quickfix
augroup alequickfix
  autocmd!
  autocmd FileType ale-preview-selection exe 'call ReadtoQuickfix()'
augroup END

function! ReadtoQuickfix()
  execute 'cgetexpr getline(1, "$")'
  pclose
endfunction

" Ale config NOTE:(lopen) to show error list
let g:ale_linters = {
\   'cpp': ['clangd', 'roslint_cpplint'],
\   'python': ['python', 'jedils', 'pyls', 'roslint_pep8'],
\}

" Ros linter
let g:ale_cpp_roslint_cpplint_options = '--filter=-build/include_what_you_use,-runtime/references,-whitespace/braces,-whitespace/line_length'
let g:ale_python_roslint_pep8_options = '--max-line-length=199 --ignore=E128'
" Ros clangd
" !catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=1 or manually add env var below
" let $CPLUS_INCLUDE_PATH='/home/user/ws/devel/include/:/opt/ros/melodic/include/'

" Python linter
" bandit security linter !pip install bandit
" let g:ale_linters['python'] += ['bandit']
let g:ale_python_pyls_config = {
\   'pyls': {
\     'plugins': {
\       'pycodestyle': {
\         'maxLineLength': 199,
\         'ignore': 'W605,W504,E128,F841,E731',
\       },
\       'mccabe': {
\         'threshold': 30,
\       },
\     },
\   },
\}
" flake8 config !pip install flake8
" let g:ale_linters['python'] += ['flake8']
" let g:ale_python_flake8_options = '--max-line-length=199 --ignore W504,E128' " more strict mode
let g:ale_python_flake8_options = '--max-line-length=199 --ignore W606,W605,W504,E128,F841,E731'
