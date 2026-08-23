-- [[ ZYROX VN - V35.0 (THE ULTIMATE HYBRID) ]] --
-- Lõi Farm: Redz Hub / Desplock (Network Bypass)
-- Giao Diện: Zyrox Premium UI

task.wait(0.1)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- =========================================================
-- KHỞI TẠO SERVICES & BIẾN
-- =========================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

-- CHỐNG VĂNG GAME (ANTI-AFK CRASH)
pcall(function()
    for i,v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end
end)
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- NHẬN DIỆN THẾ GIỚI (WORLD 1, 2, 3)
local World1, World2, World3 = false, false, false
local placeId = game.PlaceId
if placeId == 2753915549 or placeId == 85211729168715 then
    World1 = true
elseif placeId == 4442272183 or placeId == 79091703265657 then
    World2 = true
elseif placeId == 7449423635 or placeId == 100117331123089 then
    World3 = true
end

local _G = {
    AutoFarm = false,
    AutoQuest = true,
    SelectWeapon = "Melee",
    BringMob = true,
    FastAttack = true,
    AutoStats = false,
    StatsPoints = 1,
    StatsSelect = {Melee = false, Defense = false, Sword = false, Gun = false, BloxFruit = false},
    ESPPlayer = false,
    ESPFruit = false,
    ESPChest = false
}

-- =========================================================
-- HỆ THỐNG GIAO DIỆN (UI TỐI ƯU HÓA)
-- =========================================================
local UI_NAME = "ZyroxTrueHub_V35"
pcall(function() if game:GetService("CoreGui"):FindFirstChild(UI_NAME) then game:GetService("CoreGui")[UI_NAME]:Destroy() end end)
pcall(function() if LocalPlayer.PlayerGui:FindFirstChild(UI_NAME) then LocalPlayer.PlayerGui[UI_NAME]:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME; ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

-- Menu nổi khi đóng
local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 48, 0, 48); FloatingButton.Position = UDim2.new(0.1, 0, 0.5, 0); FloatingButton.BackgroundColor3 = Color3.fromRGB(13, 16, 22); FloatingButton.Visible = false; FloatingButton.Text = "Z"; FloatingButton.TextColor3 = Color3.fromRGB(0, 210, 255); FloatingButton.Font = Enum.Font.GothamBlack; FloatingButton.TextSize = 24; FloatingButton.ZIndex = 999
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", FloatingButton).Color = Color3.fromRGB(0, 210, 255); Instance.new("UIStroke", FloatingButton).Thickness = 1.5

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 350); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19); MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 210, 255); Instance.new("UIStroke", MainFrame).Thickness = 1.5

-- Kéo thả UI
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end end)
FloatingButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = FloatingButton.Position end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if MainFrame.Visible then MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        else FloatingButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end
    end
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38); TopBar.BackgroundColor3 = Color3.fromRGB(14, 18, 27); TopBar.BorderSizePixel = 0
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 300, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1; Title.RichText = true; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "ZYROX VN <font color='#00d2ff'>• V35 (REDZ CORE HYBRID)</font>"

local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 24, 0, 24); CloseBtn.Position = UDim2.new(1, -28, 0.5, -12); CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90); CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 10; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
local MinBtn = Instance.new("TextButton", TopBar); MinBtn.Size = UDim2.new(0, 24, 0, 24); MinBtn.Position = UDim2.new(1, -56, 0.5, -12); MinBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 38); MinBtn.Text = "−"; MinBtn.TextColor3 = Color3.fromRGB(160, 170, 190); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 13; Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingButton.Visible = true end)
FloatingButton.MouseButton1Click:Connect(function() MainFrame.Visible = true; FloatingButton.Visible = false end)
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
    local frame = Instance.new("Frame", page); frame.Size = UDim2.new(0.94, 0, 0, 34); frame.BackgroundColor3 = Color3.fromRGB(16, 20, 29); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, -50, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(220, 225, 235); label.Font = Enum.Font.Gotham; label.TextSize = 11; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = labelText
    local switch = Instance.new("TextButton", frame); switch.Size = UDim2.new(0, 32, 0, 16); switch.Position = UDim2.new(1, -40, 0.5, -8); switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54); switch.Text = ""; Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch); circle.Size = UDim2.new(0, 12, 0, 12); circle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    switch.MouseButton1Click:Connect(function()
        state = not state; switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), "Out", "Quad", 0.15, true)
        if callback then callback(state) end
    end)
