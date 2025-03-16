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

lint.linters.ast_grep = {
  cmd = "ast-grep",
  stdin = true,
  append_fname = true,
  args = { "--json", "--rule-file", "sgconfig.yml" }, -- Ensure `sgconfig.yml` exists
  parser = function(output, bufnr)
    local diagnostics = {}
    local decoded = vim.fn.json_decode(output)

    if decoded and decoded.matches then
      for _, match in ipairs(decoded.matches) do
        table.insert(diagnostics, {
          bufnr = bufnr,
          lnum = match.range.start.line - 1,
          col = match.range.start.column - 1,
          end_lnum = match.range["end"].line - 1,
          end_col = match.range["end"].column - 1,
          severity = vim.diagnostic.severity.WARN,
          source = "ast-grep",
          message = match.message or "Code issue detected",
        })
      end
    end
    return diagnostics
  end,
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
