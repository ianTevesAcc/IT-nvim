return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    -- Ensure we are setting the correct initial directory
    local initial_dir = vim.fn.isdirectory(vim.fn.argv(0)) == 1 and vim.fn.argv(0) or vim.fn.getcwd()
    vim.cmd("cd " .. initial_dir)

    require("nvim-tree").setup {
      sync_root_with_cwd = true, -- Sync root directory with the current working directory
      hijack_directories = {
        enable = true, -- Automatically change to the directory of the opened file
      },
    }

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
