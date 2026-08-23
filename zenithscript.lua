-- [[ ZYROX VN x REDZ V5 (THE TRUE EXECUTOR) ]] --
-- ĐÃ KHÔI PHỤC 100% LOGIC GỐC: NETWORK BYPASS, BTP, HITBOX 60, REDZ UI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Plr = Players.LocalPlayer

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- =========================================================
-- ANTI AFK & AUTO JOIN TEAM
-- =========================================================
pcall(function()
    for i,v in pairs(getconnections(Plr.Idled)) do v:Disable() end
end)
Plr.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

local function JoinTeam()
    if not Plr.Team or (Plr.Team.Name ~= "Marines" and Plr.Team.Name ~= "Pirates") then
        pcall(function()
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", "Pirates")
        end)
    end
end
JoinTeam()

-- =========================================================
-- WORLD DETECTION
-- =========================================================
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then World1 = true
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then World2 = true
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then World3 = true end

-- =========================================================
-- GLOBAL VARIABLES
-- =========================================================
_G.AutoFarm = false
_G.SelectWeapon = "Melee"
_G.StopTween = false
_G.FastAttack = true
_G.BringMonster = true
_G.ESPPlayer = false
_G.ESPFruit = false
_G.ESPChest = false
_G.WhiteScreen = false
local StartBring = false
local PosMon = nil
local MonFarm = ""
local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon
local BypassTP = true

-- =========================================================
-- QUEST LOGIC (TỪ SCRIPT REDZ GỐC)
-- =========================================================
function CheckQuest()
    local MyLevel = Plr.Data.Level.Value
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231)
            CFrameMon = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
        elseif MyLevel >= 10 and MyLevel <= 14 then
            Mon = "Monkey"; LevelQuest = 1; NameQuest = "JungleQuest"; NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            CFrameMon = CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209)
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"; LevelQuest = 2; NameQuest = "JungleQuest"; NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            CFrameMon = CFrame.new(-1129.8836669921875, 40.46354675292969, -525.4237060546875)
        elseif MyLevel >= 30 and MyLevel <= 39 then
            Mon = "Pirate"; LevelQuest = 1; NameQuest = "BuggyQuest1"; NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498)
            CFrameMon = CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125)
        elseif MyLevel >= 40 and MyLevel <= 59 then
            Mon = "Brute"; LevelQuest = 2; NameQuest = "BuggyQuest1"; NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498)
            CFrameMon = CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875)
        elseif MyLevel >= 60 and MyLevel <= 74 then
            Mon = "Desert Bandit"; LevelQuest = 1; NameQuest = "DesertQuest"; NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359)
            CFrameMon = CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375)
        elseif MyLevel >= 75 and MyLevel <= 89 then
            Mon = "Desert Officer"; LevelQuest = 2; NameQuest = "DesertQuest"; NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359)
            CFrameMon = CFrame.new(1608.2822265625, 8.614224433898926, 4371.00732421875)
        elseif MyLevel >= 90 and MyLevel <= 99 then
            Mon = "Snow Bandit"; LevelQuest = 1; NameQuest = "SnowQuest"; NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796)
            CFrameMon = CFrame.new(1354.347900390625, 87.27277374267578, -1393.946533203125)
        elseif MyLevel >= 100 and MyLevel <= 119 then
            Mon = "Snowman"; LevelQuest = 2; NameQuest = "SnowQuest"; NameMon = "Snowman"
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796)
            CFrameMon = CFrame.new(1201.6412353515625, 144.57958984375, -1550.0670166015625)
        else
            Mon = "Chief Petty Officer"; LevelQuest = 1; NameQuest = "MarineQuest2"; NameMon = "Chief Petty Officer"
            CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018)
            CFrameMon = CFrame.new(-4881.23095703125, 22.65204429626465, 4273.75244140625)
        end
    elseif World2 then
        if MyLevel <= 724 then 
            Mon = "Raider"; LevelQuest = 1; NameQuest = "Area1Quest"; NameMon = "Raider"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188)
            CFrameMon = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125)
        elseif MyLevel <= 774 then 
            Mon = "Mercenary"; LevelQuest = 2; NameQuest = "Area1Quest"; NameMon = "Mercenary"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188)
            CFrameMon = CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625)
        else 
            Mon = "Swan Pirate"; LevelQuest = 1; NameQuest = "Area2Quest"; NameMon = "Swan Pirate"
            CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898)
            CFrameMon = CFrame.new(1068.664306640625, 137.61428833007812, 1322.1060791015625) 
        end
    elseif World3 then
        if MyLevel <= 1524 then 
            Mon = "Pirate Millionaire"; LevelQuest = 1; NameQuest = "PiratePortQuest"; NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-450.104645, 107.681458, 5950.72607)
            CFrameMon = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375)
        else 
            Mon = "Dragon Crew Warrior"; LevelQuest = 1; NameQuest = "DragonCrewQuest"; NameMon = "Dragon Crew Warrior"
            CFrameQuest = CFrame.new(6750.4931640625, 127.44916534423828, -711.0308837890625)
            CFrameMon = CFrame.new(6709.76367, 52.3442993, -1139.02966) 
        end
    end
