-- NYX SCRIPTS | FULL LOADER
local UIS = game:GetService("UserInputService")
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")

local API_URL = "http://radoslavgeme.duckdns.org:28207/validate?key="
local DISCORD = "https://discord.gg/5jG3FWYjXj"

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

local function hasDrawing()
    return pcall(function() local d = Drawing.new("Circle") d:Remove() end)
end
local function hasMouseMove()
    return type(mousemoverel) == "function"
end
local function hasHttp()
    return pcall(function() safeHttp("http://radoslavgeme.duckdns.org:28207") end)
end

local drawing = hasDrawing()
local mouseMove = hasMouseMove()
local httpOk = hasHttp()

local grade, gradeColor, gradeMsg, downloadLink, blocked

if isMobile then
    if drawing and httpOk then
        grade = "S" gradeColor = Color3.fromRGB(0,255,100)
        gradeMsg = "?? Clean! Loading mobile..." blocked = false
    else
        grade = "F" gradeColor = Color3.fromRGB(255,50,50)
        gradeMsg = "bro what executor is this ?? get Delta"
        downloadLink = "https://delta-executor.com" blocked = true
    end
else
    if drawing and mouseMove and httpOk then
        grade = "S" gradeColor = Color3.fromRGB(0,255,100)
        gradeMsg = "?? Perfect! Loading..." blocked = false
    elseif drawing and httpOk and not mouseMove then
        grade = "C" gradeColor = Color3.fromRGB(255,200,0)
        gradeMsg = "Mid executor, aimbot disabled ??"
        downloadLink = "https://xeno.now" blocked = false
    else
        grade = "F" gradeColor = Color3.fromRGB(255,50,50)
        gradeMsg = "BRO ?? how are you alive get Xeno NOW"
        downloadLink = "https://xeno.now" blocked = true
    end
end

-- GUI HELPER
local function makeGui(name)
    local g = Instance.new("ScreenGui")
    g.Name = name
    g.ResetOnSpawn = false
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    g.Parent = player:WaitForChild("PlayerGui")
    return g
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function label(parent, text, size, color, font, xalign)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Color3.new(1,1,1)
    l.TextSize = size or 14
    l.Font = font or Enum.Font.GothamBold
    l.TextXAlignment = xalign or Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

-- EXECUTOR CHECK GUI
local checkGui = makeGui("NYXCheck")
local cf = Instance.new("Frame")
cf.Size = UDim2.new(0,400,0,270)
cf.Position = UDim2.new(0.5,-200,0.5,-135)
cf.BackgroundColor3 = Color3.fromRGB(13,13,18)
cf.BorderSizePixel = 0
cf.Parent = checkGui
corner(cf, 14)

local ctop = Instance.new("Frame")
ctop.Size = UDim2.new(1,0,0,48)
ctop.BackgroundColor3 = Color3.fromRGB(110,0,220)
ctop.BorderSizePixel = 0
ctop.Parent = cf
corner(ctop, 14)

local ctitle = label(ctop, "  ?? NYX SCRIPTS  |  EXECUTOR CHECK", 15, Color3.new(1,1,1), Enum.Font.GothamBold)
ctitle.Size = UDim2.new(1,0,1,0)
ctitle.TextXAlignment = Enum.TextXAlignment.Left

local gradeBox = Instance.new("Frame")
gradeBox.Size = UDim2.new(0,70,0,70)
gradeBox.Position = UDim2.new(0,18,0,62)
gradeBox.BackgroundColor3 = gradeColor
gradeBox.Parent = cf
corner(gradeBox, 10)

local gradeText = label(gradeBox, grade, 36, Color3.new(1,1,1), Enum.Font.GothamBold, Enum.TextXAlignment.Center)
gradeText.Size = UDim2.new(1,0,1,0)
gradeText.TextXAlignment = Enum.TextXAlignment.Center

local feats = {
    {"Drawing API", drawing},
    {"Mouse Control", isMobile and true or mouseMove},
    {"HTTP Requests", httpOk},
    {"Platform", nil, isMobile and "?? Mobile" or "?? PC"}
}

for i,f in ipairs(feats) do
    local fl = label(cf, (f[3] or (f[2] and "? " or "? ") .. f[1]), 13,
        f[3] and Color3.fromRGB(150,150,255) or (f[2] and Color3.fromRGB(0,220,80) or Color3.fromRGB(255,70,70)),
        Enum.Font.Gotham)
    fl.Size = UDim2.new(0,260,0,24)
    fl.Position = UDim2.new(0,105,0,58+(i-1)*28)
    if f[3] then fl.Text = f[3] end
