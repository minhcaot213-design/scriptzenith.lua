-- [[ ZYROX VN x REDZ V5 (THE PERFECTION) ]] --
-- Dùng 100% Redz UI (Tuyệt đối không đen màn hình).
-- Cự ly vàng 10 Mét. Sát thương nổ 100%.

task.wait(0.1)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local Plr = Players.LocalPlayer

local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

pcall(function() for i,v in pairs(getconnections(Plr.Idled)) do v:Disable() end end)
Plr.Idled:Connect(function() pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end)

-- =========================================================
-- KHỞI TẠO REDZ HUB (GIAO DIỆN XỊN 100%)
-- =========================================================
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Library-ui/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = redzlib:MakeWindow({
    Title = "ZYROX VN : REDZ EDITION",
    SubTitle = "Bypass Core - No Damage Loss",
    SaveFolder = "ZyroxConfig"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://15298567397", BackgroundTransparency = 0 },
    Size = UDim2.new(0, 35, 0, 35),
    Corner = { CornerRadius = UDim.new(0.25, 0) },
})

local TabFarm = Window:MakeTab({"Farm", "home"})
local TabStats = Window:MakeTab({"Stats", "Signal"})
local TabESP = Window:MakeTab({"Visual", "user"})

-- =========================================================
-- BIẾN TOÀN CỤC & TÍNH NĂNG
-- =========================================================
_G.AutoFarm = false
_G.AutoQuest = true
_G.BringMob = true
_G.FastAttack = true
_G.SelectWeapon = "Melee"

_G.ESPPlayer = false
_G.ESPMob = false
_G.ESPChest = false
_G.AutoStats = false

local StartBring = false
local PosMon = nil
local MonFarm = ""

TabFarm:AddDropdown({
    Name = "Select Weapon",
    Options = {"Melee", "Sword", "Gun", "Fruit"},
    Default = "Melee",
    Callback = function(v) _G.SelectWeapon = v end
})

TabFarm:AddToggle({
    Name = "⚡ Auto Farm Level",
    Default = false,
    Callback = function(v) 
        _G.AutoFarm = v 
        if not v then
            local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("BodyClip") then hrp.BodyClip:Destroy() end
        end
    end
})

TabFarm:AddToggle({Name = "📜 Tự Nhận Nhiệm Vụ", Default = true, Callback = function(v) _G.AutoQuest = v end})
TabFarm:AddToggle({Name = "🧲 Kéo Quái (Bring Mob)", Default = true, Callback = function(v) _G.BringMob = v end})
TabFarm:AddToggle({Name = "⚔️ Fast Attack", Default = true, Callback = function(v) _G.FastAttack = v end})

-- =========================================================
-- LOGIC BẢN ĐỒ & NHIỆM VỤ
-- =========================================================
local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715

local function GetQuest()
    local lvl = Plr.Data.Level.Value
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
    else
        return "Area1Quest", 1, "Raider", CFrame.new(-429, 71, 1836) -- Placeholder cho Sea 2/3
    end
end

-- =========================================================
-- ĐỘNG CƠ DI CHUYỂN TWEEN & BYPASS TP
-- =========================================================
local function BTP(target)
    pcall(function()
        Plr.Character.HumanoidRootPart.CFrame = target
        task.wait(0.05)
        if Plr.Character:FindFirstChild("Head") then Plr.Character.Head:Destroy() end
        Plr.Character.HumanoidRootPart.CFrame = target
    end)
end

local function topos(target)
    local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not hrp:FindFirstChild("BodyClip") then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "BodyClip"; bv.MaxForce = Vector3.new(100000, 100000, 100000); bv.Velocity = Vector3.zero
    end
    for _,v in pairs(Plr.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    
    local dist = (hrp.Position - target.Position).Magnitude
    if dist > 1500 then
        BTP(target)
    else
        TweenService:Create(hrp, TweenInfo.new(dist / 300, Enum.EasingStyle.Linear), {CFrame = target}):Play()
    end
end

local function EquipWeapon()
    pcall(function()
        if not Plr.Character:FindFirstChild("HasBuso") and CommF then CommF:InvokeServer("Buso") end
        local curr = Plr.Character:FindFirstChildOfClass("Tool")
        if curr and (string.find(curr.ToolTip, _G.SelectWeapon) or curr.Name == "Combat" or curr.Name == "Võ Tân Binh") then return end
        for _, t in ipairs(Plr.Backpack:GetChildren()) do
            if string.find(t.ToolTip, _G.SelectWeapon) or t.Name == "Combat" or t.Name == "Võ Tân Binh" then
                Plr.Character.Humanoid:EquipTool(t); break
            end
        end
    end)
end

-- =========================================================
-- VÒNG LẶP AUTO FARM (CỰ LY 10 MÉT ĐỂ 100% CÓ DAME)
-- =========================================================
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local qName, qLvl, mobName, qPos = GetQuest()
                local pGui = Plr.PlayerGui
                if not pGui.Main.Quest.Visible then
                    StartBring = false
                    if (Plr.Character.HumanoidRootPart.Position - qPos.Position).Magnitude > 20 then
                        topos(qPos)
                    elseif _G.AutoQuest then
                        CommF:InvokeServer("StartQuest", qName, qLvl)
                    end
                else
                    if not string.find(pGui.Main.Quest.Container.QuestTitle.Title.Text, mobName) then
                        StartBring = false; CommF:InvokeServer("AbandonQuest")
                        return
                    end
                    
                    local targetMob = nil
                    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                        if mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            targetMob = mob; break
                        end
                    end
                    
                    if targetMob then
                        EquipWeapon()
                        PosMon = targetMob.HumanoidRootPart.CFrame
                        -- BAY CAO ĐÚNG 10 MÉT: AN TOÀN NHƯNG VẪN KHÍT TẦM TAY ĐỂ NỔ DAME
                        topos(PosMon * CFrame.new(0, 10, 0))
                        
                        if (Plr.Character.HumanoidRootPart.Position - (PosMon * CFrame.new(0, 10, 0)).Position).Magnitude <= 15 then
                            StartBring = true
                            MonFarm = mobName
                            -- Xoay mặt xuống
                            Plr.Character.HumanoidRootPart.CFrame = CFrame.lookAt(Plr.Character.HumanoidRootPart.Position, PosMon.Position)
                        end
                    else
                        StartBring = false; topos(qPos)
                    end
                end
            end)
        end
    end