end

local farmPage = createTab("Farm", "🌾", "Cày Cấp")
local statsPage = createTab("Stats", "📈", "Nâng Điểm")
local espPage = createTab("ESP", "👁️", "Nhìn Xuyên Tường")

tabButtons["Farm"].Button.BackgroundColor3 = Color3.fromRGB(38, 105, 190); tabButtons["Farm"].Button.TextColor3 = Color3.fromRGB(255, 255, 255); tabButtons["Farm"].Pill.Visible = true; tabPages["Farm"].Visible = true

local infoLabel = Instance.new("TextLabel", farmPage); infoLabel.Size = UDim2.new(0.94, 0, 0, 25); infoLabel.BackgroundTransparency = 1; infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150); infoLabel.Font = Enum.Font.GothamBold; infoLabel.TextSize = 12

-- TẠO VŨ KHÍ
local weaponSegment = Instance.new("Frame", farmPage); weaponSegment.Size = UDim2.new(0.94, 0, 0, 28); weaponSegment.BackgroundColor3 = Color3.fromRGB(15, 18, 25); Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
local wsLayout = Instance.new("UIListLayout", weaponSegment); wsLayout.FillDirection = Enum.FillDirection.Horizontal; wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; wsLayout.Padding = UDim.new(0, 3)

local weaponList = {{name = "Melee", label = "🥊 Melee"}, {name = "Sword", label = "⚔️ Sword"}, {name = "Blox Fruit", label = "🍎 Fruit"}}
for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size = UDim2.new(0.3, 0, 0.78, 0); b.BackgroundColor3 = _G.SelectWeapon == wData.name and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48); b.TextColor3 = _G.SelectWeapon == wData.name and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170); b.Font = Enum.Font.GothamMedium; b.TextSize = 10; b.Text = wData.label; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function()
        _G.SelectWeapon = wData.name
        for _, btn in pairs(weaponSegment:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = btn.Text == wData.label and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48); btn.TextColor3 = btn.Text == wData.label and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170) end end
    end)
end

createToggle(farmPage, "⚡ Auto Farm (Lõi REDZ VIP)", false, function(v) _G.AutoFarm = v end)
createToggle(farmPage, "📜 Tự Nhận Nhiệm Vụ", true, function(v) _G.AutoQuest = v end)

-- TẠO STATS
createToggle(statsPage, "📈 Tự Động Nâng Điểm", false, function(v) _G.AutoStats = v end)
createToggle(statsPage, "🥊 Nâng Melee", false, function(v) _G.StatsSelect.Melee = v end)
createToggle(statsPage, "🛡️ Nâng Defense", false, function(v) _G.StatsSelect.Defense = v end)
createToggle(statsPage, "⚔️ Nâng Sword", false, function(v) _G.StatsSelect.Sword = v end)
createToggle(statsPage, "🍎 Nâng Blox Fruit", false, function(v) _G.StatsSelect.BloxFruit = v end)

-- TẠO ESP
createToggle(espPage, "👁️ Hiện Người Chơi (ESP Player)", false, function(v) _G.ESPPlayer = v end)
createToggle(espPage, "🍎 Hiện Trái Ác Quỷ (ESP Fruit)", false, function(v) _G.ESPFruit = v end)
createToggle(espPage, "📦 Hiện Rương (ESP Chest)", false, function(v) _G.ESPChest = v end)

