hl.monitor({
    output = "DP-1",
    mode = "preferred",
    position = "0x0",
    scale = 1,
})

hl.monitor({
    output = "DP-3",
    mode = "preferred",
    position = "2560x0",
    scale = 1,
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "preferred",
    position = "6000x0",
    scale = 1,
})

-- Keep focus on transient JetBrains dialogs while they are visible.
hl.window_rule({
    name = "jetbrains-popup-focus",
    match = {
        class = "^jetbrains-.*",
        float = true,
    },
    stay_focused = true,
})

-- Prevent pointer movement from refocusing a hovered window unexpectedly.
hl.config({
    input = {
        mouse_refocus = false,
    },
})

-- default picker is feature-rich but slow to appear. These bindings use
-- hyprshot directly while retaining both automatic saving and clipboard copy.
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output -m active"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("screenshot-select"))
hl.bind("SUPER + SHIFT + ALT + S", hl.dsp.exec_cmd("hyprshot -m region"))
