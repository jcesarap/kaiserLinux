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

-- New tab
vim.keymap.set('n', '<C-t>', '<cmd>tabnew<CR>', {})

-- Markdown Images
-- --- --- --- Logic: Get path of running file, add currently selected line to it, remove surroundings of markdown image syntax, export value to variable, open script that uses such variable to run something
local modified_path = "" -- Initialize a variable to hold the path
vim.keymap.set('n', '<C-o>', function()
    local dir_path = vim.fn.expand('%:p:h')
    local selected_line = vim.fn.getline('.')
    modified_path = dir_path .. "/" .. selected_line

    -- Remove ![]() characters from the modified path
    modified_path = modified_path:gsub('[!%[%]()]', '')

    -- Export the cleaned-up path and run the command in one shell invocation
    os.execute('export selected="' ..
        modified_path ..
        '" && export selected_path="' ..
        modified_path ..
        '" && nohup ~/Dropbox/Kaiser-Linux/Scripts/rofi/finder.sh openwithrofi > /dev/null 2>&1 &')
end)

-- Latex
-- " Use `<localleader>c` to trigger continuous compilation...
vim.api.nvim_set_keymap('n', '<C-c>', '<Plug>(vimtex-compile)', { noremap = true, silent = true })

vim.keymap.set('n', '<C-m>', '<Plug>MarkdownPreviewToggle', {})
--nmap <C-m> <Plug>MarkdownPreview
-- nmap <M-s> <Plug>MarkdownPreviewStop
-- nmap <C-p> <Plug>MarkdownPreviewToggle

-- Luasnips

-- Telescope
-- Disabling recent query
vim.api.nvim_set_keymap("n", "<C-h>", [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-g>', ':Telescope find_files<CR>', { noremap = true, silent = true }) -- Telescope
vim.api.nvim_set_keymap('n', '<C-S-f>', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]],
    { noremap = true, silent = true })

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
vim.opt.number = true -- Show absolute line numbers
vim.opt.relativenumber = true
vim.opt.mouse = 'a'   -- Enable mouse support

-- Autoformat with ff
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set({ 'n', 'x' }, 'ff', function()
            vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
        end, opts)
    end
})
