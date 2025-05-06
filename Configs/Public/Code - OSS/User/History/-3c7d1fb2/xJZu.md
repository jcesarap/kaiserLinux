# Foreword
- Ranger - Handles file management and fzf.
    - It opens new windows of nvim with 'o,n', or in the same window with enter.
- Tabs - Are distracting. As a coincidence, a day before you switched to NeoVim, having many tabs on VSCode was distracting you from work by making you anticipate all you have to do...
    - ...instead of just having one thing in front of you at any time.

# Freedom
- As you can program your window manager and bash, you can extend text editors without extending the programs - therefore, **worry not of relying on nvim**

# Keyboard shortcuts
- Ctrl+0 = Clean last search pattern
- ? = Search backwards
- f = go to symbol
    - F = same, backwards
- Ctrl+S = Save, Normal mode
- number+gg = skip to line
- _ = First character of a line
- I = Insert from beginning of line
- A = Insert from end of line
- f/F = Go to character (can be stacked with other shortcuts, such as deleting, inserting, replacing...)
    - ; , = Repeat the movement from above, backwards on ahead.
- g_ = $
- O = o, but line above
- :s/pattern/replace/g      -       To search and replace
- ~ = switches case (works with multi-cursor)
- dd = delete/cut (in this case, a line)
- Ctrl+R = Re-do
- Space+F = ranger on current directory
- Ctrl+J/K = Move view without moving cursor

## Multi-Cursor - vim-visual-multi
- Ctrl + Arrows = Column Selection
    - Go to end or beginning of line
    - Skip words
    - i = press it after selection
        - Esc = Return to normal mode, while keeping selections
- Q = Undo cursor
- q = Skip next match
- Ctrl + N = Select next match
> Otherwise use regex - learn so you can use it in all sorts of places.

# Regex
https://aaronbos.dev/posts/find-and-replace-neovim

# Macros
- q + register (any key) = Record
- @ + register = Play
- @ + @ = Play Last

# Plugins
- image.nvim - Render markdown images.
- Indent blankline - Indicate indentation.
- lsp-zero, cmp-nvim-lsp, nvim-cmp, nvim-lspconfig, nvim-treesitter - Code highlighting, auto-completion (incomplete).
- Telescope-fzf (and recent files)
- ultimate auto pair
- vim-visual-multi - to handle multi-cursor
- LuaSnip - (also dependency for auto-completion)
## Keyboard shortcuts
- Ctrl+j & k for scroll up and down
- Markdown image/finder loader (open finder on path of current file)
- Telescope - Ctrl+f & g
- Select all
