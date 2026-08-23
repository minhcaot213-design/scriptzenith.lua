-- [[ ZENITH BLOX FRUIT - V39.0 (HYBRID CORE) ]] --
-- UI: Zenith V34 (Gốc của bạn)
-- Logic Farm: Mượn 100% từ Script 10.000 dòng (Topos, BTP, Hitbox 60, NoClip)

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
local HttpService = game:GetService("HttpService")

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

local speedValue, speedEnabled = 16, false
local jumpValue, jumpEnabled = 50, false

-- BIẾN LOGIC FARM TỪ 10K SCRIPT
local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon
local StartBring = false
local PosMon = nil
local MonFarm = ""
local BypassTP = true

-- =========================================================
-- GIAO DIỆN HIỆN ĐẠI (GIỮ NGUYÊN 100% CỦA BẠN)
-- =========================================================
local UI_NAME = "ZenithTrueHub_V34_Hybrid"
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
Title.Text = "ZYROX VN <font color='#00d2ff'>• V39.0 (HYBRID CORE)</font>"

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

local farmPage = createTab("Farm", "🌾", "Cày Cấp (Farm)")
tabButtons["Farm"].Button.BackgroundColor3 = Color3.fromRGB(38, 105, 190); tabButtons["Farm"].Button.TextColor3 = Color3.fromRGB(255, 255, 255); tabButtons["Farm"].Pill.Visible = true; tabPages["Farm"].Visible = true

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

createToggle(farmPage, "⚡ Kích Hoạt Auto Farm (Bypass Tốc Độ)", false, function(v) AutoFarmLevel = v end)
createToggle(farmPage, "📜 Tự Nhận Nhiệm Vụ", true, function(v) AutoQuest = v end)
createToggle(farmPage, "🧲 Gom Quái Xuống Mặt Đất", true, function(v) BringMob = v end)

-- =========================================================
-- LOGIC KIỂM TRA NHIỆM VỤ (TỪ SCRIPT 10K)
-- =========================================================
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then World1 = true
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then World2 = true
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then World3 = true end

