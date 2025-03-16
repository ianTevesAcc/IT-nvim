local mason_registry = require "mason-registry"
local codelldb_path = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/adapter/codelldb"

-- Get current filetype
local filetype = vim.bo.filetype

-- Define configurations per language
local configs = {
  c = {
    {
      name = "Launch C",
      type = "c",
      request = "launch",
      program = function()
        return vim.fn.input("Path to C executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      args = {},
    },
  },

  cpp = {
    {
      name = "Launch C++",
      type = "cpp",
      request = "launch",
      program = function()
        return vim.fn.input("Path to C++ executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      args = {},
    },
  },

  rust = {
    {
      name = "Launch Rust",
      type = "c",
      request = "launch",
      program = function()
        return vim.fn.input("Path to Rust executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      args = {},
      env = { "RUST_BACKTRACE=1" },
    },
  },

  zig = {
    {
      name = "Launch Zig",
      type = "c",
      request = "launch",
      program = function()
        local zig_bin = vim.fn.getcwd() .. "/zig-out/bin/"
        return vim.fn.input("Path to Zig executable: ", zig_bin, "file")
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      args = {},
    },
  },
}

-- Return only the relevant debugger for the current filetype
return {
  adapter = {
    type = "server",
    port = "${port}",
    executable = {
      command = codelldb_path,
      args = { "--port", "${port}" },
    },
  },
  configurations = configs[filetype] or {},
}
