
if MazeGenerator == nil then
    MazeGenerator = class({})
end

require("collections/hashset")
require("collections/hashtable")
require("collections/queue")

require("types/vector2")

----------------------------------------------------------------------------

function MazeGenerator:constructor(size)
    print("[Maze] Create with size: "..tostring(size).."x"..tostring(size))
    self.minX, self.maxX = 1, size
    self.minY, self.maxY = 1, size

    self.maze = HashTable()

    self._undiscovered_positions = HashSet()
    self._positions_stack = Queue()
    self._current_position = Vector2(self.minX, self.minY)

    self._exit_offsets = HashTable({
        [Vector2(0, 1)]  = "u",
        [Vector2(1, 0)]  = "r",
        [Vector2(0, -1)] = "d",
        [Vector2(-1, 0)] = "l",
    })
end

----------------------------------------------------------------------------

function MazeGenerator:GenerateMaze()
    print("[Maze] Generate")
    self:_fillUndiscoveredPositions()
    self:_setCurrentPosition(self._current_position)

    while self._undiscovered_positions:Length() > 0 do
        local neighbour_positions = self:_getNeighbourPositions(self._current_position)

        if #neighbour_positions > 0 then
            local neighbour_position = neighbour_positions[math.random(#neighbour_positions)]
            self:_addPassBetween(self._current_position, neighbour_position)

            self._positions_stack:Enqueue(self._current_position)
            self:_setCurrentPosition(neighbour_position)
        else
            self._current_position = self._positions_stack:Dequeue()
        end
    end
end

----------------------------------------------------------------------------

function MazeGenerator:_fillUndiscoveredPositions()
    self._undiscovered_positions = HashSet()

    for x = self.minX, self.maxX do
        for y = self.minY, self.maxY do
            self._undiscovered_positions:Add(Vector2(x, y))
        end
    end
end

----------------------------------------------------------------------------

function MazeGenerator:_setCurrentPosition(position)
    self._current_position = position
    self._undiscovered_positions:Remove(position)
end

----------------------------------------------------------------------------

function MazeGenerator:_getNeighbourPositions(position)
    local neighbour_positions = {}

    for exitOffset, _ in self._exit_offsets:Pairs() do
        local neighbour_position = position + exitOffset
        if self._undiscovered_positions:Contains(neighbour_position) then
            table.insert(neighbour_positions, neighbour_position)
        end
    end
    return neighbour_positions
end

----------------------------------------------------------------------------

function MazeGenerator:ExtendDeadEnds()
    print("[Maze] Extend dead ends")
    for position, exits in self.maze:Pairs() do
        if #exits == 1 then
            for exitOffset, exit in self._exit_offsets:Pairs() do
                if exits[1] ~= exit then
                    local neighbour_position = position + exitOffset
                    if self:_isPositionInBounds(neighbour_position) then
                        self:_addPassBetween(position, neighbour_position)
                        break
                    end
                end
            end
        end
    end
end

----------------------------------------------------------------------------

function MazeGenerator:_isPositionInBounds(position)
    return position.x >= self.minX and position.x <= self.maxX and
           position.y >= self.minY and position.y <= self.maxY
end

----------------------------------------------------------------------------

function MazeGenerator:_addPassBetween(position_a, position_b)
    self:_addExit(position_b, self._exit_offsets:Get(position_a - position_b))
    self:_addExit(position_a, self._exit_offsets:Get(position_b - position_a))
end

----------------------------------------------------------------------------

function MazeGenerator:_addExit(position, exit)
    if not self.maze:Contains(position) then
        self.maze:Set(position, {})
    end

    table.insert(self.maze:Get(position), exit)
end

----------------------------------------------------------------------------

function MazeGenerator:ResortExits()
    local converted = {
        [1] = "u", [2] = "r", [3] = "d", [4] = "l",
        u = 1, r = 2, d = 3, l = 4}

    for position, exits in self.maze:Pairs() do
        local exit_indexes = {}
        for _, exit in pairs(exits) do
            table.insert(exit_indexes, converted[exit])
        end

        table.sort(exit_indexes)
        local sorted_exits = {}
        for ind, exitIndex in pairs(exit_indexes) do
            sorted_exits[ind] = converted[exitIndex]
        end

        self.maze:Set(position, sorted_exits)
    end
end

----------------------------------------------------------------------------

function MazeGenerator:GetMazeWithConcatExits()
    local concat_exits = {}
    for position, exits in self.maze:Pairs() do
        concat_exits[position] = table.concat(exits)
    end

    return concat_exits
end

----------------------------------------------------------------------------

function MazeGenerator:PrintRoomMaze()
    local display = {
        u = "╹", ur = "┗", urd = "┣", ud = "┃",
        r = "╺", rd = "┏", rdl = "┳", rl = "━",
        d = "╻", dl = "┒", udl = "┫",
        l = "╸", ul = "┛", url = "┻", urdl = "╋"
    }

    print("[Maze] Pattern (utf8)")
    print("-------------------------------------------------------")
    for y = self.minY, self.maxY do
        local stroke = {}
        for x = self.minX, self.maxX do
            local exits = self.maze:Get(Vector2(x, 8 - y))
            if exits ~= nil then
                table.insert(stroke, display[table.concat(exits)])
            end
        end
        print(table.concat(stroke))
    end
    print("-------------------------------------------------------")
end

----------------------------------------------------------------------------