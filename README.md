# dotfiles

My development setup: **fish + tmux + Neovim**, with a **starship** prompt and a **rofi** launcher,
on Arch-based Linux (CachyOS) with the **COSMIC** desktop and COSMIC Terminal.

## Quick start

```bash
git clone https://github.com/Abd002/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Then open a new terminal. It starts fish inside tmux.

`install.sh` is safe to run again at any time (for example after pulling changes). It:

1. Installs the packages with `pacman` (asks for your password).
2. Links the configs into place. Anything already there is moved to `~/.dotfiles-backup/<date>/` first.
3. Installs the COSMIC keyboard shortcuts.
4. Installs tpm and the tmux plugins.
5. Installs the Neovim plugins (pinned by `lazy-lock.json`), the Mason language servers and formatters, and the treesitter parsers.
6. Makes fish your login shell.

Options: `--skip-packages` (no `pacman`), `--skip-nvim` (skip the slow Neovim step), `--help`.

After the first install:

- Set your git identity if `install.sh` warns about it:
  `git config --global user.name "Your Name"` and `git config --global user.email "you@example.com"`.
- In COSMIC Terminal settings, choose a Nerd Font (e.g. *MesloLGLDZ Nerd Font*) so prompt and `eza` icons render.
- Log out and back in if fish was just made your login shell.
- Optional: run `:Codeium Auth` in Neovim for AI completion, and `npm i -g @openai/codex` for the Codex plugin.

## What goes where

| In this repo | Installed at | How |
|---|---|---|
| `fish/conf.d/` | `~/.config/fish/conf.d` | link |
| `fish/functions/` | `~/.config/fish/functions` | link |
| `nvim/` | `~/.config/nvim` | link |
| `.tmux.conf` | `~/.tmux.conf` | link |
| `starship/` | `~/.config/starship` | link |
| `rofi/` | `~/.config/rofi` | link |
| `.clang-format` | `~/.clang-format` | link |
| `conky/` | `~/.config/conky` | link |
| `conky/conky.service` | `~/.config/systemd/user/conky.service` | link, enabled (starts the widget at login) |
| `cosmic/shortcuts.ron` | `~/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom` | copied, `@HOME@` replaced |

Because most files are links, editing `~/.config/nvim/...` edits this repo directly. Commit from `~/dotfiles`.

The COSMIC shortcuts are copied instead, because the settings app rewrites that file. If you change shortcuts in
COSMIC Settings, copy the file back into `cosmic/shortcuts.ron` (and put `@HOME@` back in place of your home path).

## fish

fish already has autosuggestions, syntax highlighting and git completion built in, so no plugins are needed.

- `conf.d/env.fish`: `EDITOR=nvim`, XDG paths, themes (`NVIM_THEME`, `STARSHIP_THEME`), `PATH`.
  Secrets go in `~/.env` as `KEY=value` lines (never commit that file); they are exported automatically.
- `conf.d/tools.fish`: starship, zoxide (`z`, `zi`), fzf (`Ctrl+R` history, `Ctrl+T` files, `Alt+C` cd), pyenv if installed.
- `conf.d/aliases.fish`: git abbreviations (`gs`, `ga`, `gcm`, `gp`, `gco`, `gafzf`, ...). They expand when you
  press Space, so you see the full command.
- `conf.d/tmux.fish`: every terminal opens inside tmux (see below).
- `functions/`:
  - `quick_commit` (`gqc msg`, `gqcp msg` to also push) prefixes the message with the ticket ID from the branch
    name: on `abc-123-login`, `gqc fix it` commits `ABC-123: fix it`.
  - `v` / `vi` open Neovim, through `poetry run` inside a poetry project.
  - `r` opens ranger and `cd`s to the last directory you browsed.

## tmux

Prefix is **`Ctrl+Space`**.

| Keys | Action |
|---|---|
| `prefix H` / `prefix V` | split side by side / top and bottom (in the current directory) |
| `prefix h j k l` | resize pane |
| `Ctrl+h j k l` | move between tmux panes and Neovim splits |
| `prefix m` | zoom pane |
| `prefix [` then `v`, `y` | copy mode: select, copy to the clipboard |
| `prefix r` | reload `~/.tmux.conf` |
| `prefix I` | install plugins listed in `.tmux.conf` |
| `prefix d` | detach (the session keeps running) |

**Opens automatically:** every new terminal starts in tmux. It re-attaches to a session nobody is using (for example
one you detached from or whose window you closed), otherwise it creates a new one. Typing `exit` in the last pane
closes the terminal. It is skipped inside tmux, Neovim's `:terminal`, the VS Code terminal, TTYs and SSH.
For one terminal without tmux, run `NO_TMUX=1 cosmic-term`.

Plugins: vim-tmux-navigator, tmux-resurrect + tmux-continuum (sessions survive a reboot), CPU/memory in the status bar.

## Neovim

Requires **Neovim 0.12+**. Plugins are managed by lazy.nvim and pinned in `nvim/lazy-lock.json`.

- Run `:Lazy update` to update plugins, then commit the new `lazy-lock.json`.
- Language servers and formatters come from Mason (`:Mason`). Files are formatted on save.
- Treesitter uses the `main` branch. Parsers are listed in `nvim/lua/plugins/treesitter.lua` (keep the list in
  `install.sh` in sync). Parsers for other languages install automatically when you open such a file.
- Theme: set `NVIM_THEME` in `fish/conf.d/env.fish` (`nord` or `onedark`).
- Problems? See [`nvim/nvim-troubleshooting.md`](nvim/nvim-troubleshooting.md) and run `:checkhealth`.
- Keys: press `Space` and wait for the menu, `Space ?` for the current file's keys.
  Cheat sheet inside Neovim: `Space K` (search with `/`), `Space s K` to fuzzy-search it.
  The same sheet as a web page, with an old-to-new table: [`nvim/CHEATSHEET.html`](nvim/CHEATSHEET.html).
  After editing the key data in the HTML, run `node nvim/cheatsheet-gen.js` to regenerate `CHEATSHEET.md`.
- Claude Code runs inside Neovim (claudecode.nvim): `Space a c` opens it, `Space a s` sends a selection,
  and its edits arrive as diffs you accept with `Space a a` or reject with `Space a d`.
- Rust uses rustaceanvim (`Space r …` in Rust files, crate tools in `Cargo.toml`); C/C++ adds clangd extras
  (`Space c h` switches header/source). Rust and C/C++ debug through codelldb (`Space d …`).

## rofi and shortcuts (COSMIC)

| Shortcut | Action |
|---|---|
| `Super+Space` | rofi hub: Apps, Projects, Snippets, Todo |
| `Super+Return` | COSMIC Terminal |

- **Projects** opens a saved folder in Neovim inside tmux (list in `~/.projects.txt`).
- **Snippets** copies a saved text to the clipboard (list in `~/.notes.txt`).
- **Todo** is a quick task list (`~/.todo`): type to add, select to remove.

`Super+Space` replaces COSMIC's default "switch keyboard layout" shortcut.

## Desktop widget (conky)

A translucent "glass" card in the top-right corner of the desktop, behind all windows: clock, CPU and GPU temperature
gauges (teal, then amber from 75 °C, red from 90 °C), CPU / memory / disk bars, network speed, fan speed and battery
health. It uses under 1% of one CPU core and about 40 MB of memory.

- Drawing and layout: `conky/glass.lua` (colours at the top). Window, position and refresh rate: `conky/conky.conf`.
- Sensors are read from `/sys` by name (`k10temp`, `asus`, `BAT0`); GPU temperature comes from `nvidia-smi` every 10 s.
- Restart after editing: `pkill -9 -x conky` (it comes back by itself within a few seconds).
- Runs as the user service `conky.service` through `conky/run.sh`, which restarts conky when COSMIC
  reconfigures the screens (after login, or when a monitor is plugged in or out). Without it, conky stops
  drawing but keeps running. Stop it with `systemctl --user stop conky.service`.
- COSMIC can't blur what is behind the card, so it is tinted glass rather than frosted glass.

## Legacy (not installed by `install.sh`)

- `zsh/`: the previous zsh setup. `fish/` replaces it.
- `sxhkd/`: X11 hotkeys. They do not work on Wayland; the COSMIC shortcuts above replace them.
