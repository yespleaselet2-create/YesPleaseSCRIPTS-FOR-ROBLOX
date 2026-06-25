-- UGC Aimbot + FOV + ESP (Torso + Prediction + Anti-Kick) - FIXED X
-- Paste as LocalScript in StarterPlayerScripts

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local aimbotEnabled = true
local espEnabled = true
local fov = 200
local smoothness = 7
local targetPart = "HumanoidRootPart"
local predictionFactor = 0.12  -- Ping + movement prediction

local targets = {}
local connections = {}
local isAiming = false

-- GUI
local sg = Instance.new("ScreenGui")
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.62, 0)
frame.Position = UDim2.new(0.02, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0.09,0)
title.BackgroundTransparency = 1
title.Text = "UGC Aimbot + Prediction"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 19
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Close X (FULL DESTROY)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(190, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextSize = 26
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    for _, c in pairs(connections) do 
        if c then c:Disconnect() end 
    end
    for _, data in pairs(targets) do
        if data.box then data.box:Destroy() end
        if data.name then data.name:Destroy() end
    end
    if fovCircle then fovCircle:Destroy() end
    sg:Destroy()
    print("Aimbot fully cleaned and destroyed.")
end)

-- Toggles + Prediction Slider
local aimToggle = Instance.new("TextButton")
aimToggle.Size = UDim2.new(0.9,0,0.07,0)
aimToggle.Position = UDim2.new(0.05,0,0.11,0)
aimToggle.Text = "Aimbot: ON"
aimToggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
aimToggle.TextColor3 = Color3.new(1,1,1)
aimToggle.Parent = frame

aimToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimToggle.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
    aimToggle.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
end)

local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0.9,0,0.07,0)
espToggle.Position = UDim2.new(0.05,0,0.19,0)
espToggle.Text = "ESP: ON"
espToggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
espToggle.TextColor3 = Color3.new(1,1,1)
espToggle.Parent = frame

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    espToggle.BackgroundColor3 = espEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
end)

local predLabel = Instance.new("TextLabel")
predLabel.Size = UDim2.new(0.9,0,0.06,0)
predLabel.Position = UDim2.new(0.05,0,0.28,0)
predLabel.BackgroundTransparency = 1
predLabel.Text = "Prediction: "..predictionFactor
predLabel.TextColor3 = Color3.new(1,1,1)
predLabel.Parent = frame

local predBox = Instance.new("TextBox")
predBox.Size = UDim2.new(0.9,0,0.06,0)
predBox.Position = UDim2.new(0.05,0,0.35,0)
predBox.Text = tostring(predictionFactor)
predBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
predBox.TextColor3 = Color3.new(1,1,1)
predBox.Parent = frame

predBox.FocusLost:Connect(function()
    local val = tonumber(predBox.Text)
    if val then predictionFactor = math.clamp(val, 0, 0.4) end
    predLabel.Text = "Prediction: "..predictionFactor
end)

-- FOV + Smooth (same as before)
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.9,0,0.06,0)
fovLabel.Position = UDim2.new(0.05,0,0.43,0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: "..fov
fovLabel.TextColor3 = Color3.new(1,1,1)
fovLabel.Parent = frame

local fovBox = Instance.new("TextBox")
fovBox.Size = UDim2.new(0.9,0,0.06,0)
fovBox.Position = UDim2.new(0.05,0,0.5,0)
fovBox.Text = tostring(fov)
fovBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
fovBox.TextColor3 = Color3.new(1,1,1)
fovBox.Parent = frame

fovBox.FocusLost:Connect(function()
    local val = tonumber(fovBox.Text)
    if val then fov = math.clamp(val, 30, 800) end
    fovLabel.Text = "FOV: "..fov
end)

local smoothLabel = Instance.new("TextLabel")
smoothLabel.Size = UDim2.new(0.9,0,0.06,0)
smoothLabel.Position = UDim2.new(0.05,0,0.58,0)
smoothLabel.BackgroundTransparency = 1
smoothLabel.Text = "Smoothness: "..smoothness
smoothLabel.TextColor3 = Color3.new(1,1,1)
smoothLabel.Parent = frame

local smoothBox = Instance.new("TextBox")
smoothBox.Size = UDim2.new(0.9,0,0.06,0)
smoothBox.Position = UDim2.new(0.05,0,0.65,0)
smoothBox.Text = tostring(smoothness)
smoothBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
smoothBox.TextColor3 = Color3.new(1,1,1)
smoothBox.Parent = frame

smoothBox.FocusLost:Connect(function()
    local val = tonumber(smoothBox.Text)
    if val then smoothness = math.clamp(val, 1, 30) end
    smoothLabel.Text = "Smoothness: "..smoothness
end)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(255, 50, 255)
fovCircle.Transparency = 0.6
fovCircle.Filled = false
fovCircle.NumSides = 80

-- ESP
local function createESP(plr)
    if plr == player then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(255,0,0)
    box.Transparency = 0.9
    box.Filled = false
    
    local nametag = Drawing.new("Text")
    nametag.Size = 15
    nametag.Color = Color3.fromRGB(255,255,255)
    nametag.Outline = true
    nametag.Center = true
    
    targets[plr] = {box = box, name = nametag}
end

for _, p in ipairs(game.Players:GetPlayers()) do createESP(p) end
game.Players.PlayerAdded:Connect(createESP)

-- Get closest with prediction
local function getClosest()
    local closest = nil
    local minDist = fov
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild(targetPart) and p.Character:FindFirstChild("Humanoid") then
            local root = p.Character[targetPart]
            local hum = p.Character.Humanoid
            
            local predictedPos = root.Position + (root.Velocity * predictionFactor)
            
            local screen, onScreen = camera:WorldToViewportPoint(predictedPos)
            if onScreen then
                local dist = (Vector2.new(screen.X, screen.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = predictedPos
                end
            end
        end
    end
    return closest
end

-- Right Click
uis.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAiming = true
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAiming = false
    end
end)

-- Main Render (slower updates to reduce detection)
connections.render = rs.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
    fovCircle.Radius = fov
    fovCircle.Visible = aimbotEnabled

    if not aimbotEnabled or not isAiming then return end

    local targetPos = getClosest()
    if targetPos then
        local screenPos = camera:WorldToScreenPoint(targetPos)
        local mousePos = Vector2.new(mouse.X, mouse.Y)
        local dir = (Vector2.new(screenPos.X, screenPos.Y) - mousePos) / smoothness
        mousemoverel(dir.X * 0.8, dir.Y * 0.8)  -- softer movement
    end
end)

-- ESP
connections.esp = rs.RenderStepped:Connect(function()
    if not espEnabled then
        for _, data in pairs(targets) do
            data.box.Visible = false
            data.name.Visible = false
        end
        return
    end

    for plr, data in pairs(targets) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            local rootPos, onScreen = camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local head = plr.Character:FindFirstChild("Head")
                local headPos = head and camera:WorldToViewportPoint(head.Position) or rootPos
                local legPos = camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
                
                local height = (headPos.Y - legPos.Y) * 1.35
                local width = height / 2.1
                
                data.box.Size = Vector2.new(width, height)
                data.box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
                data.box.Visible = true
                
                data.name.Text = plr.Name
                data.name.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 20)
                data.name.Visible = true
            else
                data.box.Visible = false
                data.name.Visible = false
            end
        else
            data.box.Visible = false
            data.name.Visible = false
        end
    end
end)

print("UGC Aimbot (Torso + Prediction) loaded. Hold RIGHT CLICK. X fully destroys everything.")