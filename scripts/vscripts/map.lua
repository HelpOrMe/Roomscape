
if Map == nil then
    _G.Map = class({})
end

require("constants")

require("collections/hashtable")
require("collections/hashset")

----------------------------------------------------------------------------

function Map:constructor()
    self._rooms = HashTable()
    self._room_positions_by_content = HashTable()

    self._special_positions = HashSet()
    self._special_content_types = HashSet(SELECTED_MODE.SPECIAL_ROOM_CONTENT_TYPES)
end

_G.Map = Map()

----------------------------------------------------------------------------

function Map:AddRoom(content_type, room)
    if not self._room_positions_by_content:Contains(content_type) then
        self._room_positions_by_content:Set(content_type, {})
    end

    table.insert(self._room_positions_by_content:Get(content_type), room.position)
    if self._special_content_types:Contains(content_type) then
        self._special_positions:Add(room.position)
    end

    self._rooms:Set(room.position, room)
end

----------------------------------------------------------------------------

function Map:IsSpecialRoomAt(position)
    return self._special_positions:Contains(position)
end

----------------------------------------------------------------------------

function Map:IsSpecialRoomsNearExists(pivot, range)
    range = range or SELECTED_MODE.SPECIAL_ROOM_SPAWN_DISTANCE

    for _, position in self._special_positions:Pairs() do
        if Vector2.Distance(pivot, position) <= range then
            return true
        end
    end

    return false
end

----------------------------------------------------------------------------

function Map:GetRoomsByContent(content_type)
    if not self._room_positions_by_content:Contains(content_type) then
        print("ERROR! Unable to get rooms by content ", content_type)
        return {}
    end

    local rooms_by_content = {}
    for _, position in pairs(self._room_positions_by_content:Get(content_type)) do
        table.insert(rooms_by_content, self:GetRoomAt(position))
    end

    return rooms_by_content
end

----------------------------------------------------------------------------

function Map:GetRoomAt(position)
    return self._rooms:Get(position)
end

----------------------------------------------------------------------------
