
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

--- Rooms

ROOMS = {}

ROOMS.CONFIGS = {
    spawn = {
        hero_spawn_pos = Vector(0, 0, 0)
    }
}

ROOMS.TYPES = {
    START = {
        -- Deep 1
        { "spawn" }
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
--- Returns a room name by pattern `<style>_room_<room_type>_<exit_type>`
--- such as "default_room_spawn_urdl" or "default_room_urdl"
---@overload fun(exit_type:string, content_type:string, deep:number):string
---@overload fun(exit_type:string, content_type:string):string
---@overload fun(exit_type:string):string
---@param exit_type string
---@param room_type string
---@param room_style string
---@return string
function GetRoomName(exit_type, room_type, room_style)
    return "default_room_spawn_urdl"
    --room_style = room_style or SELECTED_ROOMS_STYLE
    --
    --local table_to_concat = {}
    --for _, value in pairs({room_style, "room", room_type, exit_type}) do
    --    if value ~= nil then
    --        table.insert(table_to_concat, value)
    --    end
    --end
    --
    --return table.concat(table_to_concat, "_")
end

---
--- Returns a random room type for content such as "boss_omni" or "hard_centaurs"
---@overload fun(content_type:string):string
---@param content_type string
---@param deep number
---@return string
function GetRandomRoomTypeByContent(content_type, deep)
    deep = deep or 1
    content_type = string.upper(content_type)

    local rooms_by_content = ROOMS.TYPES[content_type]
    if rooms_by_content ~= nil and #rooms_by_content > 0 then
        local rooms_by_deep = rooms_by_content[deep]
        if rooms_by_deep ~= nil and #rooms_by_deep > 0 then
            return rooms_by_deep[math.random(#rooms_by_deep)]
        end
    end
    print("ERROR! Unable to get room type, content_type: "..content_type..", ", tostring(deep))
end