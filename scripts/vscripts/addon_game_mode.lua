
if Roomscape == nil then
	_G.Roomscape = class({})
end

require("constants")
require("events")
require("filters")
require("dota_utils")

require("rooms/room_generator")

LinkLuaModifier("modifier_can_brake_door", "modifiers/modifier_can_brake_door", LUA_MODIFIER_MOTION_NONE)

----------------------------------------------------------------------------

function Activate()
	GameRules.Roomscape = Roomscape()
	GameRules.Roomscape:InitGameMode()

	GameRules.Roomscape.events = RoomscapeEvents()
	GameRules.Roomscape.events:RegisterEventListeners()

	GameRules.Roomscape.filters = RoomscapeFilters()
	GameRules.Roomscape.filters:SetFilters()
end

----------------------------------------------------------------------------

function Roomscape:InitGameMode()
	SelectModeByMap(GetMapName())

	--GameRules:SetCustomGameSetupTimeout(0)
	--GameRules:SetCustomGameSetupAutoLaunchDelay(0)
	for _, team in pairs(SELECTED_MODE.TEAMS) do
		GameRules:SetCustomGameTeamMaxPlayers(team, SELECTED_MODE.MAX_PLAYERS)
	end

	GameRules:GetGameModeEntity():SetAnnouncerDisabled(true)

	GameRules:SetTimeOfDay(0.25)
	GameRules:SetStrategyTime(0.0)
	GameRules:SetShowcaseTime(0.0)
	GameRules:SetPreGameTime(30.0)
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
	GameRules:GetGameModeEntity():SetForceRightClickAttackDisabled(true)
	GameRules:GetGameModeEntity():DisableClumpingBehaviorByDefault(true)
	GameRules:GetGameModeEntity():SetNeutralStashTeamViewOnlyEnabled(true)
	GameRules:GetGameModeEntity():SetNeutralItemHideUndiscoveredEnabled(true)

	GameRules:GetGameModeEntity():SetHudCombatEventsDisabled(true)
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled(true)
	--GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled(true)
	GameRules:GetGameModeEntity():SetTPScrollSlotItemOverride("item_bottle")

	GameRules:GetGameModeEntity():SetSendToStashEnabled(false)
	--self.fowBlockerRegion = GameRules:GetGameModeEntity():AllocateFowBlockerRegion(-16384, -16384, 16384, 16384, 128)

	GameRules:SetCustomGameAllowHeroPickMusic(false)
	GameRules:SetCustomGameAllowBattleMusic(false)
	GameRules:SetCustomGameAllowMusicAtGameStart(true)

	GameRules:GetGameModeEntity():SetBuybackEnabled(false)

	math.randomseed(GetSystemTimeMS())
	SelectRandomRoomsStyle()

	local generator = RoomGenerator()
	generator:GenerateMaze()
	generator:GenerateStartRooms()

	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
end

----------------------------------------------------------------------------

function Roomscape:AddStartBuffsToPlayers()
	for _, hero in pairs(GetPlayerHeroes()) do
		AddStackableModifier(hero, hero, nil, "modifier_can_brake_door", {duration = -1})
	end
end

----------------------------------------------------------------------------

function Roomscape:OnThink()
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

----------------------------------------------------------------------------
