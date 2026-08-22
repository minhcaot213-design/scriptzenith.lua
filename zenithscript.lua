-- [[ ZENITH BLOX FRUIT - COMPREHENSIVE SCRIPT HUB ]] --

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- ===================================================
-- 0. DỌN DẸP INSTANCE CŨ (CLEANUP)
-- ===================================================
local UI_NAME = "ZenithBloxFruit_V2"
local function getSafeParent()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then return coreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local parentGui = getSafeParent()
if parentGui:FindFirstChild(UI_NAME) then
    parentGui[UI_NAME]:Destroy()
end

-- ===================================================
-- 1. DATABASE QUÁI THEO TỪNG SEA (BLOX FRUITS)
-- ===================================================
local MobsDatabase = {
    ["Sea 1"] = {
        "Bandit [Lv. 5]", "Monkey [Lv. 14]", "Gorilla [Lv. 20]",
        "Pirate [Lv. 35]", "Brute [Lv. 45]", "Desert Bandit [Lv. 60]",
        "Snowman [Lv. 100]", "Chief Warden [Lv. 230]", "Magma Soldier [Lv. 300]",
        "Fishman Warrior [Lv. 375]", "God's Guard [Lv. 450]", "Galley Pirate [Lv. 625]"
    },
    ["Sea 2"] = {
        "Raider [Lv. 700]", "Mercenary [Lv. 725]", "Swan Pirate [Lv. 775]",
        "Factory Staff [Lv. 800]", "Marine Lieutenant [Lv. 875]", "Zombie [Lv. 950]",
        "Snow Trooper [Lv. 1000]", "Ship Engineer [Lv. 1275]", "Arctic Warrior [Lv. 1350]"
    },
    ["Sea 3"] = {
        "Pirate Millionaire [Lv. 1500]", "Pistol Billionaire [Lv. 1525]", "Dragon Crew Warrior [Lv. 1575]",
        "Female Islander [Lv. 1625]", "Giant Islander [Lv. 1650]", "Marine Commodore [Lv. 1700]",
        "Fishman Raider [Lv. 1775]", "Reborn Skeleton [Lv. 1975]", "Demonic Soul [Lv. 2025]", "Sea Soldier [Lv. 2200]"
    }
}

local selectedSea = "Sea 1"
local selectedMob = MobsDatabase["Sea 1"][1]
local autoFarmActive = false
local fastAttackActive = false
local bringMobActive = false

-- ===================================================
-- 2. LOGIC SPEED & HIGH JUMP (BYPASS VELOCITY)
-- ===================================================
local speedValue = 16
local speedEnabled = false
local jumpValue = 50
local jumpEnabled = false

RunService.Heartbeat:Connect(function()
    if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        if humanoid and rootPart and humanoid.MoveDirection.Magnitude > 0 then
            rootPart.AssemblyLinearVelocity = Vector3.new(
                humanoid.MoveDirection.X * speedValue,
                rootPart.AssemblyLinearVelocity.Y,
                humanoid.MoveDirection.Z * speedValue
            )
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if jumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        rootPart.AssemblyLinearVelocity = Vector3.new(rootPart.AssemblyLinearVelocity.X, jumpValue, rootPart.AssemblyLinearVelocity.Z)
    end
end)

-- ===================================================
-- 3. LOGIC AUTO FARM & FAST ATTACK (CORE)
-- ===================================================
local function getTargetEnemy()
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return nil end

    local rawName = string.gsub(selectedMob, " %[%d+%]", "")
    for _, mob in ipairs(enemies:GetChildren()) do
        if string.find(mob.Name, rawName) or mob.Name == selectedMob then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                return mob
            end
        end
    end
    return nil
end

