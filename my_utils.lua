-- clear the log file
;(function()
    local f = io.open("/home/bae/.notion/log", "w")
    if f then
        f:write("")
        f:close()
    end
end)()

function debug_print(thing) 
    local f = io.open("/home/bae/.notion/log", "a")
    if f then
        f:write(tostring(thing))
        f:close()
    end
end

function debug_println(thing) 
    debug_print(tostring(thing) .. '\n')
end

function safe(func)
    return function(_, _sub, _chld)
        local status, err = pcall(func, _, _sub, _chld)

        if not status then
            debug_println(err)
        end
    end
end
