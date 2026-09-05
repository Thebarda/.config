# Hyprland config for a bare system

A self-contained Hyprland configuration: no Omarchy, no distro scripts, no
wrapper binaries. Everything is either the native `hl.*` Lua API that ships
with Hyprland 0.56+ or a plain command looked up on `PATH` when the config
loads. Tools that aren't installed drop the bindings that need them instead of
breaking the config, so this comes up usable on a machine with nothing but
Hyprland on it, and gets better as packages are added.

It's the same keymap, look, and window behaviour as the Omarchy setup in
`../hypr`, minus the parts that only exist inside Omarchy (see
[What's different](#whats-different-from-the-omarchy-config)).

## Install

```bash
# Back up whatever is there now
mv ~/.config/hypr ~/.config/hypr.bak

# Then either copy the directory
cp -r hypr-new ~/.config/hypr

# ...or symlink it, to keep editing it in place
ln -s "$PWD/hypr-new" ~/.config/hypr
```

The directory finds itself at load time, so the name it's checked out under
doesn't matter -- only where it's linked from.

Then start Hyprland (`Hyprland`, or `uwsm start hyprland-uwsm.desktop` if you
use uwsm), and check the config loaded clean:

```bash
hyprctl reload
hyprctl configerrors
```

## What to edit

| File | What's in it |
| --- | --- |
| `programs.lua` | **Start here.** Which terminal, browser, launcher, lock screen, and so on get used. |
| `monitors.lua` | Display layout, keyed by hostname. |
| `input.lua` | Keyboard layout, repeat rate, touchpad. |
| `looknfeel.lua` | Gaps, borders, rounding, shadows, animations. |
| `bindings/` | Keybindings, split by what they do. |
| `windows.lua` | Per-app window rules: floating, opacity, screen-share hiding. |
| `autostart.lua` | What launches with the session. |
| `local.lua` | Optional, not tracked: loaded last, so it overrides everything above. |

`helpers.lua` and `hyprland.lua` are the plumbing; they rarely need touching.

Every binding is written as `o.bind(keys, description, command)`. The
description is what `SUPER + K` lists, so give new bindings one.

```lua
-- In bindings/apps.lua, or in local.lua
o.bind("SUPER + SHIFT + S", "SSH", { tui = "ssh your-server" })
o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian" })

-- Replace a default: unbind it first
hl.unbind("SUPER + SPACE")
o.bind("SUPER + SPACE", "Launcher", "rofi -show drun")
```

## Dependencies

Hyprland 0.56 or newer is the only hard requirement -- the Lua config API
landed there.

Everything else is optional. Nothing here breaks when a package is missing;
the binding or autostart that needed it just doesn't exist that session.

| Want | Install | Used by |
| --- | --- | --- |
| Terminal | `ghostty`, `alacritty`, `kitty`, or `foot` | `SUPER + RETURN` |
| App launcher | `fuzzel`, `wofi`, `rofi`, or `tofi` | `SUPER + SPACE`, clipboard history, `SUPER + K` |
| Status bar | `waybar` | autostart, `SUPER + SHIFT + SPACE` |
| Notifications | `mako`, `dunst`, or `swaync` | autostart, `SUPER + ,` |
| Lock screen | `hyprlock` | `SUPER + CTRL + L` |
| Idle / sleep | `hypridle` | autostart |
| Wallpaper | `hyprpaper` | autostart |
| Screenshots | `grim`, `slurp`, `wl-clipboard`, `jq` | `PRINT` |
| Colour picker | `hyprpicker` | `SUPER + PRINT` |
| Clipboard history | `cliphist`, `wl-clipboard` | `SUPER + CTRL + V` |
| Volume keys | `wireplumber` (`wpctl`) or `pulseaudio` (`pactl`) | media keys |
| Brightness keys | `brightnessctl` | media keys |
| Media keys | `playerctl` | media keys |
| Password prompts | `hyprpolkitagent` | autostart |
| Night light | `hyprsunset` | `SUPER + CTRL + N` |
| Auto-mounting USB drives | `udiskie` | autostart |
| Per-app systemd scopes | `uwsm` | every launched app |
| Column swapping | `jq` | `SUPER + SHIFT + J` |

A reasonable starting set on Arch:

```bash
sudo pacman -S hyprland hyprlock hypridle hyprpaper hyprpicker hyprpolkitagent \
  waybar fuzzel mako foot grim slurp wl-clipboard cliphist brightnessctl \
  playerctl jq udiskie xdg-desktop-portal-hyprland
```

`hyprlock`, `hypridle`, `hyprpaper`, and `waybar` each want their own config
file; without one they fall back to their built-in defaults, which work but
look plain. `hyprsunset.conf` and `xdph.conf` in this directory are read
automatically by hyprsunset and xdg-desktop-portal-hyprland.

## Keybindings

`SUPER + K` shows the live list, read from the file the config writes on every
load (`$XDG_STATE_HOME/hypr/keybindings.tsv`). The essentials:

| Keys | Action |
| --- | --- |
| `SUPER + RETURN` | Terminal |
| `SUPER + SPACE` | Application launcher |
| `SUPER + W` | Close window |
| `SUPER + 1`..`0` | Switch workspace (`+ SHIFT` moves the window there) |
| `SUPER + arrows` | Move focus (`+ SHIFT` swaps windows) |
| `SUPER + F` / `SUPER + ALT + F` | Fullscreen / full width |
| `SUPER + T` / `SUPER + O` | Float / float, pin and centre |
| `SUPER + J` / `SUPER + SHIFT + J` | Toggle split direction / mirror the columns |
| `SUPER + L` | Switch this workspace between dwindle and scrolling |
| `SUPER + G` | Group windows into tabs |
| `SUPER + S` | Scratchpad |
| `SUPER + C` / `V` / `X` | Copy, paste, cut -- in terminals too |
| `PRINT` | Screenshot a region (`SHIFT` the screen, `ALT` the window) |
| `SUPER + CTRL + L` | Lock |
| `SUPER + SHIFT + ESCAPE` | Exit Hyprland |

## Vendored scripts

`bin/` is put on `PATH` for everything Hyprland spawns.

- `hypr-workspace-invert-columns` -- mirrors a two-column workspace left to right.
- `hypr-screenshot` -- region, window, or output; clipboard plus a dated file
  in `~/Pictures/Screenshots`.
- `hypr-keybindings` -- the `SUPER + K` cheatsheet.

## What's different from the Omarchy config

Things that were Omarchy services or scripts, and what happens here instead:

- **Bar, menus, and notifications.** The Omarchy shell (`SUPER + SPACE` menu,
  bar panels under `SUPER + CTRL + <letter>`, the emoji and clipboard
  overlays, `SHIFT + TAB` workspace overview) is gone. `SUPER + SPACE` opens
  whichever launcher is installed; the bar is waybar, configured on its own.
- **Themes.** No theme switcher. Border colours live in `looknfeel.lua`
  (currently Kanagawa's), and each app is themed in its own config.
- **Screen recording, OCR capture, sharing, reminders, dictation, the
  calculator, web apps, and TUI launchers.** Not replaced; add bindings in
  `local.lua` for whatever you install.
- **Workspace layout toggle** (`SUPER + L`) is now native Lua, but the choice
  only lasts until the compositor restarts -- Omarchy persisted it in state
  files.
- **Laptop lid, display scaling, and monitor toggles.** Left to logind
  (which suspends on lid close by default) and `hyprctl`.
- **Idle, lock, and wallpaper** are plain hypridle / hyprlock / hyprpaper,
  autostarted when installed, each with its own config file.
