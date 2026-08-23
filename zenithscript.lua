-- [[ ZYROX VN - V44.0 (THE GOD MODE EXECUTOR) ]] --
-- Bất Tử: Player Y+40, Mob Y+33. 
-- Uncapped Fast Attack. ESP Clean (Size 12).

task.wait(0.1)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

-- CHỐNG VĂNG GAME
pcall(function() for i,v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end end)
LocalPlayer.Idled:Connect(function() pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end)

-- BIẾN TOÀN CỤC
_G.AutoFarm = false
_G.AutoQuest = true
_G.BringMob = true
_G.FastAttack = true
_G.SelectWeapon = "Melee"

_G.ESPPlayer = false
_G.ESPFruit = false
_G.ESPChest = false

local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

-- =========================================================
-- KHỞI TẠO GIAO DIỆN ZYROX CUSTOM
-- =========================================================
local UI_NAME = "Zyrox_V44_GodMode"
local function GetSafeParent()
    local s, p = pcall(function() return gethui() end)
    if s and p then return p end
    local s2, p2 = pcall(function() return game:GetService("CoreGui") end)
    if s2 and p2 then return p2 end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local targetParent = GetSafeParent()
pcall(function() if targetParent:FindFirstChild(UI_NAME) then targetParent[UI_NAME]:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME; ScreenGui.ResetOnSpawn = false; ScreenGui.Parent = targetParent

local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 48, 0, 48); FloatingButton.Position = UDim2.new(0.1, 0, 0.5, 0); FloatingButton.BackgroundColor3 = Color3.fromRGB(13, 16, 22); FloatingButton.Visible = false; FloatingButton.Text = "Z"; FloatingButton.TextColor3 = Color3.fromRGB(0, 210, 255); FloatingButton.Font = Enum.Font.GothamBlack; FloatingButton.TextSize = 24; FloatingButton.ZIndex = 999
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", FloatingButton).Color = Color3.fromRGB(0, 210, 255); Instance.new("UIStroke", FloatingButton).Thickness = 1.5

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 350); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19); MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 210, 255); Instance.new("UIStroke", MainFrame).Thickness = 1.5

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
Title.Text = "ZYROX VN <font color='#00d2ff'>• V44.0 (GOD MODE EXECUTOR)</font>"

local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 24, 0, 24); CloseBtn.Position = UDim2.new(1, -28, 0.5, -12); CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90); CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 10; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
local MinBtn = Instance.new("TextButton", TopBar); MinBtn.Size = UDim2.new(0, 24, 0, 24); MinBtn.Position = UDim2.new(1, -56, 0.5, -12); MinBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 38); MinBtn.Text = "−"; MinBtn.TextColor3 = Color3.fromRGB(160, 170, 190); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 13; Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingButton.Visible = true end)
FloatingButton.MouseButton1Click:Connect(function() MainFrame.Visible = true; FloatingButton.Visible = false end)
local isMin = false
MinBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    MainFrame:TweenSize(isMin and UDim2.new(0, 560, 0, 38) or UDim2.new(0, 560, 0, 350), "Out", "Quart", 0.25, true)
end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Name = "Sidebar"; Sidebar.Size = UDim2.new(0, 155, 1, -38); Sidebar.Position = UDim2.new(0, 0, 0, 38); Sidebar.BackgroundColor3 = Color3.fromRGB(12, 15, 22); Sidebar.BorderSizePixel = 0

local TabScroller = Instance.new("ScrollingFrame", Sidebar)
TabScroller.Name = "TabScroller"; TabScroller.Size = UDim2.new(1, -8, 1, -12); TabScroller.Position = UDim2.new(0, 4, 0, 6); TabScroller.BackgroundTransparency = 1; TabScroller.BorderSizePixel = 0; TabScroller.ScrollBarThickness = 3; TabScroller.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); TabScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIPadding", TabScroller).PaddingTop = UDim.new(0, 3)
local TabListLayout = Instance.new("UIListLayout", TabScroller)
TabListLayout.Padding = UDim.new(0, 4); TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Name = "ContentContainer"; ContentContainer.Size = UDim2.new(1, -155, 1, -38); ContentContainer.Position = UDim2.new(0, 155, 0, 38); ContentContainer.BackgroundTransparency = 1

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
    local frame = Instance.new("Frame", page); frame.Size = UDim2.new(0.94, 0, 0, 34); frame.BackgroundColor3 = Color3.fromRGB(16, 20, 29); frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    local stroke = Instance.new("UIStroke", frame); stroke.Color = Color3.fromRGB(31, 39, 54); stroke.Thickness = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -50, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(220, 225, 235); label.Font = Enum.Font.Gotham; label.TextSize = 11; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = labelText
    
    local switch = Instance.new("TextButton", frame)
    switch.Size = UDim2.new(0, 32, 0, 16); switch.Position = UDim2.new(1, -40, 0.5, -8); switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54); switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 12, 0, 12); circle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    switch.MouseButton1Click:Connect(function()
        state = not state; switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), "Out", "Quad", 0.15, true)
        if callback then callback(state) end
    end)
