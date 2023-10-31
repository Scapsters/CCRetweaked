require("world_stack")
require("inventory")

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
for i=1, 10 do worldStack:tick() end
assert(worldStack:getAge() == 10, "12") --(0 + 10)
worldStack:resetAge()
assert(worldStack:getAge() == 0, "13") -- 0 (it was just reset)

-- See if objects mess with eachother in ways they arent supposed to
assert(worldStack:getNumber() == 0, "14")
assert(worldStack2:getNumber() == 32, "15")

for i=1, 10 do worldStack2:tick() end
assert(worldStack:getAge() == 0, "16")
assert(worldStack2:getAge() == 10, "17")

local block = Block:new("pringles")
local stack = Stack:new(block, 50)

-- Stack testing
assert(stack:addItem(20) == 6, "18") -- (50 + 20) - 64 = 6
assert(stack:getNumber() == 64, "19")

assert(stack:takeItem(64) == 64, "20")
assert(stack:getNumber() == 0, "21")

assert(stack:addItem(20) == 0, "22")
assert(stack:getNumber() == 20, "23")

-- Inventory testing
local inventory = Inventory:new()

local block = Block:new("cum block")
local stack = Stack:new(block, 64)
print(stack:getNumber())

local block = Block:new("bbbb")
local partialStack = Stack:new(block, 48)
print(stack:getNumber())
print(partialStack:getNumber())

-- Just dump a stack
assert(inventory:pickUp(stack) == 0, "24")
assert(inventory:_getSelectedStack() ~= nil, "25")
assert(inventory:_getSelectedStack():getId() == "cum block", "26")

-- Dump 3/4 of a stack twice, check the two slots
assert(inventory:pickUp(partialStack) == 0, "27")
assert(inventory:pickUp(partialStack) == 0, "28")
inventory:select(2)
print(inventory:_getSelectedStack():getNumber())
assert(inventory:_getSelectedStack():getNumber() == 64, "29")
inventory:select(3)
print(inventory:_getSelectedStack():getNumber())

-- Weird bug where if you create a block, then create 2 stacks from that block,
-- both stacks turn into the same stack?? this tests that

local block = Block:new("Goodnight, gamer")
local stack = Stack:new(block, 64)
local differentStack = Stack:new(block, 10)
assert(stack:getNumber() == 64, "30")

print("all shit tests passed")

print(block)
print(stack)
print(worldStack)

DEBUG = false

print(block)
print(stack)
print(worldStack)