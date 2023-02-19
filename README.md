# Matchit: BrightScript (neovim)

- Install with packer

```lua
use {
  "enthooz/vim-matchit-brightscript"
  config = function()
    require("vim-matchit-brightscript").setup()
  end,
}
```

- Add [Matchit](https://github.com/adelarsq/vim-matchit) `match_words` for BrightScript.
- Works with neovim.
- Case-insensitive.

Supports:

- `function` .. `end function`
- `sub` .. `end sub`
- `if` .. `else if` .. `else` .. `end`
- `for` .. `to` .. `end for` .. `step` .. `exit for`
- `for each` .. `in` .. `end for` .. `exit for`
- `while` .. `end while` .. `exit while`
- `try` .. `catch` .. `end try`

## Known Issues

Doesn't quite work properly with `for` loops and `while` loops.
