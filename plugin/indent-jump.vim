" Find the jump target based on indentation. The precise description is that,
" find the first line(not counting empty lines) which has the same/less/more
" indentation level compared to current line in the specified direction,
" exception is that when level is 0(same level), and the same indentation lines
" construct a continuous block(not counting empty lines), the target line is
" the last line of the block in the specified direction.
"
" It returns a keystroke sequence string which can move the cursor to the target
" line, e.g. '20G' to move cursor to line 20, or an empty stirng if no
" target is found.
"
" direction: 1 for forward (down), -1 for backward (up)
"     level: 0 for same, 1 for more, -1 for less
function! IndentJump(direction, level)
    " Search from next line.
    let l:lnum = line('.') + a:direction
    let l:last_same_indentation_line = 0
    let l:is_continuous = 1
    let l:target_indent = getline(line('.')) =~ '^\s*$' ? -1 : indent('.')
    while l:lnum > 0 && l:lnum <= line('$')
        if getline(l:lnum) =~ '^\s*$'
            " Skip empty or whitespace-only lines
            let l:lnum += a:direction
            continue
        elseif l:target_indent == -1
            " Now we know what indent to find
            let l:target_indent = indent(l:lnum)
            let l:lnum += a:direction
            continue
        endif

        if l:target_indent == -1
            " Current line is in an empty line block, we have not figure out
            " the target indent to find..
            let l:lnum += a:direction
            continue
        endif

        let l:line_indent = indent(l:lnum)

        if a:level == 0
           \ && l:line_indent == l:target_indent
           \ && !l:is_continuous
            return l:lnum . 'G'
        endif

        if a:level == 0
           \ && l:line_indent != l:target_indent
           \ && l:is_continuous
           \ && l:last_same_indentation_line
            return l:last_same_indentation_line . 'G'
        endif

        " Check based on the requested level
        if (a:level == 1 && l:line_indent > l:target_indent) ||
           \ (a:level == -1 && l:line_indent < l:target_indent)
            return l:lnum . 'G'
        endif

        if l:line_indent == l:target_indent
            let l:last_same_indentation_line = l:lnum
        endif

        if l:line_indent != l:target_indent
            let l:is_continuous = 0
        endif

        let l:lnum += a:direction
    endwhile

    if a:level == 0
       \ && l:is_continuous
       \ && l:last_same_indentation_line
        return l:last_same_indentation_line . 'G'
    endif

    return '' " No target found
endfunction

" Find the next empty or whitespace-only line, which is not at the same
" block as current line, in the specified direction. By 'block', we mean
" few continuous empty lines.
"
" It returns a keystroke sequence string which can move the cursor to the target
" line, e.g. '20G' to move cursor to line 20, or an empty stirng if no
" target is found.
"
" direction: 1 for forward (down), -1 for backward (up)
function! JumpToEmptyLine(direction)
    " Search from next line
    let l:lnum = line('.') + a:direction
    let l:is_continuous = 1
    while l:lnum > 0 && l:lnum <= line('$')
        if getline(l:lnum) !~ '^\s*$'
            let l:is_continuous = 0
        elseif !l:is_continuous
            " Have found
            return l:lnum . 'G'
        endif

        let l:lnum += a:direction
    endwhile

    return '' " No target found
endfunction

" Key mappings in normal mode
nnoremap <expr>         <leader>i      IndentJump( 1,  0)
nnoremap <expr> <leader><leader>i      IndentJump(-1,  0)
nnoremap <expr>         <leader>u      IndentJump( 1, -1)
nnoremap <expr> <leader><leader>u      IndentJump(-1, -1)
nnoremap <expr>         <leader>o      IndentJump( 1,  1)
nnoremap <expr> <leader><leader>o      IndentJump(-1,  1)
nnoremap <expr>         <leader>e JumpToEmptyLine(1)
nnoremap <expr> <leader><leader>e JumpToEmptyLine(-1)


" Key mappings in visual mode
vnoremap <expr>         <leader>i      IndentJump( 1,  0)
vnoremap <expr> <leader><leader>i      IndentJump(-1,  0)
vnoremap <expr>         <leader>u      IndentJump( 1, -1)
vnoremap <expr> <leader><leader>u      IndentJump(-1, -1)
vnoremap <expr>         <leader>o      IndentJump( 1,  1)
vnoremap <expr> <leader><leader>o      IndentJump(-1,  1)
vnoremap <expr>         <leader>e JumpToEmptyLine(1)
vnoremap <expr> <leader><leader>e JumpToEmptyLine(-1)
