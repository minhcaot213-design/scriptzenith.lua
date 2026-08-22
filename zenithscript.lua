-- [[ ZENITH BLOX FRUIT - V12.1 (PRO FAST ATTACK & BRIGHT UI FIX) ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local Camera = Workspace.CurrentCamera

-- ===================================================
-- 0. DỌN DẸP INSTANCE CŨ (CLEANUP & SAFE GUI)
-- ===================================================
local UI_NAME = "ZenithBloxFruit_Zyrox_V12"
local function getSafeParent()
    if gethui then return gethui() end
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then return coreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local parentGui = getSafeParent()
if parentGui:FindFirstChild(UI_NAME) then parentGui[UI_NAME]:Destroy() end
if Workspace:FindFirstChild("Zenith_WaterPlatform") then Workspace.Zenith_WaterPlatform:Destroy() end

-- ===================================================
-- 1. HỆ THỐNG ĐA NGÔN NGỮ
-- ===================================================
local currentLang = "VI"
local translatableElements = {}

local LangDict = {
    VI = {
        title = "ZYROX VN <font color='#00d2ff'>• ZENITH</font>",
        badge = "PRO",
        tab_farm = "Farm Level",
        tab_fruit = "Trái Ác Quỷ",
        tab_pvp = "PVP & ESP",
        tab_server = "Máy Chủ",
        tab_raid = "Đi Raid",
        tab_item = "Farm Item",
        tab_setting = "Cài Đặt",
        auto_farm_level = "⚡ Tự Động Farm Level (Auto Quest)",
        auto_quest = "📜 Tự Nhận & Trả Nhiệm Vụ",
        bring_mob = "🧲 Gom Toàn Bộ Quái Lại Gần",
        fruit_buy = "🎲 Mua Ngẫu Nhiên Trái (Gacha)",
        fruit_collect = "🧲 Tự Động Nhặt Trái Rơi",
        fruit_store = "📦 Tự Động Cất Vào Rương",
        fruit_tracker_title = "Trái đang xuất hiện trên bản đồ:",
        speed_toggle = "Kích Hoạt Chạy Nhanh",
        speed_slider = "Tốc Độ Di Chuyển",
        jump_toggle = "Kích Hoạt Nhảy Cao",
        jump_slider = "Lực Nhảy",
        player_esp = "ESP Người Chơi (Tên/Máu/Khoảng Cách)",
        fruit_esp = "ESP Trái Ác Quỷ",
        chest_wood = "ESP Rương Đồng / Gỗ",
        chest_gold = "ESP Rương Vàng / Bạc",
        chest_diamond = "ESP Rương Kim Cương",
        redeem_codes = "🎁 Nhập Tất Cả Code Game",
        rejoin_btn = "Vào Lại Server Này",
        serverhop_btn = "Chuyển Sang Server Khác",
        auto_raid_start = "Tự Động Mua Vé & Bắt Đầu Raid",
        auto_raid_kill = "Tự Diệt Quái Raid",
        auto_bones = "Tự Farm Xương (Bones)",
        auto_chest = "Tự Động Gom Rương Gần",
        lang_title = "Ngôn Ngữ / Language",
        ui_scale = "Tỷ Lệ Thu Phóng UI (%)",
        ui_transparency = "Độ Trong Suốt Cửa Sổ (%)",
        fix_lag = "Tối Ưu Đồ Họa (Tăng FPS)",
        close_hub = "Đóng Menu Hub"
    },
    EN = {
        title = "ZYROX VN <font color='#00d2ff'>• ZENITH</font>",
        badge = "PRO",
        tab_farm = "Farm Level",
        tab_fruit = "Devil Fruit",
        tab_pvp = "PVP & ESP",
        tab_server = "Server",
        tab_raid = "Raid Hub",
        tab_item = "Item Farm",
        tab_setting = "Settings",
        auto_farm_level = "⚡ Auto Farm Level (Auto Quest)",
        auto_quest = "📜 Auto Accept/Return Quest",
        bring_mob = "🧲 Cluster Bring Mobs",
        fruit_buy = "🎲 Gacha Random Fruit",
        fruit_collect = "🧲 Auto Collect Dropped Fruits",
        fruit_store = "📦 Auto Store Into Inventory",
        fruit_tracker_title = "Live Dropped Fruits on Map:",
        speed_toggle = "Enable WalkSpeed",
        speed_slider = "Movement Speed",
        jump_toggle = "Enable High Jump",
        jump_slider = "Jump Height",
        player_esp = "Player ESP (Name/HP/Distance)",
        fruit_esp = "Devil Fruit ESP",
        chest_wood = "Bronze/Wood Chest ESP",
        chest_gold = "Silver/Gold Chest ESP",
        chest_diamond = "Diamond Chest ESP",
        redeem_codes = "🎁 Redeem All Game Codes",
        rejoin_btn = "Rejoin Current Server",
        serverhop_btn = "Hop to New Server",
        auto_raid_start = "Auto Start Raid",
        auto_raid_kill = "Auto Kill Raid Mobs",
        auto_bones = "Auto Farm Bones",
        auto_chest = "Auto Collect Nearby Chests",
        lang_title = "Language / Ngôn Ngữ",
        ui_scale = "UI Scale Ratio (%)",
        ui_transparency = "Window Transparency (%)",
        fix_lag = "Boost FPS / Reduce Lag",
        close_hub = "Close Hub Menu"
    }
}

local function registerText(label, key, isRich)
    table.insert(translatableElements, {Label = label, Key = key, Rich = isRich})
    label.Text = LangDict[currentLang][key]
end

local function setLanguage(lang)
    currentLang = lang
    for _, item in ipairs(translatableElements) do
        if item.Label and item.Label.Parent then
            if item.Update then
                item.Update()
            else
                item.Label.Text = LangDict[currentLang][item.Key]
            end
        end
    end
end

-- ===================================================
-- 2. TỰ ĐỘNG ĐỨNG TRÊN NƯỚC
-- ===================================================
task.spawn(function()
    local waterPlatform = Instance.new("Part")
    waterPlatform.Name = "Zenith_WaterPlatform"
    waterPlatform.Size = Vector3.new(120, 1, 120)
    waterPlatform.Transparency = 1
    waterPlatform.Anchored = true
    waterPlatform.CanCollide = true
    waterPlatform.Parent = Workspace

    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Swimming then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            if hrp.Position.Y <= 15 and hrp.Position.Y >= -60 then
                waterPlatform.CFrame = CFrame.new(hrp.Position.X, 0.5, hrp.Position.Z)
                waterPlatform.CanCollide = true
            else
                waterPlatform.CFrame = CFrame.new(hrp.Position.X, -500, hrp.Position.Z)
                waterPlatform.CanCollide = false
            end
        end
    end)
end)

-- ===================================================
-- 3. HỆ THỐNG PHÂN TÍCH LEVEL & NHẬN QUEST
-- ===================================================
local function getAutoQuestByLevel()
    local level = 1
    pcall(function()
        if LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") then
            level = LocalPlayer.Data.Level.Value
        end
    end)
    if level >= 1 and level <= 9 then return {QuestName = "BanditQuest1", QuestLevel = 1, MonName = "Bandit", ReqLevel = 1}
    elseif level >= 10 and level <= 14 then return {QuestName = "JungleQuest", QuestLevel = 1, MonName = "Monkey", ReqLevel = 10}
    elseif level >= 15 and level <= 29 then return {QuestName = "JungleQuest", QuestLevel = 2, MonName = "Gorilla", ReqLevel = 15}
    elseif level >= 30 and level <= 39 then return {QuestName = "BuggyQuest1", QuestLevel = 1, MonName = "Pirate", ReqLevel = 30}
    elseif level >= 40 and level <= 59 then return {QuestName = "BuggyQuest1", QuestLevel = 2, MonName = "Brute", ReqLevel = 40}
    elseif level >= 60 and level <= 74 then return {QuestName = "DesertQuest", QuestLevel = 1, MonName = "Desert Bandit", ReqLevel = 60}
    elseif level >= 75 and level <= 89 then return {QuestName = "DesertQuest", QuestLevel = 2, MonName = "Desert Officer", ReqLevel = 75}
    elseif level >= 90 and level <= 99 then return {QuestName = "SnowQuest", QuestLevel = 1, MonName = "Snow Bandit", ReqLevel = 90}
    elseif level >= 100 and level <= 119 then return {QuestName = "SnowQuest", QuestLevel = 2, MonName = "Snowman", ReqLevel = 100}
    elseif level >= 120 and level <= 149 then return {QuestName = "MarineQuest2", QuestLevel = 1, MonName = "Chief Petty Officer", ReqLevel = 120}
    elseif level >= 150 and level <= 174 then return {QuestName = "SkyQuest", QuestLevel = 1, MonName = "Sky Bandit", ReqLevel = 150}
    elseif level >= 175 and level <= 189 then return {QuestName = "SkyQuest", QuestLevel = 2, MonName = "Dark Master", ReqLevel = 175}
    elseif level >= 190 and level <= 209 then return {QuestName = "PrisonerQuest", QuestLevel = 1, MonName = "Prisoner", ReqLevel = 190}
    elseif level >= 210 and level <= 249 then return {QuestName = "PrisonerQuest", QuestLevel = 2, MonName = "Dangerous Prisoner", ReqLevel = 210}
    elseif level >= 250 and level <= 299 then return {QuestName = "ColosseumQuest", QuestLevel = 1, MonName = "Toga Warrior", ReqLevel = 250}
    elseif level >= 300 and level <= 374 then return {QuestName = "MagmaQuest", QuestLevel = 1, MonName = "Military Soldier", ReqLevel = 300}
    elseif level >= 375 and level <= 449 then return {QuestName = "FishmanQuest", QuestLevel = 1, MonName = "Fishman Warrior", ReqLevel = 375}
    elseif level >= 450 and level <= 524 then return {QuestName = "SkyExp1Quest", QuestLevel = 1, MonName = "God's Guard", ReqLevel = 450}
    elseif level >= 525 and level <= 624 then return {QuestName = "SkyExp2Quest", QuestLevel = 1, MonName = "Royal Squad", ReqLevel = 525}
    elseif level >= 625 and level <= 699 then return {QuestName = "FountainQuest", QuestLevel = 1, MonName = "Galley Pirate", ReqLevel = 625}
    elseif level >= 700 and level <= 774 then return {QuestName = "Area1Quest", QuestLevel = 1, MonName = "Raider", ReqLevel = 700}
    elseif level >= 775 and level <= 874 then return {QuestName = "Area2Quest", QuestLevel = 1, MonName = "Swan Pirate", ReqLevel = 775}
    elseif level >= 875 and level <= 999 then return {QuestName = "MarineQuest3", QuestLevel = 1, MonName = "Marine Lieutenant", ReqLevel = 875}
    elseif level >= 1000 and level <= 1249 then return {QuestName = "SnowMountainQuest", QuestLevel = 1, MonName = "Snow Trooper", ReqLevel = 1000}
    elseif level >= 1250 and level <= 1499 then return {QuestName = "ShipQuest1", QuestLevel = 1, MonName = "Ship Deckhand", ReqLevel = 1250}
    elseif level >= 1500 and level <= 1574 then return {QuestName = "PiratePortQuest", QuestLevel = 1, MonName = "Pirate Millionaire", ReqLevel = 1500}
    elseif level >= 1575 and level <= 1699 then return {QuestName = "DragonCrewQuest", QuestLevel = 1, MonName = "Dragon Crew Warrior", ReqLevel = 1575}
    elseif level >= 1700 and level <= 1899 then return {QuestName = "MusketeerQuest", QuestLevel = 1, MonName = "Marine Commodore", ReqLevel = 1700}
    elseif level >= 1900 and level <= 2199 then return {QuestName = "HauntedQuest1", QuestLevel = 1, MonName = "Reborn Skeleton", ReqLevel = 1900}
    else return {QuestName = "PeanutQuest", QuestLevel = 1, MonName = "Peanut Scout", ReqLevel = 2200} end
end

local selectedWeaponType = "Melee"
local AutoFarmLevel, AutoQuest, BringMob = false, true, true
local AutoRandomFruit, AutoCollectFruit, AutoStoreFruit = false, false, false

-- ===================================================
-- 4. PVP SPEED & ESP
-- ===================================================
local speedValue, speedEnabled = 16, false
local jumpValue, jumpEnabled = 50, false
RunService.Heartbeat:Connect(function()
    if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        if humanoid and rootPart and humanoid.MoveDirection.Magnitude > 0 then
            rootPart.AssemblyLinearVelocity = Vector3.new(humanoid.MoveDirection.X * speedValue, rootPart.AssemblyLinearVelocity.Y, humanoid.MoveDirection.Z * speedValue)
        end
    end
end)
UserInputService.JumpRequest:Connect(function()
    if jumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        rootPart.AssemblyLinearVelocity = Vector3.new(rootPart.AssemblyLinearVelocity.X, jumpValue, rootPart.AssemblyLinearVelocity.Z)
    end
end)

local espPlayerEnabled, espFruitEnabled = false, false
local espChest1Enabled, espChest2Enabled, espChest3Enabled = false, false, false
local detectedChests = {}

local function refreshChestList()
    detectedChests = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            local pName = obj.Parent and string.lower(obj.Parent.Name) or ""
            if string.find(name, "chest") or string.find(pName, "chest") then
                local tier = 1
                if string.find(name, "3") or string.find(pName, "3") or string.find(name, "diamond") then tier = 3
                elseif string.find(name, "2") or string.find(pName, "2") or string.find(name, "gold") or string.find(name, "silver") then tier = 2 end
                table.insert(detectedChests, {Part = obj, Tier = tier})
            end
        end
    end
end
task.spawn(function() while true do refreshChestList() task.wait(3) end end)

local function updatePlayerESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if espPlayerEnabled and head and hum and myHRP and hum.Health > 0 then
                local dist = math.floor((head.Position - myHRP.Position).Magnitude)
                local bbGui = head:FindFirstChild("Zenith_PlayerBillboard")
                if not bbGui then
                    bbGui = Instance.new("BillboardGui", head)
                    bbGui.Name = "Zenith_PlayerBillboard"
                    bbGui.Size, bbGui.StudsOffset, bbGui.AlwaysOnTop = UDim2.new(0, 200, 0, 45), Vector3.new(0, 2.8, 0), true
                    local txt = Instance.new("TextLabel", bbGui)
                    txt.Name = "Info"
                    txt.Size, txt.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
                    txt.Font, txt.TextSize, txt.TextColor3 = Enum.Font.GothamBold, 11, Color3.fromRGB(255, 60, 90)
                end
                bbGui.Info.Text = string.format("%s\n[%dm] • HP: %d/%d (%d%%)", p.DisplayName, dist, math.floor(hum.Health), math.floor(hum.MaxHealth), math.floor((hum.Health / hum.MaxHealth) * 100))
            else
                if head and head:FindFirstChild("Zenith_PlayerBillboard") then head.Zenith_PlayerBillboard:Destroy() end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.2)
        updatePlayerESP()
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then continue end

        for _, obj in ipairs(Workspace:GetChildren()) do
            if (obj:IsA("Tool") and string.find(obj.Name, "Fruit")) or obj:FindFirstChild("Fruit") then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    if espFruitEnabled then
                        local b = handle:FindFirstChild("Zenith_FruitESP")
                        if not b then
                            b = Instance.new("BillboardGui", handle)
                            b.Name = "Zenith_FruitESP"
                            b.Size, b.StudsOffset, b.AlwaysOnTop = UDim2.new(0, 180, 0, 30), Vector3.new(0, 2, 0), true
                            local t = Instance.new("TextLabel", b)
                            t.Name, t.Size, t.BackgroundTransparency = "Label", UDim2.new(1, 0, 1, 0), 1
                            t.Font, t.TextSize, t.TextColor3 = Enum.Font.GothamBold, 12, Color3.fromRGB(255, 70, 220)
                        end
                        b.Label.Text = string.format("🍎 %s\n[%dm]", obj.Name, math.floor((handle.Position - myHRP.Position).Magnitude))
                    else
                        if handle:FindFirstChild("Zenith_FruitESP") then handle.Zenith_FruitESP:Destroy() end
                    end
                end
            end
        end
        
        for _, item in ipairs(detectedChests) do
            local rootPart, tier = item.Part, item.Tier
            if rootPart and rootPart.Parent then
                local shouldShow = (tier == 1 and espChest1Enabled) or (tier == 2 and espChest2Enabled) or (tier == 3 and espChest3Enabled)
                if shouldShow then
                    local b = rootPart:FindFirstChild("Zenith_ChestESP")
                    if not b then
                        b = Instance.new("BillboardGui", rootPart)
                        b.Name = "Zenith_ChestESP"
                        b.Size, b.StudsOffset, b.AlwaysOnTop = UDim2.new(0, 160, 0, 25), Vector3.new(0, 2, 0), true
                        local t = Instance.new("TextLabel", b)
                        t.Name, t.Size, t.BackgroundTransparency, t.Font, t.TextSize = "Label", UDim2.new(1, 0, 1, 0), 1, Enum.Font.GothamBold, 11
                    end
                    b.Label.TextColor3 = (tier == 3 and Color3.fromRGB(0, 240, 255)) or (tier == 2 and Color3.fromRGB(255, 215, 0)) or Color3.fromRGB(205, 127, 50)
                    b.Label.Text = string.format("%s [%dm]", (tier == 3 and "💎 Diamond") or (tier == 2 and "🪙 Gold") or "📦 Bronze", math.floor((rootPart.Position - myHRP.Position).Magnitude))
                else
                    if rootPart:FindFirstChild("Zenith_ChestESP") then rootPart.Zenith_ChestESP:Destroy() end
                end
            end
        end
    end
