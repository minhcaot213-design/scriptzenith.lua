-- [[ ZENITH BLOX FRUIT - V13.0 (FIX: FLY + ATTACK + QUEST) ]] --

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

-- ===================================================
-- BIẾN TOÀN CỤC
-- ===================================================
local selectedWeaponType = "Melee"
local AutoFarmLevel, AutoQuest, BringMob = false, true, true
local espPlayerEnabled, espFruitEnabled = false, false
local espChest1Enabled, espChest2Enabled, espChest3Enabled = false, false, false
local speedValue, speedEnabled = 16, false
local jumpValue, jumpEnabled = 50, false
local AutoRandomFruit, AutoCollectFruit, AutoStoreFruit = false, false, false

-- THÔNG SỐ FARM
local flightHeight = 28
local attackCooldown = 0.04
local attackCount = 6

-- NGÔN NGỮ
local currentLang = "VI"
local Lang = {
    VI = {
        title = "ZYROX VN <font color='#00d2ff'>• V13.0</font>",
        tab_farm = "Farm", tab_fruit = "Trái Ác Quỷ", tab_pvp = "PVP & ESP", tab_server = "Máy Chủ",
        tab_raid = "Raid", tab_item = "Farm Item", tab_setting = "Cài Đặt",
        auto_farm = "⚡ AFK Farm (Bay + Đánh)", auto_quest = "📜 Tự Nhận Nhiệm Vụ", bring_mob = "🧲 Gom Quái",
        flight_height = "🏔️ Chiều Cao Bay", attack_speed = "⚡ Tốc Độ Đánh (s)",
        fruit_buy = "🎲 Mua Trái", fruit_collect = "🧲 Nhặt Trái", fruit_store = "📦 Cất Trái",
        speed_toggle = "Bật Chạy Nhanh", speed_slider = "Tốc Độ", jump_toggle = "Bật Nhảy Cao", jump_slider = "Lực Nhảy",
        player_esp = "ESP Người Chơi", fruit_esp = "ESP Trái", chest_wood = "ESP Rương Gỗ", chest_gold = "ESP Rương Vàng", chest_diamond = "ESP Rương Kim Cương",
        redeem_codes = "🎁 Nhập Code", rejoin_btn = "Vào Lại Server", serverhop_btn = "Chuyển Server",
        auto_raid = "Tự Động Raid", auto_bones = "Tự Farm Xương",
        ui_scale = "Thu Phóng UI", ui_transparency = "Trong Suốt UI", fix_lag = "Tối Ưu FPS", close_hub = "Đóng",
        lang_toggle = "🌐 Ngôn Ngữ"
    },
    EN = {
        title = "ZYROX VN <font color='#00d2ff'>• V13.0</font>",
        tab_farm = "Farm", tab_fruit = "Devil Fruit", tab_pvp = "PVP & ESP", tab_server = "Server",
        tab_raid = "Raid", tab_item = "Item Farm", tab_setting = "Settings",
        auto_farm = "⚡ AFK Farm (Fly + Attack)", auto_quest = "📜 Auto Quest", bring_mob = "🧲 Bring Mobs",
        flight_height = "🏔️ Flight Height", attack_speed = "⚡ Attack Speed (s)",
        fruit_buy = "🎲 Buy Fruit", fruit_collect = "🧲 Collect Fruit", fruit_store = "📦 Store Fruit",
        speed_toggle = "WalkSpeed", speed_slider = "Speed", jump_toggle = "High Jump", jump_slider = "Jump Power",
        player_esp = "Player ESP", fruit_esp = "Fruit ESP", chest_wood = "Wood Chest", chest_gold = "Gold Chest", chest_diamond = "Diamond Chest",
        redeem_codes = "🎁 Redeem Codes", rejoin_btn = "Rejoin", serverhop_btn = "Server Hop",
        auto_raid = "Auto Raid", auto_bones = "Auto Bones",
        ui_scale = "UI Scale", ui_transparency = "Transparency", fix_lag = "Boost FPS", close_hub = "Close",
        lang_toggle = "🌐 Language"
    }
}

-- ===================================================
-- 1. UI
-- ===================================================
local UI_NAME = "ZenithBloxFruit_Zyrox_V13"

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
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- NÚT Z
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

-- MAIN FRAME
local FULL_HEIGHT = 460
local MIN_HEIGHT = 38
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, FULL_HEIGHT)
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

