-- Window and layer rules.
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Apps that ask to be maximized on open get tiled instead.
o.window(".*", { suppress_event = "maximize" })

-- Everything is translucent by default; the rules further down take the tag
-- off the windows where transparency gets in the way, and the last rule in
-- this file applies the opacity to whatever still carries it.
o.window(".*", { tag = "+default-opacity" })

-- Fix some dragging issues with XWayland.
o.window({
  class = "^$",
  title = "^$",
  xwayland = true,
  float = true,
  fullscreen = false,
  pin = false,
}, { no_focus = true })

-- Terminals ------------------------------------------------------------------

-- One definition of "is a terminal", used by the universal clipboard bindings
-- to decide whether to send Ctrl+C or Ctrl+Insert.
o.window(
  "(Alacritty|kitty|com\\.mitchellh\\.ghostty|foot|org\\.codeberg\\.dnkl\\.foot|wezterm|XTerm|konsole|org\\.gnome\\.Terminal)",
  { tag = "+terminal" }
)

-- Browsers -------------------------------------------------------------------

o.window("((google-)?[cC]hrom(e|ium)|[bB]rave-browser|[mM]icrosoft-edge|Vivaldi-stable|helium)", { tag = "+chromium-based-browser" })
o.window("([fF]irefox|zen|librewolf)", { tag = "+firefox-based-browser" })

-- Only dim the browser when it's unfocused; reading a page through a
-- translucent window is miserable.
o.window({ tag = "chromium-based-browser" }, { tag = "-default-opacity", tile = true, opacity = "1.0 0.985" })
o.window({ tag = "firefox-based-browser" }, { tag = "-default-opacity", opacity = "1.0 0.985" })

-- Video calls and video sites: fully opaque.
o.window("(^.+-youtube\\.com__.*$|^.+-app\\.zoom\\.us__wc_home.*$)", { tag = "-chromium-based-browser" })
o.window("(^.+-youtube\\.com__.*$|^.+-app\\.zoom\\.us__wc_home.*$)", { tag = "-default-opacity" })

-- Hide the "... is sharing your screen" indicator windows.
o.window({ title = ".*is sharing.*" }, { workspace = "special silent" })

-- Floating windows -----------------------------------------------------------

o.window({ tag = "floating-window" }, { float = true })
o.window({ tag = "floating-window" }, { center = true })
o.window({ tag = "floating-window" }, { size = { 875, 600 } })

o.window("(org\\.gnome\\.NautilusPreviewer|org\\.gnome\\.Evince|imv|mpv|blueman-manager|nm-connection-editor|pavucontrol|pwvucontrol)", {
  tag = "+floating-window",
})

-- The portal only ever shows dialogs -- file pickers, screen shares,
-- permission prompts -- so all of its windows belong in the floating
-- treatment, whatever the app that asked for it titled them.
o.window("xdg-desktop-portal-gtk", { tag = "+floating-window" })
o.window({
  class = "(sublime_text|DesktopEditors|org\\.gnome\\.Nautilus)",
  title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)",
}, { tag = "+floating-window" })

-- Picture-in-picture ---------------------------------------------------------

o.window({ title = "(Picture.?in.?[Pp]icture)" }, { tag = "+pip" })
o.window({ tag = "pip" }, {
  tag = "-default-opacity",
  float = true,
  pin = true,
  size = { 600, 338 },
  keep_aspect_ratio = true,
  border_size = 0,
  opacity = "1 1",
  move = { "(monitor_w-window_w-40)", "(monitor_h*0.04)" },
})

-- Google Meet's PiP uses the meeting title instead of "Picture-in-Picture".
o.window({ tag = "chromium-based-browser", title = "^Meet - .+" }, {
  tag = "-default-opacity",
  float = true,
  pin = true,
  size = { 600, 338 },
  keep_aspect_ratio = true,
  border_size = 0,
  opacity = "1 1",
  move = { "(monitor_w-window_w-40)", "(monitor_h-window_h-40)" },
})

-- Per-app tweaks -------------------------------------------------------------

-- Colour and video work, and anything where transparency lies about what's
-- on screen.
o.window("^(zoom|vlc|mpv|org\\.kde\\.kdenlive|com\\.obsproject\\.Studio|imv|org\\.gnome\\.NautilusPreviewer|qemu)$", {
  tag = "-default-opacity",
})
o.window("^(zoom|vlc|mpv|org\\.kde\\.kdenlive|com\\.obsproject\\.Studio|imv|org\\.gnome\\.NautilusPreviewer|qemu)$", {
  opacity = "1 1",
})

-- Keep password managers out of screen shares and recordings.
o.window("^(1[pP]assword|Bitwarden|org\\.keepassxc\\.KeePassXC)$", { no_screen_share = true, tag = "+floating-window" })

-- Don't let Telegram steal focus on every new message.
o.window("org.telegram.desktop", { focus_on_activate = false })

-- JetBrains IDEs mishandle focus-follows-mouse.
o.window("^(jetbrains-.*)$", { no_follow_mouse = true })

o.window("steam", { float = true, idle_inhibit = "fullscreen" })
o.window({ class = "steam", title = "Steam" }, { center = true, size = { 1100, 700 } })
o.window({ class = "steam", title = "Friends List" }, { size = { 460, 800 } })
o.window("steam.*", { tag = "-default-opacity", opacity = "1 1" })

-- Games and streaming clients shouldn't be interrupted by the idle timer.
o.window("(com\\.moonlight_stream\\.Moonlight|com\\.libretro\\.RetroArch|GeForceNOW)", { idle_inhibit = "fullscreen" })

-- Anything can opt into these by tag: hyprctl dispatch tagwindow +noidle
o.window({ tag = "noidle" }, { idle_inhibit = "always" })

-- Layers ---------------------------------------------------------------------

-- No border or fade around the slurp region selection used by screenshots.
hl.layer_rule({ match = { namespace = "selection" }, no_anim = true, animation = "none" })

-- A status bar should appear instantly rather than sliding in.
hl.layer_rule({ match = { namespace = "^(waybar|gtk-layer-shell)$" }, no_anim = true, animation = "none" })

-- Opacity --------------------------------------------------------------------

-- Applied last, to whatever still carries the tag: focused, then unfocused.
o.window({ tag = "default-opacity" }, { opacity = "0.985 0.96" })

-- Terminal backdrops are busier than a plain app window, so they get less.
o.window({ tag = "terminal" }, { opacity = "0.99 0.985" })