end)

-- ===================================================
-- 6. PERFECT FAST ATTACK HACK ENGINE (NO CLICK / STAND STILL)
-- ===================================================
local currentTween = nil
local isAttackingTarget = false

local function executeFastAttack()
    local char = LocalPlayer.Character
    if not char then return end

    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    -- Hack thẳng CombatFramework để ra đòn ngay lập tức, không cần click chuột
    pcall(function()
        local CombatFramework = require(LocalPlayer.PlayerScripts.CombatFramework)
        local activeController = CombatFramework.activeController
        if activeController then
            activeController.hitboxLimiter = 0
            activeController.timeToNextAttack = 0
            activeController.attacking = false
            activeController.timeToNextBlock = 0
            activeController.increment = 3
            activeController.blocking = false
            activeController.hasCombatState = false

            -- Gửi lệnh chém lên Server (No Click)
            activeController:attack()
        end
    end)
    
    -- Tắt hoạt ảnh vung vũ khí để nhân vật "Đứng im" hack
    pcall(function()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for _, anim in ipairs(humanoid:GetPlayingAnimationTracks()) do
                local n = anim.Name
                if n == "Attack" or n == "Slash" or n == "Punch" or n == "Combat" or n == "M1" then
                    anim:Stop()
                end
            end
        end
    end)
