-- Change cmp selection key to TAB instead of ENTER
local cmp = require "cmp"

cmp.setup {
  mapping = cmp.mapping.preset.insert {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm { select = true }
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<CR>"] = function(fallback)
      fallback()
    end,

    ["<S-Tab>"] = cmp.mapping(function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
    end, { "i", "s" }),
  },
}
