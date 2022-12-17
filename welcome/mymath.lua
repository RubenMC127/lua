-- So... A module is a Lua script that returns a table after its execution
mymath = {}

function mymath.add(x, y)
    return x + y
end

function mymath.pow(base, power)
    local result = base
    for i = 2, power, 1 do
        result = result * base
    end
    return result
end

return mymath
