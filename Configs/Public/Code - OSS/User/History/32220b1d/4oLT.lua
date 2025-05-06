-- Loaders
require('core.remap')
require('core.lazy')
-- Extra Plugin Config
require("telescope").load_extension("recent_files")
require("ibl").setup()
--
require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})
require("luasnip").config.set_config({ -- Setting LuaSnip config
    update_events = 'TextChanged,TextChangedI',
    -- Use <Tab> (or some other key if you prefer) to trigger visual selection
    store_selection_keys = "<x>",
    require("luasnip.extras.fmt").fmt,
    enable_autosnippets = true
})

---

-- core/options.lua
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- General Neovim options
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt["guicursor"] = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'

-- Transparent background
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
  highlight LineNr guibg=none
  highlight LineNr ctermbg=none
  highlight SignColumn guibg=none
]]

-- Colorscheme
require("cyberdream").setup({ transparent = true, extensions = { telescope = false } })
vim.cmd[[colorscheme cyberdream]]
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" }) -- Transparent Telescope