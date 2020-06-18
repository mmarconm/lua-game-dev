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

    bullets = {}
    gameState = 1 -- menu player
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

        -- check if the zombie colides with the player
        if distanceBetween(z.x, z.y, player.x, player.y) < 40 then
            for i, z in ipairs(zombies) do
                zombies[i] = nil
            end
        end
    end

    for i, b in ipairs(bullets) do
        b.x = b.x + math.cos(b.direction) * b.speed * dt
        b.y = b.y + math.sin(b.direction) * b.speed * dt
    end

     -- removing bullet

     for i=#bullets, 1, -1 do
        -- going in reverse order
        -- #bullets get the size of the table
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(bullets, i) -- removing the bullet from the table
        end
     end

     for i, z in ipairs(zombies) do
        for j, b in ipairs(bullets) do
            if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true
                b.dead = true
            end
        end
     end

     -- remove the zombies when the bullet hits
     for i=#zombies, 1, -1 do
        local z = zombies[i]
        if z.dead == true then
            table.remove(zombies, i)
        end
     end
     -- remove the bullet when hits the zombie
     for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets, i)
        end
     end

end -- END OF UPDATE FUNCTION

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

    -- Iterate in bullets
    for i, b in ipairs(bullets) do
        love.graphics.draw(
            sprites.bullet, 
            b.x, 
            b.y,
            nil, -- rotation value
            0.5, -- scale the image
            0.5, -- scale the image
            sprites.bullet:getWidth() / 2,
            sprites.bullet:getHeight() / 2
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
    zombie.x = 0
    zombie.y = 0
    zombie.speed = 100
    zombie.dead = false

    local side = math.random(1, 4)

    if side == 1 then
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    elseif side == 3 then
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    else
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30 
    end

    table.insert(zombies, zombie)
end

-- Create a function to create bullets
function spawnBullet()
    bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 500
    bullet.direction = player_mouse_angle()
    bullet.dead = false

    table.insert(bullets, bullet)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" then
        spawnZombie()
    end
end

-- Action to player shoot
function love.mousepressed(x, y, b, istouch)
    if b == 1 then
        spawnBullet()
    end
end

-- Calculates the distances btw player and the zombie
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt(((y2 - y1)^2) + ((x2 - x1)^2))
end