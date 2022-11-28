set encoding=UTF-8
set number
set noswapfile
set relativenumber
set clipboard=unnamedplus
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2
set background=dark
set colorcolumn=79
set mouse=a
filetype plugin indent on

if (has('termguicolors'))
	set termguicolors
endif

let $BAT_THEME='Monokai Extended Origin'
colorscheme gruvbox
" colorscheme onehalfdark
" colorscheme space-vim-dark
let g:airline_theme = "molokai"

call plug#begin('~/.config/nvim')
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'morhetz/gruvbox'  " colorscheme gruvbox

Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/ap/vim-css-color'
Plug 'mxw/vim-jsx'
Plug 'vim-python/python-syntax'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'preservim/NERDTree'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'tpope/vim-commentary'
Plug 'mattn/emmet-vim'
Plug 'raimondi/delimitmate'
Plug 'puremourning/vimspector'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'valloric/matchtagalways'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline-themes'
Plug 'chiel92/vim-autoformat'
Plug 'ryanoasis/vim-devicons'
Plug 'sirver/ultisnips'
Plug 'tpope/vim-fugitive'
Plug 'adrienverge/yamllint'
Plug 'neomake/neomake'
Plug 'MattesGroeger/vim-bookmarks'
call plug#end()

autocmd FileType python map <buffer> <Leader>q :w<CR>:exec '!python3 %'<CR>
autocmd FileType go map <buffer> <Leader>q :w<CR>:exec '!go run %'<CR>
" run current script with python3 by CTRL+R in command and insert mode
" autocmd FileType python map <buffer> <C-r> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
" autocmd FileType python imap <buffer> <C-r> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

nmap <C-e> :NERDTreeToggle<CR>
noremap '/ :Commentary<CR>
nnoremap ,<space> :nohlsearch<CR>
map gn :bn<cr>
map gp :bp<cr>
map gw :Bclose<cr>

" FORMATTERS
au FileType javascript setlocal formatprg=prettier
au FileType javascript.jsx setlocal formatprg=prettier
au FileType typescript setlocal formatprg=prettier\ --parser\ typescript
au FileType html setlocal formatprg=js-beautify\ --type\ html
au FileType scss setlocal formatprg=prettier\ --parser\ css
au FileType css setlocal formatprg=prettier\ --parser\ css
au FileType python setlocal formatprg=autopep8\ -aa\ --indent-size\ 0\ -
au FileType json setlocal formatprg=prettier
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

let g:UltiSnipsExpandTrigger="<c-j>"
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:syntastic_check_on_open=1
let g:user_emmet_leader_key='<tab>'
" tab + ,
let g:vimspector_enable_mappings = 'HUMAN'
let g:go_fmt_autosave = 0
let g:python_highlight_all = 1

augroup remember_folds
" autocmd!
" autocmd BufWinLeave * mkview
" autocmd BufWinEnter * silent! loadview
" augroup END

au BufWrite *.yml :Neomake

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Enter dont insert mod
map <Enter> o<ESC>

" fzf
nmap <Leader>b :Buffers<CR>
nmap <Leader>f :Files<CR>
nmap <Leader>t :Tags<CR>
" nmap <Leader>l :Lines<CR>
nmap <Leader>r :Rg<CR>
" :Rg :Ag



" command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case --hidden -- ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0) 
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)


" GIT diff
" git difftool --tool nvimdiff
" git difftool --tool nvimdiff master master~10
" git difftool HEAD~1 --tool=nvimdiff
" git difftool HEAD~3 HEAD~2 --tool=nvimdiff
" git diff branch1 branch2

" /////////////////////////////////////////////////////////////////////////////////

" pumvisible() checks if the complete popup is currently visible. 
" feedkeys() Sends input-keys to Nvim, subject to various quirks controlled by mode flags
" To input sequences like <C-o> use nvim_replace_termcodes() (typically with escape_ks=false) to replace keycodes, then pass the result to nvim_feedkeys().


" ['<Tab>'] = function(fallback)
" 	if vim.fn.pumvisible() == 1 then
" 		vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
" 	else
" 		fallback()
" 	end
" 	end,
" 	['<S-Tab>'] = function(fallback)
" 	if vim.fn.pumvisible() == 1 then
" 	    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
" 	elseif luasnip.expand_or_jumpable() then
" 	    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
" 	elseif luasnip.jumpable(-1) then
" 	    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
" 	else
" 	    fallback()
" 	end
" 	end,

