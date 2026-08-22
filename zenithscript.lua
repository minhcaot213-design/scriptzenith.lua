-- [[ ZENITH BLOX FRUIT - V12.24 (FIX ESP + AUTO FARM CHUẨN) ]] --

task.wait(0.5)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
local AutoFarm = false
local AutoQuest = true
local BringMob = false  -- TẮT GOM QUÁI để tránh giật
local flightHeight = 28
local attackSpeed = 0.04

-- ESP
local espPlayer = false
local espFruit = false
local espChest = false

-- Speed / Jump
local speedEnabled = false
local speedValue = 16
local jumpEnabled = false
local jumpValue = 50

-- Fruit
local autoBuyFruit = false
local autoCollectFruit = false
local autoStoreFruit = false

-- ===================================================
-- 1. UI ĐƠN GIẢN (KHÔNG CẦN NHIỀU TAB)
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
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 380)
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
local isDragging, dragStart, frameStart = false, nil, nil
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        frameStart = MainFrame.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = (input.Position - dragStart) / UIScale.Scale
        MainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

-- TOPBAR
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 18, 26)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.RichText = true
Title.Text = "ZYROX VN <font color='#00d2ff'>• V12.24</font>"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

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

-- CONTENT
local Content = Instance.new("ScrollingFrame", MainFrame)
Content.Size = UDim2.new(1, 0, 1, -38)
Content.Position = UDim2.new(0, 0, 0, 38)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0, 6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- HÀM TẠO TOGGLE
local function createToggle(labelText, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(0.94, 0, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 225, 235)
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    
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

-- HÀM TẠO SLIDER
local function createSlider(labelText, min, max, default, callback, isFloat)
    local current = default or min
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(0.94, 0, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -70, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 225, 235)
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    
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
    track.Position = UDim2.new(0.03, 0, 0, 24)
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

-- HÀM TẠO BUTTON
local function createButton(labelText, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(0.94, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    btn.Text = labelText
    btn.TextColor3 = Color3.fromRGB(0, 210, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(0, 180, 255)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

-- ===================================================
-- TẠO UI
-- ===================================================
local infoLabel = Instance.new("TextLabel", Content)
infoLabel.Size = UDim2.new(0.94, 0, 0, 28)
infoLabel.BackgroundTransparency = 1
infoLabel.RichText = true
infoLabel.Text = "⚡ Sẵn sàng"
infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextSize = 11

-- Weapon selector
local weaponFrame = Instance.new("Frame", Content)
weaponFrame.Size = UDim2.new(0.94, 0, 0, 26)
weaponFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Instance.new("UICorner", weaponFrame).CornerRadius = UDim.new(0, 5)
local wLayout = Instance.new("UIListLayout", weaponFrame)
wLayout.FillDirection = Enum.FillDirection.Horizontal
wLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
wLayout.VerticalAlignment = Enum.VerticalAlignment.Center
wLayout.Padding = UDim.new(0, 3)

local weaponBtns = {}
local weapons = {"Melee", "Sword", "Blox Fruit"}
local icons = {"🥊", "⚔️", "🍎"}
for i, name in ipairs(weapons) do
    local b = Instance.new("TextButton", weaponFrame)
    b.Size = UDim2.new(0.3, 0, 0.8, 0)
    b.BackgroundColor3 = (selectedWeaponType == name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
    b.Text = icons[i]
    b.TextColor3 = (selectedWeaponType == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
    weaponBtns[name] = b
    b.MouseButton1Click:Connect(function()
        selectedWeaponType = name
        for n, btn in pairs(weaponBtns) do
            btn.BackgroundColor3 = (n == name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
            btn.TextColor3 = (n == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
        end
    end)
end

createToggle("⚡ AFK Farm (Bay + Đánh)", false, function(v) AutoFarm = v end)
createToggle("📜 Tự Nhận Nhiệm Vụ", true, function(v) AutoQuest = v end)
createToggle("🧲 Gom Quái (TẮT để đánh mượt)", false, function(v) BringMob = v end)
createSlider("🏔️ Chiều Cao Bay", 10, 50, 28, function(v) flightHeight = v end, false)
createSlider("⚡ Tốc Độ Đánh (s)", 0.01, 0.2, 0.04, function(v) attackSpeed = v end, true)

-- ESP
createToggle("👤 ESP Người Chơi", false, function(v) espPlayer = v end)
createToggle("🍎 ESP Trái Ác Quỷ", false, function(v) espFruit = v end)
createToggle("📦 ESP Rương", false, function(v) espChest = v end)

-- Speed / Jump
createToggle("🏃 Bật Chạy Nhanh", false, function(v) speedEnabled = v end)
createSlider("🏃 Tốc Độ", 16, 300, 16, function(v) speedValue = v end, false)
createToggle("🦘 Bật Nhảy Cao", false, function(v) jumpEnabled = v end)
createSlider("🦘 Lực Nhảy", 50, 400, 50, function(v) jumpValue = v end, false)

-- Fruit
createToggle("🎲 Mua Trái Ngẫu Nhiên", false, function(v) autoBuyFruit = v end)
createToggle("🧲 Nhặt Trái Rơi", false, function(v) autoCollectFruit = v end)
createToggle("📦 Cất Trái Vào Rương", false, function(v) autoStoreFruit = v end)

-- Server
createButton("🎁 Nhập Code Game", function()
    local codes = {"ADMINHACKED", "ADMINDARES", "SECRET_ADMIN", "NOOB2PRO", "StrawHatMaine", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "THEGREATACE", "SUB2GAMERROBOT_EXP1", "Sub2OfficialNoobie", "FUDD10", "BIGNEWS", "KITT_RESET", "SUB2NOOBMASTER123", "Sub2UncleKizaru", "Sub2Daigrock", "Axiore", "TantaiGaming", "FUDD10_V2", "CHANDLER", "GAMER_ROBOT_1M", "TY_FOR_WATCHING", "UPD16", "3BVISITS", "2BILLION"}
    task.spawn(function() for _, c in ipairs(codes) do pcall(function() CommF:InvokeServer("RedeemCustomCode", c) end) task.wait(0.1) end end)
end)
createButton("🔄 Vào Lại Server", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
createButton("🌐 Chuyển Server", function()
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
createButton("🔧 Tối Ưu FPS", function()
    Lighting.GlobalShadows = not Lighting.GlobalShadows
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end
    end
end)
createButton("❌ Đóng Cửa Sổ", function() ScreenGui:Destroy() end)

-- ===================================================
-- 2. ESP (ĐƠN GIẢN, KHÔNG GIẬT)
-- ===================================================
local espCache = {}

local function updateESP(parent, name, text, color)
    if not parent then return end
    local bb = espCache[parent .. name]
    if not bb then
        bb = Instance.new("BillboardGui", parent)
        bb.Name = name
        bb.Size = UDim2.new(0, 160, 0, 28)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        local label = Instance.new("TextLabel", bb)
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 10
        label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
        bb.Label = label
        espCache[parent .. name] = bb
    end
    bb.Label.Text = text or ""
    if color then bb.Label.TextColor3 = color end
    bb.Enabled = true
    return bb
end

task.spawn(function()
    while true do
        task.wait(0.3)
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then continue end
        
        -- Player ESP
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local head = p.Character:FindFirstChild("Head")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if espPlayer and head and hum and hum.Health > 0 then
                    local dist = math.floor((head.Position - myHRP.Position).Magnitude)
                    updateESP(head, "Zenith_Player", string.format("%s [%dm] HP:%d/%d", p.DisplayName, dist, math.floor(hum.Health), math.floor(hum.MaxHealth)), Color3.fromRGB(255, 60, 90))
                else
                    if head and espCache[head .. "Zenith_Player"] then espCache[head .. "Zenith_Player"].Enabled = false end
                end
            end
        end
        
        -- Fruit ESP
        for _, obj in ipairs(Workspace:GetChildren()) do
            if espFruit and ((obj:IsA("Tool") and string.find(obj.Name, "Fruit")) or obj:FindFirstChild("Fruit")) then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    local dist = math.floor((handle.Position - myHRP.Position).Magnitude)
                    updateESP(handle, "Zenith_Fruit", string.format("🍎 %s [%dm]", obj.Name, dist), Color3.fromRGB(255, 70, 220))
                end
            else
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle and espCache[handle .. "Zenith_Fruit"] then espCache[handle .. "Zenith_Fruit"].Enabled = false end
            end
        end
        
        -- Chest ESP
        if espChest then
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and (string.find(string.lower(part.Name), "chest") or (part.Parent and string.find(string.lower(part.Parent.Name), "chest"))) then
                    local dist = math.floor((part.Position - myHRP.Position).Magnitude)
                    updateESP(part, "Zenith_Chest", string.format("📦 Chest [%dm]", dist), Color3.fromRGB(255, 215, 0))
                else
                    if espCache[part .. "Zenith_Chest"] then espCache[part .. "Zenith_Chest"].Enabled = false end
                end
            end
        else
            for k, v in pairs(espCache) do
                if string.find(k, "Zenith_Chest") then v.Enabled = false end
            end
        end
    end
end)

-- ===================================================
-- 3. SPEED / JUMP
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
    while true do task.wait(5) if autoBuyFruit then pcall(function() CommF:InvokeServer("Cousin", "Buy") end) end end
end)
task.spawn(function()
    while true do
        task.wait(1)
        if autoCollectFruit and not AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
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
        if autoStoreFruit and CommF then
            pcall(function()
                local backpack, char = LocalPlayer:FindFirstChild("Backpack"), LocalPlayer.Character
                if backpack then for _, item in ipairs(backpack:GetChildren()) do if string.find(item.Name, "Fruit") then CommF:InvokeServer("StoreFruit", item.Name, item) end end end
                if char then for _, item in ipairs(char:GetChildren()) do if item:IsA("Tool") and string.find(item.Name, "Fruit") then CommF:InvokeServer("StoreFruit", item.Name, item) end end end
            end)
        end
    end
end)

-- ===================================================
-- 5. AUTO FARM (CHUẨN - BAY ĐẾN QUÁI, ĐÁNH, KHÔNG LẶP)
-- ===================================================
local hasQuest = false
local lastQuestCheck = 0

-- Kiểm tra quest chính xác
local function checkHasQuest()
    -- Kiểm tra trong Data
    local questData = LocalPlayer:FindFirstChild("Quest")
    if questData and questData.Value ~= "" and questData.Value ~= nil then
        return true, questData.Value
    end
    -- Kiểm tra UI
    local questGui = LocalPlayer.PlayerGui:FindFirstChild("Quest")
    if questGui and questGui.Enabled then
        return true, "Unknown"
    end
    return false, nil
end

local function getQuestByLevel()
    local lv = LocalPlayer.Data and LocalPlayer.Data.Level and LocalPlayer.Data.Level.Value or 1
    local quests = {
        {MonName = "Bandit", QuestName = "BanditQuest1", QuestLevel = 1},
        {MonName = "Gorilla", QuestName = "GorillaQuest1", QuestLevel = 50},
        {MonName = "Dragon", QuestName = "DragonQuest1", QuestLevel = 120},
        {MonName = "Ice", QuestName = "IceQuest1", QuestLevel = 200},
        {MonName = "Dark", QuestName = "DarkQuest1", QuestLevel = 300},
        {MonName = "Light", QuestName = "LightQuest1", QuestLevel = 400},
        {MonName = "Dough", QuestName = "DoughQuest1", QuestLevel = 500},
    }
    for _, q in ipairs(quests) do
        if lv >= q.QuestLevel then return q end
    end
    return quests[#quests]
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

local function equipWeapon()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local list = {}
        if backpack then for _, tool in ipairs(backpack:GetChildren()) do if tool:IsA("Tool") then table.insert(list, tool) end end end
        if char then for _, tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") then table.insert(list, tool) end end end
        
        local function match(t, name)
            local n = string.lower(name)
            if t == "Melee" and (string.find(n, "melee") or string.find(n, "fist") or string.find(n, "combat") or string.find(n, "fighting")) then return true
            elseif t == "Sword" and (string.find(n, "sword") or string.find(n, "blade") or string.find(n, "katana") or string.find(n, "cutlass") or string.find(n, "saber")) then return true
            elseif t == "Blox Fruit" and (string.find(n, "fruit") or string.find(n, "devil") or string.find(n, "paw") or string.find(n, "buddha") or string.find(n, "light") or string.find(n, "dough")) then return true
            end
            return false
        end
        
        for _, tool in ipairs(list) do
            if match(selectedWeaponType, tool.Name) then
                if tool.Parent == backpack then
                    CommF:InvokeServer("EquipTool", tool)
                    task.wait(0.1)
                end
                return
            end
        end
        -- Fallback: equip first tool
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
    local current = root.Position
    local dist = (target - current).Magnitude
    
    if dist < 3 then
        root.AssemblyLinearVelocity = Vector3.zero
        return true
    end
    
    local dir = (target - current).Unit
    root.AssemblyLinearVelocity = dir * 100
    
    local yDiff = flightHeight - current.Y
    if math.abs(yDiff) > 1 then
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, yDiff * 3, root.AssemblyLinearVelocity.Z)
    end
    return false
end

local function attack()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() task.wait(0.01) tool:Activate() end
        
        local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
        local c = CbFw.activeController
        if not c then
            for _, v in pairs(debug.getupvalues(CbFw)) do
                if type(v) == "table" and v.activeController then c = v.activeController break end
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

-- MAIN FARM THREAD
task.spawn(function()
    while true do
        task.wait(0.1)
        if not AutoFarm then
            task.wait(0.5)
            continue
        end
        
        local char = LocalPlayer.Character
        if not char then task.wait(0.5) continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(0.5) continue end
        
        -- NHẬN QUEST
        if AutoQuest then
            local has, questName = checkHasQuest()
            if not has then
                local q = getQuestByLevel()
                if q then
                    pcall(function()
                        CommF:InvokeServer("StartQuest", q.QuestName, q.QuestLevel)
                        infoLabel.Text = "📜 Đã nhận quest: " .. q.MonName
                    end)
                    task.wait(0.5)
                end
            else
                hasQuest = true
            end
        end
        
        local questData = getQuestByLevel()
        if not questData then
            infoLabel.Text = "⚠️ Không có nhiệm vụ"
            task.wait(1)
            continue
        end
        
        local mobs = getEnemies(questData.MonName)
        if #mobs == 0 then
            infoLabel.Text = string.format("🔍 Tìm %s...", questData.MonName)
            task.wait(0.3)
            continue
        end
        
        -- Tìm quái gần nhất
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
        
        local lv = LocalPlayer.Data.Level.Value
        infoLabel.Text = string.format("⚔️ %s | Lv.%d | Quái: %d", questData.MonName, lv, #mobs)
        
        equipWeapon()
        
        -- BAY ĐẾN QUÁI
        local dist = (targetHRP.Position - root.Position).Magnitude
        if dist > 15 then
            local reached = flyTo(targetHRP.Position)
            if not reached then
                task.wait(0.05)
                continue
            end
        end
        
        -- ĐÁNH KHI ĐẾN GẦN
        if dist <= 20 then
            -- Giữ độ cao
            local y = root.Position.Y
            if y < flightHeight - 1 then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 15, root.AssemblyLinearVelocity.Z)
            elseif y > flightHeight + 1 then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -5, root.AssemblyLinearVelocity.Z)
            else
                root.AssemblyLinearVelocity = Vector3.zero
            end
            
            -- Quay mặt vào quái
            local look = (targetHRP.Position - root.Position).Unit
            if look.Magnitude > 0 then
                root.CFrame = CFrame.lookAt(root.Position, root.Position + look * 10)
            end
            
            -- GOM QUÁI (CHỈ KHI BẬT)
            if BringMob then
                for _, mob in ipairs(mobs) do
                    local hrp = mob:FindFirstChild("HumanoidRootPart")
                    local hum = mob:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local d = (hrp.Position - root.Position).Magnitude
                        if d > 15 and d < 80 then
                            hrp.CFrame = CFrame.new(root.Position + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3)))
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
            
            -- SPAM ĐÁNH
            for i = 1, 10 do
                if not AutoFarm then break end
                attack()
                task.wait(attackSpeed)
            end
        end
        
        -- THOÁT HIỂM
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < hum.MaxHealth * 0.2 then
            root.AssemblyLinearVelocity = Vector3.new(0, 40, 0)
            task.wait(0.5)
        end
        
        task.wait(0.05)
    end
end)

-- DUY TRÌ ĐỘ CAO (KHI KHÔNG FARM)
task.spawn(function()
    while true do
        task.wait(0.1)
        if not AutoFarm then task.wait(0.5) continue end
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

print("✅ ZENITH V12.24 - FIX ESP + AUTO FARM CHUẨN")
print("📌 Bật 'AFK Farm' để bắt đầu farm")
print("📌 TẮT 'Gom Quái' để đánh mượt hơn")
print("📌 ESP hoạt động khi bật các toggle tương ứng")