-- KÉO THẢ
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

-- TOPBAR
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 18, 26)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 260, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.RichText = true
Title.Text = Lang[currentLang].title
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

FloatingButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatingButton.Visible = false
end)

-- SIDEBAR
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(13, 15, 22)

local TabListLayout = Instance.new("UIListLayout", Sidebar)
TabListLayout.Padding = UDim.new(0, 3)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 6)

-- CONTENT CONTAINER
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -140, 1, -38)
ContentContainer.Position = UDim2.new(0, 140, 0, 38)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ClipsDescendants = true

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 560, 0, MIN_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible = false
        ContentContainer.Visible = false
        MinBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 560, 0, FULL_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible = true
        ContentContainer.Visible = true
        MinBtn.Text = "−"
    end
end)

-- TAB
local tabButtons, tabPages, allTextLabels = {}, {}, {}

local function createPage(name)
    local page = Instance.new("Frame", ContentContainer)
    page.Size = UDim2.new(1, 0, 0, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.AutomaticSize = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 6)
    tabPages[name] = page
    return page
end

local function createTabButton(name, icon, key)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.92, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(28, 35, 48)
    btn.BorderSizePixel = 0
    btn.Text = icon .. "  " .. Lang[currentLang][key]
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
    tabButtons[name] = {Button = btn, Pill = pill, Key = key, Icon = icon}
    table.insert(allTextLabels, {obj = btn, key = key, isTab = true, icon = icon})
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

local tabConfigs = {
    {key = "Farm", icon = "🌾", langKey = "tab_farm"},
    {key = "Fruit", icon = "🍎", langKey = "tab_fruit"},
    {key = "PVP-ESP", icon = "⚔️", langKey = "tab_pvp"},
    {key = "Server", icon = "🌐", langKey = "tab_server"},
    {key = "RAID", icon = "⚡", langKey = "tab_raid"},
    {key = "FARM ITEM", icon = "🗡️", langKey = "tab_item"},
    {key = "SETTING", icon = "⚙️", langKey = "tab_setting"},
}
for _, cfg in ipairs(tabConfigs) do
    createTabButton(cfg.key, cfg.icon, cfg.langKey)
    createPage(cfg.key)
