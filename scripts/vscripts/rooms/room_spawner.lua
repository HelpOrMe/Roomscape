if RoomSpawner == nil then
    RoomSpawner = class({})()
end

----------------------------------------------------------------------------

-- called on DOTA_GAMERULES_STATE_HERO_SELECTION from events.lua
function RoomSpawner:SpawnStartRooms()
    self:_doForEachStartRoom(function(room)
        room:Spawn()
        room.cleared = true
    end, 3, 0.1)
end

----------------------------------------------------------------------------

-- called on DOTA_GAMERULES_STATE_PRE_GAME from events.lua
function RoomSpawner:SpawnStartDoors()
    self:_doForEachStartRoom(function(room)
        room:SpawnDoors(1)
    end, 0, 0.1)
end

----------------------------------------------------------------------------

function RoomSpawner:_doForEachStartRoom(func, start_delay, tick_delay)
    local rooms_queue = Queue(RoomMap:GetRoomsByType("start"))
    local current_room
    Timers:CreateTimer(start_delay, function()
        if rooms_queue:Length() > 0 then
            if current_room == nil or current_room.spawn_complete then
                current_room = rooms_queue:Dequeue()
                func(current_room)
            end
            return tick_delay
        end
    end)
end