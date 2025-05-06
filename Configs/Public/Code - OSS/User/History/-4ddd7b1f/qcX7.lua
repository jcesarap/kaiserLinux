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

-- aerial.nvimm ------------------------------------------------------------
if is_available("aerial.nvim") then
  maps.n["<leader>i"] =
  { function() require("aerial").toggle() end, desc = "Aerial" }
end

-- letee-calltree.nvimm ------------------------------------------------------------
if is_available("litee-calltree.nvim") then
  -- For every buffer, look for the one with filetype "calltree" and focus it.
  local calltree_delay = 1500 -- first run? wait a bit longer.
  local function focus_calltree()
    -- Note: No go to the previous cursor position, press ctrl+i / ctrl+o
    vim.defer_fn(function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })

        if ft == "calltree" then
          vim.api.nvim_set_current_win(win)
          return true
        end
      end
    end, calltree_delay)
    calltree_delay = 100
  end
  maps.n["gj"] = {
    function()
      vim.lsp.buf.incoming_calls()
      focus_calltree()
    end,
    desc = "Call tree (incoming)"
  }
  maps.n["gJ"] =
  {
    function()
      vim.lsp.buf.outgoing_calls()
      focus_calltree()
    end,
    desc = "Call tree (outgoing)"
  }
end

-- telescope.nvim [find] ----------------------------------------------------
if is_available("telescope.nvim") then
  maps.n["<leader>f"] = icons.f
  maps.n["<leader>gb"] = {
    function() require("telescope.builtin").git_branches() end,
    desc = "Git branches",
  }
  maps.n["<leader>gc"] = {
    function()
      require("telescope.builtin").git_commits()
    end,
    desc = "Git commits (repository)"
  }
  maps.n["<leader>gC"] = {
    function()
      require("telescope.builtin").git_bcommits()
    end,
    desc = "Git commits (current file)"
  }
  maps.n["<leader>gt"] = {
    function() require("telescope.builtin").git_status() end,
    desc = "Git status",
  }
  maps.n["<leader>f<CR>"] = {
    function() require("telescope.builtin").resume() end,
    desc = "Resume previous search",
  }
  maps.n["<leader>f'"] = {
    function() require("telescope.builtin").marks() end,
    desc = "Find marks",
  }
  maps.n["<leader>fa"] = {
    function()
      local cwd = vim.fn.stdpath "config" .. "/.."
      local search_dirs = { vim.fn.stdpath "config" }
      if #search_dirs == 1 then cwd = search_dirs[1] end -- if only one directory, focus cwd
      require("telescope.builtin").find_files {
        prompt_title = "Config Files",
        search_dirs = search_dirs,
        cwd = cwd,
        follow = true,
      } -- call telescope
    end,
    desc = "Find nvim config files",
  }
  maps.n["<leader>fB"] = {
    function() require("telescope.builtin").buffers() end,
    desc = "Find buffers",
  }
  maps.n["<leader>fw"] = {
    function() require("telescope.builtin").grep_string() end,
    desc = "Find word under cursor in project",
  }
  maps.n["<leader>fC"] = {
    function() require("telescope.builtin").commands() end,
    desc = "Find commands",
  }
  -- Let's disable this. It is way too imprecise. Use rnvimr instead.
  -- maps.n["<leader>ff"] = {
  --   function()
  --     require("telescope.builtin").find_files { hidden = true, no_ignore = true }
  --   end,
  --   desc = "Find all files",
  -- }
  -- maps.n["<leader>fF"] = {
  --   function() require("telescope.builtin").find_files() end,
  --   desc = "Find files (no hidden)",
  -- }
  maps.n["<leader>fh"] = {
    function() require("telescope.builtin").help_tags() end,
    desc = "Find help",
  }
  maps.n["<leader>fk"] = {
    function() require("telescope.builtin").keymaps() end,
    desc = "Find keymaps",
  }
  maps.n["<leader>fm"] = {
    function() require("telescope.builtin").man_pages() end,
    desc = "Find man",
  }
  if is_available("nvim-notify") then
    maps.n["<leader>fn"] = {
      function() require("telescope").extensions.notify.notify() end,
      desc = "Find notifications",
    }
  end
  maps.n["<leader>fo"] = {
    function() require("telescope.builtin").oldfiles() end,
    desc = "Find recent",
  }
  maps.n["<leader>fv"] = {
    function() require("telescope.builtin").registers() end,
    desc = "Find vim registers",
  }
  maps.n["<leader>ft"] = {
    function()
      -- load color schemes before listing them
      pcall(vim.api.nvim_command, "doautocmd User LoadColorSchemes")

      -- Open telescope
      pcall(require("telescope.builtin").colorscheme, {
        enable_preview = true,
        ignore_builtins = true
      })
    end,
    desc = "Find themes",
  }
  maps.n["<leader>ff"] = {
    function()
      require("telescope.builtin").live_grep({
        additional_args = function(args)
          args.additional_args = { "--hidden", "--no-ignore" }
          return args.additional_args
        end,
      })
    end,
    desc = "Find words in project",
  }
  maps.n["<leader>fF"] = {
    function() require("telescope.builtin").live_grep() end,
    desc = "Find words in project (no hidden)",
  }
  maps.n["<leader>f/"] = {
    function() require("telescope.builtin").current_buffer_fuzzy_find() end,
    desc = "Find words in current buffer",
  }
