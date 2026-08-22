dopath("cfg_debian")

ioncore.set{
    mousefocus="disabled",
}

dopath("cfg_defaults")

;(function()
    local f = io.open("/home/bae/.notion/log", "w")
    if f then
        f:write("")
        f:close()
    end
end)()

local function debug_print(str) 
    local f = io.open("/home/bae/.notion/log", "a")
    if f then
        f:write(str)
        f:close()
    end
end

defbindings("WFrame.toplevel", {
    bdoc("debug", "debug"),
    kpress(META.."D", 
    function()
        debug_print('========================\n')
        debug_print('clientwin_i\n')
        debug_print('========================\n')
        ioncore.clientwin_i(function(win)
            debug_print(tostring(win:name()) .. '\n')
            return true
        end)
        debug_print('========================\n')

        local types = {
            'WClientWin',
            'WWindow',
            'WRootWin',
            'WMPlex',
            'WFrame',
            'WScreen',
            'WInput',
            'WEdln',
            'WMessage',
            'WGroup',
            'WGroupWS',
            'WGroupCW',
            'WTiling',
        }

        for i, t in ipairs(types) do
            debug_print('========================\n')
            debug_print(t .. '\n')
            debug_print('========================\n')
            ioncore.region_i(function(reg)
                debug_print(tostring(reg) .. ' name: ' .. reg:name() .. ' parent: '.. tostring(reg:parent()) ..'\n')
                return true
            end, t)
            debug_print('========================\n')
        end
    end),

    bdoc("restart ion", "restart"),
    kpress(META.."R", 
    function()
        ioncore.restart()
    end),
})

defbindings("WTiling", { 
    submap("Mod1+Tab", {
        -- alone
        bdoc("Leave Frame Alone"),
        kpress("AnyModifier+O", 
        function(tiling, frame)
            local frames = {}

            tiling:managed_i(function(other_frame)
                debug_print(tostring(other_frame)..'\n')
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

local function get_movement_func(dir)
    return function(_, _sub, _chld)
        if _chld ~= nil then
            ioncore.goto_next(_chld, dir, {
                nowrap = true
            })
        end
    end
end

-- hjkl movements
defbindings("WScreen", {
    submap("Mod1+Tab", {
        bdoc("Move Left"),
        kpress("H", get_movement_func('left')),

        bdoc("Move Right"),
        kpress("L", get_movement_func('right')),

        bdoc("Move Up"),
        kpress("K", get_movement_func('up')),

        bdoc("Move Down"),
        kpress("J", get_movement_func('down')),
    }),
})