lua << EOF

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

local luasnip = require 'luasnip'

local cmp = require 'cmp'
cmp.setup({
completion = {
	autocomplete = false
	},
snippet = {
	expand = function(args)
	require('luasnip').lsp_expand(args.body)
	end,
	},
mapping = {
	['<C-p>'] = cmp.mapping.select_prev_item(),
	['<C-n>'] = cmp.mapping.select_next_item(),
	['<C-d>'] = cmp.mapping.scroll_docs(-4),
	['<C-f>'] = cmp.mapping.scroll_docs(4),
	['<C-Space>'] = cmp.mapping.complete(),
	['<C-e>'] = cmp.mapping.close(),
	['<CR>'] = cmp.mapping.confirm {
		behavior = cmp.ConfirmBehavior.Replace,
		select = true,
		},


		
	},
sources = {
	{ name = 'nvim_lsp' },
	{ name = 'luasnip' },
	},
formatting = {
	format = function(entry, vim_item)
	vim_item.kind = ({
	Text = "Text",
	Method = "Method",
	Function = "Function",
	Constructor = "Constructor",
	Field = "Field",
	Variable = "Variable",
	Class = "Class",
	Module = "Module",
	Property = "Property",
	Value = "Value",
	Enum = "Enum",
	Snippet = "Snippet",
	})[vim_item.kind]
vim_item.menu = ({
nvim_lsp = "[LSP]",
treesitter = "[TreeSitter]",
luasnip = "[LuaSnip]",
buffer = "[Buffer]",
})[entry.source.name]
return vim_item
end,
},
})

-- Setup lspconfig.
require('lspconfig').solargraph.setup{
capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

require("luasnip/loaders/from_vscode").load({ paths = { "~/.config/nvim/snippets/friendly-snippets-main" } })
-- require("luasnip/loaders/from_vscode").load()
-- require("luasnip/loaders/from_vscode").lazy_load()
EOF



lua << EOF
local nvim_lsp = require('lspconfig')


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

-- Enable completion triggered by <c-x><c-o>
buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

-- Mappings.
local opts = { noremap=true, silent=true }

-- See `:help vim.lsp.*` for documentation on any of the below functions
buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'gopls', 'tsserver' }


for _, lsp in ipairs(servers) do
nvim_lsp[lsp].setup {
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 150,
		}
	}
end
EOF



" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if v:version < 700 || exists('loaded_bclose') || &cp
	finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
	let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
	echohl ErrorMsg
	echomsg a:msg
	echohl NONE
endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)
	if empty(a:buffer)
		let btarget = bufnr('%')
	elseif a:buffer =~ '^\d\+$'
		let btarget = bufnr(str2nr(a:buffer))
	else
		let btarget = bufnr(a:buffer)
	endif
	if btarget < 0
		call s:Warn('No matching buffer for '.a:buffer)
		return
	endif
	if empty(a:bang) && getbufvar(btarget, '&modified')
		call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
		return
	endif
	" Numbers of windows that view target buffer which we will delete.
	let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
	if !g:bclose_multiple && len(wnums) > 1
		call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
		return
	endif
	let wcurrent = winnr()
	for w in wnums
		execute w.'wincmd w'
		let prevbuf = bufnr('#')
		if prevbuf > 0 && buflisted(prevbuf) && prevbuf != btarget
			buffer #
		else
			bprevious
		endif
		if btarget == bufnr('%')
			" Numbers of listed buffers which are not the target to be deleted.
			let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
			" Listed, not target, and not displayed.
			let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
			" Take the first buffer, if any (could be more intelligent).
			let bjump = (bhidden + blisted + [-1])[0]
			if bjump > 0
				execute 'buffer '.bjump
			else
				execute 'enew'.a:bang
			endif
		endif
	endfor
	execute 'bdelete'.a:bang.' '.btarget
	execute wcurrent.'wincmd w'
endfunction

command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose(<q-bang>, <q-args>)

nnoremap <silent> <Leader>bd :Bclose<CR>
snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
