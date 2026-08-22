-- [[ ZENITH BLOX FRUIT - V12.16 (LDPLAYER PERFECT FIX - CHUẨN ĐÁNH & CHUẨN UI) ]] --

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
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local Camera = Workspace.CurrentCamera

-- Chống AFK (Tránh văng game khi treo)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Biến Global Chức Năng
local selectedWeaponType = "Melee"
local AutoFarmLevel, AutoQuest, BringMob = false, true, true
local speedValue, speedEnabled = 16, false
local jumpValue, jumpEnabled = 50, false
local AutoRandomFruit, AutoCollectFruit, AutoStoreFruit = false, false, false
local espPlayerEnabled, espFruitEnabled = false, false
local espChest1Enabled, espChest2Enabled, espChest3Enabled = false, false, false

-- ===================================================
-- 1. ÉP HIỂN THỊ GIAO DIỆN & DỌN DẸP
-- ===================================================
local UI_NAME = "ZenithBloxFruit_Zyrox_V12"

local function GetSafeUIFolder()
    local folder
    pcall(function() if gethui then folder = gethui() end end)
    if not folder then pcall(function() folder = game:GetService("CoreGui") end) end
    if not folder then folder = LocalPlayer:WaitForChild("PlayerGui") end
    return folder
end

local targetUIFolder = GetSafeUIFolder()
for _, gui in ipairs(targetUIFolder:GetChildren()) do if gui.Name == UI_NAME then gui:Destroy() end end
for _, gui in ipairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do if gui.Name == UI_NAME then gui:Destroy() end end

-- ===================================================
-- 2. HỆ THỐNG NGÔN NGỮ
-- ===================================================
local currentLang = "VI"
local translatableElements = {}
local LangDict = {
    VI = {
        title = "ZYROX VN <font color='#00d2ff'>• V12.16 (FIX)</font>",
        tab_farm = "Farm Level", tab_fruit = "Trái Ác Quỷ", tab_pvp = "PVP & ESP",
        tab_server = "Máy Chủ", tab_setting = "Cài Đặt",
        auto_farm_level = "⚡ Tự Động Farm Level", auto_quest = "📜 Tự Nhận Nhiệm Vụ", bring_mob = "🧲 Gom Quái (Hitbox Vừa)",
        fruit_buy = "🎲 Mua Ngẫu Nhiên Trái", fruit_collect = "🧲 Nhặt Trái Rơi", fruit_store = "📦 Cất Trái Vào Rương",
        speed_toggle = "Bật Chạy Nhanh", speed_slider = "Tốc Độ", jump_toggle = "Bật Nhảy Cao", jump_slider = "Lực Nhảy",
        player_esp = "ESP Người Chơi", fruit_esp = "ESP Trái Ác Quỷ", chest_wood = "ESP Rương Gỗ", chest_gold = "ESP Rương Vàng", chest_diamond = "ESP Rương Kim Cương",
        redeem_codes = "🎁 Nhập Code Game", rejoin_btn = "Vào Lại Server", serverhop_btn = "Chuyển Server",
        lang_title = "Ngôn Ngữ / Language", ui_scale = "Thu Phóng UI (%)", ui_transparency = "Trong Suốt UI (%)", fix_lag = "Tối Ưu Đồ Họa (Tăng FPS)", close_hub = "Đóng Cửa Sổ"
    },
    EN = {
        title = "ZYROX VN <font color='#00d2ff'>• V12.16 (FIX)</font>",
        tab_farm = "Farm Level", tab_fruit = "Devil Fruit", tab_pvp = "PVP & ESP",
        tab_server = "Server", tab_setting = "Settings",
        auto_farm_level = "⚡ Auto Farm Level", auto_quest = "📜 Auto Quest", bring_mob = "🧲 Bring Mobs (Medium Hitbox)",
        fruit_buy = "🎲 Random Fruit", fruit_collect = "🧲 Collect Fruits", fruit_store = "📦 Store Into Inventory",
        speed_toggle = "Enable WalkSpeed", speed_slider = "Speed", jump_toggle = "Enable High Jump", jump_slider = "Jump Height",
        player_esp = "Player ESP", fruit_esp = "Fruit ESP", chest_wood = "Wood Chest", chest_gold = "Gold Chest", chest_diamond = "Diamond Chest",
        redeem_codes = "🎁 Redeem Codes", rejoin_btn = "Rejoin Server", serverhop_btn = "Server Hop",
        lang_title = "Language", ui_scale = "UI Scale (%)", ui_transparency = "Transparency (%)", fix_lag = "Boost FPS", close_hub = "Close Window"
    }
}
local function registerText(label, key, isRich)
    table.insert(translatableElements, {Label = label, Key = key, Rich = isRich})
    label.Text = LangDict[currentLang][key]
