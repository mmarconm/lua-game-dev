-- Author: Marcelo marcon
-- @2020
-- Simple 2D shooter game


-- Load
function love.load()
    -- Sets a player objects to config images or sprites
    sprites = {}
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
    sprites.bg = love.graphics.newImage('sprites/background.png')

    -- Game setup
    globalSpeed = 180
    -- Player Object
    player = {}
    player.x = 200
    player.y = 200
    player.width = sprites.player:getWidth() / 2
    player.height = sprites.player:getHeight() / 2
    player.speed = globalSpeed
end

-- Update
function love.update(dt)
    -- STARTING MOVIMENT OF THE PLAYER
    -- Up
    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed * dt
    end
    -- Down
    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed * dt
    end
    -- Left
    if love.keyboard.isDown("a") then
        player.x = player.x + - player.speed * dt
    end
    -- Right
    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
    end

end

-- 45 * (pi / 180)
-- 1.2 * (180 / pi)

-- Draw
function love.draw()
    -- Draw function that gets a drawable, like sprite
    -- and also gets a positon x, y
    love.graphics.draw(sprites.bg, 0, 0)
    -- Player
    love.graphics.draw(
        sprites.player, 
        player.x, 
        player.y, 
        player_mouse_angle(),
        nil, 
        nil, 
        player.width, 
        player.height
    )
end


function player_mouse_angle()
    -- return the radian value to the player
    ctx = math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
    return ctx
end