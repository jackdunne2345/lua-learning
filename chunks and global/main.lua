--[[
Chunk: main.lua
This is the main entry point of the application.
Any code here is part of the main chunk.
]]

-- Global variable defined in main.lua
globalVar = "I am global, defined in main.lua"

-- Load configuration (config.lua becomes its own chunk)
require("config") -- This file may add its own globals.

-- Load the module (module.lua becomes its own chunk)
local myModule = require("module")

-- Using a global variable set in config.lua
print("Config says:", globalConfigVar) -- globalConfigVar defined in config.lua

-- Call a function from the module
myModule.moduleFunction()
