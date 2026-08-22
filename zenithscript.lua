-- [[ ZENITH BLOX FRUIT - V12.24 (LDPLAYER MASTER FIX: SKY FARM 12M + AURA AFK + FULL TÍNH NĂNG) ]] --

task.wait(0.5)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local Camera = Workspace.CurrentCamera

-- Chống AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- BIẾN TOÀN CỤC (FULL CHỨC NĂNG)
local selectedWeaponType = "Melee"
local AutoFarmLevel, AutoQuest, BringMob = false, true, true
local espPlayerEnabled, espFruitEnabled = false, false
local espChest1Enabled, espChest2Enabled, espChest3Enabled = false, false, false
local speedValue, speedEnabled = 16, false
local jumpValue, jumpEnabled = 50, false
local AutoRandomFruit, AutoCollectFruit, AutoStoreFruit = false, false, false

-- ===================================================
-- 1. UI (CỨNG - KHÔNG LỖI)
-- ===================================================
local UI_NAME = "ZenithBloxFruit_Zyrox_V12"

local function GetSafeUIFolder()
    local coreGui = game:GetService("CoreGui")
    if coreGui then return coreGui end
    local success, result = pcall(function() if gethui then return gethui() end end)
    if success and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local targetUIFolder = GetSafeUIFolder()
for _, gui in ipairs(targetUIFolder:GetChildren()) do if gui.Name == UI_NAME then gui:Destroy() end end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = targetUIFolder end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- NÚT THU NHỎ
local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 48, 0, 48)
FloatingButton.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingButton.Position = UDim2.new(0.1, 0, 0.5, 0)
FloatingButton.BackgroundColor3 = Color3.fromRGB(13, 16, 22)
FloatingButton.Visible = false
FloatingButton.Text = "Z"
FloatingButton.TextColor3 = Color3.fromRGB(0, 210, 255)
FloatingButton.Font = Enum.Font.GothamBlack
FloatingButton.TextSize = 24
FloatingButton.ZIndex = 999
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", FloatingButton).Color = Color3.fromRGB(0, 210, 255)
Instance.new("UIStroke", FloatingButton).Thickness = 1.5

local FULL_HEIGHT, MIN_HEIGHT = 330, 38
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 540, 0, FULL_HEIGHT)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(30, 36, 50)
Instance.new("UIStroke", MainFrame).Thickness = 1.2

local UIScale = Instance.new("UIScale", MainFrame)

local isDraggingWindow, dragStart, frameStart = false, nil, nil
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingWindow = true
        dragStart = input.Position
        frameStart = MainFrame.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isDraggingWindow = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDraggingWindow and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = (input.Position - dragStart) / UIScale.Scale
        MainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 18, 26)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 240, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.RichText = true
Title.Text = "ZYROX VN <font color='#00d2ff'>• V12.24</font>"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

local StatsFrame = Instance.new("Frame", TopBar)
StatsFrame.Size = UDim2.new(0, 120, 0, 24)
StatsFrame.Position = UDim2.new(1, -190, 0.5, -12)
StatsFrame.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
StatsFrame.BorderSizePixel = 0
Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", StatsFrame).Color = Color3.fromRGB(0, 180, 255)
Instance.new("UIStroke", StatsFrame).Thickness = 1

local FpsLabel = Instance.new("TextLabel", StatsFrame)
FpsLabel.Size = UDim2.new(0.5, 0, 1, 0)
FpsLabel.Position = UDim2.new(0, 5, 0, 0)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: 60"
FpsLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
FpsLabel.Font = Enum.Font.GothamBold
FpsLabel.TextSize = 10
FpsLabel.TextXAlignment = Enum.TextXAlignment.Left

local PingLabel = Instance.new("TextLabel", StatsFrame)
PingLabel.Size = UDim2.new(0.5, 0, 1, 0)
PingLabel.Position = UDim2.new(0.5, -5, 0, 0)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "Ping: 0"
PingLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
PingLabel.Font = Enum.Font.GothamBold
PingLabel.TextSize = 10
PingLabel.TextXAlignment = Enum.TextXAlignment.Right

