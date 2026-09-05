-- Volume, brightness, and media keys. `locked = true` keeps them working while
-- the screen is locked; `repeating = true` lets a held key keep firing.

local programs = require("programs")

o.bind("XF86AudioRaiseVolume", "Volume up", programs.volume_up, { locked = true, repeating = true })
o.bind("XF86AudioLowerVolume", "Volume down", programs.volume_down, { locked = true, repeating = true })
o.bind("XF86AudioMute", "Mute", programs.volume_mute, { locked = true })
o.bind("XF86AudioMicMute", "Mute microphone", programs.mic_mute, { locked = true })

o.bind("ALT + XF86AudioRaiseVolume", "Volume up precise", programs.volume_up_precise, { locked = true, repeating = true })
o.bind("ALT + XF86AudioLowerVolume", "Volume down precise", programs.volume_down_precise, { locked = true, repeating = true })

o.bind("XF86MonBrightnessUp", "Brightness up", programs.brightness_up, { locked = true, repeating = true })
o.bind("XF86MonBrightnessDown", "Brightness down", programs.brightness_down, { locked = true, repeating = true })
o.bind("ALT + XF86MonBrightnessUp", "Brightness up precise", programs.brightness_up_precise, { locked = true, repeating = true })
o.bind("ALT + XF86MonBrightnessDown", "Brightness down precise", programs.brightness_down_precise, { locked = true, repeating = true })
o.bind("SHIFT + XF86MonBrightnessUp", "Brightness maximum", programs.brightness_max, { locked = true })
o.bind("SHIFT + XF86MonBrightnessDown", "Brightness minimum", programs.brightness_min, { locked = true })

o.bind("XF86KbdBrightnessUp", "Keyboard brightness up", programs.kbd_brightness_up, { locked = true, repeating = true })
o.bind("XF86KbdBrightnessDown", "Keyboard brightness down", programs.kbd_brightness_down, { locked = true, repeating = true })

o.bind("XF86AudioPlay", "Play/pause", programs.media_play_pause, { locked = true })
o.bind("XF86AudioPause", "Play/pause", programs.media_play_pause, { locked = true })
o.bind("XF86AudioNext", "Next track", programs.media_next, { locked = true })
o.bind("XF86AudioPrev", "Previous track", programs.media_previous, { locked = true })
