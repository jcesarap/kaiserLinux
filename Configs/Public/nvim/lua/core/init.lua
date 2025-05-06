-- Loaders
require('core.remap')
require('core.lazy')
require('core.cmp')
-- Extra Plugin Config
require("telescope").load_extension("recent_files")
require("ibl").setup()
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/" })
-- Lazy-load snippets, i.e. only load when required, e.g. for a given filetype
require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })
require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "c", "lua", "javascript", "markdown", "markdown_inline", "html", "bash", "css" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    -- ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

require("toggleterm").setup {
    -- size can be a number or function which is passed the current terminal
    size = 25,
    open_mapping = [[<c-;>]],
    hide_numbers = true,    -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
    -- shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true,   -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = true,
    direction = 'float',      -- 'vertical' | 'horizontal' | 'tab' | 'float'
    close_on_exit = true,     -- close the terminal window when the process exits
    -- shell = vim.o.shell, -- change the default shell
    -- This field is only relevant if direction is set to 'float'
    float_opts = {
        -- The border key is *almost* the same as 'nvim_open_win'
        -- see :h nvim_open_win for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        border = 'none', -- 'single' | 'double' | 'shadow' | 'curved'
        -- width = <value>,
        -- height = <value>,
        winblend = 3,
    }
}

function _G.set_terminal_keymaps()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    -- vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
    -- vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
    -- vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
    -- vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
    -- vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        c = { "clang-format" },
        cpp = { "clang-format" },
        html = { "superhtml" },                                        -- Add HTML
        typescript = { "biome", "prettier", stop_after_first = true }, -- Add TS if needed
    },
    formatters = {
        biome = {
            prepend_args = { "--line-width", "200" },
        },
        ["clang-format"] = {
            prepend_args = { "-style={ColumnLimit: 200}" },
        },
        prettier = {
            prepend_args = { "--print-width", "200" },
        },
        superhtml = {
            prepend_args = { "--max-line-length", "200" },
        },
        black = {
            prepend_args = { "--line-length", "100" },
        },
        stylua = {
            prepend_args = { "--column-width", "150" },
        },
        rustfmt = {
            prepend_args = { "--config", "max_width=120" }, -- Optional if you want wider Rust
        },
    },
    format_on_save = {
        lsp_fallback = true,
    },
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})
