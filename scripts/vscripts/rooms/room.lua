
if Room == nil then
    Room = class({})
end

require("constants")
require("rooms/room_types")
require("rooms/room_map")
require("rooms/room_door")

LinkLuaModifier("modifier_door", "modifiers/modifier_door", LUA_MODIFIER_MOTION_NONE)

--- Create a room. All parameters exclude position is `ctx` (parameters `style`,
--- `content_type` and deep can be ignored).
--- Room also imports config from `ROOMS.CONFIGS` (room_types.lua)
---@param position Vector2
---@param style string
---@param content_type string
---@param exit_type string
---@param room_type string
---@param deep number
---@param tier number
function Room:constructor(position, ctx)
    print("[Room] Created at ", position)

    self.position = position

    self.type = ctx.room_type
    self.exit_type = ctx.exit_type
    self.tier = ctx.tier

    self.style = ctx.style or SELECTED_ROOMS_STYLE
    self.content_type = ctx.content_type or GetRandomRoomContentByType(ctx.room_type, ctx.deep)
    self.deep = ctx.deep or 1

    self.name = GetRoomName(self.exit_type, self.content_type, self.style)

    self.spawn_handle = nil
    self.room_spawned = false
    self.spawn_complete = false

    self.door_distance = 2005
    self.doors = {}

    self.path_id = -1
    self.cleared = false

    self._box = nil

    if self.content_type ~= nil then
        -- Import room config from room_types.lua
        for field, value in pairs(ROOMS.CONFIGS[self.content_type]) do
            self[field] = value
        end
    end
end

----------------------------------------------------------------------------

--- Spawn room, to complete spawn invoke Room:CompleteSpawn() or
--- ManuallyTriggerSpawnGroupCompletion(Room.spawn_handle)
function Room:Spawn()
    local room_position = self:GetWorldPosition()

    print("[Room] Trying to spawn "..self.name.." at "..tostring(self.position))
    self.spawn_handle = DOTA_SpawnMapAtPosition(self.name, room_position, false,
            Dynamic_Wrap(Room, "OnRoomSpawn"),
            Dynamic_Wrap(Room, "OnRoomSpawnComplete"), self)
end

----------------------------------------------------------------------------

--- Complete room spawn. Use Room:Spawn() before
function Room:CompleteSpawn()
    if self.spawn_handle == nil then
        print("ERROR! Room "..self.name.." spawn_handle is nil")
        return
    end

    print("[Room] Trying to complete spawn "..self.name.." at "..tostring(self.position))
    ManuallyTriggerSpawnGroupCompletion(self.spawn_handle)
end

----------------------------------------------------------------------------

function Room:OnRoomSpawn(spawn_handle)
    if spawn_handle ~= self.spawn_handle then
        print("ERROR! Wrong spawn_handle"..tostring(spawn_handle).." >> "..tostring(self.spawn_handle))
    end

    print("[Room] Room "..self.name.." ready to complete at "..tostring(self.position))
    self.room_spawned = true
end

----------------------------------------------------------------------------

function Room:OnRoomSpawnComplete(spawn_handle)
    if spawn_handle ~= self.spawn_handle then
        print("ERROR! Wrong spawn_handle"..tostring(spawn_handle).." >> "..tostring(self.spawn_handle))
    end

    print("[Room] Room "..self.name.." complete at "..tostring(self.position))
    self.spawn_complete = true
end

----------------------------------------------------------------------------

function Room:SpawnDoors(tier)
    --self.exit_type
    for exit_char in ("urdl"):gmatch(".") do
        --local room = RoomMap:GetRoomAt(self.position + EXIT_OFFSETS[exit_char])
        --if room == nil or not room.exit_type:find(EXIT_REVERSED[exit_char]) then0
            self:SpawnDoor(exit_char, tier)
        --end
    end
end

----------------------------------------------------------------------------

function Room:SpawnDoor(exit_char, tier)
    local name = "npc_dota_gate_destructible_tier"..tostring(tier)
    local door_entity = CreateUnitByName(name,
            self:GetWorldPosition() + EXIT_OFFSETS[exit_char]:ToVector3() * self.door_distance,
            false, nil, nil, DOTA_TEAM_BADGUYS)

    door_entity:SetAngles(0, EXIT_ROTATIONS[exit_char], 0)
    door_entity:AddNewModifier(door_entity, nil, "modifier_door", {duration = -1})

    local door = RoomDoor(door_entity, name, exit_char, self)

    self.doors[exit_char] = door
end

----------------------------------------------------------------------------

function Room:RemoveDoor(exit_char)
    local door = self:GetDoor(exit_char)
    if door ~= nil then
        door:RemoveSelf()
    else
        print("ERROR! Unable to remove null door. Door: "..exit_char..", room: "..self.spawn_handle)
    end
end

----------------------------------------------------------------------------

function Room:GetDoor(exit_char)
    local entities = self:GetEntitiesInRoom("door_"..exit_char)
    if entities ~= nil and #entities > 0 then
        return entities[1]
    end
    return nil
end

----------------------------------------------------------------------------

function Room:GetBox()
    if self._box == nil then
        self._box = self:GetEntitiesInRoom( "room_box")[1]
    end
    return self._box
end

----------------------------------------------------------------------------

function Room:GetEntitiesInRoom(entity_name)
    local entities = Entities:FindAllByName(entity_name)
    for i, entity in pairs(entities) do
        if entity:GetSpawnGroupHandle() ~= self.spawn_handle then
            table.remove(entities, i)
        end
    end
    return entities
end

----------------------------------------------------------------------------

--- Return room position in the world
function Room:GetWorldPosition()
    local world_map_offset = Vector2(-SELECTED_MODE.MAP_SIZE / 2, -SELECTED_MODE.MAP_SIZE / 2)
    local room_size = Vector2(SELECTED_MODE.ROOM_SIZE, SELECTED_MODE.ROOM_SIZE)
    return ((self.position + world_map_offset) * room_size - room_size / Vector2(2, 2)):ToVector3()
end

----------------------------------------------------------------------------