end

-- =========================================================
-- ĐỘNG CƠ DI CHUYỂN, BTP & TWEEN (TỪ SCRIPT GỐC)
-- =========================================================
function BTP(v430)
    pcall(function()
        if (v430.Position - Plr.Character.HumanoidRootPart.Position).Magnitude >= 1500 and Plr.Character.Humanoid.Health > 0 then
            repeat
                wait()
                Plr.Character.HumanoidRootPart.CFrame = v430
                wait(0.05)
                Plr.Character.Head:Destroy()
                Plr.Character.HumanoidRootPart.CFrame = v430
            until (v430.Position - Plr.Character.HumanoidRootPart.Position).Magnitude < 1500 and Plr.Character.Humanoid.Health > 0
        end
    end)
end

function topos(targetCFrame)
    if not Plr.Character or not Plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local dist = (targetCFrame.Position - Plr.Character.HumanoidRootPart.Position).Magnitude
    
    -- Chống kẹt vật lý
    if not Plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "BodyClip"
        bv.Parent = Plr.Character.HumanoidRootPart
        bv.MaxForce = Vector3.new(100000, 100000, 100000)
        bv.Velocity = Vector3.new(0, 0, 0)
    end
    for _, v in pairs(Plr.Character:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end
    
    if dist > 1500 and BypassTP then
        BTP(targetCFrame)
    else
        local tweenInfo = TweenInfo.new(dist / 300, Enum.EasingStyle.Linear)
        game:GetService("TweenService"):Create(Plr.Character.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame}):Play()
    end
end

function StopTween(state)
    if not state then
        _G.StopTween = true
        wait()
        if Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            topos(Plr.Character.HumanoidRootPart.CFrame)
            if Plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                Plr.Character.HumanoidRootPart.BodyClip:Destroy()
            end
        end
        _G.StopTween = false
    end
end

function EquipWeapon(weaponName)
    if not weaponName then return end
    local backpack = Plr:WaitForChild("Backpack")
    local tool = backpack:FindFirstChild(weaponName)
    if tool then Plr.Character.Humanoid:EquipTool(tool) end
end

function AutoHaki()
    if Plr.Character and not Plr.Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

-- =========================================================
-- KHỞI TẠO REDZ UI LIBRARY V5 (GIAO DIỆN HACK VIP)
-- =========================================================
local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Library-ui/refs/heads/main/redz-V5-remake/main.luau"))()
local Window = RedzLib:MakeWindow({
    Title = "ZYROX VN : REDZ PREMIUM",
    SubTitle = "Bypass Network Edition",
    SaveFolder = "Zyrox_Redz_V36"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://15298567397", BackgroundTransparency = 0 },
    Size = UDim2.new(0, 35, 0, 35),
    Corner = { CornerRadius = UDim.new(0.25, 0) },
})

local TabFarm = Window:MakeTab({"Farm", "home"})
local TabStats = Window:MakeTab({"Stats", "Signal"})
local TabESP = Window:MakeTab({"Visuals", "user"})
local TabMisc = Window:MakeTab({"Misc", "settings"})

