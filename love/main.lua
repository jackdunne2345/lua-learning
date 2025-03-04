require("npc/npc")
require("screen/screen")
require("mouse controlls/drag_move")
require("world/world_manager")

-- Initialize the world manager with the screen dimensions
local worldManager = WorldManager.new(SCREEN_WIDTH, SCREEN_HEIGHT, 4)

-- Create NPCs and add them to the world manager
local npcOne = worldManager:addNPC(NPC.new(50, 50, "NPC 1"))
local npcTwo = worldManager:addNPC(NPC.new(80, 80, "NPC 2"))
local npcThree = worldManager:addNPC(NPC.new(20, 70, "NPC 3"))
local npcFour = worldManager:addNPC(NPC.new(10, 20, "NPC 4"))
local npcFive = worldManager:addNPC(NPC.new(20, 40, "NPC 5"))
local npcSix = worldManager:addNPC(NPC.new(5, 30, "NPC 6"))

-- Global mouse position variables
MOUSE_X = 0
MOUSE_Y = 0

function love.load()
    -- Enable debug visualization of the quad tree (optional)
    worldManager.debug = true
end

function love.update(dt)
  
    worldManager:update(dt)
end

function love.mousepressed(x, y, button)

    
    -- Example of using the quad tree to find NPCs near the mouse click
    local nearbyNPCs = worldManager:findNPCsInRadius(x, y,200)
    
    -- Print the names of nearby NPCs
    if #nearbyNPCs > 0 then
        print("Nearby NPCs:")
        for _, npc in ipairs(nearbyNPCs) do
            print("- " .. npc.name)
        end
    end
end

function love.keypressed(key)
    -- Toggle quad tree visualization with the 'q' key
    if key == "q" then
        worldManager:toggleDebug()
    end
    
    -- Add a new NPC at a random position with the 'n' key
    if key == "n" then
        local x = math.random(50, 750)
        local y = math.random(50, 550)
        worldManager:addNPC(NPC.new(x, y, "NPC " .. (#worldManager.npcs + 1)))
    end
end

function love.draw()
    -- Let the world manager handle drawing NPCs and the quad tree
    worldManager:draw()
end
