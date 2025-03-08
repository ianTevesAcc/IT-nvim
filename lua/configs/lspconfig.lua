-- Load defaults for Lua language server
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Lua language server configuration
lspconfig.lua_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = function(fname)
    -- Try to find a proper root using Git or Lua config files
    local root = lspconfig.util.find_git_ancestor(fname)
    if root then
      return root -- If Git repository exists, use it as the root
    end
    -- Otherwise, fallback to finding Lua configuration files
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
    -- If no root config found, fallback to current working directory
    return root_pattern(fname) or vim.fn.getcwd()
  end,
  single_file_support = true, -- Support for single Lua files
}

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
