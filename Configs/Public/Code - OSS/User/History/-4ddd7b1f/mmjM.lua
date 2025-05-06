-- Keybindings (qwerty).

-- DESCRIPTION:
-- All mappings are defined here.

--    Sections:
--       ## Base bindings
--       -> icons displayed on which-key.nvim
--       -> standard operations
--       -> clipboard
--       -> search highlighting
--       -> improved tabulation
--       -> improved gg
--       -> packages
--       -> buffers/tabs                       [buffers]
--       -> ui toggles                         [ui]
--       -> shifted movement keys
--       -> cmdline autocompletion
--       -> special cases

--       ## Plugin bindings
--       -> alpha-nvim
--       -> git                                [git]
--       -> file browsers
--       -> session manager
--       -> smart-splits.nvim
--       -> aerial.nvim
--       -> litee-calltree.nvim
--       -> telescope.nvim                     [find]
--       -> toggleterm.nvim
--       -> dap.nvim                           [debugger]
--       -> tests                              [tests]
--       -> nvim-ufo
--       -> code documentation                 [docs]
--       -> ask chatgpt                        [neural]
--       -> hop.nvim
--       -> mason-lspconfig.nvim               [lsp]

--
--   KEYBINDINGS REFERENCE
--   -------------------------------------------------------------------
--   |        Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
--   Command        +------+-----+-----+-----+-----+-----+------+------+
--   [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
--   n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
--   [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
--   i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
--   c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
--   v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
--   x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
--   s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
--   o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
--   t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
--   l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
--   -------------------------------------------------------------------

local M = {}
local utils = require("base.utils")
local get_icon = utils.get_icon
local is_available = utils.is_available
local ui = require("base.utils.ui")
local maps = require("base.utils").get_mappings_template()
local is_android = vim.fn.isdirectory('/data') == 1 -- true if on android

-- -------------------------------------------------------------------------
--
-- ## Base bindings ########################################################
--
-- -------------------------------------------------------------------------



  -- Goto implementation
  lsp_mappings.n["gI"] = {
    function() vim.lsp.buf.implementation() end,
    desc = "Goto implementation of current symbol",
  }

  -- Goto type definition
  lsp_mappings.n["gT"] = {
    function() vim.lsp.buf.type_definition() end,
    desc = "Goto definition of current type",
  }

  -- Goto references
  lsp_mappings.n["<leader>lR"] = {
    function() vim.lsp.buf.references() end,
    desc = "Hover references",
  }
  lsp_mappings.n["gr"] = {
    function() vim.lsp.buf.references() end,
    desc = "References of current symbol",
  }

  -- Goto help
  local lsp_hover_config = require("base.utils.lsp").lsp_hover_config
  lsp_mappings.n["gh"] = {
    function()
      vim.lsp.buf.hover(lsp_hover_config)
    end,
    desc = "Hover help",
  }
  lsp_mappings.n["gH"] = {
    function() vim.lsp.buf.signature_help(lsp_hover_config) end,
    desc = "Signature help",
  }

  lsp_mappings.n["<leader>lh"] = {
    function() vim.lsp.buf.hover(lsp_hover_config) end,
    desc = "Hover help",
  }
  lsp_mappings.n["<leader>lH"] = {
    function() vim.lsp.buf.signature_help(lsp_hover_config) end,
    desc = "Signature help",
  }

  -- Goto man
  lsp_mappings.n["gm"] = {
    function() vim.api.nvim_feedkeys("K", "n", false) end,
    desc = "Hover man",
  }
  lsp_mappings.n["<leader>lm"] = {
    function() vim.api.nvim_feedkeys("K", "n", false) end,
    desc = "Hover man",
  }

  -- Rename symbol
  lsp_mappings.n["<leader>lr"] = {
    function() vim.lsp.buf.rename() end,
    desc = "Rename current symbol",
  }

  -- Toggle inlay hints
  if vim.b.inlay_hints_enabled == nil then vim.b.inlay_hints_enabled = vim.g.inlay_hints_enabled end
  if vim.b.inlay_hints_enabled then vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end
  lsp_mappings.n["<leader>uH"] = {
    function() require("base.utils.ui").toggle_buffer_inlay_hints(bufnr) end,
    desc = "LSP inlay hints (buffer)",
  }

  -- Toggle semantic tokens
  if vim.g.semantic_tokens_enabled then
    vim.b[bufnr].semantic_tokens_enabled = true
    lsp_mappings.n["<leader>uY"] = {
      function() require("base.utils.ui").toggle_buffer_semantic_tokens(bufnr) end,
      desc = "LSP semantic highlight (buffer)",
    }
  else
    client.server_capabilities.semanticTokensProvider = nil
  end

  -- LSP based search
  lsp_mappings.n["<leader>lS"] = { function() vim.lsp.buf.workspace_symbol() end, desc = "Search symbol in workspace" }
  lsp_mappings.n["gS"] = { function() vim.lsp.buf.workspace_symbol() end, desc = "Search symbol in workspace" }

  -- LSP telescope
  if is_available("telescope.nvim") then -- setup telescope mappings if available
    if lsp_mappings.n.gd then lsp_mappings.n.gd[1] = function() require("telescope.builtin").lsp_definitions() end end
    if lsp_mappings.n.gI then
      lsp_mappings.n.gI[1] = function() require("telescope.builtin").lsp_implementations() end
    end
    if lsp_mappings.n.gr then lsp_mappings.n.gr[1] = function() require("telescope.builtin").lsp_references() end end
    if lsp_mappings.n["<leader>lR"] then
      lsp_mappings.n["<leader>lR"][1] = function() require("telescope.builtin").lsp_references() end
    end
    if lsp_mappings.n.gy then
      lsp_mappings.n.gy[1] = function() require("telescope.builtin").lsp_type_definitions() end
    end
    if lsp_mappings.n["<leader>lS"] then
      lsp_mappings.n["<leader>lS"][1] = function()
        vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" }, function(query)
          if query then
            -- word under cursor if given query is empty
            if query == "" then query = vim.fn.expand "<cword>" end
            require("telescope.builtin").lsp_workspace_symbols {
              query = query,
              prompt_title = ("Find word (%s)"):format(query),
            }
          end
        end)
      end
    end
    if lsp_mappings.n["gS"] then
      lsp_mappings.n["gS"][1] = function()
        vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" }, function(query)
          if query then
            -- word under cursor if given query is empty
            if query == "" then query = vim.fn.expand "<cword>" end
            require("telescope.builtin").lsp_workspace_symbols {
              query = query,
              prompt_title = ("Find word (%s)"):format(query),
            }
          end
        end)
      end
    end
  end

  return lsp_mappings
end

utils.set_mappings(maps)
return M
