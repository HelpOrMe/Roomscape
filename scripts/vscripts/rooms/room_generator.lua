
if RoomGenerator == nil then
    RoomGenerator = class({})
end

require("constants")
require("lua_utils")
require("maze_generator")

require("types/vector2")

require("rooms/room_map")
require("rooms/room")
require("rooms/room_types")

----------------------------------------------------------------------------

function RoomGenerator:constructor()
    self.maze = {}
    self._maze_copy_shuffled = {}
end

----------------------------------------------------------------------------

function RoomGenerator:GenerateMaze()
    self.maze = self:_generateMaze()
    self._maze_copy_shuffled = Shuffle(CopyTable(self.maze))
end

----------------------------------------------------------------------------

function RoomGenerator:_generateMaze()
    local maze_generator = MazeGenerator(SELECTED_MODE.MAP_SIZE)

    maze_generator:GenerateMaze()
    if SELECTED_MODE.EXTEND_DEAD_ENDS then
        maze_generator:ExtendDeadEnds()
    end
    maze_generator:ResortExits()

    return maze_generator:GetMazeWithConcatExits()
end

----------------------------------------------------------------------------

function RoomGenerator:GenerateStartRooms(count)
    count = count or #SELECTED_MODE.TEAMS

    for position, exit_type in pairs(self._maze_copy_shuffled) do
        if count > 0 then
            if not RoomMap:IsSpecialRoomsNearExists(position) then
                RoomMap:AddRoom(Room(position, {exit_type=exit_type, room_type="START"}))
                count = count - 1
            end
        end
    end

    if count > 0 then
        print("WARNING! Unable to generate all spawn rooms")
    end
end

----------------------------------------------------------------------------
