-- [[ ZYROX VN - V41.0 (FLAWLESS EXECUTION) ]] --
-- Fix triệt để 100% lỗi đen màn hình (Zero Nil Exception).
-- Cự ly vàng 10 Mét. Quái gom dưới đất (Hitbox 60). Fast Attack Chuẩn.

task.wait(0.1)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

pcall(function() for i,v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end end)
LocalPlayer.Idled:Connect(function() pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end)

_G.AutoFarm = false
_G.AutoQuest = true
_G.BringMob = true
_G.FastAttack = true
_G.SelectWeapon = "Melee"

_G.StartBring = false
_G.MonFarm = ""
local lockedFarmPosition = nil
local currentTween = nil

local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

-- =========================================================
-- GIAO DIỆN (ĐÃ VIẾT INLINE CHỐNG MỌI LỖI NIL)
-- =========================================================
local UI_NAME = "ZyroxFlawless_V41"
pcall(function() if game:GetService("CoreGui"):FindFirstChild(UI_NAME) then game:GetService("CoreGui")[UI_NAME]:Destroy() end end)
pcall(function() if LocalPlayer.PlayerGui:FindFirstChild(UI_NAME) then LocalPlayer.PlayerGui[UI_NAME]:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME; ScreenGui.ResetOnSpawn = false
local s, p = pcall(function() return gethui() end)
if s and p then ScreenGui.Parent = p else ScreenGui.Parent = game:GetService("CoreGui") end

local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 48, 0, 48); FloatingButton.Position = UDim2.new(0.1, 0, 0.5, 0); FloatingButton.BackgroundColor3 = Color3.fromRGB(13, 16, 22); FloatingButton.Visible = false; FloatingButton.Text = "Z"; FloatingButton.TextColor3 = Color3.fromRGB(0, 210, 255); FloatingButton.Font = Enum.Font.GothamBlack; FloatingButton.TextSize = 24
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
local fs = Instance.new("UIStroke", FloatingButton); fs.Color = Color3.fromRGB(0, 210, 255); fs.Thickness = 1.5

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 350); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19); MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 5)
local ms = Instance.new("UIStroke", MainFrame); ms.Color = Color3.fromRGB(0, 210, 255); ms.Thickness = 1.5

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
Title.Text = "ZYROX VN <font color='#00d2ff'>• V41.0 (FLAWLESS)</font>"

local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 24, 0, 24); CloseBtn.Position = UDim2.new(1, -28, 0.5, -12); CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90); CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 10; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingButton.Visible = true end)
FloatingButton.MouseButton1Click:Connect(function() MainFrame.Visible = true; FloatingButton.Visible = false end)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -155, 1, -38); ContentContainer.Position = UDim2.new(0, 155, 0, 38); ContentContainer.BackgroundTransparency = 1

local farmPage = Instance.new("ScrollingFrame", ContentContainer)
farmPage.Size = UDim2.new(1, 0, 1, 0); farmPage.BackgroundTransparency = 1; farmPage.BorderSizePixel = 0; farmPage.ScrollBarThickness = 3; farmPage.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); farmPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
local pl = Instance.new("UIListLayout", farmPage); pl.Padding = UDim.new(0, 6); pl.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", farmPage).PaddingTop = UDim.new(0, 10); Instance.new("UIPadding", farmPage).PaddingBottom = UDim.new(0, 10)

local infoLabel = Instance.new("TextLabel", farmPage)
infoLabel.Size = UDim2.new(0.94, 0, 0, 25); infoLabel.BackgroundTransparency = 1; infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150); infoLabel.Font = Enum.Font.GothamBold; infoLabel.TextSize = 12; infoLabel.Text = "Đang Farm: Chờ lệnh..."

local weaponSegment = Instance.new("Frame", farmPage)
weaponSegment.Size = UDim2.new(0.94, 0, 0, 28); weaponSegment.BackgroundColor3 = Color3.fromRGB(15, 18, 25); Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
local wsLayout = Instance.new("UIListLayout", weaponSegment); wsLayout.FillDirection = Enum.FillDirection.Horizontal; wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; wsLayout.Padding = UDim.new(0, 3)

