-- [[ ZYROX VN x REDZ HUB (V37 STANDALONE) ]] --
-- Đã fix triệt để lỗi Đen màn hình.
-- Lõi Farm Tối Ưu: Bypass TP, Gom Quái Đất, Hitbox 60, Combat Hook.

task.wait(0.1)
if not game:IsLoaded() then game.Loaded:Wait() end

-- =========================================================
-- KHỞI TẠO SERVICES
-- =========================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local Plr = Players.LocalPlayer
local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

-- CHỐNG VĂNG GAME AFK
pcall(function()
    for i,v in pairs(getconnections(Plr.Idled)) do v:Disable() end
end)
Plr.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- BIẾN TOÀN CỤC
_G.AutoFarm = false
_G.SelectWeapon = "Melee"
_G.BringMob = true
_G.FastAttack = true
_G.AutoStats = false
_G.StatsPoint = 1
_G.StatsSelect = {Melee = false, Defense = false, Sword = false, BloxFruit = false}

local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon
local StartBring = false
local PosMon = nil
local MonFarm = ""

-- =========================================================
-- LOGIC BẢN ĐỒ & NHIỆM VỤ
-- =========================================================
local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

local function CheckQuest()
    local MyLevel = Plr.Data.Level.Value
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
-- DI CHUYỂN, TWEEN VÀ BTP (BYPASS TELEPORT)
-- =========================================================
local currentTween = nil
local function BTP(targetCFrame)
    pcall(function()
        if (targetCFrame.Position - Plr.Character.HumanoidRootPart.Position).Magnitude >= 1500 then
            Plr.Character.HumanoidRootPart.CFrame = targetCFrame
            task.wait(0.05)
            Plr.Character.Head:Destroy()
            Plr.Character.HumanoidRootPart.CFrame = targetCFrame
        end
    end)
end

