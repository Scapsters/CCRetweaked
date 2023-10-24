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

local test1 = Test:new(
    "`getId` on `Block` object",
    function()
        local id = "4 big guys"

        local block = Block:new(id)

        local experimental = block:getId()

        return experimental
    end, "4 big guys", "Test1 failed!")

local test2 = Test:new(
    "Whats 9 + 10",
    function()
        return 9 + 10
    end, 21, "this fuckin test failed wat da hell"
)

Tester:addTest(test1)
Tester:addTest(test2)
Tester:runTests()