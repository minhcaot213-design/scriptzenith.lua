-- [[ ZENITH BLOX FRUIT - V12.24 (UI CŨ + FIX AUTO FARM) ]] --

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
local flightHeight = 25
local attackCooldown = 0.04

-- NGÔN NGỮ
local currentLang = "VI"
local Lang = {
    VI = {
        title = "ZYROX VN <font color='#00d2ff'>• V12.24</font>",
        tab_farm = "Farm Level", tab_fruit = "Trái Ác Quỷ", tab_pvp = "PVP & ESP",
        tab_server = "Máy Chủ", tab_raid = "Đi Raid", tab_item = "Farm Item", tab_setting = "Cài Đặt",
        auto_farm_level = "⚡ Tự Động Farm (Aura AFK)", auto_quest = "📜 Tự Nhận Nhiệm Vụ", bring_mob = "🧲 Gom Quái An Toàn",
        flight_height = "🏔️ Chiều Cao Bay", attack_speed = "⚡ Tốc Độ Đánh (s)",
        fruit_buy = "🎲 Mua Ngẫu Nhiên Trái", fruit_collect = "🧲 Nhặt Trái Rơi", fruit_store = "📦 Cất Trái Vào Rương",
        speed_toggle = "Bật Chạy Nhanh", speed_slider = "Tốc Độ", jump_toggle = "Bật Nhảy Cao", jump_slider = "Lực Nhảy",
        player_esp = "ESP Người Chơi", fruit_esp = "ESP Trái Ác Quỷ", chest_wood = "ESP Rương Gỗ", chest_gold = "ESP Rương Vàng", chest_diamond = "ESP Rương Kim Cương",
        redeem_codes = "🎁 Nhập Code Game", rejoin_btn = "Vào Lại Server", serverhop_btn = "Chuyển Server",
        auto_raid_start = "Tự Động Mua Vé & Bắt Đầu Raid", auto_bones = "Tự Farm Xương (Bones)",
        ui_scale = "Thu Phóng UI (%)", ui_transparency = "Trong Suốt UI (%)", fix_lag = "Tối Ưu Đồ Họa (Tăng FPS)", close_hub = "Đóng Cửa Sổ",
        lang_toggle = "🌐 Ngôn Ngữ / Language"
    },
    EN = {
        title = "ZYROX VN <font color='#00d2ff'>• V12.24</font>",
        tab_farm = "Farm Level", tab_fruit = "Devil Fruit", tab_pvp = "PVP & ESP",
        tab_server = "Server", tab_raid = "Raid Hub", tab_item = "Item Farm", tab_setting = "Settings",
        auto_farm_level = "⚡ Auto Farm (Aura AFK)", auto_quest = "📜 Auto Quest", bring_mob = "🧲 Safe Bring Mobs",
        flight_height = "🏔️ Flight Height", attack_speed = "⚡ Attack Speed (s)",
        fruit_buy = "🎲 Random Fruit", fruit_collect = "🧲 Collect Fruits", fruit_store = "📦 Store Into Inventory",
        speed_toggle = "Enable WalkSpeed", speed_slider = "Speed", jump_toggle = "Enable High Jump", jump_slider = "Jump Height",
        player_esp = "Player ESP", fruit_esp = "Fruit ESP", chest_wood = "Wood Chest", chest_gold = "Gold Chest", chest_diamond = "Diamond Chest",
        redeem_codes = "🎁 Redeem Codes", rejoin_btn = "Rejoin Server", serverhop_btn = "Server Hop",
        auto_raid_start = "Auto Start Raid", auto_bones = "Auto Farm Bones",
        ui_scale = "UI Scale (%)", ui_transparency = "Transparency (%)", fix_lag = "Boost FPS", close_hub = "Close Window",
        lang_toggle = "🌐 Language"
    }
}

-- ===================================================
-- 1. UI (PHIÊN BẢN CŨ - 7 TAB)
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
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- NÚT THU NHỎ (Z)
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

