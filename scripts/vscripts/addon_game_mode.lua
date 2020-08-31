
if Roomscape == nil then
	_G.Roomscape = class({})
end

require("constants")
require("precache")
require("events")
require("map")

require("libraries/timers")
require("collections/queue")

require("rooms/room_generator")


----------------------------------------------------------------------------

function Activate()
	GameRules.Roomscape = Roomscape()
	GameRules.Roomscape:InitGameMode()

	RoomscapeEvents.RegisterEventListeners()
end

----------------------------------------------------------------------------

function Roomscape:InitGameMode()
	SelectModeByMap(GetMapName())

	GameRules:GetGameModeEntity():SetAnnouncerDisabled(true)
	--GameRules:SetCustomGameSetupTimeout(0)
	--GameRules:SetCustomGameSetupAutoLaunchDelay(0)
	for _, team in pairs(SELECTED_MODE.TEAMS) do
		GameRules:SetCustomGameTeamMaxPlayers(team, SELECTED_MODE.MAX_PLAYERS)
	end

	GameRules:SetTimeOfDay(0.25)
	GameRules:SetStrategyTime(0.0)
	GameRules:SetShowcaseTime(0.0)
	GameRules:SetPreGameTime(5.0)
	GameRules:SetPostGameTime(45.0)
	GameRules:SetHeroSelectionTime(90)
	GameRules:SetTreeRegrowTime(60.0)
	GameRules:SetStartingGold(SELECTED_MODE.STARTING_GOLD)
	GameRules:SetGoldTickTime(999999.0)
	GameRules:SetGoldPerTick(0)
	GameRules:SetUseUniversalShopMode(true)

	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath(true)
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled(true)
	GameRules:GetGameModeEntity():SetStashPurchasingDisabled(true)
	GameRules:GetGameModeEntity():SetRandomHeroBonusItemGrantDisabled(true)
	GameRules:GetGameModeEntity():SetDefaultStickyItem("item_boots")
	--GameRules:GetGameModeEntity():SetForceRightClickAttackDisabled(true)
	GameRules:GetGameModeEntity():DisableClumpingBehaviorByDefault(true)
	GameRules:GetGameModeEntity():SetNeutralStashTeamViewOnlyEnabled(true)
	GameRules:GetGameModeEntity():SetNeutralItemHideUndiscoveredEnabled(true)

	--GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
	--GameRules:GetGameModeEntity():SetFriendlyBuildingMoveToEnabled(true)
	GameRules:GetGameModeEntity():SetHudCombatEventsDisabled(true)
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled(true)
	--GameRules:GetGameModeEntity():SetCameraSmoothCountOverride(2)
	--GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled(false)
	--GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled(true)
	GameRules:GetGameModeEntity():SetTPScrollSlotItemOverride("item_bottle")

	GameRules:GetGameModeEntity():SetSendToStashEnabled(false)
	--self.fowBlockerRegion = GameRules:GetGameModeEntity():AllocateFowBlockerRegion(-16384, -16384, 16384, 16384, 128)

	GameRules:SetCustomGameAllowHeroPickMusic(false)
	GameRules:SetCustomGameAllowBattleMusic(false)
	GameRules:SetCustomGameAllowMusicAtGameStart(true)

	--GameRules:GetGameModeEntity():SetCameraZRange(11, 3800)

	--GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled( true )
	--GameRules:GetGameModeEntity():SetCustomBuybackCostEnabled( true )
	--GameRules:SetHeroRespawnEnabled( false )

	math.randomseed(GetSystemTimeMS())
	SelectRandomRoomsStyle()

	self.room_generator = RoomGenerator()
	self.room_generator:GenerateMaze()
	self.room_generator:GenerateStartRooms()

	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
end

----------------------------------------------------------------------------

function Roomscape:SpawnStartRooms()
	local rooms_queue = Queue(Map:GetRoomsByContent("start"))
	local current_room
	Timers:CreateTimer(3, function()
		if rooms_queue:Length() > 0 then
			if current_room == nil or current_room.spawn_complete then
				current_room = rooms_queue:Dequeue()
				current_room:Spawn()
			end
			return 0.1
		end
	end)
end

----------------------------------------------------------------------------

function Roomscape:OnThink()
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

----------------------------------------------------------------------------
