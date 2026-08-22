-- [[ ZENITH BLOX FRUIT - V12.24 (SIMPLE UI + FIX AUTO FARM) ]] --

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
local selectedWeapon = "Melee"
local AutoFarm = false
local AutoQuest = true
local flightHeight = 28
local attackSpeed = 0.04
local espPlayer = false
local espFruit = false
local espChest = false
local speedEnabled = false
local speedValue = 16
local jumpEnabled = false
local jumpValue = 50
local autoBuyFruit = false
local autoCollectFruit = false
local autoStoreFruit = false

-- ===================================================
-- 1. UI ĐƠN GIẢN (KHÔNG LỖI FONT)
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

-- MAIN FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 420)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(30, 36, 50)
Instance.new("UIStroke", MainFrame).Thickness = 1

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
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZYROX VN - V12.24"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- NÚT FLOATING (Z)
local FloatingBtn = Instance.new("TextButton", ScreenGui)
FloatingBtn.Size = UDim2.new(0, 44, 0, 44)
FloatingBtn.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(13, 15, 22)
FloatingBtn.Visible = false
FloatingBtn.Text = "Z"
FloatingBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
FloatingBtn.Font = Enum.Font.GothamBlack
FloatingBtn.TextSize = 24
Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", FloatingBtn).Color = Color3.fromRGB(0, 200, 255)
FloatingBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatingBtn.Visible = false
end)

-- CONTENT SCROLL
local Content = Instance.new("ScrollingFrame", MainFrame)
Content.Size = UDim2.new(1, 0, 1, -32)
Content.Position = UDim2.new(0, 0, 0, 32)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 3
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ===================================================
-- HÀM TẠO UI
-- ===================================================
local function addToggle(text, default, callback)
    local state = default or false
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(0.94, 0, 0, 28)
    frame.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 225, 235)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    
    local sw = Instance.new("TextButton", frame)
    sw.Size = UDim2.new(0, 28, 0, 14)
    sw.Position = UDim2.new(1, -36, 0.5, -7)
    sw.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
    sw.Text = ""
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", sw)
    circle.Size = UDim2.new(0, 10, 0, 10)
    circle.Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    sw.MouseButton1Click:Connect(function()
        state = not state
        sw.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
        if callback then callback(state) end
    end)
end

