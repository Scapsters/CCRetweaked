---@module 'stack'
require("stack")

INVENTORY_SIZE = 16

---@class Inventory
---@field public new function
---@field public getSelectedSlot function
---@field public select function
---@field public getSelectedStack function
---@field public pickUp function
---@field public moveItem function
---@field private _setStack function
---@field private _stacks Stack[]
---@field private _selectedSlot integer
Inventory = {}

---@param self Inventory
---@return Inventory
Inventory.new = function(self)
    local stacks = {}
    for i=1,INVENTORY_SIZE do
        stacks[i] = Stack:new()
    end
    local inventory = {
        _stacks = stacks,
        _selectedSlot = 1
    }
    setmetatable(inventory, {
        __index = self,
        __tostring = self.__tostring
    }) -- the object looks to Inventory
    return inventory
end

--- The slot that the inventory will "use" items from
---@param self Inventory
---@return integer
Inventory.getSelectedSlot = function(self) return self._selectedSlot end

--- Set the selected slot. Wraps around if you go too high
---@param self Inventory
---@param slot integer
Inventory.select = function(self, slot) self._selectedSlot = (slot - 1) % INVENTORY_SIZE + 1 end

--TODO: Make this return a copy instead of the reference
--- Get the stack at the selected slot 
---@param self Inventory
---@return Stack
Inventory.getSelectedStack = function(self) return self._stacks[self:getSelectedSlot()] end

---@param self Inventory
---@param slot integer
---@param stack Stack
Inventory._setStack = function(self, slot, stack) self._stacks[slot] = stack end

--- Attempts to put a stack into an inventory
--- Side effects include affecting the number in stack, the stacks in Inventory
---@param self Inventory
---@param stack Stack
Inventory.pickUp = function(self, stack)
    local targetID = stack:getId()
    local number = stack:getNumber() -- The size of the pool of items we want to get rid of

    if number == 0 then return end

    -- Go through each slot once, looking for empty or same-type stacks
    for index, slot in pairs(self._stacks) do
        if slot:getNumber() == 0 then
            self:_setStack(index, Stack:new(nil, nil, stack)) -- Copy the given stack into the slot
            stack:takeItem(number) -- Empty the original stack and return early
            return
        end
        -- If the slot is of the same type, add as many as you can, continue
        if slot:getId() == targetID then
            local leftovers = slot:addItem(number)  -- remove as many items as possible, then update things
            local amountTaken = number - leftovers
            stack:takeItem(amountTaken)
            number = leftovers
        end
    end
end

--- Attempts to take items from the selected stack and put them into the provided stack
--- Side effects include affecting the number in toStack, the stacks in Inventory
---@param self Inventory
---@param toStack Stack
---@param amount integer
Inventory.moveItem = function(self, toStack, amount)
    local fromStack = self:getSelectedStack()
    local itemsTaken = fromStack:takeItem(amount)
    local leftoverItems = toStack:addItem(itemsTaken)
    fromStack:addItem(leftoverItems)
end

---@param self Inventory
---@return string
Inventory.toString = function(self)
    return self:__tostring()
end

---@param self Inventory
---@return string
Inventory.__tostring = function(self)
    local result = ""
    for i, stack in pairs(self._stacks) do
        result = result..stack:toString().."  "
        if i % 4 == 0 then result = result.."\n" end -- Skip a line every 4 items
    end
    return result
end

local inventory = Inventory:new()

local stack = Stack:new(Block:new("wumpus"), 48)
local stack2 = Stack:new(Block:new("wumpus"), 48)

inventory:pickUp(stack, 64)
inventory:pickUp(stack2, 64)
inventory:pickUp(stack2, 64)

print(inventory)