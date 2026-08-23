-- [[ ZYROX VN - V43.0 (THE MASTERPIECE) ]] --
-- Động cơ bay Heartbeat mượt mà (Không Reset). 
-- Đầy đủ chức năng các Tab. Hitbox 60 + Gom quái đất.

task.wait(0.5)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

-- CHỐNG VĂNG GAME AFK
pcall(function() for i,v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end end)
LocalPlayer.Idled:Connect(function() pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end)

-- BIẾN CHÍNH
_G.AutoFarm = false; _G.AutoQuest = true; _G.BringMob = true; _G.FastAttack = true
_G.SelectWeapon = "Melee"; _G.FlyTarget = nil
_G.AutoStats = false; _G.StatsPoint = 1
_G.Stats = {Melee = false, Defense = false, Sword = false, BloxFruit = false}
_G.ESPPlayer = false; _G.ESPFruit = false; _G.ESPChest = false

local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

-- =========================================================
-- 1. GIAO DIỆN (UI ZENITH CHỐNG LỖI)
-- =========================================================
local UI_NAME = "ZyroxV43_Masterpiece"
pcall(function() if game:GetService("CoreGui"):FindFirstChild(UI_NAME) then game:GetService("CoreGui")[UI_NAME]:Destroy() end end)
pcall(function() if LocalPlayer.PlayerGui:FindFirstChild(UI_NAME) then LocalPlayer.PlayerGui[UI_NAME]:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = UI_NAME; ScreenGui.ResetOnSpawn = false
local s, p = pcall(function() return gethui() end)
if s and p then ScreenGui.Parent = p else ScreenGui.Parent = game:GetService("CoreGui") end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 350); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19); MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 5)
local ms = Instance.new("UIStroke", MainFrame); ms.Color = Color3.fromRGB(0, 210, 255); ms.Thickness = 1.5

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38); TopBar.BackgroundColor3 = Color3.fromRGB(14, 18, 27); TopBar.BorderSizePixel = 0
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 300, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1; Title.RichText = true; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "ZYROX VN <font color='#00d2ff'>• V43.0 (MASTERPIECE)</font>"

local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 24, 0, 24); CloseBtn.Position = UDim2.new(1, -28, 0.5, -12); CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90); CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 10; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 155, 1, -38); Sidebar.Position = UDim2.new(0, 0, 0, 38); Sidebar.BackgroundColor3 = Color3.fromRGB(12, 15, 22); Sidebar.BorderSizePixel = 0
local TabScroller = Instance.new("ScrollingFrame", Sidebar)
TabScroller.Size = UDim2.new(1, -8, 1, -12); TabScroller.Position = UDim2.new(0, 4, 0, 6); TabScroller.BackgroundTransparency = 1; TabScroller.BorderSizePixel = 0; TabScroller.ScrollBarThickness = 3; TabScroller.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); TabScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
local TabListLayout = Instance.new("UIListLayout", TabScroller); TabListLayout.Padding = UDim.new(0, 4); TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", TabScroller).PaddingTop = UDim.new(0, 3)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -155, 1, -38); ContentContainer.Position = UDim2.new(0, 155, 0, 38); ContentContainer.BackgroundTransparency = 1

local tabButtons, tabPages = {}, {}
local function createTab(name, icon, label)
    local btn = Instance.new("TextButton", TabScroller); btn.Size = UDim2.new(1, -4, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(25, 30, 42); btn.TextColor3 = Color3.fromRGB(175, 185, 205); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 11; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.Text = "  " .. icon .. "   " .. label
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    local page = Instance.new("ScrollingFrame", ContentContainer); page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0; page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.Visible = false
    local pl = Instance.new("UIListLayout", page); pl.Padding = UDim.new(0, 6); pl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 10); Instance.new("UIPadding", page).PaddingBottom = UDim.new(0, 10)
    tabButtons[name] = btn; tabPages[name] = page
    btn.MouseButton1Click:Connect(function()
        for tName, b in pairs(tabButtons) do b.BackgroundColor3 = (tName == name) and Color3.fromRGB(38, 105, 190) or Color3.fromRGB(25, 30, 42); b.TextColor3 = (tName == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(175, 185, 205) end
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
    switch.MouseButton1Click:Connect(function() state = not state; switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54); circle:TweenPosition(state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), "Out", "Quad", 0.15, true); if callback then callback(state) end end)
