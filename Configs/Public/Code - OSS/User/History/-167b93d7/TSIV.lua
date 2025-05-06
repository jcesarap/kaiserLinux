-- core/lazy.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Import all plugins from lua/plugins/
  },
  checker = { enabled = false },
})

-- Extra Plugin Config
require("telescope").load_extension("recent_files")
require("ibl").setup()
require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/LuaSnip/" })
require("luasnip").config.set_config({
  update_events = 'TextChanged,TextChangedI',
  store_selection_keys = "<x>",
  enable_autosnippets = true,
})

-- Optionally, sync plugins if needed
require("lazy").sync()