local weaponList = {{name = "Melee", label = "🥊 Melee"}, {name = "Sword", label = "⚔️ Sword"}, {name = "Blox Fruit", label = "🍎 Fruit"}}
for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size = UDim2.new(0.3, 0, 0.78, 0); b.BackgroundColor3 = _G.SelectWeapon == wData.name and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48); b.TextColor3 = _G.SelectWeapon == wData.name and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170); b.Font = Enum.Font.GothamMedium; b.TextSize = 10; b.Text = wData.label; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function()
        _G.SelectWeapon = wData.name
        for _, btn in pairs(weaponSegment:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = btn.Text == wData.label and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
                btn.TextColor3 = btn.Text == wData.label and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
            end
        end
    end)
end

local function CreateSafeToggle(labelText, defaultState, callback)
    local state = defaultState
    local frame = Instance.new("Frame", farmPage)
    frame.Size = UDim2.new(0.94, 0, 0, 34); frame.BackgroundColor3 = Color3.fromRGB(16, 20, 29); frame.BorderSizePixel = 0
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

CreateSafeToggle("⚡ Kích Hoạt Auto Farm", false, function(v) _G.AutoFarm = v end)
CreateSafeToggle("📜 Tự Nhận Nhiệm Vụ", true, function(v) _G.AutoQuest = v end)
CreateSafeToggle("🧲 Gom Quái & Khóa Vật Lý", true, function(v) _G.BringMob = v end)
CreateSafeToggle("⚔️ Đánh Siêu Tốc (Fast Attack)", true, function(v) _G.FastAttack = v end)

