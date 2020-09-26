
if Vector2 == nil then
    require("types/object")
    Vector2 = object()
end

function Vector2:constructor(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Vector2.Distance(vec1, vec2)
    return math.sqrt((vec2.x - vec1.x) ^ 2 + (vec2.y - vec1.y) ^ 2)
end

function Vector2:Round(dec)
    dec = dec or 0

    local mult = 10^(dec or 0)
    self.x = math.floor(self.x * mult + 0.5) / mult
    self.y = math.floor(self.y * mult + 0.5) / mult
end

function Vector2:Floor()
    self.x = math.floor(self.x)
    self.y = math.floor(self.y)
end

function Vector2:ToVector3()
    return Vector(self.x, self.y, 0)
end

function Vector2.__add(vec1, vec2)
    return Vector2(vec1.x + vec2.x, vec1.y + vec2.y)
end

function Vector2.__sub(vec1, vec2)
    return Vector2(vec1.x - vec2.x, vec1.y - vec2.y)
end

function Vector2.__mul(vec1, vec2)
    return Vector2(vec1.x * vec2.x, vec1.y * vec2.y)
end

function Vector2.__div(vec1, vec2)
    return Vector2(vec1.x / vec2.x, vec1.y / vec2.y)
end

function Vector2.__hash(vec)
    --Unsupported 5.1 lua
    --return (((vec.x << 5) + vec.x) ^ vec.y)
    return vec.x.." "..vec.y
end

function Vector2.__tostring(vec)
    return "("..vec.x..","..vec.y..")"
end
