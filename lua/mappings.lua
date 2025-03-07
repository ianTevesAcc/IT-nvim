require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Normal mode"})

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })

map('n', "<leader>ts", function() require("base46").toggle_theme() end, { desc = "Toggle Theme" })
map('n', "<leader>tt", function() require("base46").toggle_transparency() end, { desc = "Toggle Transparency"})

map('i', "jj", "<ESC>la", { desc = "Skip character" })
map('i', "JJ", "<ESC>lla", { desc = "Skip 2 characters"})

map('n', "o", "o<Esc>", { desc = "Creat line below", noremap = true, silent = true })
map('n', "O", "O<Esc>", { desc = "Create line above", noremap = true, silent = true })

map('n', "<C-w>a", "<ESC>ggVG", { desc = "Select all" })

-- Remove yanking to registars for deleting
-- map('v', "d", "_d", { desc = "Void delete "})
map('n', "dd", '_dd', { desc = "Void delete line", noremap = true, silent = true })
map('n', "dw", '_diw', { desc = "Void delete word", noremap = true, silent = true })

map('n', "X", "Vx", {desc = "Cut line"})

-- Function to indent lines
map('n', '<A-h>', '<<', { noremap = true, silent = true })
map('n', '<A-l>', '>>', { noremap = true, silent = true })
map('v', '<A-h>', '<gv', { noremap = true, silent = true })
map('v', '<A-l>', '>gv', { noremap = true, silent = true })

-- Function to move lines up and down
map('n', '<A-j>', ':m .+1<CR>==', { noremap = true, silent = true })
map('n', '<A-k>', ':m .-2<CR>==', { noremap = true, silent = true })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

function RenameFunction()
  -- Get the selected text (function name)
  local pos1 = vim.fn.getpos("'<")
  local pos2 = vim.fn.getpos("'>")

  local ls, cs = pos1[2], pos1[3] -- Start line & column
  local le, ce = pos2[2], pos2[3] -- End line & column

  local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)

  if #lines == 0 then
    print("No function name selected!")
    return
  end

  local old_name = lines[1]:sub(cs, ce)
  if old_name == "" then
    print("No function name selected!")
    return
  end

  -- Ask for the new function name
  local new_name = vim.fn.input("Rename function '" .. old_name .. "' to: ")
  if new_name == "" then
    print("Rename cancelled.")
    return
  end

  -- Perform substitution across the whole file
  vim.cmd(string.format("%%s/\\<%s\\>/%s/g", vim.fn.escape(old_name, '\\'), new_name))

  print("Renamed all occurrences of '" .. old_name .. "' to '" .. new_name .. "'")
end

-- Keymap to trigger function rename in visual mode
map('v', "<leader>r", ":lua RenameFunction()<CR>", { noremap = true, silent = true })

map('n', "<leader>dd", "<CMD> Nvdash <CR>", { desc = "Load Dashboard" })
