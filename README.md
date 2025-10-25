## Jump between lines based on indentation.

```
        <leader>i : jump to next     line with same indentation
<leader><leader>i : jump to previous line with same indentation
        <leader>u : jump to next     line with less indentation
<leader><leader>u : jump to previous line with less indentation
        <leader>o : jump to next     line with more indentation
<leader><leader>o : jump to previous line with more indentation
```

#### Letter usage explanation:
- 'i' represents indentation.
- 'u' is used since it sit at the left of letter 'i' on keyboard
- 'o' is used since it sit at the right of letter 'i' on keyboard

#### Notices
- All key mappings work both in normal mode visual mode
- Empty lines are ignored
- Whitespace-only lines are considered as empty lines
- When trying to find next same indentation line, and from current line multiple
  same indentation lines construct a continuous block, the target line is the last
  line of the block in the specified direction.

## Jump between empty lines.

```
        <leader>e : jump to next     empty line
<leader><leader>e : jump to previous empty line
```

#### Letter usage explanation:
- 'e' represents empty.

#### Notices
- All key mappings work both in normal mode visual mode
- Whitespace-only lines are considered as empty lines
- When trying to find next empty line, and from current line multiple
  empty lines construct a continuous block, the target line is the next
  empty line outside the block in the specified direction.
