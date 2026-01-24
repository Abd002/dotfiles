# dotfiles

Personal configuration files for my development setup.

## Structure

- `nvim/` → `~/.config/nvim`
- `.tmux.conf` → `~/.tmux.conf`
- `.clang-format` → `~/.clang-format`
- `wezterm/` → `C:\Users\abd\AppData\.config\wezterm` (Windows)

## Usage

Clone the repo, then link/copy the configs to the locations above.

### Example (Linux)
```bash
git clone https://github.com/abd002/dotfiles.git
cd dotfiles

ln -s "$PWD/nvim" ~/.config/nvim
ln -s "$PWD/.tmux.conf" ~/.tmux.conf
ln -s "$PWD/.clang-format" ~/.clang-format
