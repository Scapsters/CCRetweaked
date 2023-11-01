---@module 'clock'
require('clock')
---@module 'limiter'
require('limiter')
---@module 'constants'
require('constants')

--- A program is a corotutine that needs
--- to call upon the Entity table, as the "action" functions all contain yields
---@class (exact) Program
---@field public new function
Program = {}

Program.new = function(self, func)
    local program = {
        [func] = func
    }

    program.setmetatable({
        __index = self
    })

    return program
end
