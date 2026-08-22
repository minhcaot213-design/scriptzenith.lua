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
-- 2. HỆ THỐNG ĐA NGÔN NGỮ
-- ===================================================
local currentLang = "VI"
local translatableElements = {}
local LangDict = {
    VI = {
        title = "ZYROX VN <font color='#00d2ff'>• V12.24</font>",
        badge = "PRO",
        tab_farm = "Farm Level", tab_fruit = "Trái Ác Quỷ", tab_pvp = "PVP & ESP",
        tab_server = "Máy Chủ", tab_raid = "Đi Raid", tab_item = "Farm Item", tab_setting = "Cài Đặt",
        auto_farm_level = "⚡ Tự Động Farm (Aura AFK)", auto_quest = "📜 Tự Nhận Nhiệm Vụ", bring_mob = "🧲 Gom Quái An Toàn",
        fruit_buy = "🎲 Mua Ngẫu Nhiên Trái", fruit_collect = "🧲 Nhặt Trái Rơi", fruit_store = "📦 Cất Trái Vào Rương",
        speed_toggle = "Bật Chạy Nhanh", speed_slider = "Tốc Độ", jump_toggle = "Bật Nhảy Cao", jump_slider = "Lực Nhảy",
        player_esp = "ESP Người Chơi", fruit_esp = "ESP Trái Ác Quỷ", chest_wood = "ESP Rương Gỗ", chest_gold = "ESP Rương Vàng", chest_diamond = "ESP Rương Kim Cương",
        redeem_codes = "🎁 Nhập Code Game", rejoin_btn = "Vào Lại Server", serverhop_btn = "Chuyển Server",
        auto_raid_start = "Tự Động Mua Vé & Bắt Đầu Raid", auto_bones = "Tự Farm Xương (Bones)",
        lang_title = "Ngôn Ngữ / Language", ui_scale = "Thu Phóng UI (%)", ui_transparency = "Trong Suốt UI (%)", fix_lag = "Tối Ưu Đồ Họa (Tăng FPS)", close_hub = "Đóng Cửa Sổ"
    },
    EN = {
        title = "ZYROX VN <font color='#00d2ff'>• V12.24</font>",
        badge = "PRO",
        tab_farm = "Farm Level", tab_fruit = "Devil Fruit", tab_pvp = "PVP & ESP",
        tab_server = "Server", tab_raid = "Raid Hub", tab_item = "Item Farm", tab_setting = "Settings",
        auto_farm_level = "⚡ Auto Farm (Aura AFK)", auto_quest = "📜 Auto Quest", bring_mob = "🧲 Safe Bring Mobs",
        fruit_buy = "🎲 Random Fruit", fruit_collect = "🧲 Collect Fruits", fruit_store = "📦 Store Into Inventory",
        speed_toggle = "Enable WalkSpeed", speed_slider = "Speed", jump_toggle = "Enable High Jump", jump_slider = "Jump Height",
        player_esp = "Player ESP", fruit_esp = "Fruit ESP", chest_wood = "Wood Chest", chest_gold = "Gold Chest", chest_diamond = "Diamond Chest",
        redeem_codes = "🎁 Redeem Codes", rejoin_btn = "Rejoin Server", serverhop_btn = "Server Hop",
        auto_raid_start = "Auto Start Raid", auto_bones = "Auto Farm Bones",
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
-- 3. XÂY DỰNG GIAO DIỆN (UI BUILDER)
-- ===================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name, ScreenGui.ResetOnSpawn = UI_NAME, false
pcall(function() ScreenGui.Parent = targetUIFolder end)

-- Nút thu nhỏ chữ Z
local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size, FloatingButton.AnchorPoint, FloatingButton.Position = UDim2.new(0, 48, 0, 48), Vector2.new(0.5, 0.5), UDim2.new(0.1, 0, 0.5, 0)
FloatingButton.BackgroundColor3, FloatingButton.Visible = Color3.fromRGB(13, 16, 22), false
FloatingButton.Text, FloatingButton.TextColor3, FloatingButton.Font, FloatingButton.TextSize = "Z", Color3.fromRGB(0, 210, 255), Enum.Font.GothamBlack, 24
FloatingButton.ZIndex = 999 
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", FloatingButton).Color = Color3.fromRGB(0, 210, 255)
Instance.new("UIStroke", FloatingButton).Thickness = 1.5

local FULL_HEIGHT, MIN_HEIGHT = 330, 38
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size, MainFrame.AnchorPoint, MainFrame.Position = UDim2.new(0, 540, 0, FULL_HEIGHT), Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3, MainFrame.BorderSizePixel, MainFrame.ClipsDescendants = Color3.fromRGB(11, 13, 19), 0, true
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
registerText(Title, "title", true)

-- Bộ đếm FPS & Ping có Border
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
    page.Size, page.BackgroundTransparency, page.ScrollBarThickness, page.ScrollBarImageColor3, page.BorderSizePixel, page.Visible = UDim2.new(1, 0, 1, 0), 1, 2, Color3.fromRGB(0, 180, 255), 0, false
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
    local entry = {Label = btn, Key = transKey, Button = btn, Pill = pill, Update = function() btn.Text = icon .. "  " .. LangDict[currentLang][transKey] end}
    table.insert(translatableElements, entry); btn.Text = icon .. "  " .. LangDict[currentLang][transKey]
    tabButtons[name] = entry; btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

local function createToggle(page, transKey, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame", page)
    frame.Size, frame.BackgroundColor3 = UDim2.new(0.94, 0, 0, 34), Color3.fromRGB(16, 20, 28)
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
    frame.Size, frame.BackgroundColor3 = UDim2.new(0.94, 0, 0, 44), Color3.fromRGB(16, 20, 28)
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

-- KHỞI TẠO ĐẦY ĐỦ 7 DANH MỤC
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

-- TAB 2: FRUIT
local fruitPage = tabPages["Fruit"]
createToggle(fruitPage, "fruit_buy", false, function(v) AutoRandomFruit = v end)
createToggle(fruitPage, "fruit_collect", false, function(v) AutoCollectFruit = v end)
createToggle(fruitPage, "fruit_store", false, function(v) AutoStoreFruit = v end)

-- TAB 3: PVP-ESP
local pvpPage = tabPages["PVP-ESP"]
createToggle(pvpPage, "speed_toggle", false, function(v) speedEnabled = v end)
createSlider(pvpPage, "speed_slider", 16, 300, 16, function(val) speedValue = val end)
createToggle(pvpPage, "jump_toggle", false, function(v) jumpEnabled = v end)
createSlider(pvpPage, "jump_slider", 50, 400, 50, function(val) jumpValue = val end)
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
    if success and response and response.data then for _, s in ipairs(response.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer) break end end end
end)

-- TAB 5: RAID
createToggle(tabPages["RAID"], "auto_raid_start", false, function(v) end)

-- TAB 6: ITEM
createToggle(tabPages["FARM ITEM"], "auto_bones", false, function(v) end)

-- TAB 7: SETTING (ĐẦY ĐỦ 100% TÍNH NĂNG CŨ)
local settingPage = tabPages["SETTING"]
createToggle(settingPage, "fix_lag", false, function(v)
    Lighting.GlobalShadows = not v
    for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA("BasePart") and v then obj.Material = Enum.Material.SmoothPlastic end end
end)
createSlider(settingPage, "ui_scale", 60, 140, 100, function(val) UIScale.Scale = val / 100 end)
createSlider(settingPage, "ui_transparency", 0, 80, 12, function(val)
    MainFrame.BackgroundTransparency = val / 100
    Sidebar.BackgroundTransparency = math.clamp((val + 8) / 100, 0, 1)
end)
createButton(settingPage, "close_hub", function() ScreenGui:Destroy() end)
switchTab("Farm")

-- ===================================================
-- 4. HỆ THỐNG FULL LOGIC ESP & FRUIT & WATER
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

task.spawn(function()
    while true do
        task.wait(0.2)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char, head, hum = p.Character, p.Character:FindFirstChild("Head"), p.Character:FindFirstChildOfClass("Humanoid")
                local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if espPlayerEnabled and head and hum and myHRP and hum.Health > 0 then
                    local dist = math.floor((head.Position - myHRP.Position).Magnitude)
                    local bbGui = head:FindFirstChild("Zenith_PlayerBillboard")
                    if not bbGui then
                        bbGui = Instance.new("BillboardGui", head)
                        bbGui.Name, bbGui.Size, bbGui.StudsOffset, bbGui.AlwaysOnTop = "Zenith_PlayerBillboard", UDim2.new(0, 200, 0, 45), Vector3.new(0, 2.8, 0), true
                        local txt = Instance.new("TextLabel", bbGui)
                        txt.Name, txt.Size, txt.BackgroundTransparency, txt.Font, txt.TextSize, txt.TextColor3 = "Info", UDim2.new(1, 0, 1, 0), 1, Enum.Font.GothamBold, 11, Color3.fromRGB(255, 60, 90)
                    end
                    bbGui.Info.Text = string.format("%s\n[%dm] • HP: %d/%d", p.DisplayName, dist, math.floor(hum.Health), math.floor(hum.MaxHealth))
                else
                    if head and head:FindFirstChild("Zenith_PlayerBillboard") then head.Zenith_PlayerBillboard:Destroy() end
                end
            end
        end
    end
end)

local detectedChests = {}
task.spawn(function()
    while true do
        detectedChests = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name, pName = string.lower(obj.Name), obj.Parent and string.lower(obj.Parent.Name) or ""
                if string.find(name, "chest") or string.find(pName, "chest") then
                    local tier = 1
                    if string.find(name, "3") or string.find(pName, "3") or string.find(name, "diamond") then tier = 3
                    elseif string.find(name, "2") or string.find(pName, "2") or string.find(name, "gold") or string.find(name, "silver") then tier = 2 end
                    table.insert(detectedChests, {Part = obj, Tier = tier})
                end
            end
        end
        task.wait(3)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then continue end

        for _, obj in ipairs(Workspace:GetChildren()) do
            if (obj:IsA("Tool") and string.find(obj.Name, "Fruit")) or obj:FindFirstChild("Fruit") then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    if espFruitEnabled then
                        local b = handle:FindFirstChild("Zenith_FruitESP")
                        if not b then
                            b = Instance.new("BillboardGui", handle)
                            b.Name, b.Size, b.StudsOffset, b.AlwaysOnTop = "Zenith_FruitESP", UDim2.new(0, 180, 0, 30), Vector3.new(0, 2, 0), true
                            local t = Instance.new("TextLabel", b)
                            t.Name, t.Size, t.BackgroundTransparency, t.Font, t.TextSize, t.TextColor3 = "Label", UDim2.new(1, 0, 1, 0), 1, Enum.Font.GothamBold, 12, Color3.fromRGB(255, 70, 220)
                        end
                        b.Label.Text = string.format("🍎 %s\n[%dm]", obj.Name, math.floor((handle.Position - myHRP.Position).Magnitude))
                    else
                        if handle:FindFirstChild("Zenith_FruitESP") then handle.Zenith_FruitESP:Destroy() end
                    end
                end
            end
        end
        
        for _, item in ipairs(detectedChests) do
            local rootPart, tier = item.Part, item.Tier
            if rootPart and rootPart.Parent then
                local shouldShow = (tier == 1 and espChest1Enabled) or (tier == 2 and espChest2Enabled) or (tier == 3 and espChest3Enabled)
                if shouldShow then
                    local b = rootPart:FindFirstChild("Zenith_ChestESP")
                    if not b then
                        b = Instance.new("BillboardGui", rootPart)
                        b.Name, b.Size, b.StudsOffset, b.AlwaysOnTop = "Zenith_ChestESP", UDim2.new(0, 160, 0, 25), Vector3.new(0, 2, 0), true
                        local t = Instance.new("TextLabel", b)
                        t.Name, t.Size, t.BackgroundTransparency, t.Font, t.TextSize = "Label", UDim2.new(1, 0, 1, 0), 1, Enum.Font.GothamBold, 11
                    end
                    b.Label.TextColor3 = (tier == 3 and Color3.fromRGB(0, 240, 255)) or (tier == 2 and Color3.fromRGB(255, 215, 0)) or Color3.fromRGB(205, 127, 50)
                    b.Label.Text = string.format("%s [%dm]", (tier == 3 and "💎 Diamond") or (tier == 2 and "🪙 Gold") or "📦 Bronze", math.floor((rootPart.Position - myHRP.Position).Magnitude))
                else
                    if rootPart:FindFirstChild("Zenith_ChestESP") then rootPart.Zenith_ChestESP:Destroy() end
                end
            end
        end
    end
end)

-- Tự động thao tác Trái ác quỷ
task.spawn(function() while true do task.wait(5) if AutoRandomFruit then pcall(function() CommF:InvokeServer("Cousin", "Buy") end) end end end)
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
                        if firetouchinterest then firetouchinterest(LocalPlayer.Character.HumanoidRootPart, handle, 0); task.wait(); firetouchinterest(LocalPlayer.Character.HumanoidRootPart, handle, 1) end
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
                if backpack then for _, item in ipairs(backpack:GetChildren()) do if string.find(item.Name, "Fruit") or item:FindFirstChild("Fruit") then CommF:InvokeServer("StoreFruit", item.Name, item) end end end
                if char then for _, item in ipairs(char:GetChildren()) do if item:IsA("Tool") and (string.find(item.Name, "Fruit") or item:FindFirstChild("Fruit")) then CommF:InvokeServer("StoreFruit", item.Name, item) end end end
            end)
        end
    end
end)

