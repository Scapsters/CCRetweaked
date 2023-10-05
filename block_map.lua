local worldSize = 100

function BlockMap:new(o)
    local items = {}
    local blocks = {}

    for x=0, worldSize do
        for y=0, worldSize do
            for z=0, worldSize do
                items[x][y][z] = {n = 0}
                blocks[x][y][z] = {name = nil}
            end
        end
    end


    o = o or {
        _items = items,
        _blocks = blocks,
        _tick = 0
    }
end

BlockMap = {

    tick = function(self)
        for x=0, worldSize do
            for y=0, worldSize do
                for z=0, worldSize do
                    self:moveItemsIfOccupied(x, y, z)
                end
            end
        end
    end,

    -----------
    -- Items --
    -----------

    getItems = function(self, x, y, z)
        return self._items[x][y][z]
    end,

    setItems = function(self, x, y, z, items)
        local prev = self._items[x][y][z]
        self._items[x][y][z] = items
        return prev
    end,

    addItem = function(self, x, y, z, item)
        local items = self._items[x][y][z]
        items[items.n + 1] = item
        items.n = items.n + 1
    end,

    pickUpItems = function(self, x, y, z)
        return self:setItems(x, y, z, {})
    end,

    moveItemsIfOccupied = function(self, x, y, z)

        -- If they are out of bounds, then remove them instead
        if y >= worldSize then
            self:setItems(x, y, z, {name = nil})
        end

        local block = self:getBlock(x, y, z)
        if block.name then
            self:setItems(x, y + 1, z, self:pickUpItems(x, y, z))
        end
    end,

    ------------
    -- Blocks --
    ------------

    getBlock = function(self, x, y, z)
        return self._blocks[x][y][z]
    end,

    setBlock = function(self, x, y, z, block)
        local prev = self._blocks[x][y][z]
        self._items[x][y][z] = block
        return prev
    end,

    placeBlock = function(self, x, y, z, block)
        local formerBlock = self:getBlock(x, y, z)
        if formerBlock then
            return false, "Block occupied"
        end

        self:setBlock(x, y, z, block)
    end,

    ------------------
    -- Blocks/Items --
    ------------------

    breakBlock = function(self, x, y, z)
        local formerBlock = self:setBlock(x, y, z, {name = nil})

        -- Don't drop an empty block
        if formerBlock.name then
            self:addItem(x, y, z, formerBlock)
        end
    end
}