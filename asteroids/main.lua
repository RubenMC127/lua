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
    -- this filter setup removes white outline on the sprites
    love.graphics.setDefaultFilter("nearest","nearest")
    background = {
        love.graphics.newImage('sprites/background_0.png'),
        love.graphics.newImage('sprites/background_1.png')
    }

    window = {
        width = 1920,
        height = 1080
    }
    love.window.setMode(window.width, window.height)

    player = {} 
    player.x = 400
    player.y = 200
    player.speed = {x=0,y=0}
    player.acceleration = {x=0,y=0}
    SHIP_ACCELERATION = 1000
    SHIP_DECELERATION= -1000 
    player.sprite = love.graphics.newImage('sprites/ship_0.png')
    player.ship_facing_theta = 0
    player.rotation_speed = 5
end

function update_ship_theta(dt)
    if love.keyboard.isDown("right") then
        player.ship_facing_theta = player.ship_facing_theta + player.rotation_speed*dt 
    end

    if love.keyboard.isDown("left") then
        player.ship_facing_theta = player.ship_facing_theta - player.rotation_speed*dt 
    end
end

function update_player_acceleration()
    player.acceleration = {x=0,y=0}
    -- up overrides it
    if love.keyboard.isDown("up") then
        -- update acceleration
        player.acceleration.x = SHIP_ACCELERATION * math.cos(player.ship_facing_theta)
        player.acceleration.y = SHIP_ACCELERATION * math.sin(player.ship_facing_theta)
    end

    -- down overrides it
    if love.keyboard.isDown("down") then
        player.acceleration.x = SHIP_DECELERATION * math.cos(player.ship_facing_theta)
        player.acceleration.y = SHIP_DECELERATION * math.sin(player.ship_facing_theta)
    end
end

function update_player_speed(dt)
    -- Updating speed if max not reached
    if player.speed.x >= -2000 and player.speed.x <= 4000 then
        player.speed.x = player.speed.x + player.acceleration.x * dt
    end
    if player.speed.y >= -2000 and player.speed.y <= 4000 then
        player.speed.y = player.speed.y + player.acceleration.y * dt
    end
end

function calculate_mrua_position(dt)
    local destination = {x=0,y=0}
    destination.x = player.x + player.speed.x * dt + 0.5*player.acceleration.x*dt*dt -- falta ajustar la velocidad al eje x
    destination.y = player.y + player.speed.y * dt + 0.5*player.acceleration.y*dt*dt -- falta ajustar la velocidad al eje y
    return destination
end

function adjust_position_to_boundaries(destination)
    if destination.x > window.width then
        destination.x = destination.x - window.width
    elseif destination.x < 0 then
        destination.x = window.width + destination.x
    end
    
    if destination.y > window.height then
        destination.y = destination.y - window.height
    elseif destination.y < 0 then
        destination.y = window.height + destination.y
    end
    return destination
end

function update_player_position(dt)
    local destination = calculate_mrua_position(dt)
    destination = adjust_position_to_boundaries(destination)
    player.x = destination.x
    player.y = destination.y
end

function love.update(dt)
    update_ship_theta(dt)
    update_player_acceleration()
    update_player_speed(dt)
    update_player_position(dt)
end

function love.draw()
    love.graphics.draw(background[1], 0, 0)
    love.graphics.draw(player.sprite, player.x, player.y, player.ship_facing_theta, 2, 2, 24, 24)
end

function love.keypressed(key, u)
--Debug
    if key == "rctrl" then --set to whatever key you want to use
        debug.debug()
    end
end