end

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
-- 2. UI COMPONENTS
-- ===================================================
local function createToggle(page, labelKey, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(0.94, 0, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
    frame.AutomaticSize = Enum.AutomaticSize.None
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = Lang[currentLang][labelKey]
    label.TextColor3 = Color3.fromRGB(220, 225, 235)
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    table.insert(allTextLabels, {obj = label, key = labelKey})
    local switch = Instance.new("TextButton", frame)
    switch.Size = UDim2.new(0, 30, 0, 15)
    switch.Position = UDim2.new(1, -38, 0.5, -7.5)
    switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
    switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 11, 0, 11)
    circle.Position = state and UDim2.new(1, -13, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    switch.MouseButton1Click:Connect(function()
        state = not state
        switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -13, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
        if callback then callback(state) end
    end)
end

local function createSlider(page, labelKey, min, max, default, callback, isFloat)
    local current = default or min
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(0.94, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
    frame.AutomaticSize = Enum.AutomaticSize.None
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -70, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = Lang[currentLang][labelKey]
    label.TextColor3 = Color3.fromRGB(220, 225, 235)
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(allTextLabels, {obj = label, key = labelKey})
    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size = UDim2.new(0, 50, 0, 18)
    valueLabel.Position = UDim2.new(1, -58, 0, 2)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = isFloat and string.format("%.2f", current) or tostring(current)
    valueLabel.TextColor3 = Color3.fromRGB(0, 210, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 10
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    local track = Instance.new("TextButton", frame)
    track.Size = UDim2.new(0.94, 0, 0, 3)
    track.Position = UDim2.new(0.03, 0, 0, 26)
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
        if isFloat then
            current = min + (max - min) * math.clamp(percent, 0, 1)
            valueLabel.Text = string.format("%.2f", current)
        else
            current = math.floor(min + (max - min) * math.clamp(percent, 0, 1))
            valueLabel.Text = tostring(current)
        end
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

local function createButton(page, labelKey, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(0.94, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    btn.Text = Lang[currentLang][labelKey]
    btn.TextColor3 = Color3.fromRGB(0, 210, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 10
    btn.AutomaticSize = Enum.AutomaticSize.None
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(0, 180, 255)
    table.insert(allTextLabels, {obj = btn, key = labelKey})
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

local function setLanguage(lang)
    currentLang = lang
    Title.Text = Lang[currentLang].title
    for _, item in ipairs(allTextLabels) do
        if item.obj and item.obj.Parent then
            if item.isTab then
                item.obj.Text = item.icon .. "  " .. Lang[currentLang][item.key]
            else
                item.obj.Text = Lang[currentLang][item.key]
            end
        end
    end
end

-- ===================================================
-- 3. GẮN CHỨC NĂNG VÀO TAB
-- ===================================================

-- TAB FARM
local farmPage = tabPages["Farm"]
local infoLabel = Instance.new("TextLabel", farmPage)
infoLabel.Size = UDim2.new(0.94, 0, 0, 28)
infoLabel.BackgroundTransparency = 1
infoLabel.RichText = true
infoLabel.Text = "⚡ Sẵn sàng farm"
infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextSize = 11

local weaponSegment = Instance.new("Frame", farmPage)
weaponSegment.Size = UDim2.new(0.94, 0, 0, 26)
weaponSegment.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 5)
local wsLayout = Instance.new("UIListLayout", weaponSegment)
wsLayout.FillDirection = Enum.FillDirection.Horizontal
wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
wsLayout.Padding = UDim.new(0, 2)

local weaponBtns = {}
local weaponList = {
    {name = "Melee", label = "🥊"},
    {name = "Sword", label = "⚔️"},
    {name = "Blox Fruit", label = "🍎"}
}
for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size = UDim2.new(0.3, 0, 0.8, 0)
    b.BackgroundColor3 = (selectedWeaponType == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
    b.Text = wData.label
    b.TextColor3 = (selectedWeaponType == wData.name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 9
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
    weaponBtns[wData.name] = b
    b.MouseButton1Click:Connect(function()
        selectedWeaponType = wData.name
        for name, btn in pairs(weaponBtns) do
            btn.BackgroundColor3 = (name == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
            btn.TextColor3 = (name == wData.name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
        end
    end)
end

createToggle(farmPage, "auto_farm", false, function(v) AutoFarmLevel = v end)
createToggle(farmPage, "auto_quest", true, function(v) AutoQuest = v end)
createToggle(farmPage, "bring_mob", true, function(v) BringMob = v end)
createSlider(farmPage, "flight_height", 10, 50, 28, function(val) flightHeight = val print("✈️ Độ cao bay: " .. val) end, false)
createSlider(farmPage, "attack_speed", 0.01, 0.2, 0.04, function(val) attackCooldown = val print("⚡ Tốc độ đánh: " .. string.format("%.2f", val) .. "s") end, true)

-- TAB FRUIT
local fruitPage = tabPages["Fruit"]
createToggle(fruitPage, "fruit_buy", false, function(v) AutoRandomFruit = v end)
createToggle(fruitPage, "fruit_collect", false, function(v) AutoCollectFruit = v end)
createToggle(fruitPage, "fruit_store", false, function(v) AutoStoreFruit = v end)

-- TAB PVP-ESP
local pvpPage = tabPages["PVP-ESP"]
createToggle(pvpPage, "speed_toggle", false, function(v) speedEnabled = v end)
createSlider(pvpPage, "speed_slider", 16, 300, 16, function(val) speedValue = val end, false)
createToggle(pvpPage, "jump_toggle", false, function(v) jumpEnabled = v end)
createSlider(pvpPage, "jump_slider", 50, 400, 50, function(val) jumpValue = val end, false)
createToggle(pvpPage, "player_esp", false, function(v) espPlayerEnabled = v end)
createToggle(pvpPage, "fruit_esp", false, function(v) espFruitEnabled = v end)
createToggle(pvpPage, "chest_wood", false, function(v) espChest1Enabled = v end)
createToggle(pvpPage, "chest_gold", false, function(v) espChest2Enabled = v end)
createToggle(pvpPage, "chest_diamond", false, function(v) espChest3Enabled = v end)

-- TAB SERVER
local serverPage = tabPages["Server"]
createButton(serverPage, "redeem_codes", function()
    local codes = {"ADMINHACKED", "ADMINDARES", "SECRET_ADMIN", "NOOB2PRO", "StrawHatMaine", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "THEGREATACE", "SUB2GAMERROBOT_EXP1", "Sub2OfficialNoobie", "FUDD10", "BIGNEWS", "KITT_RESET", "SUB2NOOBMASTER123", "Sub2UncleKizaru", "Sub2Daigrock", "Axiore", "TantaiGaming", "FUDD10_V2", "CHANDLER", "GAMER_ROBOT_1M", "TY_FOR_WATCHING", "UPD16", "3BVISITS", "2BILLION"}
    task.spawn(function() for _, c in ipairs(codes) do pcall(function() CommF:InvokeServer("RedeemCustomCode", c) end) task.wait(0.1) end end)
end)
createButton(serverPage, "rejoin_btn", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
createButton(serverPage, "serverhop_btn", function()
    local success, response = pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end)
    if success and response and response.data then
        for _, s in ipairs(response.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end
end)

-- TAB RAID
createToggle(tabPages["RAID"], "auto_raid", false, function(v) end)

-- TAB FARM ITEM
createToggle(tabPages["FARM ITEM"], "auto_bones", false, function(v) end)

-- TAB SETTING
local settingPage = tabPages["SETTING"]
createToggle(settingPage, "fix_lag", false, function(v)
    Lighting.GlobalShadows = not v
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and v then obj.Material = Enum.Material.SmoothPlastic end
    end
end)
createSlider(settingPage, "ui_scale", 60, 140, 100, function(val) UIScale.Scale = val / 100 end, false)
createSlider(settingPage, "ui_transparency", 0, 80, 12, function(val)
    MainFrame.BackgroundTransparency = val / 100
    Sidebar.BackgroundTransparency = math.clamp((val + 8) / 100, 0, 1)
end, false)

local langBtn = Instance.new("TextButton", settingPage)
langBtn.Size = UDim2.new(0.94, 0, 0, 30)
langBtn.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
langBtn.Text = "🌐 " .. (currentLang == "VI" and "Tiếng Việt" or "English")
langBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
langBtn.Font = Enum.Font.GothamMedium
langBtn.TextSize = 10
Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", langBtn).Color = Color3.fromRGB(0, 180, 255)
langBtn.MouseButton1Click:Connect(function()
    if currentLang == "VI" then setLanguage("EN") langBtn.Text = "🌐 English"
    else setLanguage("VI") langBtn.Text = "🌐 Tiếng Việt" end
end)

createButton(settingPage, "close_hub", function() ScreenGui:Destroy() end)

-- ===================================================
-- 4. ESP
-- ===================================================
local espBillboards = {}

local function getOrCreateESP(parent, name, size, offset, color)
    if not parent then return nil end
    local bb = espBillboards[parent .. name]
    if bb and bb.Parent then bb.Enabled = true return bb end
    bb = Instance.new("BillboardGui", parent)
    bb.Name = name
    bb.Size = size or UDim2.new(0, 160, 0, 28)
    bb.StudsOffset = offset or Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.Enabled = true
    local label = Instance.new("TextLabel", bb)
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.Text = ""
    bb.Label = label
    espBillboards[parent .. name] = bb
    return bb
end

local function hideESP(parent, name)
    if parent then local bb = espBillboards[parent .. name] if bb then bb.Enabled = false end end
end

task.spawn(function()
    while true do
        task.wait(0.5)
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then continue end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local head = p.Character:FindFirstChild("Head")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if espPlayerEnabled and head and hum and hum.Health > 0 then
                    local dist = math.floor((head.Position - myHRP.Position).Magnitude)
                    local bb = getOrCreateESP(head, "Zenith_PlayerBillboard", UDim2.new(0, 180, 0, 40), Vector3.new(0, 2.8, 0), Color3.fromRGB(255, 60, 90))
                    if bb and bb.Label then
                        bb.Label.Text = string.format("%s\n[%dm] HP: %d/%d", p.DisplayName, dist, math.floor(hum.Health), math.floor(hum.MaxHealth))
                        bb.Enabled = true
                    end
                else
                    hideESP(head, "Zenith_PlayerBillboard")
                end
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
                        local bb = getOrCreateESP(handle, "Zenith_FruitESP", UDim2.new(0, 160, 0, 28), Vector3.new(0, 2, 0), Color3.fromRGB(255, 70, 220))
                        if bb and bb.Label then
                            bb.Label.Text = string.format("🍎 %s\n[%dm]", obj.Name, dist)
                            bb.Enabled = true
                        end
                    else
                        hideESP(handle, "Zenith_FruitESP")
                    end
                end
            end
        end
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                local name = string.lower(part.Name)
                local pName = part.Parent and string.lower(part.Parent.Name) or ""
                if string.find(name, "chest") or string.find(pName, "chest") then
                    local tier = 1
                    if string.find(name, "3") or string.find(pName, "3") or string.find(name, "diamond") then tier = 3
                    elseif string.find(name, "2") or string.find(pName, "2") or string.find(name, "gold") then tier = 2 end
                    local shouldShow = (tier == 1 and espChest1Enabled) or (tier == 2 and espChest2Enabled) or (tier == 3 and espChest3Enabled)
                    if shouldShow then
                        local dist = math.floor((part.Position - myHRP.Position).Magnitude)
                        local color = (tier == 3 and Color3.fromRGB(0, 240, 255)) or (tier == 2 and Color3.fromRGB(255, 215, 0)) or Color3.fromRGB(205, 127, 50)
                        local labelText = (tier == 3 and "💎 Diamond") or (tier == 2 and "🪙 Gold") or "📦 Bronze"
                        local bb = getOrCreateESP(part, "Zenith_ChestESP", UDim2.new(0, 140, 0, 24), Vector3.new(0, 2, 0), color)
                        if bb and bb.Label then
                            bb.Label.Text = string.format("%s [%dm]", labelText, dist)
                            bb.Enabled = true
                        end
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
        local hum, root = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"), LocalPlayer.Character.HumanoidRootPart
        if hum and root and hum.MoveDirection.Magnitude > 0 then
            root.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * speedValue, root.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * speedValue)
        end
    end
end)
UserInputService.JumpRequest:Connect(function()
    if jumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity.X, jumpValue, LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity.Z)
    end
end)

-- ===================================================
-- 6. FRUIT AUTO
-- ===================================================
task.spawn(function()
    while true do task.wait(5) if AutoRandomFruit then pcall(function() CommF:InvokeServer("Cousin", "Buy") end) end end
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
                        task.wait(0.3)
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
                if backpack then for _, item in ipairs(backpack:GetChildren()) do if string.find(item.Name, "Fruit") then CommF:InvokeServer("StoreFruit", item.Name, item) end end end
                if char then for _, item in ipairs(char:GetChildren()) do if item:IsA("Tool") and string.find(item.Name, "Fruit") then CommF:InvokeServer("StoreFruit", item.Name, item) end end end
            end)
        end
    end
end)

-- ===================================================
-- 7. WATER PLATFORM
-- ===================================================
task.spawn(function()
    local wp = Instance.new("Part")
    wp.Name, wp.Size, wp.Transparency, wp.Anchored, wp.CanCollide = "Zenith_WaterPlatform", Vector3.new(120, 1, 120), 1, true, true
    wp.Parent = Workspace
    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp, hum = char.HumanoidRootPart, char:FindFirstChildOfClass("Humanoid")
            if hum and hum:GetState() == Enum.HumanoidStateType.Swimming then
                hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            if hrp.Position.Y <= 15 and hrp.Position.Y >= -60 then
                wp.CFrame, wp.CanCollide = CFrame.new(hrp.Position.X, 0.5, hrp.Position.Z), true
            else
                wp.CFrame, wp.CanCollide = CFrame.new(hrp.Position.X, -500, hrp.Position.Z), false
            end
        end
    end)
end)

-- ===================================================
-- 8. AUTO FARM (FIX: FLY ĐÚNG + ATTACK + QUEST)
-- ===================================================
local currentTarget = nil
local questAccepted = false

local function equipWeapon()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local function findWeapon(t)
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local list = {}
            if backpack then for _, tool in ipairs(backpack:GetChildren()) do if tool:IsA("Tool") then table.insert(list, tool) end end end
            if char then for _, tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") then table.insert(list, tool) end end end
            for _, tool in ipairs(list) do
                local n = string.lower(tool.Name)
                if t == "Melee" and (string.find(n, "melee") or string.find(n, "fist") or string.find(n, "combat") or string.find(n, "fighting")) then return tool
                elseif t == "Sword" and (string.find(n, "sword") or string.find(n, "blade") or string.find(n, "katana") or string.find(n, "cutlass") or string.find(n, "saber")) then return tool
                elseif t == "Blox Fruit" and (string.find(n, "fruit") or string.find(n, "devil") or string.find(n, "paw") or string.find(n, "buddha") or string.find(n, "light") or string.find(n, "dough")) then return tool end
            end
            return list[1]
        end
        local w = findWeapon(selectedWeaponType)
        if w and w.Parent == LocalPlayer:FindFirstChild("Backpack") then CommF:InvokeServer("EquipTool", w) task.wait(0.1) end
    end)
end

local function getEnemies(monName)
    local list = {}
    local monLower = string.lower(monName)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local objName = string.lower(obj.Name)
                if string.find(objName, monLower) or string.find(objName, string.gsub(monLower, " ", "")) then
                    table.insert(list, obj)
                end
            end
        end
    end
    return list
end

local function attackMob()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() task.wait(0.01) tool:Activate() end
        local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
        local c = CbFw.activeController
        if not c then for _, v in pairs(debug.getupvalues(CbFw)) do if type(v) == "table" and v.activeController then c = v.activeController break end end end
        if c then
            c.hitboxLimiter = 0
            c.timeToNextAttack = 0
            c.timeToNextBlock = 0
            c.increment = 10
            c.attacking = false
            c.blocking = false
            for i = 1, attackCount do c:attack() task.wait(0.008) end
        end
    end)
end

local function getQuestByLevel()
    local lv = LocalPlayer.Data and LocalPlayer.Data.Level and LocalPlayer.Data.Level.Value or 1
    local qs = {
        {MonName = "Bandit", QuestName = "BanditQuest1", QuestLevel = 1},
        {MonName = "Gorilla", QuestName = "GorillaQuest1", QuestLevel = 50},
        {MonName = "Dragon", QuestName = "DragonQuest1", QuestLevel = 120},
        {MonName = "Ice", QuestName = "IceQuest1", QuestLevel = 200},
        {MonName = "Dark", QuestName = "DarkQuest1", QuestLevel = 300},
        {MonName = "Light", QuestName = "LightQuest1", QuestLevel = 400},
        {MonName = "Dough", QuestName = "DoughQuest1", QuestLevel = 500},
    }
    for _, q in ipairs(qs) do if lv >= q.QuestLevel then return q end end
    return qs[#qs]
end

local function checkQuest()
    -- Kiểm tra quest thực tế
    local hasQuest = false
    pcall(function()
        -- Kiểm tra bằng Remote event
        local questData = CommF:InvokeServer("GetQuest")
        if questData and questData.Name and questData.Name ~= "" then
            hasQuest = true
        end
    end)
    if hasQuest then return true end
    
    -- Kiểm tra bằng PlayerGui
    local gui = LocalPlayer.PlayerGui:FindFirstChild("Quest")
    if gui and gui.Enabled then return true end
    
    -- Kiểm tra bằng biến LocalPlayer
    local questVal = LocalPlayer:FindFirstChild("Quest")
    if questVal and questVal.Value and questVal.Value ~= "" then return true end
    
    return false
end

-- FLY TO POSITION
local function flyTo(pos)
    local char = LocalPlayer.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    local targetPos = Vector3.new(pos.X, flightHeight, pos.Z)
    local currentPos = root.Position
    local dist = (targetPos - currentPos).Magnitude
    
    if dist < 3 then
        root.AssemblyLinearVelocity = Vector3.zero
        return true
    end
    
    local dir = (targetPos - currentPos).Unit
    root.AssemblyLinearVelocity = dir * 120
    
    local yDiff = flightHeight - currentPos.Y
    if math.abs(yDiff) > 1 then
        root.AssemblyLinearVelocity = Vector3.new(
            root.AssemblyLinearVelocity.X,
            yDiff * 4,
            root.AssemblyLinearVelocity.Z
        )
    end
    return false
end

-- MAIN FARM THREAD (FIX LẶP QUEST)
task.spawn(function()
    while true do
        task.wait(0.08)
        if not AutoFarmLevel then
            currentTarget = nil
            questAccepted = false
            task.wait(0.5)
            continue
        end
        
        local char = LocalPlayer.Character
        if not char then task.wait(0.5) continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(0.5) continue end
        
        local questData = getQuestByLevel()
        if not questData then
            infoLabel.Text = "⚠️ Không có nhiệm vụ"
            task.wait(1)
            continue
        end
        
        -- NHẬN QUEST (CHỈ GỌI 1 LẦN)
        if AutoQuest then
            local hasQuest = checkQuest()
            if not hasQuest and not questAccepted then
                pcall(function()
                    CommF:InvokeServer("StartQuest", questData.QuestName, questData.QuestLevel)
                    questAccepted = true
                    infoLabel.Text = "📜 Đã nhận quest: " .. questData.MonName
                end)
                task.wait(0.5)
                -- Nếu vẫn chưa có quest, thử lại 1 lần nữa
                if not checkQuest() then
                    pcall(function()
                        CommF:InvokeServer("StartQuest", questData.QuestName, questData.QuestLevel)
                        task.wait(0.3)
                    end)
                end
            end
            -- Reset flag nếu quest đã được nhận thành công
            if checkQuest() then
                questAccepted = false
            end
        end
        
        local mobs = getEnemies(questData.MonName)
        if #mobs == 0 then
            infoLabel.Text = string.format("🔍 Tìm %s...", questData.MonName)
            currentTarget = nil
            task.wait(0.3)
            continue
        end
        
        -- Lấy quái gần nhất
        local nearest = nil
        local nearestDist = math.huge
        for _, mob in ipairs(mobs) do
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - root.Position).Magnitude
                if d < nearestDist then
                    nearestDist = d
                    nearest = mob
                end
            end
        end
        
        if not nearest then task.wait(0.1) continue end
        
        local targetHRP = nearest:FindFirstChild("HumanoidRootPart")
        if not targetHRP then task.wait(0.1) continue end
        
        local level = LocalPlayer.Data.Level.Value
        infoLabel.Text = string.format("⚔️ %s | Lv.%d | Quái: %d", questData.MonName, level, #mobs)
        
        equipWeapon()
        
        -- FLY ĐẾN QUÁI
        local dist = (targetHRP.Position - root.Position).Magnitude
        if dist > 15 then
            local reached = flyTo(targetHRP.Position)
            if not reached then
                task.wait(0.05)
                continue
            end
        end
        
        -- ĐÃ ĐẾN GẦN → ĐÁNH
        if dist <= 20 then
            -- Đứng im, giữ độ cao
            root.AssemblyLinearVelocity = Vector3.zero
            
            -- Quay mặt vào quái
            local lookVec = (targetHRP.Position - root.Position).Unit
            if lookVec.Magnitude > 0 then
                root.CFrame = CFrame.lookAt(root.Position, root.Position + lookVec * 10)
            end
            
            -- GOM QUÁI (kéo về gần)
            if BringMob then
                for _, mob in ipairs(mobs) do
                    local hrp = mob:FindFirstChild("HumanoidRootPart")
                    local hum = mob:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local d = (hrp.Position - root.Position).Magnitude
                        if d > 12 and d < 150 then
                            local off = Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
                            hrp.CFrame = CFrame.new(root.Position + off)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.CanCollide = false
                            hum.WalkSpeed = 0
                            hum.JumpPower = 0
                            hum.Sit = true
                            hum.PlatformStand = true
                            local anim = hum:FindFirstChild("Animator")
                            if anim then for _, track in ipairs(anim:GetPlayingAnimationTracks()) do track:Stop() end end
                        end
                    end
                end
            end
            
            -- ĐÁNH LIÊN TỤC
            for i = 1, 10 do
                if not AutoFarmLevel then break end
                attackMob()
                task.wait(attackCooldown)
            end
            
            local weapon = char:FindFirstChildOfClass("Tool")
            if weapon then weapon:Activate() task.wait(0.03) weapon:Activate() end
        end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < hum.MaxHealth * 0.2 then
            root.AssemblyLinearVelocity = Vector3.new(0, 40, 0)
            task.wait(0.5)
        end
    end
end)

-- DUY TRÌ ĐỘ CAO
task.spawn(function()
    while true do
        task.wait(0.05)
        if not AutoFarmLevel then task.wait(0.5) continue end
        local char = LocalPlayer.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        
        local y = root.Position.Y
        if y < flightHeight - 1 then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 20, root.AssemblyLinearVelocity.Z)
        elseif y > flightHeight + 1 then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -5, root.AssemblyLinearVelocity.Z)
        end
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
    end
end)

print("✅ ZENITH V13.0 - FULL FIX: FLY + ATTACK + QUEST")
print("📌 Bật Auto Farm, nhân vật sẽ bay đến quái và đánh")
print("📌 Kéo thanh 'Chiều Cao Bay' để chỉnh độ cao")
print("📌 Kéo thanh 'Tốc Độ Đánh' để chỉnh nhanh/chậm")