end

-- TẠO CÁC TAB
local pFarm = createTab("Farm", "🌾", "Cày Cấp (Farm)")
local pFruit = createTab("Fruit", "🍎", "Trái Ác Quỷ")
local pESP = createTab("ESP", "👁️", "Nhìn Xuyên Tường")
local pMisc = createTab("Misc", "⚙️", "Khác (Server)")

tabButtons["Farm"].Button.BackgroundColor3 = Color3.fromRGB(38, 105, 190); tabButtons["Farm"].Button.TextColor3 = Color3.fromRGB(255, 255, 255); tabButtons["Farm"].Pill.Visible = true; tabPages["Farm"].Visible = true

local infoLabel = Instance.new("TextLabel", pFarm)
infoLabel.Size = UDim2.new(0.94, 0, 0, 25); infoLabel.BackgroundTransparency = 1; infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150); infoLabel.Font = Enum.Font.GothamBold; infoLabel.TextSize = 12; infoLabel.Text = "Trạng thái: Chờ lệnh..."

local weaponSegment = Instance.new("Frame", pFarm)
weaponSegment.Size = UDim2.new(0.94, 0, 0, 28); weaponSegment.BackgroundColor3 = Color3.fromRGB(15, 18, 25); Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
local wsLayout = Instance.new("UIListLayout", weaponSegment); wsLayout.FillDirection = Enum.FillDirection.Horizontal; wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; wsLayout.Padding = UDim.new(0, 3)

for _, wName in ipairs({"Melee", "Sword", "Blox Fruit"}) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size = UDim2.new(0.3, 0, 0.78, 0); b.BackgroundColor3 = _G.SelectWeapon == wName and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48); b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.GothamMedium; b.TextSize = 10; b.Text = wName; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function() _G.SelectWeapon = wName; for _, btn in pairs(weaponSegment:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = btn.Text == wName and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48) end end end)
end

-- TÍNH NĂNG
createToggle(pFarm, "⚡ Kích Hoạt Auto Farm (Bất Tử)", false, function(v) _G.AutoFarm = v end)
createToggle(pFarm, "📜 Tự Nhận Nhiệm Vụ", true, function(v) _G.AutoQuest = v end)
createToggle(pFarm, "🧲 Kéo Quái (God Mode)", true, function(v) _G.BringMob = v end)
createToggle(pFarm, "⚔️ Fast Attack (MAX SPEED)", true, function(v) _G.FastAttack = v end)

createToggle(pESP, "👁️ ESP Player (Clean Size 12)", false, function(v) _G.ESPPlayer = v end)
createToggle(pESP, "🍎 ESP Fruit", false, function(v) _G.ESPFruit = v end)
createToggle(pESP, "📦 ESP Chest", false, function(v) _G.ESPChest = v end)

createToggle(pMisc, "🚀 Giảm Giật Cấu Hình", false, function(v)
    Lighting.GlobalShadows = not v
    if v then for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("BasePart") then o.Material = Enum.Material.SmoothPlastic end end end
end)

-- =========================================================
-- LOGIC BẢN ĐỒ & DI CHUYỂN
-- =========================================================
local currentTween = nil

local function topos(target)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not hrp:FindFirstChild("ZyroxBV") then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "ZyroxBV"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bv.Velocity = Vector3.zero
    end
    for _,v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    if LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.Sit = false end
    
    local dist = (hrp.Position - target.Position).Magnitude
    if dist > 1500 then
        -- Bypass TP an toàn
        hrp.CFrame = target
        task.wait(0.1)
        if LocalPlayer.Character:FindFirstChild("Head") then LocalPlayer.Character.Head:Destroy() end
        hrp.CFrame = target
    else
        if currentTween then currentTween:Cancel() end
        currentTween = TweenService:Create(hrp, TweenInfo.new(dist / 300, Enum.EasingStyle.Linear), {CFrame = target})
        currentTween:Play()
    end
end

