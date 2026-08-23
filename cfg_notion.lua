dopath("my_utils")

dopath("cfg_debian")

ioncore.set{
    warp=false,
}

dopath("cfg_defaults")

defbindings("WTiling", { 
    submap("Mod1+Tab", {
        -- only
        bdoc("Leave Frame Only"),
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
        bdoc("Split Horizontally"),
        kpress("S", 
        function(tiling, frame)
            tiling:split_at(frame, 'bottom', true)
        end),

        bdoc("Split Vertically"),
        kpress("Shift+S", 
        function(tiling, frame)
            tiling:split_at(frame, 'left', true)
        end),
    }),
})

---------------------
-- hjkl focus move
---------------------
local function get_move_focus_func(dir)
    return function(_, _sub, _chld)
        if _chld ~= nil then
            ioncore.goto_next(_chld, dir, {
                nowrap = true
            })
        end
    end
end

defbindings("WScreen", {
    submap("Mod1+Tab", {
        bdoc("Move Focus Left"),
        kpress("H", get_move_focus_func('left')),

        bdoc("Move Focus Right"),
        kpress("L", get_move_focus_func('right')),

        bdoc("Move Focus Up"),
        kpress("K", get_move_focus_func('up')),

        bdoc("Move Focus Down"),
        kpress("J", get_move_focus_func('down')),
    }),
})

---------------------
-- hjkl win move
---------------------
local function get_move_win_func(dir)
    return function(group, _sub, _chld)
        local manager = group:manager()

        if not manager then
            return
        end

        local neighbor = ioncore.navi_next(manager, dir, {nowrap = true})

        if not neighbor or not obj_is(neighbor, "WFrame") then
            return
        end

        neighbor:attach(group, {switchto = true})

        group:goto_focus()
    end
end

defbindings("WGroupCW", {
    submap("Mod1+Tab", {
        bdoc("Move Win Left"),
        kpress("Shift+H", get_move_win_func('left')),

        bdoc("Move Win Right"),
        kpress("Shift+L", get_move_win_func('right')),

        bdoc("Move Win Up"),
        kpress("Shift+K", get_move_win_func('up')),

        bdoc("Move Win Down"),
        kpress("Shift+J", get_move_win_func('down')),
    }),
})