function CheckQuest()
    local MyLevel = LocalPlayer.Data.Level.Value
    if World1 then
        if MyLevel <= 9 then Mon="Bandit"; LevelQuest=1; NameQuest="BanditQuest1"; NameMon="Bandit"; CFrameQuest=CFrame.new(1059,15,1550); CFrameMon=CFrame.new(1045,27,1560)
        elseif MyLevel <= 14 then Mon="Monkey"; LevelQuest=1; NameQuest="JungleQuest"; NameMon="Monkey"; CFrameQuest=CFrame.new(-1598,35,153); CFrameMon=CFrame.new(-1448,67,11)
        elseif MyLevel <= 29 then Mon="Gorilla"; LevelQuest=2; NameQuest="JungleQuest"; NameMon="Gorilla"; CFrameQuest=CFrame.new(-1598,35,153); CFrameMon=CFrame.new(-1129,40,-525)
        elseif MyLevel <= 39 then Mon="Pirate"; LevelQuest=1; NameQuest="BuggyQuest1"; NameMon="Pirate"; CFrameQuest=CFrame.new(-1141,4,3831); CFrameMon=CFrame.new(-1103,13,3896)
        elseif MyLevel <= 59 then Mon="Brute"; LevelQuest=2; NameQuest="BuggyQuest1"; NameMon="Brute"; CFrameQuest=CFrame.new(-1141,4,3831); CFrameMon=CFrame.new(-1140,14,4322)
        elseif MyLevel <= 74 then Mon="Desert Bandit"; LevelQuest=1; NameQuest="DesertQuest"; NameMon="Desert Bandit"; CFrameQuest=CFrame.new(894,5,4392); CFrameMon=CFrame.new(924,6,4481)
        elseif MyLevel <= 89 then Mon="Desert Officer"; LevelQuest=2; NameQuest="DesertQuest"; NameMon="Desert Officer"; CFrameQuest=CFrame.new(894,5,4392); CFrameMon=CFrame.new(1608,8,4371)
        elseif MyLevel <= 99 then Mon="Snow Bandit"; LevelQuest=1; NameQuest="SnowQuest"; NameMon="Snow Bandit"; CFrameQuest=CFrame.new(1389,88,-1298); CFrameMon=CFrame.new(1354,87,-1393)
        elseif MyLevel <= 119 then Mon="Snowman"; LevelQuest=2; NameQuest="SnowQuest"; NameMon="Snowman"; CFrameQuest=CFrame.new(1389,88,-1298); CFrameMon=CFrame.new(1201,144,-1550)
        elseif MyLevel <= 149 then Mon="Chief Petty Officer"; LevelQuest=1; NameQuest="MarineQuest2"; NameMon="Chief Petty Officer"; CFrameQuest=CFrame.new(-5039,27,4324); CFrameMon=CFrame.new(-4881,22,4273)
        elseif MyLevel <= 174 then Mon="Sky Bandit"; LevelQuest=1; NameQuest="SkyQuest"; NameMon="Sky Bandit"; CFrameQuest=CFrame.new(-4839,716,-2619); CFrameMon=CFrame.new(-4953,295,-2899)
        elseif MyLevel <= 189 then Mon="Dark Master"; LevelQuest=2; NameQuest="SkyQuest"; NameMon="Dark Master"; CFrameQuest=CFrame.new(-4839,716,-2619); CFrameMon=CFrame.new(-5259,391,-2229)
        elseif MyLevel <= 209 then Mon="Prisoner"; LevelQuest=1; NameQuest="PrisonerQuest"; NameMon="Prisoner"; CFrameQuest=CFrame.new(5308,1,475); CFrameMon=CFrame.new(5098,0,474)
        else Mon="Peanut Scout"; LevelQuest=1; NameQuest="PeanutQuest"; NameMon="Peanut Scout"; CFrameQuest=CFrame.new(-2104,38,-10194); CFrameMon=CFrame.new(-2143,47,-10029) end
    elseif World2 then
        if MyLevel <= 724 then Mon="Raider"; LevelQuest=1; NameQuest="Area1Quest"; NameMon="Raider"; CFrameQuest=CFrame.new(-429,71,1836); CFrameMon=CFrame.new(-728,52,2345)
        elseif MyLevel <= 774 then Mon="Mercenary"; LevelQuest=2; NameQuest="Area1Quest"; NameMon="Mercenary"; CFrameQuest=CFrame.new(-429,71,1836); CFrameMon=CFrame.new(-1004,80,1424)
        else Mon="Swan Pirate"; LevelQuest=1; NameQuest="Area2Quest"; NameMon="Swan Pirate"; CFrameQuest=CFrame.new(638,71,918); CFrameMon=CFrame.new(1068,137,1322) end
    elseif World3 then
        if MyLevel <= 1524 then Mon="Pirate Millionaire"; LevelQuest=1; NameQuest="PiratePortQuest"; NameMon="Pirate Millionaire"; CFrameQuest=CFrame.new(-450,107,5950); CFrameMon=CFrame.new(-245,47,5584)
        else Mon="Dragon Crew Warrior"; LevelQuest=1; NameQuest="DragonCrewQuest"; NameMon="Dragon Crew Warrior"; CFrameQuest=CFrame.new(6750,127,-711); CFrameMon=CFrame.new(6709,52,-1139) end
    end
end

