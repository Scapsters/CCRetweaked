---@module 'constants'
require('constants')

---@class (exact) clock
---@field public cycle function
---@field private _period integer
---@field private _start integer
---@field private _current function
Clock = {}

Clock._period = 1000 -- In seconds

Clock._start = os.time()

---@return integer
Clock._current = function()
    return os.time()
end

-- TODO: figure out what happens when a cycle is skipped

--- Gets the current cycle of the clock. 
--- If a cycle was skipped, it will print a warning
---@param self clock
---@return integer cycle
Clock.cycle = function(self)
    local timeElapsed = self._current() - self._start
    return math.floor(timeElapsed / self._period) + 1
end