--
-- Bindings. This includes global bindings and bindings common to
-- screens and all types of frames only. See modules' configuration
-- files for other bindings.
--

-- WScreen context bindings
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
    bdoc("Display the main menu."),
    mpress("Button3", "mod_menu.pmenu(_, _sub, 'mainmenu')"),

    bdoc("Display the window list menu."),
    mpress("Button2", "mod_menu.pmenu(_, _sub, 'windowlist')"),

    -- super tab cycling
    bdoc("Forward-circulate focus.", "->frame"),
    kpress(META.."Tab", "ioncore.goto_next(_chld, 'right')",
           "_chld:non-nil"),
    bdoc("Backward-circulate focus.", "<-frame"),
    kpress(ALTMETA.."Tab", "ioncore.goto_next(_chld, 'left')",
           "_chld:non-nil"),

    bdoc("Switch to next/previous object within current screen."),
    kpress("Control+Mod4+Left", "WScreen.switch_prev(_)"),
    kpress("Control+Mod4+Right", "WScreen.switch_next(_)"),

    submap("Mod1+Tab", {
        ---------------------
        -- hjkl focus move
        ---------------------
        bdoc("Move Focus Left"),
        kpress("H", get_move_focus_func('left')),

        bdoc("Move Focus Right"),
        kpress("L", get_move_focus_func('right')),

        bdoc("Move Focus Up"),
        kpress("K", get_move_focus_func('up')),

        bdoc("Move Focus Down"),
        kpress("J", get_move_focus_func('down')),
        ---------------------

        bdoc("Create a new workspace of chosen default type."),
        kpress("W", "ioncore.create_ws(_)"),

        kpress("F12", "mod_query.query_menu(_, _sub, 'mainmenu', 'Main menu:')"),
    }),
})


-- Client window bindings
--
-- These bindings affect client windows directly.

defbindings("WClientWin", {
})


-- Client window group bindings

local function get_move_win_func(dir, swap)
    return function(group, _sub, _chld)
        local manager = group:manager()

        if not manager or not obj_is(manager, "WFrame") then
            return
        end

        local neighbor = ioncore.navi_next(manager, dir, {nowrap = true})

        if not neighbor or not obj_is(neighbor, "WFrame") then
            return
        end

        local neighbor_children = {}

        if swap then
            neighbor:managed_i(function(child)
                table.insert(neighbor_children, child)
                return true
            end)
        end

        neighbor:attach(group, {switchto = true})

        if swap then
            for _, child in ipairs(neighbor_children) do
                manager:attach(child)
            end
        end

        group:goto_focus()
    end
end

defbindings("WGroupCW", {
    submap("Mod1+Tab", {
        ---------------------
        -- hjkl win move
        ---------------------
        bdoc("Move Win Left"),
        kpress("Shift+H", get_move_win_func('left')),

        bdoc("Move Win Right"),
        kpress("Shift+L", get_move_win_func('right')),

        bdoc("Move Win Up"),
        kpress("Shift+K", get_move_win_func('up')),

        bdoc("Move Win Down"),
        kpress("Shift+J", get_move_win_func('down')),

        ---------------------
        -- hjkl win swap
        ---------------------
        bdoc("Swap Win Left"),
        kpress("Control+H", get_move_win_func('left', true)),

        bdoc("Swap Win Right"),
        kpress("Control+L", get_move_win_func('right', true)),

        bdoc("Swap Win Up"),
        kpress("Control+K", get_move_win_func('up', true)),

        bdoc("Swap Win Down"),
        kpress("Control+J", get_move_win_func('down', true)),
    }),
})


-- WMPlex context bindings
--
-- These bindings work in frames and on screens. The innermost of such
-- contexts/objects always gets to handle the key press.

defbindings("WMPlex", {
    kpress(META.."N", "WMPlex.switch_next(_)"),
    kpress(META.."P", "WMPlex.switch_prev(_)"),

    submap("Mod1+Tab", {
        bdoc("Close current object.", "close"),
        kpress_wait("X", "WRegion.rqclose_propagate(_, _sub)"),
    }),
})

-- Frames for transient windows ignore this bindmap

defbindings("WMPlex.toplevel", {
    submap("Mod1+Tab", {
        bdoc("Query for command line to execute.", "run"),
        kpress("semicolon", "mod_query.query_exec(_)"),

        bdoc("Query for Lua code to execute.", "lua"),
        kpress("Shift+semicolon", "mod_query.query_lua(_)"),
    }),
}) 

-- WFrame context bindings
--
-- These bindings are common to all types of frames. Some additional
-- frame bindings are found in some modules' configuration files.

defbindings("WFrame", {
    bdoc("Display context menu."),
    mpress("Button3", "mod_menu.pmenu(_, _sub, 'ctxmenu')"),

    bdoc("Switch the frame to display the object indicated by the tab."),
    mclick("Button1@tab", "WFrame.p_switch_tab(_)"),
    mclick("Button2@tab", "WFrame.p_switch_tab(_)"),

    bdoc("Resize the frame."),
    mdrag("Button1@border", "WFrame.p_resize(_)"),
    mdrag(META.."Button3", "WFrame.p_resize(_)"),

    bdoc("Move the frame."),
    mdrag(META.."Button1", "WFrame.p_move(_)"),

    bdoc("Move objects between frames by dragging and dropping the tab."),
    mdrag("Button1@tab", "WFrame.p_tabdrag(_)"),
    mdrag("Button2@tab", "WFrame.p_tabdrag(_)"),

    bdoc("Switch to next object within the frame.", "->tab"),
    mclick(META.."Button4", "WFrame.switch_next(_)"),

    bdoc("Switch to previous object within the frame.", "<-tab"),
    mclick(META.."Button5", "WFrame.switch_prev(_)"),
})

