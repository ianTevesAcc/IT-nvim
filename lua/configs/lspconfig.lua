-- Load defaults for Lua language server
local base = require "nvchad.configs.lspconfig"
local on_attach = base.on_attach
local capabilities = base.capabilities
local lspconfig = require "lspconfig"

-- Example LSP servers
local servers = { "html", "cssls", "lua_ls", "clangd" }
local nvlsp = require "nvchad.configs.lspconfig"

-- Define root pattern
local root_pattern = lspconfig.util.root_pattern(
  ".luarc.json",
  ".luarc.jsonc",
  ".luacheckrc",
  ".stylua.toml",
  "stylua.toml",
  "selene.toml",
  "selene.yml",
  ".git"
)

-- Default fallback root directory
local fallback_root = vim.fn.expand "~/.config/nvim/"

-- Function to determine root directory
local function get_root_dir(fname)
  local root = root_pattern(fname)
  if root == nil or root == vim.fn.expand "~" then
    return fallback_root
  end
  return root
end

-- Default LSP's config
for _, lsp in ipairs(servers) do
  local settings = {}

  if lsp == "lua_ls" then
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.stdpath "config" .. "/lua",
          },
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    }
  end

  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    root_dir = get_root_dir,
    settings = settings,
    handlers = {
      ["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = "rounded", focus = false }
      ),
      ["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = "rounded", focus = false }
      ),
    },
  }
end

-- Load clangd
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

-- Configuring single server, example: TypeScript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

-- ===============
-- LSP DIAGNOSTICS
-- ===============

-- Configure LSP diagnostics
vim.diagnostic.config {
  virtual_text = false, -- Disables inline diagnostics
  float = { border = "rounded" }, -- Enables floating diagnostics
  signs = true, -- Shows signs in the sign column
  underline = true, -- Underlines errors
  update_in_insert = true, -- Ensures diagnostics update while typing
  severity_sort = true, -- Optional for better sorting
}

-- Define sign icons
local signs = {
  Error = " ", -- Red
  Warn = " ", -- Orange
  Info = " ", -- Blue
  Hint = " ", -- Light Blue
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Define highlight groups
vim.cmd [[
  highlight DiagnosticSignError guifg=#FF5555 guibg=NONE
  highlight DiagnosticSignWarn  guifg=#FFAA55 guibg=NONE
  highlight DiagnosticSignInfo  guifg=#55FFFF guibg=NONE
  highlight DiagnosticSignHint  guifg=#AAAAFF guibg=NONE

  " Full-line highlight (less saturated)
  highlight DiagnosticLineError guibg=#51202A
  highlight DiagnosticLineWarn guibg=#51412A
  highlight DiagnosticLineInfo guibg=#1E5353
  highlight DiagnosticLineHint guibg=#1E2053

  " Highlight error text with a saturated background and underline
  highlight DiagnosticHighlightedError gui=undercurl guisp=Red guibg=#771A1A guifg=NONE
  highlight DiagnosticHighlightedWarn gui=undercurl guisp=Orange guibg=#77501A guifg=NONE
  highlight DiagnosticHighlightedInfo gui=undercurl guisp=LightBlue guibg=#1A7777 guifg=NONE
  highlight DiagnosticHighlightedHint gui=undercurl guisp=Blue guibg=#1A1A77 guifg=NONE
]]

-- Function to apply diagnostic highlights in real-time
local function highlight_diagnostics(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr)

  -- Clear previous highlights
  local ns_id = vim.api.nvim_create_namespace "diagnostic_highlights"
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

  for _, diag in ipairs(diagnostics) do
    local hl_line = "DiagnosticLineError"
    local hl_text = "DiagnosticHighlightedError"

    if diag.severity == vim.diagnostic.severity.WARN then
      hl_line = "DiagnosticLineWarn"
      hl_text = "DiagnosticHighlightedWarn"
    elseif diag.severity == vim.diagnostic.severity.INFO then
      hl_line = "DiagnosticLineInfo"
      hl_text = "DiagnosticHighlightedInfo"
    elseif diag.severity == vim.diagnostic.severity.HINT then
      hl_line = "DiagnosticLineHint"
      hl_text = "DiagnosticHighlightedHint"
    end

    -- Apply full-line highlighting
    vim.api.nvim_buf_add_highlight(bufnr, ns_id, hl_line, diag.lnum, 0, -1)

    -- Apply both underline and more saturated background to problematic text
    if diag.col and diag.end_col then
      vim.api.nvim_buf_add_highlight(bufnr, ns_id, hl_text, diag.lnum, diag.col, diag.end_col)
    end
  end
end

-- Auto-update highlights in real-time
vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter", "TextChanged", "InsertLeave" }, {
  callback = function(args)
    vim.defer_fn(function()
      highlight_diagnostics(args.buf)
    end, 50)
  end,
})

-- Ensure cursorline is always enabled in diagnostics
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local win_id = vim.fn.bufwinid(args.buf)
    if win_id ~= -1 then
      vim.wo[win_id].cursorline = true
    end
  end,
})

-- ========
-- Mappings
-- ========

-- Keybinding for showing floating diagnostics
local map = vim.keymap.set

map("n", "<leader>le", function()
  vim.diagnostic.open_float(nil, { focus = false })
end, { noremap = true, desc = "Show diagnostics for current line" })
map("n", "<leader>ld", function()
  vim.lsp.buf.hover()
end, { desc = "Show function documentation" })
map("n", "<leader>ls", function()
  vim.lsp.buf.signature_help()
end, { desc = "Show function signature" })
local function preview_location_callback(_, result)
  if not result or vim.tbl_isempty(result) then
    return
  end
  vim.lsp.util.preview_location(result[1], { border = "rounded" })
end
map("n", "<leader>lp", function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", params, preview_location_callback)
end, { desc = "Peek function definition" })
map("n", "gd", function()
  vim.lsp.buf_request(
    0,
    "textDocument/definition",
    vim.lsp.util.make_position_params(),
    preview_location_callback
  )
end, { desc = "Go to function definition (floating)" })
map("n", "gr", function()
  vim.lsp.buf_request(
    0,
    "textDocument/references",
    vim.lsp.util.make_position_params(),
    preview_location_callback
  )
end, { desc = "Find all references (floating)" })
