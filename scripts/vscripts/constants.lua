
require("types/vector2")

local eight_teams = { DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS, DOTA_TEAM_CUSTOM_1, DOTA_TEAM_CUSTOM_2,
                      DOTA_TEAM_CUSTOM_3, DOTA_TEAM_CUSTOM_4, DOTA_TEAM_CUSTOM_5, DOTA_TEAM_CUSTOM_6 }

--- Game modes

MODES = {"SOLO_MODE"}
SOLO_MODE = {}

--- Solo mode

SOLO_MODE.MAX_PLAYERS = 1
SOLO_MODE.TEAMS = eight_teams
SOLO_MODE.STARTING_GOLD = 650

--- Generator settings

SOLO_MODE.MAP_SIZE = 8
SOLO_MODE.ROOM_SIZE = 4096
SOLO_MODE.EXTEND_DEAD_ENDS = true

SOLO_MODE.SPAWN_ROOMS_COUNT = 8
SOLO_MODE.SPAWN_ROOM_TYPES = "All"

-- Rand value from list
SOLO_MODE.BOSS_ROOMS_COUNT = {8, 12}
SOLO_MODE.BOSS_ROOM_TYPES = "All"

SOLO_MODE.SPECIAL_ROOM_CONTENT_TYPES = {"spawn", "boss"}
SOLO_MODE.SPECIAL_ROOM_SPAWN_DISTANCE = 1

--- Selected mode

DEFAULT_MODE = SOLO_MODE
SELECTED_MODE = DEFAULT_MODE

function SelectModeByMap(map_name)
    SELECTED_MODE = GetModeForMap(map_name)
end

function GetModeForMap(map_name)
    for _, mode in pairs(MODES) do
        if map_name:find(mode.."$") then
            return mode
        end
    end
    return DEFAULT_MODE
end