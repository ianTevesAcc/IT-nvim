return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    -- Ensure we are setting the correct initial directory
    local initial_dir = vim.fn.isdirectory(vim.fn.argv(0)) == 1 and vim.fn.argv(0)
      or vim.fn.getcwd()
    vim.cmd("cd " .. initial_dir)

    local nvim_tree = require "nvim-tree"
    local api = require "nvim-tree.api"

    -- Track dotfile visibility
    local show_dotfiles = false

    nvim_tree.setup {
      sync_root_with_cwd = true, -- Sync root directory with the current working directory
      hijack_directories = {
        enable = true, -- Automatically change to the directory of the opened file
      },
      filters = {
        dotfiles = true, -- Hide dotfiles by default
      },
    }

    -- Function to toggle dotfiles visibility
    local function toggle_dotfiles()
      show_dotfiles = not show_dotfiles
      api.tree.toggle_hidden_filter() -- Properly toggles dotfiles visibility
    end

    -- Set keybinding to toggle dotfiles with <leader>k when in nvim-tree
    vim.keymap.set("n", "<leader>k", toggle_dotfiles, { desc = "Toggle dotfiles in nvim-tree" })

    -- Auto-close nvim-tree if it's the last window open
    vim.api.nvim_create_autocmd("BufEnter", {
      nested = true,
      callback = function()
        vim.schedule(function()
          if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == "NvimTree" then
            vim.cmd "quit"
          end
        end)
      end,
    })
  end,
}
