-- [[ ZENITH BLOX FRUIT - V-GOD MODE (TRUE EXECUTOR)
--    NO CLICK SIMULATION | MEMORY HOOK ATTACK | ZERO GRAVITY FARM
-- ]] --

task.wait(0.1)

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- Tắt Anti-AFK của Roblox
for _, v in pairs(getconnections(LocalPlayer.Idled)) do
    v:Disable()
end

-- =========================================================
-- BIẾN HỆ THỐNG
-- =========================================================
local AutoFarmLevel = false
local AutoQuest = true
local BringMob = true
local selectedWeaponType = "Melee"

local espPlayerEnabled = false
local espFruitEnabled = false
local espChestEnabled = false

local AutoRandomFruit = false
local AutoStoreFruit = false

local currentTargetName = ""
local currentQuestData = nil
local FarmPosition = nil

-- =========================================================
-- GIAO DIỆN (UI SIÊU MƯỢT)
-- =========================================================
local UI_NAME = "Zenith_GodMode"
pcall(function() game:GetService("CoreGui")[UI_NAME]:Destroy() end)
pcall(function() LocalPlayer.PlayerGui[UI_NAME]:Destroy() end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = Color3.fromRGB(0, 200, 255); MainStroke.Thickness = 1.5

-- Kéo thả UI
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25); TopBar.BorderSizePixel = 0
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1; Title.RichText = true; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 13; Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "ZYROX VN <font color='#00d2ff'>• V-GOD MODE</font>"

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -35, 0, 0); CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 90); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -20, 1, -50); Content.Position = UDim2.new(0, 10, 0, 40); Content.BackgroundTransparency = 1

local function CreateToggle(yPos, text, default, callback)
    local state = default
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(1, 0, 0, 35); frame.Position = UDim2.new(0, 0, 0, yPos); frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", frame); lbl.Size = UDim2.new(1, -60, 1, 0); lbl.Position = UDim2.new(0, 15, 0, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(220, 220, 220); lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = text
    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(0, 36, 0, 18); btn.Position = UDim2.new(1, -45, 0.5, -9); btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(40, 40, 45); btn.Text = ""; Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", btn); circle.Size = UDim2.new(0, 14, 0, 14); circle.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    btn.MouseButton1Click:Connect(function()
        state = not state; btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(40, 40, 45)
        circle:TweenPosition(state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.15, true)
        if callback then callback(state) end
    end)
end

CreateToggle(0, "⚡ Tự Động Farm (Tiêm Lõi Memory)", false, function(v) AutoFarmLevel = v end)
CreateToggle(40, "📜 Tự Nhận Nhiệm Vụ", true, function(v) AutoQuest = v end)
CreateToggle(80, "🧲 Gom Quái Xuống Chân (Tắt AI Quái)", true, function(v) BringMob = v end)
CreateToggle(120, "📦 Tự Động Cất Trái Ác Quỷ", false, function(v) AutoStoreFruit = v end)
CreateToggle(160, "🍎 Nhặt Trái Rơi Toàn Bản Đồ", false, function(v) AutoCollectFruit = v end)

-- =========================================================
-- LOGIC NHIỆM VỤ CHUẨN XÁC NHẤT
-- =========================================================
local function getAutoQuestData()
    local level = LocalPlayer.Data.Level.Value
    if level <= 9 then return "BanditQuest1", 1, "Bandit"
    elseif level <= 14 then return "JungleQuest", 1, "Monkey"
    elseif level <= 29 then return "JungleQuest", 2, "Gorilla"
    elseif level <= 39 then return "BuggyQuest1", 1, "Pirate"
    elseif level <= 59 then return "BuggyQuest1", 2, "Brute"
    elseif level <= 74 then return "DesertQuest", 1, "Desert Bandit"
    elseif level <= 89 then return "DesertQuest", 2, "Desert Officer"
    elseif level <= 99 then return "SnowQuest", 1, "Snow Bandit"
    elseif level <= 119 then return "SnowQuest", 2, "Snowman"
    elseif level <= 149 then return "MarineQuest2", 1, "Chief Petty Officer"
    elseif level <= 174 then return "SkyQuest", 1, "Sky Bandit"
    elseif level <= 189 then return "SkyQuest", 2, "Dark Master"
    elseif level <= 209 then return "PrisonerQuest", 1, "Prisoner"
    else return "PeanutQuest", 1, "Peanut Scout" end
end

local function hasQuest()
    for _, v in pairs(LocalPlayer.PlayerGui.Main:GetChildren()) do
        if v.Name == "Quest" and v.Visible then return true end
    end
    return false
end

-- =========================================================
-- ĐỘNG CƠ DI CHUYỂN TUYỆT ĐỐI (NO CLIP + TWEEN TỐC ĐỘ 300)
-- =========================================================
local currentTween = nil

RunService.Stepped:Connect(function()
    if AutoFarmLevel and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Tự động bơm BodyVelocity để chống rớt, lơ lửng tuyệt đối
            local bv = hrp:FindFirstChild("GodMode_BV")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "GodMode_BV"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = hrp
            end
        end
    else
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("GodMode_BV") then
            hrp.GodMode_BV:Destroy()
        end
    end
end)

local function toTarget(pos)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dist = (hrp.Position - pos.Position).Magnitude
    if dist < 5 then
        if currentTween then currentTween:Cancel() end
        hrp.CFrame = pos
        return
    end

    local speed = 300
    local tweenInfo = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
    if not currentTween or currentTween.PlaybackState ~= Enum.PlaybackState.Playing then
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = pos})
        currentTween:Play()
    end
