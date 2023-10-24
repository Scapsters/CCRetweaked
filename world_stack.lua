require("stack")

-- Represents a stack of items floating in the world, that will eventually despawn

WorldStack = {
    new = function(self, stack, maxAge, oldWorldStack)
        if oldWorldStack ~= nil then -- `Block` explains this
            if stack == nil then stack = oldWorldStack:getStack() end
            if maxAge == nil then maxAge = oldWorldStack:getMaxAge() end         
        end
        if stack == nil then stack = Stack:new() end

        local worldStack = Stack:new(nil, nil, stack) -- Make a new stack or else bad things happen

        setmetatable(worldStack, {
            __index = self,
            __tostring = self.__tostring
        }) -- the object looks to WorldStack
        setmetatable(self, {
            __index = Stack,
            __tostring = Stack.__tostring
        }) -- WorldStack looks to Stack (inheritance)
        -- Note: /stack.lua explains how these can be optimized

        -- set WorldStack properties
        worldStack._maxAge = maxAge or 300
        return worldStack
    end,

    getStack = function(self)
        return Stack:new(self:getBlock(), self:getNumber())
    end,

    getMaxAge = function(self) return self._maxAge end,

    shouldDespawn = function(self)
        return self:getAge() > self._maxAge
    end,

    toString = function(self)
        return self:__tostring()
    end,

    __tostring = function(self)
        if DEBUG then
            return "|WorldStack [_maxAge]: "..self:getMaxAge().." |Stack [_number]: "..self:getNumber().." |Block [_id]: "..self:getId().." [_age]: "..self:getAge().."|||"
        else
            return self:getNumber().." ["..self:getId().."] ("..self:getAge().."t / "..self:getMaxAge().."t)"
        end
    end
}