-- [[ ZYROX VN x REDZ V5 (THE TRUE HYBRID) ]] --
-- Đã vá lỗi UI Đen màn hình. Sử dụng 100% thư viện gốc.
-- Tích hợp hệ thống Teleport Bypass & Fast Attack Logic từ file gốc.

task.wait(0.5)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Plr = Players.LocalPlayer

-- CHỐNG AFK CRASH
pcall(function()
    for i,v in pairs(getconnections(Plr.Idled)) do v:Disable() end
end)
Plr.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- XÁC ĐỊNH SEA (WORLD)
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
    World1 = true
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    World2 = true
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
    World3 = true
end

-- GLOBAL VARIABLES
_G.SelectWeapon = "Melee"
_G.AutoFarm = false
_G.AutoAttack = true
_G.StopTween = false

local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon
local StartBring = false
local PosMon = nil
local MonFarm = ""

-- =========================================================
-- LOGIC TELEPORT & BYPASS (TỪ SCRIPT GỐC CỦA BẠN)
-- =========================================================
function WaitHRP(player)
    if player then return player.Character:WaitForChild("HumanoidRootPart", 9) else return nil end
end

function CheckNearestTeleporter(pos)
    local minMag = math.huge
    local targetTP = nil
    local teleporters = {}

    if World3 then
        teleporters = {
            ["Floating Turtle"] = Vector3.new(-12462, 375, -7552),
            ["Hydra Island"] = Vector3.new(5657.88, 1013.07, -335.49),
            ["Mansion"] = Vector3.new(-12462, 375, -7552),
            ["Castle"] = Vector3.new(-5036, 315, -3179)
        }
    elseif World2 then
        teleporters = {
            ["Swan Mansion"] = Vector3.new(-390, 332, 673),
            ["Cursed Ship"] = Vector3.new(923, 126, 32852),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    else
        teleporters = {
            ["Sky3"] = Vector3.new(-7894, 5547, -380),
            ["UnderWater"] = Vector3.new(61163, 11, 1819)
        }
    end

    for _, v in pairs(teleporters) do
        local mag = (v - pos.Position).Magnitude
        if mag < minMag then minMag = mag; targetTP = v end
    end

    if minMag <= (pos.Position - Plr.Character.HumanoidRootPart.Position).Magnitude then
        return targetTP
    else return nil end
end

function requestEntrance(pos)
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", pos)
        Plr.Character.HumanoidRootPart.CFrame = Plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 50, 0)
        task.wait(0.5)
    end)
end

