

Controller={}
Controller.__index=Controller
function Controller.new()
    return setmetatable({},Controller)
end