end
local function setLanguage(lang)
    currentLang = lang
    for _, item in ipairs(translatableElements) do
        if item.Label and item.Label.Parent then
            if item.Update then item.Update() else item.Label.Text = LangDict[currentLang][item.Key] end
        end
    end
end

-- ===================================================
-- 3. XÂY DỰNG GIAO DIỆN CẢI TIẾN (FIX NÚT LOGO)
-- ===================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name, ScreenGui.ResetOnSpawn = UI_NAME, false
local attachSuccess = pcall(function() ScreenGui.Parent = targetUIFolder end)
if not attachSuccess then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- FIX 1: NÚT LOGO THU NHỎ (Dùng TextButton thay vì Image để tránh lỗi đen xì)
local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size, FloatingButton.AnchorPoint, FloatingButton.Position = UDim2.new(0, 50, 0, 50), Vector2.new(0.5, 0.5), UDim2.new(0.1, 0, 0.5, 0)
FloatingButton.BackgroundColor3, FloatingButton.Visible, FloatingButton.Active = Color3.fromRGB(13, 16, 22), false, true
FloatingButton.Text = "Z"
FloatingButton.TextColor3 = Color3.fromRGB(0, 210, 255)
FloatingButton.Font = Enum.Font.GothamBlack
FloatingButton.TextSize = 24
FloatingButton.ZIndex = 999
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
local FloatStroke = Instance.new("UIStroke", FloatingButton)
FloatStroke.Color, FloatStroke.Thickness = Color3.fromRGB(0, 210, 255), 2

local FULL_HEIGHT, MIN_HEIGHT = 330, 38
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size, MainFrame.AnchorPoint, MainFrame.Position = UDim2.new(0, 540, 0, FULL_HEIGHT), Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3, MainFrame.BackgroundTransparency, MainFrame.BorderSizePixel, MainFrame.Active, MainFrame.ClipsDescendants = Color3.fromRGB(11, 13, 19), 0.12, 0, true, true
local UIScale = Instance.new("UIScale", MainFrame)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color, MainStroke.Transparency, MainStroke.Thickness = Color3.fromRGB(30, 36, 50), 0.2, 1.2

-- Logic Kéo Thả an toàn (Phân biệt Click và Kéo)
local isDraggingWindow, isDraggingFloating = false, false
local dragStartPos, frameStartPos = nil, nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        isDraggingWindow = true; dragStartPos = input.Position; frameStartPos = MainFrame.Position 
    end
end)

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        isDraggingFloating = true; dragStartPos = input.Position; frameStartPos = FloatingButton.Position 
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        if isDraggingFloating then
            isDraggingFloating = false
            -- Fix: Nếu khoảng cách di chuột < 10 pixel -> Mở Menu
            if dragStartPos and (input.Position - dragStartPos).Magnitude < 10 then
                FloatingButton.Visible = false
                MainFrame.Visible = true
            end
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
TopBar.Size, TopBar.BackgroundColor3, TopBar.BackgroundTransparency, TopBar.BorderSizePixel = UDim2.new(1, 0, 0, 38), Color3.fromRGB(15, 18, 26), 0.2, 0
local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position, Title.BackgroundTransparency, Title.RichText, Title.TextColor3, Title.Font, Title.TextSize, Title.TextXAlignment = UDim2.new(0, 200, 1, 0), UDim2.new(0, 15, 0, 0), 1, true, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12, Enum.TextXAlignment.Left
registerText(Title, "title", true)

