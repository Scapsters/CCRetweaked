---@module 'constants'
require('constants')

---@class (exact) Limiter
---@field public add function
---@field private _loop function
---@field private _functions function[]
Limiter = {}

Limiter._functions = {}

--- The most important part of the whole program.
--- All programs contain yields at "action points",
--- functions that require "real movements" such as moving forward a block.
--- This goes through each stage of a world tick, and lets each
--- program step forward "1 tick"
---@param self Limiter
Limiter._loop = function(self) 
    for _, func in self._functions do
        coroutine.resume(func)
    end
end

---@param func function
Limiter.add = function(func)
    Limiter._loop[#Limiter._loop+1] = func
end