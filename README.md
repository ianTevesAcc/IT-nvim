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
- [ ] Set up Linters
- [ ] Set up Dap
- [ ] Set up Debuggers
  - [ ] set up cpp
- [ ] Set <TAB> as select for CMP instead of <CR>
- [ ] Set up MD rendering
- [ ] Set up floating diagnostics instead of inline
- [ ] Fix LSP
  - [ ] add vim as global
  - [ ] fix LSP root
  - [ ] fix linters (add linter for lua, cpp, etc.)

## Broken
- [ ] Lint is currently broken (Works once then never works again at nvim startup)
- [ ] floating diagnostics on `Options.lua` currently broken (probably missed something small)
- [ ] LSP config broken - Getting LSP errors for wrong root and vim not being seen as a global config.

---

## Credits
1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
2) NvChad neovim distro https://nvchad.com as base.
