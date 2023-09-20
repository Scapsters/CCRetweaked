Turtle = {
    --------------
    -- Position --
    --------------
    _xPos = 0,
    _yPos = 0,
    _zPos = 0,

    getPosition = function()
        return {
            [1] = Turtle._xPos,
            [2] = Turtle._yPos,
            [3] = Turtle._zPos
        }
    end,

    ---------------
    -- Direction --
    ---------------
    _direction = 0,

    getDirection = function()
        return Turtle._direction % 4
    end,

    turnRight = function()
        Turtle._direction = Turtle._direction + 1
    end,

    turnLeft = function()
        Turtle._direction = Turtle._direction - 1
    end,

    --------------
    -- Movement --
    --------------

    moveForward = function()
        if Turtle._direction == 0 then
            Turtle._zPos = Turtle._zPos + 1
        elseif Turtle._direction == 1 then
            Turtle._xPos = Turtle._xPos + 1
        elseif Turtle._direction == 1 then
            Turtle._zPos = Turtle._zPos - 1
        elseif Turtle._direction == 1 then
            Turtle._xPos = Turtle._xPos - 1
        end

        return Turtle
    end,

    moveUp = function()
    Turtle._yPos = Turtle._yPos + 1

        return Turtle
    end,

    moveDown = function()
        Turtle._yPos = Turtle._yPos - 1

        return Turtle
    end,

    ---------------
    -- Inventory --
    ---------------
    _invSlot1 = nil,
    _invSlot2 = nil,
    _invSlot3 = nil,
    _invSlot4 = nil,
    _selSlot = 1,

    getInventory = function()
        return {
            [1] = Turtle._invSlot1,
            [2] = Turtle._invSlot2,
            [3] = Turtle._invSlot3,
            [4] = Turtle._invSlot4
        }
    end,

    getSelectedSlot = function()
        return Turtle._selSlot
    end

}

print(Turtle.getPosition())

