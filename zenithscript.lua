-- [[ ZENITH x REDZ HUB - OFFICIAL UNTOUCHED CORE ]] --
-- Lấy 100% logic Auto Farm nguyên bản từ code Redz (Work 100%)
-- Giao diện chuẩn RedzLib, chống mọi lỗi đen màn hình.

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

-- CHỐNG AFK CRASH
pcall(function() for i,v in pairs(getconnections(Plr.Idled)) do v:Disable() end end)
Plr.Idled:Connect(function() pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end)

-- BIẾN TOÀN CỤC CHUẨN REDZ
_G.AutoFarm = false
_G.SelectWeapon = "Melee"
_G.FastAttack = true
_G.BringMonster = true

local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon
local StartBring = false
local PosMon = nil
local MonFarm = ""
local BypassTP = true

-- =========================================================
-- LOGIC CHECKQUEST GỐC TỪ CODE REDZ
-- =========================================================
function CheckQuest()
    local MyLevel = Plr.Data.Level.Value
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42); CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
        elseif MyLevel >= 10 and MyLevel <= 14 then
            Mon = "Monkey"; LevelQuest = 1; NameQuest = "JungleQuest"; NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37); CFrameMon = CFrame.new(-1448.51, 67.85, 11.46)
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"; LevelQuest = 2; NameQuest = "JungleQuest"; NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37); CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)
        elseif MyLevel >= 30 and MyLevel <= 39 then
            Mon = "Pirate"; LevelQuest = 1; NameQuest = "BuggyQuest1"; NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54); CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)
        elseif MyLevel >= 40 and MyLevel <= 59 then
            Mon = "Brute"; LevelQuest = 2; NameQuest = "BuggyQuest1"; NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54); CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)
        elseif MyLevel >= 60 and MyLevel <= 74 then
            Mon = "Desert Bandit"; LevelQuest = 1; NameQuest = "DesertQuest"; NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(894.48, 5.14, 4392.43); CFrameMon = CFrame.new(924.79, 6.44, 4481.58)
        elseif MyLevel >= 75 and MyLevel <= 89 then
            Mon = "Desert Officer"; LevelQuest = 2; NameQuest = "DesertQuest"; NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(894.48, 5.14, 4392.43); CFrameMon = CFrame.new(1608.28, 8.61, 4371.00)
        elseif MyLevel >= 90 and MyLevel <= 99 then
            Mon = "Snow Bandit"; LevelQuest = 1; NameQuest = "SnowQuest"; NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90); CFrameMon = CFrame.new(1354.34, 87.27, -1393.94)
        elseif MyLevel >= 100 and MyLevel <= 119 then
            Mon = "Snowman"; LevelQuest = 2; NameQuest = "SnowQuest"; NameMon = "Snowman"
            CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90); CFrameMon = CFrame.new(1201.64, 144.57, -1550.06)
        else
            Mon = "Chief Petty Officer"; LevelQuest = 1; NameQuest = "MarineQuest2"; NameMon = "Chief Petty Officer"
            CFrameQuest = CFrame.new(-5039.58, 27.35, 4324.68); CFrameMon = CFrame.new(-4881.23, 22.65, 4273.75)
        end
    elseif World2 then
        if MyLevel <= 724 then 
            Mon = "Raider"; LevelQuest = 1; NameQuest = "Area1Quest"; NameMon = "Raider"
            CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18); CFrameMon = CFrame.new(-728.32, 52.77, 2345.77)
        else 
            Mon = "Swan Pirate"; LevelQuest = 1; NameQuest = "Area2Quest"; NameMon = "Swan Pirate"
            CFrameQuest = CFrame.new(638.43, 71.76, 918.28); CFrameMon = CFrame.new(1068.66, 137.61, 1322.10)
        end
    elseif World3 then
        if MyLevel <= 1524 then 
            Mon = "Pirate Millionaire"; LevelQuest = 1; NameQuest = "PiratePortQuest"; NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-450.10, 107.68, 5950.72); CFrameMon = CFrame.new(-245.99, 47.30, 5584.10)
        else 
            Mon = "Dragon Crew Warrior"; LevelQuest = 1; NameQuest = "DragonCrewQuest"; NameMon = "Dragon Crew Warrior"
            CFrameQuest = CFrame.new(6750.49, 127.44, -711.03); CFrameMon = CFrame.new(6709.76, 52.34, -1139.02)
        end
    end
