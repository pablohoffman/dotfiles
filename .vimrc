set nocompatible       " vi--

set smarttab           " tabulacion, indentacion, etc
set shiftwidth=4
set expandtab
set tabstop=8
set smartindent
set autoindent

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
set background=light   " para conservar la vista hasta los 80
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
set backspace=indent,eol,start

au Bufenter *.json set filetype=javascript
au Bufenter master.cfg set filetype=python " buildbot
au BufRead *-sup.* set ft=mail

augroup filetypedetect 
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig 
augroup END 

augroup filetype
    au! BufRead,BufNewFile *.proto setfiletype proto
augroup end

" custom key bindings

set backspace=indent,eol,start
" para hacer word wrap de parrafos al escribir mails
noremap Q gq}
map ,w :w<CR>
map ,q :qa<CR>
map ,x :wq<CR>
map ,d :bd<CR>
map ,n :bn<CR>
map ,p :bp<CR>
map ,, :noh<CR>
map ,e :tabedit 
map ,y :!pylint %<CR>
map ,au :!hg annotate -u % \| less<CR>
" Mercurial diff
map ,md :!hg cat % \| vim -R - -c ":vert diffsplit %"<CR>

" spell check (inline)
nmap ,se :set spell spelllang=en<CR>
nmap ,sp :set spell spelllang=es<CR>
nmap ,ss :set spell spelllang=<CR>

" spell check (aspell)
"map ,ss :w!<CR>:!aspell check --lang=es -e %<CR>:e! %<CR>
"map ,se :w!<CR>:!aspell check --lang=en -e %<CR>:e! %<CR>


" diferencias del archivo actual con la version del repo
function! SvnDiff()
    let ft = &ft
    let fp = expand("%:p:h")
    let fn = expand("%:t")
    execute ":vertical belowright diffsplit ".fp."/.svn/text-base/".fn.".svn-base"
    execute ":set filetype=".ft
    execute ":wincmd h"
    unlet fp fn ft
endfunction
nmap ,v :call SvnDiff()<CR>

" diferencias del archivo actual con la version del repo
function! SvnUnDiff()
    execute ":bd"
    execute ":diffoff"
endfunction
nmap ,V :call SvnUnDiff()<CR>

"set tabline=%!MyTabLine()

" Tabs {{{
" This is an attempt to emulate the default Vim-7 tabs as closely as possible but with numbered tabs.

" TODO: set truncation when tabs don't fit on line, see :h columns
if exists("+showtabline")
    source ~/.vim/tabline.vim
endif
" }}}

if exists("$HAVEACK")
    set grepprg=ack-grep\ -a\ $*
endif