-- Frames for transient windows ignore this bindmap

defbindings("WFrame.toplevel", {
    submap("Mod1+Tab", {
        bdoc("Query for a client window to attach ('nick').", "qnick"),
        kpress("B", "mod_query.query_attachclient(_)"),
    }),
})

-- Bindings for floating frames

defbindings("WFrame.floating", {
    bdoc("Toggle shade mode"),
    mdblclick("Button1@tab", "WFrame.set_shaded(_, 'toggle')"),

    bdoc("Raise the frame."),
    mpress("Button1@tab", "WRegion.rqorder(_, 'front')"),
    mpress("Button1@border", "WRegion.rqorder(_, 'front')"),
    mclick(META.."Button1", "WRegion.rqorder(_, 'front')"),

    bdoc("Lower the frame."),
    mclick(META.."Button3", "WRegion.rqorder(_, 'back')"),

    bdoc("Move the frame."),
    mdrag("Button1@tab", "WFrame.p_move(_)"),
})


-- WMoveresMode context bindings
--
-- These bindings are available keyboard move/resize mode. The mode
-- is activated on frames with the command begin_kbresize (bound to
-- META.."R" above by default).

defbindings("WMoveresMode", {
    bdoc("Cancel the resize mode."),
    kpress("AnyModifier+Escape","WMoveresMode.cancel(_)"),

    bdoc("End the resize mode."),
    kpress("AnyModifier+Return","WMoveresMode.finish(_)"),

    bdoc("Grow in specified direction."),
    kpress("Left",  "WMoveresMode.resize(_, 1, 0, 0, 0)"),
    kpress("Right", "WMoveresMode.resize(_, 0, 1, 0, 0)"),
    kpress("Up",    "WMoveresMode.resize(_, 0, 0, 1, 0)"),
    kpress("Down",  "WMoveresMode.resize(_, 0, 0, 0, 1)"),

    bdoc("Shrink in specified direction."),
    kpress("Shift+Left",  "WMoveresMode.resize(_,-1, 0, 0, 0)"),
    kpress("Shift+Right", "WMoveresMode.resize(_, 0,-1, 0, 0)"),
    kpress("Shift+Up",    "WMoveresMode.resize(_, 0, 0,-1, 0)"),
    kpress("Shift+Down",  "WMoveresMode.resize(_, 0, 0, 0,-1)"),

    bdoc("Move in specified direction."),
    kpress(META.."Left",  "WMoveresMode.move(_,-1, 0)"),
    kpress(META.."Right", "WMoveresMode.move(_, 1, 0)"),
    kpress(META.."Up",    "WMoveresMode.move(_, 0,-1)"),
    kpress(META.."Down",  "WMoveresMode.move(_, 0, 1)"),
})


--
-- Menu definitions
--


-- Main menu
defmenu("mainmenu", {
    menuentry("Run...",         "mod_query.query_exec(_)"),
    menuentry("Terminal",       "mod_query.exec_on_merr(_, XTERM or 'x-terminal-emulator')"),
    menuentry("Lock screen",
        "notioncore.exec_on(_, notioncore.lookup_script('notion-lock'))"),
    menuentry("Help",           "mod_query.query_man(_)"),
    menuentry("About Notion",      "mod_query.show_about_ion(_)"),
    submenu("Styles",           "stylemenu"),
    submenu("Debian",           "Debian"),
    submenu("Session",          "sessionmenu"),
})


-- Session control menu
defmenu("sessionmenu", {
    menuentry("Save",           "ioncore.snapshot()"),
    menuentry("Restart",        "ioncore.restart()"),
    menuentry("Restart TWM",    "ioncore.restart_other('twm')"),
    menuentry("Exit",           "ioncore.shutdown()"),
})


-- Context menu (frame actions etc.)
defctxmenu("WFrame", "Frame", {
    -- Note: this propagates the close to any subwindows; it does not
    -- destroy the frame itself, unless empty. An entry to destroy tiled
    -- frames is configured in cfg_tiling.lua.
    menuentry("Close",          "WRegion.rqclose_propagate(_, _sub)"),
    -- Low-priority entries
    menuentry("Attach tagged", "ioncore.tagged_attach(_)", { priority = 0 }),
    menuentry("Clear tags",    "ioncore.clear_tags()", { priority = 0 }),
    menuentry("Window info",   "mod_query.show_tree(_, _sub)", { priority = 0 }),
})


-- Context menu for groups (workspaces, client windows)
defctxmenu("WGroup", "Group", {
    menuentry("Toggle tag",     "WRegion.set_tagged(_, 'toggle')"),
    menuentry("De/reattach",    "ioncore.detach(_, 'toggle')"),
})


-- Context menu for workspaces
defctxmenu("WGroupWS", "Workspace", {
    menuentry("Close",          "WRegion.rqclose(_)"),
    menuentry("Rename",         "mod_query.query_renameworkspace(nil, _)"),
    menuentry("Attach tagged",  "ioncore.tagged_attach(_)"),
})


-- Context menu for client windows
defctxmenu("WClientWin", "Client window", {
    menuentry("Kill",           "WClientWin.kill(_)"),
})

-- Auto-generated Debian menu definitions
if os then
   havemenus = os.execute("test -x /usr/bin/update-menus")
   if havemenus == 0 or havemenus == true then
      if ioncore.is_i18n() then
         dopath("debian-menu-i18n")
      else
         dopath("debian-menu")
      end
   end
end
