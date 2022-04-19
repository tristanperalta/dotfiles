# dotfiles

## Requirements
- Neovim 0.6+
- NerdFonts
- ElixirLS
- Alacritty
- tmux 3.4+
- [Exa](https://the.exa.website/) - drop-in replacement for ls
- [ripgrep](https://github.com/BurntSushi/ripgrep) - replacement for grep
- [fzf](https://github.com/junegunn/fzf)

## Instruction

Install LSP for html,css,javascrip
```sh
npm i -g vscode-langservers-extracted
```
## Issues

When `ps1_functions` could not be found when running a new session, add `source ~/.bashrc` on `~/.bash_profile`.
