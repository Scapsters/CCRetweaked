require("constants")

-- Basically useless on its own, holds the management of the
-- most basic properties possible.

Block = {
    new = function(self, id, oldBlock)
        if oldBlock ~= nil then -- If a block is being provided, copy it onto the nil properties
            if id == nil then id = oldBlock:getId() end -- Don't overwrite the given arguments
        end

        local block = {
            _id = id or nil,
            _age = 0 -- Always reset this, when an item is dropped, or enters an inventory, its age should be reset
        }
        setmetatable(block, {
            __index = self,
            __tostring = self.__tostring
        })
        return block
    end,

    getId = function(self) return self._id end,
    getAge = function(self) return self._age end,

    resetAge = function(self) self:_setAge(0) end,

    _setAge = function(self, age) self._age = age end,

    _tick = function(self)
        self:_setAge(self:getAge() + 1)
    end,

    __tostring = function(self)
        if DEBUG then
            return "|Block [_id]: "..self:getId().." [_age]: "..self:getAge().."|"
        else
            return "["..self:getId().."]"
        end
    end
}