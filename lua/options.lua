require "nvchad.options"

-- Enable cursorline!
local o = vim.o
o.cursorlineopt ='both'

-- Set relative numbers and current line number on
vim.opt.number = true
vim.opt.relativenumber = true

-- Set win32yank as clipboard
vim.g.clipboard = {
  name = 'win32yank',
  copy = {
    ['+'] = 'win32yank.exe -i',
    ['*'] = 'win32yank.exe -i',
  },
  paste = {
    ['+'] = 'win32yank.exe -o',
    ['*'] = 'win32yank.exe -o',
  },
  cache_enabled = 0,
}

-- Disable inline diagnostics and enable floating windows
vim.diagnostic.config({
  virtual_text = false,    -- Disable inline text (warnings, errors, etc.)
  float = {
    severity_sort = true,  -- Sort by severity: errors first, then warnings
    border = 'rounded',    -- Style of the floating window border
    source = true,     -- Always show the source (e.g., LSP server name)
    header = '',           -- Optional header text (can be set to an empty string)
    prefix = '●',          -- Prefix for the diagnostic message (e.g., '●', '>>', etc.)
  },
})
