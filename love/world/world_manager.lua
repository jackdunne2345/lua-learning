-- World Manager to handle the quad tree and NPCs
local QuadTree = require("world/quadtree")
WorldManager = {}
WorldManager.__index = WorldManager

-- Create a new world manager
--- @param width: width of the world
--- @param height: height of the world
--- @param quadCapacity: maximum number of NPCs per quad before subdivision
function WorldManager.new(width, height, quadCapacity)
    local world = {
        width = width or 800,
        height = height or 600,
        npcs = {},
        quadTree = nil,
        quadCapacity = quadCapacity or 4,
        debug = false,
        clickedNpc = nil
    }
    
    -- Initialize the quad tree with the world boundaries
    world.quadTree = QuadTree.new({
        x = 0,
        y = 0,
        width = world.width,
        height = world.height
    }, world.quadCapacity)
    
    return setmetatable(world, WorldManager)
end

function WorldManager:initNPC(npc)
    print("Initializing NPC: " .. tostring(npc.name or "unknown"))
    table.insert(self.npcs, npc)
    self.quadTree:insert(npc)
end

-- Add an NPC to the world
function WorldManager:addNPC(npc)
    print("Adding NPC: " .. tostring(npc.id or "unknown"))
    self.quadTree:insert(npc)
    return npc
end

-- Update all NPCs in the world
function WorldManager:update(dt)
    for _, npc in ipairs(self.npcs) do
        if npc.update then
            npc:update(dt)
        end
    end
end


function WorldManager:draw()
    -- Draw all NPCs
    for _, npc in ipairs(self.npcs) do
        if npc.draw then
            npc:draw()
        end
    end
    
    -- Draw the quad tree if debug mode is enabled
    if self.debug then
        self.quadTree:draw()
    end
end

function WorldManager:findNPCsInRegion(x, y, width, height)
    local range = {
        x = x,
        y = y,
        width = width,
        height = height
    }
    
    return self.quadTree:query(range)
end

-- Find all NPCs within a radius of a point
function WorldManager:findNPCsInRadius(x, y, radius)
    -- First query a square that contains the circle
    local npcsInSquare = self:findNPCsInRegion(
        x - radius, 
        y - radius, 
        radius * 2, 
        radius * 2
    )
    
    -- Then filter to only those within the radius
    local npcsInRadius = {}
    for _, npc in ipairs(npcsInSquare) do
        local dx = npc.x - x
        local dy = npc.y - y
        local distSquared = dx * dx + dy * dy
        
        if distSquared <= radius * radius then
            table.insert(npcsInRadius, npc)
        end
    end
    
    return npcsInRadius
end

-- Toggle debug visualization
function WorldManager:toggleDebug()
    self.debug = not self.debug
end

-- Reset the world
function WorldManager:reset()
    self.npcs = {}
    self.quadTree:clear()
    
    -- Reinitialize the quad tree
    self.quadTree = QuadTree.new({
        x = 0,
        y = 0,
        width = self.width,
        height = self.height
    }, self.quadCapacity)
end

return WorldManager 