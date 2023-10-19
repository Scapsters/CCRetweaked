require("world_stack")

-- This creates a 64 stack of grass floating in the world
local block = Block:new("grASS")
local stack = Stack:new(block, 64)
local worldStack = WorldStack:new(stack, 300)

-- This does too, but we dont talk about this
local worldStack2 = WorldStack:new(Stack:new(Block:new("DIRT :smirk:"), 32), 100)

-- Test WorldStack methods
print("\n"..worldStack:getMaxAge()) -- 300
print(worldStack:shouldDespawn()) -- false

-- Test Stack methods
print("\n"..worldStack:getNumber()) -- 64
print(worldStack:getBlock():getId()) -- "grASS"
print(worldStack:isEmpty()) -- false
print(worldStack:takeItem(10)) -- 10
print(worldStack:getNumber()) -- 54 (64 - 10)

-- Test Block methods
print("\n"..worldStack:getId()) -- "grASS"
print(worldStack:getAge()) -- 0
for i=1, 10 do worldStack:_tick() end -- nothing
print(worldStack:getAge()) -- 10 (0 + 10)
worldStack:resetAge()
print(worldStack:getAge()) -- 0 (it was just reset)

-- See if objects mess with eachother in ways they arent supposed to
print("\n"..worldStack:getNumber()) -- 54
print(worldStack2:getNumber()) -- 32

for i=1, 10 do worldStack2:_tick() end
print("\n"..worldStack:getAge()) -- 0
print(worldStack2:getAge()) -- 10