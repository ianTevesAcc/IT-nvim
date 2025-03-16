return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "jay-babu/mason-nvim-dap.nvim", -- Mason integration for DAP
  },

  ft = { "cpp", "c", "rust", "python", "go" }, -- Lazy-load for supported languages
  lazy = true,

  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    -- Automatically install required DAP debuggers via Mason
    require("mason-nvim-dap").setup {
      ensure_installed = { "codelldb", "debugpy", "delve" }, -- Ensure debuggers are installed
      automatic_installation = true,
    }

    -- Define debug adapters and configurations for each language
    local debugger_configs = {
      cpp = "codelldb",
      rust = "codelldb",
      c = "codelldb",
      zig = "codelldb",
      python = "debugpy",
      go = "delve",
    }

    -- Load debugger only for the current file type
    local filetype = vim.bo.filetype
    if debugger_configs[filetype] then
      local debugger = debugger_configs[filetype]
      local debugger_path = string.format("%s/lua/plugins/DAP/%s.lua", vim.fn.stdpath "config", debugger)
      local ok, debugger_config = pcall(dofile, debugger_path)

      if ok and type(debugger_config) == "table" then
        dap.adapters[filetype] = debugger_config.adapter
        dap.configurations[filetype] = debugger_config.configurations
      else
        vim.notify("Failed to load debugger: " .. debugger_path, vim.log.levels.ERROR)
      end
    end

    -- Setup DAP UI
    dapui.setup()

    -- Automatically open/close UI on debugging events
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Debugger Signs
    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff0000", bg = "None" })
    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "⚪", texthl = "Warning", linehl = "debugPC", numhl = "" })

    -- Keybindings for Debugging
    local map = vim.keymap.set
    map("n", "<F5>", dap.continue, { desc = "Start/Continue Debugger" })
    map("n", "<F10>", dap.step_over, { desc = "Step Over" })
    map("n", "<F11>", dap.step_into, { desc = "Step Into" })
    map("n", "<F12>", dap.step_out, { desc = "Step Out" })
    map("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    map("n", "<Leader>dT", function()
      dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
    end, { desc = "Set Conditional Breakpoint" })
    map("n", "<Leader>dc", dap.clear_breakpoints, { desc = "Clear All Breakpoints" })
    map("n", "<Leader>dr", dap.repl.open, { desc = "Open Debug Console" })
    map("n", "<Leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
  end,
}
