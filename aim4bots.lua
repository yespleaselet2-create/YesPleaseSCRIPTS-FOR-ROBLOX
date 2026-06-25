-- NYX SCRIPTS | FULL LOADER
local UIS = game:GetService("UserInputService")
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

-- SAFE HTTP
local function safeHttp(url)
    if syn and syn.request then
        return syn.request({Url=url,Method="GET"}).Body
    elseif http and http.request then
        return http.request({Url=url,Method="GET"}).Body
    elseif request then
        return request({Url=url,Method="GET"}).Body
    else
        return game:HttpGet(url)
    end
end

-- CAPABILITY CHECK
local function hasDrawing()
    return pcall(function() local d = Drawing.new("Circle") d:Remove() end)
end
local function hasMouseMove()
    return type(mousemoverel) == "function"
end
local function hasHttp()
    local ok = pcall(function() safeHttp("https://google.com") end)
    return ok
end

local drawing = hasDrawing()
local mouseMove = hasMouseMove()
local httpOk = hasHttp()

-- GRADE
local grade, gradeColor, gradeMsg, downloadLink, blocked

if isMobile then
    if drawing and httpOk then
        grade = "S"
        gradeColor = Color3.fromRGB(0,255,100)
        gradeMsg = "?? Clean executor! Loading mobile version..."
        blocked = false
    else
        grade = "F"
        gradeColor = Color3.fromRGB(255,50,50)
        gradeMsg = "bro what executor is this ?? get Delta fr"
        downloadLink = "https://delta-executor.com"
        blocked = true
    end
else
    if drawing and mouseMove and httpOk then
        grade = "S"
        gradeColor = Color3.fromRGB(0,255,100)
        gradeMsg = "?? Perfect executor! Loading..."
        blocked = false
    elseif drawing and httpOk and not mouseMove then
        grade = "C"
        gradeColor = Color3.fromRGB(255,200,0)
        gradeMsg = "Mid executor, aimbot disabled ?? upgrade to Xeno"
        downloadLink = "https://xeno.now"
        blocked = false
    elseif not drawing and httpOk then
        grade = "D"
        gradeColor = Color3.fromRGB(255,120,0)
        gradeMsg = "This executor is cooked ngl ?? get Xeno"
        downloadLink = "https://xeno.now"
        blocked = true
    else
        grade = "F"
        gradeColor = Color3.fromRGB(255,50,50)
        gradeMsg = "BRO ?????? how are you even alive get Xeno NOW"
        downloadLink = "https://xeno.now"
        blocked = true
    end
end

-- EXECUTOR CHECK GUI
local checkGui = Instance.new("ScreenGui")
checkGui.Name = "NYXCheck"
checkGui.ResetOnSpawn = false
pcall(function() checkGui.Parent = game.CoreGui end)
if not checkGui.Parent then checkGui.Parent = player:WaitForChild("PlayerGui") end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,420,0,290)
frame.Position = UDim2.new(0.5,-210,0.5,-145)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.BorderSizePixel = 0
frame.Parent = checkGui
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,14)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,55)
topBar.BackgroundColor3 = Color3.fromRGB(150,0,255)
topBar.BorderSizePixel = 0
topBar.Parent = frame
Instance.new("UICorner",topBar).CornerRadius = UDim.new(0,14)

local topTitle = Instance.new("TextLabel")
topTitle.Size = UDim2.new(1,0,1,0)
topTitle.BackgroundTransparency = 1
topTitle.Text = "?? NYX SCRIPTS | EXECUTOR CHECK"
topTitle.TextColor3 = Color3.new(1,1,1)
topTitle.TextScaled = true
topTitle.Font = Enum.Font.GothamBold
topTitle.Parent = topBar

local gradeBox = Instance.new("TextLabel")
gradeBox.Size = UDim2.new(0,75,0,75)
gradeBox.Position = UDim2.new(0,18,0,68)
gradeBox.BackgroundColor3 = gradeColor
gradeBox.Text = grade
gradeBox.TextColor3 = Color3.new(1,1,1)
gradeBox.TextScaled = true
gradeBox.Font = Enum.Font.GothamBold
gradeBox.Parent = frame
Instance.new("UICorner",gradeBox).CornerRadius = UDim.new(0,10)

local features = {
    {name = "Drawing API", ok = drawing},
    {name = "Mouse Control", ok = isMobile and true or mouseMove},
    {name = "HTTP Requests", ok = httpOk},
}

