function euclidean_distance(p1, p2)
    return math.floor(math.sqrt(math.pow(p2.x - p1.x, 2) + math.pow(p2.y - p1.y, 2)))
end

function random_outside_field(field_percentaje)
    local outside_value = 0.5
    while outside_value> 0.2 and outside_value < 0.8 do
        outside_value = math.random()
    end
    return outside_value
end

function vector_add(v1,v2)
    return {x=v1.x+v2.x, y=v1.y+v2.y}
end

function vector_sub(v1,v2)
    return {x=v1.x-v2.x, y=v1.y-v2.y}
end

function table_length(t)
    local length = 0
    for _ in pairs(t) do 
        length = length + 1
    end
    return length
end

function check_collision(object1, object2)
    maxx1 = object1.x + object1.w
    minx1 = object1.x - object1.w
    maxy1 = object1.y + object1.h
    miny1 = object1.y - object1.h
    maxx2 = object2.x + object2.w
    minx2 = object2.x - object2.w
    maxy2 = object2.y + object2.h
    miny2 = object2.y - object2.h

    return (object1.x >= minx2 and object1.x <= maxx2 and
           object1.y >= miny2 and object1.y <= maxy2) or
           (object2.x >= minx1 and object2.x <= maxx1 and
           object2.y >= miny1 and object2.y <= maxy1)
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

function move_player(dt)
    update_ship_theta(dt)
    update_player_acceleration()
    update_player_speed(dt)
    update_player_position(dt)
end
    
function move_bullets(dt)
    for i, bullet in ipairs(bullets) do
        if bullet.distance_traveled > BULLET_MAX_DISTANCE then
            table.remove(bullets, i)
        else
            position = {x = bullet.x + bullet.vx * dt, y = bullet.y + bullet.vy * dt}
            distance_traveled = bullet.distance_traveled + euclidean_distance(position, {x=bullet.x,y=bullet.y})
            position = adjust_position_to_boundaries(position)
            bullets[i] = {x = position.x, y = position.y,
                          vx = bullet.vx, vy = bullet.vy, distance_traveled = distance_traveled}
            -- GAME TOO HARD LOL, REMOVED SELFSHOOT
            --if check_collision({x = position.x, y = position.y, w = 4, h = 4}, {x = player.x, y = player.y, w = 12, h = 12}) then
            --     love.event.quit()
            --end
            for i, asteroid in ipairs(asteroids) do
                if check_collision({x = position.x, y = position.y, w = 4, h = 4}, {x = asteroid.x, y = asteroid.y, w = asteroid.cx, h = asteroid.cy}) then
                    table.remove(asteroids,i)
                end
            end
        end
    end
end

function calculate_bullet_origin_right_cannon()
        -- MCU with offset for RIGHT CANNON, which needs vertical and horizontal offset
        -- formulas: 
        -- x = x + (r/2)*cos(Θ) + r*sin(Θ)*(1.5-cos(Θ)^2)
        -- y = y + (r/2)*sin(Θ) - r*cos(Θ)*(1.5-sin(Θ)^2)
    return {x = player.x + 12*math.cos(player.ship_facing_theta) + (24*math.sin(player.ship_facing_theta))*(1.5-math.pow(math.cos(player.ship_facing_theta),2)),
            y = player.y + 12*math.sin(player.ship_facing_theta) - (24*math.cos(player.ship_facing_theta))*(1.5-math.pow(math.sin(player.ship_facing_theta),2))}
end
function calculate_bullet_origin_left_cannon()
    -- MCU with offset for LEFT CANNON, which needs vertical and horizontal offset
    -- formulas: 
    -- x = x + (r/2)*cos(Θ) - r*sin(Θ)*(1.5-cos(Θ)^2)
    -- y = y + (r/2)*sin(Θ) + r*cos(Θ)*(1.5-sin(Θ)^2)
    return {x = player.x + 12*math.cos(player.ship_facing_theta) - (24*math.sin(player.ship_facing_theta))*(1.5-math.pow(math.cos(player.ship_facing_theta),2)),
            y = player.y + 12*math.sin(player.ship_facing_theta) + (24*math.cos(player.ship_facing_theta))*(1.5-math.pow(math.sin(player.ship_facing_theta),2))}
end

