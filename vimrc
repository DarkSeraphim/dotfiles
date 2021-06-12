" We load everything in .vim. Neovim supports this :)
set nocompatible

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
" NERDTree is our file tree
Plug 'preservim/nerdtree'
" airline provides the nice status bar. Also integrates with ALE for showing
" the first error.
Plug 'vim-airline/vim-airline'
" File information
Plug 'preservim/tagbar'
" Git conflict resolving \o/
Plug 'tpope/vim-fugitive'

" These are highlighting plugins, per language
" Plug 'udalov/kotlin-vim'
" Plug 'vim-python/python-syntax'
" Plug 'leafgarland/typescript-vim'
" Plug 'elixir-editors/vim-elixir'
" Plug 'zigford/vim-powershell'
" Plug 'evanleck/vim-svelte'
" Plug 'hashivim/vim-terraform'
Plug 'sheerun/vim-polyglot'
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

" Allow us to do things based on file type (see vim/ftplugin)
filetype plugin on

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

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <a-cr> :CocFix<CR> 
inoremap <expr> ^[^M :CocFix<CR>



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
autocmd vimenter * NERDTree
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

" Some more meme stuff
set statusline+=%{g:Catium()}
set laststatus=2
