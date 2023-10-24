---@diagnostic disable: redefined-local
require("world_stack")

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

Test = {
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
        return self._description.."| Expected: "..self._expected.." Actual: "..self._actual
    end
}


local blockTests = Test:new(
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

local stackInheritanceTests = Test:new(
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

local stackTests = Test:new(
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

Tester:addTest(blockTests)
Tester:addTest(stackInheritanceTests)
Tester:addTest(stackTests)
Tester:runTests()