function create_right_bullet()
    local right_cannon= calculate_bullet_origin_right_cannon()
    return {
        x = right_cannon.x, y = right_cannon.y,
        vx = BULLET_SPEED * math.cos(player.ship_facing_theta),
        vy = BULLET_SPEED * math.sin(player.ship_facing_theta),
        distance_traveled = 0
    }
end

function create_left_bullet()
    local left_cannon = calculate_bullet_origin_left_cannon()
    return {
        x = left_cannon.x, y= left_cannon.y,
        vx = BULLET_SPEED * math.cos(player.ship_facing_theta),
        vy = BULLET_SPEED * math.sin(player.ship_facing_theta),
        distance_traveled = 0
    }
end

function love.load()
    -- setting random seed
    math.randomseed(os.time())

    SHIP_ACCELERATION = 1000
    SHIP_DECELERATION= -1000 
    SHIP_CENTER_OFFSET = {x=24,y=24}
    SHIP_SCALE = 2
    BULLET_SPEED = 2000
    BULLET_MAX_DISTANCE = 1500
    shot_turn = "left"

    ASTEROID_MAX_SPEED = 300
    ASTEROID_CENTER_OFFSET = {x = 32, y = 32}
    NUMBER_OF_ASTEROIDS = 10

    asteroid_sprites = {
        love.graphics.newImage('sprites/asteroid_0_small.png'),
        love.graphics.newImage('sprites/asteroid_0_big.png'),
    }

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

    bullets = {} 
    asteroids = {} 

    player = {} 
    player.x = 400
    player.y = 200
    player.cx = SHIP_CENTER_OFFSET.x
    player.cy = SHIP_CENTER_OFFSET.y
    player.speed = {x=0,y=0}
    player.acceleration = {x=0,y=0}
    player.sprite = love.graphics.newImage('sprites/ship_0.png')
    player.ship_facing_theta = 0
    player.rotation_speed = 5
end

function love.draw()
    love.graphics.draw(background[1], 0, 0)
    love.graphics.draw(player.sprite, player.x, player.y, player.ship_facing_theta, SHIP_SCALE, SHIP_SCALE, player.cx, player.cy)
    for k, bullet in pairs(bullets) do
        love.graphics.setColor(255,255,255)
        love.graphics.circle("fill", bullet.x, bullet.y, 4)
    end

    for k, asteroid in ipairs(asteroids) do
        love.graphics.draw(asteroid.sprite, asteroid.x, asteroid.y, asteroid.theta, asteroid.sx, asteroid.sy, asteroid.cx, asteroid.cy)
    end
end

function love.keypressed(key, u)
    --Debug
    if key == "space" then --set to whatever key you want to use
        if shot_turn == "left" then
            local left_bullet = create_left_bullet()
            table.insert(bullets, left_bullet)
            shot_turn = "right"
        else
            local right_bullet = create_right_bullet()
            table.insert(bullets, right_bullet)
            shot_turn = "left"
        end
    end
end

function move_asteroids(dt)
    if table_length(asteroids) < NUMBER_OF_ASTEROIDS then
        table.insert(asteroids,{
            sprite = asteroid_sprites[1], 
            x = window.width*random_outside_field(), y = window.height*random_outside_field(),
            vx = ASTEROID_MAX_SPEED*math.random(40,100)/100, vy = ASTEROID_MAX_SPEED*math.random(70,100)/100,
            theta = 0,
            sx = 2,
            sy = 2,
            cx = ASTEROID_CENTER_OFFSET.x,
            cy = ASTEROID_CENTER_OFFSET.y
        })
    end

    for i, asteroid in ipairs(asteroids) do
        position = {x = asteroid.x + asteroid.vx * dt, y = asteroid.y + asteroid.vy * dt}
        position = adjust_position_to_boundaries(position)
        asteroids[i] = {
            sprite = asteroid_sprites[1], 
            x = position.x, y = position.y,
            vx = asteroid.vx, vy = asteroid.vy,
            theta = asteroid.theta,
            sx = asteroid.sx,
            sy = asteroid.sy,
            cx = asteroid.cx,
            cy = asteroid.cy
        }
        if check_collision({x = position.x, y = position.y, w = asteroid.cx, h = asteroid.cy}, {x = player.x, y = player.y, w = player.cx, h = player.cy}) then
            love.event.quit()
        end
    end
end

function love.update(dt)
    move_player(dt)
    move_bullets(dt)
    move_asteroids(dt)
end
