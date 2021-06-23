" Vim Formatter Config

" TODO: can this be replaced with ale fixer

" AutoFormat config
let g:autoformat_verbosemode = 1

" AutoFormat shortcuts
noremap <leader>af :Autoformat<CR>

" #################
" # Cpp Formatter #
" #################

"! astyle version 2.05 or higher is required
let g:formatdef_astyle_cpp = '"astyle --mode=c --style=allman --indent=spaces=2 --pad-oper --unpad-paren --pad-header --convert-tabs"'
let g:formatters_cpp = ['astyle_cpp']

" ####################
" # Python Formatter #
" ####################

"! sudo apt-get install python-autopep8
let g:formatdef_autopep8 = '"autopep8 - -aa --max-line-length=199 --ignore=E128,E722"'
let g:formatters_python = ['autopep8']

" ########################
" # Javascript Formatter #
" ########################

"! sudo npm install -g js-beautify
" Formatter for js, json, html and css.
let g:formatdef_jsbeautify_js = '"js-beautify -f - --jslint-happy -s 2 -n"'
let g:formatters_javascript = ['jsbeautify_js']
let g:formatters_json = ['jsbeautify_js']