-- KHUNG FPS & PING CÓ BORDER
local StatsFrame = Instance.new("Frame", TopBar)
StatsFrame.Size, StatsFrame.Position, StatsFrame.BackgroundColor3, StatsFrame.BorderSizePixel = UDim2.new(0, 120, 0, 24), UDim2.new(1, -190, 0.5, -12), Color3.fromRGB(22, 26, 38), 0
Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 6)
local StatsStroke = Instance.new("UIStroke", StatsFrame)
StatsStroke.Color, StatsStroke.Thickness = Color3.fromRGB(0, 180, 255), 1 

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
CloseBtn.MouseButton1Click:Connect(function() 
    MainFrame.Visible = false
    FloatingButton.Visible = true 
end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size, Sidebar.Position, Sidebar.BackgroundColor3, Sidebar.BackgroundTransparency, Sidebar.BorderSizePixel, Sidebar.ZIndex = UDim2.new(0, 140, 1, -38), UDim2.new(0, 0, 0, 38), Color3.fromRGB(13, 15, 22), 0.15, 0, 2
local TabListLayout = Instance.new("UIListLayout", Sidebar)
TabListLayout.Padding, TabListLayout.HorizontalAlignment = UDim.new(0, 3), Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 6)
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size, ContentContainer.Position, ContentContainer.BackgroundTransparency, ContentContainer.ZIndex = UDim2.new(1, -140, 1, -38), UDim2.new(0, 140, 0, 38), 1, 1

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
local function createPage(name)
    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Size, page.BackgroundTransparency, page.ScrollBarThickness, page.ScrollBarImageColor3, page.BorderSizePixel, page.Visible, page.AutomaticCanvasSize = UDim2.new(1, 0, 1, 0), 1, 2, Color3.fromRGB(0, 180, 255), 0, false, Enum.AutomaticSize.Y
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

local function createTabButton(name, icon, labelText)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size, btn.BackgroundColor3, btn.BorderSizePixel, btn.TextColor3, btn.Font, btn.TextSize, btn.TextXAlignment = UDim2.new(0.92, 0, 0, 28), Color3.fromRGB(28, 35, 48), 0, Color3.fromRGB(180, 190, 210), Enum.Font.GothamMedium, 11, Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 10)
    local pill = Instance.new("Frame", btn)
    pill.Size, pill.Position, pill.BackgroundColor3, pill.BorderSizePixel, pill.Visible = UDim2.new(0, 3, 0, 14), UDim2.new(0, -7, 0.5, -7), Color3.fromRGB(255, 255, 255), 0, false
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    local entry = {Label = btn, Key = labelText, Button = btn, Pill = pill, Update = function() btn.Text = icon .. "  " .. LangDict[currentLang][labelText] end}
    table.insert(translatableElements, entry) btn.Text = icon .. "  " .. LangDict[currentLang][labelText]
    tabButtons[name] = entry btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

