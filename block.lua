---@module 'constants'
require("constants")

---@class (exact) Block Smallest unit, holds type and age
---@field public new function
---@field public getId function
---@field public getAge function
---@field public resetAge function
---@field public toString function
---@field public tick function
---@field private _id string
---@field private _age number
---@field private _setAge function
---@field private __tostring function
Block = {}

---@param self Block
---@param id string?
---@param oldBlock Block?
---@return Block
Block.new = function(self, id, oldBlock)
    if oldBlock ~= nil then -- If a block is being provided, copy it onto the nil properties
        if id == nil then id = oldBlock:getId() end -- Don't overwrite the given arguments
    end

    local block = {
        _id = id or nil,
        _age = 0 -- Always reset this, when an item is dropped, or enters an inventory, its age should be reset
    }
    setmetatable(block, {
        __index = self,
        __tostring = self.__tostring,
        __concat = self.__tostring
    })
    return block
end


---@param self Block
---@return string
Block.getId = function(self) return self._id or "" end

---@param self Block
---@return number
Block.getAge = function(self) return self._age or 0 end

--- Set `_age` to 0
---@param self Block
Block.resetAge = function(self) self:_setAge(0) end

---@param self Block
---@param age number
Block._setAge = function(self, age) self._age = age end

--- Increase `_age` by 1
---@param self Block
Block.tick = function(self)
    self:_setAge(self:getAge() + 1)
end

---@param self Block
---@return string
Block.toString = function(self)
    return self:__tostring()
end

--- This is a metafunction, do not call this
---@param self Block
---@return string
Block.__tostring = function(self)
    if DEBUG then
        return "|Block [_id]: "..self:getId().." [_age]: "..self:getAge().."|"
    else
        return "["..self:getId().."]"
    end
end