function Turtle:new (o)
    o = o or {
        _xPos = 0,
        _yPos = 0,
        _zPos = 0,

        _direction = 0,

        _inventory = {
            [1] = nil,
            [2] = nil,
            [3] = nil,
            [4] = nil,
            n = 4
        },
        _selSlot = 1,

        _world = World:new()
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

Turtle = {
    --------------
    -- Position --
    --------------

    getPosition = function(self)
        return {
            [1] = self._xPos,
            [2] = self._yPos,
            [3] = self._zPos
        }
    end,

    ---------------
    -- Direction --
    ---------------

    getDirection = function(self)
        return self._direction % 1
    end,

    turnRight = function(self)
        self._direction = self._direction + 1
    end,

    turnLeft = function(self)
        self._direction = self._direction - 1
    end,

    --------------
    -- Movement --
    --------------

    moveForward = function(self)
        if self._direction == 0 then
            self._zPos = self._zPos + 1
        elseif self._direction == 1 then
            self._xPos = self._xPos + 1
        elseif self._direction == 2 then
            self._zPos = self._zPos - 1
        elseif self._direction == 4 then
            self._xPos = self._xPos - 1
        end

        return self
    end,

    moveUp = function(self)
    self._yPos = self._yPos + 1

        return self
    end,

    moveDown = function(self)
        self._yPos = self._yPos - 1

        return self
    end,

    move = function(self)
        self.moveForward()
    end,

    ---------------
    -- Inventory --
    ---------------

    getInventory = function(self)
        return self._inventory
    end,

    getSelectedSlot = function(self)
        return self._selSlot
    end,

    getSelectedItem = function(self)
        return self._inventory[self._selSlot]
    end,

    setSlot = function(self, slot, item)
        -- Make sure slot is within bounds
        if slot > 4 or slot < 1 then
            print("Invalid slot: "..slot.." is outside the range [1, 4]. Returning...")
            return self
        end

        -- Make sure the item is an item
        if item == nil then
            print("Item is nil. Returning...")
            return
        elseif item.name == nil then
            print("Item has no name. Returning...")
            return
        end

        self._inventory[slot] = item
    end,

    pickup = function(self, item)
        local inventory = self._inventory
        for i= 1, inventory.n do
            if inventory[i] == nil then
                inventory[i] = item
                return self
            end
        end

        print("Couldn't fit "..item.name..". Turtle was full. Returning...")
        return self
    end

}

local turtle = Turtle:new()
local turtleTwo = Turtle:new()
turtleTwo:moveUp()
print(turtle:getPosition()[2])
print(turtleTwo:getPosition()[2])