local function EquipWeapon()
    pcall(function()
        if not LocalPlayer.Character:FindFirstChild("HasBuso") and CommF then CommF:InvokeServer("Buso") end
        local curr = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if curr and (string.find(curr.ToolTip, _G.SelectWeapon) or curr.Name == "Combat" or curr.Name == "Võ Tân Binh") then return end
        
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack then return end
        for _, t in ipairs(backpack:GetChildren()) do
            if t:IsA("Tool") and (string.find(t.ToolTip, _G.SelectWeapon) or t.Name == "Combat" or t.Name == "Võ Tân Binh") then
                LocalPlayer.Character.Humanoid:EquipTool(t)
                break
            end
        end
    end)
end

local function GetQuestData()
    local lvl = LocalPlayer.Data.Level.Value
    if World1 then
        if lvl <= 9 then return "BanditQuest1", 1, "Bandit", CFrame.new(1060, 16, 1547)
        elseif lvl <= 14 then return "JungleQuest", 1, "Monkey", CFrame.new(-1602, 37, 152)
        elseif lvl <= 29 then return "JungleQuest", 2, "Gorilla", CFrame.new(-1598, 37, 153)
        elseif lvl <= 39 then return "BuggyQuest1", 1, "Pirate", CFrame.new(-1140, 4, 3828)
        elseif lvl <= 59 then return "BuggyQuest1", 2, "Brute", CFrame.new(-1140, 4, 3828)
        elseif lvl <= 74 then return "DesertQuest", 1, "Desert Bandit", CFrame.new(896, 6, 4390)
        elseif lvl <= 89 then return "DesertQuest", 2, "Desert Officer", CFrame.new(896, 6, 4390)
        elseif lvl <= 99 then return "SnowQuest", 1, "Snow Bandit", CFrame.new(1388, 87, -1297)
        elseif lvl <= 119 then return "SnowQuest", 2, "Snowman", CFrame.new(1388, 87, -1297)
        elseif lvl <= 149 then return "MarineQuest2", 1, "Chief Petty Officer", CFrame.new(-5036, 28, 4325)
        else return "BanditQuest1", 1, "Bandit", CFrame.new(1060, 16, 1547) end
    elseif World2 then
        if lvl <= 724 then return "Area1Quest", 1, "Raider", CFrame.new(-429, 71, 1836)
        elseif lvl <= 774 then return "Area1Quest", 2, "Mercenary", CFrame.new(-429, 71, 1836)
        else return "Area2Quest", 1, "Swan Pirate", CFrame.new(638, 71, 918) end
    else
        if lvl <= 1524 then return "PiratePortQuest", 1, "Pirate Millionaire", CFrame.new(-450, 107, 5950)
        else return "DragonCrewQuest", 1, "Dragon Crew Warrior", CFrame.new(6750, 127, -711) end
    end
end

-- =========================================================
-- VÒNG LẶP FARM CHÍNH: GOD MODE (BẤT TỬ ĐỘT PHÁ)
-- =========================================================
local lockedFarmPosition = nil

task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()
                local qName, qLevel, mobName, questPos = GetQuestData()
                infoLabel.Text = string.format("Đang Tàn Sát: %s [Cấp %d]", mobName, LocalPlayer.Data.Level.Value)
                
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                local hasQuest = pGui and pGui.Main:FindFirstChild("Quest") and pGui.Main.Quest.Visible
                
                -- Nhận nhiệm vụ
                if _G.AutoQuest and not hasQuest then
                    if (LocalPlayer.Character.HumanoidRootPart.Position - questPos.Position).Magnitude > 20 then
                        topos(questPos)
                    else
                        if CommF then CommF:InvokeServer("StartQuest", qName, qLevel) end
                    end
                    return
                end
                
                if hasQuest and not string.find(pGui.Main.Quest.Container.QuestTitle.Title.Text, mobName) then
                    if CommF then CommF:InvokeServer("AbandonQuest") end
                    return
                end

                -- Tìm Quái
                local targetMob = nil
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        targetMob = mob; break
                    end
                end

                if targetMob then
                    EquipWeapon()
                    if not lockedFarmPosition then lockedFarmPosition = targetMob.HumanoidRootPart.CFrame end
                    
                    -- GOD MODE: PLAYER BAY CAO TÍT 40 MÉT TRÊN TRỜI
                    local safePos = lockedFarmPosition * CFrame.new(0, 40, 0)
                    topos(safePos)

                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    if (hrp.Position - safePos.Position).Magnitude < 10 then
                        -- Luôn nhìn thẳng xuống dưới
                        hrp.CFrame = CFrame.lookAt(hrp.Position, lockedFarmPosition.Position)
                        
                        -- GOM QUÁI LÊN CÁCH PLAYER ĐÚNG 7 MÉT (VỪA KHÍT TẦM CHÉM, VÀ MOB BỊ TÊ LIỆT)
                        if _G.BringMob then
                            for _, m in pairs(Workspace.Enemies:GetChildren()) do
                                if m.Name == mobName and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then
                                    local d = (m.HumanoidRootPart.Position - lockedFarmPosition.Position).Magnitude
                                    if d < 350 then
                                        -- Đưa quái lên sát player
                                        m.HumanoidRootPart.CFrame = safePos * CFrame.new(0, -7, 0)
                                        m.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        m.HumanoidRootPart.CanCollide = false
                                        if m:FindFirstChild("Head") then m.Head.CanCollide = false end
                                        
                                        -- Xóa Não Quái
                                        m.Humanoid.WalkSpeed = 0
                                        m.Humanoid.JumpPower = 0
                                        m.Humanoid.Sit = true
                                        if m.Humanoid:FindFirstChild("Animator") then m.Humanoid.Animator:Destroy() end
                                        m.Humanoid:ChangeState(11)
                                    end
                                end
                            end
                            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                else
                    lockedFarmPosition = nil
                    topos(questPos)
                end
            end)
        else
            lockedFarmPosition = nil
            if currentTween then currentTween:Cancel(); currentTween = nil end
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("ZyroxBV") then hrp.ZyroxBV:Destroy() end
        end
    end
