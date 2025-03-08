-- conform.lua - Formatting setup
local conform = require "conform"

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    go = { "gofmt" },
    python = { "black" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    cs = { "csharpier" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
    async = false, -- Ensure formatting completes before save
  },
}

local function remove_windows_line_endings(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    lines[i] = line:gsub("\r", "") -- Remove ^M
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

local function trim_trailing_whitespace(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    lines[i] = line:gsub("%s+$", "") -- Remove trailing spaces
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

local function remove_empty_lines(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  -- Remove empty lines at start
  while #lines > 0 and lines[1]:match "^%s*$" do
    table.remove(lines, 1)
  end
  -- Remove empty lines at end
  while #lines > 0 and lines[#lines]:match "^%s*$" do
    table.remove(lines, #lines)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

-- Function to fix indentation
local function fix_indentation(bufnr)
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd "normal! gg=G" -- Auto-indent entire file
  end)
end

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    remove_windows_line_endings(args.buf)
    trim_trailing_whitespace(args.buf)
    remove_empty_lines(args.buf)
    fix_indentation(args.buf) -- Fix indentation before saving
  end,
})

return options
