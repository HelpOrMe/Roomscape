
if HashTable == nil then
    HashTable = object()
end

require("types/object")
require("collections/hash_functions")

function HashTable:constructor(table)
    self._values = {}
    self._keys = {}
    self._len = 0

    if table ~= nil and type(table) == "table" then
        for k, v in pairs(table) do
            self:Set(k, v)
        end
    end
end

function HashTable:Set(key, value)
    local hashedKey = hash(key)
    self._values[hashedKey] = value
    self._keys[hashedKey] = key
    self._len = self._len + 1
end

function HashTable:Get(key)
    return self._values[hash(key)]
end

function HashTable:Remove(key)
    local hashedKey = hash(key)
    self._values[hashedKey] = nil
    self._keys[hashedKey] = nil
    self._len = self._len - 1
end

function HashTable:Contains(key)
    return self._keys[hash(key)] ~= nil
end

function HashTable:Pairs()
    return pairs(self:ToTable())
end

function HashTable:ToTable()
    local t = {}
    for hash_key, key in pairs(self._keys) do
        t[key] = self._values[hash_key]
    end
    return t
end

function HashTable:Length()
    return self._len
end

function HashTable.__tostring()
    return "HashTable:"..tostring(self._len)
end
