
--- Exits:
--- [/] u [/]
---  l     r
--- [/] d [/]

--- Exit types:
--- Single: u, r, d, l
--- Double: ur, rd, dl, ul
--- Line: ud, rl
--- Triple: urd, rdl, udl, url
--- Cross: urdl

--- Room map file name pattern: <room_style>_room_<room_content_type>_<room_exit_type>
--- Example: default_room_spawn_urdl, default_room_centaurs_ur
--- Room content unique for all rooms

--- Exits

EXIT_OFFSETS = {
    u = Vector2(0, 1),
    r = Vector2(1, 0),
    d = Vector2(0, -1),
    l = Vector2(-1, 0)
}

EXIT_ROTATIONS = {
    u = 0,
    r = 90,
    d = 180,
    l = 270
}

EXIT_REVERSED = {
    u = "d",
    r = "l",
    d = "u",
    l = "r"
}

--- Rooms

ROOMS = {}

--- Additional room configs by room content
ROOMS.CONFIGS = {
    spawn = {
        hero_spawn_pos = Vector(0, 0, 256)
    }
}

--- Room content types sorted by room type and deep (ROOMS.TYPES[room_type][deep]),
--- for example:
--- start_room_content_types = ROOMS.TYPES["START"][1]
ROOMS.TYPES = {
    START = {
        [1] = { "spawn" }
    }
}

--- Styles

ROOM_STYLES = {"default"}
DEFAULT_ROOMS_STYLE = ROOM_STYLES[1]
SELECTED_ROOMS_STYLE = DEFAULT_ROOMS_STYLE

--- Randomly select style from ROOM_STYLES
function SelectRandomRoomsStyle()
    SELECTED_ROOMS_STYLE = ROOM_STYLES[math.random(#ROOM_STYLES)]
end

---
--- Returns a room name by pattern `<style>_room_<content_type>_<exit_type>`
--- such as "default_room_spawn_urdl" or "default_room_urdl"
---@overload fun(exit_type:string, content_type:string):string
---@overload fun(exit_type:string):string
---@param exit_type string
---@param content_type string
---@param style string
---@return string
function GetRoomName(exit_type, content_type, style)
    return "default_room_spawn_urdl"
    --room_style = room_style or SELECTED_ROOMS_STYLE
    --
    --local table_to_concat = {}
    --for _, value in pairs({room_style, "room", room_content, exit_type}) do
    --    if value ~= nil then
    --        table.insert(table_to_concat, value)
    --    end
    --end
    --
    --return table.concat(table_to_concat, "_")
end

---
--- Returns a random room content by room type
---@overload fun(content_type:string):string
---@param room_type string
---@param deep number
---@return string
function GetRandomRoomContentByType(room_type, deep)
    deep = deep or 1
    room_type = string.upper(room_type)

    local rooms_by_type = ROOMS.TYPES[room_type]
    if rooms_by_type ~= nil and #rooms_by_type > 0 then
        local rooms_by_deep = rooms_by_type[deep]
        if rooms_by_deep ~= nil and #rooms_by_deep > 0 then
            return rooms_by_deep[math.random(#rooms_by_deep)]
        end
    end
    print("ERROR! Unable to get random room content room type: "..room_type.."#"..tostring(deep))
end