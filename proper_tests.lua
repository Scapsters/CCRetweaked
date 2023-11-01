---@module 'world_stack'
require("world_stack")
---@module 'inventory'
require("inventory")

---@class Checker
---@field addCheckBundle function
---@field runChecks function
---@field private _checkBundles CheckBundle[]
local Checker = {
    _checkBundles = {},

    addCheckBundle = function(self, test)
        self._checkBundles[#self._checkBundles + 1] = test
    end,

    runChecks = function(self)
        for i,checkBundle in pairs(self._checkBundles) do
            io.write(i..": ")
            checkBundle:run()
        end
    end
}

---@class CheckBundle
---@field public new function
---@field public add function
---@field public run function
---@field private _name string
---@field private _checks Check[]
CheckBundle = {
    new = function(self, name, tests)
        local checkBundle = {
            _name = name,
            _checks = tests or {}
        }
        setmetatable(checkBundle, {__index = self})
        return checkBundle
    end,

    add = function(self, actual, expected, description)
        local check = Check:new(actual, expected, description)
        self._checks[#self._checks + 1] = check
    end,

    run = function(self)
        local numberFailedChecks = 0
        for index, check in pairs(self._checks) do
            local result = check:run()
            if result then
                print(result)
                numberFailedChecks = numberFailedChecks + 1
            end
        end
        if numberFailedChecks == 0 then
            print(self._name..": All checks passed")
        else
            print(self._name..": "..numberFailedChecks.." checks failed")
        end
    end
}

---@class Check
---@field new function
---@field run function
---@field _actual number|string|boolean
---@field _expected number|string|boolean
---@field _description string
---@field private __tostring function
Check = {
    new = function(self, actual, expected, description)
        local check = {
            _actual = actual,
            _expected = expected,
            _description = description
        }
        setmetatable(check,{
            __index = self,
            __tostring = self.__tostring
        })
        return check
    end,

    run = function(self)
        if self._actual ~= self._expected then
            return self
        end -- If there is no result, return nothing
    end,

    __tostring = function(self)
        return self._description.." | Expected: "..self._expected.." Actual: "..self._actual
    end
}

local function blockChecks()
    local checks = CheckBundle:new("blockChecks")

    local id = "stella_arcanum"
    local block = Block:new(id)

    checks:add(block:getId(), id, "Id set wrong on creation")
    checks:add(block:getAge(), 0, "Age set wrong on creation")

    for i=1, 16 do
        block:tick()
    end

    checks:add(block:getAge(), 16, "`tick` did not change age")
    block:resetAge()
    checks:add(block:getAge(), 0, "`resetAge` didn't")

    return checks
end

local function stackInheritanceTests()
    local checks = CheckBundle:new("stackInheritanceChecks")

    local id = "stella_arcanum"
    local block = Block:new(id)
    local stack = Stack:new(block, 16)

    checks:add(stack:getId(), id, "Id set wrong on creation")
    checks:add(stack:getAge(), 0, "Age set wrong on creation")

    for i=1, 16 do
        stack:tick()
    end

    checks:add(stack:getAge(), 16, "`tick` did not change age")
    stack:resetAge()
    checks:add(stack:getAge(), 0, "`resetAge` didn't")

    return checks
end

local function stackInheritanceTestsDefault()
    local checks = CheckBundle:new("stackInheritanceTestsDefault")

    local stack = Stack:new()

    checks:add(stack:getId(), nil, "Id set wrong on creation")
    checks:add(stack:getAge(), 0 ,"Age set wrong on creation")

    for i=1, 16 do
        stack:tick()
    end

    checks:add(stack:getAge(), 16, "`tick` did not change age")

    stack:resetAge()

    checks:add(stack:getAge(), 0, "`resetAge` didn't")

    return checks
end

local function stackTests()
    local checks = CheckBundle:new("stackTests")

    local id = "stella arcanum"
    local block = Block:new(id)
    local stack = Stack:new(block, 32)

    local function newTests()
        checks:add(stack:getNumber(), 32, "age set wrong on creation")
        checks:add(stack:getBlock():getId(), id, "getBlock didn't")
    end

    local function addItemTestPartialFill()
        checks:add(stack:addItem(16), 0, "addItem didn't return properly (partial fill case)")
        checks:add(stack:getNumber(), 48, "addItem didn't add to number (partial fill case)")
    end

    local function addItemTestOverfill()
        checks:add(stack:addItem(32), 16, "addItem didn't return properly (overfill case)")
        checks:add(stack:getNumber(), 64, "addItem didn't add to number properly (overfill case)")
        checks:add(stack:isEmpty(), false, "isEmpty is super fucking wrong")
    end

    local function addItemTestZero()
        checks:add(stack:addItem(0), 0, "additem didn't return properly (0 case)")
        checks:add(stack:getNumber(), 64, "addItem changed number while full (0 case)")
    end

    local function addItemTestEntirelyOverfill()
        checks:add(stack:addItem(16), 16, "addItem didn't return properly (entirely overfill case)")
        checks:add(stack:getNumber(), 64, "addItem changed number while full (entirely overfill case)")
    end

    local function takeItemTestOvertake()
        checks:add(stack:takeItem(100), 64, "takeItem returned improperly (overtake case)")
        checks:add(stack:getNumber(), 0, "takeItem didn't empty stack (overtake case)")
    end

    local function takeItemTestEmpty()
        checks:add(stack:takeItem(10), 0, "takeItem returned improperly (take on empty case)")
        checks:add(stack:getNumber(), 0, "takeItem changed number on an empty stack (take on empty case)")
    end

    local function isEmptyTestEmpty()
        checks:add(stack:isEmpty(), true, "isEmpty is plain fucking wrong :sob:")
    end

    newTests()
    addItemTestPartialFill()
    addItemTestOverfill()
    addItemTestZero()
    addItemTestEntirelyOverfill()
    takeItemTestOvertake()
    takeItemTestEmpty()
    isEmptyTestEmpty()

    return checks
end

local function worldStackTests()
    local checks = CheckBundle:new("worldStackTests")

    local id = "stella arcanum"
    local block = Block:new(id)
    local stack = Stack:new(block, 32)
    local worldStack = WorldStack:new(stack)
    local worldStack2 = WorldStack:new(stack, 10)

    local function newTests()
        checks:add(worldStack:getMaxAge(), 300, "maxAge isn't set properly by default")
        checks:add(worldStack2:getMaxAge(), 10, "maxAge isn't set properly by argument")
        checks:add(worldStack2:getStack():getId(), id, "getStack doesn't work")
        checks:add(worldStack2:getStack():getBlock():getId(), id, "getStack then getBlock doesn't work somehow")
    end

    local function shouldDespawnTests()
        checks:add(worldStack2:shouldDespawn(), false, "shouldDespawn is wrong")
        for i=1, 11 do worldStack2:tick() end
        checks:add(worldStack2:shouldDespawn(), true, "shouldDespawn is wrong")
    end

    newTests()
    shouldDespawnTests()

    return checks
end

local function worldStackInheritanceTests()
    local checks = CheckBundle:new("worldStackInheritanceTests")

    local id = "stella arcanum"
    local block = Block:new(id)
    local stack = Stack:new(block, 32)
    local worldStack = WorldStack:new(stack, 10)

    local function newTests()
        checks:add(stack:getNumber(), 32, "age set wrong on creation")
        checks:add(worldStack:getBlock():getId(), id, "getBlock didn't")
        checks:add(worldStack:getId(), id, "Id set wrong on creation")
        checks:add(worldStack:getAge(), 0, "Age set wrong on creation")
    end

    local function addItemTests()
        checks:add(worldStack:addItem(16), 0, "addItem didn't return properly (partial fill case)")
        checks:add(worldStack:getNumber(), 48, "addItem didn't add to number (partial fill case)")

        checks:add(worldStack:addItem(32), 16, "addItem didn't return properly (overfill case)")
        checks:add(worldStack:getNumber(), 64, "addItem didn't add to number properly (overfill case)")
        checks:add(worldStack:isEmpty(), false, "isEmpty is super fucking wrong")

        checks:add(worldStack:addItem(0), 0, "additem didn't return properly (0 case)")
        checks:add(worldStack:getNumber(), 64, "addItem changed number while full (0 case)")

        checks:add(worldStack:addItem(16), 16, "addItem didn't return properly (entirely overfill case)")
        checks:add(worldStack:getNumber(), 64, "addItem changed number while full (entirely overfill case)")
    end

    local function takeItemTests()
        checks:add(worldStack:takeItem(100), 64, "takeItem returned improperly (overtake case)")
        checks:add(worldStack:getNumber(), 0, "takeItem didn't empty worldStack (overtake case)")

        checks:add(worldStack:takeItem(10), 0, "takeItem returned improperly (take on empty case)")
        checks:add(worldStack:getNumber(), 0, "takeItem changed number on an empty worldStack (take on empty case)")
        checks:add(worldStack:isEmpty(), true, "isEmpty is plain fucking wrong :sob:")
    end

    local function tickTests()
        for i=1, 16 do
            worldStack:tick()
        end

        checks:add(worldStack:getAge(), 16, "`tick` did not change age")
        worldStack:resetAge()
        checks:add(worldStack:getAge(), 0, "`resetAge` didn't")
    end

    newTests()
    addItemTests()
    takeItemTests()
    tickTests()

    return checks
end

local function inventoryTests ()
    local checks = CheckBundle:new("inventoryTests")

    local inventory = Inventory:new()

    local function getSelectedSlotTests()
        checks:add(inventory:getSelectedSlot(), 1, "getSelectedSlot is set wrong on creation")
        inventory:select(4)
        checks:add(inventory:getSelectedSlot(), 4, "select doesn't work")
        inventory:select(17)
        checks:add(inventory:getSelectedSlot(), 1, "select didn't work (wraparound case)")
    end

    local function pickUpTests()
        local block = Block:new("stella arcanum")
        local stack = Stack:new(block, 32)
        inventory:pickUp(stack)

        checks:add(stack:getNumber(), 0, "pickUp didnt remove properly from stack")
        checks:add(inventory:getSelectedStack():getNumber(), 32, "pickUp didnt add properly to inventory")

        local stack2 = Stack:new(block, 48)
        inventory:pickUp(stack2)

        checks:add(stack2:getNumber(), 0, "pickup didnt remoove properly from stack (2 stack dropoff case)")
        checks:add(inventory:getSelectedStack():getNumber(), 64, "pickUp didnt add properly to inventory (2 stack dropoff case, 1st stack)")

        inventory:select(2)

        checks:add(inventory:getSelectedStack():getNumber(), 16, "pickup didnt add properly to inventory (2 stack dropoff case, 2nd stack)")

        local block2 = Block:new("diamond")
        local stack3 = Stack:new(block2, 48)
        inventory:pickUp(stack3)
        inventory:select(3)

        checks:add(inventory:getSelectedStack():getNumber(), 48, "pickup didn't add properly to inventory (item 1 dropping off into and inventory with partial slots of item 2 case)")
    end

    local function moveItemTests()
        inventory:select(2)
        local block = Block:new("stella arcanum")
        local stack = Stack:new(block, 0)
        inventory:moveItem(stack, 64)

        checks:add(inventory:getSelectedStack():getNumber(), 0, "takeItem did not remove items")
        checks:add(stack:getNumber(), 16, "takeItem did not return the proper number")

        inventory:select(1)
        inventory:moveItem(stack, 64)

        checks:add(inventory:getSelectedStack():getNumber(), 16, "inventory removed too many items from itself or the stack returned improperly from addItem")
        checks:add(stack:getNumber(), 64, "inventory did not take the proper amount of items from itself")
    end

    local function sideEffectTests()
        inventory:select(4)
        checks:add(inventory:getSelectedStack():getNumber(), 0, "a slot that should be 0 is not zero")
    end

    getSelectedSlotTests()
    pickUpTests()
    moveItemTests()
    sideEffectTests()

    return checks
end

Checker:addCheckBundle(blockChecks())
Checker:addCheckBundle(stackInheritanceTests())
Checker:addCheckBundle(stackInheritanceTestsDefault())
Checker:addCheckBundle(stackTests())
Checker:addCheckBundle(worldStackTests())
Checker:addCheckBundle(worldStackInheritanceTests())
Checker:addCheckBundle(inventoryTests())
Checker:runChecks()