end)

-- =========================================================
-- LÕI FAST ATTACK: MAX SPEED (CHÉM KỊCH TRẦN)
-- =========================================================
task.spawn(function()
    local function GetAc()
        local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
        if CbFw.activeController then return CbFw.activeController end
        for _, v in pairs(debug.getupvalues(CbFw) or getupvalues(CbFw)) do
            if type(v) == "table" and v.activeController then return v.activeController end
        end
        return nil
    end

    while task.wait() do
        if _G.AutoFarm and _G.FastAttack then
            pcall(function()
                -- Spam Click
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(1280, 672))
                
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.Name == "Combat") then
                    tool:Activate()
                end

                -- Hook Xóa Delay
                local ac = GetAc()
                if ac and ac.equipped then
                    ac.hitboxLimiter = math.huge
                    ac.timeToNextAttack = 0
                    ac.timeToNextBlock = 0
                    ac.increment = 3 -- Bơm stun
                    ac.attacking = false
                    ac.blocking = false
                    ac:attack()
                end
            end)
        end
    end
end)

-- Xóa hoạt ảnh vung tay để tránh giật lag màn hình
RunService.Stepped:Connect(function()
    pcall(function()
        if _G.AutoFarm and LocalPlayer.Character then
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

-- =========================================================
-- ESP TỐI ƯU HÓA: CLEAN VISUAL (SIZE 12)
-- =========================================================
task.spawn(function()
    while task.wait(1) do
        -- ESP PLAYER
        if _G.ESPPlayer then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") then
                    local head = p.Character.Head
                    if not head:FindFirstChild("Z_ESP") then
                        local gui = Instance.new("BillboardGui", head); gui.Name = "Z_ESP"; gui.Size = UDim2.new(0, 200, 0, 40); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 3, 0)
                        local txt = Instance.new("TextLabel", gui)
                        txt.Size = UDim2.new(1,0,1,0)
                        txt.BackgroundTransparency = 1
                        txt.TextScaled = false
                        txt.TextSize = 12
                        txt.TextColor3 = Color3.fromRGB(0, 255, 255)
                        txt.Font = Enum.Font.GothamBold
                        txt.TextStrokeTransparency = 0
                    end
                    local dist = math.floor((head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    head.Z_ESP.TextLabel.Text = p.Name .. " [" .. dist .. "m]\nHP: " .. math.floor(p.Character.Humanoid.Health)
                end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("Z_ESP") then p.Character.Head.Z_ESP:Destroy() end
            end
        end

        -- ESP FRUIT
        if _G.ESPFruit then
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                    local handle = v.Handle
                    if not handle:FindFirstChild("Z_ESP") then
                        local gui = Instance.new("BillboardGui", handle); gui.Name = "Z_ESP"; gui.Size = UDim2.new(0, 200, 0, 40); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 2, 0)
                        local txt = Instance.new("TextLabel", gui)
                        txt.Size = UDim2.new(1,0,1,0)
                        txt.BackgroundTransparency = 1
                        txt.TextScaled = false
                        txt.TextSize = 12
                        txt.TextColor3 = Color3.fromRGB(255, 0, 0)
                        txt.Font = Enum.Font.GothamBold
                        txt.TextStrokeTransparency = 0
                    end
                    local dist = math.floor((handle.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    handle.Z_ESP.TextLabel.Text = v.Name .. " [" .. dist .. "m]"
                end
            end
        else
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") and v.Handle:FindFirstChild("Z_ESP") then
                    v.Handle.Z_ESP:Destroy()
                end
            end
        end
    end
end)
