function love.load()
    player = {} 
    player.x = 400
    player.y = 200
    player.speed = 250
    player.sprite = love.graphics.newImage('sprites/ship.png')
    player.rotation = 0
    player.rotation_speed = 5
    background = {
        love.graphics.newImage('sprites/background_0.png'),
        love.graphics.newImage('sprites/background_1.png')
    }
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        player.rotation = player.rotation + player.rotation_speed*dt 
    end

    if love.keyboard.isDown("left") then
        player.rotation = player.rotation - player.rotation_speed*dt 
    end

    if love.keyboard.isDown("up") then
        player.x = player.x + math.cos(player.rotation) * player.speed * dt
        player.y = player.y + math.sin(player.rotation) * player.speed * dt
    end
    
    if love.keyboard.isDown("down") then
        player.x = player.x - math.cos(player.rotation) * player.speed * dt
        player.y = player.y - math.sin(player.rotation) * player.speed * dt
    end
end

function love.draw()
    love.graphics.draw(background[1], 0, 0)
    love.graphics.draw(player.sprite, player.x, player.y, player.rotation, 0.5, 0.5, 60, 78)
end

function love.keypressed(key, u)
--Debug
    if key == "rctrl" then --set to whatever key you want to use
        debug.debug()
    end
end
