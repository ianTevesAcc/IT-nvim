-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@class ChadrcConfig
local M = {}

M.base46 = {
  theme_toggle = { "tokyodark", "tokyonight" },
  theme = "tokyonight",
  transparency = "true",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.nvdash = {
  load_on_startup = true,

  -- This is suposed to belong in options.lua but is working only in chadrc - Cause may be related to a plugin that is not being handled correctly (https://github.com/NvChad/NvChad/discussions/2411)
  vim.opt_local.formatoptions:remove { "o" },
}

M.ui = {
  tabufline = {
    lazyload = false,
  },
}

return M
