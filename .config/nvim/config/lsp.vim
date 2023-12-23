let g:ale_use_neovim_diagnostics_api = 1
let g:ale_set_loclist = 0
let g:ale_echo_cursor = 0
let g:ale_virtualtext_cursor = 0
let g:ale_set_signs = 1

" Ale keymap
nnoremap <Leader>ee :lua vim.diagnostic.open_float()<CR>
nnoremap <Leader>ej :lua vim.diagnostic.goto_next()<CR>
nnoremap <Leader>ek :lua vim.diagnostic.goto_prev()<CR>
nnoremap <Leader>es :ALESymbolSearch -relative <C-r><C-w><CR>
vnoremap <Leader>es y:ALESymbolSearch -relative <C-r>"<CR>
nnoremap <Leader>e; :ALECodeAction<CR>
nnoremap <Leader>er :ALEFindReferences -relative<CR>
nnoremap <Leader>ed :ALEGoToDefinition<CR>
nnoremap <Leader>k :ALEHover<CR>
nnoremap <Leader>af :ALEFix<CR>

function! s:EnableDiagnosticPopup() abort
  augroup diagnosticpopbehaviour
    autocmd!
    autocmd CursorMoved,CursorHold * lua if vim.fn.mode() == "n" then vim.diagnostic.open_float({focus = false}) end
  augroup END
endfunction

function! s:DisableDiagnosticPopup() abort
  augroup diagnosticpopbehaviour
    autocmd!
  augroup END
endfunction

call s:EnableDiagnosticPopup()
command! -nargs=0 DisableDiagnosticPopup silent call <SID>DisableDiagnosticPopup()
command! -nargs=0 EnableDiagnosticPopup silent call <SID>EnableDiagnosticPopup()
command! -nargs=0 DisableDiagnostic silent lua vim.diagnostic.disable(0, nil); vim.diagnostic.reset(nil, 0)
command! -nargs=0 EnableDiagnostic silent lua vim.diagnostic.enable(0, nil)

augroup diagnosticbehaviour
  autocmd!
  autocmd DiagnosticChanged * lua vim.diagnostic.setloclist({open = false})
augroup END

lua << EOF
vim.diagnostic.config({
	float = {
		border = "single",
		format = function(diagnostic)
			return string.format(
				"%s: %s (%s)",
				(diagnostic.code or diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.code) or '#',
				diagnostic.message,
				diagnostic.source
			)
		end,
	},
})
EOF

" #############################################################################
" #                              Linter Config                                #
" #############################################################################

" NOTE: (lopen) to show error list
let g:ale_linters = {
\   'cpp': ['roslint_cpplint'],
\   'python': ['python', 'roslint_pep8'],
\   'javascript': ['jshint'],
\   'dart': ['dart_analyze'],
\}

" ##############
" # Ros Linter #
" ##############

" let g:ale_linters['cpp'] += ['clangd']
" let g:ale_linters['cpp'] += ['ccls']

let g:ale_cpp_clangd_options = '--pch-storage=memory --background-index -j=5 --limit-results=30'
let g:ale_cpp_roslint_cpplint_options = '--filter=-build/include_what_you_use,-runtime/references,-whitespace/braces,-whitespace/line_length'
let g:ale_python_roslint_pep8_options = '--max-line-length=199 --ignore=E128'

" Ros clangd
" run following catkin_make or set environment variable.
" !catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=1
" let $CPLUS_INCLUDE_PATH='/home/user/ws/devel/include/:/opt/ros/melodic/include/'

" #################
" # Python Linter #
" #################

" let g:ale_linters['python'] += ['bandit']
let g:ale_linters['python'] += ['flake8']

" python language server
" let g:ale_linters['python'] += ['jedils']
" let g:ale_linters['python'] += ['pyls']

" let g:ale_python_flake8_options = '--max-line-length=199 --ignore W504,E128' " more strict mode
let g:ale_python_flake8_options = '--max-line-length=199 --ignore W606,W605,W504,E128,F841,E731'
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

" #####################
" # Javascript Linter #
" #####################

" let g:ale_linters['javascript'] += ['tsserver']

" ###############
" # Dart Linter #
" ###############

" let g:ale_linters['dart'] += ['analysis_server']

" #############################################################################
" #                              Fixer Config                                 #
" #############################################################################

let g:ale_fixers = {
\   'cpp': ['astyle'],
\   'python': ['autopep8'],
\   'javascript': ['js-beautify'],
\   'dart': ['dart-format'],
\}

" #############
" # Cpp Fixer #
" #############

let g:ale_cpp_astyle_options = '--mode=c --style=allman --indent=spaces=2 --pad-oper --unpad-paren --pad-header --convert-tabs'

" ################
" # Python Fixer #
" ################

let g:ale_python_autopep8_options = '-aa --max-line-length=199 --ignore=E128,E722'

" ####################
" # Javascript Fixer #
" ####################

let g:ale_javascript_js_beautify_options = '--jslint-happy -s 2 -n'
