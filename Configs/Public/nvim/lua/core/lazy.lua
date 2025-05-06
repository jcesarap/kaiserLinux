-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        "nvim-treesitter/nvim-treesitter", -- add your plugins here --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- < < < <
        { 'VonHeikemen/lsp-zero.nvim',    branch = 'v4.x' },
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'ErichDonGubler/lsp_lines.nvim' },
        { 'hrsh7th/nvim-cmp' },
        {
            'stevearc/conform.nvim',
            opts = {},
        },
        { 'akinsho/toggleterm.nvim', version = "*", config = true },
        { 'williamboman/mason.nvim' },
        {
            "lervag/vimtex",
            lazy = false, -- we don't want to lazy load VimTeX
            -- tag = "v2.15", -- uncomment to pin to a specific release
            init = function()
                -- VimTeX configuration goes here, e.g.
                vim.g.vimtex_view_method = "zathura"
            end
        },
        {
            "iamcco/markdown-preview.nvim",
            cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
            build = "cd app && yarn install",
            init = function()
                vim.g.mkdp_filetypes = { "markdown" }
            end,
            ft = { "markdown" },
        },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
        {
            "pmizio/typescript-tools.nvim",
            dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
            opts = {},
        },
        { 'hrsh7th/nvim-cmp' }, -- Kept merely for dependency
        {
            'altermo/ultimate-autopair.nvim',
            event = { 'InsertEnter', 'CmdlineEnter' },
            branch = 'v0.6', --recommended as each new version will have breaking changes
            opts = {
                --Config goes here
            },
        },
        { 'beauwilliams/statusline.lua' },
        {
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = "make install_jsregexp"
        },
        --{
        --    "vhyrro/luarocks.nvim",
        --    priority = 1001, -- this plugin needs to run before anything else
        --    opts = {
        --        rocks = { "magick" },
        --    },
        --},
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
        notify = true,        -- get a notification when new updates are found
        frequency = 3600,     -- check for updates every hour
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
    window_overlap_clear_enabled = false,                                               -- toggles images when windows are overlapped
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    editor_only_render_when_focused = false,                                            -- auto show/hide images when the editor gains/looses focus
    tmux_show_only_in_active_window = false,                                            -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
})
-- :checkhealth lazy
-- :Lazy -- to run the UI

-- -------------------------------------------------

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end,
})

local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    mapping = cmp.mapping.preset.insert({
        -- Use Tab to navigate to the next completion item
        ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),

        -- Use Shift+Tab to navigate to the previous completion item
        ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Scroll up and down in the completion documentation
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
    }),
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
})

-- These are just examples. Replace them with the language
-- servers you have installed in your system
require('lspconfig').gleam.setup({})
require('lspconfig').rust_analyzer.setup({})

local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    snippet = {
        expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({}),
})

-- Language servers
-- To evoke mason: Mason
require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = { 'lua_ls', 'emmet_ls', 'cssls', 'biome', 'clangd' },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        -- this first function is the "default handler"
        -- it applies to every language server without a "custom handler"
        --function(server_name)
        --require('lspconfig')[server_name].setup({})
        --end,

        -- this is the "custom handler" for `biome`
        biome = function()
            require('lspconfig').biome.setup({
                single_file_support = false,
                on_attach = function(client, bufnr)
                    print('hello biome')
                end
            })
        end,
    }
})

require('lspconfig').biome.setup({
    single_file_support = false,
    on_attach = function(client, bufnr)
        print('hello biome')
    end
})
