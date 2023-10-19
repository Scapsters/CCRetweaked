require("stack")


WorldStack = {
    new = function(self, stack, maxAge)
        local worldStack = stack

        setmetatable(worldStack, {__index = self}) -- the object looks to WorldStack
        setmetatable(self, {__index = Stack}) -- WorldStack looks to Stack (inheritance)
        -- Note: /stack.lua explains how these can be optimized

        -- set WorldStack properties
        worldStack._maxAge = maxAge
        return worldStack
    end,

    getMaxAge = function(self) return self._maxAge end,

    shouldDespawn = function(self)
        return self:getAge() > self._maxAge
    end
}