require("stack")

Inventory = {
    new = function(self)
        local inventory = {
            _stacks = {n = 16},
            _selectedSlot = 1
        }
        setmetatable(inventory, {__index = self}) -- the object looks to Inventory
        return inventory
    end,

    getSelectedSlot = function(self) return self._selectedSlot end,
    _getStacks = function(self) return self._stacks end,

    _getSelectedStack = function(self) return self:_getStacks()[self:getSelectedSlot()] end,

    getSelectedStackID = function(self) return self:_getSelectedStack():getId() end,

    pickup = function(self, stack)
        local targetID = stack:getId()
        local number = stack:getNumber()

        local stacks = self:_getStacks()
        for index, stack in stacks do
            local id = stack:getId()
            if id == targetID then
        end
    end,

    takeItem = function(self, amount)
        local stack = self:_getSelectedStack()
        return stack:takeItem(amount)
    end
}