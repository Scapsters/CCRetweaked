local function count(start, duration)
        for i=start, start + duration - 1 do
                print(i)
        end
end

count(1, 5)
count(6, 5)
print()

local function yieldCount(start, duration)
        for i=start, start + duration - 1 do
                print(i)
                coroutine.yield()
        end
end

local function createCountRoutine(start, duration)
        return coroutine.create(function()
                yieldCount(start, duration)
        end)
end

local function isPrime(n)
        for i=2, n-1 do
                if n % i == 0 then return false end
        end
        print(n.." is prime")
end

local function yieldIsPrime(n)
        for i=2, n-1 do
                if n % i == 0 then return end
                coroutine.yield()
        end
        print(n.." is prime")
end

local function createPrimeRoutine(n)
        return coroutine.create(function()
                yieldIsPrime(n)
        end)
end

local countRoutine1 = createCountRoutine(1, 5)
local countRoutine2 = createCountRoutine(6, 5)
print()

for i=0, 5 do
        coroutine.resume(countRoutine1)
        coroutine.resume(countRoutine2)
end



for i=1, 1000 do
        isPrime(i)
end

-- The overhead of routine-switching makes this slower than normal.
-- The important thing is the order.
local primeRoutines = {}
for i=1, 10 do
        primeRoutines[i] = createPrimeRoutine(i)
end

for i=1, 10 do
        for i,v in pairs(primeRoutines) do
                coroutine.resume(v)
        end
end

x, y, z = 0, 0, 0

local function move()
        coroutine.yield("`move` is waiting for next tick..")
        x = x + 1
end

local turtleRoutine = coroutine.create(function()
        print(x)
        for i=1, 3 do move() print(x) end
end)

while coroutine.status(turtleRoutine) ~= "dead" do
        local nextTime = os.time() + 1

        print(coroutine.resume(turtleRoutine))

        repeat until os.time() == nextTime
        print(x)
end
