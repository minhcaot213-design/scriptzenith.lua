-- [[ ZENITH BLOX FRUIT - V33.0 (W-AZURE CORE REPLICA) ]] --
-- CÔNG NGHỆ FARM ĐỈNH CAO: PLATFORM BYPASS + BRING MOB CỰC MƯỢT

task.wait(0.1)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- =========================================================
-- KHỞI TẠO BIẾN
-- =========================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

-- CHỐNG AFK CRASH 100%
pcall(function()
    for i,v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end
end)
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

local _G = {
    AutoFarm = false,
    AutoQuest = true,
    BringMob = true,
    Weapon = "Melee",
    FastAttack = true
}

-- =========================================================
-- BẢN ĐỒ TỌA ĐỘ GPS DỰ PHÒNG
-- =========================================================
local IslandPositions = {
    ["Bandit"] = CFrame.new(1057, 16, 1378),
    ["Monkey"] = CFrame.new(-1598, 36, 153),
    ["Gorilla"] = CFrame.new(-1166, 22, -493),
    ["Pirate"] = CFrame.new(-1141, 4, 3828),
    ["Brute"] = CFrame.new(-1141, 4, 3828),
    ["Desert Bandit"] = CFrame.new(895, 6, 4390),
    ["Desert Officer"] = CFrame.new(895, 6, 4390),
    ["Snow Bandit"] = CFrame.new(1386, 87, -1298),
    ["Snowman"] = CFrame.new(1386, 87, -1298),
    ["Chief Petty Officer"] = CFrame.new(-4884, 21, 4301),
    ["Sky Bandit"] = CFrame.new(-4842, 717, -2623),
    ["Dark Master"] = CFrame.new(-4842, 717, -2623),
    ["Prisoner"] = CFrame.new(4875, 5, 735),
    ["Peanut Scout"] = CFrame.new(-2051, 37, -10254)
}

-- =========================================================
-- UI SIÊU TỐI GIẢN (CHỐNG LAG GIẢ LẬP)
-- =========================================================
local UI_NAME = "ZenithTrueHub_V33"
pcall(function() if game.CoreGui:FindFirstChild(UI_NAME) then game.CoreGui[UI_NAME]:Destroy() end end)
pcall(function() if LocalPlayer.PlayerGui:FindFirstChild(UI_NAME) then LocalPlayer.PlayerGui[UI_NAME]:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Text = "ZYROX VN - V33 (W-AZURE CORE)"
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

-- Kéo thả UI
local dragging, dragInput, dragStart, startPos
Title.InputBegan:Connect(function(input)
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
Title.InputChanged:Connect(function(input)
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
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(40, 40, 45)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(40, 40, 45)
        circle:TweenPosition(state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.15, true)
        if callback then callback(state) end
    end)
end

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 45)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 12
StatusLabel.Text = "Đang rảnh..."

CreateToggle(80, "⚡ Kích Hoạt Auto Farm (Pro Mode)", false, function(v) _G.AutoFarm = v end)
CreateToggle(120, "⚔️ Fast Attack (Chém Không Vung Tay)", true, function(v) _G.FastAttack = v end)
CreateToggle(160, "🧲 Kéo Quái Lên Trời (VIP Bring Mob)", true, function(v) _G.BringMob = v end)
CreateToggle(200, "🛡 Tự Động Bật Haki", true, function(v)
    if v and LocalPlayer.Character and not LocalPlayer.Character:FindFirstChild("HasBuso") and CommF then
        CommF:InvokeServer("Buso")
    end
end)

-- Nút Thu Nhỏ
local MinBtn = Instance.new("TextButton", Title)
MinBtn.Size = UDim2.new(0, 40, 1, 0)
MinBtn.Position = UDim2.new(1, -40, 0, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame:TweenSize(isMinimized and UDim2.new(0, 400, 0, 40) or UDim2.new(0, 400, 0, 250), "Out", "Quad", 0.2, true)
end)

-- =========================================================
-- LÕI VŨ KHÍ & HAKI TỰ ĐỘNG
-- =========================================================
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                
                -- Haki
                if not char:FindFirstChild("HasBuso") and CommF then CommF:InvokeServer("Buso") end
                
                -- Vũ khí
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local hum = char:FindFirstChild("Humanoid")
                local currentTool = char:FindFirstChildOfClass("Tool")
                
                local isEquipped = false
                if currentTool and (string.find(currentTool.ToolTip, _G.Weapon) or currentTool.Name == "Combat" or currentTool.Name == "Võ Tân Binh") then 
                    isEquipped = true 
                end
                
                if not isEquipped and backpack and hum then
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and (string.find(tool.ToolTip, _G.Weapon) or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then 
                            hum:EquipTool(tool) 
                            break 
                        end
                    end
                end
            end)
        end
    end
end)

