--[[
Chunk: module.lua
This chunk defines a module.
We return a table of functions and variables.
]]

local module = {} -- This table is local to the module chunk

-- A local variable within module.lua (not accessible outside)
local localModuleVar = "Local to module.lua"

-- Global variable created in module.lua
globalModuleVar = "I am global, defined in module.lua"

-- A function in the module that uses both local and global variables
function module.moduleFunction()
    print("Inside moduleFunction:")
    print("Local variable:", localModuleVar)           -- accessible only inside this chunk
    print("Global variable from module.lua:", globalModuleVar)
    print("Global variable from main.lua:", globalVar) -- accessible because it's global
end

return module
