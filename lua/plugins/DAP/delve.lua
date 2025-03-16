local mason_registry = require "mason-registry"
local delve_path = mason_registry.get_package("delve"):get_install_path() .. "/dlv"

return {
  adapter = {
    type = "server",
    host = "127.0.0.1",
    port = 38697,
    executable = {
      command = delve_path,
      args = { "dap", "-l", "127.0.0.1:38697" },
    },
  },
  configurations = {
    {
      type = "go",
      name = "Debug Go",
      request = "launch",
      program = "${file}",
    },
  },
}