-- =========================================================
-- TẤM THẢM TÀNG HÌNH & TWEEN SIÊU MƯỢT (BYPASS W-AZURE)
-- =========================================================
local Platform = Workspace:FindFirstChild("ZenithPlatform") or Instance.new("Part", Workspace)
Platform.Name = "ZenithPlatform"
Platform.Size = Vector3.new(20, 2, 20)
Platform.Anchored = true
Platform.CanCollide = true
Platform.Transparency = 1 -- Ẩn hoàn toàn

local currentTween = nil

local function TweenTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local dist = (hrp.Position - targetCFrame.Position).Magnitude

    if dist <= 10 then
        if currentTween then currentTween:Cancel(); currentTween = nil end
        hrp.CFrame = targetCFrame
        return
    end

    if dist > 350 then
        hrp.CFrame = targetCFrame
    else
        local speed = 300
        if not currentTween or currentTween.PlaybackState ~= Enum.PlaybackState.Playing then
            if currentTween then currentTween:Cancel() end
            currentTween = TweenService:Create(hrp, TweenInfo.new(dist / speed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
            currentTween:Play()
        end
    end
end

-- NOCLIP VÀ ĐẶT PLATFORM
RunService.Stepped:Connect(function()
    pcall(function()
        if _G.AutoFarm and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                
                -- Đặt thảm đỡ chân ngay dưới Player
                Platform.CFrame = hrp.CFrame * CFrame.new(0, -3.5, 0)
            end
        else
            Platform.CFrame = CFrame.new(0, 99999, 0)
        end
    end)
end)

-- =========================================================
-- LÕI FAST ATTACK NATIVE (CHÉM KHÔNG VUNG TAY)
-- =========================================================
local function GetActiveController()
    local success, result = pcall(function()
        local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
        if CbFw.activeController then return CbFw.activeController end
        local getupvals = debug.getupvalues or getupvalues
        if getupvals then
            for _, v in pairs(getupvals(CbFw)) do
                if type(v) == "table" and v.activeController then return v.activeController end
            end
        end
        return nil
    end)
    return success and result or nil
end

task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoFarm and _G.FastAttack then
            pcall(function()
                local ac = GetActiveController()
                if ac and ac.equipped then
                    ac.hitboxLimiter = 0
                    ac.timeToNextAttack = 0
                    ac.timeToNextBlock = 0
                    ac.increment = 3
                    ac:attack()
                end
                
                -- CLICK CHUỘT ẢO ÉP SÁT THƯƠNG
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(50, 50))
            end)
        end
    end
end)

