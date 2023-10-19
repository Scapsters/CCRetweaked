-- The atom, the smallest building block of the world.
--
-- Basically useless on its own, holds the management of the
-- most basic properties possible.

Block = {
    getId = function(self) return self._id end,
    getAge = function(self) return self._age end,

    resetAge = function(self) self:_setAge(0) end,

    _setAge = function(self, age) self._age = age end,

    _tick = function(self)
        self._setAge(self.getAge() + 1)
    end
}

function Block:new(o, id)
    o = o or {
        _id = id or nil,
        _age = 0
    }
    setmetatable(o, self)
    self.__index = self
    return o
end