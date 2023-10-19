-- Things contained in inventories and (almost) the things plopped in worlds

Stack = {
    getItem = function(self) return self._block end,
    getNumber = function(self) return self._number end,

    _setNumber = function(self, number) self._number = number end,

    takeItem = function(self, amount)
        -- Returns how many of that item was taken
        local number, block = self:getNumber(), self:getItem()
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

function Stack:new(o)
    o = o or {
        _block = nil,
        _number = 0
    }
    o.setmetatable(o, self)
    self.__index = self
    return o
end