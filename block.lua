-- The atom, the smallest building block of the world.
--
-- Basically useless on its own, holds the management of the
-- most basic properties possible.

Atom = {
    getId = function(self) return self.id end,
    getAge = function(self) return self.age end,

    _setAge = function(self, age) self.age = age end,

    tick = function(self)
        self._setAge(self.getAge() + 1)
    end
}

function Atom:new(o)
    o = o or {
        id = nil,
        age = 0
    }
    o.setmetatable(o, self)
    self.__index = self
    return o
end