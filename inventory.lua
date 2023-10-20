require("stack")

INVENTORY_SIZE = 16

Inventory = {
    new = function(self)
        local stacks = {}
        for i=1,INVENTORY_SIZE do
            stacks[i] = {}
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

    select = function(self, slot) self._selectedSlot = slot % INVENTORY_SIZE end,

    _getSelectedStack = function(self) return self:_getStacks()[self:getSelectedSlot()] end,

    _setStack = function(self, slot, stack) self._stacks[slot] = stack end,

    pickUp = function(self, stack)
        local next = next -- For efficiency
        local targetID = stack:getId()
        local number = stack:getNumber()

        local stacks = self:_getStacks()
        for index, slot in pairs(stacks) do
            if next(slot) == nil then
                -- Empty slot. Dump it in the first slot and return 0
                print("dumping "..number)
                self:_setStack(index, stack)
                return 0
            end
            -- If the slot is of the same type, add as many as you can, continue
            local slotStack = stacks[index]
            local id = slotStack:getId()
            if id == targetID then
                number = slotStack:addItem(number)
            end
        end

        return number -- Return how many items are leftover
    end,

    takeItem = function(self, amount)
        local stack = self:_getSelectedStack()
        return stack:takeItem(amount)
    end
}