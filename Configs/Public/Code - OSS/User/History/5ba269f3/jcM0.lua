-- HELLO, welcome to NormalNvim!
-- ----------------------------------------
-- Here you can define your nvim variables.
-- ----------------------------------------

-- Theme
vim.g.default_colorscheme = "tokyonight-night"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.shiftwidth = 4    -- Number of spaces to use for each indentation level
vim.opt.tabstop = 4       -- Number of spaces a tab character represents
vim.opt.expandtab = true  -- Use spaces instead of tabs
vim.opt.softtabstop = 2     -- Tab key behavior in insert mode
vim.opt["guicursor"] = "" -- For block cursor