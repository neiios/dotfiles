hl.monitor({ output = "", mode = "highrr", position = "auto", scale = "auto" })

-- systemd-native session integration
hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm finalize")
end)

hl.bind("SUPER + Return", hl.dsp.exec_cmd("uwsm app -- ghostty"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("uwsm app -- hyprshutdown"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd([[uwsm app -- sh -c 'grim -g "$(slurp)" - | wl-copy']]))
hl.bind("SUPER + Space", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd([[sh -c 'app=$("$HOME/.local/bin/tofi-drun" --drun-launch=false) && [ -n "$app" ] && exec uwsm app -- $app']]), { release = true })
hl.bind("SUPER + B", hl.dsp.exec_cmd([[uwsm app -- "$HOME/dotfiles/bin/bt-menu"]]))
hl.bind("SUPER + L", hl.dsp.exec_cmd("loginctl lock-session"))
-- Fallback lock on lid close (logind handles suspend; this covers the docked case)
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("loginctl lock-session"), { locked = true })

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

hl.bind("SUPER + A", hl.dsp.layout("cycleprev"))
hl.bind("SUPER + D", hl.dsp.layout("cyclenext"))
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))

hl.bind("SUPER + Tab", function()
    local workspace = hl.get_active_workspace()
    if not workspace then return end
    hl.workspace_rule({
        workspace = tostring(workspace.id),
        layout = workspace.tiled_layout == "monocle" and "master" or "monocle",
    })
end)

for i = 1, 10 do
    hl.bind("SUPER + " .. i % 10, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. i % 10, hl.dsp.window.move({ workspace = i }))
end

hl.device({ name = "pulsar-8k-dongle", accel_profile = "flat" })

hl.config({
    animations = { enabled = false },
    input = { kb_layout = "us,lt,ru" },
    general = {
        layout = "master",
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
        col = {
            active_border   = "rgba(555555ff)",
            inactive_border = "rgba(111111ff)",
        },
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
    decoration = {
        shadow = {
            enabled = true,
            range = 12,
            render_power = 3,
            color = "rgba(00000033)",
            color_inactive = "rgba(00000022)",
        },
    },
})