end

-- =========================================================
-- COMBAT FRAMEWORK HOOK (TRUE FAST ATTACK)
-- =========================================================
local requireCbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
local CbFw = debug.getupvalues(requireCbFw)[2]

-- Xóa hiệu ứng rung màn hình
pcall(function()
    local camShaker = require(ReplicatedStorage.Util.CameraShaker)
    camShaker:Stop()
end)

task.spawn(function()
    while task.wait() do
        if AutoFarmLevel then
            pcall(function()
                local ac = CbFw.activeController
                if ac and ac.equipped then
                    ac.hitboxLimiter = 0
                    ac.timeToNextAttack = 0
                    ac.timeToNextBlock = 0
                    ac.increment = 3
                    ac.attacking = false
                    ac.blocking = false
                    ac.hasCombatState = false
                    
                    -- Ép game tung đòn đánh thẳng vào server
                    ac:attack()
                    
                    -- Chơi đòn đánh ảo (Aura Slash) cho ngầu
                    local weapon = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if weapon then weapon:Activate() end
                end
            end)
        end
    end
end)

-- =========================================================
-- VÒNG LẶP FARM CHÍNH
-- =========================================================
task.spawn(function()
    while task.wait(0.05) do
        if AutoFarmLevel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local qName, qLevel, mobName = getAutoQuestData()
            
            -- 1. Nhận Nhiệm Vụ
            if AutoQuest and not hasQuest() then
                pcall(function() CommF:InvokeServer("StartQuest", qName, qLevel) end)
                task.wait(0.5)
            end
            
            -- 2. Đổi Vũ Khí
            pcall(function()
                local bp = LocalPlayer:FindFirstChild("Backpack")
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                local curTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if bp and hum then
                    if not curTool or (not string.find(curTool.ToolTip, "Melee") and curTool.Name ~= "Combat" and curTool.Name ~= "Võ Tân Binh") then
                        for _, tool in pairs(bp:GetChildren()) do
                            if tool:IsA("Tool") and (string.find(tool.ToolTip, "Melee") or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then
                                hum:EquipTool(tool)
                                break
                            end
                        end
                    end
                end
            end)

            -- 3. Tìm Quái & Gom Quái
            local targetMob = nil
            for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                    targetMob = mob
                    break
                end
            end

            if targetMob then
                local mobHRP = targetMob.HumanoidRootPart
                -- Tọa độ bay: Nằm trên đỉnh bãi quái 30 mét
                if not FarmPosition or (FarmPosition.Position - mobHRP.Position).Magnitude > 200 then
                    FarmPosition = mobHRP.CFrame * CFrame.new(0, 30, 0)
                end

                local myHRP = LocalPlayer.Character.HumanoidRootPart
                local dist = (myHRP.Position - FarmPosition.Position).Magnitude

                if dist > 5 then
                    toTarget(FarmPosition)
                else
                    if currentTween then currentTween:Cancel() end
                    -- Ép bạn đứng lơ lửng, nhìn xuống mặt đất
                    myHRP.CFrame = CFrame.lookAt(FarmPosition.Position, FarmPosition.Position - Vector3.new(0, 10, 0))

                    if BringMob then
                        for _, v in pairs(Workspace.Enemies:GetChildren()) do
                            if v.Name == mobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                pcall(function()
                                    local eHRP = v.HumanoidRootPart
                                    local eHum = v.Humanoid
                                    if (eHRP.Position - FarmPosition.Position).Magnitude < 350 then
                                        -- Hút quái gom lại dưới chân bạn đúng 6 mét
                                        eHRP.CFrame = FarmPosition * CFrame.new(0, -6, -4)
                                        eHRP.Size = Vector3.new(15, 15, 15) -- Kích thước vừa phải để chém trúng, Server không block
                                        eHRP.Transparency = 1
                                        eHRP.CanCollide = false
                                        
                                        -- Xóa AI quái vật hoàn toàn
                                        eHum.WalkSpeed = 0
                                        eHum.JumpPower = 0
                                        eHum.Sit = true
                                        if eHum:FindFirstChild("Animator") then eHum.Animator:Destroy() end
                                        
                                        -- Cố định quái bằng BodyVelocity
                                        local eBv = eHRP:FindFirstChild("GodMode_BV_Mob")
                                        if not eBv then
                                            eBv = Instance.new("BodyVelocity")
                                            eBv.Name = "GodMode_BV_Mob"
                                            eBv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                            eBv.Velocity = Vector3.new(0, 0, 0)
                                            eBv.Parent = eHRP
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end
            else
                FarmPosition = nil
                -- Tìm điểm Spawn
                local spawnPos = nil
                local origin = Workspace:FindFirstChild("_WorldOrigin")
                if origin and origin:FindFirstChild("EnemySpawns") then
                    for _, sp in pairs(origin.EnemySpawns:GetChildren()) do
                        if sp.Name == mobName then spawnPos = sp.CFrame; break end
                    end
                end
                
                if spawnPos then
                    toTarget(spawnPos * CFrame.new(0, 30, 0))
                else
                    if currentTween then currentTween:Cancel() end
                end
            end
        else
            if currentTween then currentTween:Cancel() end
            FarmPosition = nil
        end
    end
end)
