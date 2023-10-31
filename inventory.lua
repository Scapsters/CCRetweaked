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
---@field private _getStacks function
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
    setmetatable(inventory, {__index = self}) -- the object looks to Inventory
    return inventory
end

--- The slot that the inventory will "use" items from
---@param self Inventory
---@return integer
Inventory.getSelectedSlot = function(self) return self._selectedSlot end

---@param self Inventory
---@return Stack[]
Inventory._getStacks = function(self) return self._stacks end

--- Set the selected slot. Wraps around if you go too high
---@param self Inventory
---@param slot integer
Inventory.select = function(self, slot) self._selectedSlot = (slot - 1) % INVENTORY_SIZE + 1 end

--TODO: Make this return a copy instead of the reference
--- Get the stack at the selected slot 
---@param self Inventory
---@return Stack
Inventory.getSelectedStack = function(self) return self:_getStacks()[self:getSelectedSlot()] end

---@param self Inventory
---@param slot integer
---@param stack Stack
Inventory._setStack = function(self, slot, stack) self._stacks[slot] = stack end

--- Attempts to put a stack into an inventory
---@param self Inventory
---@param stack any
---@return integer overfill How many items were not returned
Inventory.pickUp = function(self, stack)
    -- Returns how many items were placed into the inventory
    local targetID = stack:getId()
    local number = stack:getNumber()

    local stacks = self:_getStacks()
    for index, slot in pairs(stacks) do
        if slot:getNumber() == 0 then
            -- Empty slot. Dump it in the first slot and return number
            self:_setStack(index, Stack:new(nil, nil, stack)) -- Dereference stack
            stack:takeItem(number) -- Empty the stack
            return number
        end
        -- If the slot is of the same type, add as many as you can, continue
        local id = slot:getId()
        if id == targetID then
            number = stack:takeItem(slot:addItem(number)) -- remove as many items as possible, update number
        end
    end

    return number
end

--- Attempts to take items from the selected stack and put them into the provided stack
--- Side effects include affecting the number in toStack, the stacks in Inventory
---@param self Inventory
---@param toStack Stack
---@param amount integer
---@return integer amount How many items were taken
Inventory.moveItem = function(self, toStack, amount)
    local fromStack = self:getSelectedStack()
    local itemsTaken = fromStack:takeItem(amount)
    local leftoverItems = toStack:addItem(itemsTaken)
    fromStack:addItem(leftoverItems)
    return itemsTaken - leftoverItems
end