end

local msgL = label(cf, gradeMsg, 13, gradeColor, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
msgL.Size = UDim2.new(0.9,0,0,28)
msgL.Position = UDim2.new(0.05,0,0,175)

if blocked then
    local dlBtn = Instance.new("TextButton")
    dlBtn.Size = UDim2.new(0.85,0,0,40)
    dlBtn.Position = UDim2.new(0.075,0,0,215)
    dlBtn.BackgroundColor3 = Color3.fromRGB(110,0,220)
    dlBtn.Text = isMobile and "?? Get Delta (Free)" or "?? Get Xeno (Free)"
    dlBtn.TextColor3 = Color3.new(1,1,1)
    dlBtn.TextSize = 14
    dlBtn.Font = Enum.Font.GothamBold
    dlBtn.Parent = cf
    corner(dlBtn)
    dlBtn.MouseButton1Click:Connect(function()
        pcall(function() game:GetService("GuiService"):OpenBrowserWindow(downloadLink) end)
    end)
else
    local contBtn = Instance.new("TextButton")
    contBtn.Size = UDim2.new(0.85,0,0,40)
    contBtn.Position = UDim2.new(0.075,0,0,215)
    contBtn.BackgroundColor3 = Color3.fromRGB(110,0,220)
    contBtn.Text = "?  Continue"
    contBtn.TextColor3 = Color3.new(1,1,1)
    contBtn.TextSize = 14
    contBtn.Font = Enum.Font.GothamBold
    contBtn.Parent = cf
    corner(contBtn)

    local function proceed()
        if checkGui and checkGui.Parent then
            checkGui:Destroy()
            LOADKEYSYSTEM()
        end
    end

    contBtn.MouseButton1Click:Connect(proceed)
    if grade == "S" then task.delay(2, proceed) end
end

-- KEY SYSTEM
function LOADKEYSYSTEM()
    pcall(function() game:GetService("GuiService"):OpenBrowserWindow(DISCORD) end)

    local kg = makeGui("NYXKey")
    local kf = Instance.new("Frame")
    kf.Size = UDim2.new(0,420,0,260)
    kf.Position = UDim2.new(0.5,-210,0.5,-130)
    kf.BackgroundColor3 = Color3.fromRGB(13,13,18)
    kf.BorderSizePixel = 0
    kf.Parent = kg
    corner(kf, 14)

    local ktop = Instance.new("Frame")
    ktop.Size = UDim2.new(1,0,0,48)
    ktop.BackgroundColor3 = Color3.fromRGB(110,0,220)
    ktop.BorderSizePixel = 0
    ktop.Parent = kf
    corner(ktop, 14)

    local ktitle = label(ktop, "  ?? NYX SCRIPTS  |  KEY SYSTEM", 15, Color3.new(1,1,1), Enum.Font.GothamBold)
    ktitle.Size = UDim2.new(1,0,1,0)

    local discBtn = Instance.new("TextButton")
    discBtn.Size = UDim2.new(0.88,0,0,38)
    discBtn.Position = UDim2.new(0.06,0,0,58)
    discBtn.BackgroundColor3 = Color3.fromRGB(88,101,242)
    discBtn.Text = "??  Join Discord to Get Your Key"
    discBtn.TextColor3 = Color3.new(1,1,1)
    discBtn.TextSize = 14
    discBtn.Font = Enum.Font.GothamBold
    discBtn.Parent = kf
    corner(discBtn)
    discBtn.MouseButton1Click:Connect(function()
        pcall(function() game:GetService("GuiService"):OpenBrowserWindow(DISCORD) end)
    end)

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(0.88,0,0,1)
    sep.Position = UDim2.new(0.06,0,0,106)
    sep.BackgroundColor3 = Color3.fromRGB(40,40,50)
    sep.BorderSizePixel = 0
    sep.Parent = kf

    local kinput = Instance.new("TextBox")
    kinput.Size = UDim2.new(0.88,0,0,42)
    kinput.Position = UDim2.new(0.06,0,0,116)
    kinput.BackgroundColor3 = Color3.fromRGB(20,20,28)
    kinput.Text = ""
    kinput.PlaceholderText = "  NYX-XXXXXXXXXXXXXXXX"
    kinput.TextColor3 = Color3.new(1,1,1)
    kinput.TextSize = 14
    kinput.Font = Enum.Font.Code
    kinput.ClearTextOnFocus = false
    kinput.Parent = kf
    corner(kinput)

    local kstatus = label(kf, "??  Enter your key from Discord", 13, Color3.fromRGB(120,120,140), Enum.Font.Gotham, Enum.TextXAlignment.Center)
    kstatus.Size = UDim2.new(1,0,0,24)
    kstatus.Position = UDim2.new(0,0,0,165)

    local kbtn = Instance.new("TextButton")
    kbtn.Size = UDim2.new(0.88,0,0,42)
    kbtn.Position = UDim2.new(0.06,0,0,196)
    kbtn.BackgroundColor3 = Color3.fromRGB(110,0,220)
    kbtn.Text = "??  UNLOCK"
    kbtn.TextColor3 = Color3.new(1,1,1)
    kbtn.TextSize = 15
    kbtn.Font = Enum.Font.GothamBold
    kbtn.Parent = kf
    corner(kbtn)

    local unlocked = false
    kbtn.MouseButton1Click:Connect(function()
        if unlocked then return end
        local key = kinput.Text
        if key == "" then
            kstatus.Text = "?  Please enter your key first!"
            kstatus.TextColor3 = Color3.fromRGB(255,80,80)
            return
        end
        kstatus.Text = "?  Validating key..."
        kstatus.TextColor3 = Color3.fromRGB(255,200,0)

        local ok, result = pcall(safeHttp, API_URL..key)
        if ok and result then
            local dok, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(result)
            end)
            if dok and data and data.valid then
                unlocked = true
                kstatus.Text = "?  Valid! Loading..."
                kstatus.TextColor3 = Color3.fromRGB(0,220,80)
                task.wait(0.8)
                kg:Destroy()
                if isMobile then
                    LOADMOBILE(data)
                else
                    LOADPC(data)
                end
            else
                kstatus.Text = "?  Invalid key! Join Discord to get one"
                kstatus.TextColor3 = Color3.fromRGB(255,80,80)
                kinput.Text = ""
            end
        else
            kstatus.Text = "?  Connection failed!"
            kstatus.TextColor3 = Color3.fromRGB(255,80,80)
        end
    end)
