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

-- Example LSP servers
local servers = { "html", "cssls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- LSPs with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    root_dir = root_pattern, -- Add root pattern here
  }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
