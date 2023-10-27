---@diagnostic disable: redefined-local
require("world_stack")
require("inventory")

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
        block:_tick()
    end

    checks:add(block:getAge(), 16, "`_tick` did not change age")
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
        stack:_tick()
    end

    checks:add(stack:getAge(), 16, "`_tick` did not change age")
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
        stack:_tick()
    end

    checks:add(stack:getAge(), 16, "`_tick` did not change age")

    stack:resetAge()

    checks:add(stack:getAge(), 0, "`resetAge` didn't")

    return checks
end

local function stackTests()
    local checks = CheckBundle:new("stackTests")

    local id = "stella arcanum"
    local block = Block:new(id)
    local stack = Stack:new(block, 32)

    checks:add(stack:getNumber(), 32, "age set wrong on creation")
    checks:add(stack:getBlock():getId(), id, "getBlock didn't")

    checks:add(stack:addItem(16), 0, "addItem didn't return properly (partial fill case)")
    checks:add(stack:getNumber(), 48, "addItem didn't add to number (partial fill case)")

    checks:add(stack:addItem(32), 16, "addItem didn't return properly (overfill case)")
    checks:add(stack:getNumber(), 64, "addItem didn't add to number properly (overfill case)")
    checks:add(stack:isEmpty(), false, "isEmpty is super fucking wrong")

    checks:add(stack:addItem(0), 0, "additem didn't return properly (0 case)")
    checks:add(stack:getNumber(), 64, "addItem changed number while full (0 case)")

    checks:add(stack:addItem(16), 16, "addItem didn't return properly (entirely overfill case)")
    checks:add(stack:getNumber(), 64, "addItem changed number while full (entirely overfill case)")

    checks:add(stack:takeItem(100), 64, "takeItem returned improperly (overtake case)")
    checks:add(stack:getNumber(), 0, "takeItem didn't empty stack (overtake case)")

    checks:add(stack:takeItem(10), 0, "takeItem returned improperly (take on empty case)")
    checks:add(stack:getNumber(), 0, "takeItem changed number on an empty stack (take on empty case)")
    checks:add(stack:isEmpty(), true, "isEmpty is plain fucking wrong :sob:")

    return checks
end

local function worldStackTests()
    local checks = CheckBundle:new("worldStackTests")

    local id = "stella arcanum"
    local block = Block:new(id)
    local stack = Stack:new(block, 32)
    local worldStack = WorldStack:new(stack)

    checks:add(worldStack:getMaxAge(), 300, "maxAge isn't set properly by default")

    local worldStack = WorldStack:new(stack, 10)

    checks:add(worldStack:getMaxAge(), 10, "maxAge isn't set properly by argument")

    checks:add(worldStack:getStack():getId(), id, "getStack doesn't work")
    checks:add(worldStack:getStack():getBlock():getId(), id, "getStack then getBlock doesn't work somehow")

    checks:add(worldStack:shouldDespawn(), false, "shouldDespawn is wrong")
    for i=1, 11 do worldStack:_tick() end
    checks:add(worldStack:shouldDespawn(), true, "shouldDespawn is wrong")

    return checks
end

local function worldStackInheritanceTests()
    local checks = CheckBundle:new("worldStackInheritanceTests")

    local id = "stella arcanum"
    local block = Block:new(id)
    local stack = Stack:new(block, 32)
    local worldStack = WorldStack:new(stack, 10)

    checks:add(stack:getNumber(), 32, "age set wrong on creation")
    checks:add(worldStack:getBlock():getId(), id, "getBlock didn't")

    checks:add(worldStack:addItem(16), 0, "addItem didn't return properly (partial fill case)")
    checks:add(worldStack:getNumber(), 48, "addItem didn't add to number (partial fill case)")

    checks:add(worldStack:addItem(32), 16, "addItem didn't return properly (overfill case)")
    checks:add(worldStack:getNumber(), 64, "addItem didn't add to number properly (overfill case)")
    checks:add(worldStack:isEmpty(), false, "isEmpty is super fucking wrong")

    checks:add(worldStack:addItem(0), 0, "additem didn't return properly (0 case)")
    checks:add(worldStack:getNumber(), 64, "addItem changed number while full (0 case)")

    checks:add(worldStack:addItem(16), 16, "addItem didn't return properly (entirely overfill case)")
    checks:add(worldStack:getNumber(), 64, "addItem changed number while full (entirely overfill case)")

    checks:add(worldStack:takeItem(100), 64, "takeItem returned improperly (overtake case)")
    checks:add(worldStack:getNumber(), 0, "takeItem didn't empty worldStack (overtake case)")

    checks:add(worldStack:takeItem(10), 0, "takeItem returned improperly (take on empty case)")
    checks:add(worldStack:getNumber(), 0, "takeItem changed number on an empty worldStack (take on empty case)")
    checks:add(worldStack:isEmpty(), true, "isEmpty is plain fucking wrong :sob:")

    checks:add(worldStack:getId(), id, "Id set wrong on creation")
    checks:add(worldStack:getAge(), 0, "Age set wrong on creation")

    for i=1, 16 do
        worldStack:_tick()
    end

    checks:add(worldStack:getAge(), 16, "`_tick` did not change age")
    worldStack:resetAge()
    checks:add(worldStack:getAge(), 0, "`resetAge` didn't")

    return checks
end

local function inventoryTests ()
    local checks = CheckBundle:new("inventoryTests")

    local inventory = Inventory:new()

    checks:add(inventory:getSelectedSlot(), 1, "getSelectedSlot is set wrong on creation")
    inventory:select(4)
    checks:add(inventory:getSelectedSlot(), 4, "select doesn't work")
    inventory:select(17)
    checks:add(inventory:getSelectedSlot(), 1, "select didn't work (wraparound case)")

    local block = Block:new("stella arcanum")
    local stack = Stack:new(block, 32)
    stack:takeItem(inventory:pickUp(stack))

    Check:new(stack:getNumber(), 0, "pickUp didnt remove properly from stack")
    Check:new(inventory:getSelectedStack():getNumber(), 32, "pickUp didnt add properly to inventory")

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