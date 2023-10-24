-- Most files will require this class

DEBUG = true
if DEBUG then
    debug.setmetatable(nil, {
        __tostring = function() return "nil" end,
        __concat = function() return "nil" end
    })
end