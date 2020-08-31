
Object = {
    __call = function(cls, ...)
        local obj = cls.__new(cls, ...)
        if obj.constructor then
            obj:constructor(...)
        end
        return obj
    end
}
Object.__index = Object

function Object.__new(cls, ...)
    local meta_functions = {}
    local main = {}

    for key, value in pairs(cls) do
        if key:find("^__") and type(value) == "function" then
            local sep_start, _ = key:find("_metaignore")
            if sep_start then
                main[key:sub(0, sep_start - 1)] = value
            else
                meta_functions[key] = value
            end
        else
            main[key] = value
        end
    end

    return setmetatable(main, meta_functions)
end

function object(cls)
    return setmetatable(cls or {}, Object)
end
