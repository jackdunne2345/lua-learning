Controller = {}
Controller.__index = Controller

function Controller.new()
    return setmetatable({ }, Controller)
end

function Controller:update(dt)
    -- If no NPC is selected, do nothing
    if not SELECTED_NPC then
        return
    end
    
    local dx = 0
    local dy = 0

    -- Horizontal movement
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        dx = dx - 1
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        dx = dx + 1
    end

    -- Vertical movement
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        dy = dy - 1
    end
    if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        dy = dy + 1
    end

    -- Normalize diagonal movement to maintain consistent speed
    if dx ~= 0 and dy ~= 0 then
        dx = dx * 0.707
        dy = dy * 0.707
    end
    local moveSpeed = SELECTED_NPC.moveSpeed or 100 
    -- Apply movement to the selected NPC
    SELECTED_NPC.x = SELECTED_NPC.x + (dx * moveSpeed * dt)
    SELECTED_NPC.y = SELECTED_NPC.y + (dy * moveSpeed * dt)
end

return Controller