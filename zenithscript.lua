-- [[ ZENITH BLOX FRUIT - V34.0 (THE TRUE GROUND MAGNET) ]] --
-- QUÁI GOM DƯỚI MẶT ĐẤT - PLAYER LƠ LỬNG AN TOÀN - CHÉM BÀN THỜ

task.wait(0.5)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- =========================================================
-- SERVICES & BIẾN TOÀN CỤC
-- =========================================================
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

-- CHỐNG AFK CRASH 
pcall(function()
    for i,v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end
end)
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

local selectedWeaponType = "Melee"
local AutoFarmLevel = false
local AutoQuest = true
local BringMob = true

local espPlayerEnabled = false
local espFruitEnabled = false
local espChest1Enabled, espChest2Enabled, espChest3Enabled = false, false, false

local speedValue, speedEnabled = 16, false
local jumpValue, jumpEnabled = 50, false

local AutoRandomFruit = false
local AutoCollectFruit = false
local AutoStoreFruit = false

-- =========================================================
-- BẢN ĐỒ TỌA ĐỘ GPS CỨNG
-- =========================================================
local IslandPositions = {
    ["Bandit"] = Vector3.new(1057, 16, 1378),
    ["Monkey"] = Vector3.new(-1598, 36, 153),
    ["Gorilla"] = Vector3.new(-1166, 22, -493),
    ["Pirate"] = Vector3.new(-1141, 4, 3828),
    ["Brute"] = Vector3.new(-1141, 4, 3828),
    ["Desert Bandit"] = Vector3.new(895, 6, 4390),
    ["Desert Officer"] = Vector3.new(895, 6, 4390),
    ["Snow Bandit"] = Vector3.new(1386, 87, -1298),
    ["Snowman"] = Vector3.new(1386, 87, -1298),
    ["Chief Petty Officer"] = Vector3.new(-4884, 21, 4301),
    ["Sky Bandit"] = Vector3.new(-4842, 717, -2623),
    ["Dark Master"] = Vector3.new(-4842, 717, -2623),
    ["Prisoner"] = Vector3.new(4875, 5, 735),
    ["Peanut Scout"] = Vector3.new(-2051, 37, -10254)
}

-- =========================================================
-- GIAO DIỆN HIỆN ĐẠI (GIỮ NGUYÊN 100% MENU GỐC)
-- =========================================================
local UI_NAME = "ZenithTrueHub_V34"
local function GetSafeParent()
    local success, parent = pcall(function() return gethui() end)
    if success and parent then return parent end
    local success2, parent2 = pcall(function() return game:GetService("CoreGui") end)
    if success2 and parent2 then return parent2 end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local targetParent = GetSafeParent()
pcall(function() if targetParent:FindFirstChild(UI_NAME) then targetParent[UI_NAME]:Destroy() end end)
pcall(function() if LocalPlayer.PlayerGui:FindFirstChild(UI_NAME) then LocalPlayer.PlayerGui[UI_NAME]:Destroy() end end)
pcall(function() if game:GetService("CoreGui"):FindFirstChild(UI_NAME) then game:GetService("CoreGui")[UI_NAME]:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME; ScreenGui.ResetOnSpawn = false; ScreenGui.Parent = targetParent

local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 48, 0, 48); FloatingButton.Position = UDim2.new(0.1, 0, 0.5, 0); FloatingButton.BackgroundColor3 = Color3.fromRGB(13, 16, 22); FloatingButton.Visible = false; FloatingButton.Text = "Z"; FloatingButton.TextColor3 = Color3.fromRGB(0, 210, 255); FloatingButton.Font = Enum.Font.GothamBlack; FloatingButton.TextSize = 24; FloatingButton.ZIndex = 999
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", FloatingButton).Color = Color3.fromRGB(0, 210, 255); Instance.new("UIStroke", FloatingButton).Thickness = 1.5

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 350); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19); MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true
local UIScale = Instance.new("UIScale", MainFrame)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 210, 255); Instance.new("UIStroke", MainFrame).Thickness = 1.5

local isDraggingWindow, isDraggingFloating = false, false
local dragStartPos, frameStartPos

MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingWindow = true; dragStartPos = input.Position; frameStartPos = MainFrame.Position end end)
FloatingButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingFloating = true; dragStartPos = input.Position; frameStartPos = FloatingButton.Position end end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if isDraggingFloating then isDraggingFloating = false; if dragStartPos and (input.Position - dragStartPos).Magnitude < 12 then FloatingButton.Visible = false; MainFrame.Visible = true end end
        isDraggingWindow = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    if isDraggingWindow and MainFrame.Visible then local delta = (input.Position - dragStartPos) / UIScale.Scale; MainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
    elseif isDraggingFloating and FloatingButton.Visible then local delta = (input.Position - dragStartPos) / UIScale.Scale; FloatingButton.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y) end
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38); TopBar.BackgroundColor3 = Color3.fromRGB(14, 18, 27); TopBar.BorderSizePixel = 0
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 240, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1; Title.RichText = true; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "ZYROX VN <font color='#00d2ff'>• V34.0 (TRUE MAGNET)</font>"

local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 24, 0, 24); CloseBtn.Position = UDim2.new(1, -28, 0.5, -12); CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90); CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 10; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
local MinBtn = Instance.new("TextButton", TopBar); MinBtn.Size = UDim2.new(0, 24, 0, 24); MinBtn.Position = UDim2.new(1, -56, 0.5, -12); MinBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 38); MinBtn.Text = "−"; MinBtn.TextColor3 = Color3.fromRGB(160, 170, 190); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 13; Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingButton.Visible = true end)
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame:TweenSize(isMinimized and UDim2.new(0, 560, 0, 38) or UDim2.new(0, 560, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
end)

local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Name = "Sidebar"; Sidebar.Size = UDim2.new(0, 155, 1, -38); Sidebar.Position = UDim2.new(0, 0, 0, 38); Sidebar.BackgroundColor3 = Color3.fromRGB(12, 15, 22); Sidebar.BorderSizePixel = 0
local TabScroller = Instance.new("ScrollingFrame", Sidebar); TabScroller.Size = UDim2.new(1, -8, 1, -12); TabScroller.Position = UDim2.new(0, 4, 0, 6); TabScroller.BackgroundTransparency = 1; TabScroller.BorderSizePixel = 0; TabScroller.ScrollBarThickness = 3; TabScroller.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); TabScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIPadding", TabScroller).PaddingTop = UDim.new(0, 3)
local TabListLayout = Instance.new("UIListLayout", TabScroller); TabListLayout.Padding = UDim.new(0, 4); TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local ContentContainer = Instance.new("Frame", MainFrame); ContentContainer.Name = "ContentContainer"; ContentContainer.Size = UDim2.new(1, -155, 1, -38); ContentContainer.Position = UDim2.new(0, 155, 0, 38); ContentContainer.BackgroundTransparency = 1

local function styleToggleFrame(frame)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 29); frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    local stroke = Instance.new("UIStroke", frame); stroke.Color = Color3.fromRGB(31, 39, 54); stroke.Thickness = 1
end

local function styleButton(btn)
    btn.BackgroundColor3 = Color3.fromRGB(19, 25, 36); btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    local stroke = Instance.new("UIStroke", btn); if stroke then stroke.Color = Color3.fromRGB(0, 170, 230); stroke.Thickness = 1; stroke.Transparency = 0.2 end
end

local tabButtons, tabPages = {}, {}

local function createTab(name, icon, label)
    local btn = Instance.new("TextButton", TabScroller); btn.Size = UDim2.new(1, -4, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(25, 30, 42); btn.TextColor3 = Color3.fromRGB(175, 185, 205); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 11; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.Text = "  " .. icon .. "   " .. label
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    local Pill = Instance.new("Frame", btn); Pill.Size = UDim2.new(0, 3, 0, 18); Pill.Position = UDim2.new(0, 0, 0.5, -9); Pill.BackgroundColor3 = Color3.fromRGB(0, 210, 255); Pill.Visible = false; Instance.new("UICorner", Pill).CornerRadius = UDim.new(0, 2)
    
    local page = Instance.new("ScrollingFrame", ContentContainer); page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0; page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.Visible = false
    local pl = Instance.new("UIListLayout", page); pl.Padding = UDim.new(0, 6); pl.HorizontalAlignment = Enum.HorizontalAlignment.Center; pl.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 10); Instance.new("UIPadding", page).PaddingBottom = UDim.new(0, 10)

    tabButtons[name] = {Button = btn, Pill = Pill}; tabPages[name] = page

    btn.MouseButton1Click:Connect(function()
        for tName, item in pairs(tabButtons) do
            local act = (tName == name)
            item.Button.BackgroundColor3 = act and Color3.fromRGB(38, 105, 190) or Color3.fromRGB(25, 30, 42)
            item.Button.TextColor3 = act and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(175, 185, 205)
            item.Pill.Visible = act
        end
        for pName, p in pairs(tabPages) do p.Visible = (pName == name) end
    end)
    return page
