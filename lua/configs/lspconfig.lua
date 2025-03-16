-- Load defaults for Lua language server
local lspconfig = require "lspconfig"

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
  if root == nil or root == vim.loop.os_homedir() then
    return fallback_root
  end
  return root
end

-- Configure LSP diagnostics (floating windows instead of inline)
vim.diagnostic.config {
  virtual_text = false, -- Disables inline diagnostics
  float = { border = "rounded" }, -- Enables floating diagnostics
  signs = true, -- Shows signs in the sign column
  underline = true, -- Underlines errors
  update_in_insert = false, -- Avoids updating diagnostics while typing
  severity_sort = true, -- Optional for better sorting
}

-- Keybinding for showing floating diagnostics
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float(nil, { focus = false })
end, { noremap = true, desc = "Show diagnostics for current line" })

-- Example LSP servers
local servers = { "html", "cssls", "lua_ls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- LSPs with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    ro = get_root_dir,
  }
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    root_dir = get_root_dir,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT", -- Neovim uses LuaJIT
        },
        diagnostics = {
          globals = { "vim" }, -- Recognize `vim` as a global
        },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua", -- Neovim's runtime files
            vim.fn.stdpath "config" .. "/lua", -- Your Neovim config files
          },
          checkThirdParty = false, -- Avoids warning about third-party libraries
        },
        telemetry = {
          enable = false, -- Disable telemetry
        },
      },
    },
  }
end

-- Configuring single server, example: TypeScript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
