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

function Stack:new(o, block, number)
    block:resetAge()
    Stack._number = number or 0
    return block:new(Stack)
end

local block = Block:new(nil, "pizza")
local stack = Stack:new(nil, block, 10)
print(stack:getId())
print(stack:getNumber())

local stack2 = Stack:new(nil, block)
print(stack2:getNumber())