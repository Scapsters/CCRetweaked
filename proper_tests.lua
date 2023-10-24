---@diagnostic disable: redefined-local
require("world_stack")
require("inventory")

local Tester = {
    _tests = {n = 0},

    addTest = function(self, test)
        self._tests[self._tests.n + 1] = test
        self._tests.n = self._tests.n + 1
    end,

    _doesPass = function(test)
        return test()
    end,

    runTests = function(self)
        for i,test in pairs(self._tests) do
            if i == "n" then return end -- Dont call `run` on the integer...
            io.write(i..": ")
            test:run()
        end
    end
}

TestBundle = {
    new = function(self, testName, testFunction)
        local test = {
            _testName = testName,
            _testFunction = testFunction
        }
        setmetatable(test, {__index = self})
        return test
    end,

    run = function(self)
        io.write("["..self._testName.."] ")

        local result = self._testFunction()

        if result then print(result)
        else print("All tests passed")
        end
    end
}

Error = {
    new = function(self, expected, actual, description)
        local error = {
            _expected = expected,
            _actual = actual,
            _description = description
        }
        setmetatable(error, {
            __index = self,
            __tostring = self.__tostring
        })
        return error
    end,

    __tostring = function(self)
        return self._description.." | Expected: "..self._expected.." Actual: "..self._actual
    end
}


local blockTests = TestBundle:new(
    "blockTests",
    function()
        local id = "stella arcanum"
        local block = Block:new(id)

        local expected = id
        local actual = block:getId()
        if actual ~= expected then
            return Error:new(expected, actual, "Id set wrong on creation")
        end

        local expected = 0
        local actual = block:getAge()
        if actual ~= expected then
            return Error:new(expected, actual, "Age set wrong on creation")
        end

        for i=1, 16 do block:_tick() end

        local expected = 16
        local actual = block:getAge()
        if actual ~= expected then
            return Error:new(expected, actual, "tick() didnt work")
        end

        block:resetAge()
        local expected = 0
        local actual = block:getAge()
        if actual ~= expected then
            return Error:new(expected, actual, "resetAge didnt work")
        end
    end
)

local stackInheritanceTests = TestBundle:new(
    "stackInheritanceTests",
    function()
        local id = "stella arcanum"
        local block = Block:new(id)
        local stack = Stack:new(block, 32)

        local expected = id
        local actual = stack:getId()
        if actual ~= expected then
            return Error:new(expected, actual, "Id set wrong on creation")
        end

        local expected = 0
        local actual = stack:getAge()
        if actual ~= expected then
            return Error:new(expected, actual, "Age set wrong on creation")
        end

        for i=1, 16 do stack:_tick() end

        local expected = 16
        local actual = stack:getAge()
        if actual ~= expected then
            return Error:new(expected, actual, "tick() didnt work")
        end

        stack:resetAge()
        local expected = 0
        local actual = stack:getAge()
        if actual ~= expected then
            return Error:new(expected, actual, "resetAge didnt work")
        end
    end
)

local stackInheritanceTestsDefault = TestBundle:new(
    "stackInheritanceTestsDefault",
    function()
        local stack = Stack:new()

        local expected = nil
        local actual = stack:getId()
        if actual ~= expected then
            return Error:new(expected, actual, "Id set wrong on creation")
        end

        local expected = 0
        local actual = stack:getAge()
        if actual ~= expected then
            return Error:new(expected, actual, "Age set wrong on creation")
        end

        for i=1, 16 do stack:_tick() end

        local expected = 16
        local actual = stack:getAge()
        if actual ~= expected then
            return Error:new(expected, actual, "tick() didnt work")
        end

        stack:resetAge()
        local expected = 0
        local actual = stack:getAge()
        if actual ~= expected then
            return Error:new(expected, actual, "resetAge didnt work")
        end
    end
)

local stackTests = TestBundle:new(
    "stackTests",
    function()
        local id = "stella arcanum"
        local block = Block:new(id)
        local stack = Stack:new(block, 32)

        local expected = 32
        local actual = stack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "age set wrong on creation")
        end

        local expected = id
        local actual = stack:getBlock():getId()
        if actual ~= expected then
            return Error:new(expected, actual, "getBlock didn't work")
        end

        local expected = 0
        local actual = stack:addItem(16)
        if actual ~= expected then
            return Error:new(expected, actual, "addItem didn't return properly (partial fill case)")
        end

        local expected = 48
        local actual = stack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "addItem didn't add to number")
        end

        local expected = 16
        local actual = stack:addItem(32)
        if actual ~= expected then
            return Error:new(expected, actual, "addItem didn't return properly (overfill case)")
        end

        local expected = 64
        local actual = stack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "addItem didn't add to number properly (overfill limit failed)")
        end

        local expected = 0
        local actual = stack:addItem(0)
        if actual ~= expected then
            return Error:new(expected, actual, "addItem didn't return properly (0 case)")
        end

        local expected = 64
        local actual = stack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "addItem changed number on 0 case while full")
        end

        local expected = 64
        local actual = stack:takeItem(100)
        if actual ~= expected then
            return Error:new(expected, actual, "takeItem returned improperly (overtake case)")
        end

        local expected = 0
        local actual = stack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "takeItem didnt empty stack on overtake case")
        end

        local expected = 0
        local actual = stack:takeItem(10)
        if actual ~= expected then
            return Error:new(expected, actual, "take Item returned improperly (take on empty stack case)")
        end

        local expected = 0
        local actual = stack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "number changed on takeItem on an empty stack")
        end

        local expected = true
        local actual = stack:isEmpty()
        if actual ~= expected then
            return Error:new(expected, actual, "isEmpty is plain fucking wrong :sob:")
        end
    end
)

