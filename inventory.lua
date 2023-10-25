require("stack")

INVENTORY_SIZE = 16

Inventory = {
    new = function(self)
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
    end,

    getSelectedSlot = function(self) return self._selectedSlot end,
    _getStacks = function(self) return self._stacks end,

    select = function(self, slot) self._selectedSlot = (slot - 1) % INVENTORY_SIZE + 1 end,

    getSelectedStack = function(self) return self:_getStacks()[self:getSelectedSlot()] end,

    _setStack = function(self, slot, stack) self._stacks[slot] = stack end,

    pickUp = function(self, stack)
        local targetID = stack:getId()
        local number = stack:getNumber()

        local stacks = self:_getStacks()
        for index, slot in pairs(stacks) do
            if slot:getNumber() == 0 then
                -- Empty slot. Dump it in the first slot and return 0
                self:_setStack(index, Stack:new(nil, nil, stack)) -- Dereference stack
                return number
            end
            -- If the slot is of the same type, add as many as you can, continue
            local id = slot:getId()
            if id == targetID then
                number = slot:addItem(number)
            end
        end

        local itemsTaken = stack:getNumber() - number
        return itemsTaken
    end,

    takeItem = function(self, amount)
        local stack = self:_getSelectedStack()
        return stack:takeItem(amount)
    end
}