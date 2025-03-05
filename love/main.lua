require("npc/npc")
require("screen/screen")
require("mouse controlls/drag_move")
require("world/world_manager")


SELECTED_NPC=nil

---Sets the currently selected NPC
---@param npc NPC The NPC instance to select
function SET_SELECTED_NPC(npc)
    if SELECTED_NPC  then
        SELECTED_NPC.clicked=false
    end
    SELECTED_NPC=npc
    npc.clicked=true
end

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

   worldManager.quadTree:findNPCAtPosition(x,y)
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