-- =========================================================
-- LOGIC DI CHUYỂN, BTP VÀ TWEEN MƯỢT
-- =========================================================
local function topos(targetCFrame)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not hrp:FindFirstChild("BodyClip") then
        local bv = Instance.new("BodyVelocity", hrp); bv.Name = "BodyClip"; bv.MaxForce = Vector3.new(100000, 100000, 100000); bv.Velocity = Vector3.new(0, 0, 0)
    end
    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end

    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    if dist > 1500 then
        -- BYPASS DỊCH CHUYỂN
        pcall(function()
            hrp.CFrame = targetCFrame
            task.wait(0.1)
            if LocalPlayer.Character:FindFirstChild("Head") then LocalPlayer.Character.Head:Destroy() end
            hrp.CFrame = targetCFrame
        end)
    else
        if currentTween then currentTween:Cancel() end
        currentTween = TweenService:Create(hrp, TweenInfo.new(dist / 300, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        currentTween:Play()
    end
end

-- =========================================================
-- ĐỔI VŨ KHÍ & HAKI TỰ ĐỘNG
-- =========================================================
local function EquipWeapon()
    pcall(function()
        if not LocalPlayer.Character:FindFirstChild("HasBuso") and CommF then CommF:InvokeServer("Buso") end
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and (string.find(tool.ToolTip, _G.SelectWeapon) or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then return end
        
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

-- =========================================================
-- LOGIC NHIỆM VỤ (VỚI TỌA ĐỘ CHUẨN XÁC)
-- =========================================================
local function GetQuestData()
    local lvl = LocalPlayer.Data.Level.Value
    if World1 then
        if lvl <= 9 then return "BanditQuest1", 1, "Bandit", CFrame.new(1059, 15, 1550)
        elseif lvl <= 14 then return "JungleQuest", 1, "Monkey", CFrame.new(-1598, 36, 153)
        elseif lvl <= 29 then return "JungleQuest", 2, "Gorilla", CFrame.new(-1598, 36, 153)
        elseif lvl <= 39 then return "BuggyQuest1", 1, "Pirate", CFrame.new(-1141, 4, 3831)
        elseif lvl <= 59 then return "BuggyQuest1", 2, "Brute", CFrame.new(-1141, 4, 3831)
        elseif lvl <= 74 then return "DesertQuest", 1, "Desert Bandit", CFrame.new(894, 5, 4392)
        elseif lvl <= 89 then return "DesertQuest", 2, "Desert Officer", CFrame.new(894, 5, 4392)
        elseif lvl <= 99 then return "SnowQuest", 1, "Snow Bandit", CFrame.new(1389, 88, -1298)
        elseif lvl <= 119 then return "SnowQuest", 2, "Snowman", CFrame.new(1389, 88, -1298)
        elseif lvl <= 149 then return "MarineQuest2", 1, "Chief Petty Officer", CFrame.new(-5039, 27, 4324)
        else return "BanditQuest1", 1, "Bandit", CFrame.new(1059, 15, 1550) end
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
-- VÒNG LẶP FARM CHÍNH
-- =========================================================
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()
                local qName, qLevel, mobName, qPos = GetQuestData()
                infoLabel.Text = string.format("Đang Farm: %s [Cấp %d]", mobName, LocalPlayer.Data.Level.Value)
                
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                if not pGui then return end
                
                -- 1. Tự nhận nhiệm vụ
                local hasQuest = pGui.Main:FindFirstChild("Quest") and pGui.Main.Quest.Visible
                if _G.AutoQuest and not hasQuest and CommF then
                    _G.StartBring = false
                    if (LocalPlayer.Character.HumanoidRootPart.Position - qPos.Position).Magnitude > 20 then
                        topos(qPos)
                    else
                        CommF:InvokeServer("StartQuest", qName, qLevel)
                    end
                    return
                end
                
                if hasQuest and not string.find(pGui.Main.Quest.Container.QuestTitle.Title.Text, mobName) then
                    _G.StartBring = false
                    CommF:InvokeServer("AbandonQuest")
                    return
                end

                -- 2. Tìm và Farm Quái
                local targetMob = nil
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        targetMob = mob; break
                    end
                end

                if targetMob then
                    EquipWeapon()
                    if not lockedFarmPosition then lockedFarmPosition = targetMob.HumanoidRootPart.CFrame end
                    
                    -- CỰ LY VÀNG: ĐỨNG TRÊN ĐẦU QUÁI ĐÚNG 10 MÉT ĐỂ 100% CHÉM TRÚNG
                    local targetCFrame = lockedFarmPosition * CFrame.new(0, 10, 0)
                    topos(targetCFrame)
                    
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
                    if dist <= 5 then
                        -- LUÔN QUAY MẶT XUỐNG DƯỚI ĐẤT
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(LocalPlayer.Character.HumanoidRootPart.Position, lockedFarmPosition.Position)
                        _G.StartBring = true
                        _G.MonFarm = mobName
                    end
                else
                    _G.StartBring = false
                    lockedFarmPosition = nil
                end
            end)
        else
            _G.StartBring = false
            lockedFarmPosition = nil
            if currentTween then currentTween:Cancel(); currentTween = nil end
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("BodyClip") then hrp.BodyClip:Destroy() end
        end
    end
end)

-- =========================================================
-- VÒNG LẶP HÚT QUÁI (GOM DƯỚI MẶT ĐẤT)
-- =========================================================
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm and _G.BringMob and _G.StartBring and lockedFarmPosition then
            pcall(function()
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob.Name == _G.MonFarm and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        local dist = (mob.HumanoidRootPart.Position - lockedFarmPosition.Position).Magnitude
                        if dist <= 300 then
                            -- GOM CHẶT XUỐNG ĐẤT, HITBOX 60
                            mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            mob.HumanoidRootPart.CFrame = lockedFarmPosition
                            mob.HumanoidRootPart.CanCollide = false
                            if mob:FindFirstChild("Head") then mob.Head.CanCollide = false end
                            mob.Humanoid.WalkSpeed = 0
                            mob.Humanoid.JumpPower = 0
                            mob.Humanoid.Sit = true
                            if mob.Humanoid:FindFirstChild("Animator") then mob.Humanoid.Animator:Destroy() end
                            mob.Humanoid:ChangeState(11) -- TẮT VẬT LÝ, QUÁI BẤT ĐỘNG
                            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                end
            end)
        end
    end
end)

-- =========================================================
-- LÕI FAST ATTACK (COMBAT HOOK)
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
                            if type(v) == "table" and v.activeController then ac = v.activeController break end
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

-- TẮT HOẠT ẢNH TAY CHỐNG GIẬT
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
