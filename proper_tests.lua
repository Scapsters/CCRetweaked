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

        return nil -- if it returns nothing, then nothing broke
    end)

Tester:addTest(blockTests)
Tester:runTests()