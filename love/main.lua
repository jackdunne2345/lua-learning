require("npc/npc")
require("screen/screen")

require("world/world_manager")
local Controller = require("controlls/keyboard_controlls")


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
 WORLD_MANAGER = WorldManager.new(SCREEN_WIDTH, SCREEN_HEIGHT, 4)

-- Create NPCs and add them to the world manager

local npcOne = WORLD_MANAGER:initNPC(NPC.new(50, 50, "NPC 1"))
local npcTwo = WORLD_MANAGER:initNPC(NPC.new(80, 80, "NPC 2"))
local npcThree = WORLD_MANAGER:initNPC(NPC.new(20, 70, "NPC 3"))
local npcFour = WORLD_MANAGER:initNPC(NPC.new(10, 20, "NPC 4"))
local npcFive = WORLD_MANAGER:initNPC(NPC.new(20, 40, "NPC 5"))
local npcSix = WORLD_MANAGER:initNPC(NPC.new(20, 30, "NPC 6"))



-- Create a single controller instance
local controller = Controller.new()

function love.load()
    -- Enable debug visualization of the quad tree (optional)
    WORLD_MANAGER.debug = true
end

function love.update(dt)
    controller:update(dt)
    WORLD_MANAGER:update(dt)
end

function love.mousepressed(x, y)
    WORLD_MANAGER.quadTree:findNPCAtPosition(x,y)
end

function love.keypressed(key)
    -- Toggle quad tree visualization with the 'q' key
    if key == "q" then
        WORLD_MANAGER:toggleDebug()
    end
end

function love.draw()
    -- Let the world manager handle drawing NPCs and the quad tree
    WORLD_MANAGER:draw()
end
