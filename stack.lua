require("block")

-- Things contained in inventories and (almost) the things plopped in worlds

Stack = {
    getNumber = function(self) return self._number end,

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

function Stack:new(o, id)
    local so = Block:new(nil, id)
    o = so:new(o or {
        _number = 0
    })
    return o
end

local stack = Stack:new(nil, "pizza")
print(stack:getId())