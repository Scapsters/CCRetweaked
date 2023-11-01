---@module 'limiter'
require('limiter')

local function getIntInput()
    io.write("How many loops?")
    return io.read("n")
end

for _=1,getIntInput() do
    Limiter:_loop()
end