end

-- SHARED UI BUILDER (sidebar style)
local function buildMainGui(data, mobile)
    local discordUser = data and data.username or "unknown"
    local avatarUrl = data and data.avatar_url or ""

    local sg = makeGui("NYXMain")

    -- MAIN FRAME
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, mobile and 340 or 520, 0, mobile and 320 or 400)
    main.Position = UDim2.new(0.5, mobile and -170 or -260, 0.5, mobile and -160 or -200)
    main.BackgroundColor3 = Color3.fromRGB(13,13,18)
    main.BorderSizePixel = 0
    main.Parent = sg
    corner(main, 14)

    -- TOPBAR
    local topbar = Instance.new("Frame")
    topbar.Size = UDim2.new(1,0,0,44)
    topbar.BackgroundColor3 = Color3.fromRGB(110,0,220)
    topbar.BorderSizePixel = 0
    topbar.Parent = main
    corner(topbar, 14)

    local titleL = label(topbar, "  ?? NYX SCRIPTS", 15, Color3.new(1,1,1), Enum.Font.GothamBold)
    titleL.Size = UDim2.new(1,-90,1,0)

    -- MINIMIZE button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0,32,0,28)
    minBtn.Position = UDim2.new(1,-74,0,8)
    minBtn.BackgroundColor3 = Color3.fromRGB(50,50,65)
    minBtn.Text = "—"
    minBtn.TextColor3 = Color3.new(1,1,1)
    minBtn.TextSize = 16
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = topbar
    corner(minBtn, 6)

    -- CLOSE button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,32,0,28)
    closeBtn.Position = UDim2.new(1,-36,0,8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,50)
    closeBtn.Text = "?"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = topbar
    corner(closeBtn, 6)

    -- SIDEBAR
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, mobile and 90 or 110, 0, -54)
    sidebar.Position = UDim2.new(0,0,0,44)
    sidebar.SizeConstraint = Enum.SizeConstraint.RelativeXY
    sidebar.Size = UDim2.new(0, mobile and 90 or 110, 1, -44-40)
    sidebar.BackgroundColor3 = Color3.fromRGB(18,18,25)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main

    -- CONTENT AREA
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -(mobile and 90 or 110), 1, -44-40)
    content.Position = UDim2.new(0, mobile and 90 or 110, 0, 44)
    content.BackgroundColor3 = Color3.fromRGB(16,16,22)
    content.BorderSizePixel = 0
    content.Parent = main

    -- BOTTOM BAR
    local bottomBar = Instance.new("Frame")
    bottomBar.Size = UDim2.new(1,0,0,40)
    bottomBar.Position = UDim2.new(0,0,1,-40)
    bottomBar.BackgroundColor3 = Color3.fromRGB(18,18,25)
    bottomBar.BorderSizePixel = 0
    bottomBar.Parent = main
    corner(bottomBar, 8)

    -- Avatar circle
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0,28,0,28)
    avatarFrame.Position = UDim2.new(0,8,0,6)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(110,0,220)
    avatarFrame.BorderSizePixel = 0
    avatarFrame.Parent = bottomBar
    corner(avatarFrame, 14)

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.new(1,0,1,0)
    avatarImg.BackgroundTransparency = 1
    avatarImg.Image = avatarUrl
    avatarImg.Parent = avatarFrame
    corner(avatarImg, 14)

    -- Discord username
    local userL = label(bottomBar, discordUser, 12, Color3.fromRGB(220,220,220), Enum.Font.GothamBold)
    userL.Size = UDim2.new(0,120,0,16)
    userL.Position = UDim2.new(0,44,0,4)

    -- Made by
    local madeBy = label(bottomBar, "Made by RadoslavGeme", 10, Color3.fromRGB(110,0,220), Enum.Font.Gotham, Enum.TextXAlignment.Center)
    madeBy.Size = UDim2.new(0,160,0,12)
    madeBy.Position = UDim2.new(0.5,-80,0,4)

    -- Bug report
    local bugL = label(bottomBar, "Report bugs in DMs to radoslavgeme or make a ticket", 8, Color3.fromRGB(70,70,90), Enum.Font.Gotham, Enum.TextXAlignment.Center)
    bugL.Size = UDim2.new(0,260,0,10)
    bugL.Position = UDim2.new(0.5,-130,0,18)

    -- DRAGGABLE
    local dragging, dragStart, startPos
    topbar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- MINIMIZE
    local minimized = false
    local fullSize = main.Size
    local miniBar = Instance.new("Frame")
    miniBar.Size = UDim2.new(0,200,0,36)
    miniBar.Position = main.Position
    miniBar.BackgroundColor3 = Color3.fromRGB(110,0,220)
    miniBar.BorderSizePixel = 0
    miniBar.Visible = false
    miniBar.Parent = sg
    corner(miniBar, 8)

    local miniTitle = label(miniBar, "?? NYX SCRIPTS", 13, Color3.new(1,1,1), Enum.Font.GothamBold)
    miniTitle.Size = UDim2.new(1,-40,1,0)
    miniTitle.Position = UDim2.new(0,8,0,0)

    local miniOpen = Instance.new("TextButton")
    miniOpen.Size = UDim2.new(0,30,0,26)
    miniOpen.Position = UDim2.new(1,-34,0,5)
    miniOpen.BackgroundColor3 = Color3.fromRGB(50,50,65)
    miniOpen.Text = "^"
    miniOpen.TextColor3 = Color3.new(1,1,1)
    miniOpen.TextSize = 12
    miniOpen.Font = Enum.Font.GothamBold
    miniOpen.Parent = miniBar
    corner(miniOpen, 6)

    minBtn.MouseButton1Click:Connect(function()
        minimized = true
        main.Visible = false
        miniBar.Visible = true
        miniBar.Position = main.Position
    end)

    miniOpen.MouseButton1Click:Connect(function()
        minimized = false
        main.Visible = true
        miniBar.Visible = false
    end)

    -- SIDEBAR TABS
    local tabs = {}
    local tabContents = {}
    local activeTab = nil
    local tabNames = mobile and {"Aimbot","ESP","Settings"} or {"Aimbot","ESP","Settings","Info"}
    local tabIcons = {"??","??","??","??"}

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0,4)
    tabLayout.Parent = sidebar

    local tabPad = Instance.new("UIPadding")
    tabPad.PaddingTop = UDim.new(0,8)
    tabPad.PaddingLeft = UDim.new(0,6)
    tabPad.PaddingRight = UDim.new(0,6)
    tabPad.Parent = sidebar

    local function switchTab(name)
        for n, c in pairs(tabContents) do
            c.Visible = n == name
        end
        for n, b in pairs(tabs) do
            b.BackgroundColor3 = n == name and Color3.fromRGB(110,0,220) or Color3.fromRGB(25,25,35)
        end
        activeTab = name
    end

    for i, name in ipairs(tabNames) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1,0,0,mobile and 42 or 48)
        tabBtn.BackgroundColor3 = Color3.fromRGB(25,25,35)
        tabBtn.Text = tabIcons[i].."\n"..name
        tabBtn.TextColor3 = Color3.new(1,1,1)
        tabBtn.TextSize = mobile and 10 or 11
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.LayoutOrder = i
        tabBtn.Parent = sidebar
        corner(tabBtn, 8)
        tabs[name] = tabBtn

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1,0,1,0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(110,0,220)
        tabContent.Visible = false
        tabContent.Parent = content
        tabContents[name] = tabContent

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0,6)
        listLayout.Parent = tabContent

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0,8)
        pad.PaddingLeft = UDim.new(0,8)
        pad.PaddingRight = UDim.new(0,8)
        pad.Parent = tabContent

        tabBtn.MouseButton1Click:Connect(function() switchTab(name) end)
    end

    switchTab("Aimbot")

    -- TOGGLE HELPER
    local function addToggle(parent, text, desc, default, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1,0,0,52)
        row.BackgroundColor3 = Color3.fromRGB(20,20,28)
        row.BorderSizePixel = 0
        row.Parent = parent
        corner(row, 8)

        local tl = label(row, text, 13, Color3.new(1,1,1), Enum.Font.GothamBold)
        tl.Size = UDim2.new(1,-60,0,18)
        tl.Position = UDim2.new(0,10,0,8)

        local dl = label(row, desc, 10, Color3.fromRGB(100,100,120), Enum.Font.Gotham)
        dl.Size = UDim2.new(1,-60,0,14)
        dl.Position = UDim2.new(0,10,0,28)

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0,44,0,24)
        toggle.Position = UDim2.new(1,-54,0.5,-12)
        toggle.BackgroundColor3 = default and Color3.fromRGB(110,0,220) or Color3.fromRGB(40,40,55)
        toggle.Text = default and "ON" or "OFF"
        toggle.TextColor3 = Color3.new(1,1,1)
        toggle.TextSize = 11
        toggle.Font = Enum.Font.GothamBold
        toggle.Parent = row
        corner(toggle, 12)

        local state = default
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.Text = state and "ON" or "OFF"
            toggle.BackgroundColor3 = state and Color3.fromRGB(110,0,220) or Color3.fromRGB(40,40,55)
            callback(state)
        end)
        return toggle
    end

    local function addSlider(parent, text, min, max, default, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1,0,0,60)
        row.BackgroundColor3 = Color3.fromRGB(20,20,28)
        row.BorderSizePixel = 0
        row.Parent = parent
        corner(row, 8)

        local tl = label(row, text..": "..default, 13, Color3.new(1,1,1), Enum.Font.GothamBold)
        tl.Size = UDim2.new(1,-16,0,18)
        tl.Position = UDim2.new(0,10,0,6)

        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1,-20,0,6)
        sliderBg.Position = UDim2.new(0,10,0,30)
        sliderBg.BackgroundColor3 = Color3.fromRGB(35,35,48)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = row
        corner(sliderBg, 3)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
        fill.BackgroundColor3 = Color3.fromRGB(110,0,220)
        fill.BorderSizePixel = 0
        fill.Parent = sliderBg
        corner(fill, 3)

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0,50,0,20)
        box.Position = UDim2.new(1,-60,0,40)
        box.BackgroundColor3 = Color3.fromRGB(30,30,42)
        box.Text = tostring(default)
        box.TextColor3 = Color3.new(1,1,1)
        box.TextSize = 11
        box.Font = Enum.Font.Code
        box.Parent = row
        corner(box, 4)

        box.FocusLost:Connect(function()
            local v = tonumber(box.Text)
            if v then
                v = math.clamp(v, min, max)
                box.Text = tostring(v)
                tl.Text = text..": "..v
                fill.Size = UDim2.new((v-min)/(max-min),0,1,0)
                callback(v)
            end
        end)

        -- Slider drag
        local sliding = false
        sliderBg.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                sliding = true
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local rel = math.clamp((i.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max-min)*rel)
                fill.Size = UDim2.new(rel,0,1,0)
                box.Text = tostring(val)
                tl.Text = text..": "..val
                callback(val)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                sliding = false
            end
        end)
    end

    local function addSection(parent, text)
        local s = label(parent, "  "..text, 11, Color3.fromRGB(110,0,220), Enum.Font.GothamBold)
        s.Size = UDim2.new(1,0,0,22)
        s.BackgroundColor3 = Color3.fromRGB(18,18,26)
        s.BackgroundTransparency = 0
        corner(s, 6)
        return s
    end

    -- AIMBOT SETTINGS
    local aimbotEnabled = true
    local fov = 120
    local smoothness = 18
    local prediction = 0.08
    local silentAim = false

    local aimbotTab = tabContents["Aimbot"]
    addSection(aimbotTab, "AIMBOT")
    addToggle(aimbotTab, "Aimbot", "Auto aim at nearest player", true, function(v) aimbotEnabled = v end)
    addToggle(aimbotTab, "Silent Aim", "Aim without camera movement", false, function(v) silentAim = v end)
    addSection(aimbotTab, "CONFIGURATION")
    addSlider(aimbotTab, "FOV", 30, 400, fov, function(v) fov = v end)
    addSlider(aimbotTab, "Smoothness", 1, 30, smoothness, function(v) smoothness = v end)
    addSlider(aimbotTab, "Prediction", 0, 40, math.floor(prediction*100), function(v) prediction = v/100 end)

    -- ESP SETTINGS
    local espEnabled = true
    local showNames = true
    local showBoxes = true
    local showHealth = true
    local chamsEnabled = false

    local espTab = tabContents["ESP"]
    addSection(espTab, "ESP")
    addToggle(espTab, "ESP", "Show player outlines", true, function(v) espEnabled = v end)
    addToggle(espTab, "Names", "Show player names", true, function(v) showNames = v end)
    addToggle(espTab, "Boxes", "Show player boxes", true, function(v) showBoxes = v end)
    addToggle(espTab, "Health Bar", "Show player health", true, function(v) showHealth = v end)
    if not mobile then
        addToggle(espTab, "Chams", "Highlight players through walls", false, function(v) chamsEnabled = v end)
    end

    -- SETTINGS TAB
    local settingsTab = tabContents["Settings"]
    addSection(settingsTab, "GENERAL")
    addToggle(settingsTab, "FOV Circle", "Show FOV circle on screen", true, function(v)
        if fovCircle then fovCircle.Visible = v end
    end)
    addToggle(settingsTab, "Notifications", "Show status notifications", true, function(v) end)
    addSection(settingsTab, "TARGET")
    addToggle(settingsTab, "Closest to Mouse", "Target nearest to cursor", true, function(v) end)
    addToggle(settingsTab, "Alive Only", "Only target alive players", true, function(v) end)

    -- INFO TAB (PC only)
    if not mobile and tabContents["Info"] then
        local infoTab = tabContents["Info"]
        addSection(infoTab, "ABOUT")
        local infoTexts = {
            {"Script", "NYX Scripts v1.0"},
            {"Author", "RadoslavGeme"},
            {"Discord", "discord.gg/5jG3FWYjXj"},
            {"Executor", grade == "S" and "? Supported" or "?? Limited"},
            {"Platform", "?? PC"},
            {"Key", "? Validated"},
        }
        for _, info in ipairs(infoTexts) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1,0,0,36)
            row.BackgroundColor3 = Color3.fromRGB(20,20,28)
            row.BorderSizePixel = 0
            row.Parent = infoTab
            corner(row, 8)
            local kl = label(row, info[1], 11, Color3.fromRGB(110,0,220), Enum.Font.GothamBold)
            kl.Size = UDim2.new(0,80,1,0)
            kl.Position = UDim2.new(0,10,0,0)
            local vl = label(row, info[2], 11, Color3.fromRGB(200,200,200), Enum.Font.Gotham)
            vl.Size = UDim2.new(1,-100,1,0)
            vl.Position = UDim2.new(0,95,0,0)
        end
    end

    -- CLOSE (full destroy)
    local connections = {}
    local targets = {}
    local highlights = {}
    local fovCircle = nil

    closeBtn.MouseButton1Click:Connect(function()
        for _,c in pairs(connections) do pcall(function() c:Disconnect() end) end
        for _,d in pairs(targets) do
            pcall(function() d.box:Remove() end)
            pcall(function() d.name:Remove() end)
        end
        for _,h in pairs(highlights) do pcall(function() h:Destroy() end) end
        if fovCircle then pcall(function() fovCircle:Remove() end) end
        sg:Destroy()
        print("NYX: Fully stopped and cleaned up")
    end)

    return {
        sg = sg,
        connections = connections,
        targets = targets,
        highlights = highlights,
        getFovCircle = function() return fovCircle end,
        setFovCircle = function(c) fovCircle = c end,
        getAimbotEnabled = function() return aimbotEnabled end,
        getEspEnabled = function() return espEnabled end,
        getShowNames = function() return showNames end,
        getShowBoxes = function() return showBoxes end,
        getFov = function() return fov end,
        getSmoothness = function() return smoothness end,
        getPrediction = function() return prediction end,
        getSilentAim = function() return silentAim end,
        getChams = function() return chamsEnabled end,
    }
