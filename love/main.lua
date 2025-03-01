require("npc/npc")
require("screen/screen")


local npcs = {}
table.insert(npcs, NPC.new(50, 50, "NPC 1"))
table.insert(npcs, NPC.new(80, 80, "NPC 2"))

function love.mousepressed(x, y, button)
    for i, npc in ipairs(npcs) do
        npc:checkClick(x, y) 
    end
end

function love.draw()
    
    for i, npc in ipairs(npcs) do
        npc:draw()
    end
    
end