-- Vòng lặp Auto Farm & Fast Attack
task.spawn(function()
    while true do
        task.wait()
        if autoFarmActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local enemy = getTargetEnemy()
            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                local myRoot = LocalPlayer.Character.HumanoidRootPart
                local targetHRP = enemy.HumanoidRootPart
                
                -- Teleport đứng phía trên đầu quái 10 studs
                myRoot.CFrame = targetHRP.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                myRoot.AssemblyLinearVelocity = Vector3.zero

                -- Fast Attack
                if fastAttackActive then
                    VirtualUser:CaptureController()
                    VirtualUser:Button1Down(Vector2.new(0, 0))
                end

                -- Gom quái (Bring Mob)
                if bringMobActive then
                    local enemies = Workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, other in ipairs(enemies:GetChildren()) do
                            if other ~= enemy and (string.find(other.Name, string.gsub(selectedMob, " %[%d+%]", "")) or other.Name == selectedMob) then
                                local oHRP = other:FindFirstChild("HumanoidRootPart")
                                local oHum = other:FindFirstChildOfClass("Humanoid")
                                if oHRP and oHum and oHum.Health > 0 then
                                    oHRP.CFrame = targetHRP.CFrame
                                    oHRP.CanCollide = false
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ===================================================
-- 4. KHỞI TẠO KHUNG GIAO DIỆN (UI INITIALIZATION)
-- ===================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 400)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(38, 42, 56)
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- Kéo thả cửa sổ (Drag Logic)
local isDraggingWindow = false
local dragStartPos, frameStartPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingWindow = true
        dragStartPos = input.Position
        frameStartPos = MainFrame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingWindow = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingWindow and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartPos
        MainFrame.Position = UDim2.new(
            frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
            frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y
        )
    end
end)

-- TopBar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarTitle = Instance.new("TextLabel")
TopBarTitle.Size = UDim2.new(1, -50, 1, 0)
TopBarTitle.Position = UDim2.new(0, 16, 0, 0)
TopBarTitle.BackgroundTransparency = 1
TopBarTitle.Text = "ZENITH <font color='#00d2ff'>BLOX FRUIT</font>"
TopBarTitle.RichText = true
TopBarTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TopBarTitle.Font = Enum.Font.GothamBold
TopBarTitle.TextSize = 14
TopBarTitle.TextXAlignment = Enum.TextXAlignment.Left
TopBarTitle.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 33, 45)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Sidebar Tabs
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 19, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Parent = Sidebar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.Parent = Sidebar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -150, 1, -42)
ContentContainer.Position = UDim2.new(0, 150, 0, 42)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local tabButtons = {}
local tabPages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "_Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.BorderSizePixel = 0
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = ContentContainer

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Parent = page

    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingTop = UDim.new(0, 12)
    pagePadding.PaddingBottom = UDim.new(0, 16)
    pagePadding.Parent = page

    tabPages[name] = page
    return page
end

local function switchTab(name)
    for tabName, btn in pairs(tabButtons) do
        if tabName == name then
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(24, 26, 35)
            btn.TextColor3 = Color3.fromRGB(160, 165, 180)
        end
    end
    for pageName, page in pairs(tabPages) do
        page.Visible = (pageName == name)
    end
end

