
function hash(value)
    if type(value) == "table" then
        local hash_func = _get_hash_func(getmetatable(value))
        if hash_func then
            return hash_func(value)
        end
    end
    return value
end

function _get_hash_func(value)
    if value.__hash then
        return value.__hash
    else
        local metatable = getmetatable(value)
        if metatable then
            return _get_hash_func(metatable)
        end
    end
end