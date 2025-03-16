local mason_registry = require "mason-registry"
local debugpy_path = mason_registry.get_package("debugpy"):get_install_path() .. "/venv/bin/python"

return {
  adapter = {
    type = "executable",
    command = debugpy_path,
    args = { "-m", "debugpy.adapter" },
  },
  configurations = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      pythonPath = function()
        return vim.fn.exepath "python3" or "python"
      end,
    },
  },
}
