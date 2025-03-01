NPC = {}
NPC.__index = NPC

function NPC:new(x, y)
    local obj = {
        x = x,
        y = y,
        angle = 0, -- Initial rotation angle
        speed = math.rad(90) -- Rotation speed in degrees per second
    }
    setmetatable(obj, NPC)
    return obj
end

function NPC:update(dt)
    self.angle = self.angle + self.speed * dt
end

function NPC:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.angle)
    love.graphics.rectangle("line", -10, -10, 20, 20) -- Draws a rotating square
    love.graphics.pop()
end
