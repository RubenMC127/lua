local function addTableValues(t1, t2)
    return t1.num + t2.num
end

-- some metamethods we can use are:
-- __add
-- __sub
-- __mul = *
-- __div = /
-- __mod = %
-- __pow = ^
-- __concat = ..
-- __len = #
-- __eq = ==
-- __lt = <
-- __le = <=
-- ...
local metatable = {
    __add = addTableValues,
    __sub = function(t1, t2)
        return t1.num - t2.num
    end
}

local t1 = {num = 10}
-- override de add and sub operators for tbl1
setmetatable(t1, metatable) 

local t2 = {num = 20}

local ans = t1 + t2
print(ans)


local vector = function(x, y)
    return {
        x = x,
        y = y,
    }
end

local function vadd(v1,v2)
    return {
        x = v1.x + v2.x,
        y = v1.y + v2.y
    }
end

local function vsub(v1,v2)
    return {
        x = v1.x - v2.x,
        y = v1.y - v2.y
    }
end

local function vdotprod(v1,v2)
    return {
        v1.x*v2.x + v1.y*v2.y
    }
end

local v1 = {x=10,y=5}
local v2 = {x=3,y=2}

setmetatable(v1,{
    __add = vadd,
    __sub = vsub,
    __mul = vdotprod
})

print("v1.x = " .. v1.x .. ", v1.y = " .. v1.y)
print("v2.x = " .. v2.x .. ", v2.y = " .. v2.y)
local ans = v1+v2
print("v1+v2 = {x = " .. ans.x .. ", y = " .. ans.y .. "}")
ans = v1-v2
print("v1-v2 = {x = " .. ans.x .. ", y = " .. ans.y .. "}")
ans = v1*v2
print("v1*v2 = " .. ans[1])
