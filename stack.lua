---@module 'block'
require("block")

-- Things contained in inventories and (almost) the things plopped in worlds

MAX_NUMBER = 64

---@class (exact) Stack: Block
---@field public new function
---@field public getNumber function
---@field public getBlock function
---@field public addItem function
---@field public takeItem function
---@field public isEmpty function 
---@field public toString function
---@field private _setNumber function
---@field private _number number
---@field private __tostring function
Stack = {}

---@param self Stack
---@param block Block?
---@param number number?
---@param oldStack Stack?
---@return Stack
Stack.new = function(self, block, number, oldStack)
    if oldStack ~= nil then -- `Block` explains this
        if block == nil then block = oldStack:getBlock() end
        if number == nil then number = oldStack:getNumber() end
    end
    if block == nil then block = Block:new() end

    local stack = Block:new(nil, block) --[[@as Stack]] -- Make a new block or else bad things happen

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
end

---@param self Stack
---@return number
Stack.getNumber = function(self) return self._number end

--- Creates a new block from the information within `self`
---@param self Stack
---@return Block
Stack.getBlock = function(self)
    return Block:new(self:getId())
end

--- Add items to a stack
---@param self Stack
---@param amount integer How many to attempt to add
---@return integer leftover How many items don't get put in the stack
Stack.addItem = function(self, amount)
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
end

--- Take items from a stack
---@param self Stack
---@param amount number How many to attempt to remove
---@return integer amountTaken How many items are removed from the stack
Stack.takeItem = function(self, amount)
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
end

---@param self Stack
---@return boolean
Stack.isEmpty = function(self) return self:getNumber() == 0 end

---@param self Stack
---@return string
Stack.toString = function(self)
    return self:__tostring()
end

---@param self Stack
---@param number integer
Stack._setNumber = function(self, number) self._number = number end

--- This is a metamethod. Do not call
---@param self Stack
---@return string
Stack.__tostring = function(self)
    if DEBUG then
        return "|Stack [_number]: "..self:getNumber().." |Block [_id]: "..self:getId().." [_age]: "..self:getAge().."||"
    else
        return self:getNumber().." ["..self:getId().."]"
    end
end