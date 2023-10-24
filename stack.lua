require("block")

-- Things contained in inventories and (almost) the things plopped in worlds

MAX_NUMBER = 64

Stack = {
    new = function(self, block, number, oldStack)
        if oldStack ~= nil then -- `Block` explains this
            if block == nil then block = oldStack:getBlock() end
            if number == nil then number = oldStack:getNumber() end
        end

        local stack = Block:new(nil, block) -- Make a new block or else bad things happen

        setmetatable(stack, {
            __index = self,
            __tostring = self.__tostring
        }) -- the object looks to Stack
        setmetatable(self, {
            __index = Block,
            __tostring = self.__tostring
        }) -- Stack looks to Block (inheritance)
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

    addItem = function(self, amount)
        -- returns how many items are left over
        local number = self:getNumber()
        if number + amount > MAX_NUMBER then
            -- If there isnt enough room
            self:_setNumber(MAX_NUMBER)
            return (number + amount) - MAX_NUMBER
        else
            self:_setNumber(number + amount)
            return 0
        end
    end,

    takeItem = function(self, amount)
        -- returns how many items leave the stack
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

    isEmpty = function(self) return self:getNumber() == 0 end,

    __tostring = function(self)
        if DEBUG then
            return "|Stack [_number]: "..self:getNumber().." |Block [_id]: "..self:getId().." [_age]: "..self:getAge().."||"
        else
            return self:getNumber().." ["..self:getId().."]"
        end
    end
}