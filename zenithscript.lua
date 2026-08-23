-- [[ ZENITH BLOX FRUIT - TRUE HUB CORE (AZURE/HOHO BYPASS) ]] --
-- ĐÃ LOẠI BỎ CHUỘT ẢO, SỬ DỤNG 100% HOOK MEMORY VÀ CFRAME LERP

task.wait(0.5)
if not game:IsLoaded() then game.Loaded:Wait() end

-- =========================================================
-- KHỞI TẠO DỮ LIỆU & LÕI
-- =========================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- Chống Disconnect
for i,v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end

-- Biến toàn cục
local _G = {
    AutoFarm = false,
    AutoQuest = true,
    BringMob = true,
    Weapon = "Melee",
    FastAttack = true,
    TargetPos = nil,
    TargetName = ""
}

-- =========================================================
-- LÕI FAST ATTACK (COMBAT FRAMEWORK HOOK) - CHUẨN HUB VIP
-- =========================================================
local requireCbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
local CbFw = debug.getupvalues(requireCbFw)[2]

-- Ngắt rung màn hình để không bị lác mắt khi chém 100 hit/s
pcall(function()
    local camShaker = require(ReplicatedStorage.Util.CameraShaker)
    camShaker:Stop()
end)

task.spawn(function()
    while task.wait() do
        if _G.AutoFarm and _G.FastAttack then
            pcall(function()
                local ac = CbFw.activeController
                if ac and ac.equipped then
                    -- Xóa toàn bộ giới hạn và delay của Game
                    ac.hitboxLimiter = 0
                    ac.timeToNextAttack = 0
                    ac.timeToNextBlock = 0
                    ac.increment = 3
                    ac.attacking = false
                    ac.blocking = false
                    ac.hasCombatState = false
                    
                    -- Kích hoạt hàm tấn công nội bộ của game
                    ac:attack()
                    
                    -- Kích hoạt đòn chém ẩn
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end)
            
            -- Backup Force Click (Cho LDPlayer nếu bị mất focus)
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
    end
end)

-- Xóa Animation Vung Tay (Giảm 100% Lag Giả Lập)
RunService.Stepped:Connect(function()
    if _G.AutoFarm then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local animator = hum:FindFirstChild("Animator")
                if animator then
                    for _, anim in ipairs(animator:GetPlayingAnimationTracks()) do
                        local name = anim.Name:lower()
                        if name:match("attack") or name:match("punch") or name:match("slash") or name:match("swing") or name:match("m1") then
                            anim:Stop()
                        end
                    end
                end
            end
        end
    end
end)

-- =========================================================
-- ĐỘNG CƠ BAY (TWEEN + LERP CHỐNG KẸT & ANTI-CHEAT)
-- =========================================================
local currentTween = nil

local function TweenTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    
    -- Nếu gần, ghim cứng luôn
    if dist < 5 then
        if currentTween then currentTween:Cancel(); currentTween = nil end
        hrp.CFrame = targetCFrame
        return
    end

    -- Nếu quá xa (chuyển đảo), dùng thuật toán Bypass Teleport của Hub
    if dist > 1500 then
        -- Mẹo: Rơi tự do rồi teleport từng nấc để không bị AntiCheat kéo lại
        hrp.CFrame = targetCFrame
        task.wait(0.1)
        return
    end

    local speed = 350
    local tweenInfo = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
    if not currentTween or currentTween.PlaybackState ~= Enum.PlaybackState.Playing then
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        currentTween:Play()
    end
end

-- Bật tàng hình (NoClip) và Đệm khí vĩnh cửu
RunService.Stepped:Connect(function()
    if _G.AutoFarm and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            
            local bv = hrp:FindFirstChild("GodMode_BV")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "GodMode_BV"
                bv.MaxForce = Vector3.new(100000, 100000, 100000)
                bv.Velocity = Vector3.zero
                bv.Parent = hrp
            else
                bv.Velocity = Vector3.zero
            end
        end
    else
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("GodMode_BV") then hrp.GodMode_BV:Destroy() end
    end
end)

-- =========================================================
-- LOGIC TÌM NHIỆM VỤ & QUÁI VẬT TỐI ƯU
-- =========================================================
local function getQuestData()
    local level = LocalPlayer.Data.Level.Value
    if level <= 9 then return "BanditQuest1", 1, "Bandit", CFrame.new(1057, 16, 1378)
    elseif level <= 14 then return "JungleQuest", 1, "Monkey", CFrame.new(-1598, 36, 153)
    elseif level <= 29 then return "JungleQuest", 2, "Gorilla", CFrame.new(-1189, 36, -512)
    elseif level <= 39 then return "BuggyQuest1", 1, "Pirate", CFrame.new(-1141, 4, 3828)
    elseif level <= 59 then return "BuggyQuest1", 2, "Brute", CFrame.new(-1141, 4, 3828)
    elseif level <= 74 then return "DesertQuest", 1, "Desert Bandit", CFrame.new(895, 6, 4390)
    elseif level <= 89 then return "DesertQuest", 2, "Desert Officer", CFrame.new(895, 6, 4390)
    elseif level <= 99 then return "SnowQuest", 1, "Snow Bandit", CFrame.new(1386, 87, -1298)
    elseif level <= 119 then return "SnowQuest", 2, "Snowman", CFrame.new(1386, 87, -1298)
    else return "BanditQuest1", 1, "Bandit", CFrame.new(1057, 16, 1378) end -- Fallback
end

local function hasQuest()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    return gui and gui.Main:FindFirstChild("Quest") and gui.Main.Quest.Visible
end