local function topos(targetCFrame)
    local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Bật NoClip chống kẹt
    if not hrp:FindFirstChild("BodyClip") then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "BodyClip"; bv.MaxForce = Vector3.new(100000, 100000, 100000); bv.Velocity = Vector3.new(0, 0, 0)
    end
    for _, part in ipairs(Plr.Character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    if dist > 1500 then
        BTP(targetCFrame)
    else
        local tweenInfo = TweenInfo.new(dist / 300, Enum.EasingStyle.Linear)
        if currentTween then currentTween:Cancel() end
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        currentTween:Play()
    end
end

local function EquipWeapon(weaponType)
    pcall(function()
        local backpack = Plr:FindFirstChild("Backpack")
        local char = Plr.Character
        if not backpack or not char then return end
        
        local cTool = char:FindFirstChildOfClass("Tool")
        if cTool and (string.find(cTool.ToolTip, weaponType) or cTool.Name == "Combat" or cTool.Name == "Võ Tân Binh") then return end
        
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (string.find(tool.ToolTip, weaponType) or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then
                char.Humanoid:EquipTool(tool)
                break
            end
        end
    end)
end

local function AutoHaki()
    if Plr.Character and not Plr.Character:FindFirstChild("HasBuso") and CommF then
        CommF:InvokeServer("Buso")
    end
end

-- =========================================================
-- KHỞI TẠO GIAO DIỆN REDZ HUB V5 GỐC (BẢO ĐẢM KHÔNG ĐEN MÀN)
-- =========================================================
local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Library-ui/refs/heads/main/redz-V5-remake/main.luau"))()
local Window = RedzLib:MakeWindow({
    Title = "ZYROX VN : REDZ PREMIUM",
    SubTitle = "Skidded & Fixed by Zyrox",
    SaveFolder = "Zyrox_V37_Config"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://15298567397", BackgroundTransparency = 0 },
    Size = UDim2.new(0, 35, 0, 35),
    Corner = { CornerRadius = UDim.new(0.25, 0) },
})

local TabFarm = Window:MakeTab({"Farm", "home"})
local TabStats = Window:MakeTab({"Stats", "Signal"})
local TabMisc = Window:MakeTab({"Misc", "settings"})

-- UI TAB FARM
TabFarm:AddDropdown({
    Name = "Select Weapon",
    Options = {"Melee", "Sword", "Gun", "Blox Fruit"},
    Default = "Melee",
    Callback = function(v) _G.SelectWeapon = v end
})

TabFarm:AddToggle({
    Name = "Auto Farm Level",
    Default = false,
    Callback = function(v) 
        _G.AutoFarm = v 
        if not v and currentTween then currentTween:Cancel() end
    end
})

TabFarm:AddToggle({
    Name = "Bring Mob (Gom quái siêu mượt)",
    Default = true,
    Callback = function(v) _G.BringMonster = v end
})

TabFarm:AddToggle({
    Name = "Fast Attack (Không vung tay)",
    Default = true,
    Callback = function(v) _G.FastAttack = v end
})

-- UI TAB STATS
TabStats:AddToggle({ Name = "Auto Stats", Default = false, Callback = function(v) _G.AutoStats = v end })
TabStats:AddSlider({ Name = "Points Amount", Min = 1, Max = 100, Default = 1, Callback = function(v) _G.StatsPoint = v end })
TabStats:AddToggle({ Name = "Melee", Default = false, Callback = function(v) _G.StatsSelect.Melee = v end })
TabStats:AddToggle({ Name = "Defense", Default = false, Callback = function(v) _G.StatsSelect.Defense = v end })
TabStats:AddToggle({ Name = "Sword", Default = false, Callback = function(v) _G.StatsSelect.Sword = v end })
TabStats:AddToggle({ Name = "Blox Fruit", Default = false, Callback = function(v) _G.StatsSelect.BloxFruit = v end })

-- =========================================================
-- VÒNG LẶP AUTO FARM CHÍNH
-- =========================================================
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                local questTitle = Plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                
                if Plr.PlayerGui.Main.Quest.Visible == false then
                    StartBring = false
                    if (Plr.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 15 then
                        topos(CFrameQuest)
                    else
                        CommF:InvokeServer("StartQuest", NameQuest, LevelQuest)
                    end
                elseif not string.find(questTitle, NameMon) then
                    StartBring = false
                    CommF:InvokeServer("AbandonQuest")
                else
                    local foundMob = false
                    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                        if mob.Name == Mon and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            foundMob = true
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                
                                PosMon = mob.HumanoidRootPart.CFrame
                                -- ĐỨNG TRÊN ĐẦU QUÁI 8 MÉT (ĐỦ GẦN ĐỂ CHÉM TRÚNG, ĐỦ CAO ĐỂ BẤT TỬ)
                                topos(mob.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0))
                                
                                mob.HumanoidRootPart.CanCollide = false
                                mob.Head.CanCollide = false
                                mob.Humanoid.WalkSpeed = 0
                                mob.Humanoid.JumpPower = 0
                                mob.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                
                                StartBring = true
                                MonFarm = mob.Name
                                
                                VirtualUser:CaptureController()
                                VirtualUser:Button1Down(Vector2.new(1280, 672))
                            until not _G.AutoFarm or mob.Humanoid.Health <= 0 or not mob.Parent or Plr.PlayerGui.Main.Quest.Visible == false
                        end
                    end
                    if not foundMob then
                        StartBring = false
                        topos(CFrameMon)
                    end
                end
            end)
        end
    end
end)

-- =========================================================
-- VÒNG LẶP HÚT QUÁI (BRING MOB)
-- =========================================================
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.BringMonster and StartBring and PosMon then
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob.Name == MonFarm and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        if (mob.HumanoidRootPart.Position - PosMon.Position).Magnitude <= 320 then
                            mob.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            mob.HumanoidRootPart.CFrame = PosMon
                            mob.HumanoidRootPart.CanCollide = false
                            mob.Head.CanCollide = false
                            if mob.Humanoid:FindFirstChild("Animator") then
                                mob.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(Plr, "SimulationRadius", math.huge)
                        end
                    end
                end
            end
        end)
    end
end)

-- =========================================================
-- VÒNG LẶP FAST ATTACK & COMBAT HOOK
-- =========================================================
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoFarm and _G.FastAttack then
            pcall(function()
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
        if _G.AutoFarm and Plr.Character then
            local hum = Plr.Character:FindFirstChild("Humanoid")
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
-- VÒNG LẶP AUTO STATS
-- =========================================================
task.spawn(function()
    while task.wait(0.4) do
        if _G.AutoStats then
            pcall(function()
                local points = Plr.Data.Points.Value
                if points > 0 then
                    local enabled = {}
                    for stat, state in pairs(_G.StatsSelect) do
                        if state then table.insert(enabled, stat) end
                    end
                    if #enabled > 0 then
                        local pts = math.floor(_G.StatsPoint / #enabled)
                        if pts < 1 then pts = 1 end
                        for _, stat in ipairs(enabled) do CommF:InvokeServer("AddPoint", stat, pts) end
                    end
                end
            end)
        end
    end
end)
