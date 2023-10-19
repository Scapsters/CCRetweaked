require("stack")


WorldStack = {
    getMaxAge = function(self) return self.maxAge end,

    shouldDespawn = function(self)
        return self.getAge() > self._maxAge
    end
}

function WorldStack:new(o, stack, maxAge)
    stack:resetAge()
    WorldStack._maxAge = maxAge or 60
    return stack:new(WorldStack, stack:getBlock(), stack:getNumber())
end

local block = Block:new(nil, "gyatt")
local stack = Stack:new(nil, block, 15)
local worldStack = WorldStack:new(nil, stack, 70)

print(worldStack:getMaxAge())
print(worldStack:getNumber())
print(worldStack:getId())


