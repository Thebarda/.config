-- Keyboard, mouse, and touchpad.
-- https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
  input = {
    -- US International: ' " ` ~ ^ act as dead keys for accented characters.
    kb_layout = "us",
    kb_variant = "intl",
    kb_model = "",
    kb_rules = "",

    -- CapsLock is the compose key, so Caps Lock itself has to live somewhere
    -- else. Both Shifts together is the usual home for it, but it's easy to
    -- hit by accident while typing; the _cancel variant releases it on the
    -- next lone Shift, so a misfire clears itself.
    kb_options = "compose:caps,shift:both_capslock_cancel",

    follow_mouse = 1,
    sensitivity = 0,

    repeat_rate = 40,
    repeat_delay = 250,
    numlock_by_default = true,

    touchpad = {
      natural_scroll = false,
      -- Two-finger click for right-click instead of the lower-right corner.
      clickfinger_behavior = true,
      scroll_factor = 0.4,
    },
  },

  misc = {
    key_press_enables_dpms = true,
    mouse_move_enables_dpms = true,
  },
})

-- Terminals scroll a line at a time, which is far too slow on a touchpad.
o.window("(Alacritty|kitty|foot|org\\.codeberg\\.dnkl\\.foot|wezterm)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

-- Multiple layouts, switched with Left Alt + Right Alt:
-- hl.config({ input = { kb_layout = "us,dk", kb_options = "compose:caps,grp:alts_toggle" } })

-- Touchpad gestures.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
