set smarttab           " tabulacion, indentacion, etc
set shiftwidth=4
set expandtab
set tabstop=8
set smartindent
set autoindent

filetype plugin indent on

set hlsearch
set showmatch          " al insertar closing brackets mostrar el opening bracket
set incsearch          " busqueda incremental (no recomendada para terminales lentas)
set ignorecase         " ignorar mayusculas/minusculas en las busquedas
if exists("+foldmethod")
    set foldmethod=marker  " foldmethod por defecto
endif
set showcmd            " que muestre en la barra de estado el progreso de los comandos (ej: 23gg)
set pastetoggle=<F11>  " para habilitar y deshabilitar rapido el modo paste 
set hidden             " para poder switchear buffers sin grabar
set ruler              " mostrar linea y columna en la barra de estado
set wildmenu           " mostrar menu scrollable al buscar archivos
set wildmode=list:longest,full  " que al primer TAB muestre lista completa y con el segundo recorrar los files

syntax on

highlight Folded ctermfg=black

" tab completion
function! CleverTab()
	if strpart(getline("."), 0, col('.')-1) =~ '^\s*$'
		return "\<TAB>"
	else
		return "\<C-N>"
	endfunction
inoremap <TAB> <C-R>=CleverTab()<CR>

au bufenter file-p set noswapfile

" custom key bindings
set backspace=indent,eol,start
map ,w :w<CR>
map ,q :qa<CR>
map ,x :wq<CR>
map ,d :bd<CR>
map ,n :bn<CR>
map ,p :bp<CR>
map ,, :noh<CR>
map ,e :tabedit 
map ,y :!python /usr/bin/pylint %<CR>

" spell check (inline)
nmap ,se :set spell spelllang=en<CR>
nmap ,sp :set spell spelllang=es<CR>
nmap ,ss :set spell spelllang=<CR>

" paste X clipboard
nmap ,v "+gP

" Tabs {{{
" This is an attempt to emulate the default Vim-7 tabs as closely as possible but with numbered tabs.

" TODO: set truncation when tabs don't fit on line, see :h columns
if exists("+showtabline")
    source ~/.vim/tabline.vim
endif
" }}}
