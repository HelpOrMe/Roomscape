
if RoomscapeFilters == nil then
    RoomscapeFilters = class({})
end

require("rooms/room_map")
require("dota_utils")

--------------------------------------------------------------------

function RoomscapeFilters:SetFilters()
    GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(RoomscapeFilters, "ExecuteOrderFilter"), self)
    GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(RoomscapeFilters, "DamageFilter"), self)
end

----------------------------------------------------------------------------

function RoomscapeFilters:ExecuteOrderFilter(filterTable)
    local orderType = filterTable.order_type
    local target = filterTable.entindex_target ~= 0 and EntIndexToHScript(filterTable.entindex_target) or nil
    local unit
    if filterTable.units and filterTable.units["0"] then
        unit = EntIndexToHScript(filterTable.units["0"])
    end

    if orderType == DOTA_UNIT_ORDER_ATTACK_TARGET then
        if RoomMap.room_doors[target:GetEntityIndex()] ~= nil then
            if not unit:HasModifier("modifier_can_brake_door") then
                return false
            end
        end
    end

    return true
end

----------------------------------------------------------------------------

function RoomscapeFilters:DamageFilter(filterTable)
    local target = EntIndexToHScript(filterTable.entindex_victim_const) or nil
    local unit = EntIndexToHScript(filterTable.entindex_attacker_const)

    if RoomMap.room_doors[target:GetEntityIndex()] ~= nil then
        if not unit:HasModifier("modifier_can_brake_door") then
            return false
        end
        DecrStackableModifier(unit, "modifier_can_brake_door")
    end
    return true
end