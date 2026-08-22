-- [[ ZENITH BLOX FRUIT - COMPACT HUB (WEAPON SELECTOR & UI SCALE) ]] --

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- ===================================================
-- 0. DỌN DẸP INSTANCE CŨ (CLEANUP)
-- ===================================================
local UI_NAME = "ZenithBloxFruit_Compact"
local function getSafeParent()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then return coreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local parentGui = getSafeParent()
if parentGui:FindFirstChild(UI_NAME) then parentGui[UI_NAME]:Destroy() end
if Workspace:FindFirstChild("Zenith_WaterPlatform") then Workspace.Zenith_WaterPlatform:Destroy() end

-- ===================================================
-- 1. TỰ ĐỘNG ĐỨNG TRÊN NƯỚC (ALWAYS ACTIVE)
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
            local hrp = char.HumanoidRootPart
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            
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
-- 2. DỮ LIỆU QUEST, QUÁI & VŨ KHÍ
-- ===================================================
local QuestMap = {
    -- SEA 1
    ["Bandit [Lv. 5]"] = {QuestName = "BanditQuest1", QuestLevel = 1, MonName = "Bandit"},
    ["Monkey [Lv. 14]"] = {QuestName = "JungleQuest", QuestLevel = 1, MonName = "Monkey"},
    ["Gorilla [Lv. 20]"] = {QuestName = "JungleQuest", QuestLevel = 2, MonName = "Gorilla"},
    ["Pirate [Lv. 35]"] = {QuestName = "BuggyQuest1", QuestLevel = 1, MonName = "Pirate"},
    ["Brute [Lv. 45]"] = {QuestName = "BuggyQuest1", QuestLevel = 2, MonName = "Brute"},
    ["Desert Bandit [Lv. 60]"] = {QuestName = "DesertQuest", QuestLevel = 1, MonName = "Desert Bandit"},
    ["Snowman [Lv. 100]"] = {QuestName = "SnowQuest", QuestLevel = 1, MonName = "Snowman"},
    
    -- SEA 2
    ["Raider [Lv. 700]"] = {QuestName = "Area1Quest", QuestLevel = 1, MonName = "Raider"},
    ["Mercenary [Lv. 725]"] = {QuestName = "Area1Quest", QuestLevel = 2, MonName = "Mercenary"},
    ["Swan Pirate [Lv. 775]"] = {QuestName = "Area2Quest", QuestLevel = 1, MonName = "Swan Pirate"},
    ["Factory Staff [Lv. 800]"] = {QuestName = "Area2Quest", QuestLevel = 2, MonName = "Factory Staff"},

    -- SEA 3
    ["Pirate Millionaire [Lv. 1500]"] = {QuestName = "PiratePortQuest", QuestLevel = 1, MonName = "Pirate Millionaire"},
    ["Pistol Billionaire [Lv. 1525]"] = {QuestName = "PiratePortQuest", QuestLevel = 2, MonName = "Pistol Billionaire"},
    ["Dragon Crew Warrior [Lv. 1575]"] = {QuestName = "DragonCrewQuest", QuestLevel = 1, MonName = "Dragon Crew Warrior"}
}

local SeaCategories = {
    ["Sea 1"] = {"Bandit [Lv. 5]", "Monkey [Lv. 14]", "Gorilla [Lv. 20]", "Pirate [Lv. 35]", "Brute [Lv. 45]", "Desert Bandit [Lv. 60]", "Snowman [Lv. 100]"},
    ["Sea 2"] = {"Raider [Lv. 700]", "Mercenary [Lv. 725]", "Swan Pirate [Lv. 775]", "Factory Staff [Lv. 800]"},
    ["Sea 3"] = {"Pirate Millionaire [Lv. 1500]", "Pistol Billionaire [Lv. 1525]", "Dragon Crew Warrior [Lv. 1575]"}
}

local selectedSea = "Sea 1"
local selectedMobKey = SeaCategories["Sea 1"][1]
local selectedWeaponType = "Melee" -- "Melee", "Sword", "Blox Fruit", "Gun"

local AutoFarm = false
local AutoQuest = true
local BringMob = false