local function createToggle(page, transKey, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame", page)
    frame.Size, frame.BackgroundColor3, frame.BackgroundTransparency, frame.BorderSizePixel = UDim2.new(0.94, 0, 0, 34), Color3.fromRGB(16, 20, 28), 0.2, 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel", frame)
    label.Size, label.Position, label.BackgroundTransparency, label.TextColor3, label.Font, label.TextSize, label.TextXAlignment = UDim2.new(1, -50, 1, 0), UDim2.new(0, 10, 0, 0), 1, Color3.fromRGB(220, 225, 235), Enum.Font.Gotham, 11, Enum.TextXAlignment.Left
    registerText(label, transKey)
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

local function createSlider(page, transKey, min, max, default, callback)
    local current = default or min
    local frame = Instance.new("Frame", page)
    frame.Size, frame.BackgroundColor3, frame.BackgroundTransparency, frame.BorderSizePixel = UDim2.new(0.94, 0, 0, 44), Color3.fromRGB(16, 20, 28), 0.2, 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel", frame)
    label.Size, label.Position, label.BackgroundTransparency, label.TextColor3, label.Font, label.TextSize, label.TextXAlignment = UDim2.new(1, -70, 0, 20), UDim2.new(0, 10, 0, 3), 1, Color3.fromRGB(220, 225, 235), Enum.Font.Gotham, 11, Enum.TextXAlignment.Left
    registerText(label, transKey)
    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size, valueLabel.Position, valueLabel.BackgroundTransparency, valueLabel.Text, valueLabel.TextColor3, valueLabel.Font, valueLabel.TextSize, valueLabel.TextXAlignment = UDim2.new(0, 55, 0, 20), UDim2.new(1, -65, 0, 3), 1, tostring(current), Color3.fromRGB(0, 210, 255), Enum.Font.GothamBold, 11, Enum.TextXAlignment.Right
    local track = Instance.new("TextButton", frame)
    track.Size, track.Position, track.BackgroundColor3, track.AutoButtonColor, track.Text = UDim2.new(0.94, 0, 0, 4), UDim2.new(0.03, 0, 0, 28), Color3.fromRGB(35, 42, 58), false, ""
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track)
    fill.Size, fill.BackgroundColor3 = UDim2.new((current - min) / (max - min), 0, 1, 0), Color3.fromRGB(0, 190, 255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local isDraggingSlider = false
    local function update(percent)
        fill.Size = UDim2.new(math.clamp(percent, 0, 1), 0, 1, 0) current = math.floor(min + (max - min) * math.clamp(percent, 0, 1)) valueLabel.Text = tostring(current)
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
    registerText(btn, transKey) btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

local cats = {{"Farm", "🌾", "tab_farm"}, {"Fruit", "🍎", "tab_fruit"}, {"PVP-ESP", "⚔️", "tab_pvp"}, {"Server", "🌐", "tab_server"}, {"SETTING", "⚙️", "tab_setting"}}
for _, c in ipairs(cats) do createTabButton(c[1], c[2], c[3]) createPage(c[1]) end

-- NỘI DUNG TABS CƠ BẢN
local farmPage = tabPages["Farm"]
local infoLabel = Instance.new("TextLabel", farmPage)
infoLabel.Size, infoLabel.BackgroundTransparency, infoLabel.RichText, infoLabel.TextColor3, infoLabel.Font, infoLabel.TextSize = UDim2.new(0.94, 0, 0, 30), 1, true, Color3.fromRGB(0, 255, 150), Enum.Font.GothamBold, 12

local weaponSegment = Instance.new("Frame", farmPage)
weaponSegment.Size, weaponSegment.BackgroundColor3, weaponSegment.BackgroundTransparency = UDim2.new(0.94, 0, 0, 28), Color3.fromRGB(15, 18, 25), 0.2
Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
local wsLayout = Instance.new("UIListLayout", weaponSegment)
wsLayout.FillDirection, wsLayout.HorizontalAlignment, wsLayout.VerticalAlignment, wsLayout.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0, 3)
local weaponBtns, weaponList = {}, {{name = "Melee", label = "🥊 Melee"}, {name = "Sword", label = "⚔️ Sword"}, {name = "Blox Fruit", label = "🍎 Fruit"}}
for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size, b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = UDim2.new(0.3, 0, 0.78, 0), (selectedWeaponType == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48), wData.label, (selectedWeaponType == wData.name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170), Enum.Font.GothamMedium, 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    weaponBtns[wData.name] = b
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

createToggle(tabPages["Fruit"], "fruit_buy", false, function(v) AutoRandomFruit = v end)
createToggle(tabPages["Fruit"], "fruit_collect", false, function(v) AutoCollectFruit = v end)
createToggle(tabPages["Fruit"], "fruit_store", false, function(v) AutoStoreFruit = v end)

createToggle(tabPages["PVP-ESP"], "speed_toggle", false, function(v) speedEnabled = v end)
createSlider(tabPages["PVP-ESP"], "speed_slider", 16, 300, 16, function(val) speedValue = val end)
createToggle(tabPages["PVP-ESP"], "jump_toggle", false, function(v) jumpEnabled = v end)
createSlider(tabPages["PVP-ESP"], "jump_slider", 50, 400, 50, function(val) jumpValue = val end)
createToggle(tabPages["PVP-ESP"], "player_esp", false, function(v) espPlayerEnabled = v end)
createToggle(tabPages["PVP-ESP"], "fruit_esp", false, function(v) espFruitEnabled = v end)
createToggle(tabPages["PVP-ESP"], "chest_wood", false, function(v) espChest1Enabled = v end)

createButton(tabPages["Server"], "rejoin_btn", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)

local settingPage = tabPages["SETTING"]
createToggle(settingPage, "fix_lag", false, function(v)
    Lighting.GlobalShadows = not v
    for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA("BasePart") and v then obj.Material = Enum.Material.SmoothPlastic end end
end)
createSlider(settingPage, "ui_scale", 60, 140, 100, function(val) UIScale.Scale = val / 100 end)
createButton(settingPage, "close_hub", function() ScreenGui:Destroy() end)