local FULL_HEIGHT, MIN_HEIGHT = 400, 38
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 540, 0, FULL_HEIGHT)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
local UIScale = Instance.new("UIScale", MainFrame)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(30, 36, 50)
Instance.new("UIStroke", MainFrame).Thickness = 1.2

local isDraggingWindow, isDraggingFloating = false, false
local dragStartPos, frameStartPos = nil, nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingWindow, dragStartPos, frameStartPos = true, input.Position, MainFrame.Position end
end)
FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingFloating, dragStartPos, frameStartPos = true, input.Position, FloatingButton.Position end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        if isDraggingFloating then
            isDraggingFloating = false
            if dragStartPos and (input.Position - dragStartPos).Magnitude < 12 then FloatingButton.Visible = false; MainFrame.Visible = true end
        end
        isDraggingWindow = false 
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if isDraggingWindow and MainFrame.Visible then
            local delta = (input.Position - dragStartPos) / UIScale.Scale
            MainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
        elseif isDraggingFloating and FloatingButton.Visible then
            local delta = (input.Position - dragStartPos) / UIScale.Scale
            FloatingButton.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
        end
    end
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size, TopBar.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(15, 18, 26)
local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position, Title.BackgroundTransparency, Title.RichText, Title.TextColor3, Title.Font, Title.TextSize, Title.TextXAlignment = UDim2.new(0, 240, 1, 0), UDim2.new(0, 15, 0, 0), 1, true, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12, Enum.TextXAlignment.Left
Title.Text = Lang[currentLang].title

local StatsFrame = Instance.new("Frame", TopBar)
StatsFrame.Size, StatsFrame.Position, StatsFrame.BackgroundColor3, StatsFrame.BorderSizePixel = UDim2.new(0, 120, 0, 24), UDim2.new(1, -190, 0.5, -12), Color3.fromRGB(22, 26, 38), 0
Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", StatsFrame).Color = Color3.fromRGB(0, 180, 255)
Instance.new("UIStroke", StatsFrame).Thickness = 1
local FpsLabel = Instance.new("TextLabel", StatsFrame)
FpsLabel.Size, FpsLabel.Position, FpsLabel.BackgroundTransparency, FpsLabel.TextColor3, FpsLabel.Font, FpsLabel.TextSize, FpsLabel.TextXAlignment = UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 5, 0, 0), 1, Color3.fromRGB(0, 255, 150), Enum.Font.GothamBold, 10, Enum.TextXAlignment.Left
local PingLabel = Instance.new("TextLabel", StatsFrame)
PingLabel.Size, PingLabel.Position, PingLabel.BackgroundTransparency, PingLabel.TextColor3, PingLabel.Font, PingLabel.TextSize, PingLabel.TextXAlignment = UDim2.new(0.5, 0, 1, 0), UDim2.new(0.5, -5, 0, 0), 1, Color3.fromRGB(255, 180, 0), Enum.Font.GothamBold, 10, Enum.TextXAlignment.Right
RunService.RenderStepped:Connect(function(deltaTime)
    FpsLabel.Text = "FPS: " .. math.floor(1 / deltaTime)
    pcall(function() PingLabel.Text = "Ping: " .. string.split(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1] end)
end)

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size, MinBtn.Position, MinBtn.BackgroundColor3, MinBtn.Text, MinBtn.TextColor3, MinBtn.Font, MinBtn.TextSize = UDim2.new(0, 24, 0, 24), UDim2.new(1, -56, 0.5, -12), Color3.fromRGB(22, 26, 38), "−", Color3.fromRGB(160, 170, 190), Enum.Font.GothamBold, 13
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size, CloseBtn.Position, CloseBtn.BackgroundColor3, CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.Font, CloseBtn.TextSize = UDim2.new(0, 24, 0, 24), UDim2.new(1, -28, 0.5, -12), Color3.fromRGB(255, 60, 90), "✕", Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingButton.Visible = true end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size, Sidebar.Position, Sidebar.BackgroundColor3 = UDim2.new(0, 140, 1, -38), UDim2.new(0, 0, 0, 38), Color3.fromRGB(13, 15, 22)
local TabListLayout = Instance.new("UIListLayout", Sidebar)
TabListLayout.Padding, TabListLayout.HorizontalAlignment = UDim.new(0, 3), Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 6)
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size, ContentContainer.Position, ContentContainer.BackgroundTransparency = UDim2.new(1, -140, 1, -38), UDim2.new(0, 140, 0, 38), 1
ContentContainer.ClipsDescendants = true

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 540, 0, MIN_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible, ContentContainer.Visible, MinBtn.Text = false, false, "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 540, 0, FULL_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible, ContentContainer.Visible, MinBtn.Text = true, true, "−"
    end