end

local function createButton(page, labelText, callback)
    local btn = Instance.new("TextButton", page); btn.Size = UDim2.new(0.94, 0, 0, 30); btn.BackgroundColor3 = Color3.fromRGB(19, 25, 36); Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4); btn.TextColor3 = Color3.fromRGB(0, 210, 255); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 11; btn.Text = labelText
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

-- TẠO CÁC TAB
local pFarm = createTab("Farm", "🌾", "Cày Cấp (Farm)")
local pStats = createTab("Stats", "📈", "Nâng Điểm")
local pFruit = createTab("Fruit", "🍎", "Trái Ác Quỷ")
local pESP = createTab("ESP", "👁️", "Nhìn Xuyên Tường")
local pTele = createTab("Teleport", "🚀", "Dịch Chuyển")
local pShop = createTab("Shop", "🛒", "Cửa Hàng")
local pMisc = createTab("Misc", "⚙️", "Khác (Server)")

tabButtons["Farm"].BackgroundColor3 = Color3.fromRGB(38, 105, 190); tabButtons["Farm"].TextColor3 = Color3.fromRGB(255, 255, 255); tabPages["Farm"].Visible = true

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

-- SETUP CHỨC NĂNG UI
createToggle(pFarm, "⚡ Kích Hoạt Auto Farm Level", false, function(v) _G.AutoFarm = v end)
createToggle(pFarm, "📜 Tự Nhận Nhiệm Vụ", true, function(v) _G.AutoQuest = v end)
createToggle(pFarm, "🧲 Gom Quái Xuống Mặt Đất", true, function(v) _G.BringMob = v end)
createToggle(pFarm, "⚔️ Fast Attack (Chém nhanh)", true, function(v) _G.FastAttack = v end)

createToggle(pStats, "📈 Auto Nâng Điểm", false, function(v) _G.AutoStats = v end)
createToggle(pStats, "🥊 Melee", false, function(v) _G.Stats.Melee = v end)
createToggle(pStats, "🛡️ Defense", false, function(v) _G.Stats.Defense = v end)
createToggle(pStats, "⚔️ Sword", false, function(v) _G.Stats.Sword = v end)
createToggle(pStats, "🍎 Blox Fruit", false, function(v) _G.Stats.BloxFruit = v end)

