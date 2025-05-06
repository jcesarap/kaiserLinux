-- Keybindings (qwerty).

-- DESCRIPTION:
-- All mappings are defined here.

--    Sections:
--       ## Base bindings
--       -> icons displayed on which-key.nvim
--       -> standard operations
--       -> clipboard
--       -> search highlighting
--       -> improved tabulation
--       -> improved gg
--       -> packages
--       -> buffers/tabs                       [buffers]
--       -> ui toggles                         [ui]
--       -> shifted movement keys
--       -> cmdline autocompletion
--       -> special cases

--       ## Plugin bindings
--       -> alpha-nvim
--       -> git                                [git]
--       -> file browsers
--       -> session manager
--       -> smart-splits.nvim
--       -> aerial.nvim
--       -> litee-calltree.nvim
--       -> telescope.nvim                     [find]
--       -> toggleterm.nvim
--       -> dap.nvim                           [debugger]
--       -> tests                              [tests]
--       -> nvim-ufo
--       -> code documentation                 [docs]
--       -> ask chatgpt                        [neural]
--       -> hop.nvim
--       -> mason-lspconfig.nvim               [lsp]

--
--   KEYBINDINGS REFERENCE
--   -------------------------------------------------------------------
--   |        Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
--   Command        +------+-----+-----+-----+-----+-----+------+------+
--   [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
--   n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
--   [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
--   i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
--   c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
--   v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
--   x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
--   s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
--   o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
--   t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
--   l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
--   -------------------------------------------------------------------

local M = {}
local utils = require("base.utils")
local get_icon = utils.get_icon
local is_available = utils.is_available
local ui = require("base.utils.ui")
local maps = require("base.utils").get_mappings_template()
local is_android = vim.fn.isdirectory('/data') == 1 -- true if on android

-- -------------------------------------------------------------------------
--
-- ## Base bindings ########################################################
--
-- -------------------------------------------------------------------------


-- Making a vim bridge between its pure form, and what you have now, is precisely what you need to transition
-- Valknutr this... Just make it usable for config files... use Codium for everything else.

-- "=" Fixes indentation
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.api.nvim_set_keymap('n', '<C-/>', ':let @/=""<CR>:nohlsearch<CR>', { noremap = true, silent = true })
-- Remap move view without moving cursor
-- Remap Ctrl+j to scroll down (like Ctrl+e)
vim.api.nvim_set_keymap('n', '<C-j>', '<C-e>', { noremap = true, silent = true })
-- Remap Ctrl+k to scroll up (like Ctrl+y)
vim.api.nvim_set_keymap('n', '<C-k>', '<C-y>', { noremap = true, silent = true })

-- Markdown Images
-- --- --- --- Logic: Get path of running file, add currently selected line to it, remove surroundings of markdown image syntax, export value to variable, open script that uses such variable to run something
local modified_path = ""  -- Initialize a variable to hold the path
vim.keymap.set('n', '<C-i>', function()
  local dir_path = vim.fn.expand('%:p:h')
  local selected_line = vim.fn.getline('.')
  modified_path = dir_path .. "/" .. selected_line

  -- Remove ![]() characters from the modified path
  modified_path = modified_path:gsub('[!%[%]()]', '')

  -- Export the cleaned-up path and run the command in one shell invocation
  os.execute('export selected="' .. modified_path .. '" && export selected_path="' .. modified_path .. '" && nohup ~/Dropbox/Kaiser-Linux/Scripts/rofi/finder.sh openwithrofi > /dev/null 2>&1 &')
end)

-- Luasnips
vim.cmd[[
" Use Tab to expand and jump through snippets/nodes
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

" Use Shift-Tab to jump backwards through snippets/nodes
imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
]]


-- Telescope
--vim.api.nvim_set_keymap("n", "<C-g>", [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]], {noremap = true, silent = true})
--vim.api.nvim_set_keymap('n', '<C-f>', ':Telescope find_files<CR>', { noremap = true, silent = true }) -- Telescope
vim.api.nvim_set_keymap("n", "<C-g>", [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-f>', ':Telescope find_files<CR>', { noremap = true, silent = true }) -- Telescope
vim.api.nvim_set_keymap('n', '<C-S-f>', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })

-- Shift + Arrow Selection
vim.api.nvim_set_keymap('n', '<S-Up>', 'v<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Down>', 'v<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Left>', 'v<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Right>', 'v<Right>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('v', '<S-Up>', '<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Down>', '<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Left>', '<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Right>', '<Right>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('i', '<S-Up>', '<Esc>v<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Down>', '<Esc>v<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Left>', '<Esc>v<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Right>', '<Esc>v<Right>', { noremap = true, silent = true })

-- Clipboard Operations
vim.opt.clipboard:append("unnamedplus")

-- Keybindings for Undo, Redo, and Select All
vim.api.nvim_set_keymap('n', '<C-z>', '<cmd>lua vim.cmd("undo")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-z>', '<cmd>lua vim.cmd("redo")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-a>', '<cmd>lua vim.cmd("normal! ggVG")<CR>', { noremap = true, silent = true })

-- Window and Save Commands
vim.api.nvim_set_keymap('n', '<C-w>', ':q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('i', '<C-w>', '<Esc>:q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('x', '<C-w>', '<Esc>:q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true })

-- New shortcut for :qa! (Close all without saving)
vim.api.nvim_set_keymap('n', '<C-S-w>', ':qa!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-S-w>', '<Esc>:qa!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<C-S-w>', '<Esc>:qa!<CR>', { noremap = true, silent = true })

-- Shift + Home, End, PgUp, PgDn Selection
vim.api.nvim_set_keymap('n', '<S-Home>', 'v<Home>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-End>', 'v<End>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Prior>', 'v<Prior>', { noremap = true, silent = true }) -- PgUp
vim.api.nvim_set_keymap('n', '<S-Next>', 'v<Next>', { noremap = true, silent = true })   -- PgDn

-- Options
vim.opt.number = true       -- Show absolute line numbers
vim.opt.relativenumber = true
vim.opt.mouse = 'a'         -- Enable mouse support


-- packages -----------------------------------------------------------------
-- lazy
maps.n["<leader>p"] = icons.p
maps.n["<leader>pu"] =
{ function() require("lazy").check() end, desc = "Lazy open" }
maps.n["<leader>pU"] =
{ function() require("lazy").update() end, desc = "Lazy update" }

-- mason
if is_available("mason.nvim") then
  maps.n["<leader>pm"] = { "<cmd>Mason<cr>", desc = "Mason open" }
  maps.n["<leader>pM"] = { "<cmd>MasonUpdateAll<cr>", desc = "Mason update" }
end

-- treesitter
if is_available("nvim-treesitter") then
  maps.n["<leader>pT"] = { "<cmd>TSUpdate<cr>", desc = "Treesitter update" }
  maps.n["<leader>pt"] = { "<cmd>TSInstallInfo<cr>", desc = "Treesitter open" }
end

-- nvim updater
maps.n["<leader>pD"] = { "<cmd>DistroUpdate<cr>", desc = "Distro update" }
maps.n["<leader>pv"] = { "<cmd>DistroReadVersion<cr>", desc = "Distro version" }
maps.n["<leader>pc"] = { "<cmd>DistroReadChangelog<cr>", desc = "Distro changelog" }

-- buffers/tabs [buffers ]--------------------------------------------------
maps.n["<leader>c"] = { -- Close window and buffer at the same time.
  function() require("heirline-components.buffer").wipe() end,
  desc = "Wipe buffer",
}
maps.n["<leader>C"] = { -- Close buffer keeping the window.
  function() require("heirline-components.buffer").close() end,
  desc = "Close buffer",
}
maps.n["<leader>bw"] = {     -- Closes the window
  function()
    vim.cmd("silent! close") -- Be aware you can't close the last window
  end,
  desc = "Close window",
}
-- Close buffer keeping the window → Without confirmation.
-- maps.n["<leader>X"] = {
--   function() require("heirline-components.buffer").close(0, true) end,
--   desc = "Force close buffer",
--
maps.n["<leader>ba"] = {
  function() vim.cmd("wa") end,
  desc = "Write all changed buffers",
}
maps.n["]b"] = {
  function()
    require("heirline-components.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
  end,
  desc = "Next buffer",
}
maps.n["[b"] = {
  function()
    require("heirline-components.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
  end,
  desc = "Previous buffer",
}
maps.n[">b"] = {
  function()
    require("heirline-components.buffer").move(vim.v.count > 0 and vim.v.count or 1)
  end,
  desc = "Move buffer tab right",
}
maps.n["<b"] = {
  function()
    require("heirline-components.buffer").move(-(vim.v.count > 0 and vim.v.count or 1))
  end,
  desc = "Move buffer tab left",
}

maps.n["<leader>b"] = icons.b
maps.n["<leader>bc"] = {
  function() require("heirline-components.buffer").close_all(true) end,
  desc = "Close all buffers except current",
}
maps.n["<leader>bC"] = {
  function() require("heirline-components.buffer").close_all() end,
  desc = "Close all buffers",
}
maps.n["<leader>bb"] = {
  function()
    require("heirline-components.all").heirline.buffer_picker(
      function(bufnr) vim.api.nvim_win_set_buf(0, bufnr) end
    )
  end,
  desc = "Select buffer from tabline",
}
maps.n["<leader>bd"] = {
  function()
    require("heirline-components.all").heirline.buffer_picker(
      function(bufnr) require("heirline-components.buffer").close(bufnr) end
    )
  end,
  desc = "Delete buffer from tabline",
}
maps.n["<leader>bl"] = {
  function() require("heirline-components.buffer").close_left() end,
  desc = "Close all buffers to the left",
}
maps.n["<leader>br"] = {
  function() require("heirline-components.buffer").close_right() end,
  desc = "Close all buffers to the right",
}
maps.n["<leader>bs"] = icons.bs
maps.n["<leader>bse"] = {
  function() require("heirline-components.buffer").sort "extension" end,
  desc = "Sort by extension (buffers)",
}
maps.n["<leader>bsr"] = {
  function() require("heirline-components.buffer").sort "unique_path" end,
  desc = "Sort by relative path (buffers)",
}
maps.n["<leader>bsp"] = {
  function() require("heirline-components.buffer").sort "full_path" end,
  desc = "Sort by full path (buffers)",
}
maps.n["<leader>bsi"] = {
  function() require("heirline-components.buffer").sort "bufnr" end,
  desc = "Sort by buffer number (buffers)",
}
maps.n["<leader>bsm"] = {
  function() require("heirline-components.buffer").sort "modified" end,
  desc = "Sort by modification (buffers)",
}
maps.n["<leader>b\\"] = {
  function()
    require("heirline-components.all").heirline.buffer_picker(function(bufnr)
      vim.cmd.split()
      vim.api.nvim_win_set_buf(0, bufnr)
    end)
  end,
  desc = "Horizontal split buffer from tabline",
}
maps.n["<leader>b|"] = {
  function()
    require("heirline-components.all").heirline.buffer_picker(function(bufnr)
      vim.cmd.vsplit()
      vim.api.nvim_win_set_buf(0, bufnr)
    end)
  end,
  desc = "Vertical split buffer from tabline",
}

-- quick buffer switching
maps.n["<C-k>"] = {
  function()
    require("heirline-components.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
  end,
  desc = "Next buffer",
}
maps.n["<C-j>"] = {
  function()
    require("heirline-components.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
  end,
  desc = "Previous buffer",
}

-- tabs
maps.n["]t"] = { function() vim.cmd.tabnext() end, desc = "Next tab" }
maps.n["[t"] = { function() vim.cmd.tabprevious() end, desc = "Previous tab" }

-- zen mode
if is_available("zen-mode.nvim") then
  maps.n["<leader>uz"] =
  { function() ui.toggle_zen_mode() end, desc = "Zen mode" }
end

-- ui toggles [ui] ---------------------------------------------------------
maps.n["<leader>u"] = icons.u
if is_available("nvim-autopairs") then
  maps.n["<leader>ua"] = { ui.toggle_autopairs, desc = "Autopairs" }
end
maps.n["<leader>ub"] = { ui.toggle_background, desc = "Background" }
if is_available("nvim-cmp") then
  maps.n["<leader>uc"] = { ui.toggle_cmp, desc = "Autocompletion" }
end
if is_available("nvim-colorizer.lua") then
  maps.n["<leader>uC"] =
  { "<cmd>ColorizerToggle<cr>", desc = "color highlight" }
end
maps.n["<leader>ud"] = { ui.toggle_diagnostics, desc = "Diagnostics" }
maps.n["<leader>uD"] = { ui.set_indent, desc = "Change indent setting" }
maps.n["<leader>ug"] = { ui.toggle_signcolumn, desc = "Signcolumn" }
maps.n["<leader>ul"] = { ui.toggle_statusline, desc = "Statusline" }
maps.n["<leader>un"] = { ui.change_number, desc = "Change line numbering" }
maps.n["<leader>uP"] = { ui.toggle_paste, desc = "Paste mode" }
maps.n["<leader>us"] = { ui.toggle_spell, desc = "Spellcheck" }
maps.n["<leader>uS"] = { ui.toggle_conceal, desc = "Conceal" }
maps.n["<leader>ut"] = { ui.toggle_tabline, desc = "Tabline" }
maps.n["<leader>uu"] = { ui.toggle_url_effect, desc = "URL highlight" }
maps.n["<leader>uw"] = { ui.toggle_wrap, desc = "Wrap" }
maps.n["<leader>uy"] = { ui.toggle_buffer_syntax, desc = "Syntax highlight (buffer)" }
maps.n["<leader>uh"] = { ui.toggle_foldcolumn, desc = "Foldcolumn" }
maps.n["<leader>uN"] =
{ ui.toggle_ui_notifications, desc = "UI notifications" }
if is_available("lsp_signature.nvim") then
  maps.n["<leader>up"] = { ui.toggle_lsp_signature, desc = "LSP signature" }
end
if is_available("mini.animate") then
  maps.n["<leader>uA"] = { ui.toggle_animations, desc = "Animations" }
end

-- shifted movement keys ----------------------------------------------------
maps.n["<S-Down>"] = {
  function() vim.api.nvim_feedkeys("7j", "n", true) end,
  desc = "Fast move down",
}
maps.n["<S-Up>"] = {
  function() vim.api.nvim_feedkeys("7k", "n", true) end,
  desc = "Fast move up",
}
maps.n["<S-PageDown>"] = {
  function()
    local current_line = vim.fn.line "."
    local total_lines = vim.fn.line "$"
    local target_line = current_line + 1 + math.floor(total_lines * 0.20)
    if target_line > total_lines then target_line = total_lines end
    vim.api.nvim_win_set_cursor(0, { target_line, 0 })
    vim.cmd("normal! zz")
  end,
  desc = "Page down exactly a 20% of the total size of the buffer",
}
maps.n["<S-PageUp>"] = {
  function()
    local current_line = vim.fn.line "."
    local target_line = current_line - 1 - math.floor(vim.fn.line "$" * 0.20)
    if target_line < 1 then target_line = 1 end
    vim.api.nvim_win_set_cursor(0, { target_line, 0 })
    vim.cmd("normal! zz")
  end,
  desc = "Page up exactly 20% of the total size of the buffer",
}

-- cmdline autocompletion ---------------------------------------------------
maps.c["<Up>"] = {
  function() return vim.fn.wildmenumode() == 1 and "<Left>" or "<Up>" end,
  noremap = true,
  expr = true,
  desc = "Wildmenu fix for neovim bug #9953",
}
maps.c["<Down>"] = {
  function() return vim.fn.wildmenumode() == 1 and "<Right>" or "<Down>" end,
  noremap = true,
  expr = true,
  desc = "Wildmenu fix for neovim bug #9953",
}
maps.c["<Left>"] = {
  function() return vim.fn.wildmenumode() == 1 and "<Up>" or "<Left>" end,
  noremap = true,
  expr = true,
  desc = "Wildmenu fix for neovim bug #9953",
}
maps.c["<Right>"] = {
  function() return vim.fn.wildmenumode() == 1 and "<Down>" or "<Right>" end,
  noremap = true,
  expr = true,
  desc = "Wildmenu fix for neovim bug #9953",
}

-- special cases ------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWinEnter", {
  desc = "Make q close help, man, quickfix, dap floats",
  callback = function(args)
    local buftype =
        vim.api.nvim_get_option_value("buftype", { buf = args.buf })
    if vim.tbl_contains({ "help", "nofile", "quickfix" }, buftype) then
      vim.keymap.set(
        "n", "q", "<cmd>close<cr>",
        { buffer = args.buf, silent = true, nowait = true }
      )
    end
  end,
})
vim.api.nvim_create_autocmd("CmdwinEnter", {
  desc = "Make q close command history (q: and q?)",
  callback = function(args)
    vim.keymap.set(
      "n", "q", "<cmd>close<cr>",
      { buffer = args.buf, silent = true, nowait = true }
    )
  end,
})

-- -------------------------------------------------------------------------
--
-- ## Plugin bindings
--
-- -------------------------------------------------------------------------

-- alpha-nvim --------------------------------------------------------------
if is_available("alpha-nvim") then
  maps.n["<leader>h"] = {
    function()
      local wins = vim.api.nvim_tabpage_list_wins(0)
      if #wins > 1
          and vim.api.nvim_get_option_value("filetype", { win = wins[1] })
          == "neo-tree"
      then
        vim.fn.win_gotoid(wins[2]) -- go to non-neo-tree window to toggle alpha
      end
      require("alpha").start(false, require("alpha").default_config)
      vim.b.miniindentscope_disable = true
    end,
    desc = "Home screen",
  }
end

-- [git] -----------------------------------------------------------
-- gitsigns.nvim
maps.n["<leader>g"] = icons.g
if is_available("gitsigns.nvim") then
  maps.n["<leader>g"] = icons.g
  maps.n["]g"] =
  { function() require("gitsigns").nav_hunk('next') end, desc = "Next Git hunk" }
  maps.n["[g"] = {
    function() require("gitsigns").nav_hunk('prev') end,
    desc = "Previous Git hunk",
  }
  maps.n["<leader>gl"] = {
    function() require("gitsigns").blame_line() end,
    desc = "View Git blame",
  }
  maps.n["<leader>gL"] = {
    function() require("gitsigns").blame_line { full = true } end,
    desc = "View full Git blame",
  }
  maps.n["<leader>gp"] = {
    function() require("gitsigns").preview_hunk() end,
    desc = "Preview Git hunk",
  }
  maps.n["<leader>gh"] = {
    function() require("gitsigns").reset_hunk() end,
    desc = "Reset Git hunk",
  }
  maps.n["<leader>gr"] = {
    function() require("gitsigns").reset_buffer() end,
    desc = "Reset Git buffer",
  }
  maps.n["<leader>gs"] = {
    function() require("gitsigns").stage_hunk() end,
    desc = "Stage Git hunk",
  }
  maps.n["<leader>gS"] = {
    function() require("gitsigns").stage_buffer() end,
    desc = "Stage Git buffer",
  }
  maps.n["<leader>gu"] = {
    function() require("gitsigns").undo_stage_hunk() end,
    desc = "Unstage Git hunk",
  }
  maps.n["<leader>gd"] = {
    function() require("gitsigns").diffthis() end,
    desc = "View Git diff",
  }
end
-- git fugitive
if is_available("vim-fugitive") then
  maps.n["<leader>gP"] = {
    function() vim.cmd(":GBrowse") end,
    desc = "Open in github ",
  }
end
-- git client
if vim.fn.executable "lazygit" == 1 then -- if lazygit exists, show it
  maps.n["<leader>gg"] = {
    function()
      local git_dir = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
      if git_dir ~= "" then
        vim.cmd("TermExec cmd='lazygit && exit'")
      else
        utils.notify("Not a git repository", vim.log.levels.WARN)
      end
    end,
    desc = "ToggleTerm lazygit",
  }
end
if vim.fn.executable "gitui" == 1 then -- if gitui exists, show it
  maps.n["<leader>gg"] = {
    function()
      local git_dir = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
      if git_dir ~= "" then
        if vim.fn.executable "keychain" == 1 then
          vim.cmd('TermExec cmd="eval `keychain --eval ~/.ssh/github.key` && gitui && exit"')
        else
          vim.cmd("TermExec cmd='gitui && exit'")
        end
      else
        utils.notify("Not a git repository", vim.log.levels.WARN)
      end
    end,
    desc = "ToggleTerm gitui",
  }
end

-- file browsers ------------------------------------
-- yazi
if is_available("yazi.nvim") and vim.fn.executable("yazi") == 1 then
  maps.n["<leader>r"] = {
    -- TODO: use 'Yazi toggle' instead once yazi v0.4.0 is released.
    "<cmd>Yazi<CR>",
    desc = "File browser",
  }
end

-- neotree
if is_available("neo-tree.nvim") then
  maps.n["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Neotree" }
end

-- session manager ---------------------------------------------------------
if is_available("neovim-session-manager") then
  maps.n["<leader>S"] = icons.S
  maps.n["<leader>Sl"] = {
    "<cmd>SessionManager! load_last_session<cr>",
    desc = "Load last session",
  }
  maps.n["<leader>Ss"] = {
    "<cmd>SessionManager! save_current_session<cr>",
    desc = "Save this session",
  }
  maps.n["<leader>Sd"] =
  { "<cmd>SessionManager! delete_session<cr>", desc = "Delete session" }
  maps.n["<leader>Sf"] =
  { "<cmd>SessionManager! load_session<cr>", desc = "Search sessions" }
  maps.n["<leader>S."] = {
    "<cmd>SessionManager! load_current_dir_session<cr>",
    desc = "Load current directory session",
  }
end
if is_available("resession.nvim") then
  maps.n["<leader>S"] = icons.S
  maps.n["<leader>Sl"] = {
    function() require("resession").load "Last Session" end,
    desc = "Load last session",
  }
  maps.n["<leader>Ss"] =
  { function() require("resession").save() end, desc = "Save this session" }
  maps.n["<leader>St"] = {
    function() require("resession").save_tab() end,
    desc = "Save this tab's session",
  }
  maps.n["<leader>Sd"] =
  { function() require("resession").delete() end, desc = "Delete a session" }
  maps.n["<leader>Sf"] =
  { function() require("resession").load() end, desc = "Load a session" }
  maps.n["<leader>S."] = {
    function()
      require("resession").load(vim.fn.getcwd(), { dir = "dirsession" })
    end,
    desc = "Load current directory session",
  }
end

-- smart-splits.nvim
if is_available("smart-splits.nvim") then
  maps.n["<C-h>"] = {
    function() require("smart-splits").move_cursor_left() end,
    desc = "Move to left split",
  }
  maps.n["<C-j>"] = {
    function() require("smart-splits").move_cursor_down() end,
    desc = "Move to below split",
  }
  maps.n["<C-k>"] = {
    function() require("smart-splits").move_cursor_up() end,
    desc = "Move to above split",
  }
  maps.n["<C-l>"] = {
    function() require("smart-splits").move_cursor_right() end,
    desc = "Move to right split",
  }
  maps.n["<C-Up>"] = {
    function() require("smart-splits").resize_up() end,
    desc = "Resize split up",
  }
  maps.n["<C-Down>"] = {
    function() require("smart-splits").resize_down() end,
    desc = "Resize split down",
  }
  maps.n["<C-Left>"] = {
    function() require("smart-splits").resize_left() end,
    desc = "Resize split left",
  }
  maps.n["<C-Right>"] = {
    function() require("smart-splits").resize_right() end,
    desc = "Resize split right",
  }
else
  maps.n["<C-h>"] = { "<C-w>h", desc = "Move to left split" }
  maps.n["<C-j>"] = { "<C-w>j", desc = "Move to below split" }
  maps.n["<C-k>"] = { "<C-w>k", desc = "Move to above split" }
  maps.n["<C-l>"] = { "<C-w>l", desc = "Move to right split" }
  maps.n["<C-Up>"] = { "<cmd>resize -2<CR>", desc = "Resize split up" }
  maps.n["<C-Down>"] = { "<cmd>resize +2<CR>", desc = "Resize split down" }
  maps.n["<C-Left>"] =
  { "<cmd>vertical resize -2<CR>", desc = "Resize split left" }
  maps.n["<C-Right>"] =
  { "<cmd>vertical resize +2<CR>", desc = "Resize split right" }
end


  -- Some lsp keymappings are here because they depend on telescope
  maps.n["<leader>l"] = icons.l
  maps.n["<leader>ls"] = {
    function()
      local aerial_avail, _ = pcall(require, "aerial")
      if aerial_avail then
        require("telescope").extensions.aerial.aerial()
      else
        require("telescope.builtin").lsp_document_symbols()
      end
    end,
    desc = "Search symbol in buffer", -- Useful to find every time a variable is assigned.
  }
  maps.n["gs"] = {
    function()
      local aerial_avail, _ = pcall(require, "aerial")
      if aerial_avail then
        require("telescope").extensions.aerial.aerial()
      else
        require("telescope.builtin").lsp_document_symbols()
      end
    end,
    desc = "Search symbol in buffer", -- Useful to find every time a variable is assigned.
  }

  -- extra - project.nvim
  if is_available("project.nvim") then
    maps.n["<leader>fp"] = {
      function() vim.cmd("Telescope projects") end,
      desc = "Find project",
    }
  end

  -- extra - spectre.nvim (search and replace in project)
  if is_available("nvim-spectre") then
    maps.n["<leader>fr"] = {
      function() require("spectre").toggle() end,
      desc = "Find and replace word in project",
    }
    maps.n["<leader>fb"] = {
      function() require("spectre").toggle { path = vim.fn.expand "%:t:p" } end,
      desc = "Find and replace word in buffer",
    }
  end

  -- extra - luasnip
  if is_available("LuaSnip") and is_available("telescope-luasnip.nvim") then
    maps.n["<leader>fs"] = {
      function() require("telescope").extensions.luasnip.luasnip {} end,
      desc = "Find snippets",
    }
  end

  -- extra - nvim-neoclip (neovim internal clipboard)
  --         Specially useful if you disable the shared clipboard in options.
  if is_available("nvim-neoclip.lua") then
    maps.n["<leader>fy"] = {
      function() require("telescope").extensions.neoclip.default() end,
      desc = "Find yank history",
    }
    maps.n["<leader>fq"] = {
      function() require("telescope").extensions.macroscope.default() end,
      desc = "Find macro history",
    }
  end

  -- extra - undotree
  if is_available("telescope-undo.nvim") then
    maps.n["<leader>fu"] = {
      function() require("telescope").extensions.undo.undo() end,
      desc = "Find in undo tree",
    }
  end

  -- extra - compiler
  if is_available("compiler.nvim") and is_available("overseer.nvim") then
    maps.n["<leader>m"] = icons.c
    maps.n["<leader>mm"] = {
      function() vim.cmd("CompilerOpen") end,
      desc = "Open compiler",
    }
    maps.n["<leader>mr"] = {
      function() vim.cmd("CompilerRedo") end,
      desc = "Compiler redo",
    }
    maps.n["<leader>mt"] = {
      function() vim.cmd("CompilerToggleResults") end,
      desc = "compiler results",
    }
    maps.n["<F6>"] = {
      function() vim.cmd("CompilerOpen") end,
      desc = "Open compiler",
    }
    maps.n["<S-F6>"] = {
      function() vim.cmd("CompilerRedo") end,
      desc = "Compiler redo",
    }
    maps.n["<S-F7>"] = {
      function() vim.cmd("CompilerToggleResults") end,
      desc = "compiler resume",
    }
  end
end

-- toggleterm.nvim ----------------------------------------------------------
if is_available("toggleterm.nvim") then
  maps.n["<leader>t"] = icons.t
  maps.n["<leader>tt"] =
  { "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" }
  maps.n["<leader>th"] = {
    "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
    desc = "Toggleterm horizontal split",
  }
  maps.n["<leader>tv"] = {
    "<cmd>ToggleTerm size=80 direction=vertical<cr>",
    desc = "Toggleterm vertical split",
  }
  maps.n["<F7>"] = { "<cmd>ToggleTerm<cr>", desc = "terminal" }
  maps.t["<F7>"] = maps.n["<F7>"]
  maps.n["<C-'>"] = maps.n["<F7>"] -- requires terminal that supports binding <C-'>
  maps.t["<C-'>"] = maps.n["<F7>"] -- requires terminal that supports binding <C-'>
end

-- extra - improved terminal navigation
maps.t["<C-h>"] =
{ "<cmd>wincmd h<cr>", desc = "Terminal left window navigation" }
maps.t["<C-j>"] =
{ "<cmd>wincmd j<cr>", desc = "Terminal down window navigation" }
maps.t["<C-k>"] =
{ "<cmd>wincmd k<cr>", desc = "Terminal up window navigation" }
maps.t["<C-l>"] =
{ "<cmd>wincmd l<cr>", desc = "Terminal right window navigation" }

-- dap.nvim [debugger] -----------------------------------------------------
-- Depending your terminal some F keys may not work. To fix it:
-- modified function keys found with `showkey -a` in the terminal to get key code
-- run `nvim -V3log +quit` and search through the "Terminal info" in the `log` file for the correct keyname
if is_available("nvim-dap") then
  maps.n["<leader>d"] = icons.d
  maps.x["<leader>d"] = icons.d

  -- F keys
  maps.n["<F5>"] = {
    function()
      require("dap").continue()
    end,
    desc = "Debugger: Start"
  }
  maps.n["<S-F5>"] =
  { function() require("dap").terminate() end, desc = "Debugger: Stop" }
  maps.n["<C-F5>"] = {
    function() require("dap").restart_frame() end, desc = "Debugger: Restart" }
  maps.n["<F9>"] = {
    function() require("dap").toggle_breakpoint() end, desc = "Debugger: Toggle Breakpoint" }
  maps.n["<S-F9>"] = {
    function()
      vim.ui.input({ prompt = "Condition: " }, function(condition)
        if condition then require("dap").set_breakpoint(condition) end
      end)
    end,
    desc = "Debugger: Conditional Breakpoint",
  }
  maps.n["<F10>"] =
  { function() require("dap").step_over() end, desc = "Debugger: Step Over" }
  maps.n["<S-F10>"] =
  { function() require("dap").step_back() end, desc = "Debugger: Step Back" }
  maps.n["<F11>"] =
  { function() require("dap").step_into() end, desc = "Debugger: Step Into" }
  maps.n["<S-F11>"] =
  { function() require("dap").step_out() end, desc = "Debugger: Step Out" }

  -- Space + d
  maps.n["<leader>db"] = {
    function() require("dap").toggle_breakpoint() end,
    desc = "Breakpoint (F9)",
  }
  maps.n["<leader>dB"] = {
    function() require("dap").clear_breakpoints() end,
    desc = "Clear Breakpoints",
  }
  maps.n["<leader>dc"] =
  { function() require("dap").continue() end, desc = "Start/Continue (F5)" }
  maps.n["<leader>dC"] = {
    function()
      vim.ui.input({ prompt = "Condition: " }, function(condition)
        if condition then require("dap").set_breakpoint(condition) end
      end)
    end,
    desc = "Conditional Breakpoint (S-F9)",
  }
  maps.n["<leader>do"] =
  { function() require("dap").step_over() end, desc = "Step Over (F10)" }
  maps.n["<leader>do"] =
  { function() require("dap").step_back() end, desc = "Step Back (S-F10)" }
  maps.n["<leader>db"] =
  { function() require("dap").step_into() end, desc = "Step Into (F11)" }
  maps.n["<leader>dO"] =
  { function() require("dap").step_out() end, desc = "Step Out (S-F11)" }
  maps.n["<leader>dq"] =
  { function() require("dap").close() end, desc = "Close Session" }
  maps.n["<leader>dQ"] = {
    function() require("dap").terminate() end,
    desc = "Terminate Session (S-F5)",
  }
  maps.n["<leader>dp"] =
  { function() require("dap").pause() end, desc = "Pause" }
  maps.n["<leader>dr"] =
  { function() require("dap").restart_frame() end, desc = "Restart (C-F5)" }
  maps.n["<leader>dR"] =
  { function() require("dap").repl.toggle() end, desc = "REPL" }
  maps.n["<leader>ds"] =
  { function() require("dap").run_to_cursor() end, desc = "Run To Cursor" }

  if is_available("nvim-dap-ui") then
    maps.n["<leader>dE"] = {
      function()
        vim.ui.input({ prompt = "Expression: " }, function(expr)
          if expr then require("dapui").eval(expr, { enter = true }) end
        end)
      end,
      desc = "Evaluate Input",
    }
    maps.x["<leader>dE"] =
    { function() require("dapui").eval() end, desc = "Evaluate Input" }
    maps.n["<leader>du"] =
    { function() require("dapui").toggle() end, desc = "Debugger UI" }
    maps.n["<leader>dh"] = {
      function() require("dap.ui.widgets").hover() end,
      desc = "Debugger Hover",
    }
  end
end

-- testing [tests] -------------------------------------------------
-- neotest
maps.n["<leader>T"] = icons.tt
maps.x["<leader>T"] = icons.tt
if is_available("neotest") then
  maps.n["<leader>Tu"] = {
    function() require("neotest").run.run() end,
    desc = "Unit",
  }
  maps.n["<leader>Ts"] = {
    function() require("neotest").run.stop() end,
    desc = "Stop unit",
  }
  maps.n["<leader>Tf"] = {
    function() require("neotest").run.run(vim.fn.expand "%") end,
    desc = "File",
  }
  maps.n["<leader>Td"] = {
    function() require("neotest").run.run { strategy = "dap" } end,
    desc = "Unit in debugger",
  }
  maps.n["<leader>Tt"] = {
    function() require("neotest").summary.toggle() end,
    desc = "Neotest summary",
  }
  maps.n["<leader>TT"] = {
    function() require("neotest").output_panel.toggle() end,
    desc = "Output panel",
  }
end

-- Extra - nvim-coverage
--         Your project must generate coverage/lcov.info for this to work.
--
--         On jest, make sure your packages.json file has this:
--         "test": "jest --coverage"
--
--         If you use other framework or language, refer to nvim-coverage docs:
--         https://github.com/andythigpen/nvim-coverage/blob/main/doc/nvim-coverage.txt
if is_available("nvim-coverage") then
  maps.n["<leader>Tc"] = {
    function()
      require("coverage").load(false)
      require("coverage").summary()
    end,
    desc = "Coverage",
  }
  maps.n["<leader>TC"] = {
    function()
      ui.toggle_coverage_signs()
    end,
    desc = "Coverage signs (toggle)",
  }
end

-- Extra - nodejs testing commands
maps.n["<leader>Ta"] = {
  function() vim.cmd("TestNodejs") end,
  desc = "All",
}
maps.n["<leader>Te"] = {
  function() vim.cmd("TestNodejsE2e") end,
  desc = "E2e",
}

-- nvim-ufo [code folding] --------------------------------------------------
if is_available("nvim-ufo") then
  maps.n["zR"] =
  { function() require("ufo").openAllFolds() end, desc = "Open all folds" }
  maps.n["zM"] =
  { function() require("ufo").closeAllFolds() end, desc = "Close all folds" }
  maps.n["zr"] = {
    function() require("ufo").openFoldsExceptKinds() end,
    desc = "Fold less",
  }
  maps.n["zm"] =
  { function() require("ufo").closeFoldsWith() end, desc = "Fold more" }
  maps.n["zp"] = {
    function() require("ufo").peekFoldedLinesUnderCursor() end,
    desc = "Peek fold",
  }
  maps.n["zn"] =
  {
    function() require("ufo").openFoldsExceptKinds({ 'comment' }) end,
    desc = "Fold comments"
  }
  maps.n["zN"] =
  {
    function() require("ufo").openFoldsExceptKinds({ 'region' }) end,
    desc = "Fold region"
  }
end

-- code docmentation [docs] -------------------------------------------------

if is_available("markdown-preview.nvim") or is_available("markmap.nvim") or is_available("dooku.nvim") then
  maps.n["<leader>D"] = icons.dc

  -- Markdown preview
  if is_available("markdown-preview.nvim") then
    maps.n["<leader>Dp"] = {
      function() vim.cmd("MarkdownPreview") end,
      desc = "Markdown preview",
    }
  end

  -- Markdown Mindmap
  if is_available("markmap.nvim") then
    maps.n["<leader>Dm"] = {
      function()
        if is_android then
          vim.cmd("MarkmapWatch")
        else
          vim.cmd("MarkmapOpen")
        end
      end,
      desc = "Markmap",
    }
  end

  if is_available("dooku.nvim") then
    maps.n["<leader>Dd"] = {
      function() vim.cmd(":DookuGenerate") end,
      desc = "Open documentation",
    }
  end
end

-- [neural] -----------------------------------------------------------------
if is_available("neural") or is_available("copilot") then
  maps.n["<leader>a"] = {
    function() require("neural").prompt() end,
    desc = "Ask chatgpt",
  }
end

-- hop.nvim ----------------------------------------------------------------
if is_available("hop.nvim") then
  -- Note that Even though we are using ENTER for hop, you can still select items
  -- from special menus like 'quickfix', 'q?' and 'q:' with <C+ENTER>.

  maps.n["<C-m>"] = { -- The terminal undersand C-m and ENTER as the same key.
    function()
      require("hop")
      vim.cmd("silent! HopWord")
    end,
    desc = "Hop to word",
  }
  maps.x["<C-m>"] = { -- The terminal undersand C-m and ENTER as the same key.
    function()
      require("hop")
      vim.cmd("silent! HopWord")
    end,
    desc = "Hop to word",
  }
end

-- mason-lspconfig.nvim [lsp] -------------------------------------------------
-- WARNING: Don't delete this section, or you won't have LSP keymappings.

--A function we call from the script to start lsp.
--@return table lsp_mappings
function M.lsp_mappings(client, bufnr)
  -- Helper function to check if any active LSP clients
  -- given a filter provide a specific capability.
  -- @param capability string The server capability to check for (example: "documentFormattingProvider").
  -- @param filter vim.lsp.get_clients.filter|nil A valid get_clients filter (see function docs).
  -- @return boolean # `true` if any of the clients provide the capability.
  local function has_capability(capability, filter)
    for _, lsp_client in ipairs(vim.lsp.get_clients(filter)) do
      if lsp_client.supports_method(capability) then return true end
    end
    return false
  end

  local lsp_mappings = require("base.utils").get_mappings_template()

  -- Diagnostics
  lsp_mappings.n["<leader>ld"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" }
  lsp_mappings.n["[d"] = { function()
      -- TODO: Delete after dropping nvim 0.10 support.
      if vim.fn.has('nvim-0.11') == 1 then vim.diagnostic.jump({ count = -1 })
      else vim.diagnostic.goto_prev() end end, desc = "Previous diagnostic"
  }
  lsp_mappings.n["]d"] = { function()
    -- TODO: Delete after dropping nvim 0.10 support.
    if vim.fn.has('nvim-0.11') == 1 then vim.diagnostic.jump({ count = 1 })
    else vim.diagnostic.goto_next() end end, desc = "Next diagnostic" }

  -- Diagnostics
  lsp_mappings.n["gl"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" }
  if is_available("telescope.nvim") then
    lsp_mappings.n["<leader>lD"] =
      { function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" }
  end

  -- LSP info
  if is_available("mason-lspconfig.nvim") then
    lsp_mappings.n["<leader>li"] = { "<cmd>LspInfo<cr>", desc = "LSP information" }
  end

  if is_available("none-ls.nvim") then
    lsp_mappings.n["<leader>lI"] = { "<cmd>NullLsInfo<cr>", desc = "Null-ls information" }
  end

  -- Code actions
  lsp_mappings.n["<leader>la"] = {
    function() vim.lsp.buf.code_action() end,
    desc = "LSP code action",
  }
  lsp_mappings.v["<leader>la"] = lsp_mappings.n["<leader>la"]

  -- Codelens
  utils.add_autocmds_to_buffer("lsp_codelens_refresh", bufnr, {
    events = { "InsertLeave" },
    desc = "Refresh codelens",
    callback = function(args)
      if client.supports_method "textDocument/codeLens" then
        if vim.g.codelens_enabled then vim.lsp.codelens.refresh({ bufnr = args.buf }) end
      end
    end,
  })
  if client.supports_method "textDocument/codeLens" then -- on LspAttach
    if vim.g.codelens_enabled then vim.lsp.codelens.refresh({ bufnr = 0 }) end
  end

  lsp_mappings.n["<leader>ll"] = {
    function()
      vim.lsp.codelens.run()
      vim.lsp.codelens.refresh({ bufnr = 0 })
    end,
    desc = "LSP CodeLens run",
  }
  lsp_mappings.n["<leader>uL"] = {
    function() ui.toggle_codelens() end,
    desc = "CodeLens",
  }

  -- Formatting (keymapping)
  local formatting = require("base.utils.lsp").formatting
  local format_opts = require("base.utils.lsp").format_opts
  lsp_mappings.n["<leader>lf"] = {
    function()
      vim.lsp.buf.format(format_opts)
      vim.cmd("checktime") -- Sync buffer with changes
    end,
    desc = "Format buffer",
  }
  lsp_mappings.v["<leader>lf"] = lsp_mappings.n["<leader>lf"]

  -- Formatting (command)
  vim.api.nvim_buf_create_user_command(
    bufnr,
    "Format",
    function() vim.lsp.buf.format(format_opts) end,
    { desc = "Format file with LSP" }
  )

  -- Autoformatting (autocmd)
  local autoformat = formatting.format_on_save
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

  -- guard clauses
  local is_autoformat_enabled = autoformat.enabled
  local is_filetype_allowed = vim.tbl_isempty(autoformat.allow_filetypes or {})
      or vim.tbl_contains(autoformat.allow_filetypes, filetype)
  local is_filetype_ignored = vim.tbl_isempty(
    autoformat.ignore_filetypes or {}
  ) or not vim.tbl_contains(autoformat.ignore_filetypes, filetype)

if is_autoformat_enabled and is_filetype_allowed and is_filetype_ignored then
    utils.add_autocmds_to_buffer("lsp_auto_format", bufnr, {
      events = "BufWritePre", -- Trigger before save
      desc = "Autoformat on save",
      callback = function()
        -- guard clause: has_capability
        if
            not has_capability("textDocument/formatting", { bufnr = bufnr })
        then
          utils.del_autocmds_from_buffer("lsp_auto_format", bufnr)
          return
        end

        -- Get autoformat setting (buffer or global)
        local autoformat_enabled = vim.b.autoformat_enabled
            or vim.g.autoformat_enabled
        local has_no_filter = not autoformat.filter
        local passes_filter = autoformat.filter and autoformat.filter(bufnr)

        -- Use these variables in the if condition
        if autoformat_enabled and (has_no_filter or passes_filter) then
          vim.lsp.buf.format(
            vim.tbl_deep_extend("force", format_opts, { bufnr = bufnr })
          )
        end
      end,
    })

    -- Key mappings for toggling autoformat (buffer/global)
    lsp_mappings.n["<leader>uf"] = {
      function() require("base.utils.ui").toggle_buffer_autoformat() end,
      desc = "Toggle buffer autoformat",
    }
    lsp_mappings.n["<leader>uF"] = {
      function() require("base.utils.ui").toggle_autoformat() end,
      desc = "Toggle global autoformat",
    }
  end

  -- Highlight references when cursor holds
  utils.add_autocmds_to_buffer("lsp_document_highlight", bufnr, {
    {
      events = { "CursorHold", "CursorHoldI" },
      desc = "highlight references when cursor holds",
      callback = function()
        if has_capability("textDocument/documentHighlight", { bufnr = bufnr }) then
          vim.lsp.buf.document_highlight()
        end
      end,
    },
    {
      events = { "CursorMoved", "CursorMovedI", "BufLeave" },
      desc = "clear references when cursor moves",
      callback = function() vim.lsp.buf.clear_references() end,
    },
  })

  -- Other LSP mappings
  lsp_mappings.n["<leader>lL"] = {
    function() vim.api.nvim_command(':LspRestart') end,
    desc = "LSP refresh",
  }

  -- Goto definition / declaration
  lsp_mappings.n["gd"] = {
    function() vim.lsp.buf.definition() end,
    desc = "Goto definition of current symbol",
  }
  lsp_mappings.n["gD"] = {
    function() vim.lsp.buf.declaration() end,
    desc = "Goto declaration of current symbol",
  }

  -- Goto implementation
  lsp_mappings.n["gI"] = {
    function() vim.lsp.buf.implementation() end,
    desc = "Goto implementation of current symbol",
  }

  -- Goto type definition
  lsp_mappings.n["gT"] = {
    function() vim.lsp.buf.type_definition() end,
    desc = "Goto definition of current type",
  }

  -- Goto references
  lsp_mappings.n["<leader>lR"] = {
    function() vim.lsp.buf.references() end,
    desc = "Hover references",
  }
  lsp_mappings.n["gr"] = {
    function() vim.lsp.buf.references() end,
    desc = "References of current symbol",
  }

  -- Goto help
  local lsp_hover_config = require("base.utils.lsp").lsp_hover_config
  lsp_mappings.n["gh"] = {
    function()
      vim.lsp.buf.hover(lsp_hover_config)
    end,
    desc = "Hover help",
  }
  lsp_mappings.n["gH"] = {
    function() vim.lsp.buf.signature_help(lsp_hover_config) end,
    desc = "Signature help",
  }

  lsp_mappings.n["<leader>lh"] = {
    function() vim.lsp.buf.hover(lsp_hover_config) end,
    desc = "Hover help",
  }
  lsp_mappings.n["<leader>lH"] = {
    function() vim.lsp.buf.signature_help(lsp_hover_config) end,
    desc = "Signature help",
  }

  -- Goto man
  lsp_mappings.n["gm"] = {
    function() vim.api.nvim_feedkeys("K", "n", false) end,
    desc = "Hover man",
  }
  lsp_mappings.n["<leader>lm"] = {
    function() vim.api.nvim_feedkeys("K", "n", false) end,
    desc = "Hover man",
  }

  -- Rename symbol
  lsp_mappings.n["<leader>lr"] = {
    function() vim.lsp.buf.rename() end,
    desc = "Rename current symbol",
  }

  -- Toggle inlay hints
  if vim.b.inlay_hints_enabled == nil then vim.b.inlay_hints_enabled = vim.g.inlay_hints_enabled end
  if vim.b.inlay_hints_enabled then vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end
  lsp_mappings.n["<leader>uH"] = {
    function() require("base.utils.ui").toggle_buffer_inlay_hints(bufnr) end,
    desc = "LSP inlay hints (buffer)",
  }

  -- Toggle semantic tokens
  if vim.g.semantic_tokens_enabled then
    vim.b[bufnr].semantic_tokens_enabled = true
    lsp_mappings.n["<leader>uY"] = {
      function() require("base.utils.ui").toggle_buffer_semantic_tokens(bufnr) end,
      desc = "LSP semantic highlight (buffer)",
    }
  else
    client.server_capabilities.semanticTokensProvider = nil
  end

  -- LSP based search
  lsp_mappings.n["<leader>lS"] = { function() vim.lsp.buf.workspace_symbol() end, desc = "Search symbol in workspace" }
  lsp_mappings.n["gS"] = { function() vim.lsp.buf.workspace_symbol() end, desc = "Search symbol in workspace" }

  -- LSP telescope
  if is_available("telescope.nvim") then -- setup telescope mappings if available
    if lsp_mappings.n.gd then lsp_mappings.n.gd[1] = function() require("telescope.builtin").lsp_definitions() end end
    if lsp_mappings.n.gI then
      lsp_mappings.n.gI[1] = function() require("telescope.builtin").lsp_implementations() end
    end
    if lsp_mappings.n.gr then lsp_mappings.n.gr[1] = function() require("telescope.builtin").lsp_references() end end
    if lsp_mappings.n["<leader>lR"] then
      lsp_mappings.n["<leader>lR"][1] = function() require("telescope.builtin").lsp_references() end
    end
    if lsp_mappings.n.gy then
      lsp_mappings.n.gy[1] = function() require("telescope.builtin").lsp_type_definitions() end
    end
    if lsp_mappings.n["<leader>lS"] then
      lsp_mappings.n["<leader>lS"][1] = function()
        vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" }, function(query)
          if query then
            -- word under cursor if given query is empty
            if query == "" then query = vim.fn.expand "<cword>" end
            require("telescope.builtin").lsp_workspace_symbols {
              query = query,
              prompt_title = ("Find word (%s)"):format(query),
            }
          end
        end)
      end
    end
    if lsp_mappings.n["gS"] then
      lsp_mappings.n["gS"][1] = function()
        vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" }, function(query)
          if query then
            -- word under cursor if given query is empty
            if query == "" then query = vim.fn.expand "<cword>" end
            require("telescope.builtin").lsp_workspace_symbols {
              query = query,
              prompt_title = ("Find word (%s)"):format(query),
            }
          end
        end)
      end
    end
  end

  return lsp_mappings
end

utils.set_mappings(maps)
return M