-- ===================================================
-- 3. SPEED & HIGH JUMP (PVP MODULE)
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
-- 4. LOGIC FARM & VŨ KHÍ
-- ===================================================
local currentTween = nil

local function toTargetPos(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    local distance = (root.Position - targetCFrame.Position).Magnitude
    local speed = 250
    local time = distance / speed

    if currentTween then currentTween:Cancel() end
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
end

RunService.Stepped:Connect(function()
    if AutoFarm and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

local function equipChosenWeapon()
    local char = LocalPlayer.Character
    if not char then return end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Kiểm tra xem đã cầm đúng loại vũ khí chưa
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            if item.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (item.ToolTip == "Melee" or item.ToolTip == "Combat")) then
                return
            end
        end
    end

    -- Tìm trong balo để trang bị
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if tool.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (tool.ToolTip == "Melee" or tool.ToolTip == "Combat")) then
                    humanoid:EquipTool(tool)
                    break
                end
            end
        end
    end
end

local function checkHasQuest()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui and playerGui:FindFirstChild("Main") then
        local questFrame = playerGui.Main:FindFirstChild("Quest")
        if questFrame and questFrame.Visible then
            return true
        end
    end
    return false
end

local function getEnemyInstance(monName)
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return nil end

    for _, mob in ipairs(enemies:GetChildren()) do
        if string.find(mob.Name, monName) then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                return mob
            end
        end
    end
    return nil
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local mobData = QuestMap[selectedMobKey]
            if mobData then
                if AutoQuest and not checkHasQuest() then
                    CommF:InvokeServer("StartQuest", mobData.QuestName, mobData.QuestLevel)
                    task.wait(0.5)
                end

                local mob = getEnemyInstance(mobData.MonName)
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    equipChosenWeapon()
                    local mobHRP = mob.HumanoidRootPart
                    local targetCFrame = mobHRP.CFrame * CFrame.new(0, 8, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    
                    if (LocalPlayer.Character.HumanoidRootPart.Position - mobHRP.Position).Magnitude > 15 then
                        toTargetPos(targetCFrame)
                    else
                        if currentTween then currentTween:Cancel() end
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
                        LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero

                        VirtualUser:CaptureController()
                        VirtualUser:Button1Down(Vector2.new(0, 0))

                        if BringMob then
                            local enemies = Workspace:FindFirstChild("Enemies")
                            if enemies then
                                for _, other in ipairs(enemies:GetChildren()) do
                                    if other ~= mob and string.find(other.Name, mobData.MonName) then
                                        local oHRP = other:FindFirstChild("HumanoidRootPart")
                                        local oHum = other:FindFirstChildOfClass("Humanoid")
                                        if oHRP and oHum and oHum.Health > 0 then
                                            oHRP.CFrame = mobHRP.CFrame
                                            oHRP.CanCollide = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            if currentTween then currentTween:Cancel() end
        end
    end
end)

-- ===================================================
-- 5. GIAO DIỆN NHỎ GỌN (COMPACT UI & SCALING)
-- ===================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentGui

-- Khung cửa sổ kích thước nhỏ gọn mặc định: 500 x 310
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 310)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Bộ scale phóng to / thu nhỏ UI
local UIScale = Instance.new("UIScale")
UIScale.Scale = 1.0
UIScale.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(35, 38, 50)
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- Kéo thả cửa sổ
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
        local delta = (input.Position - dragStartPos) / UIScale.Scale
        MainFrame.Position = UDim2.new(
            frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
            frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y
        )
    end
end)

-- TopBar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 34)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZENITH <font color='#00d2ff'>BLOX FRUIT</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -29, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 33, 45)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 125, 1, -34)
Sidebar.Position = UDim2.new(0, 0, 0, 34)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 19, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 3)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.Parent = Sidebar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 6)
TabPadding.Parent = Sidebar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -125, 1, -34)
ContentContainer.Position = UDim2.new(0, 125, 0, 34)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local tabButtons = {}
local tabPages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.BorderSizePixel = 0
    page.Visible = false
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = ContentContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = page

    tabPages[name] = page
    return page
end