createButton(pFruit, "🎲 Random Fruit (Gacha)", function() if CommF then CommF:InvokeServer("Cousin", "Buy") end end)
createButton(pFruit, "📦 Store All Fruits", function() for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") then CommF:InvokeServer("StoreFruit", string.split(v.Name, "-")[1], v) end end end)

createToggle(pESP, "👁️ ESP Player", false, function(v) _G.ESPPlayer = v end)
createToggle(pESP, "📦 ESP Chest", false, function(v) _G.ESPChest = v end)
createToggle(pESP, "🍎 ESP Fruit", false, function(v) _G.ESPFruit = v end)

createButton(pTele, "🏝️ Teleport Sea 1", function() if CommF then CommF:InvokeServer("TravelMain") end end)
createButton(pTele, "🏝️ Teleport Sea 2", function() if CommF then CommF:InvokeServer("TravelDressrosa") end end)
createButton(pTele, "🏝️ Teleport Sea 3", function() if CommF then CommF:InvokeServer("TravelZou") end end)

createButton(pShop, "🦵 Buy Geppo (10k)", function() if CommF then CommF:InvokeServer("BuyHaki", "Geppo") end end)
createButton(pShop, "🛡️ Buy Buso Haki (25k)", function() if CommF then CommF:InvokeServer("BuyHaki", "Buso") end end)
createButton(pShop, "🏃 Buy Soru (100k)", function() if CommF then CommF:InvokeServer("BuyHaki", "Soru") end end)
createButton(pShop, "👁️ Buy Ken Haki (750k)", function() if CommF then CommF:InvokeServer("KenTalk", "Buy") end end)

createButton(pMisc, "🎁 Redeem All Codes", function() local codes = {"ADMINHACKED", "ADMINDARES", "SECRET_ADMIN", "NOOB2PRO", "StrawHatMaine", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "THEGREATACE"}; task.spawn(function() for _, c in ipairs(codes) do pcall(function() CommF:InvokeServer("RedeemCustomCode", c) end); task.wait(0.2) end end) end)
createToggle(pMisc, "🚀 Tắt Đồ Họa (Giảm Lag)", false, function(v) Lighting.GlobalShadows = not v; if v then for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("BasePart") then o.Material = Enum.Material.SmoothPlastic end end end end)
createButton(pMisc, "🔄 Rejoin Server", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)

-- =========================================================
-- 2. ĐỘNG CƠ BAY MƯỢT (HEARTBEAT - KHÔNG GIẬT CỤC)
-- =========================================================
RunService.Heartbeat:Connect(function(deltaTime)
    pcall(function()
        if _G.AutoFarm and _G.FlyTarget and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hrp and hum then
                hum.Sit = false
                -- Tàng hình lướt vật thể
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end

                -- Khóa trọng lực
                local bv = hrp:FindFirstChild("FlyBV")
                if not bv then bv = Instance.new("BodyVelocity"); bv.Name = "FlyBV"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bv.Parent = hrp end
                bv.Velocity = Vector3.zero

                local dist = (hrp.Position - _G.FlyTarget.Position).Magnitude
                if dist > 5 then
                    -- Lướt tới mục tiêu với tốc độ 325 (An toàn không bị kick)
                    local speed = 325
                    hrp.CFrame = CFrame.lookAt(hrp.Position, _G.FlyTarget.Position) * CFrame.new(0, 0, -speed * deltaTime)
                else
                    hrp.CFrame = _G.FlyTarget
                end
            end
        else
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("FlyBV") then hrp.FlyBV:Destroy() end
        end
    end)
end)

local function EquipWeapon()
    pcall(function()
        if not LocalPlayer.Character:FindFirstChild("HasBuso") and CommF then CommF:InvokeServer("Buso") end
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and (string.find(tool.ToolTip, _G.SelectWeapon) or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then return end
        for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if t:IsA("Tool") and (string.find(t.ToolTip, _G.SelectWeapon) or t.Name == "Combat" or t.Name == "Võ Tân Binh") then LocalPlayer.Character.Humanoid:EquipTool(t); break end
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
-- 3. VÒNG LẶP FARM CHÍNH
-- =========================================================
local bringPos = nil
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()
                local qName, qLevel, mobName, questPos = GetQuestData()
                infoLabel.Text = string.format("Đang Farm: %s [Cấp %d]", mobName, LocalPlayer.Data.Level.Value)
                
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                local hasQuest = pGui and pGui.Main:FindFirstChild("Quest") and pGui.Main.Quest.Visible
                
                if not hasQuest then
                    bringPos = nil
                    _G.FlyTarget = questPos
                    if (LocalPlayer.Character.HumanoidRootPart.Position - questPos.Position).Magnitude <= 10 then
                        if CommF then CommF:InvokeServer("StartQuest", qName, qLevel) end
                    end
                else
                    if not string.find(pGui.Main.Quest.Container.QuestTitle.Title.Text, mobName) then
                        if CommF then CommF:InvokeServer("AbandonQuest") end
                        return
                    end
                    
                    EquipWeapon()
                    local targetMob = nil
                    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                        if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            targetMob = mob; break
                        end
                    end
                    
                    if targetMob then
                        if not bringPos then bringPos = targetMob.HumanoidRootPart.CFrame end
                        
                        -- CỰ LY 10 MÉT ĐỂ BẤT TỬ
                        local safePos = bringPos * CFrame.new(0, 10, 0)
                        -- Luôn nhìn thẳng xuống con quái
                        _G.FlyTarget = CFrame.lookAt(safePos.Position, bringPos.Position)
                        
                        if (LocalPlayer.Character.HumanoidRootPart.Position - safePos.Position).Magnitude <= 10 then
                            if _G.BringMob then
                                for _, m in pairs(Workspace.Enemies:GetChildren()) do
                                    if m.Name == mobName and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then
                                        -- GOM XUỐNG DƯỚI ĐẤT
                                        m.HumanoidRootPart.CFrame = bringPos
                                        m.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        m.HumanoidRootPart.CanCollide = false
                                        m.Humanoid.WalkSpeed = 0
                                        m.Humanoid.JumpPower = 0
                                        if m.Humanoid:FindFirstChild("Animator") then m.Humanoid.Animator:Destroy() end
                                        m.Humanoid:ChangeState(11)
                                    end
                                end
                                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                            end
                        end
                    else
                        -- Quay về điểm nhận quest nếu hết quái
                        bringPos = nil
                        _G.FlyTarget = questPos
                    end
                end
            end)
        else
            _G.FlyTarget = nil
            bringPos = nil
        end
    end
end)

-- =========================================================
-- 4. FAST ATTACK & HOẠT ẢNH
-- =========================================================
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoFarm and _G.FastAttack then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(50, 50))
                
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                
                local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
                local ac = CbFw.activeController
                if not ac then
                    local get_upv = debug.getupvalues or getupvalues
                    if get_upv then
                        for _, v in pairs(get_upv(CbFw)) do
                            if type(v) == "table" and v.activeController then ac = v.activeController; break end
                        end
                    end
                end
                
                if ac and ac.equipped then
                    ac.hitboxLimiter = 2^20
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
        if _G.AutoFarm and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum and hum:FindFirstChild("Animator") then
                for _, anim in ipairs(hum.Animator:GetPlayingAnimationTracks()) do
                    if anim.Name:lower():match("attack") or anim.Name:lower():match("slash") or anim.Name:lower():match("punch") then anim:Stop() end
                end
            end
        end
    end)
