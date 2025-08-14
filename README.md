# dotfiles

Personal Linux dotfiles configuration for development environment.

## Requirements
- Neovim 0.6+
- NerdFonts
- Alacritty
- tmux 3.4+
- [Exa](https://the.exa.website/) - drop-in replacement for ls
- [ripgrep](https://github.com/BurntSushi/ripgrep) - replacement for grep
- [fzf](https://github.com/junegunn/fzf)

## Installation

### 1. Install dotfiles via symlinks
```bash
make all
```

### 2. Install system dependencies (optional)
```bash
ansible-playbook playbook.yml
```
This installs ripgrep, fzf, and exa automatically.

### 3. Install language servers
```bash
# Web development LSPs
npm i -g vscode-langservers-extracted

# Elixir development (handled automatically by Mason in Neovim)
# ElixirLS will be installed when you first open an .ex/.exs file
```

### 4. For better Elixir LSP experience
To enable go-to-definition for Elixir core modules:
```bash
# Install Elixir with source code
asdf install elixir 1.18.4-otp-27 --source
```

## Key Features

### Neovim Configuration
- **Plugin manager**: lazy.nvim
- **LSP**: Mason + ElixirLS, TypeScript, Python, CSS, Lua
- **Completion**: blink.cmp with enhanced Elixir support
- **File explorer**: Neo-tree
- **Fuzzy finder**: Telescope
- **Theme**: Nightfox

### Shell Configuration  
- **Custom prompt**: Git/Mercurial branch status with color coding
- **Aliases**: Git, Ruby/Rails, and tmux shortcuts
- **History**: Enhanced bash history settings

### Terminal Tools
- **tmux**: Vim-style navigation with Nightfox theme
- **Alacritty**: GPU-accelerated terminal emulator
- **i3**: Tiling window manager configuration

## Common Commands

```bash
# Remove symlinks
make clean

# Reload tmux config
<prefix>r  # (Ctrl-a + r)

# Neovim shortcuts (Leader: -)
-t          # Toggle file explorer
-o          # Find files
-a          # Live grep search
K           # Show documentation
gd          # Go to definition
```

## Troubleshooting

### ps1_functions not found
When `ps1_functions` could not be found when running a new session, add `source ~/.bashrc` to `~/.bash_profile`.

### ElixirLS go-to-definition issues
If `gd` shows "Can't find file in path":
1. Ensure your project is compiled: `mix compile`
2. Install Elixir with sources: `asdf install elixir 1.18.4-otp-27 --source`
3. For dependencies: `mix deps.get --force && mix deps.compile --force`