for i, feat in ipairs(features) do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,260,0,26)
    lbl.Position = UDim2.new(0,110,0,62+(i-1)*30)
    lbl.BackgroundTransparency = 1
    lbl.Text = (feat.ok and "? " or "? ")..feat.name
    lbl.TextColor3 = feat.ok and Color3.fromRGB(0,255,100) or Color3.fromRGB(255,80,80)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
end

local platformLbl = Instance.new("TextLabel")
platformLbl.Size = UDim2.new(0,260,0,26)
platformLbl.Position = UDim2.new(0,110,0,152)
platformLbl.BackgroundTransparency = 1
platformLbl.Text = isMobile and "?? Platform: Mobile" or "?? Platform: PC"
platformLbl.TextColor3 = Color3.fromRGB(180,180,180)
platformLbl.TextScaled = true
platformLbl.Font = Enum.Font.Gotham
platformLbl.TextXAlignment = Enum.TextXAlignment.Left
platformLbl.Parent = frame

local msgLbl = Instance.new("TextLabel")
msgLbl.Size = UDim2.new(0.9,0,0,32)
msgLbl.Position = UDim2.new(0.05,0,0,182)
msgLbl.BackgroundTransparency = 1
msgLbl.Text = gradeMsg
msgLbl.TextColor3 = gradeColor
msgLbl.TextScaled = true
msgLbl.Font = Enum.Font.GothamBold
msgLbl.Parent = frame

if blocked then
    local dlBtn = Instance.new("TextButton")
    dlBtn.Size = UDim2.new(0.85,0,0,42)
    dlBtn.Position = UDim2.new(0.075,0,0,228)
    dlBtn.BackgroundColor3 = Color3.fromRGB(150,0,255)
    dlBtn.Text = isMobile and "?? Get Delta (Free)" or "?? Get Xeno (Free)"
    dlBtn.TextColor3 = Color3.new(1,1,1)
    dlBtn.TextScaled = true
    dlBtn.Font = Enum.Font.GothamBold
    dlBtn.Parent = frame
    Instance.new("UICorner",dlBtn).CornerRadius = UDim.new(0,8)
    dlBtn.MouseButton1Click:Connect(function()
        pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow(downloadLink)
        end)
    end)
else
    if downloadLink then
        local dlBtn = Instance.new("TextButton")
        dlBtn.Size = UDim2.new(0.4,0,0,38)
        dlBtn.Position = UDim2.new(0.05,0,0,232)
        dlBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
        dlBtn.Text = "?? Upgrade Executor"
        dlBtn.TextColor3 = Color3.new(1,1,1)
        dlBtn.TextScaled = true
        dlBtn.Font = Enum.Font.GothamBold
        dlBtn.Parent = frame
        Instance.new("UICorner",dlBtn).CornerRadius = UDim.new(0,8)
        dlBtn.MouseButton1Click:Connect(function()
            pcall(function()
                game:GetService("GuiService"):OpenBrowserWindow(downloadLink)
            end)
        end)
    end

    local contBtn = Instance.new("TextButton")
    contBtn.Size = UDim2.new(downloadLink and 0.4 or 0.85, 0, 0, 38)
    contBtn.Position = UDim2.new(downloadLink and 0.55 or 0.075, 0, 0, 232)
    contBtn.BackgroundColor3 = Color3.fromRGB(150,0,255)
    contBtn.Text = "? Continue"
    contBtn.TextColor3 = Color3.new(1,1,1)
    contBtn.TextScaled = true
    contBtn.Font = Enum.Font.GothamBold
    contBtn.Parent = frame
    Instance.new("UICorner",contBtn).CornerRadius = UDim.new(0,8)

    contBtn.MouseButton1Click:Connect(function()
        checkGui:Destroy()
        LOADKEYSYSTEM()
    end)

    -- Auto continue if S grade
    if grade == "S" then
        task.wait(2)
        if checkGui and checkGui.Parent then
            checkGui:Destroy()
            LOADKEYSYSTEM()
        end
    end
end

