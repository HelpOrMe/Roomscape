
if RoomscapeEvents == nil then
    RoomscapeEvents = class({})
end

--------------------------------------------------------------------

function RoomscapeEvents.RegisterEventListeners()
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(RoomscapeEvents, "OnGameRulesStateChange"), self)
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(RoomscapeEvents, "OnNpcSpawned"), self)
end

--------------------------------------------------------------------

function RoomscapeEvents.OnGameRulesStateChange()
    local state = GameRules:State_Get();

    if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
        GameRules.Roomscape:SpawnStartRooms()
    end
end

--------------------------------------------------------------------

function RoomscapeEvents.OnNpcSpawned(event)
    local spawnedUnit = EntIndexToHScript(event.entindex)
    print("OnNpcSpawned")
    if spawnedUnit:IsRealHero() then
        local player_id = spawnedUnit:GetPlayerID()
        print("Player spawned: ",player_id)
        local room = Map:GetRoomsByContent("start")[player_id + 1]
        print("Setpos,", room:GetWorldPosition())
        spawnedUnit:SetOrigin(room:GetWorldPosition())
    end
end

--------------------------------------------------------------------
