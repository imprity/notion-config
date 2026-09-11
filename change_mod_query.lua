-- this is a modified version of mod_query.query
-- see the original version at https://github.com/raboof/notion/blob/main/mod_query/mod_query.lua
mod_query.query = function(mplex, prompt, initvalue, handler, completor, context)
    local function handle_it(str)
        handler(mplex, str)
    end

    -- Check that no other queries are open in the mplex.
    local ok=mplex:managed_i(function(r)
                                 return not obj_is(r, "WEdln")
                             end)
    if not ok then
        return
    end

    local wedln=mod_query.do_query(mplex, prompt, initvalue,
                                   handle_it, completor, nil, nil)

    if wedln then
        ioncore.unsqueeze(wedln)

        if context then
            wedln:set_context(context)
        end
    end

    return wedln
end
