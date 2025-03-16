require "nvchad.options"

-- Enable cursorline!
local o = vim.o
o.cursorlineopt = "both"

-- Set relative numbers and current line number on
vim.opt.number = true
vim.opt.relativenumber = true

-- Set win32yank as clipboard
vim.g.clipboard = {
  name = "win32yank",
  copy = {
    ["+"] = "win32yank.exe -i",
    ["*"] = "win32yank.exe -i",
  },
  paste = {
    ["+"] = "win32yank.exe -o",
    ["*"] = "win32yank.exe -o",
  },
  cache_enabled = 0,
}

-- Conceal Secrets
local conceal_ns = vim.api.nvim_create_namespace "conceal_secrets"
local hidden = true -- Track toggle state

local function conceal_secrets()
  vim.api.nvim_buf_clear_namespace(0, conceal_ns, 0, -1) -- Clear previous marks

  if hidden then
    local secret_patterns =
      { "secret%s*=%s*['\"](.-)['\"]", "password%s*=%s*['\"](.-)['\"]", "API_KEY%s*=%s*['\"](.-)['\"]" }

    for _, pattern in ipairs(secret_patterns) do
      for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
        local start_pos, end_pos, match = line:find(pattern)
        if start_pos and match then
          local lnum = vim.fn.search(match, "n") - 1
          vim.api.nvim_buf_set_extmark(0, conceal_ns, lnum, start_pos, {
            virt_text = { { "******", "Comment" } }, -- Overlay with ***
            virt_text_pos = "overlay",
            hl_mode = "combine",
          })
        end
      end
    end
  end
end

-- Toggle Function
local function toggle_conceal()
  hidden = not hidden
  conceal_secrets()
end

-- Keybinding to toggle visibility
vim.keymap.set("n", "<leader>rr", toggle_conceal, { desc = "Toggle Secret Concealment" })

-- Auto conceal secrets on buffer read
vim.api.nvim_create_autocmd("BufReadPost", { callback = conceal_secrets })

-- -- Disable inline diagnostics and enable floating windows
-- vim.diagnostic.config {
--   virtual_text = false, -- Disable inline text (warnings, errors, etc.)
--   float = {
--     severity_sort = true, -- Sort by severity: errors first, then warnings
--     border = "rounded", -- Style of the floating window border
--     source = true, -- Always show the source (e.g., LSP server name)
--     header = "", -- Optional header text (can be set to an empty string)
--     prefix = "●", -- Prefix for the diagnostic message (e.g., '●', '>>', etc.)
--   },
-- }