switchTab("Farm")

-- ===================================================
-- 4. HỆ THỐNG ĐÁNH TỰ ĐỘNG CHUẨN (FIX NO DAMAGE LDPLAYER)
-- ===================================================
local isAttackingTarget = false

local function executePerfectAttack()
    local char = LocalPlayer.Character
    if not char then return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then 
        tool:Activate() 
    end
    
    pcall(function()
        local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
        local controller = CbFw.activeController
        if controller and controller.equipped then
            controller.hitboxLimiter = 0
            controller.timeToNextAttack = 0
            controller.timeToNextBlock = 0
            controller.increment = 3
            controller.attacking = false
            controller.blocking = false
            controller:attack()
        end
    end)

    -- Backup cho giả lập không cướp chuột
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
    end)
end

task.spawn(function()
    while true do
        if AutoFarmLevel and isAttackingTarget then
            executePerfectAttack()
            task.wait(0.12)
        else
            task.wait(0.2)
        end
    end
end)

-- ===================================================
-- 5. LOGIC DI CHUYỂN, GOM QUÁI (FIX LỖI BAY VÀ THANG MÁY)
-- ===================================================
local currentTween = nil
local function toTargetPos(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    if currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing then return end
    
    -- Tăng tốc độ bay lên 350 để bay tới đảo chuẩn nhanh hơn
    local speed = 350 
    local time = (root.Position - targetCFrame.Position).Magnitude / speed
    currentTween = TweenService:Create(root, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    currentTween:Play()
end

RunService.Stepped:Connect(function()
    if AutoFarmLevel and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

local function equipChosenWeapon()
    local char = LocalPlayer.Character
    if not char then return end
    local backpack, humanoid = LocalPlayer:FindFirstChild("Backpack"), char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool and (currentTool.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (currentTool.ToolTip == "Melee" or currentTool.ToolTip == "Combat" or currentTool.Name == "Combat" or currentTool.Name == "Võ Tân Binh"))) then return end
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (tool.ToolTip == "Melee" or tool.ToolTip == "Combat" or tool.Name == "Combat" or tool.Name == "Võ Tân Binh"))) then
                humanoid:EquipTool(tool) return
            end
        end
    end
end

-- DATA QUÁI THEO LEVEL
local function getAutoQuestByLevel()
    local level = 1
    pcall(function() level = LocalPlayer.Data.Level.Value end)
    if level <= 9 then return {QuestName = "BanditQuest1", QuestLevel = 1, MonName = "Bandit", ReqLevel = 1}
    elseif level <= 14 then return {QuestName = "JungleQuest", QuestLevel = 1, MonName = "Monkey", ReqLevel = 10}
    elseif level <= 29 then return {QuestName = "JungleQuest", QuestLevel = 2, MonName = "Gorilla", ReqLevel = 15}
    elseif level <= 39 then return {QuestName = "BuggyQuest1", QuestLevel = 1, MonName = "Pirate", ReqLevel = 30}
    elseif level <= 59 then return {QuestName = "BuggyQuest1", QuestLevel = 2, MonName = "Brute", ReqLevel = 40}
    elseif level <= 74 then return {QuestName = "DesertQuest", QuestLevel = 1, MonName = "Desert Bandit", ReqLevel = 60}
    elseif level <= 89 then return {QuestName = "DesertQuest", QuestLevel = 2, MonName = "Desert Officer", ReqLevel = 75}
    elseif level <= 99 then return {QuestName = "SnowQuest", QuestLevel = 1, MonName = "Snow Bandit", ReqLevel = 90}
    elseif level <= 119 then return {QuestName = "SnowQuest", QuestLevel = 2, MonName = "Snowman", ReqLevel = 100}
    elseif level <= 149 then return {QuestName = "MarineQuest2", QuestLevel = 1, MonName = "Chief Petty Officer", ReqLevel = 120}
    elseif level <= 174 then return {QuestName = "SkyQuest", QuestLevel = 1, MonName = "Sky Bandit", ReqLevel = 150}
    elseif level <= 189 then return {QuestName = "SkyQuest", QuestLevel = 2, MonName = "Dark Master", ReqLevel = 175}
    elseif level <= 209 then return {QuestName = "PrisonerQuest", QuestLevel = 1, MonName = "Prisoner", ReqLevel = 190}
    else return {QuestName = "PeanutQuest", QuestLevel = 1, MonName = "Peanut Scout", ReqLevel = 2200} end
