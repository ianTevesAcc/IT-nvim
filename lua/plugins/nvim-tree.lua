
return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    -- Detect if an argument (a file or directory) is passed to Neovim
    local initial_dir = vim.fn.argc() > 0 and vim.fn.argv(0) or vim.fn.getcwd()

    require'nvim-tree'.setup {
      sync_root_with_cwd = true,  -- Sync root directory with the current working directory
      hijack_directories = {
        enable = true,  -- Automatically change to the directory of the opened file
        auto_open = true,
      },
    }

    -- Ensure nvim-tree uses the passed directory as root
    vim.cmd("cd " .. initial_dir)

    -- Auto-close nvim-tree if it's the last window open
    vim.api.nvim_create_autocmd("BufEnter", {
      nested = true,
      callback = function()
        if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == "NvimTree" then
          vim.cmd("quit")
        end
      end,
    })
  end
}


