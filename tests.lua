require("world_stack")

-- This creates a 64 stack of grass floating in the world
local block = Block:new("grASS")
local stack = Stack:new(block, 64)
local worldStack = WorldStack:new(stack, 300)

-- This does too, but we dont talk about this
local worldStack2 = WorldStack:new(Stack:new(Block:new("DIRT :smirk:"), 32), 100)

-- Test WorldStack methods
assert(worldStack:getMaxAge() == 300, "1")
assert(worldStack:shouldDespawn() == false, "2")

-- Test Stack methods
assert(worldStack:getNumber() == 64, "3")
assert(worldStack:getBlock():getId() == "grASS", "4")
assert(worldStack:isEmpty() == false, "5")
assert(worldStack:takeItem(10) == 10, "6")
assert(worldStack:getNumber() == 54, "7")
assert(worldStack:takeItem(60) == 54, "8")
assert(worldStack:getNumber() == 0, "9")

-- Test Block methods
assert(worldStack:getId() == "grASS", "10")
assert(worldStack:getAge() == 0, "11")
for i=1, 10 do worldStack:_tick() end
assert(worldStack:getAge() == 10, "12") --(0 + 10)
worldStack:resetAge()
assert(worldStack:getAge() == 0, "13") -- 0 (it was just reset)

-- See if objects mess with eachother in ways they arent supposed to
assert(worldStack:getNumber() == 0, "14")
assert(worldStack2:getNumber() == 32, "15")

for i=1, 10 do worldStack2:_tick() end
assert(worldStack:getAge() == 0, "16")
assert(worldStack2:getAge() == 10, "17")

print("all tests passed")