end

-- Vòng lặp Fast Attack (Chớp nhoáng 0.08s - Chuẩn hack)
task.spawn(function()
    while true do
        if AutoFarmLevel and isAttackingTarget then
            executeFastAttack()
            task.wait(0.08)
        else
            task.wait(0.1)
        end
    end
end)

local function toTargetPos(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local speed = 300 
    local time = distance / speed
    if currentTween then currentTween:Cancel() end
    currentTween = TweenService:Create(root, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    currentTween:Play()
end

RunService.Stepped:Connect(function()
    if (AutoFarmLevel or AutoCollectFruit) and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end
end)

local function equipChosenWeapon()
    local char = LocalPlayer.Character
    if not char then return nil end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") and (item.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (item.ToolTip == "Melee" or item.ToolTip == "Combat" or item.Name == "Combat" or item.Name == "Võ Tân Binh"))) then return item end
    end
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (tool.ToolTip == "Melee" or tool.ToolTip == "Combat" or tool.Name == "Combat" or tool.Name == "Võ Tân Binh"))) then
                humanoid:EquipTool(tool)
                return tool
            end
        end
    end
    return nil
end

local function checkHasQuest()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui and playerGui:FindFirstChild("Main") then
        local questFrame = playerGui.Main:FindFirstChild("Quest")
        return (questFrame and questFrame.Visible)
    end
    return false
