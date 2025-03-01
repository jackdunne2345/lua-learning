require("npc/helpers/inital_position")

NPC = {}
NPC.__index = NPC

function NPC.new(x, y, name)
  local initX,initY=INITIAL_POSITION(x,y)
   return setmetatable({
        name=name or "NPC",
        angle = 0,
        x=initX,
        y=initY,
        speed = math.rad(90),
        clicked=false
    }, NPC)
end

function NPC:update(dt)
    self.angle = self.angle + self.speed * dt
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
