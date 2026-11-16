-- clear the log file
local user_home = nil

function get_user_home()
    if user_home == nil then
        user_home = os.getenv("HOME")
    end

    if user_home ~= nil then
        -- if $HOME ends with / (for some reason) cut that out
        if string.sub(user_home, -1) == '/' then
            user_home = string.sub(user_home, 1, #user_home - 1)
        end
    end

    return user_home
end

;(function()
    if get_user_home() == nil then
        return
    end

    local f = io.open(get_user_home() .. "/.notion/log", "w")
    if f then
        f:write("")
        f:close()
    end
end)()

function debug_print(thing) 
    if get_user_home() == nil then
        return
    end

    local f = io.open(get_user_home() .. "/.notion/log", "a")
    if f then
        f:write(tostring(thing))
        f:close()
    end
end

function debug_println(thing) 
    debug_print(tostring(thing) .. '\n')
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) 
       return true 
   else 
       return false 
   end
end

function safe(func)
    return function(_, _sub, _chld)
        local status, err = pcall(func, _, _sub, _chld)

        if not status then
            debug_println(err)
        end
    end
end

