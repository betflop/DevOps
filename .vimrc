set number
" set noswapfile

set clipboard=unnamed

if (has('termguicolors'))
set termguicolors
endif

set background=dark
colorscheme onehalfdark

call plug#begin('~/.vim/plugins/') 
Plug 'rafi/awesome-vim-colorschemes'
Plug 'preservim/NERDTree'
Plug 'https://github.com/vim-airline/vim-airline'
call plug#end()

nmap <C-e> :NERDTreeToggle<CR>

" change cursor in insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
