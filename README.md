# IT nvim
**This repo is my nvim config built on top of NvChad neovim distro!**

- The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
- So you just import its modules , like `require "nvchad.options" , require "nvchad.mappings"`
- So you can delete the .git from this repo ( when you clone it locally ) or fork it :)
- You can see nvim cheatsheet by pressing `<leader>ch` or command `:NvCheatsheet`

---

## To Do List
- [x] Set up git remote repo
- [x] Update README
- [x] Set up Conform
- [x] Set up Linters
- [x] Set up Dap
- [x] Set up Dap-UI
- [x] Set up Debuggers
  - [x] set up cpp, rust, go, c, zig, python
- [x] Set <TAB> as select for CMP instead of <CR>
- [ ] Set up MD rendering
  - [x] Latex rendering
  - [ ] Live MD Render Plugin
  - [ ] Configure MD rendering
- [x] Set up floating diagnostics instead of inline
- [x] Fix LSP
  - [x] add vim as global
  - [x] fix LSP root
  - [x] fix linters (add linter for lua, cpp, etc.)
- [ ] Add mappings:
  - [ ] route delete and paste over to void register (I think I saw this somewhere in Primeagen nvim set up tutorial series)
  - [ ] in .md file cross out selected {'n', "~"}
- [ ] Add plugins:
  - [ ] leap nvim
  - [ ] mini surround nvim
  - [ ] ai copilot
    - [ ] yazi nvim
  - [ ] Add Markdown Live rendering
  - [ ] Add Markdown Keymaps
  - [x] Add Latex Live Rendering
  - [x] Add Latex Keymaps
  - [ ] Add a way to go to current line when clicking in sumatraPDF or nvim .tex file
- [x] disable new line comment
- [x] Added LSP highlights
- [ ] Create a Latex Suite plugin
  - [ ] Latex Suite fast mappings
  - [ ] Latex Suite formula mappings
  - [ ] Latex Suite Mathjax - Math block and Math inline mappings
  - [ ] Latex TikzJax Mappings
  - [ ] Make it complement with Obsidian TikzJax Renderer (Maybe fork this to work with rendering to browser or inline render through Term emulator for inline rendering)


## Broken
- [x] ~~floating diagnostics broken again (may be because of changes in lspconfig.lua)~~
- [x] ~~Conform format on save resets cursor placement to top of file and resets transparency of nvim (Add function to remember cursor before format save, either re-toggle transparency on save or prevent transparency toggle in the first place) - couldn't find documentation for persistent transparency. I just set transparency to always be transparent.~~
- [x] ~~Lint is currently broken (Works once then never works again at nvim startup)~~
- [x] ~~floating diagnostics on `Options.lua` currently broken (probably missed something small)~~
- [x] ~~LSP config broken - Getting LSP errors for wrong root and vim not being seen as a global config.~~

---

## Credits
1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
2) NvChad neovim distro https://nvchad.com as base.
