
function Shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

function CopyTable(t, deep)
    deep = deep or 0

    local table_copy = {}
    for k, v in pairs(t) do
        if deep > 0 then
            deep = deep - 1
            if type(k) == "table" then
                k = CopyTable(k, deep)
            end
            if type(v) == "table" then
                v = CopyTable(v, deep)
            end
        else
            table_copy[k] = v
        end
    end

    return table_copy
end
