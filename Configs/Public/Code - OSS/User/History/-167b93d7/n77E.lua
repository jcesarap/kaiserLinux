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

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {
		"nvim-treesitter/nvim-treesitter", -- add your plugins here --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- < < < < 
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
		{"L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" }, -- Mth is about algorithm, not transcribing calculations
		{
			'altermo/ultimate-autopair.nvim',
			event={'InsertEnter','CmdlineEnter'},
			branch='v0.6', --recommended as each new version will have breaking changes
			opts={
				--Config goes here
			},
		},
    {
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        kotlin = { "ktlint" },
        terraform = { "tflint" },
        ruby = { "standardrb" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  }
		{'beauwilliams/statusline.lua'},
		{
			"vhyrro/luarocks.nvim",
			priority = 1001, -- this plugin needs to run before anything else
			opts = {
				rocks = { "magick" },
			},
		},
		{
			"3rd/image.nvim",
			dependencies = { "luarocks.nvim" },
			config = function()
				-- ...
			end
		},
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		'nvim-lua/plenary.nvim',
		lazy = false,
		priority = 1000,
		opts = {},
		"nvim-telescope/telescope.nvim", -- Has a 'live grep' feature that allows you to search through many files
		"smartpde/telescope-recent-files",
		{ 'mg979/vim-visual-multi', branch = master },	
		-- { 'echasnovski/mini.nvim', version = false }, -- Status line
		"lukas-reineke/indent-blankline.nvim",
		'rbgrouleff/bclose.vim',
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = {
		-- automatically check for plugin updates
		enabled = false,
		concurrency = nil, ---@type number? set to 1 to check for updates very slowly
		notify = true, -- get a notification when new updates are found
		frequency = 3600, -- check for updates every hour
		check_pinned = false, -- check for pinned packages that can't be updated
	},
})

-- Images on markdown
require("image").setup({
	backend = "ueberzug",
	processor = "magick_cli", -- or "magick_cli"
	integrations = {
		markdown = {
			enabled = true,
			clear_in_insert_mode = false,
			download_remote_images = true,
			only_render_image_at_cursor = true,
			filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
		},
		neorg = {
			enabled = true,
			clear_in_insert_mode = false,
			download_remote_images = true,
			only_render_image_at_cursor = true,
			filetypes = { "norg" },
		},
		html = {
			enabled = false,
		},
		css = {
			enabled = false,
		},
	},
	max_width = nil,
	max_height = nil,
	max_width_window_percentage = nil,
	max_height_window_percentage = 50,
	window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
	window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
	editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
	tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
	hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
})
-- :checkhealth lazy
-- :Lazy -- to run the UI