end)

local tabButtons, tabPages = {}, {}
local allTextLabels = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Size, page.BackgroundTransparency, page.ScrollBarThickness, page.ScrollBarImageColor3, page.BorderSizePixel, page.Visible = UDim2.new(1, 0, 1, 0), 1, 2, Color3.fromRGB(0, 180, 255), 0, false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", page)
    layout.Padding, layout.HorizontalAlignment = UDim.new(0, 6), Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 8)
    tabPages[name] = page return page
end

local function switchTab(name)
    for tName, item in pairs(tabButtons) do
        if tName == name then
            item.Button.BackgroundColor3, item.Button.TextColor3, item.Pill.Visible = Color3.fromRGB(45, 120, 255), Color3.fromRGB(255, 255, 255), true
        else
            item.Button.BackgroundColor3, item.Button.TextColor3, item.Pill.Visible = Color3.fromRGB(28, 35, 48), Color3.fromRGB(180, 190, 210), false
        end
    end
    for pName, page in pairs(tabPages) do page.Visible = (pName == name) end
end

local function createTabButton(name, icon, transKey)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size, btn.BackgroundColor3, btn.BorderSizePixel, btn.TextColor3, btn.Font, btn.TextSize, btn.TextXAlignment = UDim2.new(0.92, 0, 0, 28), Color3.fromRGB(28, 35, 48), 0, Color3.fromRGB(180, 190, 210), Enum.Font.GothamMedium, 11, Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 10)
    local pill = Instance.new("Frame", btn)
    pill.Size, pill.Position, pill.BackgroundColor3, pill.Visible = UDim2.new(0, 3, 0, 14), UDim2.new(0, -7, 0.5, -7), Color3.fromRGB(255, 255, 255), false
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    local entry = {Label = btn, Key = transKey, Button = btn, Pill = pill, Update = function() btn.Text = icon .. "  " .. Lang[currentLang][transKey] end}
    table.insert(allTextLabels, {obj = btn, key = transKey, isTab = true, icon = icon})
    btn.Text = icon .. "  " .. Lang[currentLang][transKey]
    tabButtons[name] = entry; btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

local function createToggle(page, transKey, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame", page)
    frame.Size, frame.BackgroundColor3 = UDim2.new(0.94, 0, 0, 34), Color3.fromRGB(16, 20, 28)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel", frame)
    label.Size, label.Position, label.BackgroundTransparency, label.TextColor3, label.Font, label.TextSize, label.TextXAlignment = UDim2.new(1, -50, 1, 0), UDim2.new(0, 10, 0, 0), 1, Color3.fromRGB(220, 225, 235), Enum.Font.Gotham, 11, Enum.TextXAlignment.Left
    label.Text = Lang[currentLang][transKey]
    table.insert(allTextLabels, {obj = label, key = transKey})
    local switch = Instance.new("TextButton", frame)
    switch.Size, switch.Position, switch.BackgroundColor3, switch.Text = UDim2.new(0, 32, 0, 16), UDim2.new(1, -40, 0.5, -8), state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54), ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch)
    circle.Size, circle.Position, circle.BackgroundColor3 = UDim2.new(0, 12, 0, 12), state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    switch.MouseButton1Click:Connect(function()
        state = not state switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        if callback then callback(state) end
    end)
end

