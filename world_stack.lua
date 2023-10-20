require("stack")

-- Represents a stack of items floating in the world, that will eventually despawn

WorldStack = {
    new = function(self, stack, maxAge)
        local worldStack = Stack:new(stack:getBlock(), stack:getNumber()) -- Make a new stack or else bad things happen

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