-- =========================================================
-- TAB: FARM
-- =========================================================
TabFarm:AddDropdown({
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

TabFarm:AddToggle({
    Name = "Auto Farm Level",
    Description = "Tự động nhận Quest và cày cấp (Chuẩn Redz)",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
        StopTween(_G.AutoFarm)
    end
})

TabFarm:AddToggle({
    Name = "Fast Attack (Network Bypass)",
    Description = "Chém không cần vung tay, không delay",
    Default = true,
    Callback = function(state)
        _G.FastAttack = state
    end
})

TabFarm:AddToggle({
    Name = "Bring Mob (Gom Quái)",
    Description = "Hút quái lên không trung, gom 1 cục",
    Default = true,
    Callback = function(state)
        _G.BringMonster = state
    end
})

-- =========================================================
-- VÒNG LẶP AUTO FARM CHÍNH
-- =========================================================
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
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                    end
                elseif not string.find(questText, NameMon) then
                    StartBring = false
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                else
                    -- ĐI TÌM QUÁI VẬT
                    local found = false
                    for _, v in pairs(Workspace.Enemies:GetChildren()) do
                        if v.Name == Mon and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            found = true
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                
                                PosMon = v.HumanoidRootPart.CFrame
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                
                                StartBring = true
                                MonFarm = v.Name
                                
                                VirtualUser:CaptureController()
                                VirtualUser:Button1Down(Vector2.new(1280, 672))
                            until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or Plr.PlayerGui.Main.Quest.Visible == false
                        end
                    end
                    if not found then
                        StartBring = false
                        topos(CFrameMon)
                    end
                end
            end)
        end
    end
end)

-- LOGIC HÚT QUÁI (BRING MOB)
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.BringMonster and StartBring and PosMon then
                for _, v in pairs(Workspace.Enemies:GetChildren()) do
                    if v.Name == MonFarm and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        if (v.HumanoidRootPart.Position - Plr.Character.HumanoidRootPart.Position).Magnitude <= 320 then
                            v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v.HumanoidRootPart.CFrame = PosMon
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
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
-- LÕI FAST ATTACK NETWORK (BẢN GỐC TỪ SOURCE REDZ)
-- =========================================================
local v1 = next
local v2 = {ReplicatedStorage.Util, ReplicatedStorage.Common, ReplicatedStorage.Remotes, ReplicatedStorage.Assets, ReplicatedStorage.FX}
local v3, u4, u5 = nil, nil, nil

