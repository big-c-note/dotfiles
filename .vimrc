" Install vim-plug if not installed.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs " 21k stars
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Packages to install. 
call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale' 
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'github/copilot.vim'
call plug#end()

" coc-nvim settings.
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Lightline statusline/tabline bar plugin 
set laststatus=2
" Showing the -- INSERT -- mode isn't needed anymore as Lightline takes care
" of that for us. 
set noshowmode 

let g:lightline = {
    \ 'colorscheme': 'seoul256',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'filename', 'readonly', 'modified' ],
    \             [ 'gitbranch' ],
    \           ],
    \   'right': [
    \             [ 'percent' ],
    \             [ 'lineinfo' ],
    \             [ 'fileformat', 'fileencoding' ],
    \             [ 'gutentags'],
    \            ],
    \ },
    \ 'component_function': {
    \   'readonly': 'LightlineReadonly',
    \   'filename': 'LightlineFilename',
    \   'gitbranch': 'fugitive#head',
    \   'fileformat': 'LightlineFileformat',
    \   'fileencoding': 'LightlineFileencoding',
    \ },
    \ }

function! LightlineReadonly()
  return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction

function! LightlineFilename()
  let fname = expand('%:.')
  let ftype =  &filetype !=# '' ? &filetype : 'no ft'
  return fname . ' (' . ftype . ')'
endfunction

function! LightlineFileencoding()
  let encoding = &fenc !=# '' ? &fenc : &enc
  return encoding !=# 'utf-8' ? encoding : ''
endfunction

function! LightlineFileformat()
  return &fileformat !=# 'unix' ? &fileformat : ''
endfunction
let g:lightline.component_expand = {'trailing': 'lightline#trailing_whitespace#component'}
let g:lightline.component_type = {'trailing': 'error'}
" end lightline.
" end colors.

" Start File settings.
" Draw visual line for where lines should end.
autocmd BufNewFile,BufRead * set colorcolumn=80

" https://stackoverflow.com/questions/10760082/vim-settings-for-python
filetype plugin indent on
syntax on

" Python file settings.
au BufNewFile,BufRead *.py
    \ set tabstop=4       |
    \ set softtabstop=4   |
    \ set shiftwidth=4    |
    \ set textwidth=79    |
    \ set expandtab       |
    \ set autoindent      |
    \ set fileformat=unix 

au BufNewFile,BufRead *.js,*.html,*.yaml,*.c,*.cc,*.go
    \ set tabstop=2       |
    \ set softtabstop=2   |
    \ set shiftwidth=4    |
    \ set textwidth=79    |
    \ set expandtab       |
    \ set autoindent      |
    \ set fileformat=unix 

" Yaml file settings.
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Read md files as markdown so they are highlighted correctly.
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" Upon writing to python files, remove trailing whitespaces.
autocmd BufWritePre *.py %s/\s\+$//e
" End file settings.


" Start NERDTree.
" Open NERDTREE when Vim starts.
" autocmd vimenter * NERDTree

" Open NERDTree automatically if no file specified at startup.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Close vim if the only remaining window is NERDTree.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif 
" End NERDTree.


" Start ALE
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_python_pycodestyle_options = '--max-line-length 90'
let g:ale_linters = {
\   'python': ['flake8', 'mypy'],
\   'javascript': ['eslint'],
\   'rust': ['rust-analyzer', 'cargo']
\}
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'python': ['black'],
\   'cpp': ['clang-format'],
\   'c': ['clang-format'],
\   'rust': ['rustfmt']
\}
let g:ale_fix_on_save = 1

let g:python_black_executable = 'black'

let g:ale_python_flake8_executable = 'flake8'
let g:ale_python_flake8_options = '--ignore=E501,W503 --max-line-length=100'
let g:ale_python_flake8_use_global = 1

let g:ale_python_mypy_executable = 'mypy'
let g:ale_python_mypy_options = '--ignore-missing-imports'

let g:ale_keep_list_window_open = 0
let g:ale_open_list = 0 
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0 
let g:ale_lint_on_enter = 1
let g:ale_sign_column_always = 1

" Double hit escape in normal mode to hide ALE
nnoremap <esc> :noh<return>:ALEReset<return>:cclose<return>:pclose<return><esc>
nnoremap <esc>^[ <esc>^[
nnoremap <leader>l :ALELint<CR>
" End ALE.


" Leader key is not a '\' (default), it is now a comma ','
let mapleader = ","
set encoding=utf-8

" Absolute numbered lines.
set number

" Highlight selections in view when I search for them.
set hlsearch

" Prevent up/down/left/right keys navigation.
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
vnoremap u :noh<cr>

" Yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif


" Start search settings.
" Fzf vim
set rtp+=~/.fzf

" ,+b for filename search
nnoremap <leader>b :Files<CR>

" ,+n for all-file code search
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '-u', <bang>0)
nnoremap <leader>n :Ag<CR>

" ,+m for in-file code search
nnoremap <leader>m :BLines<CR>

let g:fzf_colors = { 
\ 'fg':      ['fg', 'Normal'],
\ 'bg':      ['bg', 'Normal'],
\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
\ 'info':    ['fg', 'PreProc'],
\ 'border':  ['fg', 'Ignore'],
\ 'prompt':  ['fg', 'Conditional'],
\ 'pointer': ['fg', 'Exception'],
\ 'marker':  ['fg', 'Keyword'],
\ 'spinner': ['fg', 'Label'],
\ 'header':  ['fg', 'Comment'] 
\ }
" End search settings.

" Start git settings.
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