local worldStackTests = TestBundle:new(
    "worldStackTests",
    function()
        local id = "stella arcanum"
        local block = Block:new(id)
        local stack = Stack:new(block, 32)
        local worldStack = WorldStack:new(stack)

        local expected = 300
        local actual = worldStack:getMaxAge()
        if actual ~= expected then
            return Error:new(expected, actual, "maxAge isnt set properly by default")
        end

        local worldStack = WorldStack:new(stack, 10)

        local expected = 10
        local actual = worldStack:getMaxAge()
        if actual ~= expected then
            return Error:new(expected, actual, "maxAge isnt set properly by argument")
        end

        local expected = id
        local actual = worldStack:getStack():getId()
        if actual ~= expected then
            return Error:new(expected, actual, "getStack doesn't work")
        end

        local expected = id
        local actual = worldStack:getStack():getBlock():getId()
        if actual ~= expected then
            return Error:new(expected, actual, "getStack then getBlock doesn't work somehow")
        end

        local expected = false
        local actual = worldStack:shouldDespawn()
        if actual ~= expected then
            return Error:new(tostring(expected), tostring(actual), "shouldDespawn is wrong")
        end

        for i=1, 11 do worldStack:_tick() end

        local expected = true
        local actual = worldStack:shouldDespawn()
        if actual ~= expected then
            return Error:new(tostring(expected), tostring(actual), "shouldDespawn is wrong")
        end
    end
)

local worldStackInheritanceTests = TestBundle:new(
    "worldStackInheritanceTests",
    function()
        local id = "stella arcanum"
        local block = Block:new(id)
        local stack = Stack:new(block, 32)
        local worldStack = WorldStack:new(stack, 10)

        local expected = id
        local actual = worldStack:getId()
        if actual ~= expected then
            return Error:new(expected, actual, "Id set wrong on creation")
        end

        local expected = 0
        local actual = worldStack:getAge()
        if actual ~= expected then
            return Error:new(expected, actual, "Age set wrong on creation")
        end

        for i=1, 16 do worldStack:_tick() end

        local expected = 16
        local actual = worldStack:getAge()
        if actual ~= expected then
            return Error:new(expected, actual, "tick() didnt work")
        end

        worldStack:resetAge()
        local expected = 0
        local actual = worldStack:getAge()
        if actual ~= expected then
            return Error:new(expected, actual, "resetAge didnt work")
        end

        local expected = 32
        local actual = worldStack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "age set wrong on creation")
        end

        local expected = id
        local actual = worldStack:getBlock():getId()
        if actual ~= expected then
            return Error:new(expected, actual, "getBlock didn't work")
        end

        local expected = 0
        local actual = worldStack:addItem(16)
        if actual ~= expected then
            return Error:new(expected, actual, "addItem didn't return properly (partial fill case)")
        end

        local expected = 48
        local actual = worldStack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "addItem didn't add to number")
        end

        local expected = 16
        local actual = worldStack:addItem(32)
        if actual ~= expected then
            return Error:new(expected, actual, "addItem didn't return properly (overfill case)")
        end

        local expected = 64
        local actual = worldStack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "addItem didn't add to number properly (overfill limit failed)")
        end

        local expected = 0
        local actual = worldStack:addItem(0)
        if actual ~= expected then
            return Error:new(expected, actual, "addItem didn't return properly (0 case)")
        end

        local expected = 64
        local actual = worldStack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "addItem changed number on 0 case while full")
        end

        local expected = 64
        local actual = worldStack:takeItem(100)
        if actual ~= expected then
            return Error:new(expected, actual, "takeItem returned improperly (overtake case)")
        end

        local expected = 0
        local actual = worldStack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "takeItem didnt empty stack on overtake case")
        end

        local expected = 0
        local actual = worldStack:takeItem(10)
        if actual ~= expected then
            return Error:new(expected, actual, "take Item returned improperly (take on empty stack case)")
        end

        local expected = 0
        local actual = worldStack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "number changed on takeItem on an empty stack")
        end

        local expected = true
        local actual = worldStack:isEmpty()
        if actual ~= expected then
            return Error:new(expected, actual, "isEmpty is plain fucking wrong :sob:")
        end
    end
)

local inventoryTests = TestBundle:new(
    "inventoryTests",
    function()
        local inventory = Inventory:new()

        local expected = 1
        local actual = inventory:getSelectedSlot()
        if actual ~= expected then
            return Error:new(expected, actual, "getSelectedSlot is plain wrong")
        end

        inventory:select(4)

        local expected = 4
        local actual = inventory:getSelectedSlot()
        if actual ~= expected then
            return Error:new(expected, actual, "select didnt work")
        end

        inventory:select(17)

        local expected = 1
        local actual = inventory:getSelectedSlot()
        if actual ~= expected then
            return Error:new(expected, actual, "select wraparound didnt work")
        end

        local block = Block:new("stella arcanum")
        local stack = Stack:new(block, 32)

        stack:takeItem(inventory:pickUp(stack))

        local expected = 0
        local actual = stack:getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "pickUp didnt remove properly from stack")
        end

        local expected = 32
        local actual = inventory:getSelectedStack():getNumber()
        if actual ~= expected then
            return Error:new(expected, actual, "pickUp didnt add properly to inventory")
        end
    end
)

Tester:addTest(blockTests)
Tester:addTest(stackInheritanceTests)
Tester:addTest(stackInheritanceTestsDefault)
Tester:addTest(stackTests)
Tester:addTest(worldStackInheritanceTests)
Tester:addTest(worldStackTests)
Tester:addTest(inventoryTests)
Tester:runTests()