end

local function getAllLivingEnemies(monName)
    local list = {}
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return list end
    for _, mob in ipairs(enemies:GetChildren()) do
        if string.find(mob.Name, monName) then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then table.insert(list, mob) end
        end
    end
    return list
end

task.spawn(function()
    while true do
        task.wait(0.05)
        if AutoFarmLevel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local currentQuest = getAutoQuestByLevel()
            if currentQuest then
                if AutoQuest and not checkHasQuest() then
                    CommF:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.QuestLevel)
                    task.wait(0.3)
                end
                local mobList = getAllLivingEnemies(currentQuest.MonName)
                if #mobList > 0 then
                    equipChosenWeapon()
                    local primaryMob = mobList[1]
                    local primaryHRP = primaryMob:FindFirstChild("HumanoidRootPart")
                    local myHRP = LocalPlayer.Character.HumanoidRootPart

                    if primaryHRP then
                        local clusterPosition = primaryHRP.Position
                        local targetCFrame = CFrame.new(clusterPosition + Vector3.new(0, 1.5, 3.5), clusterPosition)
                        local dist = (myHRP.Position - clusterPosition).Magnitude

                        if dist > 15 then
                            isAttackingTarget = false
                            toTargetPos(targetCFrame)
                        else
                            if currentTween then currentTween:Cancel() end
                            if (myHRP.Position - targetCFrame.Position).Magnitude > 2.5 then
                                myHRP.CFrame = targetCFrame
                            end
                            myHRP.AssemblyLinearVelocity = Vector3.zero
                            isAttackingTarget = true

                            if BringMob then
                                for _, otherMob in ipairs(mobList) do
                                    local oHRP = otherMob:FindFirstChild("HumanoidRootPart")
                                    local oHum = otherMob:FindFirstChildOfClass("Humanoid")
                                    if oHRP and oHum and oHum.Health > 0 then
                                        if (oHRP.Position - clusterPosition).Magnitude <= 320 then
                                            oHRP.CFrame = CFrame.new(clusterPosition)
                                            oHRP.AssemblyLinearVelocity = Vector3.zero
                                            oHRP.CanCollide = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    isAttackingTarget = false
                end
            end
        else
            isAttackingTarget = false
            if currentTween then currentTween:Cancel() end
        end
    end
end)

-- ===================================================
-- 7. MODULE FRUIT (RANDOM, COLLECT, STORE)
-- ===================================================
task.spawn(function()
    while true do
        task.wait(5)
        if AutoRandomFruit then pcall(function() CommF:InvokeServer("Cousin", "Buy") end) end
    end
end)
task.spawn(function()
    while true do
        task.wait(1)
        if AutoCollectFruit and not AutoFarmLevel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if (obj:IsA("Tool") and string.find(obj.Name, "Fruit")) or obj:FindFirstChild("Fruit") then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        toTargetPos(handle.CFrame)
                        task.wait(0.5)
                        if firetouchinterest then
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, handle, 0)
                            task.wait()
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, handle, 1)
                        end
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        if AutoStoreFruit then
            pcall(function()
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local char = LocalPlayer.Character
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if string.find(item.Name, "Fruit") or item:FindFirstChild("Fruit") then CommF:InvokeServer("StoreFruit", item.Name, item) end
                    end
                end
                if char then
                    for _, item in ipairs(char:GetChildren()) do
                        if item:IsA("Tool") and (string.find(item.Name, "Fruit") or item:FindFirstChild("Fruit")) then CommF:InvokeServer("StoreFruit", item.Name, item) end
                    end
                end
            end)
        end
    end