end

local function createToggle(page, labelText, defaultState, callback)
    local state = defaultState
    local frame = Instance.new("Frame", page); frame.Size = UDim2.new(0.94, 0, 0, 34); styleToggleFrame(frame)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, -50, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(220, 225, 235); label.Font = Enum.Font.Gotham; label.TextSize = 11; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = labelText
    local switch = Instance.new("TextButton", frame); switch.Size = UDim2.new(0, 32, 0, 16); switch.Position = UDim2.new(1, -40, 0.5, -8); switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54); switch.Text = ""; Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch); circle.Size = UDim2.new(0, 12, 0, 12); circle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    switch.MouseButton1Click:Connect(function()
        state = not state; switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), "Out", "Quad", 0.15, true)
        if callback then callback(state) end
    end)
end

local function createSlider(page, labelText, min, max, default, callback)
    local current = default or min
    local frame = Instance.new("Frame", page); frame.Size = UDim2.new(0.94, 0, 0, 44); styleToggleFrame(frame)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, -70, 0, 20); label.Position = UDim2.new(0, 10, 0, 3); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(220, 225, 235); label.Font = Enum.Font.Gotham; label.TextSize = 11; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = labelText
    local valueLabel = Instance.new("TextLabel", frame); valueLabel.Size = UDim2.new(0, 55, 0, 20); valueLabel.Position = UDim2.new(1, -65, 0, 3); valueLabel.BackgroundTransparency = 1; valueLabel.Text = tostring(current); valueLabel.TextColor3 = Color3.fromRGB(0, 210, 255); valueLabel.Font = Enum.Font.GothamBold; valueLabel.TextSize = 11; valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    local track = Instance.new("TextButton", frame); track.Size = UDim2.new(0.94, 0, 0, 4); track.Position = UDim2.new(0.03, 0, 0, 28); track.BackgroundColor3 = Color3.fromRGB(35, 42, 58); track.AutoButtonColor = false; track.Text = ""; Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track); fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 190, 255); Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local isDraggingSlider = false
    local function update(percent)
        percent = math.clamp(percent, 0, 1); fill.Size = UDim2.new(percent, 0, 1, 0); current = math.floor(min + (max - min) * percent); valueLabel.Text = tostring(current); if callback then callback(current) end
    end
    track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingSlider = true; update((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingSlider = false end end)
    UserInputService.InputChanged:Connect(function(input) if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update((UserInputService:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X) end end)
end

local function createButton(page, labelText, callback)
    local btn = Instance.new("TextButton", page); btn.Size = UDim2.new(0.94, 0, 0, 30); styleButton(btn); btn.TextColor3 = Color3.fromRGB(0, 210, 255); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 11; btn.Text = labelText
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

-- TẠO 7 TAB ĐẦY ĐỦ
local farmPage = createTab("Farm", "🌾", "Cày Cấp (Farm)")
local fruitPage = createTab("Fruit", "🍎", "Trái Ác Quỷ")
local pvpPage = createTab("PVP-ESP", "⚔️", "PVP & ESP")
local serverPage = createTab("Server", "🌐", "Máy Chủ")
local raidPage = createTab("RAID", "⚡", "Đi Raid")
local itemPage = createTab("FARM ITEM", "🗡️", "Farm Item")
local settingPage = createTab("SETTING", "⚙️", "Cài Đặt")

tabButtons["Farm"].Button.BackgroundColor3 = Color3.fromRGB(38, 105, 190); tabButtons["Farm"].Button.TextColor3 = Color3.fromRGB(255, 255, 255); tabButtons["Farm"].Pill.Visible = true; tabPages["Farm"].Visible = true

-- [ TAB FARM ]
local infoLabel = Instance.new("TextLabel", farmPage); infoLabel.Size = UDim2.new(0.94, 0, 0, 25); infoLabel.BackgroundTransparency = 1; infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150); infoLabel.Font = Enum.Font.GothamBold; infoLabel.TextSize = 12

local weaponSegment = Instance.new("Frame", farmPage); weaponSegment.Size = UDim2.new(0.94, 0, 0, 28); weaponSegment.BackgroundColor3 = Color3.fromRGB(15, 18, 25); Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
local wsLayout = Instance.new("UIListLayout", weaponSegment); wsLayout.FillDirection = Enum.FillDirection.Horizontal; wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; wsLayout.Padding = UDim.new(0, 3)

local weaponBtns = {}
local weaponList = {{name = "Melee", label = "🥊 Melee"}, {name = "Sword", label = "⚔️ Sword"}, {name = "Blox Fruit", label = "🍎 Fruit"}}
for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size = UDim2.new(0.3, 0, 0.78, 0); b.BackgroundColor3 = selectedWeaponType == wData.name and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48); b.TextColor3 = selectedWeaponType == wData.name and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170); b.Font = Enum.Font.GothamMedium; b.TextSize = 10; b.Text = wData.label; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); weaponBtns[wData.name] = b
    b.MouseButton1Click:Connect(function()
        selectedWeaponType = wData.name
        for name, btn in pairs(weaponBtns) do
            btn.BackgroundColor3 = name == wData.name and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
            btn.TextColor3 = name == wData.name and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
        end
    end)