end

-- PC VERSION
function LOADPC(data)
    local ui = buildMainGui(data, false)
    local mouse = player:GetMouse()
    local isAiming = false
    local targets = ui.targets

    local fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1
    fovCircle.Color = Color3.fromRGB(180,0,255)
    fovCircle.Transparency = 0.5
    fovCircle.Filled = false
    fovCircle.NumSides = 80
    ui.setFovCircle(fovCircle)

    local function createESP(plr)
        if plr == player then return end
        local box = Drawing.new("Square")
        box.Thickness = 1
        box.Color = Color3.fromRGB(255,50,50)
        box.Transparency = 0.8
        box.Filled = false
        local nametag = Drawing.new("Text")
        nametag.Size = 12
        nametag.Color = Color3.fromRGB(255,255,255)
        nametag.Outline = true
        nametag.Center = true
        local healthBar = Drawing.new("Square")
        healthBar.Thickness = 2
        healthBar.Color = Color3.fromRGB(0,255,0)
        healthBar.Transparency = 0.8
        healthBar.Filled = false
        targets[plr] = {box=box, name=nametag, health=healthBar}
    end

    for _,p in ipairs(game.Players:GetPlayers()) do createESP(p) end
    game.Players.PlayerAdded:Connect(createESP)
    game.Players.PlayerRemoving:Connect(function(p)
        if targets[p] then
            pcall(function() targets[p].box:Remove() end)
            pcall(function() targets[p].name:Remove() end)
            pcall(function() targets[p].health:Remove() end)
            targets[p] = nil
        end
    end)

    local function getClosest()
        local closest, minDist = nil, ui.getFov()
        for _,p in ipairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character
            and p.Character:FindFirstChild("HumanoidRootPart")
            and p.Character:FindFirstChild("Humanoid")
            and p.Character.Humanoid.Health > 0 then
                local root = p.Character.HumanoidRootPart
                local predicted = root.Position + (root.Velocity * ui.getPrediction())
                local screen, onScreen = camera:WorldToViewportPoint(predicted)
                if onScreen then
                    local dist = (Vector2.new(screen.X,screen.Y) - Vector2.new(mouse.X,mouse.Y)).Magnitude
                    if dist < minDist then minDist = dist closest = predicted end
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

    ui.connections.render = RS.RenderStepped:Connect(function()
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
        fovCircle.Radius = ui.getFov()
        fovCircle.Visible = ui.getAimbotEnabled()

        if ui.getAimbotEnabled() and isAiming then
            local t = getClosest()
            if t then
                local sp = camera:WorldToScreenPoint(t)
                local dir = (Vector2.new(sp.X,sp.Y) - Vector2.new(mouse.X,mouse.Y)) / ui.getSmoothness()
                pcall(function() mousemoverel(dir.X*0.75, dir.Y*0.75) end)
            end
        end

        for plr, d in pairs(targets) do
            local espOn = ui.getEspEnabled()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local root = plr.Character.HumanoidRootPart
                local rp, onScreen = camera:WorldToViewportPoint(root.Position)
                if onScreen and espOn then
                    local head = plr.Character:FindFirstChild("Head")
                    local hp = head and camera:WorldToViewportPoint(head.Position) or rp
                    local lp = camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
                    local h = (hp.Y - lp.Y) * 1.35
                    local w = h / 2.1
                    if ui.getShowBoxes() then
                        d.box.Size = Vector2.new(w,h)
                        d.box.Position = Vector2.new(rp.X-w/2, rp.Y-h/2)
                        d.box.Visible = true
                    else d.box.Visible = false end
                    if ui.getShowNames() then
                        d.name.Text = plr.Name
                        d.name.Position = Vector2.new(rp.X, rp.Y-h/2-16)
                        d.name.Visible = true
                    else d.name.Visible = false end
                else
                    d.box.Visible = false
                    d.name.Visible = false
                    d.health.Visible = false
                end
            else
                d.box.Visible = false
                d.name.Visible = false
                d.health.Visible = false
            end
        end
    end)
