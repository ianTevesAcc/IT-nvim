return {
  "lervag/vimtex",
  ft = "tex",
  config = function()
    vim.g.vimtex_view_method = "general"
    vim.g.vimtex_view_general_viewer = "sumatraPDF"

    -- Ensure the Windows path is correctly extracted
    local tex_path = vim.fn.systemlist("wslpath -w " .. vim.fn.expand "%:p")[1]

    -- Fix path slashes for Windows compatibility
    tex_path = tex_path:gsub("\\", "/") -- Convert backslashes to forward slashes

    vim.g.vimtex_view_general_options = "-reuse-instance -forward-search "
      .. tex_path
      .. " @line @pdf"
  end,
}
