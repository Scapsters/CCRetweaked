---@module 'constants'
require('constants')

---@class (exact) clock
---@field public cycle function
---@field private _lastCycle integer
---@field private _period integer
---@field private _start integer
---@field private _current function
Clock = {}

Clock._period = CLOCK_PERIOD -- In seconds

Clock._start = os.time()

Clock._lastCycle = -1

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
    -- Calculate the cycle
    local timeElapsed = self._current() - self._start
    local cycle = math.floor(timeElapsed / self._period) + 1
    -- Check if we've fallen behind
    if cycle - self._lastCycle > 1 then
        io.write("A cycle was skipped! "..self._lastCycle.." -> "..cycle)
    end

    self._lastCycle = cycle
    return cycle
end