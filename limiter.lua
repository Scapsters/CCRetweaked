---@module 'constants'
require('constants')

---@class (exact) Limiter
---@field public add function
---@field private _loop function[]
---@field private _shouldContinue function
Limiter = {}

---TODO: Have this not always return true maybe
---@return boolean
Limiter._shouldContinue = function() return true end

Limiter._loop = {
    [1] = Limiter._shouldContinue
}

---@param func function
Limiter.add = function(func)
    Limiter._loop[#Limiter._loop+1] = func
end

local function getIntInput()
    io.write("How many loops?")
    return io.read("n")
end

for _=1,getIntInput() do
    Limiter._loop()
end