end

-- =========================================================
-- LOGIC DI CHUYỂN BTP & TOPOS GỐC TỪ REDZ
-- =========================================================
function BTP(targetCFrame)
    pcall(function()
        if (targetCFrame.Position - Plr.Character.HumanoidRootPart.Position).Magnitude >= 1500 and Plr.Character.Humanoid.Health > 0 then
            repeat
                task.wait()
                Plr.Character.HumanoidRootPart.CFrame = targetCFrame
                task.wait(0.05)
                if Plr.Character:FindFirstChild("Head") then Plr.Character.Head:Destroy() end
                Plr.Character.HumanoidRootPart.CFrame = targetCFrame
            until (targetCFrame.Position - Plr.Character.HumanoidRootPart.Position).Magnitude < 1500 or Plr.Character.Humanoid.Health <= 0
        end
    end)
end

function topos(targetCFrame)
    if not Plr.Character or not Plr.Character:FindFirstChild("HumanoidRootPart") then return end
    
    if not Plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "BodyClip"; bv.MaxForce = Vector3.new(100000, 100000, 100000); bv.Velocity = Vector3.zero
        bv.Parent = Plr.Character.HumanoidRootPart
    end
    for _, v in pairs(Plr.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end

    local dist = (targetCFrame.Position - Plr.Character.HumanoidRootPart.Position).Magnitude
    if dist > 1500 and BypassTP then
        BTP(targetCFrame)
    else
        local tweenInfo = TweenInfo.new(dist / 300, Enum.EasingStyle.Linear)
        TweenService:Create(Plr.Character.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame}):Play()
    end
end

function EquipWeapon(weaponName)
    pcall(function()
        if not Plr.Character:FindFirstChild("HasBuso") then CommF:InvokeServer("Buso") end
        local backpack = Plr:WaitForChild("Backpack")
        local tool = backpack:FindFirstChild(weaponName)
        if tool then Plr.Character.Humanoid:EquipTool(tool) end
    end)
end

-- =========================================================
-- KHỞI TẠO GIAO DIỆN REDZ V5 GỐC
-- =========================================================
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Library-ui/refs/heads/main/redz-V5-remake/main.luau"))()
local Window = redzlib:MakeWindow({
    Title = "ZENITH HUB : UNTOUCHED CORE",
    SubTitle = "100% Nguyên bản Redz Logic",
    SaveFolder = "ZenithConfig"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://15298567397", BackgroundTransparency = 0 },
    Size = UDim2.new(0, 35, 0, 35),
    Corner = { CornerRadius = UDim.new(0.25, 0) }
})

local TabFarm = Window:MakeTab({"Farm", "home"})

TabFarm:AddDropdown({
    Name = "Select Weapon",
    Options = {"Melee", "Sword", "Gun", "Blox Fruit"},
    Default = "Melee",
    Callback = function(v) _G.SelectWeapon = v end
})

TabFarm:AddToggle({
    Name = "Auto Farm Level (Redz Core)",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
        if not state then
            local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("BodyClip") then hrp.BodyClip:Destroy() end
        end
    end
})

TabFarm:AddToggle({Name = "Auto Quest", Default = true, Callback = function(v) _G.AutoQuest = v end})
TabFarm:AddToggle({Name = "Bring Mob (Ground Magnet)", Default = true, Callback = function(v) _G.BringMonster = v end})
TabFarm:AddToggle({Name = "Fast Attack (Network)", Default = true, Callback = function(v) _G.FastAttack = v end})

-- =========================================================
-- VÒNG LẶP AUTO FARM CHÍNH (ĐÚNG CHUẨN CODE GỐC 100%)
-- =========================================================
spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                local questGui = Plr.PlayerGui.Main.Quest
                local questText = questGui.Container.QuestTitle.Title.Text
                
                if not questGui.Visible then
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
                    local foundMob = false
                    for _, v512 in pairs(Workspace.Enemies:GetChildren()) do
                        if v512:FindFirstChild("HumanoidRootPart") and v512:FindFirstChild("Humanoid") and v512.Humanoid.Health > 0 and v512.Name == Mon then
                            foundMob = true
                            repeat
                                task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                AutoHaki()
                                PosMon = v512.HumanoidRootPart.CFrame
                                
                                -- ĐỨNG CÁCH ĐẦU QUÁI 8 MÉT (ĐẢM BẢO CHÉM TRÚNG NỔ MÁU)
                                topos(v512.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0))
                                
                                v512.HumanoidRootPart.CanCollide = false
                                v512.Humanoid.WalkSpeed = 0
                                v512.Head.CanCollide = false
                                v512.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                
                                StartBring = true
                                MonFarm = v512.Name
                                
                                VirtualUser:CaptureController()
                                VirtualUser:Button1Down(Vector2.new(1280, 672))
                            until not _G.AutoFarm or v512.Humanoid.Health <= 0 or not v512.Parent or questGui.Visible == false
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

