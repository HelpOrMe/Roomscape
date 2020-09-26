
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

SOLO_MODE.BOSS_ROOMS_COUNT = {8, 12}
SOLO_MODE.BOSS_CONTENT_TYPES = "All"

SOLO_MODE.SPECIAL_ROOM_TYPES = { "SPAWN", "BOSS"}
SOLO_MODE.SPECIAL_ROOM_SPAWN_DISTANCE = 0

--- Selected mode

DEFAULT_MODE = SOLO_MODE
SELECTED_MODE = DEFAULT_MODE

function SelectModeByMap(map_name)
    SELECTED_MODE = GetModeForMap(map_name)
end

---
--- Search for mode names in map name
--- Return DEFAULT_MODE if nothing is found
---@param map_name string
---@return table
function GetModeForMap(map_name)
    for _, mode in pairs(MODES) do
        if map_name:find(string.lower(mode).."$") then
            return _G[mode]
        end
    end
    return DEFAULT_MODE
end
