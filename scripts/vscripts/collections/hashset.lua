
if HashSet == nil then
    HashSet = object()
end

require("types/object")
require("collections/hash_functions")

function HashSet:constructor(table)
    self._values = {}
    self._len = 0

    if table ~= nil and type(table) == "table" then
        for _, v in pairs(table) do
            self:Add(v)
        end
    end
end

function HashSet:Add(value)
    self._values[hash(value)] = value
    self._len = self._len + 1
end

function HashSet:Remove(value)
    self._values[hash(value)] = nil
    self._len = self._len - 1
end

function HashSet:Contains(value)
    return self._values[hash(value)] ~= nil
end

function HashSet:Pairs()
    return pairs(self._values)
end

function HashSet:ToTable()
    local t = {}
    for _, value in pairs(self._values) do
        table.insert(t, value)
    end
    return t
end

function HashSet:Length()
    return self._len
end