local function switchTab(name)
    for tName, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = (tName == name) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(24, 26, 35)
        btn.TextColor3 = (tName == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 165, 180)
    end
    for pName, page in pairs(tabPages) do
        page.Visible = (pName == name)
    end
end

local function createTabButton(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(24, 26, 35)
    btn.BorderSizePixel = 0
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(160, 165, 180)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.Parent = Sidebar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn

    tabButtons[name] = btn
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

local function createToggle(page, text, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
    frame.BorderSizePixel = 0
    frame.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 34, 0, 17)
    switch.Position = UDim2.new(1, -42, 0.5, -8)
    switch.BackgroundColor3 = state and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(45, 48, 65)
    switch.Text = ""
    switch.BorderSizePixel = 0
    switch.Parent = frame

    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = switch

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 11, 0, 11)
    circle.Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = switch

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(1, 0)
    cc.Parent = circle

    switch.MouseButton1Click:Connect(function()
        state = not state
        switch.BackgroundColor3 = state and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(45, 48, 65)
        circle.Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
        if callback then callback(state) end
    end)
end

local function createSlider(page, text, min, max, default, callback)
    local current = default or min
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 46)
    frame.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
    frame.BorderSizePixel = 0
    frame.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 3)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 55, 0, 20)
    valueLabel.Position = UDim2.new(1, -65, 0, 3)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(current)
    valueLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local track = Instance.new("TextButton")
    track.Size = UDim2.new(0.94, 0, 0, 4)
    track.Position = UDim2.new(0.03, 0, 0, 30)
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
    btn.Size = UDim2.new(0.92, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(26, 28, 40)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 180, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- ===================================================
-- 6. SETUP TABS & NỘI DUNG
-- ===================================================
local cats = {
    {"Farm", "🌾"}, {"Server", "🌐"}, {"PVP-ESP", "⚔️"},
    {"RAID", "⚡"}, {"FARM ITEM", "🗡️"}, {"SETTING", "⚙️"}
}
for _, c in ipairs(cats) do
    createTabButton(c[1], c[2])
    createPage(c[1])
end

-- [TAB FARM]
local farmPage = tabPages["Farm"]

-- Chọn Sea (1, 2, 3)
local seaFrame = Instance.new("Frame")
seaFrame.Size = UDim2.new(0.92, 0, 0, 30)
seaFrame.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
seaFrame.BorderSizePixel = 0
seaFrame.Parent = farmPage

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 5)
sCorner.Parent = seaFrame

local sLayout = Instance.new("UIListLayout")
sLayout.FillDirection = Enum.FillDirection.Horizontal
sLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sLayout.VerticalAlignment = Enum.VerticalAlignment.Center
sLayout.Padding = UDim.new(0, 5)
sLayout.Parent = seaFrame

local seaBtns = {}
local mobListScroll

local function updateMobList()
    if not mobListScroll then return end
    for _, ch in ipairs(mobListScroll:GetChildren()) do
        if ch:IsA("TextButton") then ch:Destroy() end
    end

    for _, mobKey in ipairs(SeaCategories[selectedSea]) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.95, 0, 0, 24)
        b.BackgroundColor3 = (selectedMobKey == mobKey) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(28, 30, 42)
        b.Text = mobKey
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.Gotham
        b.TextSize = 10
        b.BorderSizePixel = 0
        b.Parent = mobListScroll

        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 4)
        bc.Parent = b

        b.MouseButton1Click:Connect(function()
            selectedMobKey = mobKey
            updateMobList()
        end)
    end
end

for _, sName in ipairs({"Sea 1", "Sea 2", "Sea 3"}) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.3, 0, 0.75, 0)
    b.BackgroundColor3 = (selectedSea == sName) and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(32, 35, 48)
    b.Text = sName
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.BorderSizePixel = 0
    b.Parent = seaFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = b

    seaBtns[sName] = b
    b.MouseButton1Click:Connect(function()
        selectedSea = sName
        for k, btn in pairs(seaBtns) do
            btn.BackgroundColor3 = (k == sName) and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(32, 35, 48)
        end
        selectedMobKey = SeaCategories[sName][1]
        updateMobList()
    end)
end