-- =========================================================
-- ĐỘNG CƠ DI CHUYỂN TWEEN MƯỢT VÀ BYPASS TELEPORT (TỪ SCRIPT 10K)
-- =========================================================
local currentTween = nil
function BTP(targetCFrame)
    pcall(function()
        if (targetCFrame.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1500 and LocalPlayer.Character.Humanoid.Health > 0 then
            repeat
                task.wait()
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
                task.wait(0.05)
                if LocalPlayer.Character:FindFirstChild("Head") then LocalPlayer.Character.Head:Destroy() end
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
            until (targetCFrame.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 1500 or LocalPlayer.Character.Humanoid.Health <= 0
        end
    end)
end

function topos(targetCFrame)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not hrp:FindFirstChild("BodyClip") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "BodyClip"
        bv.Parent = hrp
        bv.MaxForce = Vector3.new(100000, 100000, 100000)
        bv.Velocity = Vector3.new(0, 0, 0)
    end

    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end

    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    if dist > 1500 and BypassTP then
        BTP(targetCFrame)
    else
        if currentTween then currentTween:Cancel() end
        currentTween = TweenService:Create(hrp, TweenInfo.new(dist / 300, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        currentTween:Play()
    end
end

function StopTween(state)
    if not state then
        if currentTween then currentTween:Cancel() end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("BodyClip") then
            hrp.BodyClip:Destroy()
        end
    end
end

function EquipWeapon()
    pcall(function()
        if not LocalPlayer.Character:FindFirstChild("HasBuso") then CommF:InvokeServer("Buso") end
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack then return end
        
        local curr = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if curr and (string.find(curr.ToolTip, selectedWeaponType) or curr.Name == "Combat" or curr.Name == "Võ Tân Binh") then return end
        
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (string.find(tool.ToolTip, selectedWeaponType) or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
                break
            end
        end
    end)
end

-- =========================================================
-- VÒNG LẶP AUTO FARM CHÍNH
-- =========================================================
task.spawn(function()
    while task.wait() do
        if AutoFarmLevel then
            pcall(function()
                CheckQuest()
                infoLabel.Text = string.format("Đang Farm: %s [Cấp %d]", NameMon or "", LocalPlayer.Data.Level.Value)
                
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                if pGui and pGui.Main.Quest.Visible == false then
                    StartBring = false
                    if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 20 then
                        topos(CFrameQuest)
                    else
                        CommF:InvokeServer("StartQuest", NameQuest, LevelQuest)
                    end
                else
                    local questText = pGui.Main.Quest.Container.QuestTitle.Title.Text
                    if not string.find(questText, NameMon) then
                        StartBring = false
                        CommF:InvokeServer("AbandonQuest")
                    else
                        local foundMob = false
                        for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                            if mob.Name == Mon and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                                foundMob = true
                                repeat
                                    task.wait()
                                    EquipWeapon()
                                    
                                    PosMon = mob.HumanoidRootPart.CFrame
                                    -- CỰ LY 10 MÉT CHUẨN ĐỂ ĐÁNH CHẮC CHẮN TRÚNG MÀ KHÔNG BỊ PHÁT HIỆN
                                    topos(mob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)) 
                                    
                                    mob.HumanoidRootPart.CanCollide = false
                                    mob.Humanoid.WalkSpeed = 0
                                    mob.Head.CanCollide = false
                                    mob.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    
                                    StartBring = true
                                    MonFarm = mob.Name
                                    
                                    VirtualUser:CaptureController()
                                    VirtualUser:Button1Down(Vector2.new(1280, 672))
                                until not AutoFarmLevel or mob.Humanoid.Health <= 0 or not mob.Parent or pGui.Main.Quest.Visible == false
                            end
                        end
                        if not foundMob then
                            StartBring = false
                            topos(CFrameMon)
                        end
                    end
                end
            end)
        else
            StopTween(AutoFarmLevel)
        end
    end
end)

-- VÒNG LẶP HÚT QUÁI
task.spawn(function()
    while task.wait() do
        pcall(function()
            if BringMob and StartBring and PosMon then
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob.Name == MonFarm and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        if (mob.HumanoidRootPart.Position - PosMon.Position).Magnitude <= 300 then
                            mob.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            mob.HumanoidRootPart.CFrame = PosMon
                            mob.HumanoidRootPart.CanCollide = false
                            mob.Head.CanCollide = false
                            if mob.Humanoid:FindFirstChild("Animator") then
                                mob.Humanoid.Animator:Destroy()
                            end
                            mob.Humanoid:ChangeState(11)
                            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                end
            end
        end)
    end
end)

-- =========================================================
-- VÒNG LẶP FAST ATTACK CHUẨN
-- =========================================================
task.spawn(function()
    while task.wait(0.01) do
        if AutoFarmLevel then
            pcall(function()
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                
                local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
                local ac = CbFw.activeController
                if not ac then
                    local get_upv = debug.getupvalues or getupvalues
                    if get_upv then
                        for _, v in pairs(get_upv(CbFw)) do
                            if type(v) == "table" and v.activeController then ac = v.activeController break end
                        end
                    end
                end
                
                if ac and ac.equipped then
                    ac.hitboxLimiter = 0
                    ac.timeToNextAttack = 0
                    ac.timeToNextBlock = 0
                    ac.increment = 3
                    ac:attack()
                end
            end)
        end
    end
end)

RunService.Stepped:Connect(function()
    pcall(function()
        if AutoFarmLevel and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum and hum:FindFirstChild("Animator") then
                for _, anim in ipairs(hum.Animator:GetPlayingAnimationTracks()) do
                    local name = anim.Name:lower()
                    if name:match("attack") or name:match("slash") or name:match("punch") then anim:Stop() end
                end
            end
        end
    end)
end)
