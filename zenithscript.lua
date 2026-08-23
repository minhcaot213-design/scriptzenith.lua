-- [[ ZYROX VN x REDZ V5 (THE TRUE STANDALONE) ]] --
-- Fix 100% Đen màn hình. Cự ly 8 Mét. Gom quái mặt đất. 

task.wait(0.1)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local Plr = Players.LocalPlayer

-- CHỐNG VĂNG GAME
pcall(function() for i,v in pairs(getconnections(Plr.Idled)) do v:Disable() end end)
Plr.Idled:Connect(function() pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end) end)

local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
_G.AutoFarm = false; _G.SelectWeapon = "Melee"; _G.BringMob = true; _G.FastAttack = true
local lockedFarmPosition = nil; local MonFarm = ""

-- =========================================================
-- KHỞI TẠO UI REDZ V5 (LOAD TRỰC TIẾP, KHÔNG ĐEN MÀN)
-- =========================================================
local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Library-ui/refs/heads/main/redz-V5-remake/main.luau"))()
local Window = RedzLib:MakeWindow({
    Title = "ZYROX VN : REDZ PREMIUM",
    SubTitle = "Cự Ly Vàng 8 Mét + Hitbox Khổng Lồ",
    SaveFolder = "Zyrox_V38"
})
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://15298567397", BackgroundTransparency = 0 },
    Size = UDim2.new(0, 35, 0, 35)
})

local TabFarm = Window:MakeTab({"Farm", "home"})
TabFarm:AddDropdown({
    Name = "Chọn Vũ Khí (Select Weapon)",
    Options = {"Melee", "Sword", "Blox Fruit"},
    Default = "Melee",
    Callback = function(v) _G.SelectWeapon = v end
})
TabFarm:AddToggle({
    Name = "Bật Auto Farm Level",
    Default = false,
    Callback = function(v) _G.AutoFarm = v end
})
TabFarm:AddToggle({
    Name = "Gom Quái Mặt Đất (Bring Mob)",
    Default = true,
    Callback = function(v) _G.BringMob = v end
})
TabFarm:AddToggle({
    Name = "Chém Siêu Tốc (Fast Attack)",
    Default = true,
    Callback = function(v) _G.FastAttack = v end
})

-- =========================================================
-- LOGIC BẢN ĐỒ & NHIỆM VỤ (ĐÃ BAO GỒM GORILLA CỦA BẠN)
-- =========================================================
local function GetQuest()
    local lvl = Plr.Data.Level.Value
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
    else return "BanditQuest1", 1, "Bandit", CFrame.new(1059, 15, 1550) end -- Tạm gọn Sea 1
end

-- =========================================================
-- HỆ THỐNG DI CHUYỂN TWEEN MƯỢT + BYPASS TELEPORT
-- =========================================================
local function topos(targetCFrame)
    local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not hrp:FindFirstChild("ZyroxBV") then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "ZyroxBV"
        bv.MaxForce = Vector3.new(100000, 100000, 100000)
        bv.Velocity = Vector3.zero
    end

    for _, v in pairs(Plr.Character:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end

    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    if dist > 1500 then
        -- BYPASS DỊCH CHUYỂN TỨC THỜI
        hrp.CFrame = targetCFrame
        task.wait(0.1)
        if Plr.Character:FindFirstChild("Head") then Plr.Character.Head:Destroy() end
        hrp.CFrame = targetCFrame
    else
        TweenService:Create(hrp, TweenInfo.new(dist / 300, Enum.EasingStyle.Linear), {CFrame = targetCFrame}):Play()
    end
end

-- Đổi vũ khí + Haki
local function EquipTool()
    if Plr.Character and not Plr.Character:FindFirstChild("HasBuso") then CommF:InvokeServer("Buso") end
    local backpack = Plr:FindFirstChild("Backpack")
    if not backpack then return end
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and (string.find(tool.ToolTip, _G.SelectWeapon) or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then
            Plr.Character.Humanoid:EquipTool(tool)
            break
        end
    end
end

-- =========================================================
-- VÒNG LẶP FARM CHÍNH
-- =========================================================
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local qName, qLevel, mobName, qPos = GetQuest()
                local pGui = Plr.PlayerGui
                
                -- 1. Tự nhận Quest
                if pGui.Main.Quest.Visible == false then
                    lockedFarmPosition = nil
                    if (Plr.Character.HumanoidRootPart.Position - qPos.Position).Magnitude > 20 then
                        topos(qPos)
                    else
                        CommF:InvokeServer("StartQuest", qName, qLevel)
                    end
                else
                    -- 2. Đánh Quái
                    local targetMob = nil
                    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                        if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            targetMob = mob
                            break
                        end
                    end

                    if targetMob then
                        EquipTool()
                        if not lockedFarmPosition then lockedFarmPosition = targetMob.HumanoidRootPart.CFrame end
                        
                        -- CỰ LY VÀNG: ĐỨNG TRÊN ĐẦU QUÁI ĐÚNG 8 MÉT (100% TRÚNG ĐÒN)
                        topos(lockedFarmPosition * CFrame.new(0, 8, 0))
                        
                        local hrp = Plr.Character.HumanoidRootPart
                        if (hrp.Position - (lockedFarmPosition * CFrame.new(0, 8, 0)).Position).Magnitude <= 10 then
                            MonFarm = mobName
                            if _G.BringMob then
                                for _, m in pairs(Workspace.Enemies:GetChildren()) do
                                    if m.Name == mobName and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then
                                        -- GOM QUÁI CHẶT DƯỚI MẶT ĐẤT, PHÓNG TO HITBOX 60
                                        m.HumanoidRootPart.CFrame = lockedFarmPosition
                                        m.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        m.HumanoidRootPart.CanCollide = false
                                        m.Humanoid.WalkSpeed = 0
                                        m.Humanoid.JumpPower = 0
                                        if m.Humanoid:FindFirstChild("Animator") then m.Humanoid.Animator:Destroy() end
                                        m.Humanoid:ChangeState(11)
                                        sethiddenproperty(Plr, "SimulationRadius", math.huge)
                                    end
                                end
                            end
                        end
                    else
                        lockedFarmPosition = nil
                        topos(qPos) -- Quay về chỗ nhận quest nếu hết quái
                    end
                end
            end)
        else
            lockedFarmPosition = nil
        end
    end
end)

-- =========================================================
-- LÕI FAST ATTACK + COMBAT HOOK (CỰC MẠNH)
-- =========================================================
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoFarm and _G.FastAttack then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(50, 50))
                
                local CbFw = require(Plr.PlayerScripts.CombatFramework)
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
game:GetService("RunService").Stepped:Connect(function()
    pcall(function()
        if _G.AutoFarm and Plr.Character then
            local hum = Plr.Character:FindFirstChild("Humanoid")
            if hum and hum:FindFirstChild("Animator") then
                for _, anim in ipairs(hum.Animator:GetPlayingAnimationTracks()) do
                    if anim.Name:lower():match("attack") or anim.Name:lower():match("slash") then anim:Stop() end
                end
            end
        end
    end)
end)