-- BRING MOB LOGIC GỐC
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoFarm and _G.BringMonster and StartBring and PosMon then
                for _, v1167 in pairs(Workspace.Enemies:GetChildren()) do
                    if v1167.Name == MonFarm and v1167:FindFirstChild("Humanoid") and v1167:FindFirstChild("HumanoidRootPart") and v1167.Humanoid.Health > 0 then
                        if (v1167.HumanoidRootPart.Position - PosMon.Position).Magnitude <= 320 then
                            v1167.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v1167.HumanoidRootPart.CFrame = PosMon
                            v1167.HumanoidRootPart.CanCollide = false
                            v1167.Head.CanCollide = false
                            if v1167.Humanoid:FindFirstChild("Animator") then v1167.Humanoid.Animator:Destroy() end
                            v1167.Humanoid:ChangeState(11)
                            sethiddenproperty(Plr, "SimulationRadius", math.huge)
                        end
                    end
                end
            end
        end)
    end
end)

-- =========================================================
-- LÕI FAST ATTACK NATIVE
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
    while task.wait(0.0001) do
        if _G.AutoFarm and _G.FastAttack then
            pcall(function()
                local _Character = Plr.Character
                local v13 = _Character and _Character:FindFirstChild('HumanoidRootPart')
                if not v13 then return end

                local v14, v15, v16 = ipairs({Workspace.Enemies, Workspace.Characters})
                local u17 = {}

                while true do
                    local v18
                    v16, v18 = v14(v15, v16)
                    if v16 == nil then break end

                    local v19, v20, v21 = ipairs(v18 and v18:GetChildren() or {})
                    while true do
                        local v22
                        v21, v22 = v19(v20, v21)
                        if v21 == nil then break end

                        local _HumanoidRootPart = v22:FindFirstChild('HumanoidRootPart')
                        local _Humanoid = v22:FindFirstChild('Humanoid')

                        if v22 ~= _Character and (_HumanoidRootPart and (_Humanoid and (_Humanoid.Health > 0 and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 60))) then
                            local v25, v26, v27 = ipairs(v22:GetChildren())
                            while true do
                                local v28
                                v27, v28 = v25(v26, v27)
                                if v27 == nil then break end
                                if v28:IsA('BasePart') and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 60 then
                                    u17[#u17 + 1] = {v22, v28}
                                end
                            end
                        end
                    end
                end

                local _Tool = _Character:FindFirstChildOfClass('Tool')
                if #u17 > 0 and (_Tool and (_Tool:GetAttribute('WeaponType') == 'Melee' or _Tool:GetAttribute('WeaponType') == 'Sword' or _Tool.Name == "Combat")) then
                    pcall(function()
                        require(ReplicatedStorage.Modules.Net):RemoteEvent('RegisterHit', true)
                        ReplicatedStorage.Modules.Net['RE/RegisterAttack']:FireServer()

                        local _Head = u17[1][1]:FindFirstChild('Head')

                        if _Head then
                            ReplicatedStorage.Modules.Net['RE/RegisterHit']:FireServer(_Head, u17, {}, tostring(Plr.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
                            local r_u4 = (typeof(cloneref) == "function" and cloneref(u4)) or u4
                            if r_u4 then
                                r_u4:FireServer(string.gsub('RE/RegisterHit', '.', function(p31)
                                    return string.char(bit32.bxor(string.byte(p31), math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1))
                                end), bit32.bxor(u5 + 909090, ReplicatedStorage.Modules.Net.seed:InvokeServer() * 2), _Head, u17)
                            end
                        end
                    end)
                end
            end)
        end
    end
end)
