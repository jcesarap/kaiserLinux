require("core")
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.shiftwidth = 4    -- Number of spaces to use for each indentation level
vim.opt.tabstop = 4       -- Number of spaces a tab character represents
vim.opt.expandtab = true  -- Use spaces instead of tabs
vim.opt.softtabstop = 4   -- Tab key behavior in insert mode
vim.opt["guicursor"] = "" -- For block cursor
vim.g.mkdp_browser = 'firefox'
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
  highlight LineNr guibg=none
  highlight LineNr ctermbg=none
  highlight SignColumn guibg=none
]]
-- This is necessary for VimTeX to load properly. The "indent" is optional.
-- Note: Most plugin managers will do this automatically!
vim.cmd('filetype plugin indent on')

-- This enables Vim's and neovim's syntax-related features. Without this, some
-- VimTeX features will not work (see ":help vimtex-requirements" for more
-- info).
-- Note: Most plugin managers will do this automatically!
vim.cmd('syntax enable')

-- Viewer options: One may configure the viewer either by specifying a built-in
-- viewer method:
vim.g.vimtex_view_method = 'zathura'
-- require("tokyonight").setup {
--     transparent = true,
--     styles = {
--        sidebars = "transparent",
--        floats = "transparent",
--     }
-- }
