-- TABLES
local x, y, z = 1, 2, 3
local coord = {1, 2, 3}
--print(x);print(y);print(z)
--print(coord)

local lmao = {10, "patata", math.pi, true}
--for i = 1, #lmao do
--    print(lmao[i])
--end

local matrix = {
    {1,2,3},
    {6,8,0},
    {9, 99, 989}
}
--print(matrix[3][3])

local function pow(base, power)
    local result = base
    for i = 2, power, 1 do
        result = result * base
    end
    return result
end
print(string.format("2^16 = %d", pow(2,16)))


-- COROUTINE
local routine_func = function()
    for i = 11, 20 do
        print("(Routine): " .. i) -- .. is the concat operator
        if i == 15 then
            coroutine.yield() -- stops the execution
        end
    end
end    

-- Working with files


-- creates a routine in suspended status 
local routine = coroutine.create(routine_func)
print(coroutine.status(routine))
coroutine.resume(routine)
-- continue coroutine after yield
print(coroutine.status(routine))
coroutine.resume(routine)

-- BASIC STUFF BELOW
-- Lets go!
--print("Hello")

-- Cool, we have math module!
--print("Pi")
--print(math.pi)

--print("Random")
--math.randomseed(os.time())
--print(math.random())
--
--print(math.max(1,2,34,56,6,76,1,1,2,65))
--print(math.min(1,2,34,56,6,76,1,1,2,65))
--
--print(string.format("printf pi: %.2f",math.pi))
--
---- Flow variables
--local age = 20
--local name = "Rubén"
--
---- Flow Control
--if age > 18 then
--    print("You can enter the disco")
--else
--    print("Too young for this place")
--end
--
---- Loops
--for i = 0, 1000, 100 do
--    print(i)
--end
--
--local i = 4
--while i > 0 do
--    print("whateva")
--    i = i - 1
--end
--
---- reads input
--local test = io.read()
---- prints input
--print("test:",test)
--
---- writes to screen and waits for input
--io.write("test:") -- waits for input
--local test2 = io.read()
--
---- just to prove it stored the value
--print("read test:", test2)