end)

-- ===================================================
-- 8. GIAO DIỆN CYBERPUNK BRIGHT TABS FIX
-- ===================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentGui

local FULL_HEIGHT, MIN_HEIGHT = 310, 38
local isMinimized = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size, MainFrame.AnchorPoint = UDim2.new(0, 520, 0, FULL_HEIGHT), Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3, MainFrame.BackgroundTransparency = Color3.fromRGB(11, 13, 19), 0.12
MainFrame.BorderSizePixel, MainFrame.Active, MainFrame.ClipsDescendants = 0, true, true

local UIScale = Instance.new("UIScale", MainFrame)
UIScale.Scale = 1.0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color, MainStroke.Transparency, MainStroke.Thickness = Color3.fromRGB(30, 36, 50), 0.2, 1.2

-- Kéo thả cửa sổ
local isDraggingWindow, dragStartPos, frameStartPos = false, nil, nil
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingWindow, dragStartPos, frameStartPos = true, input.Position, MainFrame.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingWindow = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDraggingWindow and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = (input.Position - dragStartPos) / UIScale.Scale
        MainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
    end
end)

-- TopBar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size, TopBar.BackgroundColor3, TopBar.BackgroundTransparency, TopBar.BorderSizePixel = UDim2.new(1, 0, 0, 38), Color3.fromRGB(15, 18, 26), 0.2, 0
local TopBarStroke = Instance.new("Frame", TopBar)
TopBarStroke.Size, TopBarStroke.Position, TopBarStroke.BackgroundColor3, TopBarStroke.BorderSizePixel = UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 1, -1), Color3.fromRGB(26, 32, 46), 0
local LogoIcon = Instance.new("ImageLabel", TopBar)
LogoIcon.Size, LogoIcon.Position, LogoIcon.BackgroundTransparency, LogoIcon.Image, LogoIcon.ScaleType = UDim2.new(0, 22, 0, 22), UDim2.new(0, 10, 0.5, -11), 1, "rbxassetid://100412534591942", Enum.ScaleType.Fit
local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position, Title.BackgroundTransparency, Title.RichText, Title.TextColor3, Title.Font, Title.TextSize, Title.TextXAlignment = UDim2.new(0, 140, 1, 0), UDim2.new(0, 38, 0, 0), 1, true, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12, Enum.TextXAlignment.Left
registerText(Title, "title", true)
local Badge = Instance.new("TextLabel", TopBar)
Badge.Size, Badge.Position, Badge.BackgroundColor3, Badge.BackgroundTransparency, Badge.TextColor3, Badge.Font, Badge.TextSize = UDim2.new(0, 32, 0, 16), UDim2.new(0, 172, 0.5, -8), Color3.fromRGB(0, 180, 255), 0.8, Color3.fromRGB(0, 210, 255), Enum.Font.GothamBold, 9
Instance.new("UICorner", Badge).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", Badge).Color = Color3.fromRGB(0, 180, 255)
registerText(Badge, "badge")

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size, MinBtn.Position, MinBtn.BackgroundColor3, MinBtn.Text, MinBtn.TextColor3, MinBtn.Font, MinBtn.TextSize = UDim2.new(0, 24, 0, 24), UDim2.new(1, -56, 0.5, -12), Color3.fromRGB(22, 26, 38), "−", Color3.fromRGB(160, 170, 190), Enum.Font.GothamBold, 13
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size, CloseBtn.Position, CloseBtn.BackgroundColor3, CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.Font, CloseBtn.TextSize = UDim2.new(0, 24, 0, 24), UDim2.new(1, -28, 0.5, -12), Color3.fromRGB(22, 26, 38), "✕", Color3.fromRGB(160, 170, 190), Enum.Font.GothamBold, 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size, Sidebar.Position, Sidebar.BackgroundColor3, Sidebar.BackgroundTransparency, Sidebar.BorderSizePixel, Sidebar.ZIndex = UDim2.new(0, 140, 1, -38), UDim2.new(0, 0, 0, 38), Color3.fromRGB(13, 15, 22), 0.15, 0, 2
local SidebarRightBorder = Instance.new("Frame", MainFrame)
SidebarRightBorder.Size, SidebarRightBorder.Position, SidebarRightBorder.BackgroundColor3, SidebarRightBorder.BorderSizePixel, SidebarRightBorder.ZIndex = UDim2.new(0, 1, 1, -38), UDim2.new(0, 139, 0, 38), Color3.fromRGB(26, 32, 46), 0, 3
local TabListLayout = Instance.new("UIListLayout", Sidebar)
TabListLayout.Padding, TabListLayout.HorizontalAlignment = UDim.new(0, 3), Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 6)

-- Content Container
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size, ContentContainer.Position, ContentContainer.BackgroundTransparency, ContentContainer.ZIndex = UDim2.new(1, -140, 1, -38), UDim2.new(0, 140, 0, 38), 1, 1

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 520, 0, MIN_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible, SidebarRightBorder.Visible, ContentContainer.Visible, MinBtn.Text = false, false, false, "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 520, 0, FULL_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible, SidebarRightBorder.Visible, ContentContainer.Visible, MinBtn.Text = true, true, true, "−"
    end
end)

local tabButtons = {}
local tabPages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Size, page.BackgroundTransparency, page.ScrollBarThickness, page.ScrollBarImageColor3, page.BorderSizePixel, page.Visible, page.AutomaticCanvasSize = UDim2.new(1, 0, 1, 0), 1, 2, Color3.fromRGB(0, 180, 255), 0, false, Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", page)
    layout.Padding, layout.HorizontalAlignment = UDim.new(0, 6), Enum.HorizontalAlignment.Center
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop, pad.PaddingBottom = UDim.new(0, 8), UDim.new(0, 8)
    tabPages[name] = page
    return page
