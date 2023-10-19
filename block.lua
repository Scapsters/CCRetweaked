-- The atom, the smallest building block of the world.
--
-- Basically useless on its own, holds the management of the
-- most basic properties possible.

Block = {
    new = function(self, id)
        local block = {
            _id = id or nil,
            _age = 0
        }
        setmetatable(block, self)
        self.__index = self
        return block
    end,

    getId = function(self) return self._id end,
    getAge = function(self) return self._age end,

    resetAge = function(self) self:_setAge(0) end,

    _setAge = function(self, age) self._age = age end,

    _tick = function(self)
        self:_setAge(self:getAge() + 1)
    end
}