-- Change cmp selection key to TAB instead of ENTER
local cmp = require 'cmp'

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- Use <Tab> to confirm selection
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),

    -- Disable <CR> from confirming selection
    ["<CR>"] = function(fallback)
      fallback()
    end,

    -- Optionally, use <S-Tab> to navigate backwards
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),

})