-- =========================================================
-- ĐỔI VŨ KHÍ TỰ ĐỘNG
-- =========================================================
local function EquipWeapon()
    pcall(function()
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if char and backpack then
            local currentTool = char:FindFirstChildOfClass("Tool")
            if currentTool and (string.find(currentTool.ToolTip, _G.SelectWeapon) or currentTool.Name == "Combat" or currentTool.Name == "Võ Tân Binh") then return end
            
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and (string.find(tool.ToolTip, _G.SelectWeapon) or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then
                    char.Humanoid:EquipTool(tool)
                    break
                end
            end
        end
    end)
end

-- =========================================================
-- HỆ THỐNG BAY TWEEN MƯỢT (CHỐNG KẸT / RƠI)
-- =========================================================
local function topos(targetCFrame)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Bật NoClip
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    
    -- Chống rơi
    local bv = hrp:FindFirstChild("Zyrox_BV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "Zyrox_BV"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp
    end
    
    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    if dist < 200 then
        hrp.CFrame = targetCFrame
    else
        local tweenInfo = TweenInfo.new(dist / 300, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
    end
end

local function StopTween(isFarming)
    if not isFarming then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("Zyrox_BV") then
            hrp.Zyrox_BV:Destroy()
        end
    end
end

-- =========================================================
-- LÕI FAST ATTACK: NETWORK BYPASS (GỬI THẲNG LÊN SERVER)
-- =========================================================
local u4, u5 = nil, nil
task.spawn(function()
    local Net = require(game.ReplicatedStorage.Modules.Net)
    for _, v in pairs(game.ReplicatedStorage.Remotes:GetChildren()) do
        if v:IsA("RemoteEvent") and v:GetAttribute("Id") then
            u5 = v:GetAttribute("Id")
            u4 = v
        end
    end
end)

task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoFarm and _G.FastAttack then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local targets = {}
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                    local mobHum = mob:FindFirstChild("Humanoid")
                    if mobHRP and mobHum and mobHum.Health > 0 and (mobHRP.Position - hrp.Position).Magnitude <= 60 then
                        for _, part in ipairs(mob:GetChildren()) do
                            if part:IsA("BasePart") then
                                table.insert(targets, {mob, part})
                            end
                        end
                    end
                end

                local tool = char:FindFirstChildOfClass("Tool")
                if #targets > 0 and tool and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then
                    -- GỬI LỆNH REGISTER HIT TRỰC TIẾP LÊN SERVER
                    require(game.ReplicatedStorage.Modules.Net):RemoteEvent("RegisterHit", true)
                    game.ReplicatedStorage.Modules.Net["RE/RegisterAttack"]:FireServer()
                    
                    local head = targets[1][1]:FindFirstChild("Head")
                    if head and u4 and u5 then
                        game.ReplicatedStorage.Modules.Net["RE/RegisterHit"]:FireServer(head, targets, {}, tostring(LocalPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
                    end
                end
            end)
        end
    end
end)

-- XÓA HOẠT ẢNH TAY ĐỂ TĂNG TỐC & TRÁNH CRASH
RunService.Stepped:Connect(function()
    pcall(function()
        if _G.AutoFarm and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                local animator = hum:FindFirstChild("Animator")
                if animator then
                    for _, anim in ipairs(animator:GetPlayingAnimationTracks()) do
                        local name = anim.Name:lower()
                        if name:match("attack") or name:match("punch") or name:match("slash") or name:match("swing") or name:match("m1") then anim:Stop() end
                    end
                end
            end
        end
    end)
end)

-- =========================================================
-- LOGIC NHIỆM VỤ ĐỘNG (LẤY TỪ REDZ HUB)
-- =========================================================
local function GetQuestData()
    local lvl = LocalPlayer.Data.Level.Value
    if World1 then
        if lvl <= 9 then return "BanditQuest1", 1, "Bandit", CFrame.new(1059, 15, 1550), CFrame.new(1045, 27, 1560)
        elseif lvl <= 14 then return "JungleQuest", 1, "Monkey", CFrame.new(-1598, 36, 153), CFrame.new(-1448, 67, 11)
        elseif lvl <= 29 then return "JungleQuest", 2, "Gorilla", CFrame.new(-1598, 36, 153), CFrame.new(-1129, 40, -525)
        elseif lvl <= 39 then return "BuggyQuest1", 1, "Pirate", CFrame.new(-1141, 4, 3831), CFrame.new(-1103, 13, 3896)
        elseif lvl <= 59 then return "BuggyQuest1", 2, "Brute", CFrame.new(-1141, 4, 3831), CFrame.new(-1140, 14, 4322)
        elseif lvl <= 74 then return "DesertQuest", 1, "Desert Bandit", CFrame.new(894, 5, 4392), CFrame.new(924, 6, 4481)
        elseif lvl <= 89 then return "DesertQuest", 2, "Desert Officer", CFrame.new(894, 5, 4392), CFrame.new(1608, 8, 4371)
        elseif lvl <= 99 then return "SnowQuest", 1, "Snow Bandit", CFrame.new(1389, 88, -1298), CFrame.new(1354, 87, -1393)
        elseif lvl <= 119 then return "SnowQuest", 2, "Snowman", CFrame.new(1389, 88, -1298), CFrame.new(1201, 144, -1550)
        elseif lvl <= 149 then return "MarineQuest2", 1, "Chief Petty Officer", CFrame.new(-5039, 27, 4324), CFrame.new(-4881, 22, 4273)
        elseif lvl <= 174 then return "SkyQuest", 1, "Sky Bandit", CFrame.new(-4839, 716, -2619), CFrame.new(-4953, 295, -2899)
        elseif lvl <= 189 then return "SkyQuest", 2, "Dark Master", CFrame.new(-4839, 716, -2619), CFrame.new(-5259, 391, -2229)
        elseif lvl <= 209 then return "PrisonerQuest", 1, "Prisoner", CFrame.new(5308, 1, 475), CFrame.new(5098, 0, 474)
        else return "PeanutQuest", 1, "Peanut Scout", CFrame.new(-2104, 38, -10194), CFrame.new(-2143, 47, -10029) end
    elseif World2 then
        -- Placeholder nhanh Sea 2
        if lvl <= 724 then return "Area1Quest", 1, "Raider", CFrame.new(-429, 71, 1836), CFrame.new(-728, 52, 2345)
        else return "Area1Quest", 2, "Mercenary", CFrame.new(-429, 71, 1836), CFrame.new(-1004, 80, 1424) end
    elseif World3 then
        if lvl <= 1524 then return "PiratePortQuest", 1, "Pirate Millionaire", CFrame.new(-450, 107, 5950), CFrame.new(-245, 47, 5584)
        else return "DragonCrewQuest", 1, "Dragon Crew Warrior", CFrame.new(6750, 127, -711), CFrame.new(6709, 52, -1139) end
    end
end

-- =========================================================
-- VÒNG LẶP AUTO FARM CHÍNH
-- =========================================================
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local qName, qLevel, mobName, questPos, mobSpawn = GetQuestData()
                infoLabel.Text = string.format("Đang Farm: %s [Cấp %d]", mobName, LocalPlayer.Data.Level.Value)

                -- 1. Bật Haki & Đổi Vũ Khí
                if not char:FindFirstChild("HasBuso") and CommF then CommF:InvokeServer("Buso") end
                EquipWeapon()

                -- 2. Nhận Nhiệm Vụ
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                local hasQuest = pGui and pGui:FindFirstChild("Main") and pGui.Main:FindFirstChild("Quest") and pGui.Main.Quest.Visible
                if _G.AutoQuest and not hasQuest and CommF then
                    local distToQuest = (hrp.Position - questPos.Position).Magnitude
                    if distToQuest > 20 then
                        topos(questPos)
                    else
                        CommF:InvokeServer("StartQuest", qName, qLevel)
                        task.wait(0.5)
                    end
                    return -- Nhận xong chờ loop sau
                end

                -- 3. Đi Farm Quái
                local targetMob = nil
                local distMob = math.huge
                for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                    if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        local d = (hrp.Position - mob.HumanoidRootPart.Position).Magnitude
                        if d < distMob then distMob = d; targetMob = mob end
                    end
                end

                if targetMob then
                    local mobHRP = targetMob.HumanoidRootPart
                    -- ĐỨNG LƠ LỬNG TRÊN ĐẦU QUÁI 30 MÉT ĐỂ BẤT TỬ
                    topos(mobHRP.CFrame * CFrame.new(0, 30, 0))
                    
                    if _G.BringMob and distMob <= 300 then
                        -- ÉP HITBOX 60 & KÉO QUÁI LÊN CAO CÁCH MŨI KIẾM 5 MÉT (ĐỂ ĐÁNH TRÚNG)
                        mobHRP.Size = Vector3.new(60, 60, 60)
                        mobHRP.Transparency = 1
                        mobHRP.CanCollide = false
                        mobHRP.CFrame = hrp.CFrame * CFrame.new(0, -10, 0)
                        
                        targetMob.Humanoid.WalkSpeed = 0
                        targetMob.Humanoid.JumpPower = 0
                        targetMob.Humanoid.Sit = true
                        
                        -- XÓA NÃO QUÁI ĐỂ NÓ KHÔNG ĐÁNH LẠI
                        if targetMob.Humanoid:FindFirstChild("Animator") then targetMob.Humanoid.Animator:Destroy() end
                        targetMob.Humanoid:ChangeState(11) 
                        
                        -- Nếu dùng Network Hit thì chỉ cần đứng đây là chết
                    end
                else
                    -- LƯỢN VỀ BÃI QUÁI NẾU KHÔNG CÓ QUÁI
                    topos(mobSpawn)
                end
            end)
        else
            StopTween(_G.AutoFarm)
        end
    end
end)

-- =========================================================
-- AUTO STATS
-- =========================================================
task.spawn(function()
    while task.wait(0.4) do
        if _G.AutoStats then
            pcall(function()
                local statsFolder = LocalPlayer:FindFirstChild("Data")
                if not statsFolder then return end
                local points = statsFolder:FindFirstChild("Points")
                if not points or points.Value <= 0 then return end
                
                local EnabledStats = {}
                for stat, enabled in pairs(_G.StatsSelect) do
                    if enabled then table.insert(EnabledStats, stat) end
                end
                
                if #EnabledStats > 0 then
                    local amountEach = math.floor(_G.StatsPoints / #EnabledStats)
                    if amountEach < 1 then amountEach = 1 end
                    for _, stat in ipairs(EnabledStats) do
                        if CommF then CommF:InvokeServer("AddPoint", stat, amountEach, false) end
                    end
                end
            end)
        end
    end
end)

-- =========================================================
-- ESP THÔNG MINH
-- =========================================================
task.spawn(function()
    while task.wait(0.5) do
        -- ESP Player
        if _G.ESPPlayer then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local head = p.Character.Head
                    if not head:FindFirstChild("PlayerESP") then
                        local gui = Instance.new("BillboardGui", head); gui.Name = "PlayerESP"; gui.Size = UDim2.new(0, 200, 0, 40); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 3, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextScaled = true; txt.TextColor3 = Color3.fromRGB(255,0,0); txt.Font = Enum.Font.GothamBold
                    end
                    head.PlayerESP.TextLabel.Text = p.Name
                end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("PlayerESP") then p.Character.Head.PlayerESP:Destroy() end
            end
        end

        -- ESP Fruit
        if _G.ESPFruit then
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                    local handle = v.Handle
                    if not handle:FindFirstChild("FruitESP") then
                        local gui = Instance.new("BillboardGui", handle); gui.Name = "FruitESP"; gui.Size = UDim2.new(0, 200, 0, 40); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 2, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextScaled = true; txt.TextColor3 = Color3.fromRGB(0,255,0); txt.Font = Enum.Font.GothamBold
                    end
                    handle.FruitESP.TextLabel.Text = v.Name
                end
            end
        else
            for _, v in pairs(Workspace:GetDescendants()) do if v.Name == "FruitESP" then v:Destroy() end end
        end
    end
end)