-- =========================================================
-- LOGIC TÌM NHIỆM VỤ VÀ GOM QUÁI LÊN TRỜI
-- =========================================================
local function GetQuestData()
    local lvl = 1
    pcall(function() lvl = LocalPlayer.Data.Level.Value end)
    if lvl <= 9 then return "BanditQuest1", 1, "Bandit"
    elseif lvl <= 14 then return "JungleQuest", 1, "Monkey"
    elseif lvl <= 29 then return "JungleQuest", 2, "Gorilla"
    elseif lvl <= 39 then return "BuggyQuest1", 1, "Pirate"
    elseif lvl <= 59 then return "BuggyQuest1", 2, "Brute"
    elseif lvl <= 74 then return "DesertQuest", 1, "Desert Bandit"
    elseif lvl <= 89 then return "DesertQuest", 2, "Desert Officer"
    elseif lvl <= 99 then return "SnowQuest", 1, "Snow Bandit"
    elseif lvl <= 119 then return "SnowQuest", 2, "Snowman"
    elseif lvl <= 149 then return "MarineQuest2", 1, "Chief Petty Officer"
    else return "BanditQuest1", 1, "Bandit" end
end

local function HasQuest()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    return pGui and pGui:FindFirstChild("Main") and pGui.Main:FindFirstChild("Quest") and pGui.Main.Quest.Visible or false
end

local function GetClosestMob(monName)
    local closest, dist = nil, math.huge
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not Workspace:FindFirstChild("Enemies") then return nil end
    
    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
        if mob.Name == monName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local eHrp = mob:FindFirstChild("HumanoidRootPart")
            if eHrp then
                local d = (hrp.Position - eHrp.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = mob
                end
            end
        end
    end
    return closest
end

-- VÒNG LẶP CHÍNH
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if _G.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local qName, qLevel, mobName = GetQuestData()
                StatusLabel.Text = string.format("Trạng thái: Đang tàn sát %s", mobName)

                -- Nhận nhiệm vụ
                if _G.AutoQuest and not HasQuest() and CommF then
                    CommF:InvokeServer("StartQuest", qName, qLevel)
                    task.wait(0.5)
                end

                -- Tìm quái
                local targetMob = GetClosestMob(mobName)
                local targetCFrame = nil

                if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                    -- BẠN: LƠ LỬNG TRÊN KHÔNG CÁCH GỐC QUÁI 30 MÉT
                    targetCFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                elseif IslandPositions[mobName] then
                    targetCFrame = IslandPositions[mobName] * CFrame.new(0, 30, 0)
                end

                if targetCFrame then
                    -- LUÔN QUAY MẶT XUỐNG
                    targetCFrame = CFrame.lookAt(targetCFrame.Position, targetCFrame.Position - Vector3.new(0, 10, 0))
                    TweenTo(targetCFrame)

                    local myHrp = LocalPlayer.Character.HumanoidRootPart
                    if (myHrp.Position - targetCFrame.Position).Magnitude <= 15 and _G.BringMob then
                        -- KÉO TOÀN BỘ QUÁI LÊN ĐỈNH ĐẦU BẠN
                        for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                            if mob.Name == mobName then
                                local eHrp = mob:FindFirstChild("HumanoidRootPart")
                                local eHum = mob:FindFirstChild("Humanoid")
                                if eHrp and eHum and eHum.Health > 0 then
                                    -- Kéo quái đến cách mũi kiếm 5 mét
                                    eHrp.CFrame = myHrp.CFrame * CFrame.new(0, 0, -5)
                                    -- Phóng to Hitbox cực đại để auto chém trúng
                                    eHrp.Size = Vector3.new(60, 60, 60)
                                    eHrp.CanCollide = false
                                    
                                    -- Tắt vật lý quái
                                    eHum.WalkSpeed = 0
                                    eHum.JumpPower = 0
                                    eHum:ChangeState(11) -- StrafingNoPhysics
                                    
                                    -- Đóng băng quái trên không bằng BodyVelocity
                                    eHrp.AssemblyLinearVelocity = Vector3.zero
                                    local bv = eHrp:FindFirstChild("AntiFall")
                                    if not bv then
                                        bv = Instance.new("BodyVelocity", eHrp)
                                        bv.Name = "AntiFall"
                                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                        bv.Velocity = Vector3.zero
                                    end
                                end
                            end
                        end
                    end
                end
            else
                if currentTween then currentTween:Cancel(); currentTween = nil end
            end
        end)
    end
end)