end

createToggle(farmPage, "⚡ Kích Hoạt Auto Farm (Bypass Pro)", false, function(v) AutoFarmLevel = v end)
createToggle(farmPage, "📜 Tự Nhận Nhiệm Vụ", true, function(v) AutoQuest = v end)
createToggle(farmPage, "🧲 Gom Quái Mặt Đất (Gắn Chặt)", true, function(v) BringMob = v end)

-- [ CÁC TAB CÒN LẠI ]
createToggle(fruitPage, "🎲 Mua Ngẫu Nhiên Trái", false, function(v) AutoRandomFruit = v end)
createToggle(fruitPage, "🧲 Tự Nhặt Trái Rơi", false, function(v) AutoCollectFruit = v end)
createToggle(fruitPage, "📦 Tự Cất Trái Vào Rương", false, function(v) AutoStoreFruit = v end)

createToggle(pvpPage, "🏃‍♂️ Bật Chạy Nhanh", false, function(v) speedEnabled = v end)
createSlider(pvpPage, "Tốc Độ", 16, 300, 16, function(val) speedValue = val end)
createToggle(pvpPage, "🦘 Bật Nhảy Cao", false, function(v) jumpEnabled = v end)
createSlider(pvpPage, "Lực Nhảy", 50, 400, 50, function(val) jumpValue = val end)
createToggle(pvpPage, "👁️ Hiện Vị Trí Người Chơi", false, function(v) espPlayerEnabled = v end)

createButton(serverPage, "🎁 Tự Nhập Code", function()
    local codes = {"ADMINHACKED", "ADMINDARES", "SECRET_ADMIN", "NOOB2PRO", "StrawHatMaine", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "THEGREATACE", "SUB2GAMERROBOT_EXP1"}
    task.spawn(function() for _, c in ipairs(codes) do pcall(function() if CommF then CommF:InvokeServer("RedeemCustomCode", c) end end); task.wait(0.1) end end)
end)
createButton(serverPage, "🔄 Rejoin Server", function() pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end) end)

createToggle(raidPage, "⚡ Tự Động Đi Raid", false, function(v) end)
createToggle(itemPage, "☠️ Tự Farm Xương", false, function(v) end)

createToggle(settingPage, "🚀 Giảm Giật Cấu Hình", false, function(v)
    Lighting.GlobalShadows = not v
    if v then for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end end end
end)
createButton(settingPage, "❌ Tắt Menu (Đóng Script)", function() ScreenGui:Destroy() end)