function topos(targetCFrame)
    if not Plr.Character or Plr.Character.Humanoid.Health <= 0 or not Plr.Character:FindFirstChild("HumanoidRootPart") then return end
    if not targetCFrame then return end
    
    local dist = (targetCFrame.Position - Plr.Character.HumanoidRootPart.Position).Magnitude
    local nearestTP = CheckNearestTeleporter(targetCFrame)
    if nearestTP then requestEntrance(nearestTP) end
    
    if dist < 300 then
        Plr.Character.HumanoidRootPart.CFrame = targetCFrame
    else
        local tweenInfo = TweenInfo.new(dist / 300, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(Plr.Character.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        
        -- Chống kẹt & Tàng hình
        if not Plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "BodyClip"
            bv.Parent = Plr.Character.HumanoidRootPart
            bv.MaxForce = Vector3.new(100000, 100000, 100000)
            bv.Velocity = Vector3.new(0, 0, 0)
        end
        for _, part in ipairs(Plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end

function StopTween(state)
    if not state then
        _G.StopTween = true
        task.wait()
        if Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            topos(Plr.Character.HumanoidRootPart.CFrame)
            if Plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                Plr.Character.HumanoidRootPart.BodyClip:Destroy()
            end
        end
        _G.StopTween = false
    end
end

-- =========================================================
-- LOGIC QUEST (RÚT GỌN ĐỂ TỐI ƯU VÒNG LẶP)
-- =========================================================
function CheckQuest()
    local MyLevel = Plr.Data.Level.Value
    if World1 then
        if MyLevel <= 9 then Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"; CFrameQuest = CFrame.new(1059, 15, 1550); CFrameMon = CFrame.new(1045, 27, 1560)
        elseif MyLevel <= 14 then Mon = "Monkey"; LevelQuest = 1; NameQuest = "JungleQuest"; NameMon = "Monkey"; CFrameQuest = CFrame.new(-1598, 35, 153); CFrameMon = CFrame.new(-1448, 67, 11)
        elseif MyLevel <= 29 then Mon = "Gorilla"; LevelQuest = 2; NameQuest = "JungleQuest"; NameMon = "Gorilla"; CFrameQuest = CFrame.new(-1598, 35, 153); CFrameMon = CFrame.new(-1129, 40, -525)
        elseif MyLevel <= 39 then Mon = "Pirate"; LevelQuest = 1; NameQuest = "BuggyQuest1"; NameMon = "Pirate"; CFrameQuest = CFrame.new(-1141, 4, 3831); CFrameMon = CFrame.new(-1103, 13, 3896)
        elseif MyLevel <= 59 then Mon = "Brute"; LevelQuest = 2; NameQuest = "BuggyQuest1"; NameMon = "Brute"; CFrameQuest = CFrame.new(-1141, 4, 3831); CFrameMon = CFrame.new(-1140, 14, 4322)
        elseif MyLevel <= 74 then Mon = "Desert Bandit"; LevelQuest = 1; NameQuest = "DesertQuest"; NameMon = "Desert Bandit"; CFrameQuest = CFrame.new(894, 5, 4392); CFrameMon = CFrame.new(924, 6, 4481)
        elseif MyLevel <= 89 then Mon = "Desert Officer"; LevelQuest = 2; NameQuest = "DesertQuest"; NameMon = "Desert Officer"; CFrameQuest = CFrame.new(894, 5, 4392); CFrameMon = CFrame.new(1608, 8, 4371)
        elseif MyLevel <= 99 then Mon = "Snow Bandit"; LevelQuest = 1; NameQuest = "SnowQuest"; NameMon = "Snow Bandit"; CFrameQuest = CFrame.new(1389, 88, -1298); CFrameMon = CFrame.new(1354, 87, -1393)
        elseif MyLevel <= 119 then Mon = "Snowman"; LevelQuest = 2; NameQuest = "SnowQuest"; NameMon = "Snowman"; CFrameQuest = CFrame.new(1389, 88, -1298); CFrameMon = CFrame.new(1201, 144, -1550)
        elseif MyLevel <= 149 then Mon = "Chief Petty Officer"; LevelQuest = 1; NameQuest = "MarineQuest2"; NameMon = "Chief Petty Officer"; CFrameQuest = CFrame.new(-5039, 27, 4324); CFrameMon = CFrame.new(-4881, 22, 4273)
        elseif MyLevel <= 174 then Mon = "Sky Bandit"; LevelQuest = 1; NameQuest = "SkyQuest"; NameMon = "Sky Bandit"; CFrameQuest = CFrame.new(-4839, 716, -2619); CFrameMon = CFrame.new(-4953, 295, -2899)
        elseif MyLevel <= 189 then Mon = "Dark Master"; LevelQuest = 2; NameQuest = "SkyQuest"; NameMon = "Dark Master"; CFrameQuest = CFrame.new(-4839, 716, -2619); CFrameMon = CFrame.new(-5259, 391, -2229)
        elseif MyLevel <= 209 then Mon = "Prisoner"; LevelQuest = 1; NameQuest = "PrisonerQuest"; NameMon = "Prisoner"; CFrameQuest = CFrame.new(5308, 1, 475); CFrameMon = CFrame.new(5098, -0, 474)
        else Mon = "Peanut Scout"; LevelQuest = 1; NameQuest = "PeanutQuest"; NameMon = "Peanut Scout"; CFrameQuest = CFrame.new(-2104, 38, -10194); CFrameMon = CFrame.new(-2143, 47, -10029) end
    elseif World2 then
        if MyLevel <= 724 then Mon = "Raider"; LevelQuest = 1; NameQuest = "Area1Quest"; NameMon = "Raider"; CFrameQuest = CFrame.new(-429, 71, 1836); CFrameMon = CFrame.new(-728, 52, 2345)
        elseif MyLevel <= 774 then Mon = "Mercenary"; LevelQuest = 2; NameQuest = "Area1Quest"; NameMon = "Mercenary"; CFrameQuest = CFrame.new(-429, 71, 1836); CFrameMon = CFrame.new(-1004, 80, 1424)
        else Mon = "Swan Pirate"; LevelQuest = 1; NameQuest = "Area2Quest"; NameMon = "Swan Pirate"; CFrameQuest = CFrame.new(638, 71, 918); CFrameMon = CFrame.new(1068, 137, 1322) end
    elseif World3 then
        if MyLevel <= 1524 then Mon = "Pirate Millionaire"; LevelQuest = 1; NameQuest = "PiratePortQuest"; NameMon = "Pirate Millionaire"; CFrameQuest = CFrame.new(-450, 107, 5950); CFrameMon = CFrame.new(-245, 47, 5584)
        else Mon = "Dragon Crew Warrior"; LevelQuest = 1; NameQuest = "DragonCrewQuest"; NameMon = "Dragon Crew Warrior"; CFrameQuest = CFrame.new(6750, 127, -711); CFrameMon = CFrame.new(6709, 52, -1139) end
    end
end

function EquipWeapon(weaponName)
    if not weaponName then return end
    local backpack = Plr:WaitForChild("Backpack")
    local tool = backpack:FindFirstChild(weaponName)
    if tool then Plr.Character.Humanoid:EquipTool(tool) end
end

function AutoHaki()
    if Plr.Character and not Plr.Character:FindFirstChild("HasBuso") and CommF then
        CommF:InvokeServer("Buso")
    end
end

-- =========================================================
-- KHỞI TẠO REDZ UI LIB (HÀNG XỊN TỪ GITHUB)
-- =========================================================
local vu32 = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Library-ui/refs/heads/main/redz-V5-remake/main.luau"))()
local v466 = vu32:MakeWindow({
    Title = "ZYROX VN : Redz Hub Hybrid",
    SubTitle = "Skidded & Fixed by Zyrox",
    SaveFolder = "Zyrox_Redz_V36"
})

v466:AddMinimizeButton({
    Button = { Image = "rbxassetid://15298567397", BackgroundTransparency = 0 },
    Size = UDim2.new(0, 35, 0, 35),
    Corner = { CornerRadius = UDim.new(0.25, 0) },
})

local tabFarm = v466:MakeTab({"Farm", "home"})
local tabStats = v466:MakeTab({"Stats", "Signal"})
local tabESP = v466:MakeTab({"Visual", "user"})

-- =========================================================
-- FARM TAB
-- =========================================================
tabFarm:AddDropdown({
    Name = "Select Tool",
    Description = "Choose the tool you want to use",
    Options = {"Melee", "Sword", "Gun", "Blox Fruit"},
    Default = "Melee",
    Flag = "WeaponType",
    Callback = function(v)
        task.spawn(function()
            for _, t in pairs(Plr.Backpack:GetChildren()) do
                if v == "Melee" and t.ToolTip == "Melee" then _G.SelectWeapon = t.Name
                elseif v == "Sword" and t.ToolTip == "Sword" then _G.SelectWeapon = t.Name
                elseif v == "Gun" and t.ToolTip == "Gun" then _G.SelectWeapon = t.Name
                elseif (v == "Fruit" or v == "Blox Fruit") and t.ToolTip == "Blox Fruit" then _G.SelectWeapon = t.Name end
            end
        end)
    end
})

tabFarm:AddToggle({
    Name = "Auto Farm Level (Redz Logic)",
    Description = "Tự nhận Quest & Gom quái mặt đất",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
        StopTween(_G.AutoFarm)
    end
})

tabFarm:AddToggle({
    Name = "Fast Attack (Combat Hook)",
    Description = "Chém không vung tay",
    Default = true,
    Callback = function(state)
        _G.AutoAttack = state
    end
})

-- VÒNG LẶP FARM CHÍNH
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                local questText = Plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                
                if Plr.PlayerGui.Main.Quest.Visible == false then
                    StartBring = false
                    if (Plr.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 20 then
                        topos(CFrameQuest)
                    else
                        CommF:InvokeServer("StartQuest", NameQuest, LevelQuest)
                    end
                elseif not string.find(questText, NameMon) then
                    StartBring = false
                    CommF:InvokeServer("AbandonQuest")
                else
                    -- TÌM VÀ GOM QUÁI
                    local foundMob = false
                    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                        if mob.Name == Mon and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            foundMob = true
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                
                                PosMon = mob.HumanoidRootPart.CFrame
                                -- ĐỨNG TRÊN CAO 30 MÉT
                                topos(mob.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                
                                mob.HumanoidRootPart.CanCollide = false
                                mob.Head.CanCollide = false
                                mob.Humanoid.WalkSpeed = 0
                                mob.Humanoid.JumpPower = 0
                                -- ÉP HITBOX 70 (CHUẨN REDZ)
                                mob.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                
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

-- BRING MOB LOGIC
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoFarm and StartBring and PosMon then
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob.Name == MonFarm and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        local dist = (mob.HumanoidRootPart.Position - Plr.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= 320 then
                            mob.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                            mob.HumanoidRootPart.CFrame = PosMon
                            mob.HumanoidRootPart.CanCollide = false
                            mob.Head.CanCollide = false
                            if mob.Humanoid:FindFirstChild("Animator") then mob.Humanoid.Animator:Destroy() end
                            sethiddenproperty(Plr, "SimulationRadius", math.huge)
                        end
                    end
                end
            end
        end)
    end
end)

-- FAST ATTACK LÕI
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoAttack and _G.AutoFarm then
            pcall(function()
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
                    ac.attacking = false
                    ac.blocking = false
                    ac:attack()
                end
            end)
        end
    end
end)

-- =========================================================
-- STATS TAB
-- =========================================================
tabStats:AddToggle({ Name = "Auto Stats", Default = false, Callback = function(v) _G.AutoStats = v end })
tabStats:AddSlider({ Name = "Points Amount", Min = 1, Max = 500, Default = 1, Callback = function(v) _G.StatsPoint = v end })
tabStats:AddToggle({ Name = "Melee", Default = false, Callback = function(v) _G.StatsSelect.Melee = v end })
tabStats:AddToggle({ Name = "Defense", Default = false, Callback = function(v) _G.StatsSelect.Defense = v end })
tabStats:AddToggle({ Name = "Sword", Default = false, Callback = function(v) _G.StatsSelect.Sword = v end })
tabStats:AddToggle({ Name = "Blox Fruit", Default = false, Callback = function(v) _G.StatsSelect.BloxFruit = v end })

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

-- =========================================================
-- ESP TAB (BILLBOARD NATIVE TỪ SCRIPT GỐC)
-- =========================================================
tabESP:AddToggle({ Name = "ESP Players", Default = false, Callback = function(v) _G.ESPPlayer = v end })
tabESP:AddToggle({ Name = "ESP Chests", Default = false, Callback = function(v) _G.ESPChest = v end })
tabESP:AddToggle({ Name = "ESP Fruits", Default = false, Callback = function(v) _G.ESPFruit = v end })

task.spawn(function()
    while task.wait(1) do
        -- ESP Player
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Plr then
                pcall(function()
                    if _G.ESPPlayer and p.Character and p.Character:FindFirstChild("Head") then
                        local head = p.Character.Head
                        if not head:FindFirstChild("RedzESP") then
                            local bg = Instance.new("BillboardGui", head); bg.Name = "RedzESP"; bg.Size = UDim2.new(0, 200, 0, 50); bg.AlwaysOnTop = true; bg.StudsOffset = Vector3.new(0, 3, 0)
                            local tl = Instance.new("TextLabel", bg); tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency = 1; tl.TextScaled = true; tl.TextColor3 = Color3.new(1,0,0); tl.Font = Enum.Font.SourceSansBold
                        end
                        local dist = math.floor((head.Position - Plr.Character.HumanoidRootPart.Position).Magnitude)
                        head.RedzESP.TextLabel.Text = p.Name .. " [" .. dist .. "m]"
                    elseif p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("RedzESP") then
                        p.Character.Head.RedzESP:Destroy()
                    end
                end)
            end
        end

        -- ESP Chest
        for _, chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
            pcall(function()
                if _G.ESPChest and not chest:GetAttribute("IsDisabled") then
                    if not chest:FindFirstChild("RedzESP") then
                        local bg = Instance.new("BillboardGui", chest); bg.Name = "RedzESP"; bg.Size = UDim2.new(0, 200, 0, 50); bg.AlwaysOnTop = true; bg.StudsOffset = Vector3.new(0, 2, 0)
                        local tl = Instance.new("TextLabel", bg); tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency = 1; tl.TextScaled = true; tl.TextColor3 = Color3.fromRGB(255, 215, 0); tl.Font = Enum.Font.SourceSansBold
                    end
                    local dist = math.floor((chest:GetPivot().Position - Plr.Character.HumanoidRootPart.Position).Magnitude)
                    chest.RedzESP.TextLabel.Text = "Chest [" .. dist .. "m]"
                elseif chest:FindFirstChild("RedzESP") then
                    chest.RedzESP:Destroy()
                end
            end)
        end
    end
end)