end)

-- BRING MOB
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm and _G.BringMob and StartBring and PosMon then
            pcall(function()
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob.Name == MonFarm and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        local dist = (mob.HumanoidRootPart.Position - PosMon.Position).Magnitude
                        if dist <= 350 then
                            -- GOM QUÁI XUỐNG DƯỚI ĐẤT & PHÓNG TO HITBOX LÊN 50
                            mob.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            mob.HumanoidRootPart.CFrame = PosMon
                            mob.HumanoidRootPart.CanCollide = false
                            if mob:FindFirstChild("Head") then mob.Head.CanCollide = false end
                            
                            mob.Humanoid.WalkSpeed = 0
                            mob.Humanoid.JumpPower = 0
                            mob.Humanoid.Sit = true
                            if mob.Humanoid:FindFirstChild("Animator") then mob.Humanoid.Animator:Destroy() end
                            mob.Humanoid:ChangeState(11)
                            sethiddenproperty(Plr, "SimulationRadius", math.huge)
                        end
                    end
                end
            end)
        end
    end
end)

-- =========================================================
-- LÕI FAST ATTACK COMBAT HOOK
-- =========================================================
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoFarm and _G.FastAttack then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(1280, 672))
                
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
                    ac.hitboxLimiter = math.huge
                    ac.timeToNextAttack = 0
                    ac.timeToNextBlock = 0
                    ac.increment = 3
                    ac.attacking = false
                    ac:attack()
                end
            end)
        end
    end
end)

RunService.Stepped:Connect(function()
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

-- =========================================================
-- STATS TAB
-- =========================================================
TabStats:AddToggle({ Name = "Auto Stats", Default = false, Callback = function(v) _G.AutoStats = v end })
TabStats:AddToggle({ Name = "Melee", Default = false, Callback = function(v) _G.Stats.Melee = v end })
TabStats:AddToggle({ Name = "Defense", Default = false, Callback = function(v) _G.Stats.Defense = v end })
TabStats:AddToggle({ Name = "Sword", Default = false, Callback = function(v) _G.Stats.Sword = v end })
TabStats:AddToggle({ Name = "Blox Fruit", Default = false, Callback = function(v) _G.Stats.BloxFruit = v end })

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoStats then
            pcall(function()
                local points = Plr.Data.Points.Value
                if points > 0 then
                    for s, st in pairs(_G.Stats) do 
                        if st then CommF:InvokeServer("AddPoint", s, 1) end 
                    end
                end
            end)
        end
    end
end)

-- =========================================================
-- ESP TAB (NATIVE VẼ LÊN ĐẦU)
-- =========================================================
TabESP:AddToggle({ Name = "ESP Players", Default = false, Callback = function(v) _G.ESPPlayer = v end })
TabESP:AddToggle({ Name = "ESP Chests", Default = false, Callback = function(v) _G.ESPChest = v end })

task.spawn(function()
    while task.wait(1) do
        if _G.ESPPlayer then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= Plr and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") then
                    local head = p.Character.Head
                    if not head:FindFirstChild("Z_ESP") then
                        local gui = Instance.new("BillboardGui", head); gui.Name = "Z_ESP"; gui.Size = UDim2.new(0, 200, 0, 40); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 3, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextSize = 14; txt.TextColor3 = Color3.fromRGB(0,255,0); txt.Font = Enum.Font.GothamBold; txt.TextStrokeTransparency = 0
                    end
                    local dist = math.floor((head.Position - Plr.Character.HumanoidRootPart.Position).Magnitude)
                    head.Z_ESP.TextLabel.Text = p.Name .. " [" .. dist .. "m]"
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
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextSize = 14; txt.TextColor3 = Color3.fromRGB(255, 215, 0); txt.Font = Enum.Font.GothamBold; txt.TextStrokeTransparency = 0
                    end
                    local dist = math.floor((chest:GetPivot().Position - Plr.Character.HumanoidRootPart.Position).Magnitude)
                    chest.Z_ESP.TextLabel.Text = "Chest [" .. dist .. "m]"
                elseif chest:FindFirstChild("Z_ESP") then chest.Z_ESP:Destroy() end
            end
        else
            for _, chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
                if chest:FindFirstChild("Z_ESP") then chest.Z_ESP:Destroy() end
            end
        end
    end
end)