local function createSlider(page, transKey, min, max, default, callback, isFloat)
    local current = default or min
    local frame = Instance.new("Frame", page)
    frame.Size, frame.BackgroundColor3 = UDim2.new(0.94, 0, 0, 44), Color3.fromRGB(16, 20, 28)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel", frame)
    label.Size, label.Position, label.BackgroundTransparency, label.TextColor3, label.Font, label.TextSize, label.TextXAlignment = UDim2.new(1, -70, 0, 20), UDim2.new(0, 10, 0, 3), 1, Color3.fromRGB(220, 225, 235), Enum.Font.Gotham, 11, Enum.TextXAlignment.Left
    label.Text = Lang[currentLang][transKey]
    table.insert(allTextLabels, {obj = label, key = transKey})
    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size, valueLabel.Position, valueLabel.BackgroundTransparency, valueLabel.Text, valueLabel.TextColor3, valueLabel.Font, valueLabel.TextSize, valueLabel.TextXAlignment = UDim2.new(0, 55, 0, 20), UDim2.new(1, -65, 0, 3), 1, isFloat and string.format("%.2f", current) or tostring(current), Color3.fromRGB(0, 210, 255), Enum.Font.GothamBold, 11, Enum.TextXAlignment.Right
    local track = Instance.new("TextButton", frame)
    track.Size, track.Position, track.BackgroundColor3, track.AutoButtonColor, track.Text = UDim2.new(0.94, 0, 0, 4), UDim2.new(0.03, 0, 0, 28), Color3.fromRGB(35, 42, 58), false, ""
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track)
    fill.Size, fill.BackgroundColor3 = UDim2.new((current - min) / (max - min), 0, 1, 0), Color3.fromRGB(0, 190, 255)
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
    track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingSlider = true update((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingSlider = false end end)
    UserInputService.InputChanged:Connect(function(input) if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update((UserInputService:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X) end end)
end

local function createButton(page, transKey, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size, btn.BackgroundColor3, btn.TextColor3, btn.Font, btn.TextSize = UDim2.new(0.94, 0, 0, 30), Color3.fromRGB(20, 26, 38), Color3.fromRGB(0, 210, 255), Enum.Font.GothamMedium, 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(0, 180, 255)
    btn.Text = Lang[currentLang][transKey]
    table.insert(allTextLabels, {obj = btn, key = transKey})
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

-- HÀM ĐỔI NGÔN NGỮ
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

-- KHỞI TẠO 7 TAB
local cats = {{"Farm", "🌾", "tab_farm"}, {"Fruit", "🍎", "tab_fruit"}, {"PVP-ESP", "⚔️", "tab_pvp"}, {"Server", "🌐", "tab_server"}, {"RAID", "⚡", "tab_raid"}, {"FARM ITEM", "🗡️", "tab_item"}, {"SETTING", "⚙️", "tab_setting"}}
for _, c in ipairs(cats) do createTabButton(c[1], c[2], c[3]) createPage(c[1]) end

-- TAB 1: FARM
local farmPage = tabPages["Farm"]
local infoLabel = Instance.new("TextLabel", farmPage)
infoLabel.Size, infoLabel.BackgroundTransparency, infoLabel.RichText, infoLabel.TextColor3, infoLabel.Font, infoLabel.TextSize = UDim2.new(0.94, 0, 0, 30), 1, true, Color3.fromRGB(0, 255, 150), Enum.Font.GothamBold, 12

local weaponSegment = Instance.new("Frame", farmPage)
weaponSegment.Size, weaponSegment.BackgroundColor3 = UDim2.new(0.94, 0, 0, 28), Color3.fromRGB(15, 18, 25)
Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
local wsLayout = Instance.new("UIListLayout", weaponSegment)
wsLayout.FillDirection, wsLayout.HorizontalAlignment, wsLayout.VerticalAlignment, wsLayout.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0, 3)
local weaponBtns, weaponList = {}, {{name = "Melee", label = "🥊 Melee"}, {name = "Sword", label = "⚔️ Sword"}, {name = "Blox Fruit", label = "🍎 Fruit"}}
for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size, b.BackgroundColor3, b.TextColor3, b.Font, b.TextSize = UDim2.new(0.3, 0, 0.78, 0), (selectedWeaponType == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48), (selectedWeaponType == wData.name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170), Enum.Font.GothamMedium, 10
    b.Text = wData.label; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); weaponBtns[wData.name] = b
    b.MouseButton1Click:Connect(function()
        selectedWeaponType = wData.name
        for name, btn in pairs(weaponBtns) do
            btn.BackgroundColor3, btn.TextColor3 = (name == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48), (name == wData.name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
        end
    end)
end

createToggle(farmPage, "auto_farm_level", false, function(v) AutoFarmLevel = v end)
createToggle(farmPage, "auto_quest", true, function(v) AutoQuest = v end)
createToggle(farmPage, "bring_mob", true, function(v) BringMob = v end)
createSlider(farmPage, "flight_height", 10, 50, 25, function(v) flightHeight = v print("✈️ Độ cao bay: " .. v) end, false)
createSlider(farmPage, "attack_speed", 0.01, 0.2, 0.04, function(v) attackCooldown = v print("⚡ Tốc độ đánh: " .. string.format("%.2f", v) .. "s") end, true)

-- TAB 2: FRUIT
local fruitPage = tabPages["Fruit"]
createToggle(fruitPage, "fruit_buy", false, function(v) AutoRandomFruit = v end)
createToggle(fruitPage, "fruit_collect", false, function(v) AutoCollectFruit = v end)
createToggle(fruitPage, "fruit_store", false, function(v) AutoStoreFruit = v end)

-- TAB 3: PVP-ESP
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

-- TAB 4: SERVER
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

-- TAB 5: RAID
local raidPage = tabPages["RAID"]
createToggle(raidPage, "auto_raid_start", false, function(v) end)

-- TAB 6: FARM ITEM
local itemPage = tabPages["FARM ITEM"]
createToggle(itemPage, "auto_bones", false, function(v) end)

-- TAB 7: SETTING
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

-- NÚT ĐỔI NGÔN NGỮ
local langBtn = Instance.new("TextButton", settingPage)
langBtn.Size = UDim2.new(0.94, 0, 0, 30)
langBtn.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
langBtn.Text = "🌐 " .. (currentLang == "VI" and "Tiếng Việt" or "English")
langBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
langBtn.Font = Enum.Font.GothamMedium
langBtn.TextSize = 11
Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", langBtn).Color = Color3.fromRGB(0, 180, 255)
langBtn.MouseButton1Click:Connect(function()
    if currentLang == "VI" then
        setLanguage("EN")
        langBtn.Text = "🌐 English"
    else
        setLanguage("VI")
        langBtn.Text = "🌐 Tiếng Việt"
    end
end)

createButton(settingPage, "close_hub", function() ScreenGui:Destroy() end)

switchTab("Farm")

-- ===================================================
-- 2. ESP (FIX GIẬT)
-- ===================================================
local espBillboards = {}

local function getOrCreateESP(parent, name, size, offset, color)
    if not parent then return nil end
    local bb = espBillboards[parent .. name]
    if bb and bb.Parent then bb.Enabled = true return bb end
    bb = Instance.new("BillboardGui", parent)
    bb.Name = name
    bb.Size = size or UDim2.new(0, 180, 0, 30)
    bb.StudsOffset = offset or Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.Enabled = true
    local label = Instance.new("TextLabel", bb)
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.Text = ""
    bb.Label = label
    espBillboards[parent .. name] = bb
    return bb
end

local function hideESP(parent, name)
    if parent then
        local bb = espBillboards[parent .. name]
        if bb then bb.Enabled = false end
    end
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
                    local bb = getOrCreateESP(head, "Zenith_PlayerBillboard", UDim2.new(0, 200, 0, 45), Vector3.new(0, 2.8, 0), Color3.fromRGB(255, 60, 90))
                    if bb and bb.Label then
                        bb.Label.Text = string.format("%s\n[%dm] • HP: %d/%d", p.DisplayName, dist, math.floor(hum.Health), math.floor(hum.MaxHealth))
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
                        local bb = getOrCreateESP(handle, "Zenith_FruitESP", UDim2.new(0, 180, 0, 30), Vector3.new(0, 2, 0), Color3.fromRGB(255, 70, 220))
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
                        local bb = getOrCreateESP(part, "Zenith_ChestESP", UDim2.new(0, 160, 0, 25), Vector3.new(0, 2, 0), color)
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
-- 3. SPEED + JUMP
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
-- 4. FRUIT AUTO
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
-- 5. WATER PLATFORM
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
-- 6. AUTO FARM (FIX - KHÔNG LẶP QUEST)
-- ===================================================
local questAccepted = false
local lastQuestTime = 0

local function hasQuest()
    -- Kiểm tra UI Quest
    local questGui = LocalPlayer.PlayerGui:FindFirstChild("Quest")
    if questGui and questGui.Enabled then
        return true
    end
    -- Kiểm tra Data
    local questData = LocalPlayer:FindFirstChild("Quest")
    if questData and questData.Value ~= "" and questData.Value ~= nil then
        return true
    end
    return false
end

local function getQuestByLevel()
    local lv = LocalPlayer.Data and LocalPlayer.Data.Level and LocalPlayer.Data.Level.Value or 1
    local qs = {
        {Mon = "Bandit", Name = "BanditQuest1", Lv = 1},
        {Mon = "Gorilla", Name = "GorillaQuest1", Lv = 50},
        {Mon = "Dragon", Name = "DragonQuest1", Lv = 120},
        {Mon = "Ice", Name = "IceQuest1", Lv = 200},
        {Mon = "Dark", Name = "DarkQuest1", Lv = 300},
        {Mon = "Light", Name = "LightQuest1", Lv = 400},
        {Mon = "Dough", Name = "DoughQuest1", Lv = 500},
    }
    for _, q in ipairs(qs) do
        if lv >= q.Lv then return q end
    end
    return qs[#qs]
end

local function getMobs(name)
    local list = {}
    local lower = string.lower(name)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local n = string.lower(obj.Name)
                if string.find(n, lower) then
                    table.insert(list, obj)
                end
            end
        end
    end
    return list
end

local function equipWeapon()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local list = {}
        if backpack then
            for _, t in ipairs(backpack:GetChildren()) do
                if t:IsA("Tool") then table.insert(list, t) end
            end
        end
        if char then
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then table.insert(list, t) end
            end
        end
        
        local function match(t, n)
            local nl = string.lower(n)
            if t == "Melee" and (string.find(nl, "melee") or string.find(nl, "fist") or string.find(nl, "combat") or string.find(nl, "fighting")) then return true
            elseif t == "Sword" and (string.find(nl, "sword") or string.find(nl, "blade") or string.find(nl, "katana") or string.find(nl, "cutlass") or string.find(nl, "saber")) then return true
            elseif t == "Blox Fruit" and (string.find(nl, "fruit") or string.find(nl, "devil") or string.find(nl, "paw") or string.find(nl, "buddha") or string.find(nl, "light") or string.find(nl, "dough")) then return true
            end
            return false
        end
        
        for _, t in ipairs(list) do
            if match(selectedWeaponType, t.Name) and t.Parent == backpack then
                CommF:InvokeServer("EquipTool", t)
                task.wait(0.1)
                return
            end
        end
        if list[1] and list[1].Parent == backpack then
            CommF:InvokeServer("EquipTool", list[1])
            task.wait(0.1)
        end
    end)
end

local function flyTo(pos)
    local char = LocalPlayer.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    local target = Vector3.new(pos.X, flightHeight, pos.Z)
    local cur = root.Position
    local dist = (target - cur).Magnitude
    
    if dist < 3 then
        root.AssemblyLinearVelocity = Vector3.zero
        return true
    end
    
    local dir = (target - cur).Unit
    root.AssemblyLinearVelocity = dir * 100
    
    local yd = flightHeight - cur.Y
    if math.abs(yd) > 1 then
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, yd * 3, root.AssemblyLinearVelocity.Z)
    end
    return false
end

local function attackMob()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
            task.wait(0.01)
            tool:Activate()
        end
        
        local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
        local c = CbFw.activeController
        if not c then
            for _, v in pairs(debug.getupvalues(CbFw)) do
                if type(v) == "table" and v.activeController then
                    c = v.activeController
                    break
                end
            end
        end
        if c then
            c.hitboxLimiter = 0
            c.timeToNextAttack = 0
            c.timeToNextBlock = 0
            c.increment = 10
            c.attacking = false
            c.blocking = false
            for i = 1, 6 do
                c:attack()
                task.wait(0.008)
            end
        end
    end)