-- Bộ chọn loại vũ khí (Melee, Sword, Blox Fruit, Gun)
local weaponFrame = Instance.new("Frame")
weaponFrame.Size = UDim2.new(0.92, 0, 0, 30)
weaponFrame.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
weaponFrame.BorderSizePixel = 0
weaponFrame.Parent = farmPage

local wCorner = Instance.new("UICorner")
wCorner.CornerRadius = UDim.new(0, 5)
wCorner.Parent = weaponFrame

local wLayout = Instance.new("UIListLayout")
wLayout.FillDirection = Enum.FillDirection.Horizontal
wLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
wLayout.VerticalAlignment = Enum.VerticalAlignment.Center
wLayout.Padding = UDim.new(0, 4)
wLayout.Parent = weaponFrame

local weaponBtns = {}
local weaponList = {
    {name = "Melee", label = "🥊 Melee"},
    {name = "Sword", label = "⚔️ Sword"},
    {name = "Blox Fruit", label = "🍎 Fruit"},
    {name = "Gun", label = "🔫 Gun"}
}

for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.23, 0, 0.75, 0)
    b.BackgroundColor3 = (selectedWeaponType == wData.name) and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(32, 35, 48)
    b.Text = wData.label
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 10
    b.BorderSizePixel = 0
    b.Parent = weaponFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = b

    weaponBtns[wData.name] = b
    b.MouseButton1Click:Connect(function()
        selectedWeaponType = wData.name
        for name, btn in pairs(weaponBtns) do
            btn.BackgroundColor3 = (name == wData.name) and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(32, 35, 48)
        end
    end)
end

-- Danh sách chọn quái
mobListScroll = Instance.new("ScrollingFrame")
mobListScroll.Size = UDim2.new(0.92, 0, 0, 75)
mobListScroll.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
mobListScroll.BorderSizePixel = 0
mobListScroll.ScrollBarThickness = 3
mobListScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
mobListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
mobListScroll.Parent = farmPage

local mlc = Instance.new("UICorner")
mlc.CornerRadius = UDim.new(0, 5)
mlc.Parent = mobListScroll

local mll = Instance.new("UIListLayout")
mll.Padding = UDim.new(0, 3)
mll.HorizontalAlignment = Enum.HorizontalAlignment.Center
mll.Parent = mobListScroll

updateMobList()

createToggle(farmPage, "⚡ Auto Farm Level + Auto Quest", false, function(v)
    AutoFarm = v
end)

createToggle(farmPage, "📜 Tự Động Nhận Quest Phù Hợp", true, function(v)
    AutoQuest = v
end)

createToggle(farmPage, "🧲 Bring Mob (Gom Quái Lại Gần)", false, function(v)
    BringMob = v
end)

-- [TAB PVP-ESP]
local pvpPage = tabPages["PVP-ESP"]

createToggle(pvpPage, "Bật Tăng Tốc Độ (WalkSpeed)", false, function(v)
    speedEnabled = v
end)

createSlider(pvpPage, "Chỉnh Speed", 16, 300, 16, function(val)
    speedValue = val
end)

createToggle(pvpPage, "Bật Nhảy Cao (High Jump)", false, function(v)
    jumpEnabled = v
end)

createSlider(pvpPage, "Chỉnh JumpPower", 50, 400, 50, function(val)
    jumpValue = val
end)

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

-- [TAB SERVER]
local serverPage = tabPages["Server"]
createButton(serverPage, "Rejoin Server (Vào Lại)", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

createButton(serverPage, "Server Hop (Đổi Server Khác)", function()
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

-- [TAB FARM ITEM]
local farmItemPage = tabPages["FARM ITEM"]
createToggle(farmItemPage, "Auto Farm Bones (Xương)", false, function(v) end)
createToggle(farmItemPage, "Auto Collect Chests (Nhặt Rương)", false, function(v) end)

-- [TAB SETTING]
local settingPage = tabPages["SETTING"]

-- Thanh trượt điều chỉnh kích thước Menu Hub (60% - 140%)
createSlider(settingPage, "Kích Thước Giao Diện (UI Scale %)", 60, 140, 100, function(val)
    UIScale.Scale = val / 100
end)

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

switchTab("Farm")
