
if RoomDoor == nil then
    RoomDoor = class({})
end

LinkLuaModifier("modifier_broken_door", "modifiers/modifier_broken_door", LUA_MODIFIER_MOTION_NONE)

function RoomDoor:constructor(entity, name, exit_char, parent_room)
    self.entity = entity
    self.broken_entity = nil

    self.name = name
    self.exit_char = exit_char

    self.parent_room = parent_room

    self.is_broken = false
end

function RoomDoor:Break()
    self.is_broken = true
    self.broken_entity = CreateUnitByName(
            self.name.."_anim",
            self.entity:GetOrigin(),
            false, nil, nil, DOTA_TEAM_BADGUYS)

    local rot = self.entity:GetAnglesAsVector()
    self.broken_entity:SetAngles(rot.x, rot.y, rot.z)
    self.broken_entity:SetOrigin(self.entity:GetOrigin())
    self.broken_entity:AddNewModifier(self.broken_entity, nil, "modifier_broken_door", {duration = -1})

    self.entity:Destroy()
end