end

-- MAIN FARM LOOP
task.spawn(function()
    while true do
        task.wait(0.1)
        if not AutoFarmLevel then
            task.wait(0.5)
            continue
        end
        
        local char = LocalPlayer.Character
        if not char then task.wait(0.5) continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(0.5) continue end
        
        -- NHẬN QUEST (CHỈ GỌI 1 LẦN KHI CHƯA CÓ)
        if AutoQuest and not hasQuest() then
            if tick() - lastQuestTime > 2 then
                local q = getQuestByLevel()
                if q then
                    pcall(function()
                        CommF:InvokeServer("StartQuest", q.Name, q.Lv)
                        infoLabel.Text = "📜 Quest: " .. q.Mon
                        lastQuestTime = tick()
                    end)
                    task.wait(0.5)
                end
            end
        end
        
        local quest = getQuestByLevel()
        if not quest then
            infoLabel.Text = "⚠️ Không có quest"
            task.wait(1)
            continue
        end
        
        -- TÌM QUÁI
        local mobs = getMobs(quest.Mon)
        if #mobs == 0 then
            infoLabel.Text = "🔍 Tìm " .. quest.Mon .. "..."
            task.wait(0.3)
            continue
        end
        
        -- LẤY QUÁI GẦN NHẤT
        local target = nil
        local minDist = math.huge
        for _, mob in ipairs(mobs) do
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - root.Position).Magnitude
                if d < minDist then
                    minDist = d
                    target = mob
                end
            end
        end
        
        if not target then
            task.wait(0.1)
            continue
        end
        
        local tHRP = target:FindFirstChild("HumanoidRootPart")
        if not tHRP then task.wait(0.1) continue end
        
        local lv = LocalPlayer.Data.Level.Value
        infoLabel.Text = string.format("⚔️ %s | Lv.%d | %d mobs", quest.Mon, lv, #mobs)
        
        equipWeapon()
        
        -- BAY ĐẾN QUÁI
        local dist = (tHRP.Position - root.Position).Magnitude
        if dist > 15 then
            flyTo(tHRP.Position)
            task.wait(0.05)
            continue
        end
        
        -- ĐÁNH QUÁI KHI ĐẾN GẦN
        if dist <= 18 then
            -- HẠ THẤP ĐỘ CAO XUỐNG GẦN QUÁI
            local targetY = flightHeight
            local currentY = root.Position.Y
            if currentY > tHRP.Position.Y + 5 then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -10, root.AssemblyLinearVelocity.Z)
            else
                root.AssemblyLinearVelocity = Vector3.zero
            end
            
            -- QUAY MẶT VÀO QUÁI
            local look = (tHRP.Position - root.Position).Unit
            if look.Magnitude > 0 then
                root.CFrame = CFrame.lookAt(root.Position, root.Position + look * 10)
            end
            
            -- SPAM ĐÁNH
            for i = 1, 10 do
                if not AutoFarmLevel then break end
                attackMob()
                task.wait(attackCooldown)
            end
        end
        
        -- THOÁT HIỂM
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
        task.wait(0.1)
        if not AutoFarmLevel then task.wait(0.5) continue end
        local char = LocalPlayer.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        
        local y = root.Position.Y
        if y < flightHeight - 1.5 then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 15, root.AssemblyLinearVelocity.Z)
        elseif y > flightHeight + 1.5 then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -5, root.AssemblyLinearVelocity.Z)
        end
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
    end
end)

print("✅ ZENITH V12.24 - UI CŨ + FIX AUTO FARM")