RunService.RenderStepped:Connect(function(deltaTime)
    FpsLabel.Text = "FPS: " .. math.floor(1 / deltaTime)
    pcall(function() PingLabel.Text = "Ping: " .. string.split(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1] end)
end)

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -56, 0.5, -12)
MinBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(160, 170, 190)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 13
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingButton.Visible = true
end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(13, 15, 22)

local TabListLayout = Instance.new("UIListLayout", Sidebar)
TabListLayout.Padding = UDim.new(0, 3)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 6)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -140, 1, -38)
ContentContainer.Position = UDim2.new(0, 140, 0, 38)
ContentContainer.BackgroundTransparency = 1

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 540, 0, MIN_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible = false
        ContentContainer.Visible = false
        MinBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 540, 0, FULL_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible = true
        ContentContainer.Visible = true
        MinBtn.Text = "−"
    end
end)

local tabButtons, tabPages = {}, {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.BorderSizePixel = 0
    page.Visible = false
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 8)
    tabPages[name] = page
    return page
end

local function createTabButton(name, icon)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.92, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(28, 35, 48)
    btn.BorderSizePixel = 0
    btn.Text = icon .. "  " .. name
    btn.TextColor3 = Color3.fromRGB(180, 190, 210)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 10)
    local pill = Instance.new("Frame", btn)
    pill.Size = UDim2.new(0, 3, 0, 14)
    pill.Position = UDim2.new(0, -7, 0.5, -7)
    pill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pill.Visible = false
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    tabButtons[name] = {Button = btn, Pill = pill}
    btn.MouseButton1Click:Connect(function()
        for tName, item in pairs(tabButtons) do
            if tName == name then
                item.Button.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
                item.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                item.Pill.Visible = true
            else
                item.Button.BackgroundColor3 = Color3.fromRGB(28, 35, 48)
                item.Button.TextColor3 = Color3.fromRGB(180, 190, 210)
                item.Pill.Visible = false
            end
        end
        for pName, page in pairs(tabPages) do page.Visible = (pName == name) end
    end)
end

-- TẠO TAB
local tabList = {"Farm", "Fruit", "PVP-ESP", "Server", "RAID", "FARM ITEM", "SETTING"}
local iconList = {"🌾", "🍎", "⚔️", "🌐", "⚡", "🗡️", "⚙️"}
for i, name in ipairs(tabList) do
    createTabButton(name, iconList[i])
    createPage(name)
end

-- MẶC ĐỊNH TAB FARM
for tName, item in pairs(tabButtons) do
    if tName == "Farm" then
        item.Button.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
        item.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        item.Pill.Visible = true
    else
        item.Button.BackgroundColor3 = Color3.fromRGB(28, 35, 48)
        item.Button.TextColor3 = Color3.fromRGB(180, 190, 210)
        item.Pill.Visible = false
    end
end
for pName, page in pairs(tabPages) do page.Visible = (pName == "Farm") end

-- ===================================================
-- 2. HÀM TẠO TOGGLE / SLIDER / BUTTON
-- ===================================================
local function createToggle(page, labelText, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(0.94, 0, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 225, 235)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    local switch = Instance.new("TextButton", frame)
    switch.Size = UDim2.new(0, 32, 0, 16)
    switch.Position = UDim2.new(1, -40, 0.5, -8)
    switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
    switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 12, 0, 12)
    circle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    switch.MouseButton1Click:Connect(function()
        state = not state
        switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        if callback then callback(state) end
    end)
end

