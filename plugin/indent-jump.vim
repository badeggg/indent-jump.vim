"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Jump between lines based on indentation
"         <leader>i : jump to next     line with same indentation
" <leader><leader>i : jump to previous line with same indentation
"         <leader>u : jump to next     line with less indentation
" <leader><leader>u : jump to previous line with less indentation
"         <leader>o : jump to next     line with more indentation
" <leader><leader>o : jump to previous line with more indentation
"
" Letter usage explanation:
" 'i' represents indentation.
" 'u' is used since it sit at the left of letter 'i' on keyboard
" 'o' is used since it sit at the right of letter 'i' on keyboard
"
"""""" ↓↓↓

" Find the jump target based on indentation. The precise description is that,
" find the first line(not counting empty lines) which has the same/less/more
" indentation level compared to current line in the specified direction,
" exception is that when level is 0(same level), and the same indentation lines
" construct a continuous block(not counting empty lines), the target line shold
" be the last line of the block in the specified direction.
"
" It returns a keystroke sequence string which can move the cursor to the target
" line, e.g. '20G' to move cursor to line 20, or an empty stirng if no
" target is found.
"
" direction: 1 for forward (down), -1 for backward (up)
"     level: 0 for same, 1 for more, -1 for less
function! IndentJump(direction, level)
    let l:ref_line = line('.')
    let l:current_indent = indent(ref_line)

    " Search from ref_line.
    let l:lnum = ref_line + a:direction

    let l:last_same_indentation_line = 0
    let l:is_continuous = 1
    while lnum > 0 && lnum <= line('$')
        " Skip empty or whitespace-only lines
        if getline(lnum) =~ '^\s*$'
            let l:lnum += a:direction
            continue
        endif

        let l:target_indent = indent(lnum)

        if a:level == 0
           \ && target_indent == current_indent
           \ && !is_continuous
            return lnum . 'G'
        endif

        if a:level == 0
           \ && target_indent != current_indent
           \ && is_continuous
           \ && last_same_indentation_line
            return last_same_indentation_line . 'G'
        endif

        " Check based on the requested level
        if (a:level == 1 && target_indent > current_indent) ||
           \ (a:level == -1 && target_indent < current_indent)
            return lnum . 'G'
        endif

        if target_indent == current_indent
            let l:last_same_indentation_line = lnum
        endif

        if target_indent != current_indent
            let l:is_continuous = 0
        endif

        let l:lnum += a:direction
    endwhile

    if a:level == 0
       \ && is_continuous
       \ && last_same_indentation_line
        return last_same_indentation_line . 'G'
    endif

    return '' " No target found
endfunction

" Key mappings in normal mode
nnoremap <expr>         <leader>i IndentJump( 1,  0)
nnoremap <expr> <leader><leader>i IndentJump(-1,  0)
nnoremap <expr>         <leader>u IndentJump( 1, -1)
nnoremap <expr> <leader><leader>u IndentJump(-1, -1)
nnoremap <expr>         <leader>o IndentJump( 1,  1)
nnoremap <expr> <leader><leader>o IndentJump(-1,  1)


" Key mappings in visual mode
vnoremap <expr>         <leader>i IndentJump( 1,  0)
vnoremap <expr> <leader><leader>i IndentJump(-1,  0)
vnoremap <expr>         <leader>u IndentJump( 1, -1)
vnoremap <expr> <leader><leader>u IndentJump(-1, -1)
vnoremap <expr>         <leader>o IndentJump( 1,  1)
vnoremap <expr> <leader><leader>o IndentJump(-1,  1)

"""""" ↑↑↑
" Jump between lines based on indentation 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