-- =========================================================
-- ĐỔI VŨ KHÍ TỰ ĐỘNG
-- =========================================================
task.spawn(function()
    while task.wait(0.5) do
        if AutoFarmLevel then
            pcall(function()
                local char = LocalPlayer.Character
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                local currentTool = char and char:FindFirstChildOfClass("Tool")
                
                local needEquip = true
                if currentTool and (string.find(currentTool.ToolTip, selectedWeaponType) or currentTool.Name == "Combat" or currentTool.Name == "Võ Tân Binh") then needEquip = false end
                
                if needEquip and backpack and humanoid then
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and (string.find(tool.ToolTip, selectedWeaponType) or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then humanoid:EquipTool(tool); break end
                    end
                end
                if not char:FindFirstChild("HasBuso") and CommF then CommF:InvokeServer("Buso") end
            end)
        end
    end
end)

-- =========================================================
-- ĐỘNG CƠ C-FRAME & GIỮ CHÂN TRÊN KHÔNG
-- =========================================================
local FlyTarget = nil
RunService.Heartbeat:Connect(function(deltaTime)
    pcall(function()
        if AutoFarmLevel and FlyTarget and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hrp and hum then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
                hum.Sit = false

                local bv = hrp:FindFirstChild("GodMode_BV")
                if not bv then bv = Instance.new("BodyVelocity"); bv.Name = "GodMode_BV"; bv.MaxForce = Vector3.new(0, math.huge, 0); bv.Velocity = Vector3.new(0, 0, 0); bv.Parent = hrp end

                local dist = (hrp.Position - FlyTarget.Position).Magnitude
                if dist > 3 then
                    local speed = 350
                    local moveDist = speed * deltaTime
                    if moveDist > dist then hrp.CFrame = FlyTarget else hrp.CFrame = CFrame.lookAt(hrp.Position, FlyTarget.Position) * CFrame.new(0, 0, -moveDist) end
                else
                    hrp.CFrame = FlyTarget
                end
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        else
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("GodMode_BV") then hrp.GodMode_BV:Destroy() end
        end
    end)
end)

-- =========================================================
-- LÕI CHÉM NHANH (KHÔNG THỂ XỊT)
-- =========================================================
task.spawn(function()
    while task.wait() do
        if AutoFarmLevel then
            pcall(function()
                -- Dùng Tool Activate liên tục
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                
                -- Bơm thêm VirtualUser Input (Tác dụng rất mạnh trên LDPlayer)
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(9999, 9999))
            end)
        end
    end
end)

-- =========================================================
-- LOGIC NHIỆM VỤ & GOM QUÁI (DƯỚI MẶT ĐẤT - PLAYER Y+12)
-- =========================================================
local function getAutoQuestByLevel()
    local level = 1
    pcall(function() level = LocalPlayer.Data.Level.Value end)
    if level <= 9 then return {QuestName = "BanditQuest1", QuestLevel = 1, MonName = "Bandit"}
    elseif level <= 14 then return {QuestName = "JungleQuest", QuestLevel = 1, MonName = "Monkey"}
    elseif level <= 29 then return {QuestName = "JungleQuest", QuestLevel = 2, MonName = "Gorilla"}
    elseif level <= 39 then return {QuestName = "BuggyQuest1", QuestLevel = 1, MonName = "Pirate"}
    elseif level <= 59 then return {QuestName = "BuggyQuest1", QuestLevel = 2, MonName = "Brute"}
    elseif level <= 74 then return {QuestName = "DesertQuest", QuestLevel = 1, MonName = "Desert Bandit"}
    elseif level <= 89 then return {QuestName = "DesertQuest", QuestLevel = 2, MonName = "Desert Officer"}
    elseif level <= 99 then return {QuestName = "SnowQuest", QuestLevel = 1, MonName = "Snow Bandit"}
    elseif level <= 119 then return {QuestName = "SnowQuest", QuestLevel = 2, MonName = "Snowman"}
    elseif level <= 149 then return {QuestName = "MarineQuest2", QuestLevel = 1, MonName = "Chief Petty Officer"}
    elseif level <= 174 then return {QuestName = "SkyQuest", QuestLevel = 1, MonName = "Sky Bandit"}
    elseif level <= 189 then return {QuestName = "SkyQuest", QuestLevel = 2, MonName = "Dark Master"}
    elseif level <= 209 then return {QuestName = "PrisonerQuest", QuestLevel = 1, MonName = "Prisoner"}
    else return {QuestName = "PeanutQuest", QuestLevel = 1, MonName = "Peanut Scout"} end
end

local function checkHasQuest()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    return pGui and pGui:FindFirstChild("Main") and pGui.Main:FindFirstChild("Quest") and pGui.Main.Quest.Visible or false
end

