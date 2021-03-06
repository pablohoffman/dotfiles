function MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        " set up some oft-used variables
        let tab = i + 1 " range() starts at 0
        let winnr = tabpagewinnr(tab) " gets current window of current tab
        let buflist = tabpagebuflist(tab) " list of buffers associated with the windows in the current tab
        let bufnr = buflist[winnr - 1] " current buffer number
        let bufname = bufname(bufnr) " gets the name of the current buffer in the current window of the current tab

        let s .= '%' . tab . 'T' " start a tab
        let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#') " if this tab is the current tab...set the right highlighting
        let s .= ' ' . tab " current tab number
        let n = tabpagewinnr(tab,'$') " get the number of windows in the current tab
        if n > 1
            let s .= ':' . n " if there's more than one, add a colon and display the count
        endif
        let bufmodified = getbufvar(bufnr, "&mod")
        if bufmodified
            let s .= ' +'
        endif
        if bufname != ''
            let s .= ' ' . pathshorten(bufname) . ' ' " outputs the one-letter-path shorthand & filename
        else
            let s .= ' [No Name] '
        endif
    endfor
    let s .= '%#TabLineFill#' " blank highlighting between the tabs and the righthand close 'X'
    let s .= '%T' " resets tab page number?
    let s .= '%=' " seperate left-aligned from right-aligned
    let s .= '%#TabLine#' " set highlight for the 'X' below
    let s .= '%999XX' " places an 'X' at the far-right
    return s
endfunction
set tabline=%!MyTabLine()

map ,1 1gt
map ,2 2gt
map ,3 3gt
map ,4 4gt
map ,5 5gt
map ,6 6gt
map ,7 7gt
map ,8 8gt
map ,9 9gt

" open file under cursor in tabs
map gf <C-w>gf
