
if Queue == nil then
    require("types/object")
    Queue = object()
end

require("collections/hashset")

function Queue:constructor(table)
    self._values = HashSet()
    self._queue = {}
    self._pointer = -1

    if table ~= nil and type(table) == "table" then
        for _, value in pairs(table) do
            self:Enqueue(value)
        end
    end
end

function Queue:Enqueue(value)
    self._pointer = self._pointer + 1
    self._queue[self._pointer] = value
    self._values:Add(value)
end

function Queue:Dequeue()
    if self._pointer <= -1 then
        print("WARNING! Dequeue from empty queue")
        return nil
    end

    local value = self._queue[self._pointer]
    self._values:Remove(value)
    self._queue[self._pointer] = nil
    self._pointer = self._pointer - 1

    if value == nil then
        return self:Dequeue()
    end

    return value
end

function Queue:Last()
    if self._pointer <= -1 then
        print("WARNING! Unable to get last from empty queue")
        return nil
    end

    return self._queue[self._pointer]
end

function Queue:Contains(value)
    return self._values:Contains(value)
end

function Queue:ToTable()
    return pairs(self:ToTable())
end

function Queue:ToTable()
    return self._queue
end

function Queue:Length()
    return self._pointer + 1
end
