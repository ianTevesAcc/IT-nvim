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
vim.keymap.set("n", "<leader>de", function()
  vim.diagnostic.open_float(nil, { focus = false })
end, { desc = "Show diagnostics for current line" })

-- Example LSP servers
local servers = { "html", "cssls", "lua_ls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- LSPs with default config
for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    root_dir = function(fname)
      return root_pattern(fname) or vim.fn.getcwd() -- Use current working directory as fallback
    end,
  }
end

-- Special configuration for Lua language server
lspconfig.lua_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  root_dir = function(fname)
    -- Try to detect a valid project root
    local root = root_pattern(fname)
    if root and root ~= "/home/ian" then
      return root
    end

    -- Fallback: If no valid root is found, use Neovim's config directory (or disable workspace)
    local fallback_root = vim.fn.stdpath "config" -- ~/.config/nvim
    return fallback_root ~= "/home/ian" and fallback_root or nil
  end,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = { "vim" }, -- Prevent `vim` being marked as undefined
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.fn.stdpath "config",
          vim.fn.stdpath "data",
          unpack(vim.api.nvim_get_runtime_file("", true)),
        },
      },
      telemetry = { enable = false },
    },
  },
}

-- Configuring single server, example: TypeScript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

-- Configuring single server, example: TypeScript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