end

local function switchTab(name)
    for tName, item in pairs(tabButtons) do
        if tName == name then
            -- Nổi Bật Tab Đang Chọn (Màu Xanh Đậm Thay Vì Đen Tối)
            item.Button.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
            item.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            item.Pill.Visible = true
        else
            -- Sáng Lên Chút Cho Tab Chưa Chọn
            item.Button.BackgroundColor3 = Color3.fromRGB(28, 35, 48)
            item.Button.TextColor3 = Color3.fromRGB(180, 190, 210)
            item.Pill.Visible = false
        end
    end
    for pName, page in pairs(tabPages) do page.Visible = (pName == name) end
end

local function createTabButton(name, icon, transKey)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.92, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(28, 35, 48) -- Sáng Hơn
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(180, 190, 210)
    btn.Font, btn.TextSize, btn.TextXAlignment = Enum.Font.GothamMedium, 11, Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 10)

    local pill = Instance.new("Frame", btn)
    pill.Size, pill.Position, pill.BackgroundColor3, pill.BorderSizePixel, pill.Visible = UDim2.new(0, 3, 0, 14), UDim2.new(0, -7, 0.5, -7), Color3.fromRGB(255, 255, 255), 0, false
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local entry = {Label = btn, Key = transKey, Button = btn, Pill = pill, Update = function() btn.Text = icon .. "  " .. LangDict[currentLang][transKey] end}
    table.insert(translatableElements, entry)
    btn.Text = icon .. "  " .. LangDict[currentLang][transKey]
    tabButtons[name] = entry
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

local function createToggle(page, transKey, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame", page)
    frame.Size, frame.BackgroundColor3, frame.BackgroundTransparency, frame.BorderSizePixel = UDim2.new(0.94, 0, 0, 34), Color3.fromRGB(16, 20, 28), 0.2, 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(28, 34, 48)
    
    local label = Instance.new("TextLabel", frame)
    label.Size, label.Position, label.BackgroundTransparency, label.TextColor3, label.Font, label.TextSize, label.TextXAlignment = UDim2.new(1, -50, 1, 0), UDim2.new(0, 10, 0, 0), 1, Color3.fromRGB(220, 225, 235), Enum.Font.Gotham, 11, Enum.TextXAlignment.Left
    registerText(label, transKey)

    local switch = Instance.new("TextButton", frame)
    switch.Size, switch.Position, switch.BackgroundColor3, switch.Text = UDim2.new(0, 32, 0, 16), UDim2.new(1, -40, 0.5, -8), state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54), ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch)
    circle.Size, circle.Position, circle.BackgroundColor3 = UDim2.new(0, 12, 0, 12), state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    switch.MouseButton1Click:Connect(function()
        state = not state
        switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        if callback then callback(state) end
    end)
end

