# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository for Linux development environment configuration. It contains configuration files for terminal tools, shell customization, and development applications including Neovim, tmux, Alacritty, and i3 window manager.

## Installation and Setup Commands

### Install dotfiles via symlinks
```bash
make all
```
This creates symlinks from the repository files to the appropriate locations in the home directory.

### Remove dotfiles symlinks
```bash
make clean
```

### Install system dependencies (Ansible)
```bash
ansible-playbook playbook.yml
```
This installs ripgrep, fzf, and exa using the included Ansible playbook.

### Manual dependency installation
Required tools that need manual installation:
- Neovim 0.6+
- NerdFonts
- ElixirLS
- Alacritty 
- tmux 3.4+

Language server for web development:
```bash
npm i -g vscode-langservers-extracted
```

## Architecture and Key Components

### Shell Configuration
- **bashrc**: Main bash configuration with history settings, aliases, and environment variables
- **bash/aliases**: Git, Ruby/Rails, and tmux aliases for common workflows
- **bash/ps1_functions**: Custom prompt with Git/Mercurial branch information and color coding
- **bash_aliases**: Additional user-specific aliases (sources bash/aliases)

### Terminal and Development Tools
- **tmux.conf**: tmux configuration with Nightfox color scheme, vim-style navigation, and vim-tmux-navigator integration
- **config/alacritty/alacritty.toml**: Terminal emulator configuration
- **config/nvim/**: Neovim configuration using lazy.nvim plugin manager

### Neovim Setup
- **init.lua**: Bootstrap script for lazy.nvim with core options and keymaps
- **lua/plugins.lua**: Plugin specifications including:
  - Nightfox colorscheme
  - Neo-tree file explorer
  - Telescope fuzzy finder
  - Treesitter syntax highlighting (nvim-treesitter `main` branch)
  - LSP configuration with Mason
  - Native LSP completion via `vim.lsp.completion`

### Window Manager
- **i3config**: i3 window manager configuration
- **i3status**: Status bar configuration for i3

### Git Configuration
- **gitconfig**: Git user settings, aliases, and default branch configuration
- **gitignore**: Global gitignore patterns

## Common Development Workflows

### Neovim Key Mappings
- Leader key: `-`
- `<leader>t`: Toggle Neo-tree file explorer
- `<leader>o`: Telescope find files
- `<leader>a`: Telescope live grep
- `<C-h/j/k/l>`: Vim-tmux-navigator pane switching
- `gK`: Toggle diagnostic virtual lines

#### Elixir-specific mappings (when in .ex/.exs files):
- `<leader>fp`: Convert pipe to function call
- `<leader>tp`: Convert function call to pipe
- `<leader>em`: Expand macro (visual mode)
- `<leader>et`: Run Elixir tests

### Git Aliases (from gitconfig)
- `git st`: status
- `git co`: checkout  
- `git ci`: commit
- `git br`: branch
- `git dc`: diff --cached
- `git hist`: formatted log with graph

### Shell Aliases (from bash/aliases)
- `gs`: git status
- `ga`: git add
- `gc`: git commit
- `gd`: git diff
- `be`: bundle exec
- `tmux`: launches with 256-color support

### tmux Configuration
- Prefix key: `C-a`
- `|`: horizontal split
- `-`: vertical split
- `h/j/k/l`: pane navigation (vim-style)
- Mouse support enabled
- Configuration reload: `<prefix>r`

## ElixirLS Configuration

### Features Enabled
- **Dialyzer integration**: Type checking and analysis
- **Test lenses**: Inline test running capabilities  
- **Spec suggestions**: Automatic typespec recommendations
- **Auto-formatting**: Format on save with mix format
- **Code completion**: Enhanced with function signatures
- **Enhanced navigation**: Pipe operators and macro expansion tools

### ElixirLS Settings
- Uses Mason-installed ElixirLS v0.27.2
- Elixir 1.18.4 with OTP 27 via asdf
- Dialyzer enabled for better type checking
- Mix environment: dev
- Auto-fetch dependencies: disabled (for performance)

## Environment Notes

- Default editor: vim (set in bashrc)
- Man page viewer: nvim +Man!
- PS1 functions provide Git/Mercurial branch status with color coding
- Requires sourcing ~/.bashrc in ~/.bash_profile if ps1_functions not found
- Supports both Git and Mercurial repositories with branch-specific coloring