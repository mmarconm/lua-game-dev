-- assets = require('assets')

-- Setup function
-- global varibles
function love.load()
    -- Table passed here to be unpacked on love.draw
    maps = {100, 100, 200, 100}

    -- Button config
    button = {}
    button.x = 200
    button.y = 200
    button.size = 50

    score = 0
    timer = 10
    myFont = love.graphics.newFont(40)
    gameState = 1  -- set to 1, means that we are in main menu and not playing
end

function love.update(dt)
    -- dt = delta time
    if gameState == 2 then
        if timer > 0 then
            timer = timer - dt
        else
            timer = 0
        end
    end
end

function love.draw()
    -- Button Config
    if gameState == 2 then
        love.graphics.setColor(255, 0, 0)
        love.graphics.circle('fill', button.x, button.y, button.size)
    end
    -- Set timer display
    -- love.graphics.setColor(255, 0, 255)
    -- love.graphics.setFont(myFont)
    -- love.graphics.print(score)
    showDisplay({100, 250, 0}, math.ceil(timer), {50, 0})

    -- Set score Display
    showDisplay({255, 0, 255}, score, {0, 0})
    -- love.graphics.setColor(255, 255, 255)
    -- love.graphics.setFont(myFont)
    -- love.graphics.print(score, 100, 0)
end

function love.mousepressed(x, y, btn, istouch)
    if btn == 1 and gameState == 2 then
        if distanceBetween(button.x, button.y, love.mouse.getX(), love.mouse.getY()) < button.size then
            score = score + 1
            button.x = math.random(button.size, love.graphics.getWidth() - button.size)
            button.y = math.random(button.size, love.graphics.getHeight() - button.size)
        end
    end
    -- Start the game if the player click anywhere on the screen
    if gameState == 1 then
        gameState = 2
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt(((y2 - y1)^2) + ((x2 - x1)^2))
end

function showDisplay(rgbColor, ctx, position)
    love.graphics.setColor(unpack(rgbColor))
    love.graphics.setFont(myFont)
    love.graphics.print(ctx, unpack(position))
end