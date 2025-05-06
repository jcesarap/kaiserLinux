require('core.options') -- Load general Neovim options
require('core.remap')   -- Load key mappings
require('core.lazy')    -- Load plugins via lazy.nvim

-- Load plugins
require('plugins.telescope')    -- Telescope plugin config
require('plugins.treesitter')   -- Treesitter plugin config
require('plugins.luasnip')      -- LuaSnip plugin config
require('plugins.autopair')     -- Autopairs plugin config
require('plugins.lint')         -- Linting plugin config
require('plugins.image')        -- Image plugin config
require('plugins.indent_blankline') -- IndentBlankline plugin config
require('plugins.statusline')   -- Statusline plugin config
require('plugins.visual_multi') -- Visual multi plugin config