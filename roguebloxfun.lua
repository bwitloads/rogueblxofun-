local DataModel = dx9.GetDatamodel()
local Workspace = dx9.FindFirstChild(DataModel, "Workspace")
if not Workspace then
    print("Workspace not found")
    return
end

local Debris = dx9.FindFirstChild(Workspace, "Debris")
if not Debris then
    print("Debris not found")
    return
end

local SpawnedItems = dx9.FindFirstChild(Debris, "SpawnedItems")
if not SpawnedItems then
    print("SpawnedItems not found")
    return
end

local Config = {
    defaultColor = {255, 255, 255}, -- white
    alertColor = {255, 0, 0},       -- red
}

local alertScrolls = {
    "scroll of gate",
    "scroll of zimzap",
    "scroll of conatum",
    "scroll of pondus ultima",
    "scroll of iudicium",
    "scroll of hearth"
}

local function isTargetItem(name)
    local lowerName = name:lower()
    
    if lowerName:find("scroll") then
        for _, scroll in pairs(alertScrolls) do
            if lowerName:find(scroll) then
                return true
            end
        end
    end

    return lowerName:find("life crystal") or lowerName:find("moonshine relic")
end

local function getColor(name)
    local lowerName = name:lower()
    if lowerName:find("life crystal") or lowerName:find("moonshine relic") then
        return Config.alertColor
    end
    for _, scroll in pairs(alertScrolls) do
        if lowerName:find(scroll) then
            return Config.alertColor
        end
    end
    return Config.defaultColor
end

local function drawESP()
    for _, obj in next, dx9.GetChildren(SpawnedItems) do
        local name = dx9.GetName(obj)
        if isTargetItem(name) then
            local pos = dx9.GetPosition(obj)
            if pos then
                local screenPos = dx9.WorldToScreen({ pos.x, pos.y, pos.z })
                if screenPos then
                    local color = getColor(name)
                    dx9.DrawString({ screenPos.x, screenPos.y }, color, "[" .. name .. "]")
                end
            end
        end
    end
end

while true do
    drawESP()
    dx9.Sleep(100) -- 0.1 seconds
end
