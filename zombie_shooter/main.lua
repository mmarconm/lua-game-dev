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

    -- Zombies
    zombies = {}
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

    -- Zombie moviment calculation
    for i, z in ipairs(zombies) do
        z.y = z.y + math.sin(zombie_player_angle(z)) * z.speed * dt
        z.x = z.x + math.cos(zombie_player_angle(z)) * z.speed * dt
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

    -- Zombie Player
    -- iterate over the zombies object and create
    for i, z in ipairs(zombies) do
        love.graphics.draw(
            sprites.zombie, 
            z.x, 
            z.y, 
            zombie_player_angle(z),
            nil,
            nil,
            sprites.zombie:getWidth() / 2,
            sprites.zombie:getHeight() / 2
        )
    end

end -- end love.draw


function player_mouse_angle()
    -- return the radian value to the player
    ctx = math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
    return ctx
end

function zombie_player_angle(enemy)
    ctx = math.atan2(player.y - enemy.y, player.x - enemy.x)
    return ctx
end

-- Create a new zombie and add to zombies object
function spawnZombie()
    -- create a singular zombie
    zombie = {}
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = math.random(0, love.graphics.getHeight())
    zombie.speed = 100

    table.insert(zombies, zombie)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" then
        spawnZombie()
    end
end