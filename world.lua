World = {
    tick = function(self)
        self._blockMap.tick()
        self._turtle.tick()
    end,

    constructSimpleWorld = function(self)
        self._blockMap:constructSimpleWorld()
        self._turtle:_setPosition(2, 5, 2)
    end
}

function World:new (o)
    o = o or {
        _blockMap = BlockMap:new(),
        _turtle = Turtle:new(),
        age = 0
    }
    setmetatable(o, self)
    self.__index = self
    return o
end