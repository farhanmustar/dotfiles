" auto install vundle
if empty(glob('~/.vim/bundle/Vundle.vim')) && executable('git')
  echom 'Installing Vundle...'
  echom ''
  silent execute '!git clone https://github.com/farhanmustar/Vundle.vim.git ' . glob('~') . '/.vim/bundle/Vundle.vim'
endif

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'farhanmustar/Vundle.vim'

Plugin 'Chiel92/vim-autoformat'
Plugin 'dense-analysis/ale'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'djoshea/vim-autoread'
Plugin 'ervandew/supertab'
Plugin 'farhanmustar/ale-python-linter'
Plugin 'farhanmustar/gv.vim'
Plugin 'fidian/hexmode'
Plugin 'ludovicchabant/vim-lawrencium'
Plugin 'mbbill/undotree'
Plugin 'mhinz/vim-startify'
Plugin 'mkitt/tabline.vim'
Plugin 'morhetz/gruvbox'
Plugin 'szw/vim-ctrlspace'
Plugin 'terryma/vim-smooth-scroll'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'

"Plugin 'dart-lang/dart-vim-plugin'
"Plugin 'erisian/rest_tools'
"Plugin 'ompugao/ros.vim'

if executable('curl')
  Plugin 'farhanmustar/cs.vim'
endif

if executable('ctags') " universal-ctags
  Plugin 'preservim/tagbar'
endif

if executable('yarn')
  Plugin 'iamcco/markdown-preview.nvim', { 'oninstall': '!cd app && yarn install', 'onupdate': '!cd app && yarn install' }
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" Inherit aliases from ~/.bash_aliases
let $BASH_ENV = "~/.bash_aliases"

" Colorscheme
set t_Co=256
set t_ut=
set background=dark
set cursorline
let g:gruvbox_contrast_dark='hard'
silent! colorscheme gruvbox

" Prevent auto-indenting of comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Let Vim jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Open each buffer in its own tabpage
"au BufAdd,BufNewFile * nested tab sball


" Some tuning
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set mouse=a			" Enable mouse usage (all modes)
set ruler
set number
set splitbelow
set splitright
set hidden
" Tabs settings
set expandtab
set softtabstop=0
set shiftwidth=2
set tabstop=2
" Make tab completion in command mode behave like in Bash
set wildmenu
set wildmode=longest,list
set wildignore=*.o,*.class,*.swp,*.swo,*.pyc

" Use tree view for netrw directory browsing
let g:netrw_liststyle=3

" CtrlSpace config
let g:CtrlSpaceUseUnicode = 0
let g:CtrlSpaceSymbols = { "IV": "o" }
let g:CtrlSpaceSaveWorkspaceOnExit = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceUseMouseAndArrowsInTerm = 1
let g:CtrlSpaceIgnoredFiles = '\v(tmp|temp|build|dist|env|node_modules|platforms|plugins|www\/lib)[\/]'

" ROS config
let g:ros_make = "current"
let g:ros_build_system = "catkin"
"let g:ros_catkin_make_options = "-DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"

" AutoFormat config
let g:autoformat_verbosemode = 1
"! astyle version 2.05 or higher is required
let g:formatdef_astyle_cpp = '"astyle --mode=c --style=allman --indent=spaces=2 --pad-oper --unpad-paren --pad-header --convert-tabs"'
let g:formatters_cpp = ['astyle_cpp']
"! sudo apt-get install python-autopep8
let g:formatdef_autopep8 = '"autopep8 - -aa --max-line-length=199 --ignore=E128,E722"'
let g:formatters_python = ['autopep8']
"! sudo npm install -g js-beautify
" Formatter for js, json, html and css.
let g:formatdef_jsbeautify_js = '"js-beautify -f - --jslint-happy -s 2 -n"'
let g:formatters_javascript = ['jsbeautify_js']
let g:formatters_json = ['jsbeautify_js']

" Indentation config for html and htmldjango
let g:html_indent_inctags = 'body,head,tbody,p'

" Associates triggers with ROS filetypes
let g:ycm_semantic_triggers = {
\   'roslaunch': ['="', '$(', '/'],
\   'rosmsg,rossrv,rosaction': ['re!^'],
\ }

" SuperTab config
let g:SuperTabDefaultCompletionType = '<C-n>'

" vim-table-mode config
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='='

" Import mswin key mappings and behavior.
source $VIMRUNTIME/mswin.vim

" Unmap CTRL-Y(redo) to its original scroll
nunmap <C-Y>
iunmap <C-Y>

