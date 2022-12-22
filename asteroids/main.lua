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
    player.speed = {x=0,y=0}--250
    player.acceleration = {x=0,y=0}
    ship_acceleration = 1000
    ship_deceleration = -1000 
    player.sprite = love.graphics.newImage('sprites/ship.png')
    player.ship_facing_theta = 2*math.pi
    --player.ship_forward_vector = {x=0,y=0}

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

    -- default acceleration
    player.acceleration = {x=0,y=0}
    -- up overrides it
    if love.keyboard.isDown("up") then
        -- update acceleration
        player.acceleration.x = ship_acceleration * math.cos(player.ship_facing_theta)
        player.acceleration.y = ship_acceleration * math.sin(player.ship_facing_theta)
    end

    -- down overrides it
    if love.keyboard.isDown("down") then
        player.acceleration.x = ship_deceleration * math.cos(player.ship_facing_theta)
        player.acceleration.y = ship_deceleration * math.sin(player.ship_facing_theta)
    end

    -- Updating speed if max not reached
    --if player.speed >=-2 and player.speed <= 4 then
    --    player.speed = player.speed + player.acceleration * dt
    --end
    player.speed.x = player.speed.x + player.acceleration.x * dt
    player.speed.y = player.speed.y + player.acceleration.y * dt

    -- Always update ship position
    --local new_x = player.x + math.cos(player.ship_forward_vector) * player.speed * dt
    local new_x = player.x + player.speed.x * dt + 0.5*player.acceleration.x*dt*dt -- falta ajustar la velocidad al eje x
    if new_x > window.width then
        new_x = new_x - window.width
    elseif new_x < 0 then
        new_x = window.width + new_x
    end
    player.x = new_x

    --local new_y = player.y + math.sin(player.ship_forward_vector) * player.speed * dt
    local new_y = player.y + player.speed.y * dt + 0.5*player.acceleration.y*dt*dt -- falta ajustar la velocidad al eje y
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
