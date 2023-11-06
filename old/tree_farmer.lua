---@diagnostic disable: undefined-global, unused-function


-- Sapling layout
-- ######################
-- #                    #
-- # S SS SS SS SS SS S #
-- # S SS SS SS SS SS S #
-- # STSS SS SS SS SS S #
-- #                    #
-- ###C##################
-- The turtle goes on T, facing up
-- This would have an
-- NUMBER_ROWS of 6
-- ROW_LENGTH of 3
-- Chest is on C as high as CHESTS_HEIGHT

NUMBER_ROWS = 4 -- Number of Rows
ROW_LENGTH = 7 -- Row Length
CHESTS_HEIGHT = 3 -- Chest Height (1 is sitting on the ground)
RELATIVE_DIRECTION = 1 -- Relative Direction
FUEL_THRESHOLD = 1000 -- Fuel Threshold
NAME_LOGS = {
  [1] = "minecraft:oak_log"
  } -- Logs, not ordered
NAME_SAPLINGS = {
  [1] = "minecraft:oak_sapling"
  } -- Saplings, not ordered
NAME_FUELS = {
  [1] = "minecraft:oak_log",
  [2] = "minecraft:stick"
  } -- Fuels, ordered

function Main()
  if NUMBER_ROWS % 2 ~= 0
    then error("NUMBER_ROWS must be divisble by 2")
  end
  while true do
    HandleStorage()
    HandleFuel()
    Patrol()
  end
end

-- Only empty inventory if
-- Every slot is non-empty
function HandleStorage()
  local inventory = GetInventory()
  for i= 1, 16 do
    if inventory[i] == nil then
      return
    end
  end
  EmptyStorage()
end

-- Will empty storage, saving
-- 1 stack of saplings
function EmptyStorage()
  turtle.turnLeft()
  turtle.turnLeft()
  MoveForward()

  for i= 1, CHESTS_HEIGHT do MoveUp() end

  local prev = turtle.getSelectedSlot()

  local isSaplingStackSaved = false
  for i= 1, 16 do
    turtle.select(i)
    local data = turtle.getItemDetail()
    if not IsIn(data.name, NAME_SAPLINGS) or isSaplingStackSaved then
      turtle.drop()
    else
      isSaplingStackSaved = true
    end
  end

  turtle.select(prev)

  for i= 1, CHESTS_HEIGHT do MoveDown() end

  turtle.turnLeft()
  turtle.turnLeft()
  MoveForward()
end

function MoveForward()
    turtle.dig()
    turtle.suck()
    EnsureForward()
end

function MoveBackward()
    turtle.turnLeft()
    turtle.turnLeft()
    MoveForward()
    turtle.turnLeft()
    turtle.turnLeft()
end

function MoveUp()
    turtle.digUp()
    turtle.suckUp()
    EnsureUp()
end

function MoveDown()
    turtle.digDown()
    turtle.suckDown()
    EnsureDown()
end

function EnsureForward()
  local success = turtle.forward()
  while not success do
    turtle.dig()
    success = turtle.forward()
  end
end

function EnsureUp()
  local success = turtle.up()
  while not success do
    turtle.digup()
    success = turtle.up()
  end
end

function EnsureDown()
  local success = turtle.down()
  while not success do
    turtle.digDown()
    success = turtle.down()
  end
end

function HandleFuel()
  local prev = turtle.getSelectedSlot()

  if turtle.getFuelLevel() < FUEL_THRESHOLD then
    turtle.select(FindItem(NAME_FUELS, "ordered"))
    turtle.refuel()
  end

  turtle.select(prev)
end

function Patrol()
  for row= 1, NUMBER_ROWS do
    for _= 1, ROW_LENGTH do
      CheckForTrees()
      MoveForward()
    end
    if row < NUMBER_ROWS
      then StepRow()
    end
  end
  ResetRow()
end

function CheckForTrees()
  turtle.turnLeft()
  turtle.suck()

  CheckForTree()

  turtle.turnRight()
  turtle.suck()
  turtle.turnRight()
  turtle.suck()

  CheckForTree()

  turtle.turnLeft()
  turtle.suck()
end

function CheckForTree()
  local success, data = turtle.inspect()
  if IsIn(data.name, NAME_LOGS)
    then ChopTree()
  end
end

-- Won't break leaves
-- Can only chop normal trees
function ChopTree()
  MoveForward()

  local height = 0

  local blockNameAbove = turtle.inspectUp().data.name
  while IsIn(blockNameAbove, NAME_LOGS) do
    MoveUp()
    height = height + 1
  end

  for _=1, height do
    MoveDown()
  end

  MoveBackward()

  local prev = turtle.getSelectedSlot()
  if turtle.select(FindItem(NAME_SAPLINGS)) then
    turtle.place()
    turtle.select(prev)
    return true
  end
  return false
end

function StepRow()
  Turn(RELATIVE_DIRECTION)

  for _= 1, 3 do MoveForward() end

  Turn(RELATIVE_DIRECTION)

  RELATIVE_DIRECTION = RELATIVE_DIRECTION * -1

  MoveForward()
end

function Turn(dir)
  if dir == 1
    then turtle.turnRight()
    else turtle.turnLeft()
  end
end

function ResetRow()
  turtle.turnRight()
  for _= 1, ((NUMBER_ROWS / 2) * 6) - 3 do
    MoveForward()
  end
  turtle.turnRight()
  MoveForward()
  RELATIVE_DIRECTION = 1 --Reset
end

-- Find the first occurance
-- of an item(s) in inventory
-- and return the first index
function FindItem(names)
  local inventory = GetInventory()

  for i= 1, 16 do
    if isIn(names, inventory[j]) then
      print("match found")
      return j
    end
  end
end

function GetInventory()
  local inventory = {}
  for i= 1, 16 do
    local data = turtle.getItemDetail(i)
    if data then
      inventory[i] = data.name
    end
  end
  return inventory
end

function IsIn(target, list)
  if list == nil then return false end

  for i= 1, GetLength(list) do
    if target == list[i] then
      return i
    end
  end
  return false
end

function GetLength(list)
  if list == nil then return 0 end
  if type(list) ~= "table" then return 1 end

  local index = 0
  repeat
    index = index + 1
  until not list[index]
  return index - 1
end