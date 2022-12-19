local function vector_magnitude(v)
    return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2))
end

local function vector_add(v1,v2)
    return {x=v1.x+v2.x, y=v1.y+v2.y}
end

local function vector_sub(v1,v2)
    return {x=v1.x-v2.x, y=v1.y-v2.y}
end

function love.load()
    player = {} 
    player.x = 400
    player.y = 200
    player.speed = 0--250
    player.acceleration = 0
    player.sprite = love.graphics.newImage('sprites/ship.png')
    player.ship_facing_theta = 0
    player.ship_forward_vector = {x=0,y=0}

    player.rotation_speed = 5
    background = {
        love.graphics.newImage('sprites/background_0.png'),
        love.graphics.newImage('sprites/background_1.png')
    }
    window = {
        width = 800,
        height = 600
    }
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        player.ship_facing_theta = player.ship_facing_theta + player.rotation_speed*dt 
    end

    if love.keyboard.isDown("left") then
        player.ship_facing_theta = player.ship_facing_theta - player.rotation_speed*dt 
    end

    if love.keyboard.isDown("up") then
        -- update acceleration
        if player.acceleration < 3 then
            player.acceleration = player.acceleration + 1
        end
        -- recalculate forward vector
        if player.acceleration >= 0 then
            player.ship_forward_vector = vector_add(player.ship_forward_vector,{x=math.cos(player.ship_facing_theta), y=math.sin(player.ship_facing_theta)})
        end
    elseif love.keyboard.isDown("down") then
        -- update acceleration
        if player.acceleration > - 1 then
            player.acceleration = player.acceleration - 0.5
        end
        -- recalculate forward vector
        player.ship_forward_vector = vector_sub(player.ship_forward_vector,{x=-math.cos(player.ship_facing_theta), y=-math.sin(player.ship_facing_theta)})
    else
        player.acceleration = 0
    end
    

    -- Adding maximum speed
    if player.speed >=-2  and player.speed <= 4 then
        player.speed = player.speed + player.acceleration*dt
    elseif player.speed > 0 then
        player.speed = 4
    else
        player.speed = -2
    end

    -- Always update ship position
    --local new_x = player.x + math.cos(player.ship_forward_vector) * player.speed * dt
    local new_x = player.x + player.ship_forward_vector.x * player.speed * dt -- falta ajustar la velocidad al eje x
    if new_x > window.width then
        new_x = new_x - window.width
    elseif new_x < 0 then
        new_x = window.width + new_x
    end
    player.x = new_x

    --local new_y = player.y + math.sin(player.ship_forward_vector) * player.speed * dt
    local new_y = player.y + player.ship_forward_vector.y * player.speed * dt -- falta ajustar la velocidad al eje y
    if new_y > window.height then
        new_y = new_y - window.height
    elseif new_y < 0 then
        new_y = window.height + new_y
    end
    player.y = new_y
end

function love.draw()
    love.graphics.draw(background[1], 0, 0)
    love.graphics.draw(player.sprite, player.x, player.y, player.ship_facing_theta, 0.5, 0.5, 60, 78)
end

function love.keypressed(key, u)
--Debug
    if key == "rctrl" then --set to whatever key you want to use
        debug.debug()
    end
end