end)

-- =========================================================
-- 5. CÁC TÍNH NĂNG PHỤ: STATS & ESP
-- =========================================================
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoStats then
            pcall(function()
                local points = LocalPlayer.Data.Points.Value
                if points > 0 then
                    local en = {}
                    for s, st in pairs(_G.Stats) do if st then table.insert(en, s) end end
                    if #en > 0 then
                        local pts = math.floor(_G.StatsPoint / #en)
                        if pts < 1 then pts = 1 end
                        for _, st in ipairs(en) do CommF:InvokeServer("AddPoint", st, pts) end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.ESPPlayer then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") then
                    local head = p.Character.Head
                    if not head:FindFirstChild("Z_ESP") then
                        local gui = Instance.new("BillboardGui", head); gui.Name = "Z_ESP"; gui.Size = UDim2.new(0, 200, 0, 40); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 3, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextScaled = true; txt.TextColor3 = Color3.fromRGB(255,0,0); txt.Font = Enum.Font.GothamBold
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

        if _G.ESPChest then
            for _, chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
                if not chest:GetAttribute("IsDisabled") then
                    if not chest:FindFirstChild("Z_ESP") then
                        local gui = Instance.new("BillboardGui", chest); gui.Name = "Z_ESP"; gui.Size = UDim2.new(0, 200, 0, 50); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 2, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextScaled = true; txt.TextColor3 = Color3.fromRGB(255, 215, 0); txt.Font = Enum.Font.GothamBold
                    end
                    local dist = math.floor((chest:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    chest.Z_ESP.TextLabel.Text = "Chest [" .. dist .. "m]"
                elseif chest:FindFirstChild("Z_ESP") then chest.Z_ESP:Destroy() end
            end
        else
            for _, chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
                if chest:FindFirstChild("Z_ESP") then chest.Z_ESP:Destroy() end
            end
        end
        
        if _G.ESPFruit then
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                    local handle = v.Handle
                    if not handle:FindFirstChild("Z_ESP") then
                        local gui = Instance.new("BillboardGui", handle); gui.Name = "Z_ESP"; gui.Size = UDim2.new(0, 200, 0, 40); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 2, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextScaled = true; txt.TextColor3 = Color3.fromRGB(0,255,0); txt.Font = Enum.Font.GothamBold
                    end
                    handle.Z_ESP.TextLabel.Text = v.Name
                end
            end
        else
            for _, v in pairs(Workspace:GetDescendants()) do if v.Name == "Z_ESP" then v:Destroy() end end
        end
    end
end)
