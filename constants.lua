-- Most files will require this class

CLOCK_PERIOD = 1000; -- in milliseconds (1000 = 1 second)

DEBUG = true
if DEBUG then
    debug.setmetatable(nil, {
        __tostring = function() return "nil" end,
        __concat = function() return "nil" end
    })
end