-- KEY SYSTEM
function LOADKEYSYSTEM()
    local API_URL = "http://13.215.254.31:28207/validate?key="
    local DISCORD = "https://discord.gg/5jG3FWYjXj"

    pcall(function()
        game:GetService("GuiService"):OpenBrowserWindow(DISCORD)
    end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "NYXKeySystem"
    gui.ResetOnSpawn = false
    pcall(function() gui.Parent = game.CoreGui end)
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

    local kframe = Instance.new("Frame")
    kframe.Size = UDim2.new(0,400,0,255)
    kframe.Position = UDim2.new(0.5,-200,0.5,-127)
    kframe.BackgroundColor3 = Color3.fromRGB(10,10,10)
    kframe.BorderSizePixel = 0
    kframe.Parent = gui
    Instance.new("UICorner",kframe).CornerRadius = UDim.new(0,12)

    local ktitle = Instance.new("TextLabel")
    ktitle.Size = UDim2.new(1,0,0,52)
    ktitle.BackgroundColor3 = Color3.fromRGB(150,0,255)
    ktitle.Text = "?? NYX SCRIPTS | KEY SYSTEM"
    ktitle.TextColor3 = Color3.new(1,1,1)
    ktitle.TextScaled = true
    ktitle.Font = Enum.Font.GothamBold
    ktitle.Parent = kframe
    Instance.new("UICorner",ktitle).CornerRadius = UDim.new(0,12)

    local discBtn = Instance.new("TextButton")
    discBtn.Size = UDim2.new(0.85,0,0,36)
    discBtn.Position = UDim2.new(0.075,0,0,60)
    discBtn.BackgroundColor3 = Color3.fromRGB(88,101,242)
    discBtn.Text = "?? Join Discord to Get Key"
    discBtn.TextColor3 = Color3.new(1,1,1)
    discBtn.TextScaled = true
    discBtn.Font = Enum.Font.GothamBold
    discBtn.Parent = kframe
    Instance.new("UICorner",discBtn).CornerRadius = UDim.new(0,8)
    discBtn.MouseButton1Click:Connect(function()
        pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow(DISCORD)
        end)
    end)

    local kinput = Instance.new("TextBox")
    kinput.Size = UDim2.new(0.85,0,0,40)
    kinput.Position = UDim2.new(0.075,0,0,105)
    kinput.BackgroundColor3 = Color3.fromRGB(25,25,25)
    kinput.Text = ""
    kinput.PlaceholderText = "NYX-XXXXXXXXXXXXXXXX"
    kinput.TextColor3 = Color3.new(1,1,1)
    kinput.TextScaled = true
    kinput.Font = Enum.Font.Code
    kinput.ClearTextOnFocus = false
    kinput.Parent = kframe
    Instance.new("UICorner",kinput).CornerRadius = UDim.new(0,8)

    local kstatus = Instance.new("TextLabel")
    kstatus.Size = UDim2.new(1,0,0,28)
    kstatus.Position = UDim2.new(0,0,0,153)
    kstatus.BackgroundTransparency = 1
    kstatus.Text = "?? Get your key from Discord!"
    kstatus.TextColor3 = Color3.fromRGB(150,150,150)
    kstatus.TextScaled = true
    kstatus.Font = Enum.Font.Gotham
    kstatus.Parent = kframe

    local kbtn = Instance.new("TextButton")
    kbtn.Size = UDim2.new(0.85,0,0,40)
    kbtn.Position = UDim2.new(0.075,0,0,188)
    kbtn.BackgroundColor3 = Color3.fromRGB(150,0,255)
    kbtn.Text = "?? UNLOCK"
    kbtn.TextColor3 = Color3.new(1,1,1)
    kbtn.TextScaled = true
    kbtn.Font = Enum.Font.GothamBold
    kbtn.Parent = kframe
    Instance.new("UICorner",kbtn).CornerRadius = UDim.new(0,8)

    local unlocked = false
    kbtn.MouseButton1Click:Connect(function()
        if unlocked then return end
        local key = kinput.Text
        if key == "" then
            kstatus.Text = "? Enter your key first!"
            kstatus.TextColor3 = Color3.fromRGB(255,80,80)
            return
        end
        kstatus.Text = "? Validating..."
        kstatus.TextColor3 = Color3.fromRGB(255,200,0)

        local ok, result = pcall(safeHttp, API_URL..key)
        if ok and result then
            local dok, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(result)
            end)
            if dok and data and data.valid then
                unlocked = true
                kstatus.Text = "? Valid! Loading " .. (isMobile and "?? mobile" or "?? PC") .. " version..."
                kstatus.TextColor3 = Color3.fromRGB(0,255,100)
                task.wait(1)
                gui:Destroy()
                if isMobile then
                    LOADMOBILE()
                else
                    LOADPC()
                end
            else
                kstatus.Text = "? Invalid key! Join Discord to get one"
                kstatus.TextColor3 = Color3.fromRGB(255,80,80)
                kinput.Text = ""
            end
        else
            kstatus.Text = "? Connection failed!"
            kstatus.TextColor3 = Color3.fromRGB(255,80,80)
        end
    end)
