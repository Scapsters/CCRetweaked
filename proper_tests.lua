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
        for _,test in pairs(self._tests) do
            if _ == "n" then return end -- Dont call `run` on the integer...
            test:run()
        end
    end
}

Test = {
    new = function(self, testFunction, expectedValue, falseOutput)
        local test = {
            _testFunction = testFunction,
            _expectedValue = expectedValue,
            _falseOutput = falseOutput
        }
        setmetatable(test, {__index = self})
        return test
    end,

    run = function(self)
        local result = self._testFunction()
        if result ~= self._expectedValue then
            print(
                self._falseOutput.."\t\t"..
                "Expected result: ".. self._expectedValue.."\t\t"..
                "Actual result: ".. result
            )
        end
    end
}

local test1 = Test:new(
    function()
        return 12
    end, 15, "Test1 failed!")

local test2 = Test:new(
    function()
        return 9 + 10
    end, 21, "this fuckin test failed wat da hell"
)

Tester:addTest(test1)
Tester:addTest(test2)
Tester:runTests()