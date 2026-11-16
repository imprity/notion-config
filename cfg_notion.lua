dopath("my_utils")

-- load local settings
;(function()
    if get_user_home() == nil then
        dopath("local_settings_default.lua")
        return
    end

    local local_settings_path = get_user_home() .. '/.notion/local_settings.lua'

    if not file_exists(local_settings_path) then
        dopath("local_settings_default.lua")
        return
    end

    dopath(local_settings_path)
end)()


dopath("my_functions")

dopath("cfg_debian")

ioncore.set{
    warp=false,
}

dopath("cfg_defaults")

dopath("change_mod_query.lua")