end

-- PC VERSION
function LOADPC()
    local rs = game:GetService("RunService")
    local mouse = player:GetMouse()
    local aimbotEnabled = true
    local espEnabled = true
    local fov = 120
    local smoothness = 18
    local targetPart = "HumanoidRootPart"
    local predictionFactor = 0.08
    local targets = {}
    local connections = {}
    local isAiming = false

    local sg = Instance.new("ScreenGui")
    sg.ResetOnSpawn = false
    pcall(function() sg.Parent = game.CoreGui end)
    if not sg.Parent then sg.Parent = player:WaitForChild("PlayerGui") end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,260,0,310)
    frame.Position = UDim2.new(0.02,0,0.2,0)
    frame.BackgroundColor3 = Color3.fromRGB(12,12,12)
    frame.BorderSizePixel = 0
    frame.Parent = sg
    Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

    -- Draggable
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1,0,0,45)
    topBar.BackgroundColor3 = Color3.fromRGB(150,0,255)
    topBar.BorderSizePixel = 0
    topBar.Parent = frame
    Instance.new("UICorner",topBar).CornerRadius = UDim.new(0,12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-50,1,0)
    title.BackgroundTransparency = 1
    title.Text = "?? NYX | Murder Duels"
    title.TextColor3 = Color3.new(1,1,1)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,36,0,36)
    closeBtn.Position = UDim2.new(1,-41,0,4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = frame
    Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(0,6)

    local function makeToggle(text, yPos, default, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.88,0,0,36)
        btn.Position = UDim2.new(0.06,0,0,yPos)
        btn.BackgroundColor3 = default and Color3.fromRGB(0,160,0) or Color3.fromRGB(160,0,0)
        btn.Text = text .. ": " .. (default and "ON" or "OFF")
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = frame
        Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)
        local state = default
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text .. ": " .. (state and "ON" or "OFF")
            btn.BackgroundColor3 = state and Color3.fromRGB(0,160,0) or Color3.fromRGB(160,0,0)
            callback(state)
        end)
        return btn
    end

    local function makeSlider(labelText, yPos, min, max, default, callback)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.88,0,0,22)
        lbl.Position = UDim2.new(0.06,0,0,yPos)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText..": "..default
        lbl.TextColor3 = Color3.fromRGB(200,200,200)
        lbl.TextScaled = true
        lbl.Font = Enum.Font.Gotham
        lbl.Parent = frame

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.88,0,0,28)
        box.Position = UDim2.new(0.06,0,0,yPos+24)
        box.BackgroundColor3 = Color3.fromRGB(30,30,30)
        box.Text = tostring(default)
        box.TextColor3 = Color3.new(1,1,1)
        box.TextScaled = true
        box.Font = Enum.Font.Code
        box.Parent = frame
        Instance.new("UICorner",box).CornerRadius = UDim.new(0,6)
        box.FocusLost:Connect(function()
            local v = tonumber(box.Text)
            if v then
                v = math.clamp(v,min,max)
                box.Text = tostring(v)
                lbl.Text = labelText..": "..v
                callback(v)
            end
        end)
    end

    makeToggle("Aimbot", 52, true, function(v) aimbotEnabled = v end)
    makeToggle("ESP", 94, true, function(v) espEnabled = v end)
    makeSlider("FOV", 136, 30, 400, fov, function(v) fov = v end)
    makeSlider("Smoothness", 192, 1, 30, smoothness, function(v) smoothness = v end)
    makeSlider("Prediction", 248, 0, 0.4, predictionFactor, function(v) predictionFactor = v end)

    closeBtn.MouseButton1Click:Connect(function()
        for _,c in pairs(connections) do pcall(function() c:Disconnect() end) end
        for _,d in pairs(targets) do
            pcall(function() d.box:Remove() end)
            pcall(function() d.name:Remove() end)
        end
        pcall(function() fovCircle:Remove() end)
        sg:Destroy()
    end)

    local fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1
    fovCircle.Color = Color3.fromRGB(200,0,255)
    fovCircle.Transparency = 0.5
    fovCircle.Filled = false
    fovCircle.NumSides = 80

    local function createESP(plr)
        if plr == player then return end
        local box = Drawing.new("Square")
        box.Thickness = 1
        box.Color = Color3.fromRGB(255,50,50)
        box.Transparency = 0.85
        box.Filled = false
        local nametag = Drawing.new("Text")
        nametag.Size = 13
        nametag.Color = Color3.fromRGB(255,255,255)
        nametag.Outline = true
        nametag.Center = true
        targets[plr] = {box=box, name=nametag}
    end

    for _,p in ipairs(game.Players:GetPlayers()) do createESP(p) end
    game.Players.PlayerAdded:Connect(createESP)
    game.Players.PlayerRemoving:Connect(function(p)
        if targets[p] then
            pcall(function() targets[p].box:Remove() end)
            pcall(function() targets[p].name:Remove() end)
            targets[p] = nil
        end
    end)

    local function getClosest()
        local closest, minDist = nil, fov
        for _,p in ipairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild(targetPart) 
            and p.Character:FindFirstChild("Humanoid") 
            and p.Character.Humanoid.Health > 0 then
                local root = p.Character[targetPart]
                local predicted = root.Position + (root.Velocity * predictionFactor)
                local screen, onScreen = camera:WorldToViewportPoint(predicted)
                if onScreen then
                    local dist = (Vector2.new(screen.X,screen.Y) - Vector2.new(mouse.X,mouse.Y)).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = predicted
                    end
                end
            end
        end
        return closest
    end

    UIS.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end
    end)

    connections.render = game:GetService("RunService").RenderStepped:Connect(function()
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
        fovCircle.Radius = fov
        fovCircle.Visible = aimbotEnabled

        if aimbotEnabled and isAiming then
            local t = getClosest()
            if t then
                local sp = camera:WorldToScreenPoint(t)
                local dir = (Vector2.new(sp.X,sp.Y) - Vector2.new(mouse.X,mouse.Y)) / smoothness
                pcall(function() mousemoverel(dir.X*0.75, dir.Y*0.75) end)
            end
        end

        if espEnabled then
            for plr, data in pairs(targets) do
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local root = plr.Character.HumanoidRootPart
                    local rp, onScreen = camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local head = plr.Character:FindFirstChild("Head")
                        local hp = head and camera:WorldToViewportPoint(head.Position) or rp
                        local lp = camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
                        local h = (hp.Y - lp.Y) * 1.35
                        local w = h / 2.1
                        data.box.Size = Vector2.new(w,h)
                        data.box.Position = Vector2.new(rp.X-w/2, rp.Y-h/2)
                        data.box.Visible = true
                        data.name.Text = plr.Name
                        data.name.Position = Vector2.new(rp.X, rp.Y-h/2-18)
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
        else
            for _,data in pairs(targets) do
                data.box.Visible = false
                data.name.Visible = false
            end
        end
    end)
