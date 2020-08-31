if Enum == nil then
    require("types/object")
    Enum = object()
end

require("collections/hashset")

function Enum:constructor(list)
    self.max_weight = math.floor(2 ^ #list)
    self.values = {}

    local weight = 1
    for _, value in pairs(list) do
        local element = EnumElement(self, weight, true)
        self.values[weight] = value
        self[value] = element
        weight = weight * 2
    end
end

function Enum:AddElement(el)
    self.max_weight = self.max_weight * 2
    self[el] = EnumElement(self, self.max_weight, true)
end

function Enum:AddToTable(t)
    for _, value in pairs(self.values) do
        t[value] = self[value]
    end
end

function Enum:__tostring()
    return "Enum:"..tostring(self.max_weight)
end

if EnumElement == nil then
    EnumElement = object()
end

local function checkForValidOperationBetween(el1, el2)
    if el1.enum ~= el2.enum then
        error("Invalid operation between two enum elements")
    end
    return true
end

local function doArithmeticBetween(el1, el2, func)
    if checkForValidOperationBetween(el1, el2) then
        return EnumElement(el1.enum, func(el1.num, el2.num))
    end
end

function EnumElement:constructor(enum, num, unchecked)
    self.enum = enum
    self.num = num
    self.weights = HashSet()

    if unchecked then
        self.weights:Add(num)
    else
        self:SetWeightsFrom(num)
    end
end

function EnumElement:SetWeightsFrom(num)
    if num == nil or num == 0 then
        return
    end

    local weight = self.enum.max_weight
    while weight >= 1 do
        if num - weight >= 0 then
            self.weights:Set(weight)
            num = num - weight
        end
        weight = math.floor(weight / 2)
    end
end

function EnumElement.__eq(el1, el2)
    if not checkForValidOperationBetween(el1, el2) then
        return false
    end

    local major = el1.weights:Length() >= el2.weights:Length() and el1 or el2
    local minor = major == el1 and el2 or el1

    for _, weight in minor.weights:Pairs() do
        if not major.weights:Contains(weight) then
            return false
        end
    end
    return true
end

function EnumElement.__add(el1, el2)
    return doArithmeticBetween(el1, el2, function(el1, el2) return el1 + el2 end)
end

function EnumElement.__sub(el1, el2)
    return doArithmeticBetween(el1, el2, function(el1, el2) return el1 - el2 end)
end

function EnumElement:__tostring()
    return self.enum.values[self.num]
end