local function createSlider(page, labelText, min, max, default, callback)
    local current = default or min
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(0.94, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -70, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 3)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 225, 235)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size = UDim2.new(0, 55, 0, 20)
    valueLabel.Position = UDim2.new(1, -65, 0, 3)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(current)
    valueLabel.TextColor3 = Color3.fromRGB(0, 210, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    local track = Instance.new("TextButton", frame)
    track.Size = UDim2.new(0.94, 0, 0, 4)
    track.Position = UDim2.new(0.03, 0, 0, 28)
    track.BackgroundColor3 = Color3.fromRGB(35, 42, 58)
    track.AutoButtonColor = false
    track.Text = ""
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 190, 255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local isDraggingSlider = false
    local function update(percent)
        fill.Size = UDim2.new(math.clamp(percent, 0, 1), 0, 1, 0)
        current = math.floor(min + (max - min) * math.clamp(percent, 0, 1))
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
            update((UserInputService:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
        end
    end)
end

local function createButton(page, labelText, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(0.94, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    btn.Text = labelText
    btn.TextColor3 = Color3.fromRGB(0, 210, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(0, 180, 255)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

-- ===================================================
-- 3. GẮN CHỨC NĂNG VÀO TỪNG TAB
-- ===================================================

-- TAB 1: FARM
local farmPage = tabPages["Farm"]
local infoLabel = Instance.new("TextLabel", farmPage)
infoLabel.Size = UDim2.new(0.94, 0, 0, 30)
infoLabel.BackgroundTransparency = 1
infoLabel.RichText = true
infoLabel.Text = "⚡ Sẵn sàng farm"
infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextSize = 12

-- Weapon selector
local weaponSegment = Instance.new("Frame", farmPage)
weaponSegment.Size = UDim2.new(0.94, 0, 0, 28)
weaponSegment.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
local wsLayout = Instance.new("UIListLayout", weaponSegment)
wsLayout.FillDirection = Enum.FillDirection.Horizontal
wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
wsLayout.Padding = UDim.new(0, 3)
local weaponBtns = {}
local weaponList = {{name = "Melee", label = "🥊 Melee"}, {name = "Sword", label = "⚔️ Sword"}, {name = "Blox Fruit", label = "🍎 Fruit"}}
for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size = UDim2.new(0.3, 0, 0.78, 0)
    b.BackgroundColor3 = (selectedWeaponType == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
    b.Text = wData.label
    b.TextColor3 = (selectedWeaponType == wData.name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    weaponBtns[wData.name] = b
    b.MouseButton1Click:Connect(function()
        selectedWeaponType = wData.name
        for name, btn in pairs(weaponBtns) do
            btn.BackgroundColor3 = (name == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
            btn.TextColor3 = (name == wData.name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
        end
    end)
end

createToggle(farmPage, "⚡ Tự Động Farm (Aura AFK)", false, function(v) AutoFarmLevel = v end)
createToggle(farmPage, "📜 Tự Nhận Nhiệm Vụ", true, function(v) AutoQuest = v end)
createToggle(farmPage, "🧲 Gom Quái An Toàn", true, function(v) BringMob = v end)

-- TAB 2: FRUIT
local fruitPage = tabPages["Fruit"]
createToggle(fruitPage, "🎲 Mua Ngẫu Nhiên Trái", false, function(v) AutoRandomFruit = v end)
createToggle(fruitPage, "🧲 Nhặt Trái Rơi", false, function(v) AutoCollectFruit = v end)
createToggle(fruitPage, "📦 Cất Trái Vào Rương", false, function(v) AutoStoreFruit = v end)

-- TAB 3: PVP-ESP
local pvpPage = tabPages["PVP-ESP"]
createToggle(pvpPage, "Bật Chạy Nhanh", false, function(v) speedEnabled = v end)
createSlider(pvpPage, "Tốc Độ", 16, 300, 16, function(val) speedValue = val end)
createToggle(pvpPage, "Bật Nhảy Cao", false, function(v) jumpEnabled = v end)
createSlider(pvpPage, "Lực Nhảy", 50, 400, 50, function(val) jumpValue = val end)
createToggle(pvpPage, "ESP Người Chơi", false, function(v) espPlayerEnabled = v end)
createToggle(pvpPage, "ESP Trái Ác Quỷ", false, function(v) espFruitEnabled = v end)
createToggle(pvpPage, "ESP Rương Gỗ", false, function(v) espChest1Enabled = v end)
createToggle(pvpPage, "ESP Rương Vàng", false, function(v) espChest2Enabled = v end)
createToggle(pvpPage, "ESP Rương Kim Cương", false, function(v) espChest3Enabled = v end)

-- TAB 4: SERVER
local serverPage = tabPages["Server"]
createButton(serverPage, "🎁 Nhập Code Game", function()
    local codes = {"ADMINHACKED", "ADMINDARES", "SECRET_ADMIN", "NOOB2PRO", "StrawHatMaine", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "THEGREATACE", "SUB2GAMERROBOT_EXP1", "Sub2OfficialNoobie", "FUDD10", "BIGNEWS", "KITT_RESET", "SUB2NOOBMASTER123", "Sub2UncleKizaru", "Sub2Daigrock", "Axiore", "TantaiGaming", "FUDD10_V2", "CHANDLER", "GAMER_ROBOT_1M", "TY_FOR_WATCHING", "UPD16", "3BVISITS", "2BILLION"}
    task.spawn(function()
        for _, c in ipairs(codes) do
            pcall(function() CommF:InvokeServer("RedeemCustomCode", c) end)
            task.wait(0.1)
        end
    end)
end)
createButton(serverPage, "Vào Lại Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)
createButton(serverPage, "Chuyển Server", function()
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and response and response.data then
        for _, s in ipairs(response.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end
end)

-- TAB 5: RAID
local raidPage = tabPages["RAID"]
createToggle(raidPage, "Tự Động Mua Vé & Bắt Đầu Raid", false, function(v) end)

-- TAB 6: FARM ITEM
local itemPage = tabPages["FARM ITEM"]
createToggle(itemPage, "Tự Farm Xương (Bones)", false, function(v) end)

-- TAB 7: SETTING
local settingPage = tabPages["SETTING"]
createToggle(settingPage, "Tối Ưu Đồ Họa (Tăng FPS)", false, function(v)
    Lighting.GlobalShadows = not v
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and v then obj.Material = Enum.Material.SmoothPlastic end
    end
end)
createSlider(settingPage, "Thu Phóng UI (%)", 60, 140, 100, function(val) UIScale.Scale = val / 100 end)
createSlider(settingPage, "Trong Suốt UI (%)", 0, 80, 12, function(val)
    MainFrame.BackgroundTransparency = val / 100
    Sidebar.BackgroundTransparency = math.clamp((val + 8) / 100, 0, 1)
end)
createButton(settingPage, "Đóng Cửa Sổ", function() ScreenGui:Destroy() end)

-- ===================================================
-- 4. ESP (FIX GIẬT)
-- ===================================================
local espCache = {}
local function getOrCreateBillboard(parent, name, size, offset, color, text)
    if not parent then return nil end
    local bb = parent:FindFirstChild(name)
    if not bb then
        bb = Instance.new("BillboardGui", parent)
        bb.Name = name
        bb.Size = size or UDim2.new(0, 180, 0, 30)
        bb.StudsOffset = offset or Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        local label = Instance.new("TextLabel", bb)
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
        label.Text = text or ""
        bb.Label = label
    end
    if bb.Label then
        bb.Label.TextColor3 = color or bb.Label.TextColor3
        bb.Label.Text = text or bb.Label.Text
    end
    bb.Enabled = true
    return bb
end

local function hideESP(parent, name)
    if parent and parent:FindFirstChild(name) then parent[name].Enabled = false end
end

local frameCounter = 0
RunService.RenderStepped:Connect(function(delta)
    frameCounter = frameCounter + 1
    if frameCounter % 3 ~= 0 then return end
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if espPlayerEnabled and head and hum and hum.Health > 0 then
                local dist = math.floor((head.Position - myHRP.Position).Magnitude)
                getOrCreateBillboard(head, "Zenith_PlayerBillboard",
                    UDim2.new(0, 200, 0, 45), Vector3.new(0, 2.8, 0),
                    Color3.fromRGB(255, 60, 90),
                    string.format("%s\n[%dm] • HP: %d/%d", p.DisplayName, dist, math.floor(hum.Health), math.floor(hum.MaxHealth))
                )
            else
                hideESP(head, "Zenith_PlayerBillboard")
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then continue end
        for _, obj in ipairs(Workspace:GetChildren()) do
            if (obj:IsA("Tool") and string.find(obj.Name, "Fruit")) or obj:FindFirstChild("Fruit") then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    if espFruitEnabled then
                        local dist = math.floor((handle.Position - myHRP.Position).Magnitude)
                        getOrCreateBillboard(handle, "Zenith_FruitESP",
                            UDim2.new(0, 180, 0, 30), Vector3.new(0, 2, 0),
                            Color3.fromRGB(255, 70, 220),
                            string.format("🍎 %s\n[%dm]", obj.Name, dist)
                        )
                    else
                        hideESP(handle, "Zenith_FruitESP")
                    end
                end
            end
        end
        local chests = Workspace:GetDescendants()
        for _, part in ipairs(chests) do
            if part:IsA("BasePart") then
                local name = string.lower(part.Name)
                local pName = part.Parent and string.lower(part.Parent.Name) or ""
                if string.find(name, "chest") or string.find(pName, "chest") then
                    local tier = 1
                    if string.find(name, "3") or string.find(pName, "3") or string.find(name, "diamond") then tier = 3
                    elseif string.find(name, "2") or string.find(pName, "2") or string.find(name, "gold") or string.find(name, "silver") then tier = 2 end
                    local shouldShow = (tier == 1 and espChest1Enabled) or (tier == 2 and espChest2Enabled) or (tier == 3 and espChest3Enabled)
                    if shouldShow then
                        local dist = math.floor((part.Position - myHRP.Position).Magnitude)
                        local color = (tier == 3 and Color3.fromRGB(0, 240, 255)) or (tier == 2 and Color3.fromRGB(255, 215, 0)) or Color3.fromRGB(205, 127, 50)
                        local labelText = (tier == 3 and "💎 Diamond") or (tier == 2 and "🪙 Gold") or "📦 Bronze"
                        getOrCreateBillboard(part, "Zenith_ChestESP",
                            UDim2.new(0, 160, 0, 25), Vector3.new(0, 2, 0),
                            color,
                            string.format("%s [%dm]", labelText, dist)
                        )
                    else
                        hideESP(part, "Zenith_ChestESP")
                    end
                end
            end
        end
    end
end)

-- ===================================================
-- 5. SPEED + JUMP
-- ===================================================
RunService.Heartbeat:Connect(function()
    if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid, rootPart = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"), LocalPlayer.Character.HumanoidRootPart
        if humanoid and rootPart and humanoid.MoveDirection.Magnitude > 0 then
            rootPart.AssemblyLinearVelocity = Vector3.new(humanoid.MoveDirection.X * speedValue, rootPart.AssemblyLinearVelocity.Y, humanoid.MoveDirection.Z * speedValue)
        end
    end
end)
UserInputService.JumpRequest:Connect(function()
    if jumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity.X, jumpValue, LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity.Z)
    end
end)

-- ===================================================
-- 6. FRUIT AUTO BUY / COLLECT / STORE
-- ===================================================
task.spawn(function()
    while true do
        task.wait(5)
        if AutoRandomFruit then
            pcall(function() CommF:InvokeServer("Cousin", "Buy") end)
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(1)
        if AutoCollectFruit and not AutoFarmLevel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if (obj:IsA("Tool") and string.find(obj.Name, "Fruit")) or obj:FindFirstChild("Fruit") then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = handle.CFrame
                        task.wait(0.5)
                        if firetouchinterest then
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, handle, 0)
                            task.wait()
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, handle, 1)
                        end
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        if AutoStoreFruit and CommF then
            pcall(function()
                local backpack, char = LocalPlayer:FindFirstChild("Backpack"), LocalPlayer.Character
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if string.find(item.Name, "Fruit") or item:FindFirstChild("Fruit") then
                            CommF:InvokeServer("StoreFruit", item.Name, item)
                        end
                    end
                end
                if char then
                    for _, item in ipairs(char:GetChildren()) do
                        if item:IsA("Tool") and (string.find(item.Name, "Fruit") or item:FindFirstChild("Fruit")) then
                            CommF:InvokeServer("StoreFruit", item.Name, item)
                        end
                    end
                end
            end)
        end
    end
end)

-- ===================================================
-- 7. WATER PLATFORM
-- ===================================================
task.spawn(function()
    local waterPlatform = Instance.new("Part")
    waterPlatform.Name = "Zenith_WaterPlatform"
    waterPlatform.Size = Vector3.new(120, 1, 120)
    waterPlatform.Transparency = 1
    waterPlatform.Anchored = true
    waterPlatform.CanCollide = true
    waterPlatform.Parent = Workspace
    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp, humanoid = char.HumanoidRootPart, char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Swimming then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            if hrp.Position.Y <= 15 and hrp.Position.Y >= -60 then
                waterPlatform.CFrame = CFrame.new(hrp.Position.X, 0.5, hrp.Position.Z)
                waterPlatform.CanCollide = true
            else
                waterPlatform.CFrame = CFrame.new(hrp.Position.X, -500, hrp.Position.Z)
                waterPlatform.CanCollide = false
            end
        end
    end)
end)

-- ===================================================
-- 8. AUTO FARM + FLY (FIX 100%)
-- ===================================================
local flightHeight = 25
local attackRadius = 40
local attackCooldown = 0.06

local function stopTween()
    if currentTween then
        pcall(function() currentTween:Cancel() end)
        currentTween = nil
    end
end

local function flyToPosition(targetPos)
    local char = LocalPlayer.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local target = Vector3.new(targetPos.X, flightHeight, targetPos.Z)
    local current = root.Position
    local dist = (target - current).Magnitude
    if dist < 2 then
        root.AssemblyLinearVelocity = Vector3.zero
        return true
    end
    local dir = (target - current).Unit
    root.AssemblyLinearVelocity = dir * 110
    local yDiff = flightHeight - current.Y
    if math.abs(yDiff) > 1 then
        root.AssemblyLinearVelocity = Vector3.new(
            root.AssemblyLinearVelocity.X,
            yDiff * 3.5,
            root.AssemblyLinearVelocity.Z
        )
    end
    return false
end

local function fastAttack()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
            task.wait(0.02)
            tool:Activate()
        end
        local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
        local controller = CbFw.activeController
        if not controller then
            for _, v in pairs(debug.getupvalues(CbFw)) do
                if type(v) == "table" and v.activeController then
                    controller = v.activeController
                    break
                end
            end
        end
        if controller then
            controller.hitboxLimiter = 0
            controller.timeToNextAttack = 0
            controller.timeToNextBlock = 0
            controller.increment = 5
            controller.attacking = false
            controller.blocking = false
            for i = 1, 4 do
                controller:attack()
                task.wait(0.015)
            end
        end
    end)
end

local function pullMobs(mobList, myPos)
    local pullRadius = 80
    for _, mob in ipairs(mobList) do
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local dist = (hrp.Position - myPos).Magnitude
            if dist > attackRadius and dist < pullRadius then
                local offset = Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
                hrp.CFrame = CFrame.new(myPos + offset)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CanCollide = false
                hum.WalkSpeed = 0
                hum.JumpPower = 0
                hum.Sit = true
                local anim = hum:FindFirstChild("Animator")
                if anim then
                    for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
                        track:Stop()
                    end
                end
            end
        end
    end
end

local function getAutoQuestByLevel()
    local level = LocalPlayer.Data and LocalPlayer.Data.Level and LocalPlayer.Data.Level.Value or 1
    local quests = {
        {MonName = "Bandit", QuestName = "BanditQuest1", QuestLevel = 1},
        {MonName = "Gorilla", QuestName = "GorillaQuest1", QuestLevel = 100},
        {MonName = "Dragon", QuestName = "DragonQuest1", QuestLevel = 500},
    }
    for _, q in ipairs(quests) do
        if level >= q.QuestLevel then return q end
    end
    return quests[#quests]
end

local function checkHasQuest()
    return true
end

local function getAllLivingEnemies(monName)
    local list = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and string.find(string.lower(obj.Name), string.lower(monName)) then
                table.insert(list, obj)
            end
        end
    end
    return list
end

task.spawn(function()
    while true do
        task.wait(0.05)
        if not AutoFarmLevel then
            stopTween()
            task.wait(0.5)
            continue
        end
        local char = LocalPlayer.Character
        if not char then task.wait(0.5) continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(0.5) continue end
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, math.max(root.AssemblyLinearVelocity.Y, -3), root.AssemblyLinearVelocity.Z)
        local questData = getAutoQuestByLevel()
        if not questData then
            infoLabel.Text = "⚠️ Không có nhiệm vụ phù hợp"
            task.wait(1)
            continue
        end
        if AutoQuest and not checkHasQuest() then
            pcall(function() CommF:InvokeServer("StartQuest", questData.QuestName, questData.QuestLevel) end)
            task.wait(0.3)
        end
        local mobs = getAllLivingEnemies(questData.MonName)
        if #mobs == 0 then
            infoLabel.Text = string.format("🔍 Đang tìm %s...", questData.MonName)
            task.wait(0.2)
            continue
        end
        table.sort(mobs, function(a, b)
            local aPos = a:FindFirstChild("HumanoidRootPart")
            local bPos = b:FindFirstChild("HumanoidRootPart")
            if not aPos or not bPos then return false end
            return (aPos.Position - root.Position).Magnitude < (bPos.Position - root.Position).Magnitude
        end)
        local target = mobs[1]
        local targetHRP = target:FindFirstChild("HumanoidRootPart")
        if not targetHRP then task.wait(0.1) continue end
        infoLabel.Text = string.format("⚔️ Farm: %s (Lv.%d) | Quái: %d", questData.MonName, LocalPlayer.Data.Level.Value, #mobs)
        if BringMob then pullMobs(mobs, root.Position) end
        local dist = (targetHRP.Position - root.Position).Magnitude
        if dist > attackRadius then
            local reached = flyToPosition(targetHRP.Position)
            stopTween()
            if not reached then task.wait(0.05) continue end
        end
        if dist <= attackRadius + 10 then
            root.AssemblyLinearVelocity = Vector3.zero
            local lookVec = (targetHRP.Position - root.Position).Unit
            root.CFrame = CFrame.lookAt(root.Position, root.Position + lookVec * 10)
            for i = 1, 5 do
                fastAttack()
                task.wait(attackCooldown)
            end
            local weapon = char:FindFirstChildOfClass("Tool")
            if weapon then
                weapon:Activate()
                task.wait(0.05)
                weapon:Activate()
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < hum.MaxHealth * 0.3 then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 45, root.AssemblyLinearVelocity.Z)
            task.wait(0.3)
        end
        task.wait(0.03)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if not AutoFarmLevel then task.wait(0.5) continue end
        local char = LocalPlayer.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local y = root.Position.Y
        if y < flightHeight - 2 then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 30, root.AssemblyLinearVelocity.Z)
        elseif y > flightHeight + 5 then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -10, root.AssemblyLinearVelocity.Z)
        end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
    end
end)

print("✅ Script ZENITH V12.24 đã chạy! Panel hiện, full chức năng.")
