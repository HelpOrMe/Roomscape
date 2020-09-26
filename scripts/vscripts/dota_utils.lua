
function ChangeWorldBounds(minBounds, maxBounds)
    local oldBounds = Entities:FindByClassname(nil, "world_bounds")
    if oldBounds then
        oldBounds:RemoveSelf()
    end
    SpawnEntityFromTableSynchronous("world_bounds", {Min = minBounds, Max = maxBounds})
end

----------------------------------------------------------------------------

--- Search for player heroes and return list with heroes
--- @return table
function GetPlayerHeroes()
    local heroes = {}
    for i = 0, PlayerResource:GetPlayerCount() do
        local player = PlayerResource:GetPlayer(i)
        if player ~= nil then
            local hero = player:GetAssignedHero()
            if hero ~= nil then
                table.insert(heroes, hero)
            end
        end
    end
    return heroes
end

----------------------------------------------------------------------------

function AddStackableModifier(unit, caster, ability, scriptName, modifierTable)
    if not unit:HasModifier(modName) then
        unit:AddNewModifier(caster, ability, scriptName, modifierTable)
    else
        local modifier = unit:FindModifierByName(modName)
        modifier:IncrementStackCount()
    end
end

----------------------------------------------------------------------------

function DecrStackableModifier(unit, scriptName)
    local modifier = unit:FindModifierByName(scriptName)
    modifier:DecrementStackCount()
    if modifier:GetStackCount() <= 0 then
        unit:RemoveModifierByName(scriptName)
    end
end