-- Tự động đứng trên nước
task.spawn(function()
    local waterPlatform = Instance.new("Part")
    waterPlatform.Name, waterPlatform.Size, waterPlatform.Transparency, waterPlatform.Anchored, waterPlatform.CanCollide = "Zenith_WaterPlatform", Vector3.new(120, 1, 120), 1, true, true
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
                waterPlatform.CFrame, waterPlatform.CanCollide = CFrame.new(hrp.Position.X, 0.5, hrp.Position.Z), true
            else
                waterPlatform.CFrame, waterPlatform.CanCollide = CFrame.new(hrp.Position.X, -500, hrp.Position.Z), false
            end
        end
    end)
end)


-- ===================================================
-- 5. HỆ THỐNG ĐỘC LẬP: AURA AFK & GOM QUÁI (FIX 100% NO DAMAGE & LỖI ĐƠ)
-- ===================================================
local isAttackingTarget = false

-- Luồng 1: Xả sát thương ngầm hoàn toàn độc lập (Không bị kẹt bởi nhận nhiệm vụ)
task.spawn(function()
    while true do
        if AutoFarmLevel and isAttackingTarget then
            pcall(function()
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end

                local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
                local controller = CbFw.activeController
                if not controller and debug.getupvalues then
                    for _, v in pairs(debug.getupvalues(CbFw)) do
                        if type(v) == "table" and v.activeController then controller = v.activeController break end
                    end
                end
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
            task.wait(0.12)
        else
            task.wait(0.2)
        end
    end
end)

-- Luồng 2: Di chuyển và nhận nhiệm vụ độc lập
local currentTween = nil
local function toTargetPos(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    if currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing then return end
    local distance = (root.Position - targetCFrame.Position).Magnitude
    if distance < 3 then return end
    local speed = 350 
    local time = distance / speed
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

local lockedFarmPosition = nil

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
                        if not lockedFarmPosition or (lockedFarmPosition.Position - primaryHRP.Position).Magnitude > 300 then
                            lockedFarmPosition = primaryHRP.CFrame
                        end
                        
                        local groundPos = lockedFarmPosition.Position
                        local attackPos = CFrame.new(groundPos.X, groundPos.Y + 6, groundPos.Z)
                        local lookAtPos = CFrame.lookAt(attackPos.Position, groundPos)
                        
                        if (myHRP.Position - attackPos.Position).Magnitude > 3 then
                            isAttackingTarget = false 
                            toTargetPos(lookAtPos)
                        else
                            if currentTween then currentTween:Cancel(); currentTween = nil end
                            
                            myHRP.CFrame = lookAtPos
                            myHRP.AssemblyLinearVelocity = Vector3.zero
                            isAttackingTarget = true
                            
                            if BringMob then
                                for _, otherMob in ipairs(mobList) do
                                    local oHRP, oHum = otherMob:FindFirstChild("HumanoidRootPart"), otherMob:FindFirstChildOfClass("Humanoid")
                                    if oHRP and oHum and oHum.Health > 0 and (oHRP.Position - groundPos).Magnitude <= 350 then
                                        oHRP.CFrame = CFrame.new(groundPos)
                                        oHRP.AssemblyLinearVelocity = Vector3.zero
                                        oHRP.CanCollide = false
                                        oHum.WalkSpeed = 0
                                        oHum.JumpPower = 0
                                        oHum.Sit = true
                                    end
                                end
                            end
                        end
                    end
                else 
                    isAttackingTarget = false
                    lockedFarmPosition = nil
                end
            end
        else 
            isAttackingTarget = false 
            lockedFarmPosition = nil
            if currentTween then currentTween:Cancel(); currentTween = nil end 
        end
    end
end)