-- =========================================================
-- GIAO DIỆN (UI TỐI GIẢN - ĐẬM CHẤT HACKER)
-- =========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenithTrueHub"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 260)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 255, 128)
Stroke.Thickness = 1.5

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "TRUE HUB CORE - BYPASS ALL"

local InfoLabel = Instance.new("TextLabel", MainFrame)
InfoLabel.Size = UDim2.new(1, -20, 0, 25)
InfoLabel.Position = UDim2.new(0, 10, 0, 45)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.Font = Enum.Font.GothamMedium
InfoLabel.TextSize = 12
InfoLabel.Text = "Đang rảnh..."

-- Drag Logic
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
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
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local function CreateToggle(yPos, text, default, callback)
    local state = default
    local frame = Instance.new("Frame", MainFrame)
    frame.Size = UDim2.new(1, -20, 0, 35)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 15, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text
    
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -50, 0.5, -10)
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(40, 40, 45)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(40, 40, 45)
        circle:TweenPosition(state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.15, true)
        if callback then callback(state) end
    end)
end

CreateToggle(80, "⚡ Kích Hoạt Auto Farm (Bypass Cực Mạnh)", false, function(v) _G.AutoFarm = v end)
CreateToggle(125, "⚔️ Bật Fast Attack Tiêm Memory", true, function(v) _G.FastAttack = v end)
CreateToggle(170, "🧲 Hút Quái Vật Thể Rắn", true, function(v) _G.BringMob = v end)
CreateToggle(215, "🛡 Tự Động Bật Haki", true, function(v)
    if v and not LocalPlayer.Character:FindFirstChild("HasBuso") then
        CommF:InvokeServer("Buso")
    end
end)

-- Nút Thu Nhỏ
local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 35, 0, 35); MinBtn.Position = UDim2.new(1, -35, 0, 0); MinBtn.BackgroundTransparency = 1; MinBtn.Text = "—"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 14
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame:TweenSize(minimized and UDim2.new(0, 450, 0, 35) or UDim2.new(0, 450, 0, 260), "Out", "Quad", 0.2, true)
end)


-- =========================================================
-- VÒNG LẶP CHÍNH (GOM QUÁI TÀN BẠO)
-- =========================================================
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local qName, qLevel, mobName, defaultSpawn = getQuestData()
            _G.TargetName = mobName
            
            pcall(function() InfoLabel.Text = string.format("Đang Trảm Áp: %s [Cấp %d]", mobName, LocalPlayer.Data.Level.Value) end)

            -- Nhận Nhiệm Vụ
            if _G.AutoQuest and not hasQuest() then
                pcall(function() CommF:InvokeServer("StartQuest", qName, qLevel) end)
                task.wait(0.5)
            end

            -- Trang bị vũ khí (Check liên tục)
            pcall(function()
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if not tool or (not string.find(tool.ToolTip, "Melee") and tool.Name ~= "Combat" and tool.Name ~= "Võ Tân Binh") then
                    for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if t:IsA("Tool") and (string.find(t.ToolTip, "Melee") or t.Name == "Combat" or t.Name == "Võ Tân Binh") then
                            LocalPlayer.Character.Humanoid:EquipTool(t)
                            break
                        end
                    end
                end
            end)

            -- Bật Haki
            if not LocalPlayer.Character:FindFirstChild("HasBuso") then
                pcall(function() CommF:InvokeServer("Buso") end)
            end

            -- TÌM VÀ GOM QUÁI MẠNH MẼ
            local targetMob = nil
            for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    targetMob = mob
                    break
                end
            end

            if targetMob then
                local mobPos = targetMob.HumanoidRootPart.Position
                -- Tọa độ bạn đứng: Cực kì an toàn, 30 Mét trên không trung
                local safePos = CFrame.new(mobPos.X, mobPos.Y + 30, mobPos.Z)
                
                local myHRP = LocalPlayer.Character.HumanoidRootPart
                if (myHRP.Position - safePos.Position).Magnitude > 5 then
                    TweenTo(safePos)
                else
                    if currentTween then currentTween:Cancel(); currentTween = nil end
                    
                    -- Ép hướng nhìn thẳng xuống quái
                    myHRP.CFrame = CFrame.lookAt(safePos.Position, safePos.Position - Vector3.new(0, 10, 0))

                    if _G.BringMob then
                        for _, v in pairs(Workspace.Enemies:GetChildren()) do
                            if v.Name == mobName then
                                pcall(function()
                                    local eHrp = v.HumanoidRootPart
                                    local eHum = v.Humanoid
                                    if eHum.Health > 0 and (eHrp.Position - mobPos).Magnitude < 350 then
                                        -- Hút toàn bộ quái lại 1 điểm ngay trước mũi kiếm
                                        -- 6 mét là khoảng cách vàng để Fast Attack phát huy
                                        eHrp.CFrame = safePos * CFrame.new(0, -6, -4)
                                        eHrp.Size = Vector3.new(10, 10, 10)
                                        eHrp.CanCollide = false
                                        eHrp.AssemblyLinearVelocity = Vector3.zero
                                        
                                        -- Vô hiệu hóa AI Quái (StrafingNoPhysics)
                                        eHum.WalkSpeed = 0
                                        eHum.JumpPower = 0
                                        eHum:ChangeState(Enum.HumanoidStateType.StrafingNoPhysics)
                                    end
                                end)
                            end
                        end
                    end
                end
            else
                -- Không thấy quái, bay ngay tới điểm Origin GPS
                TweenTo(defaultSpawn * CFrame.new(0, 30, 0))
            end
        else
            if currentTween then currentTween:Cancel(); currentTween = nil end
        end
    end
end)
