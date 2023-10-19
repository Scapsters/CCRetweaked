local worldSize = 8

BlockMap = {

    tick = function(self)
        for x=1, worldSize do
            for y=1, worldSize do
                for z=1, worldSize do
                    self:moveItemsIfOccupied(x, y, z)

                    local block = self:getBlock(x, y, z)
                    block.age = block.age + 1
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
        items[#items + 1] = item
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
        self._blocks[x][y][z] = block
        return prev
    end,

    ------------------
    -- Blocks/Items --
    ------------------

    breakBlock = function(self, x, y, z)
        local formerBlock = self:setBlock(x, y, z, {name = ""})

        -- Don't drop an empty block
        if formerBlock.name then
            self:addItem(x, y, z, formerBlock)
        end

        return formerBlock
    end,

    placeBlock = function(self, x, y, z, block)
        local formerBlock =  self:getBlock(x, y, z)
        if formerBlock.name then -- Air has no name
            return false, "Block already present"
        end

        self:setBlock(x, y, z, block)
        return block
    end

}

function BlockMap:new(o)
    local items = {}
    local blocks = {}

    for x=1, worldSize do
        print("new x")
        items[x] = {}
        blocks[x] = {}

        for y=1, worldSize do
            items[x][y] = {}
            blocks[x][y] = {}

            for z=1, worldSize do
                items[x][y][z] = {n = 0}
                blocks[x][y][z] = {name = ""}
            end
        end
    end


    o = o or {
        _items = items,
        _blocks = blocks,
        _tick = 0
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

local function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

local function printWorld(world)
    for x=1, worldSize do
        for y=1, worldSize do
            for z=1, worldSize do
                local block = string.sub(world[x][y][z].name, 0, 1)
                if block == '' then block = ' ' end
                io.write('['..block..']')
            end
            io.write(' ')
        end
        print()
    end
    print()
end

local function constructSimpleWorld(world)
    -- Bottom to quarter up
    for x=1, worldSize do
        for y=1, worldSize // 4 do
            for z=1, worldSize do
                world:setBlock(x, y, z, {name = "s"})
            end
        end
    end
    -- Quarter up to halfway
    for x=1, worldSize do
        for y=worldSize // 4 + 1, worldSize // 4 * 2 do
            for z=1, worldSize do
                world:setBlock(x, y, z, {name = "dirt"})
            end
        end
    end
    -- Halfway exactly
    for x=1, worldSize do
        for y=worldSize // 4 * 2, worldSize // 4 * 2 do
            for z=1, worldSize do
                world:setBlock(x, y, z, {name = "grass"})
            end
        end
    end
end

local blockMap = BlockMap:new()

print("basic block testing")
print("place grass. result should be the former block, air (empty string)")
print(dump(blockMap:setBlock(1, 1, 1, {name = "grass"})))
print("\nget the block. should be grass")
print(dump(blockMap:getBlock(1, 1, 1)))
print("\nbreak the block. result should be the formal block, grass")
print(dump(blockMap:breakBlock(1, 1, 1)))
print("\nget the block, should be air")
print(dump(blockMap:getBlock(1, 1, 1)))

print("\n\n")
print("print world testing")
for x=1, worldSize do
    blockMap:setBlock(x, 3, 1, {name = "x"})
end
for y=1, worldSize do
    blockMap:setBlock(1, y, 1, {name = "y"})
end
for z=1, worldSize do
    blockMap:setBlock(3, 2, z, {name = "z"})
end
print("\nall blocks: ")
printWorld(blockMap._blocks)

blockMap = BlockMap:new()
constructSimpleWorld(blockMap)
printWorld(blockMap._blocks)
