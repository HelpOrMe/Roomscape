
if _RoomPaths == nil then
    _G._RoomPaths = class({})
end

function _RoomPaths:constructor()
    self.room_paths = {}
    self.player_paths = {}

    self._last_path_id = -1
end

----------------------------------------------------------------------------

if _RoomPaths == nil then
    _G.RoomPaths = _RoomPaths()
end

----------------------------------------------------------------------------

function _RoomPaths:AddPathBetween(room_a, room_b)
    if room_a.path_id == -1 and room_b.path_id == -1 then
        self:CreateNewPath({room_a, room_b})
    elseif room_a.path_id ~= -1 and room_b.path_id ~= -1 then
        self:MergePaths(room_a.path_id, room_b.path_id)
    else
        self:AddToExistingPath(room_a, room_b)
    end
end

----------------------------------------------------------------------------

function _RoomPaths:CreateNewPath(start_rooms)
    self._last_path_id = self._last_path_id + 1

    self.room_paths[self._last_path_id] = start_rooms
    for _, room in pairs(start_rooms) do
        room.path_id = self._last_path_id
    end
    return self._last_path_id
end

----------------------------------------------------------------------------

function _RoomPaths:MergePaths(from_path_id, to_path_id)
    for _, room in pairs(self.room_paths[from_path_id]) do
        self:AddToPath(room, to_path_id)
    end

    self.room_paths[from_path_id] = nil
end

----------------------------------------------------------------------------

function _RoomPaths:AddToExistingPath(room_a, room_b)
    local room = room_a.path_id ~= -1 and room_a or room_b
    local path_id = room_a.path_id ~= -1 and room_a.path_id or room_b.path_id
    self:AddToPath(room, path_id)
end

----------------------------------------------------------------------------

function _RoomPaths:AddToPath(room, path_id)
    table.insert(self.room_paths[path_id], room)
    room.path_id = path_id
end

----------------------------------------------------------------------------