local function addSlider(text, min, max, default, callback, isFloat)
    local current = default or min
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(0.94, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -70, 0, 16)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 225, 235)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valLabel = Instance.new("TextLabel", frame)
    valLabel.Size = UDim2.new(0, 50, 0, 16)
    valLabel.Position = UDim2.new(1, -58, 0, 2)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = isFloat and string.format("%.2f", current) or tostring(current)
    valLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 11
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    
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
    
    local dragging = false
    local function update(percent)
        fill.Size = UDim2.new(math.clamp(percent, 0, 1), 0, 1, 0)
        if isFloat then
            current = min + (max - min) * math.clamp(percent, 0, 1)
            valLabel.Text = string.format("%.2f", current)
        else
            current = math.floor(min + (max - min) * math.clamp(percent, 0, 1))
            valLabel.Text = tostring(current)
        end
        if callback then callback(current) end
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update((UserInputService:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
        end
    end)
end

local function addButton(text, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(0.94, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 200, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(0, 180, 255)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

-- ===================================================
-- TẠO UI
-- ===================================================
local infoLabel = Instance.new("TextLabel", Content)
infoLabel.Size = UDim2.new(0.94, 0, 0, 28)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "⚡ Sẵn sàng"
infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextSize = 12

-- Weapon select
local wFrame = Instance.new("Frame", Content)
wFrame.Size = UDim2.new(0.94, 0, 0, 26)
wFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
Instance.new("UICorner", wFrame).CornerRadius = UDim.new(0, 4)
local wLayout = Instance.new("UIListLayout", wFrame)
wLayout.FillDirection = Enum.FillDirection.Horizontal
wLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
wLayout.VerticalAlignment = Enum.VerticalAlignment.Center
wLayout.Padding = UDim.new(0, 4)

local wBtns = {}
local wList = {"Melee", "Sword", "Fruit"}
local wIcons = {"🥊", "⚔️", "🍎"}
for i, name in ipairs(wList) do
    local b = Instance.new("TextButton", wFrame)
    b.Size = UDim2.new(0.3, 0, 0.8, 0)
    b.BackgroundColor3 = (selectedWeapon == name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
    b.Text = wIcons[i]
    b.TextColor3 = (selectedWeapon == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 170, 190)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    wBtns[name] = b
    b.MouseButton1Click:Connect(function()
        selectedWeapon = name
        for n, btn in pairs(wBtns) do
            btn.BackgroundColor3 = (n == name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
            btn.TextColor3 = (n == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 170, 190)
        end
    end)
end

addToggle("⚡ AFK Farm", false, function(v) AutoFarm = v end)
addToggle("📜 Auto Quest", true, function(v) AutoQuest = v end)
addSlider("🏔️ Độ cao bay", 10, 50, 28, function(v) flightHeight = v end, false)
addSlider("⚡ Tốc đánh (s)", 0.01, 0.2, 0.04, function(v) attackSpeed = v end, true)

addToggle("👤 ESP Player", false, function(v) espPlayer = v end)
addToggle("🍎 ESP Fruit", false, function(v) espFruit = v end)
addToggle("📦 ESP Chest", false, function(v) espChest = v end)

addToggle("🏃 Speed", false, function(v) speedEnabled = v end)
addSlider("🏃 Speed", 16, 300, 16, function(v) speedValue = v end, false)
addToggle("🦘 Jump", false, function(v) jumpEnabled = v end)
addSlider("🦘 Jump", 50, 400, 50, function(v) jumpValue = v end, false)

addToggle("🎲 Buy Fruit", false, function(v) autoBuyFruit = v end)
addToggle("🧲 Collect Fruit", false, function(v) autoCollectFruit = v end)
addToggle("📦 Store Fruit", false, function(v) autoStoreFruit = v end)

addButton("🎁 Redeem Codes", function()
    local codes = {"ADMINHACKED", "ADMINDARES", "SECRET_ADMIN", "NOOB2PRO", "StrawHatMaine", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "THEGREATACE", "SUB2GAMERROBOT_EXP1", "Sub2OfficialNoobie", "FUDD10", "BIGNEWS", "KITT_RESET", "SUB2NOOBMASTER123", "Sub2UncleKizaru", "Sub2Daigrock", "Axiore", "TantaiGaming", "FUDD10_V2", "CHANDLER", "GAMER_ROBOT_1M", "TY_FOR_WATCHING", "UPD16", "3BVISITS", "2BILLION"}
    task.spawn(function() for _, c in ipairs(codes) do pcall(function() CommF:InvokeServer("RedeemCustomCode", c) end) task.wait(0.1) end end)
end)
addButton("🔄 Rejoin", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
addButton("🌐 Server Hop", function()
    local success, res = pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end)
    if success and res and res.data then
        for _, s in ipairs(res.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end
end)
addButton("🔧 Boost FPS", function()
    Lighting.GlobalShadows = not Lighting.GlobalShadows
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end
    end
end)
addButton("❌ Close", function() ScreenGui:Destroy() end)

-- ===================================================
-- 2. ESP
-- ===================================================
local espCache = {}

local function updateESP(parent, name, text, color)
    if not parent then return end
    local bb = espCache[parent .. name]
    if not bb then
        bb = Instance.new("BillboardGui", parent)
        bb.Name = name
        bb.Size = UDim2.new(0, 160, 0, 26)
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
end

task.spawn(function()
    while true do
        task.wait(0.3)
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        
        -- Player
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local head = p.Character:FindFirstChild("Head")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if espPlayer and head and hum and hum.Health > 0 then
                    local dist = math.floor((head.Position - root.Position).Magnitude)
                    updateESP(head, "Zenith_Player", string.format("%s [%dm] HP:%d", p.DisplayName, dist, math.floor(hum.Health)), Color3.fromRGB(255, 60, 90))
                elseif head and espCache[head .. "Zenith_Player"] then
                    espCache[head .. "Zenith_Player"].Enabled = false
                end
            end
        end
        
        -- Fruit
        for _, obj in ipairs(Workspace:GetChildren()) do
            if espFruit and ((obj:IsA("Tool") and string.find(obj.Name, "Fruit")) or obj:FindFirstChild("Fruit")) then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    local dist = math.floor((handle.Position - root.Position).Magnitude)
                    updateESP(handle, "Zenith_Fruit", string.format("🍎 %s [%dm]", obj.Name, dist), Color3.fromRGB(255, 70, 220))
                end
            else
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle and espCache[handle .. "Zenith_Fruit"] then espCache[handle .. "Zenith_Fruit"].Enabled = false end
            end
        end
        
        -- Chest
        if espChest then
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and (string.find(string.lower(part.Name), "chest") or (part.Parent and string.find(string.lower(part.Parent.Name), "chest"))) then
                    local dist = math.floor((part.Position - root.Position).Magnitude)
                    updateESP(part, "Zenith_Chest", string.format("📦 Chest [%dm]", dist), Color3.fromRGB(255, 215, 0))
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
    if speedEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.MoveDirection.Magnitude > 0 then
            root.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * speedValue, root.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * speedValue)
        end
    end
end)
UserInputService.JumpRequest:Connect(function()
    if jumpEnabled and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, jumpValue, root.AssemblyLinearVelocity.Z)
        end
    end
end)

-- ===================================================
-- 4. FRUIT AUTO
-- ===================================================
task.spawn(function()
    while true do
        task.wait(5)
        if autoBuyFruit then pcall(function() CommF:InvokeServer("Cousin", "Buy") end) end
    end
end)
task.spawn(function()
    while true do
        task.wait(1)
        if autoCollectFruit and LocalPlayer.Character then
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
        if autoStoreFruit then
            pcall(function()
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local char = LocalPlayer.Character
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if string.find(item.Name, "Fruit") then CommF:InvokeServer("StoreFruit", item.Name, item) end
                    end
                end
                if char then
                    for _, item in ipairs(char:GetChildren()) do
                        if item:IsA("Tool") and string.find(item.Name, "Fruit") then CommF:InvokeServer("StoreFruit", item.Name, item) end
                    end
                end
            end)
        end
    end
end)

-- ===================================================
-- 5. AUTO FARM (CHUẨN - KHÔNG LẶP, KHÔNG GIẬT)
-- ===================================================
local function checkQuest()
    local q = LocalPlayer:FindFirstChild("Quest")
    if q and q.Value ~= "" and q.Value ~= nil then return true end
    local gui = LocalPlayer.PlayerGui:FindFirstChild("Quest")
    if gui and gui.Enabled then return true end
    return false
end

local function getQuest()
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
    for _, q in ipairs(qs) do if lv >= q.Lv then return q end end
    return qs[#qs]
end

local function getMobs(name)
    local list = {}
    local lower = string.lower(name)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local n = string.lower(obj.Name)
                if string.find(n, lower) then
                    table.insert(list, obj)
                end
            end
        end
    end
    return list
end

local function equipTool()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local list = {}
        if backpack then for _, t in ipairs(backpack:GetChildren()) do if t:IsA("Tool") then table.insert(list, t) end end end
        if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then table.insert(list, t) end end end
        
        local function match(t, n)
            local nl = string.lower(n)
            if t == "Melee" and (string.find(nl, "melee") or string.find(nl, "fist") or string.find(nl, "combat")) then return true
            elseif t == "Sword" and (string.find(nl, "sword") or string.find(nl, "blade") or string.find(nl, "katana") or string.find(nl, "cutlass")) then return true
            elseif t == "Fruit" and (string.find(nl, "fruit") or string.find(nl, "devil") or string.find(nl, "paw") or string.find(nl, "buddha") or string.find(nl, "light") or string.find(nl, "dough")) then return true
            end
            return false
        end
        
        for _, t in ipairs(list) do
            if match(selectedWeapon, t.Name) and t.Parent == backpack then
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

local function doAttack()
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
            for i = 1, 5 do
                c:attack()
                task.wait(0.008)
            end
        end
    end)
end

-- MAIN LOOP
task.spawn(function()
    local lastQuestTime = 0
    local isFarming = false
    
    while true do
        task.wait(0.1)
        if not AutoFarm then
            isFarming = false
            task.wait(0.5)
            continue
        end
        
        local char = LocalPlayer.Character
        if not char then task.wait(0.5) continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(0.5) continue end
        
        -- QUEST
        if AutoQuest then
            if not checkQuest() and tick() - lastQuestTime > 2 then
                local q = getQuest()
                if q then
                    pcall(function()
                        CommF:InvokeServer("StartQuest", q.Name, q.Lv)
                        infoLabel.Text = "📜 Quest: " .. q.Mon
                    end)
                    lastQuestTime = tick()
                end
            end
        end
        
        local quest = getQuest()
        if not quest then
            infoLabel.Text = "⚠️ No quest"
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
        
        equipTool()
        
        -- BAY ĐẾN
        local dist = (tHRP.Position - root.Position).Magnitude
        if dist > 15 then
            flyTo(tHRP.Position)
            task.wait(0.05)
            continue
        end
        
        -- ĐÁNH
        if dist <= 18 then
            -- GIỮ ĐỘ CAO
            local y = root.Position.Y
            if y < flightHeight - 1 then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 15, root.AssemblyLinearVelocity.Z)
            elseif y > flightHeight + 1 then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -5, root.AssemblyLinearVelocity.Z)
            else
                root.AssemblyLinearVelocity = Vector3.zero
            end
            
            -- QUAY MẶT
            local look = (tHRP.Position - root.Position).Unit
            if look.Magnitude > 0 then
                root.CFrame = CFrame.lookAt(root.Position, root.Position + look * 10)
            end
            
            -- SPAM ĐÁNH
            for i = 1, 10 do
                if not AutoFarm then break end
                doAttack()
                task.wait(attackSpeed)
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

print("✅ ZENITH V12.24 - UI ĐƠN GIẢN + AUTO FARM CHUẨN")
print("📌 Bật 'AFK Farm' để farm")
print("📌 ESP hoạt động khi bật toggle")
