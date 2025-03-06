-- QuadTree implementation for efficient spatial partitioning
-- Used to store and query NPCs based on their positions

QuadTree = {}
QuadTree.__index = QuadTree

-- Create a new QuadTree node
--- @param boundary: table with x, y, width, height defining the region
-- @param capacity: maximum number of objects before subdivision
function QuadTree.new(boundary, capacity, name)
    local qt = {
        boundary = boundary,
        capacity = capacity or 4,
        npcs = {},
        divided = false,
        northwest = nil,
        northeast = nil,
        southwest = nil,
        southeast = nil,
        name=name or nil
    }
    return setmetatable(qt, QuadTree)
end

-- Check if a point is within this quad's boundary
function QuadTree:contains(x, y)
    return x >= self.boundary.x and
           x < self.boundary.x + self.boundary.width and
           y >= self.boundary.y and
           y < self.boundary.y + self.boundary.height
end

-- Subdivide this quad into four child quads
function QuadTree:subdivide()
    local x = self.boundary.x
    local y = self.boundary.y
    local w = self.boundary.width / 2
    local h = self.boundary.height / 2

    -- Create four children
    self.northwest = QuadTree.new({x = x, y = y, width = w, height = h}, self.capacity,"northwest")
    self.northeast = QuadTree.new({x = x + w, y = y, width = w, height = h}, self.capacity,"northeast")
    self.southwest = QuadTree.new({x = x, y = y + h, width = w, height = h}, self.capacity,"southwest")
    self.southeast = QuadTree.new({x = x + w, y = y + h, width = w, height = h}, self.capacity,"southeast")
    
    -- Mark as divided
    self.divided = true
    
    -- Redistribute existing NPCs to children
    for _, npc in ipairs(self.npcs) do
        self:insertToChildren(npc)
    end
    
    -- Clear this node's NPCs since they've been redistributed
    self.npcs = {}
end

-- Helper function to insert an NPC into the appropriate child node
function QuadTree:insertToChildren(npc)
    if self.northwest:contains(npc.x, npc.y) then
        self.northwest:insert(npc)
    elseif self.northeast:contains(npc.x, npc.y) then
        self.northeast:insert(npc)
    elseif self.southwest:contains(npc.x, npc.y) then
        self.southwest:insert(npc)
    elseif self.southeast:contains(npc.x, npc.y) then
        self.southeast:insert(npc)
    end
end

-- Insert an NPC into the quad tree
function QuadTree:insert(npc)
    -- If this point is not within boundary, don't insert
    if not self:contains(npc.x, npc.y) then
        return false
    end
    
    -- If there's space in this quad and it's not divided, add here
    if #self.npcs < self.capacity then
        table.insert(self.npcs, npc)
        npc.quad = self
        print("npc inserted into quadtree: " .. tostring(npc.id or "unknown") .. 
              " at position (" .. npc.x .. "," .. npc.y .. 
              "), divided: " .. tostring(self.divided) .. 
              ", name: " .. tostring(self.name))
        return true
    end
    
    -- Otherwise, subdivide if needed and add to children
    if not self.divided then
        self:subdivide()
    end

   return self:insertToChildren(npc)
end

-- Query the quad tree for all NPCs within a region
-- @param range: table with x, y, width, height defining the query region
-- @param found: table to store found NPCs (passed by reference)
function QuadTree:query(range, found)
    found = found or {}
    
    -- If range doesn't intersect this quad, return empty
    if not self:intersects(range) then
        return found
    end
    
    -- If this quad is divided, check children first
    if self.divided then
        -- Check if range completely contains this quad
        if self:rangeContainsQuad(range) then
            -- If range contains this quad entirely, add all NPCs without individual checks
            for _, npc in ipairs(self.npcs) do
                table.insert(found, npc)
            end
        else
            -- Otherwise, recursively check children
            self.northwest:query(range, found)
            self.northeast:query(range, found)
            self.southwest:query(range, found)
            self.southeast:query(range, found)
        end
    else
        -- If not divided, check NPCs in this quad
        for _, npc in ipairs(self.npcs) do
            if self:pointInRange(npc.x, npc.y, range) then
                table.insert(found, npc)
                break;
            end
        end
    end
    
    return found