local function createSlider(page, transKey, min, max, default, callback)
    local current = default or min
    local frame = Instance.new("Frame", page)
    frame.Size, frame.BackgroundColor3, frame.BackgroundTransparency, frame.BorderSizePixel = UDim2.new(0.94, 0, 0, 44), Color3.fromRGB(16, 20, 28), 0.2, 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(28, 34, 48)

    local label = Instance.new("TextLabel", frame)
    label.Size, label.Position, label.BackgroundTransparency, label.TextColor3, label.Font, label.TextSize, label.TextXAlignment = UDim2.new(1, -70, 0, 20), UDim2.new(0, 10, 0, 3), 1, Color3.fromRGB(220, 225, 235), Enum.Font.Gotham, 11, Enum.TextXAlignment.Left
    registerText(label, transKey)
    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size, valueLabel.Position, valueLabel.BackgroundTransparency, valueLabel.Text, valueLabel.TextColor3, valueLabel.Font, valueLabel.TextSize, valueLabel.TextXAlignment = UDim2.new(0, 55, 0, 20), UDim2.new(1, -65, 0, 3), 1, tostring(current), Color3.fromRGB(0, 210, 255), Enum.Font.GothamBold, 11, Enum.TextXAlignment.Right
    local track = Instance.new("TextButton", frame)
    track.Size, track.Position, track.BackgroundColor3, track.AutoButtonColor, track.Text = UDim2.new(0.94, 0, 0, 4), UDim2.new(0.03, 0, 0, 28), Color3.fromRGB(35, 42, 58), false, ""
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track)
    fill.Size, fill.BackgroundColor3 = UDim2.new((current - min) / (max - min), 0, 1, 0), Color3.fromRGB(0, 190, 255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local isDraggingSlider = false
    local function update(percent)
        percent = math.clamp(percent, 0, 1)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        current = math.floor(min + (max - min) * percent)
        valueLabel.Text = tostring(current)
        if callback then callback(current) end
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingSlider, update((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X) = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingSlider = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update((UserInputService:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X) end
    end)
end

local function createButton(page, transKey, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size, btn.BackgroundColor3, btn.TextColor3, btn.Font, btn.TextSize = UDim2.new(0.94, 0, 0, 30), Color3.fromRGB(20, 26, 38), Color3.fromRGB(0, 210, 255), Enum.Font.GothamMedium, 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color, stroke.Transparency = Color3.fromRGB(0, 180, 255), 0.8
    registerText(btn, transKey)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

-- ===================================================
-- 9. TẠO CÁC DANH MỤC
-- ===================================================
local cats = {{"Farm", "🌾", "tab_farm"}, {"Fruit", "🍎", "tab_fruit"}, {"PVP-ESP", "⚔️", "tab_pvp"}, {"Server", "🌐", "tab_server"}, {"RAID", "⚡", "tab_raid"}, {"FARM ITEM", "🗡️", "tab_item"}, {"SETTING", "⚙️", "tab_setting"}}
for _, c in ipairs(cats) do createTabButton(c[1], c[2], c[3]) createPage(c[1]) end

-- [TAB 1: FARM]
local farmPage = tabPages["Farm"]
local infoCard = Instance.new("Frame", farmPage)
infoCard.Size, infoCard.BackgroundColor3, infoCard.BackgroundTransparency = UDim2.new(0.94, 0, 0, 42), Color3.fromRGB(15, 19, 28), 0.2
Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", infoCard).Color = Color3.fromRGB(32, 40, 58)
local icBar = Instance.new("Frame", infoCard)
icBar.Size, icBar.Position, icBar.BackgroundColor3 = UDim2.new(0, 3, 1, -10), UDim2.new(0, 5, 0, 5), Color3.fromRGB(0, 210, 255)
Instance.new("UICorner", icBar).CornerRadius = UDim.new(1, 0)
local infoLabel = Instance.new("TextLabel", infoCard)
infoLabel.Size, infoLabel.Position, infoLabel.BackgroundTransparency, infoLabel.RichText, infoLabel.TextColor3, infoLabel.Font, infoLabel.TextSize, infoLabel.TextXAlignment = UDim2.new(1, -22, 1, 0), UDim2.new(0, 14, 0, 0), 1, true, Color3.fromRGB(230, 235, 245), Enum.Font.GothamMedium, 10, Enum.TextXAlignment.Left

task.spawn(function()
    while true do
        task.wait(1)
        local curQuest = getAutoQuestByLevel()
        local pLevel = 1
        pcall(function() pLevel = LocalPlayer.Data.Level.Value end)
        if curQuest then infoLabel.Text = string.format("Level: <font color='#00d2ff'><b>%d</b></font>  |  Mục Tiêu:\nQuái: <font color='#ffb703'><b>%s</b></font> (Yêu Cầu Lv.%d)", pLevel, curQuest.MonName, curQuest.ReqLevel) end
    end
end)

local weaponSegment = Instance.new("Frame", farmPage)
weaponSegment.Size, weaponSegment.BackgroundColor3, weaponSegment.BackgroundTransparency = UDim2.new(0.94, 0, 0, 28), Color3.fromRGB(15, 18, 25), 0.2
Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", weaponSegment).Color = Color3.fromRGB(28, 34, 48)
local wsLayout = Instance.new("UIListLayout", weaponSegment)
wsLayout.FillDirection, wsLayout.HorizontalAlignment, wsLayout.VerticalAlignment, wsLayout.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0, 3)

local weaponBtns = {}
local weaponList = {{name = "Melee", label = "🥊 Melee"}, {name = "Sword", label = "⚔️ Sword"}, {name = "Blox Fruit", label = "🍎 Fruit"}, {name = "Gun", label = "🔫 Gun"}}
for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size, b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = UDim2.new(0.235, 0, 0.78, 0), (selectedWeaponType == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48), wData.label, (selectedWeaponType == wData.name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170), Enum.Font.GothamMedium, 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    weaponBtns[wData.name] = b
    b.MouseButton1Click:Connect(function()
        selectedWeaponType = wData.name
        for name, btn in pairs(weaponBtns) do
            btn.BackgroundColor3 = (name == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
            btn.TextColor3 = (name == wData.name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
        end
    end)
end

createToggle(farmPage, "auto_farm_level", false, function(v) AutoFarmLevel = v end)
createToggle(farmPage, "auto_quest", true, function(v) AutoQuest = v end)
createToggle(farmPage, "bring_mob", true, function(v) BringMob = v end)

-- [TAB 2: FRUIT]
local fruitPage = tabPages["Fruit"]
createToggle(fruitPage, "fruit_buy", false, function(v) AutoRandomFruit = v end)
createToggle(fruitPage, "fruit_collect", false, function(v) AutoCollectFruit = v end)
createToggle(fruitPage, "fruit_store", false, function(v) AutoStoreFruit = v end)
local trackerTitle = Instance.new("TextLabel", fruitPage)
trackerTitle.Size, trackerTitle.BackgroundTransparency, trackerTitle.TextColor3, trackerTitle.Font, trackerTitle.TextSize, trackerTitle.TextXAlignment = UDim2.new(0.94, 0, 0, 18), 1, Color3.fromRGB(0, 210, 255), Enum.Font.GothamBold, 10, Enum.TextXAlignment.Left
registerText(trackerTitle, "fruit_tracker_title")
local fruitListDisplay = Instance.new("ScrollingFrame", fruitPage)
fruitListDisplay.Size, fruitListDisplay.BackgroundColor3, fruitListDisplay.BackgroundTransparency, fruitListDisplay.BorderSizePixel, fruitListDisplay.ScrollBarThickness, fruitListDisplay.ScrollBarImageColor3 = UDim2.new(0.94, 0, 0, 70), Color3.fromRGB(15, 18, 26), 0.2, 0, 2, Color3.fromRGB(0, 180, 255)
Instance.new("UICorner", fruitListDisplay).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", fruitListDisplay).Color = Color3.fromRGB(28, 34, 48)
local flLayout = Instance.new("UIListLayout", fruitListDisplay)
flLayout.Padding, flLayout.HorizontalAlignment = UDim.new(0, 2), Enum.HorizontalAlignment.Center
task.spawn(function()
    while true do
        task.wait(1.5)
        for _, ch in ipairs(fruitListDisplay:GetChildren()) do if ch:IsA("TextLabel") then ch:Destroy() end end
        local foundFruits = 0
        for _, obj in ipairs(Workspace:GetChildren()) do
            if (obj:IsA("Tool") and string.find(obj.Name, "Fruit")) or obj:FindFirstChild("Fruit") then
                foundFruits = foundFruits + 1
                local item = Instance.new("TextLabel", fruitListDisplay)
                item.Size, item.BackgroundTransparency, item.Text, item.TextColor3, item.Font, item.TextSize, item.TextXAlignment = UDim2.new(0.95, 0, 0, 18), 1, "🍎 " .. obj.Name, Color3.fromRGB(255, 120, 200), Enum.Font.GothamMedium, 10, Enum.TextXAlignment.Left
            end
        end
        if foundFruits == 0 then
            local none = Instance.new("TextLabel", fruitListDisplay)
            none.Size, none.BackgroundTransparency, none.Text, none.TextColor3, none.Font, none.TextSize, none.TextXAlignment = UDim2.new(0.95, 0, 0, 18), 1, "• Không có trái nào rơi trên sàn", Color3.fromRGB(120, 130, 145), Enum.Font.Gotham, 10, Enum.TextXAlignment.Left
        end
    end
end)

-- [TAB 3: PVP-ESP]
local pvpPage = tabPages["PVP-ESP"]
createToggle(pvpPage, "speed_toggle", false, function(v) speedEnabled = v end)
createSlider(pvpPage, "speed_slider", 16, 300, 16, function(val) speedValue = val end)
createToggle(pvpPage, "jump_toggle", false, function(v) jumpEnabled = v end)
createSlider(pvpPage, "jump_slider", 50, 400, 50, function(val) jumpValue = val end)
createToggle(pvpPage, "player_esp", false, function(v) espPlayerEnabled = v end)
createToggle(pvpPage, "fruit_esp", false, function(v) espFruitEnabled = v end)
createToggle(pvpPage, "chest_wood", false, function(v) espChest1Enabled = v end)
createToggle(pvpPage, "chest_gold", false, function(v) espChest2Enabled = v end)
createToggle(pvpPage, "chest_diamond", false, function(v) espChest3Enabled = v end)

-- [TAB 4: SERVER]
local serverPage = tabPages["Server"]
local gameCodes = {"ADMINHACKED", "ADMINDARES", "SECRET_ADMIN", "NOOB2PRO", "StrawHatMaine", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "THEGREATACE", "SUB2GAMERROBOT_EXP1", "Sub2OfficialNoobie", "FUDD10", "BIGNEWS", "KITT_RESET", "SUB2NOOBMASTER123", "Sub2UncleKizaru", "Sub2Daigrock", "Axiore", "TantaiGaming", "FUDD10_V2", "CHANDLER", "GAMER_ROBOT_1M", "TY_FOR_WATCHING", "UPD16", "3BVISITS", "2BILLION"}
createButton(serverPage, "redeem_codes", function() task.spawn(function() for _, c in ipairs(gameCodes) do pcall(function() CommF:InvokeServer("RedeemCustomCode", c) end) task.wait(0.1) end end) end)
createButton(serverPage, "rejoin_btn", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
createButton(serverPage, "serverhop_btn", function()
    local success, response = pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end)
    if success and response and response.data then
        for _, s in ipairs(response.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer) break end end
    end
end)

-- [TAB 5: RAID & TAB 6: ITEM]
createToggle(tabPages["RAID"], "auto_raid_start", false, function(v) end)
createToggle(tabPages["RAID"], "auto_raid_kill", false, function(v) end)
createToggle(tabPages["FARM ITEM"], "auto_bones", false, function(v) end)
createToggle(tabPages["FARM ITEM"], "auto_chest", false, function(v) end)

-- [TAB 7: SETTING]
local settingPage = tabPages["SETTING"]
local langFrame = Instance.new("Frame", settingPage)
langFrame.Size, langFrame.BackgroundColor3, langFrame.BackgroundTransparency = UDim2.new(0.94, 0, 0, 36), Color3.fromRGB(16, 20, 28), 0.2
Instance.new("UICorner", langFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", langFrame).Color = Color3.fromRGB(28, 34, 48)
local langLabel = Instance.new("TextLabel", langFrame)
langLabel.Size, langLabel.Position, langLabel.BackgroundTransparency, langLabel.TextColor3, langLabel.Font, langLabel.TextSize, langLabel.TextXAlignment = UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 10, 0, 0), 1, Color3.fromRGB(220, 225, 235), Enum.Font.Gotham, 11, Enum.TextXAlignment.Left
registerText(langLabel, "lang_title")

local vnBtn = Instance.new("TextButton", langFrame)
vnBtn.Size, vnBtn.Position, vnBtn.BackgroundColor3, vnBtn.Text, vnBtn.TextColor3, vnBtn.Font, vnBtn.TextSize = UDim2.new(0.22, 0, 0.7, 0), UDim2.new(0.52, 0, 0.15, 0), (currentLang == "VI") and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(28, 35, 48), "🇻🇳 VN", Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 10
Instance.new("UICorner", vnBtn).CornerRadius = UDim.new(0, 4)

local enBtn = Instance.new("TextButton", langFrame)
enBtn.Size, enBtn.Position, enBtn.BackgroundColor3, enBtn.Text, enBtn.TextColor3, enBtn.Font, enBtn.TextSize = UDim2.new(0.22, 0, 0.7, 0), UDim2.new(0.76, 0, 0.15, 0), (currentLang == "EN") and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(28, 35, 48), "🇬🇧 EN", Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 10
Instance.new("UICorner", enBtn).CornerRadius = UDim.new(0, 4)

vnBtn.MouseButton1Click:Connect(function() vnBtn.BackgroundColor3, enBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255), Color3.fromRGB(28, 35, 48) setLanguage("VI") end)
enBtn.MouseButton1Click:Connect(function() enBtn.BackgroundColor3, vnBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255), Color3.fromRGB(28, 35, 48) setLanguage("EN") end)

createSlider(settingPage, "ui_scale", 60, 140, 100, function(val) UIScale.Scale = val / 100 end)
createSlider(settingPage, "ui_transparency", 0, 80, 12, function(val) MainFrame.BackgroundTransparency = val / 100 Sidebar.BackgroundTransparency = math.clamp((val + 8) / 100, 0, 1) end)
createButton(settingPage, "fix_lag", function()
    Lighting.GlobalShadows, Lighting.FogEnd, Lighting.Brightness = false, 9e9, 1
    for _, v in ipairs(Lighting:GetChildren()) do if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then v.Enabled = false end end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then obj.Material, obj.CastShadow = Enum.Material.SmoothPlastic, false
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then obj.Enabled = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1 end
    end
end)
createButton(settingPage, "close_hub", function() ScreenGui:Destroy() end)

switchTab("Farm")