local function getClosestMob(monName)
    local closestMob = nil
    local shortestDistance = math.huge
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not Workspace:FindFirstChild("Enemies") or not myHRP then return nil end
    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
        if mob.Name == monName then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local dist = (myHRP.Position - hrp.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestMob = mob
                end
            end
        end
    end
    return closestMob
end

local function GetMobSpawn(monName)
    local origin = Workspace:FindFirstChild("_WorldOrigin")
    local spawns = origin and origin:FindFirstChild("EnemySpawns")
    if spawns then
        for _, spawnPart in ipairs(spawns:GetChildren()) do
            if spawnPart.Name == monName or string.find(string.lower(spawnPart.Name), string.lower(monName)) then return spawnPart.CFrame end
        end
    end
    return nil
end

local lockedFarmPosition = nil

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if AutoFarmLevel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local currentQuest = getAutoQuestByLevel()
                if currentQuest then
                    local mobName = currentQuest.MonName
                    infoLabel.Text = string.format("Đang Farm: %s [Cấp %d]", mobName, LocalPlayer.Data.Level.Value)

                    if AutoQuest and not checkHasQuest() and CommF then
                        CommF:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.QuestLevel)
                        task.wait(0.5)
                    end

                    local targetMob = getClosestMob(mobName)
                    local targetPos = nil

                    -- TÌM BÃI QUÁI
                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        local primaryHRP = targetMob.HumanoidRootPart
                        if not lockedFarmPosition or (lockedFarmPosition.Position - primaryHRP.Position).Magnitude > 300 then
                            lockedFarmPosition = primaryHRP.CFrame
                        end
                        -- BẠN: LƠ LỬNG CAO ĐÚNG 12 MÉT (TRONG TẦM CHÉM CỦA GAME)
                        targetPos = CFrame.new(lockedFarmPosition.Position.X, lockedFarmPosition.Position.Y + 12, lockedFarmPosition.Position.Z)
                    else
                        lockedFarmPosition = nil
                        local spawnCFrame = GetMobSpawn(mobName)
                        if spawnCFrame then
                            lockedFarmPosition = spawnCFrame
                            targetPos = CFrame.new(spawnCFrame.Position.X, spawnCFrame.Position.Y + 12, spawnCFrame.Position.Z)
                        elseif IslandPositions[mobName] then
                            lockedFarmPosition = CFrame.new(IslandPositions[mobName])
                            targetPos = CFrame.new(IslandPositions[mobName] + Vector3.new(0, 12, 0))
                        end
                    end

                    if targetPos and lockedFarmPosition then
                        FlyTarget = targetPos
                        local myHRP = LocalPlayer.Character.HumanoidRootPart
                        local dist = (myHRP.Position - targetPos.Position).Magnitude
                        
                        -- KHI ĐÃ ĐẾN NƠI -> NHÌN XUỐNG VÀ GOM QUÁI
                        if dist <= 5 then
                            myHRP.CFrame = CFrame.lookAt(targetPos.Position, lockedFarmPosition.Position)

                            if BringMob then
                                for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                                    if mob.Name == mobName then
                                        local oHRP = mob:FindFirstChild("HumanoidRootPart")
                                        local oHum = mob:FindFirstChildOfClass("Humanoid")
                                        if oHRP and oHum and oHum.Health > 0 then
                                            -- QUÁI VẬT: DÍNH CHẶT Ở DƯỚI MẶT ĐẤT
                                            oHRP.CFrame = lockedFarmPosition
                                            
                                            -- HITBOX 25: ĐẢM BẢO CHÉM TỪ TRÊN 12 MÉT XUỐNG VẪN NỔ MÁU
                                            oHRP.Size = Vector3.new(25, 25, 25)
                                            oHRP.Transparency = 1
                                            oHRP.CanCollide = false
                                            oHRP.AssemblyLinearVelocity = Vector3.zero
                                            
                                            -- Đóng băng não quái
                                            local animator = oHum:FindFirstChild("Animator")
                                            if animator then animator:Destroy() end
                                            
                                            oHum.WalkSpeed = 0
                                            oHum.JumpPower = 0
                                            oHum.Sit = true
                                            oHum:ChangeState(11) -- StrafingNoPhysics (Tắt AI hoàn toàn)
                                        end
                                    end
                                end
                            end
                        end
                    else
                        FlyTarget = nil
                    end
                end
            else
                lockedFarmPosition = nil
                FlyTarget = nil
            end
        end)
    end
end)
