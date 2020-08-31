
if Room == nil then
    Room = class({})
end

require("constants")
require("rooms/room_types")

----------------------------------------------------------------------------

--- Create a room
---@overload fun(position:Vector2, room_type:string, exit_type:string, room_style:string)
---@overload fun(position:Vector2, room_type:string, exit_type:string)
---@overload fun(position:Vector2, content_type:string, deep:number, exit_type:string, room_style:string)
---@overload fun(position:Vector2, content_type:string, deep:number, exit_type:string)
---@overload fun(position:Vector2, content_type:string, exit_type:string, room_style:string)
---@overload fun(position:Vector2, content_type:string, exit_type:string)
---@param position Vector2
---@param room_type string
---@param exit_type string
---@param content_type string
---@param deep number
---@param room_type string
function Room:constructor(position, ctx)
    print("[Room] Created at ", position)

    self.position = position
    self.ctx = ctx

    self.exit_type = ctx.exit_type
    self.room_type = ctx.room_type or GetRandomRoomTypeByContent(ctx.content_type, ctx.deep)
    self.room_style = ctx.room_style or SELECTED_ROOMS_STYLE
    self.name = GetRoomName(self.exit_type, self.room_type, self.room_style)

    self.spawn_handle = nil
    self.ready_to_complete = false
    self.spawn_complete = false

    if self.room_type ~= nil then
        -- Import room config from room_types.lua
        for field, value in pairs(ROOMS.CONFIGS[self.room_type]) do
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
            Dynamic_Wrap(Room, "OnRoomReadyToSpawn"),
            Dynamic_Wrap(Room, "OnRoomSpawnComplete"), self)
end

----------------------------------------------------------------------------

--- Return room position in the world
function Room:GetWorldPosition()
    local world_map_offset = Vector2(-SELECTED_MODE.MAP_SIZE / 2, -SELECTED_MODE.MAP_SIZE / 2)
    local room_size = Vector2(SELECTED_MODE.ROOM_SIZE, SELECTED_MODE.ROOM_SIZE)
    return ((self.position + world_map_offset) * room_size - room_size / Vector2(2, 2)):ToVector3()
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

function Room:OnRoomReadyToSpawn(spawn_handle)
    if spawn_handle ~= self.spawn_handle then
        print("ERROR! Wrong spawn_handle"..tostring(spawn_handle).." >> "..tostring(self.spawn_handle))
    end

    print("[Room] Room "..self.name.." ready to complete at "..tostring(self.position))
    self.ready_to_complete = true
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