" Tap CTRL-S twice for save and exit, also in Insert mode
"noremap <C-S><C-S>		:wq<CR>
"vnoremap <C-S><C-S>		<C-C>:wq<CR>
"inoremap <C-S><C-S>		<C-O>:wq<CR>

" Tap CTRL-W twice for exit, also in Insert mode
"noremap <C-W><C-W>		:q!<CR>
"vnoremap <C-W><C-W>		<C-C>:q!<CR>
"inoremap <C-W><C-W>		<C-O>:q!<CR>

" Move by virtual lines when used without a count
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Quickly select the text that was just pasted. This allows you to, e.g.,
" indent it after pasting.
noremap gV `[v`]

" Stay in visual mode when indenting. You will never have to run gv after
" performing an indentation.
vnoremap < <gv
vnoremap > >gv

" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yy).
noremap Y y$

" Avoid pressing shift key to switch to previous tab
noremap gr gT

" Allows you to easily replace the current word and all its occurrences.
nnoremap <Leader>rc :%s/\<<C-r><C-w>\>/
vnoremap <Leader>rc y:%s/<C-r>"/

" Allows you to easily change the current word and all occurrences to something
" else. The difference between this and the previous mapping is that the mapping
" below pre-fills the current word for you to change.
nnoremap <Leader>cc :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>cc y:%s/<C-r>"/<C-r>"

" Allow you to easily search the current word.
nnoremap <Leader>ff /\<<C-r><C-w>\><CR>
vnoremap <Leader>ff y/<C-r>"<CR>

" Diff shortcuts
noremap <leader>df :call DiffToggle()<CR>
function! DiffToggle()
  if &diff
    diffoff!
    windo setlocal nocursorbind
  else
    windo diffthis
  endif
:endfunction

" Toggle paste mode
nnoremap <Leader>pp :call PasteToggle()<CR>
function! PasteToggle()
  if &paste
		set nopaste
		echo "Paste Mode Disabled"
  else
		set paste
		echo "Paste Mode Enabled"
  endif
:endfunction

" Smooth Scroll shortcuts
noremap <silent> <c-y> :call smooth_scroll#up(3, 0, 3)<CR>
noremap <silent> <c-e> :call smooth_scroll#down(3, 0, 3)<CR>
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 20, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 20, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 20, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 20, 4)<CR>

" ROS shortcuts
noremap <F10> :make!<CR>

" AutoFormat shortcuts
"noremap <F3> :Autoformat<CR><CR>
noremap <leader>af :Autoformat<CR>

" Remove trailing whitespaces
noremap <leader>as :%s/\s\+$//e<CR>

" Quickfix shortcuts (grep)
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap <expr> <CR> &buftype is# 'quickfix' ? '<CR><C-w>p' : '<CR>'

" Auto open quickfix window
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* nested bot cwindow 20 | redraw!
    autocmd QuickFixCmdPost l* nested bot lwindow 20 | redraw!
augroup END

" Fugitive shortcuts
command! Gv vertical topleft G
command! Gt tab G
command! Greload :e "<C-r>%"<CR>
command! -nargs=+ GG silent execute "Ggrep! -niI --exclude-standard --untracked <args>"
nnoremap <Leader>gg :GG <C-r><C-w><CR>
vnoremap <Leader>gg y:GG "<C-r>""<CR>

" Hard mode - disable arrow keys
map <Up>	 :echo "no!"<CR>
map <Down>	 :echo "no!"<CR>
map <Left>	 :echo "no!"<CR>
map <Right>	 :echo "no!"<CR>
inoremap <Up>		<Nop>
inoremap <Down>		<Nop>
inoremap <Left>		<Nop>
inoremap <Right>	<Nop>

" window resize
nnoremap <Right> :vertical resize +10<CR>
nnoremap <Left> :vertical resize -10<CR>
nnoremap <Up> :resize +10<CR>
nnoremap <Down> :resize -10<CR>

" Disable Execute Mode
nmap Q	<Nop>

" close pane using shortcut
nnoremap gq :q<CR>

" Ale config
let g:ale_linters = {
\   'python': ['python'],
\}

" vimscript dev mapping
nnoremap <Leader>so :source %<CR>

" tagbar config
let g:tagbar_width = 60
nnoremap <Leader>st :TagbarToggle<CR>

" set space as leader key
nnoremap <Space> <Nop>
map <Space> <Leader>

" startify config
command! S botright split | Startify
command! Sv vertical botright split | Startify
command! St tabnew | Startify
let g:startify_bookmarks = [
\   '~/.vimrc', 
\]

" undotree config
nnoremap <Leader>ut :UndotreeToggle<CR>
