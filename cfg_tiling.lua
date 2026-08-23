--
-- Notion tiling module configuration file
--

-- Bindings for the tilings.
defbindings("WTiling", {
    submap("Mod1+Tab", {
        -- only
        bdoc("Leave Frame Only", "only"),
        kpress("AnyModifier+O", 
        function(tiling, frame)
            local frames = {}

            tiling:managed_i(function(other_frame)
                table.insert(frames, other_frame)
                return true
            end)

            for _, other_frame in ipairs(frames) do
                if other_frame ~= frame then
                    tiling:unsplit_at(other_frame)
                end
            end
        end),

        -- split
        bdoc("Split Horizontally", "split"),
        kpress("S", 
        function(tiling, frame)
            tiling:split_at(frame, 'bottom', true)
        end),

        bdoc("Split Vertically", "vsplit"),
        kpress("Shift+S", 
        function(tiling, frame)
            tiling:split_at(frame, 'left', true)
        end),

        -- Destroy
        bdoc("Destroy current frame.", "unsplit"),
        kpress("Q", "WTiling.unsplit_at(_, _sub)"),
    }),

    mclick(META.."Shift+Button4", "ioncore.goto_next(_sub, 'up', {no_ascend=_})"),
    mclick(META.."Shift+Button5", "ioncore.goto_next(_sub, 'down', {no_ascend=_})"),
})

-- Frame bindings.
defbindings("WFrame.floating", {
})

-- Context menu for tiled workspaces.
defctxmenu("WTiling", "Tiling", {
    menuentry("Destroy frame",
              "WTiling.unsplit_at(_, _sub)"),

    menuentry("Into rows",
              "WTiling.split_at(_, _sub, 'bottom', true)"),
    menuentry("Into columns",
              "WTiling.split_at(_, _sub, 'right', true)"),

    menuentry("Flip", "WTiling.flip_at(_, _sub)"),
    menuentry("Transpose", "WTiling.transpose_at(_, _sub)"),

    menuentry("Untile", "mod_tiling.untile(_)"),

    submenu("Float split", {
        menuentry("At left",
                  "WTiling.set_floating_at(_, _sub, 'toggle', 'left')"),
        menuentry("At right",
                  "WTiling.set_floating_at(_, _sub, 'toggle', 'right')"),
        menuentry("Above",
                  "WTiling.set_floating_at(_, _sub, 'toggle', 'up')"),
        menuentry("Below",
                  "WTiling.set_floating_at(_, _sub, 'toggle', 'down')"),
    }),

    submenu("At root", {
        menuentry("Into Rows",
                  "WTiling.split_top(_, 'bottom')"),
        menuentry("Into columns",
                  "WTiling.split_top(_, 'right')"),
        menuentry("Flip", "WTiling.flip_at(_)"),
        menuentry("Transpose", "WTiling.transpose_at(_)"),
    }),
})

-- Extra context menu extra entries for floatframes.
defctxmenu("WFrame.floating", "Floating frame", {
    append=true,
    menuentry("New tiling", "mod_tiling.mkbottom(_)"),
})
