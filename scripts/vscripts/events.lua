
if RoomscapeEvents == nil then
    RoomscapeEvents = class({})
end

require("rooms/room_map")
require("libraries/timers")

--------------------------------------------------------------------

function RoomscapeEvents:RegisterEventListeners()
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(RoomscapeEvents, "OnGameRulesStateChange"), self)
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(RoomscapeEvents, "OnNpcSpawned"), self)
    ListenToGameEvent("entity_killed", Dynamic_Wrap(RoomscapeEvents, "OnEntityKilled"), self)
end

--------------------------------------------------------------------

function RoomscapeEvents:OnGameRulesStateChange()
    local state = GameRules:State_Get()

    if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
        RoomSpawner.SpawnStartRooms()
    elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
        RoomSpawner.SpawnStartDoors()
    elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        GameRules.Roomscape:AddStartBuffsToPlayers()
    end
end

--------------------------------------------------------------------

function RoomscapeEvents:OnNpcSpawned(event)
    local spawnedUnit = EntIndexToHScript(event.entindex)
    if spawnedUnit:IsRealHero() then
        self:TeleportHeroToSpawn(spawnedUnit)
        if not spawnedUnit.spawned then
            spawnedUnit.spawned = true
        end
    end
end

--------------------------------------------------------------------

function RoomscapeEvents:TeleportHeroToSpawn(spawnedUnit)
    local player_id = spawnedUnit:GetPlayerID()
    local room = RoomMap:GetRoomsByType("start")[player_id + 1]

    if not spawnedUnit.spawned then
        Timers:CreateTimer({
            useGameTime = true,
            endTime = 0.15,
            callback = function()
                CenterCameraOnUnit(player_id, spawnedUnit)
                spawnedUnit:SetOrigin(room:GetWorldPosition() + room.hero_spawn_pos)
            end
        })
    else
        spawnedUnit:SetOrigin(room:GetWorldPosition())
    end
end

--------------------------------------------------------------------

function RoomscapeEvents:OnEntityKilled(event)
    local entIndex = event.entindex_killed
    local killedUnit = EntIndexToHScript(entIndex)
    if killedUnit ~= nil then
        local door = RoomMap.room_doors[entIndex]
        if door ~= nil then
            door:Break()
        end
    end
end

--------------------------------------------------------------------
