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

-- require("tokyonight").setup {
--     transparent = true,
--     styles = {
--        sidebars = "transparent",
--        floats = "transparent",
--     }
-- } 
-- vim.cmd[[colorscheme tokyonight-night]]
require("cyberdream").setup({transparent=true, extensions ={telescope=false,}})
vim.cmd[[colorscheme cyberdream]]
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" }) -- Transparent Telescope