local function createTabButton(name, icon, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(24, 26, 35)
    btn.BorderSizePixel = 0
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(160, 165, 180)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.LayoutOrder = order
    btn.Parent = Sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    tabButtons[name] = btn
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- ===================================================
-- 5. UI COMPONENTS (TOGGLE, BUTTON, SLIDER, DROPDOWN)
-- ===================================================
local function createToggle(page, text, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
    frame.BorderSizePixel = 0
    frame.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 38, 0, 20)
    switch.Position = UDim2.new(1, -48, 0.5, -10)
    switch.BackgroundColor3 = state and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(45, 48, 65)
    switch.Text = ""
    switch.BorderSizePixel = 0
    switch.Parent = frame

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = switch

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    switch.MouseButton1Click:Connect(function()
        state = not state
        switch.BackgroundColor3 = state and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(45, 48, 65)
        circle.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        if callback then callback(state) end
    end)
end

local function createSlider(page, text, min, max, default, callback)
    local current = default or min
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 52)
    frame.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
    frame.BorderSizePixel = 0
    frame.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 22)
    valueLabel.Position = UDim2.new(1, -72, 0, 4)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(current)
    valueLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local track = Instance.new("TextButton")
    track.Size = UDim2.new(0.94, 0, 0, 5)
    track.Position = UDim2.new(0.03, 0, 0, 34)
    track.BackgroundColor3 = Color3.fromRGB(45, 48, 65)
    track.AutoButtonColor = false
    track.BorderSizePixel = 0
    track.Text = ""
    track.Parent = frame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local isDraggingSlider = false
    local function update(percent)
        percent = math.clamp(percent, 0, 1)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        current = math.floor(min + (max - min) * percent)
        valueLabel.Text = tostring(current)
        if callback then callback(current) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSlider = true
            update((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSlider = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = UserInputService:GetMouseLocation().X
            update((mouseX - track.AbsolutePosition.X) / track.AbsoluteSize.X)
        end
    end)
end

local function createButton(page, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(26, 28, 40)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 180, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- ===================================================
-- 6. TẠO CÁC DANH MỤC (TABS SETUP)
-- ===================================================
local categories = {
    { name = "Farm", icon = "🌾" },
    { name = "Server", icon = "🌐" },
    { name = "PVP-ESP", icon = "⚔️" },
    { name = "RAID", icon = "⚡" },
    { name = "FARM ITEM", icon = "🗡️" },
    { name = "SETTING", icon = "⚙️" }
}

for order, cat in ipairs(categories) do
    createTabButton(cat.name, cat.icon, order)
    createPage(cat.name)
end

-- ===================================================
-- 7. TAB FARM: TÍCH HỢP SEA & AUTO FARM QUÁI SIÊU TỐC
-- ===================================================
local farmPage = tabPages["Farm"]

-- Chọn Sea (Sea 1, Sea 2, Sea 3)
local seaFrame = Instance.new("Frame")
seaFrame.Size = UDim2.new(0.92, 0, 0, 42)
seaFrame.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
seaFrame.BorderSizePixel = 0
seaFrame.Parent = farmPage

local seaCorner = Instance.new("UICorner")
seaCorner.CornerRadius = UDim.new(0, 6)
seaCorner.Parent = seaFrame

local seaLayout = Instance.new("UIListLayout")
seaLayout.FillDirection = Enum.FillDirection.Horizontal
seaLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
seaLayout.VerticalAlignment = Enum.VerticalAlignment.Center
seaLayout.Padding = UDim.new(0, 8)
seaLayout.Parent = seaFrame

local seaButtons = {}
local mobContainer

local function refreshMobList()
    if not mobContainer then return end
    for _, child in ipairs(mobContainer:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, mobName in ipairs(MobsDatabase[selectedSea]) do
        local mobBtn = Instance.new("TextButton")
        mobBtn.Size = UDim2.new(0.95, 0, 0, 30)
        mobBtn.BackgroundColor3 = (selectedMob == mobName) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(28, 30, 42)
        mobBtn.Text = mobName
        mobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        mobBtn.Font = Enum.Font.Gotham
        mobBtn.TextSize = 11
        mobBtn.BorderSizePixel = 0
        mobBtn.Parent = mobContainer

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = mobBtn

        mobBtn.MouseButton1Click:Connect(function()
            selectedMob = mobName
            refreshMobList()
        end)
    end
end

for _, seaName in ipairs({"Sea 1", "Sea 2", "Sea 3"}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, 0, 0.75, 0)
    btn.BackgroundColor3 = (selectedSea == seaName) and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(32, 35, 48)
    btn.Text = seaName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = seaFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn

    seaButtons[seaName] = btn
    btn.MouseButton1Click:Connect(function()
        selectedSea = seaName
        for name, b in pairs(seaButtons) do
            b.BackgroundColor3 = (name == seaName) and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(32, 35, 48)
        end
        selectedMob = MobsDatabase[seaName][1]
        refreshMobList()
    end)
end

-- Khung hiển thị danh sách quái có thanh cuộn
mobContainer = Instance.new("ScrollingFrame")
mobContainer.Size = UDim2.new(0.92, 0, 0, 110)
mobContainer.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
mobContainer.BorderSizePixel = 0
mobContainer.ScrollBarThickness = 3
mobContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
mobContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
mobContainer.Parent = farmPage

local mobCorner = Instance.new("UICorner")
mobCorner.CornerRadius = UDim.new(0, 6)
mobCorner.Parent = mobContainer

local mobListLayout = Instance.new("UIListLayout")
mobListLayout.Padding = UDim.new(0, 4)
mobListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
mobListLayout.Parent = mobContainer

local mobPadding = Instance.new("UIPadding")
mobPadding.PaddingTop = UDim.new(0, 6)
mobPadding.PaddingBottom = UDim.new(0, 6)
mobPadding.Parent = mobContainer

refreshMobList()

createToggle(farmPage, "⚡ Auto Farm Quái Đã Chọn (Siêu Tốc)", false, function(v)
    autoFarmActive = v
end)

createToggle(farmPage, "🗡️ Fast Attack (Chém Cực Nhanh)", false, function(v)
    fastAttackActive = v
end)

createToggle(farmPage, "🧲 Bring Mob (Gom Quái Về 1 Chỗ)", false, function(v)
    bringMobActive = v
end)

-- ===================================================
-- 8. TAB PVP-ESP: SPEED, NHẢY CAO & ĐỊNH VỊ
-- ===================================================
local pvpPage = tabPages["PVP-ESP"]

createToggle(pvpPage, "Kích Hoạt Tăng Tốc Độ (WalkSpeed)", false, function(v)
    speedEnabled = v
end)

createSlider(pvpPage, "Chỉnh Speed", 16, 300, 16, function(val)
    speedValue = val
end)

createToggle(pvpPage, "Kích Hoạt Nhảy Cao (High Jump)", false, function(v)
    jumpEnabled = v
end)

createSlider(pvpPage, "Chỉnh Độ Cao Nhảy (JumpPower)", 50, 400, 50, function(val)
    jumpValue = val
end)

-- ESP Players
local espActive = false
local function handleHighlight(character, enable)
    local highlight = character:FindFirstChild("ZenithESP")
    if enable then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "ZenithESP"
            highlight.FillColor = Color3.fromRGB(255, 45, 85)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.4
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = character
            highlight.Parent = character
        end
    else
        if highlight then highlight:Destroy() end
    end
end

createToggle(pvpPage, "Player ESP (Định Vị Người Chơi)", false, function(enabled)
    espActive = enabled
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            handleHighlight(p.Character, enabled)
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        if espActive and p ~= LocalPlayer then
            task.wait(0.5)
            handleHighlight(char, true)
        end
    end)
end)

createToggle(pvpPage, "Chest ESP (Rương Báu)", false, function(v) end)
createToggle(pvpPage, "Devil Fruit ESP (Trái Ác Quỷ)", false, function(v) end)

-- ===================================================
-- 9. CÁC TAB CÒN LẠI: SERVER, RAID, FARM ITEM, SETTING
-- ===================================================

-- [TAB SERVER]
local serverPage = tabPages["Server"]
createButton(serverPage, "Rejoin Server (Vào Lại)", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

createButton(serverPage, "Server Hop (Đổi Server Ngẫu Nhiên)", function()
    local placeId = game.PlaceId
    local serversApi = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(serversApi))
    end)
    if success and response and response.data then
        for _, s in ipairs(response.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(placeId, s.id, LocalPlayer)
                break
            end
        end
    end
end)

-- [TAB RAID]
local raidPage = tabPages["RAID"]
createToggle(raidPage, "Auto Start Raid", false, function(v) end)
createToggle(raidPage, "Auto Kill Raid Mobs", false, function(v) end)
createToggle(raidPage, "Auto Next Island", false, function(v) end)

-- [TAB FARM ITEM]
local farmItemPage = tabPages["FARM ITEM"]
createToggle(farmItemPage, "Auto Farm Bones (Xương)", false, function(v) end)
createToggle(farmItemPage, "Auto Collect Chests (Nhặt Rương)", false, function(v) end)

-- [TAB SETTING]
local settingPage = tabPages["SETTING"]
createButton(settingPage, "Fix Lag / Boost FPS", function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1

    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then
            v.Enabled = false
        end
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
            obj.Enabled = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end
end)

createButton(settingPage, "Tắt Giao Diện (Close Hub)", function()
    ScreenGui:Destroy()
end)

-- Mở mặc định trang Farm
switchTab("Farm")
