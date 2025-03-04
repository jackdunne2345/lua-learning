require("npc/helpers/inital_position")
require("mouse controlls/drag_move")

NPC = {}
NPC.__index = NPC

function NPC.new(x, y, name)
    local initX, initY = INITIAL_POSITION(x, y)
    return setmetatable({
        name = name or "NPC",
        angle = 0,
        x = initX,
        y = initY,
        speed = math.rad(90),
        clicked = false,
        width = 20,
        height = 20,
        lastX = initX,  
        lastY = initY
    }, NPC)
end

function NPC:update(dt)
    self.lastX, self.lastY = self.x, self.y
    
    self.angle = self.angle + self.speed * dt
    
    -- Example of random movement (uncomment if you want NPCs to move)
    -- if math.random() < 0.01 then
    --     self.x = self.x + math.random(-5, 5)
    --     self.y = self.y + math.random(-5, 5)
    -- end
end

function NPC:draw()
    love.graphics.push()
    self:checkClick(MOUSE_X, MOUSE_Y)
    if(self.clicked) then
        love.graphics.print(self.name, self.x-30, self.y-30) 
    end
    love.graphics.translate(self.x, self.y)
    love.graphics.rectangle("line", -10, -10, 20, 20) 
    love.graphics.pop()
end

function NPC:checkClick(mouseX, mouseY)
    local dx = mouseX - self.x
    local dy = mouseY - self.y
    
    -- Check if mouse is within the 20x20 
    if dx >= -10 and dx <= 10 and dy >= -10 and dy <= 10 then
        self.clicked = true
        return true
    else
        self.clicked = false
        return false
    end
end

-- Get the bounds of this NPC (useful for quad tree operations)
function NPC:getBounds()
    return {
        x = self.x - 10,
        y = self.y - 10,
        width = self.width,
        height = self.height
    }
end

-- Check if this NPC intersects with another NPC
function NPC:intersects(other)
    local myBounds = self:getBounds()
    local otherBounds = other:getBounds()
    
    return not (
        myBounds.x + myBounds.width < otherBounds.x or
        myBounds.x > otherBounds.x + otherBounds.width or
        myBounds.y + myBounds.height < otherBounds.y or
        myBounds.y > otherBounds.y + otherBounds.height
    )
end

-- Check if this NPC contains a point
function NPC:contains(x, y)
    local bounds = self:getBounds()
    return x >= bounds.x and x < bounds.x + bounds.width and
           y >= bounds.y and y < bounds.y + bounds.height
end
