
if _RoomMap == nil then
    _G._RoomMap = class({})
end

require("constants")

require("collections/hashtable")
require("collections/hashset")

require("rooms/room_types")

----------------------------------------------------------------------------

function _RoomMap:constructor()
    self.room_doors = {}
    self.player_rooms = {}

    self._room_by_position = HashTable()
    self._room_by_box = HashTable()
    self._room_positions_by_type = HashTable()

    self._special_positions = HashSet()
    self._special_room_types = HashSet(SELECTED_MODE.SPECIAL_ROOM_TYPES)
end

----------------------------------------------------------------------------

if RoomMap == nil then
    _G.RoomMap = _RoomMap()
end

----------------------------------------------------------------------------

function OnPlayerEnterRoom(player, room_box)
    local player_ent_id = player:GetEntityId()
    local room = self._room_by_box[room_box:GetEntityIndex()]
    local player_room = self.player_rooms[player_ent_id]

    if player_room ~= nil and player_room.path_id ~= room.path_id then
        print("Illegal path")
        return
    end

    self.player_rooms[player_ent_id] = room
end

----------------------------------------------------------------------------

function OnPlayerLeaveRoom(player, room_box)
    print("Leave room ", player:GetOrigin())
end

----------------------------------------------------------------------------

function _RoomMap:AddRoom(room)
    if not self._room_positions_by_type:Contains(room.type) then
        self._room_positions_by_type:Set(room.type, {})
    end
    table.insert(self._room_positions_by_type:Get(room.type), room.position)

    if self._special_room_types:Contains(room.type) then
        self._special_positions:Add(room.position)
    end

    self._room_by_box[room:GetBox():GetEntityIndex()] = room
    self._room_by_position:Set(room.position, room)
end

----------------------------------------------------------------------------

function _RoomMap:IsSpecialRoomAt(position)
    return self._special_positions:Contains(position)
end

----------------------------------------------------------------------------

function _RoomMap:IsSpecialRoomsNearExists(pivot, range)
    range = range or SELECTED_MODE.SPECIAL_ROOM_SPAWN_DISTANCE

    for _, position in self._special_positions:Pairs() do
        if Vector2.Distance(pivot, position) <= range then
            return true
        end
    end
    return false
end

----------------------------------------------------------------------------

--- Return all generated rooms by content type
--- You can get room content types from rooms/room_types.lua
---@param room_type string
---@return table
function _RoomMap:GetRoomsByType(room_type)
    room_type = string.upper(room_type)
    if not self._room_positions_by_type:Contains(room_type) then
        print("ERROR! Unable to get rooms by content ", room_type)
        return {}
    end

    local rooms_by_content = {}
    for _, position in pairs(self._room_positions_by_type:Get(room_type)) do
        table.insert(rooms_by_content, self:GetRoomFromGrid(position))
    end

    return rooms_by_content
end

----------------------------------------------------------------------------

--- Return room under world position
--- @return table
function _RoomMap:GetRoomUnderPosition(position)
    local room_size = Vector2(SELECTED_MODE.ROOM_SIZE, SELECTED_MODE.ROOM_SIZE)

    local world_map_offset = Vector2(-SELECTED_MODE.MAP_SIZE / 2, -SELECTED_MODE.MAP_SIZE / 2)
    local room_position = (position + room_size / Vector2(2, 2)) / room_size - world_map_offset
    room_position:Round()

    return self:GetRoomFromGrid(room_position)
end

----------------------------------------------------------------------------

--- Return room by grid position
--- @return table
function _RoomMap:GetRoomFromGrid(position)
    return self._room_by_position:Get(position)
end

----------------------------------------------------------------------------