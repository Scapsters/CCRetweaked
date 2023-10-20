require("stack")

-- Represents a stack of items floating in the world, that will eventually despawn

WorldStack = {
    new = function(self, stack, maxAge, oldWorldStack)
        local worldStack = Stack:new(nil, nil, stack or oldWorldStack:getStack()) -- Make a new stack or else bad things happen

        setmetatable(worldStack, {__index = self}) -- the object looks to WorldStack
        setmetatable(self, {__index = Stack}) -- WorldStack looks to Stack (inheritance)
        -- Note: /stack.lua explains how these can be optimized

        -- set WorldStack properties
        worldStack._maxAge = maxAge
        return worldStack
    end,

    getStack = function(self)
        return Stack:new(self:getBlock(), self:getNumber())
    end,

    getMaxAge = function(self) return self._maxAge end,

    shouldDespawn = function(self)
        return self:getAge() > self._maxAge
    end
}