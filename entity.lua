---@module 'Inventory'
require('inventory')

---@class (exact) Entity
---@field public new function
---@field public setProgram function
---@field public getProgram function
---@field public getInventory function
---@field public toString function
---@field private _program Program
---@field private _inventory Inventory
---@field private __tostring function
Entity = {}

---@param self Entity
---@param program Program
---@return Entity
Entity.new = function(self, program, inventory)
    local entity = {
        _program = program,
        _inventory = inventory or Inventory:new()
    }
    entity.setmetatable({
        __index = self,
        __tostring = self.__tostring
    })
    return entity
end

---@param self Entity
---@param program Program
Entity.setProgram = function(self, program)
    self._program = program
end

---@param self Entity
---@return Program
Entity.getProgram = function(self)
    return self._program
end

---@param self Entity
---@return Inventory
Entity.getInventory = function(self)
    return self._inventory
end

Entity.toString = function(self)
    return self:__tostring()
end

Entity.__tostring = function(self)
    return self._inventory:toString().."\n"..self._program:toString()
end