task.spawn(function()
    while true do
        local v6
        v3, v6 = v1(v2, v3)
        if v3 == nil then break end
        local v7 = next
        local v8, v9 = v6:GetChildren()
        while true do
            local v10
            v9, v10 = v7(v8, v9)
            if v9 == nil then break end
            if v10:IsA('RemoteEvent') and v10:GetAttribute('Id') then
                u5 = v10:GetAttribute('Id')
                u4 = v10
            end
        end
        v6.ChildAdded:Connect(function(p11)
            if p11:IsA('RemoteEvent') and p11:GetAttribute('Id') then
                u5 = p11:GetAttribute('Id')
                u4 = p11
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.001) do
        if _G.AutoFarm and _G.FastAttack then
            pcall(function()
                local char = Plr.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local targets = {}
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        if (mob.HumanoidRootPart.Position - hrp.Position).Magnitude <= 60 then
                            for _, part in ipairs(mob:GetChildren()) do
                                if part:IsA("BasePart") then
                                    table.insert(targets, {mob, part})
                                end
                            end
                        end
                    end
                end

                local tool = char:FindFirstChildOfClass("Tool")
                if #targets > 0 and tool and (tool:GetAttribute("WeaponType") == "Melee" or tool:GetAttribute("WeaponType") == "Sword" or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then
                    require(game.ReplicatedStorage.Modules.Net):RemoteEvent("RegisterHit", true)
                    game.ReplicatedStorage.Modules.Net["RE/RegisterAttack"]:FireServer()

                    local head = targets[1][1]:FindFirstChild("Head")
                    if head and u4 and u5 then
                        game.ReplicatedStorage.Modules.Net["RE/RegisterHit"]:FireServer(head, targets, {}, tostring(Plr.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
                        u4:FireServer(string.gsub("RE/RegisterHit", ".", function(c)
                            return string.char(bit32.bxor(string.byte(c), math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1))
                        end), bit32.bxor(u5 + 909090, game.ReplicatedStorage.Modules.Net.seed:InvokeServer() * 2), head, targets)
                    end
                end
            end)
        end
    end
end)

-- =========================================================
-- TAB: STATS
-- =========================================================
TabStats:AddToggle({ Name = "Auto Stats", Default = false, Callback = function(v) _G.AutoStats = v end })
TabStats:AddSlider({ Name = "Points per Tick", Min = 1, Max = 100, Default = 1, Callback = function(v) _G.StatsPoint = v end })
TabStats:AddToggle({ Name = "Melee", Default = false, Callback = function(v) _G.StatsSelect.Melee = v end })
TabStats:AddToggle({ Name = "Defense", Default = false, Callback = function(v) _G.StatsSelect.Defense = v end })
TabStats:AddToggle({ Name = "Sword", Default = false, Callback = function(v) _G.StatsSelect.Sword = v end })
TabStats:AddToggle({ Name = "Blox Fruit", Default = false, Callback = function(v) _G.StatsSelect.BloxFruit = v end })

task.spawn(function()
    while task.wait(0.4) do
        if _G.AutoStats then
            pcall(function()
                local statsFolder = Plr:FindFirstChild("Data")
                if not statsFolder then return end
                local points = statsFolder:FindFirstChild("Points")
                if not points or points.Value <= 0 then return end
                
                local EnabledStats = {}
                for stat, enabled in pairs(_G.StatsSelect) do
                    if enabled then table.insert(EnabledStats, stat) end
                end
                
                if #EnabledStats > 0 then
                    local amountEach = math.floor(_G.StatsPoint / #EnabledStats)
                    if amountEach < 1 then amountEach = 1 end
                    for _, stat in ipairs(EnabledStats) do
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", stat, amountEach, false)
                    end
                end
            end)
        end
    end
end)

-- =========================================================
-- TAB: ESP NATIVE
-- =========================================================
TabESP:AddToggle({ Name = "ESP Players", Default = false, Callback = function(v) _G.ESPPlayer = v end })
TabESP:AddToggle({ Name = "ESP Chests", Default = false, Callback = function(v) _G.ESPChest = v end })
TabESP:AddToggle({ Name = "ESP Fruits", Default = false, Callback = function(v) _G.ESPFruit = v end })

task.spawn(function()
    while task.wait(1) do
        -- ESP PLAYER
        if _G.ESPPlayer then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= Plr and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") then
                    local head = p.Character.Head
                    if not head:FindFirstChild("PlayerESP") then
                        local gui = Instance.new("BillboardGui", head); gui.Name = "PlayerESP"; gui.Size = UDim2.new(0, 200, 0, 50); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 3, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextScaled = true; txt.TextColor3 = Color3.new(1,0,0); txt.Font = Enum.Font.SourceSansBold
                    end
                    local dist = math.floor((head.Position - Plr.Character.HumanoidRootPart.Position).Magnitude)
                    head.PlayerESP.TextLabel.Text = p.Name .. " [" .. dist .. "m]\nHP: " .. math.floor(p.Character.Humanoid.Health)
                end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("PlayerESP") then p.Character.Head.PlayerESP:Destroy() end
            end
        end

        -- ESP CHEST
        if _G.ESPChest then
            for _, chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
                if not chest:GetAttribute("IsDisabled") then
                    if not chest:FindFirstChild("ChestESP") then
                        local gui = Instance.new("BillboardGui", chest); gui.Name = "ChestESP"; gui.Size = UDim2.new(0, 200, 0, 50); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 2, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextScaled = true; txt.TextColor3 = Color3.fromRGB(255, 215, 0); txt.Font = Enum.Font.SourceSansBold
                    end
                    local dist = math.floor((chest:GetPivot().Position - Plr.Character.HumanoidRootPart.Position).Magnitude)
                    chest.ChestESP.TextLabel.Text = "Chest [" .. dist .. "m]"
                elseif chest:FindFirstChild("ChestESP") then
                    chest.ChestESP:Destroy()
                end
            end
        else
            for _, chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
                if chest:FindFirstChild("ChestESP") then chest.ChestESP:Destroy() end
            end
        end
    end
end)

-- =========================================================
-- TAB: MISC
-- =========================================================
TabMisc:AddToggle({
    Name = "White Screen",
    Default = false,
    Callback = function(v)
        _G.WhiteScreen = v
        RunService:Set3dRenderingEnabled(not v)
    end
})

TabMisc:AddButton({
    Title = "Redeem All Codes",
    Callback = function()
        local codes = {"ADMINHACKED", "ADMINDARES", "SECRET_ADMIN", "NOOB2PRO", "StrawHatMaine", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "THEGREATACE", "SUB2GAMERROBOT_EXP1"}
        task.spawn(function() for _, c in ipairs(codes) do pcall(function() ReplicatedStorage.Remotes.Redeem:InvokeServer(c) end); task.wait(0.1) end end)
    end
})

TabMisc:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, Plr)
    end
})
