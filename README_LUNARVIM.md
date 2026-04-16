# LunarVim Installation with Chezmoi

This chezmoi configuration includes automatic installation of LunarVim and its prerequisites.

## Installation Order

When you run `chezmoi apply`, the following happens in order:

1. **Repositories** (`run_onchange_00_add_repositories.sh.tmpl`) - Adds necessary package repositories
2. **Packages** (`run_onchange_10_add_packages.sh.tmpl`) - Installs system packages including:
   - Neovim (nvim)
   - Node.js and npm
   - Rust and cargo
   - ripgrep
   - fd-find
   - Python and pip

3. **LunarVim Installation** (`run_once_before_install_lunarvim.sh.tmpl`) - Runs BEFORE config files are applied:
   - Verifies Neovim version (requires >= 0.9.0)
   - Installs npm dependencies (neovim, tree-sitter-cli)
   - Installs Python neovim package (pynvim)
   - Verifies rust tools (fd-find, ripgrep)
   - Runs the LunarVim installer script
   - Uses the stable release branch (release-1.4/neovim-0.9)

4. **Config Files** - Your custom LunarVim configuration is applied:
   - `~/.config/lvim/config.lua`
   - `~/.config/lvim/lazy-lock.json`
   - `~/.config/lvim/empty_init.lua`

## Prerequisites

The following packages are automatically installed via the packages script:

- **Neovim** >= 0.9.0
- **Node.js** and **npm** (for LSP servers and tree-sitter)
- **Rust** and **cargo** (for some plugins)
- **ripgrep** (required by LunarVim for searching)
- **fd-find** (required by LunarVim for file finding)
- **Python** and **pip** (for Python support)
- **Git** (for plugin management)

## Manual Installation

If you need to reinstall LunarVim manually:

```bash
# Remove existing installation
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/uninstall.sh)

# Reinstall
LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/release-1.4/neovim-0.9/utils/installer/install.sh)
```

## Usage

After installation, you can launch LunarVim with:

```bash
lvim
```

The `lvim` executable is installed to `~/.local/bin/lvim`, which should be in your PATH.

## Troubleshooting

### LunarVim command not found

Add `~/.local/bin` to your PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

This should already be configured in your `.zshrc` if you're using the provided dotfiles.

### Neovim version too old

Check your Neovim version:

```bash
nvim --version
```

LunarVim requires Neovim >= 0.9.0. On Fedora, you may need to install from a newer repository or build from source.

### Missing dependencies

If you encounter issues with missing dependencies, you can manually install them:

```bash
# npm dependencies
npm install -g neovim tree-sitter-cli

# Python support
pip3 install --user pynvim

# Rust tools (if not installed via dnf)
cargo install fd-find ripgrep
```

## References

- [LunarVim Official Documentation](https://www.lunarvim.org/docs/installation)
- [LunarVim GitHub Repository](https://github.com/LunarVim/LunarVim)
- [Chezmoi Documentation](https://www.chezmoi.io/)
