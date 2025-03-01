
function love.load()
    -- Initialize the NPC at the center of the screen
    local centerX, centerY = 400, 300
end

--this is called every frame. before the draw call
function love.update(dt)

end

--this is called every frame. thats why we push and pop the new frame state each frame
function love.draw()

    love.graphics.push()
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
end