end

-- Check if a point is within a range
function QuadTree:pointInRange(x, y, range)
    return x >= range.x and
           x < range.x + range.width and
           y >= range.y and
           y < range.y + range.height
end

-- Check if this quad's boundary intersects with a range
function QuadTree:intersects(range)
    return not (range.x > self.boundary.x + self.boundary.width or
                range.x + range.width < self.boundary.x or
                range.y > self.boundary.y + self.boundary.height or
                range.y + range.height < self.boundary.y)
end

-- Clear the quad tree
function QuadTree:clear()
    self.npcs = {}
    self.divided = false
    self.northwest = nil
    self.northeast = nil
    self.southwest = nil
    self.southeast = nil
end

-- Update an NPC's position in the quad tree
function QuadTree:updateNPC(npc, oldX, oldY)
    -- If the NPC hasn't moved outside its current quad, no need to update
    if self:contains(npc.x, npc.y) and self:contains(oldX, oldY) and not self.divided then
        return true
    end
    
    -- Remove from current position and reinsert
    self:removeNPC(npc, oldX, oldY)
    WORLD_MANAGER:addNPC(npc)
    
end

-- Remove an NPC from the quad tree
function QuadTree:removeNPC(npc)
    for i, storedNPC in ipairs(self.npcs) do
        if storedNPC == npc then
            table.remove(self.npcs, i)
            print("removed npc from quadtree")
            return true
        end
    end
    return false
end

-- Debug function to draw the quad tree structure
function QuadTree:draw()
    -- Draw this quad's boundary
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", self.boundary.x, self.boundary.y, 
                           self.boundary.width, self.boundary.height)
    
    -- Draw children if divided
    if self.divided then
        self.northwest:draw()
        self.northeast:draw()
        self.southwest:draw()
        self.southeast:draw()
    end
    
    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end

-- Add this helper method to check if a range completely contains this quad
function QuadTree:rangeContainsQuad(range)
    -- Assuming range has x, y, width, height properties
    -- And the quad has boundary with x, y, width, height
    return range.x <= self.boundary.x and
           range.y <= self.boundary.y and
           (range.x + range.width) >= (self.boundary.x + self.boundary.width) and
           (range.y + range.height) >= (self.boundary.y + self.boundary.height)
end

-- Find an NPC at the given mouse position and set it as selected
-- @param x, y: coordinates of the mouse click
-- @return: the NPC found at position or nil if none
function QuadTree:findNPCAtPosition(x, y)
    local found={}
    if not self:contains(x, y) then
        print("not valid coordinates")
        return nil
    end
    
    if self.divided then
        local found = nil
        if self.northwest:contains(x, y) then
            return self.northwest:findNPCAtPosition(x, y)
            
        elseif self.northeast:contains(x, y) then
            return self.northeast:findNPCAtPosition(x, y)
        elseif self.southwest:contains(x, y) then
            return self.southwest:findNPCAtPosition(x, y)
        elseif self.southeast:contains(x, y) then
            return self.southeast:findNPCAtPosition(x, y)
        end
        -- need to handle deselecting an npc  when one is selected
        -- also need to handle the edge case when finNPC returns more than one npc 
        if found then
            print("found npc1")
            SET_SELECTED_NPC(found)
        end
    else
     -- Check NPCs in this quad 
        for _, npc in ipairs(self.npcs) do
            -- Assuming NPCs have a contains or intersects method to check if a point is inside them
            if npc.contains and npc:contains(x, y) then
                npc.quad=self
                print("found npc2")
                SET_SELECTED_NPC(npc)
                return npc
            end
        end
    end
    print("no npc found")
    return nil
end


return QuadTree 