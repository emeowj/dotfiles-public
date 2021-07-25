set nocompatible
filetype off

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'sainnhe/sonokai'
Plug 'itchyny/lightline.vim'
Plug 'frazrepo/vim-rainbow'
Plug 'ap/vim-css-color'
Plug 'junegunn/vim-emoji'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'scalameta/nvim-metals', {'branch': 'next'}
call plug#end()

filetype plugin indent on

" Color theme
if has('termguicolors')
  set termguicolors
endif

" General settings
set hidden
highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
set cursorline
set laststatus=2
set nobackup
set noswapfile
set t_Co=256
set number relativenumber
set clipboard=unnamedplus
set history=1000

syntax enable

filetype plugin on
filetype indent on

set background=dark

" Auto read when a file changes from outside
set autoread
au FocusGained,BufEnter * checktime

let mapleader = ","
nmap <leader>w :w!<CR>

" Toggle paste mode
map <leader>pp :setlocal paste!<cr> 

" Remap jj in insert mode to Escape 
imap jj <Esc>

" Set 7 lines to the cursor when moving with j/k
set so=7
set shortmess=a
set ruler

""""""""""""""""""""""""""""""""
" Search
""""""""""""""""""""""""""""""""
set ignorecase
set hlsearch
set incsearch
" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

""""""""""""""""""""""""""""""""
" Split
""""""""""""""""""""""""""""""""
set splitbelow splitright
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

" Adjusting split sizes
nnoremap <silent> <C-Left> :vertical resize +3<CR>
nnoremap <silent> <C-Right> :vertical resize -3<CR>
nnoremap <silent> <C-Up> :resize +3<CR>
nnoremap <silent> <C-Down> :resize -3<CR>

""""""""""""""""""""""""""""""""
" Text, tab and indent
""""""""""""""""""""""""""""""""
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
set ai " Auto indent
set si " Smart indent
set wrap " Wrap lines

""""""""""""""""""""""""""""""""
" Buffers and tabs
""""""""""""""""""""""""""""""""
" Close the current buffer
map <leader>bd :bd<cr>

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<cr>
map <leader>t :tabnext<cr>

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


""""""""""""""""""""""""""""""""
" Status line
""""""""""""""""""""""""""""""""
set laststatus=2
set noshowmode
let g:lightline = {
	\ 'colorscheme': 'material',
	\ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

nmap <M-j> mz:m+<cr>`z
" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fast editing and reloading of vimrc configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>e :e! ~/.config/nvim/init.vim<cr>
autocmd! bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins configuration 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" telescope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

lua <<EOF
require('telescope').setup{
  defaults = {
    file_ignore_patterns = {
      '**/node_modules',
      '**/*.class',
      '**/target',
    }
  }
}
EOF

" nvim-metals
augroup lsp
  au!
  " metals_config.init_options.statusBarProvider = 'on'
  " metals_config = require'metals'.bare_config
  au FileType scala,sbt lua  require('metals').initialize_or_attach({metals_config})
augroup end