end

-- MOBILE VERSION
function LOADMOBILE()
    local rs = game:GetService("RunService")
    local aimbotEnabled = true
    local espEnabled = true
    local fov = 150
    local smoothness = 0.12
    local lockedTarget = nil
    local highlights = {}
    local connections = {}

    local sg = Instance.new("ScreenGui")
    sg.ResetOnSpawn = false
    pcall(function() sg.Parent = game.CoreGui end)
    if not sg.Parent then sg.Parent = player:WaitForChild("PlayerGui") end

    -- Compact mobile menu
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,200,0,160)
    frame.Position = UDim2.new(0,10,0.3,0)
    frame.BackgroundColor3 = Color3.fromRGB(12,12,12)
    frame.BorderSizePixel = 0
    frame.Parent = sg
    Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1,0,0,38)
    topBar.BackgroundColor3 = Color3.fromRGB(150,0,255)
    topBar.BorderSizePixel = 0
    topBar.Parent = frame
    Instance.new("UICorner",topBar).CornerRadius = UDim.new(0,12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-40,1,0)
    title.BackgroundTransparency = 1
    title.Text = "?? NYX Mobile"
    title.TextColor3 = Color3.new(1,1,1)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,30,0,30)
    closeBtn.Position = UDim2.new(1,-34,0,4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = frame
    Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(0,6)

    local function makeMobileToggle(text, yPos, default, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.88,0,0,32)
        btn.Position = UDim2.new(0.06,0,0,yPos)
        btn.BackgroundColor3 = default and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
        btn.Text = text..": "..(default and "ON" or "OFF")
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = frame
        Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)
        local state = default
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text..": "..(state and "ON" or "OFF")
            btn.BackgroundColor3 = state and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
            callback(state)
        end)
    end

    makeMobileToggle("Aimbot", 44, true, function(v) aimbotEnabled = v end)
    makeMobileToggle("ESP", 82, true, function(v) espEnabled = v end)

    -- Lock button (replaces right click for mobile)
    local lockBtn = Instance.new("TextButton")
    lockBtn.Size = UDim2.new(0,90,0,90)
    lockBtn.Position = UDim2.new(1,-110,1,-110)
    lockBtn.BackgroundColor3 = Color3.fromRGB(150,0,255)
    lockBtn.Text = "?? LOCK"
    lockBtn.TextColor3 = Color3.new(1,1,1)
    lockBtn.TextScaled = true
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.Parent = sg
    Instance.new("UICorner",lockBtn).CornerRadius = UDim.new(0,45)

    local isLocking = false
    lockBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            isLocking = true
            lockBtn.BackgroundColor3 = Color3.fromRGB(255,0,100)
            lockBtn.Text = "?? ON"
        end
    end)
    lockBtn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            isLocking = false
            lockedTarget = nil
            lockBtn.BackgroundColor3 = Color3.fromRGB(150,0,255)
            lockBtn.Text = "?? LOCK"
        end
    end)

    -- ESP via Highlights (mobile friendly, no Drawing needed)
    local function createHighlight(plr)
        if plr == player then return end
        local function applyHighlight()
            if plr.Character then
                if highlights[plr] then highlights[plr]:Destroy() end
                local h = Instance.new("Highlight")
                h.FillColor = Color3.fromRGB(255,0,0)
                h.FillTransparency = 0.6
                h.OutlineColor = Color3.fromRGB(255,255,255)
                h.OutlineTransparency = 0
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Adornee = plr.Character
                h.Parent = plr.Character
                highlights[plr] = h
            end
        end
        applyHighlight()
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            applyHighlight()
        end)
    end

    for _,p in ipairs(game.Players:GetPlayers()) do createHighlight(p) end
    game.Players.PlayerAdded:Connect(createHighlight)
    game.Players.PlayerRemoving:Connect(function(p)
        if highlights[p] then
            pcall(function() highlights[p]:Destroy() end)
            highlights[p] = nil
        end
    end)

    -- Find closest to screen center (mobile doesn't have mouse)
    local function getClosestToCenter()
        local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
        local closest, minDist = nil, fov
        for _,p in ipairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character 
            and p.Character:FindFirstChild("HumanoidRootPart")
            and p.Character:FindFirstChild("Humanoid")
            and p.Character.Humanoid.Health > 0 then
                local root = p.Character.HumanoidRootPart
                local screen, onScreen = camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local dist = (Vector2.new(screen.X,screen.Y) - center).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = p
                    end
                end
            end
        end
        return closest
    end

    closeBtn.MouseButton1Click:Connect(function()
        for _,c in pairs(connections) do pcall(function() c:Disconnect() end) end
        for _,h in pairs(highlights) do pcall(function() h:Destroy() end) end
        sg:Destroy()
    end)

    -- ESP toggle for highlights
    connections.esp = rs.Heartbeat:Connect(function()
        for plr, h in pairs(highlights) do
            pcall(function()
                h.Enabled = espEnabled
                if lockedTarget and plr == lockedTarget then
                    h.FillColor = Color3.fromRGB(255,200,0)
                    h.OutlineColor = Color3.fromRGB(255,200,0)
                else
                    h.FillColor = Color3.fromRGB(255,0,0)
                    h.OutlineColor = Color3.fromRGB(255,255,255)
                end
            end)
        end
    end)

    -- CFrame aimbot for mobile
    connections.aim = rs.RenderStepped:Connect(function()
        if not aimbotEnabled or not isLocking then return end

        if not lockedTarget or not lockedTarget.Character 
        or not lockedTarget.Character:FindFirstChild("HumanoidRootPart")
        or lockedTarget.Character.Humanoid.Health <= 0 then
            lockedTarget = getClosestToCenter()
        end

        if lockedTarget and lockedTarget.Character then
            local root = lockedTarget.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local targetPos = root.Position + Vector3.new(0,1.5,0)
                local currentCF = camera.CFrame
                local desiredLook = (targetPos - currentCF.Position).Unit
                local currentLook = currentCF.LookVector
                local smoothed = currentLook:Lerp(desiredLook, smoothness)
                camera.CFrame = CFrame.lookAt(currentCF.Position, currentCF.Position + smoothed)
            end
        end
    end)
end
