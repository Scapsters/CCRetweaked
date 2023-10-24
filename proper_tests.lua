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
            io.write("\n")
        end
    end
}

Test = {
    new = function(self, testName, testFunction, expectedValue, falseOutput)
        if falseOutput == nil then falseOutput = "Failed" end
        local test = {
            _testName = testName,
            _testFunction = testFunction,
            _expectedValue = expectedValue,
            _falseOutput = falseOutput
        }
        setmetatable(test, {__index = self})
        return test
    end,

    run = function(self)
        io.write("["..self._testName.."] ")
        local result = self._testFunction()
        if result ~= self._expectedValue then
            io.write(
                self._falseOutput.."\t\t"..
                "Expected result: ".. self._expectedValue.."\t\t"..
                "Actual result: ".. result
            )
        else
            io.write("Passed")
        end
    end
}

local blockOne = Test:new(
    "`getId` on `Block` object",
    function()
        local id = "4 big guys"

        local block = Block:new(id)

        local experimental = block:getId()

        return experimental
    end, "4 big guys")

local blockTwo = Test:new(
    "`getAge` on `Block` object",
    function()
        local block = Block:new()

        local experimental = block:getAge()

        return experimental
    end, 0)


local test2 = Test:new(
    "Whats 9 + 10",
    function()
        return 9 + 10
    end, 21, "this fuckin test failed wat da hell"
)

Tester:addTest(blockOne)
Tester:addTest(blockTwo)
Tester:runTests()