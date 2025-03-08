-- lint.lua - Linting setup
local lint = require "lint"

lint.linters_by_ft = {
  lua = { "ast-grep" },
  python = { "ast-grep" },
  go = { "ast-grep" },
  c = { "ast-grep" },
  cpp = { "ast-grep" },
  csharp = { "ast-grep" },
}

-- Auto-run linters on save
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
  callback = function()
    lint.try_lint()
  end,
})

-- Notify user if linting fails
vim.api.nvim_create_autocmd("User", {
  pattern = "ConformFormatFailed",
  callback = function()
    vim.notify("Formatting failed. Check :ConformInfo for details.", vim.log.levels.WARN)
  end,
})
