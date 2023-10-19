require("block")

-- Things contained in inventories and (almost) the things plopped in worlds

Stack = {
    new = function(self, block, number)
        local stack = block

        setmetatable(stack, {__index = self}) -- the object looks to Stack
        setmetatable(self, {__index = Block}) -- Stack looks to Block (inheritance)
        -- Note: These can be optimzed by removing the table creation and doing
        -- self.__index = self
        -- the second command, setting Stack to look to Block, can likely
        -- be moved outside of the class to avoid overhead upon Stack creation.

        -- Set Stack attributes
        stack._number = number or 0
        return stack
    end,

    getNumber = function(self) return self._number end,
    getBlock = function(self)
        return Block:new(self:getId())
    end,

    _setNumber = function(self, number) self._number = number end,

    takeItem = function(self, amount)
        -- Returns how many of that item was taken
        local number = self:getNumber()
        if amount > number then
            -- If too many items are taken
            self:_setNumber(0)
            return number
        else
            self:_setNumber(number - amount)
            return amount
        end
    end,

    isEmpty = function(self) return self:getNumber() == 0 end
}