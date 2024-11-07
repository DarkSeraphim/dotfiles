" We load everything in .vim. Neovim supports this :)
set nocompatible
set modeline
set modelines=5

let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
" You might have to close a window manually after a new plugin was added
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')

" Let the plugging begin!
" ALE is our linting engine
Plug 'dense-analysis/ale'
" CoC is our completion engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-scripts/dbext.vim'
" NERDTree is our file tree
Plug 'preservim/nerdtree'
" airline provides the nice status bar. Also integrates with ALE for showing
" the first error.
Plug 'vim-airline/vim-airline'
" File information
Plug 'preservim/tagbar'
" Git conflict resolving \o/
Plug 'tpope/vim-fugitive'
" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'unblevable/quick-scope'

Plug 'nvim-lua/plenary.nvim'

" Telescope
Plug 'nvim-telescope/telescope.nvim', { 'branch': 'master'}
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Neotest
Plug 'vim-test/vim-test'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-neotest/nvim-nio'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-vim-test'

" Indent line guides
Plug 'lukas-reineke/indent-blankline.nvim'

" These are highlighting plugins, per language
" Plug 'udalov/kotlin-vim'
" Plug 'vim-python/python-syntax'
" Plug 'leafgarland/typescript-vim'
" Plug 'elixir-editors/vim-elixir'
" Plug 'zigford/vim-powershell'
" Plug 'evanleck/vim-svelte'
" Plug 'hashivim/vim-terraform'
Plug 'sheerun/vim-polyglot'
Plug 'rfratto/vim-river'

" Memes
Plug 'edvb/catium.vim'
Plug 'koron/nyancat-vim'

" And themes
Plug 'doums/darcula'

call plug#end()

" Defaults for my tabbing. I have no good idea what the exact difference is
" (aside from expandtabs)
" ts = tabstop, sts = softtabstop, et = expandtabs.
set ts=2
set sts=2
set shiftwidth=2
set et

" Folding with treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable

" Allow us to do things based on file type (see vim/ftplugin)
filetype plugin on

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

autocmd FileType * if &ft ==# 'yaml' | nnoremap <buffer> <CR> za | endif

" Always have our sign gutter enabled, keeps the width consistent
let g:ale_sign_column_always = 1
" Only lint with what we tell you to lint with
let g:ale_linters_explicit = 1
" Artifact of the past, we have CoC now
" let g:ale_completion_enabled = 0
let g:terraform_align = 1
" highlight ALEError ctermbg=180

" Change to whatever theme you have installed
colorscheme darcula
" Supposedly makes the autocomplete window transparent
hi Quote ctermbg=109 guifg=#83a598


fun! SetupCommandAlias(from, to)
	  exec 'cnoreabbrev <expr> '.a:from
	      \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

function! SetupCommandAbbrs(from, to)
    exec 'cnoreabbrev <expr> '.a:from
            \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
            \ .'? ("'.a:to.'") : ("'.a:from.'"))'
  endfunction

set updatetime=300
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')
inoremap <silent><expr> <c-space> coc#refresh()
nnoremap <silent> <A-enter> <Plug>(coc-codeaction-selected)

" Use K to show documentation in preview window.
nnoremap <silent> <leader>h :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif


" Time for some fugitive config
" command Gresolve :Gvdiffsplit! 
nnoremap <silent> m<Left> :diffget //2<CR>
nnoremap <silent> m<Right> :diffget //3<CR>

" Screw typos!
call SetupCommandAlias("W","w")
call SetupCommandAlias("Wq","wq")
call SetupCommandAlias("WQ","wq")
call SetupCommandAlias("Q","q")

" Start with our file tree enabled
" autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
" Exit vim if our last open buffer is the file tree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Remap ctrl+IJKL as single keystroke buffer navigation
" (e.g. ctrl+I goes to the buffer above it, ctrl+J to the left, etc)
nnoremap <C-I> <C-W><C-I>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-J> <C-W><C-H>
" Navigate between linting errors
nmap <silent> <C-z> <Plug>(ale_previous_wrap)
nmap <silent> <C-x> <Plug>(ale_next_wrap)

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
endif

if has('nvim')
  lua <<EOF
require("neotest").setup({
  adapters = {
    require("neotest-vim-test")({
      ignore_file_types = { "python", "vim", "lua" },
    }),
  },
})
local telescope = require("telescope")

local select_one_or_multi = function(prompt_bufnr)
  local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()

  if vim.tbl_isempty(multi) then
    require('telescope.actions').select_default(prompt_bufnr)
    return
  end

  require('telescope.actions').close(prompt_bufnr)
  for _, entry in pairs(multi) do
    local filename = entry.filename or entry.value
    local lnum = entry.lnum or 1
    local lcol = entry.col or 1
    if filename then
      vim.cmd(string.format("tabnew +%d %s", lnum, filename))
      vim.cmd(string.format("normal! %dG%d|", lnum, lcol))
    end
  end
end

telescope.load_extension("fzf")
telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<CR>'] = select_one_or_multi,
      },
      n = {
        ['<CR>'] = select_one_or_multi,
      }
    }
  },
  pickers = {
    find_files = {
      hidden = true,
			find_command = { "rg", "--files", "--glob", "!**/.git/*" },
    }
  }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require("ibl").setup {
      \ indent = { highlight = {"CursorColumn", "Whitespace", } }
    \ }

EOF
endif

command RunTests lua require('neotest').run.run(vim.fn.expand('%'))
command OpenTestOutput lua require('neotest').output.open({enter = true})
command ToggleTestSummary lua require("neotest").summary.toggle()

" Some more meme stuff
set statusline+=%{g:Catium()}
set laststatus=2
