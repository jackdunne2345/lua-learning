require("npc/helpers/inital_position")
---@class NPC
---@field name string The name of the NPC
---@field x number The x position
---@field y number The y position
---@field clicked boolean Whether the NPC is currently clicked
---@field angle number The rotation angle
---@field speed number Movement speed
---@field width number Width of the NPC
---@field height number Height of the NPC
---@field lastX number Previous x position
---@field lastY number Previous y position
---@field quad QuadTree The quad that currently contains this NPCs
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
        lastY = initY,
        moveSpeed = 100,
        quad=nil
    }, NPC)
end

function NPC:update(dt)
    if(self.x >self.quad.boundary.x+self.quad.boundary.width or self.x < self.quad.boundary.x or self.y > self.quad.boundary.y+self.quad.boundary.height or self.y < self.quad.boundary.y) then
        self.quad:removeNPC(self)
        self.quad=nil
        WORLD_MANAGER:addNPC(self)
    end
end

function NPC:draw()
    love.graphics.push()

    if(self.clicked) then
        love.graphics.print(self.name, self.x-30, self.y-30) 
    end
    love.graphics.translate(self.x, self.y)
    love.graphics.rectangle("line", -10, -10, 20, 20) 
    love.graphics.pop()
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


-- Check if this NPC contains a point
function NPC:contains(x, y)
    local bounds = self:getBounds()
    return x >= bounds.x and x < bounds.x + bounds.width and
           y >= bounds.y and y < bounds.y + bounds.height
end