end

local function checkHasQuest()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    return pGui and pGui:FindFirstChild("Main") and pGui.Main:FindFirstChild("Quest") and pGui.Main.Quest.Visible or false
end

-- Tìm quái còn sống
local function getAllLivingEnemies(monName)
    local list = {}
    if not Workspace:FindFirstChild("Enemies") then return list end
    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
        if string.find(mob.Name, monName) then
            local hum, hrp = mob:FindFirstChildOfClass("Humanoid"), mob:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then table.insert(list, mob) end
        end
    end
    return list
end

-- VÒNG LẶP FARM CHÍNH
local lockedGroundY = nil
task.spawn(function()
    while true do
        task.wait(0.05)
        if AutoFarmLevel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and CommF then
            local currentQuest = getAutoQuestByLevel()
            if currentQuest then
                pcall(function() infoLabel.Text = string.format("Đang Farm: %s (Lv.%d)", currentQuest.MonName, LocalPlayer.Data.Level.Value) end)
                
                if AutoQuest and not checkHasQuest() then 
                    CommF:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.QuestLevel) 
                    task.wait(0.5) 
                end
                
                local mobList = getAllLivingEnemies(currentQuest.MonName)
                if #mobList > 0 then
                    equipChosenWeapon()
                    local primaryMob = mobList[1]
                    local primaryHRP = primaryMob:FindFirstChild("HumanoidRootPart")
                    local myHRP = LocalPlayer.Character.HumanoidRootPart
                    
                    if primaryHRP then
                        local mobPos = primaryHRP.Position
                        
                        -- FIX 1: Lấy Y chuẩn của đảo, không cập nhật Y nếu quái bị kéo. Chống bay lên trời.
                        if not lockedGroundY or math.abs(lockedGroundY - mobPos.Y) > 50 then
                            lockedGroundY = mobPos.Y
                        end
                        
                        -- FIX 2: Bay xuống THẤP HƠN (chỉ cách 12 studs), đảm bảo chém trúng và an toàn.
                        local attackPos = CFrame.new(mobPos.X, lockedGroundY + 12, mobPos.Z)
                        local lookAtPos = CFrame.lookAt(attackPos.Position, Vector3.new(mobPos.X, lockedGroundY, mobPos.Z))
                        
                        if (myHRP.Position - attackPos.Position).Magnitude > 5 then
                            isAttackingTarget = false 
                            toTargetPos(lookAtPos)
                        else
                            if currentTween then currentTween:Cancel(); currentTween = nil end
                            
                            myHRP.CFrame = lookAtPos
                            myHRP.AssemblyLinearVelocity = Vector3.zero
                            isAttackingTarget = true
                            
                            -- FIX 3: Trả Hitbox về kích thước vừa chuẩn (15x15x15), không để khổng lồ gây lỗi Server
                            if BringMob then
                                for _, otherMob in ipairs(mobList) do
                                    local oHRP, oHum = otherMob:FindFirstChild("HumanoidRootPart"), otherMob:FindFirstChildOfClass("Humanoid")
                                    if oHRP and oHum and oHum.Health > 0 and (oHRP.Position - Vector3.new(mobPos.X, lockedGroundY, mobPos.Z)).Magnitude <= 350 then
                                        
                                        oHRP.Size = Vector3.new(15, 15, 15)
                                        oHRP.CanCollide = false
                                        oHRP.Transparency = 0.8
                                        
                                        -- Cố định quái dưới mặt đất, thẳng chân nhân vật
                                        oHRP.CFrame = CFrame.new(mobPos.X, lockedGroundY, mobPos.Z)
                                        oHRP.AssemblyLinearVelocity = Vector3.zero
                                        oHum.Sit = true
                                    end
                                end
                            end
                        end
                    end
                else 
                    isAttackingTarget = false
                    lockedGroundY = nil
                end
            end
        else 
            isAttackingTarget = false 
            lockedGroundY = nil
            if currentTween then currentTween:Cancel(); currentTween = nil end 
        end
    end
end)
