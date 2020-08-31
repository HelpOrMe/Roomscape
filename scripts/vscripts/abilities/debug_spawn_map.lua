debug_spawn_map = class({})

--------------------------------------------------------------------------------

function debug_spawn_map:OnSpellStart()
    --GameRules.Roomscape:SpawnRooms()
    self:SpawnMap()
end

--------------------------------------------------------------------------------

function debug_spawn_map:SpawnMap()
    if not IsServer() then return end

    local position = translateToMapPosition(self:GetCaster():GetCursorPosition())
    print("DEBUG: Spawn test room at position"..tostring(position))
    DOTA_SpawnMapAtPosition("arena", position, false,
            Dynamic_Wrap(debug_spawn_map, "OnRoomReadyToSpawn"),
            Dynamic_Wrap(debug_spawn_map, "OnSpawnRoomComplete"), self)
end

function translateToMapPosition(position)
    return Vector(
            math.floor(position.x / 64) * 64,
            math.floor(position.y / 64) * 64,
            512)
end

--------------------------------------------------------------------------------

function debug_spawn_map:OnRoomReadyToSpawn(spawnGroupHandle)
    print("onRoomReadyToSpawn "..tostring(spawnGroupHandle))
    --ManuallyTriggerSpawnGroupCompletion(spawnGroupHandle)
end

--------------------------------------------------------------------------------

function debug_spawn_map:OnSpawnRoomComplete(spawnGroupHandle)
    print("OnSpawnRoomComplete "..tostring(spawnGroupHandle))
end