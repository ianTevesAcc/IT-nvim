return {
  "lervag/vimtex",
  ft = "tex", -- Load VimTeX only for .tex files
  init = function()
    -- Compile using latexmk
    vim.g.vimtex_compiler_method = "latexmk"

    -- Disable auto quickfix window
    vim.g.vimtex_quickfix_mode = 0

    -- Use Windows default browser via wslview
    vim.g.vimtex_view_method = "general"
    vim.g.vimtex_view_general_viewer = "/mnt/c/Program Files/SumatraPDF/SumatraPDF.exe"
    vim.g.vimtex_view_general_options = "-reuse-instance"

    -- Alternative: Open PDF in a specific browser
    -- vim.g.vimtex_view_general_viewer = "/mnt/c/Program Files/Mozilla Firefox/firefox.exe"
    -- vim.g.vimtex_view_general_options = ""
  end,
}