end

-- MOBILE VERSION
function LOADMOBILE(data)
    local ui = buildMainGui(data, true)
    local lockedTarget = nil
    local isLocking = false

    -- Lock button
    local lockBtn = Instance.new("TextButton")
    lockBtn.Size = UDim2.new(0,80,0,80)
    lockBtn.Position = UDim2.new(1,-95,1,-95)
    lockBtn.BackgroundColor3 = Color3.fromRGB(110,0,220)
    lockBtn.Text = "??\nLOCK"
    lockBtn.TextColor3 = Color3.new(1,1,1)
    lockBtn.TextSize = 12
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.Parent = ui.sg
    corner(lockBtn, 40)

    lockBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            isLocking = true
            lockBtn.BackgroundColor3 = Color3.fromRGB(200,0,80)
            lockBtn.Text = "??\nON"
        end
    end)
    lockBtn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            isLocking = false
            lockedTarget = nil
            lockBtn.BackgroundColor3 = Color3.fromRGB(110,0,220)
            lockBtn.Text = "??\nLOCK"
        end
    end)

    local function createHighlight(plr)
        if plr == player then return end
        local function apply()
            if plr.Character then
                if ui.highlights[plr] then ui.highlights[plr]:Destroy() end
                local h = Instance.new("Highlight")
                h.FillColor = Color3.fromRGB(255,0,0)
                h.FillTransparency = 0.6
                h.OutlineColor = Color3.fromRGB(255,255,255)
                h.OutlineTransparency = 0
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Adornee = plr.Character
                h.Parent = plr.Character
                ui.highlights[plr] = h
            end
        end
        apply()
        plr.CharacterAdded:Connect(function() task.wait(0.5) apply() end)
    end

    for _,p in ipairs(game.Players:GetPlayers()) do createHighlight(p) end
    game.Players.PlayerAdded:Connect(createHighlight)
    game.Players.PlayerRemoving:Connect(function(p)
        if ui.highlights[p] then
            pcall(function() ui.highlights[p]:Destroy() end)
            ui.highlights[p] = nil
        end
    end)

    local function getClosestCenter()
        local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
        local closest, minDist = nil, ui.getFov()
        for _,p in ipairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character
            and p.Character:FindFirstChild("HumanoidRootPart")
            and p.Character:FindFirstChild("Humanoid")
            and p.Character.Humanoid.Health > 0 then
                local root = p.Character.HumanoidRootPart
                local screen, onScreen = camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local dist = (Vector2.new(screen.X,screen.Y) - center).Magnitude
                    if dist < minDist then minDist = dist closest = p end
                end
            end
        end
        return closest
    end

    ui.connections.esp = RS.Heartbeat:Connect(function()
        for plr, h in pairs(ui.highlights) do
            pcall(function()
                h.Enabled = ui.getEspEnabled()
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

    ui.connections.aim = RS.RenderStepped:Connect(function()
        if not ui.getAimbotEnabled() or not isLocking then return end
        if not lockedTarget or not lockedTarget.Character
        or not lockedTarget.Character:FindFirstChild("HumanoidRootPart")
        or lockedTarget.Character.Humanoid.Health <= 0 then
            lockedTarget = getClosestCenter()
        end
        if lockedTarget and lockedTarget.Character then
            local root = lockedTarget.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local targetPos = root.Position + Vector3.new(0,1.5,0)
                local currentCF = camera.CFrame
                local desiredLook = (targetPos - currentCF.Position).Unit
                local smoothed = currentCF.LookVector:Lerp(desiredLook, ui.getSmoothness()/100)
                camera.CFrame = CFrame.lookAt(currentCF.Position, currentCF.Position + smoothed)
            end
        end
    end)
end
