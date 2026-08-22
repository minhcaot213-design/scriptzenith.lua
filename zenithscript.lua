-- [[ ZENITH BLOX FRUIT - V12.1 (ULTIMATE FIX & COMBAT ENGINE) ]] --

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
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local Camera = Workspace.CurrentCamera

-- ===================================================
-- 0. DỌN DẸP INSTANCE CŨ (CLEANUP & SAFE GUI)
-- ===================================================
local UI_NAME = "ZenithBloxFruit_Zyrox_V12"
local function getSafeParent()
    if gethui then return gethui() end -- Hỗ trợ tốt nhất cho các Executor xịn
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
local AutoFarmLevel = false
local AutoQuest = true
local BringMob = true

local AutoRandomFruit = false
local AutoCollectFruit = false
local AutoStoreFruit = false

-- ===================================================
-- 4. PVP SPEED & JUMP MODULE
-- ===================================================
local speedValue = 16
local speedEnabled = false
local jumpValue = 50
local jumpEnabled = false

RunService.Heartbeat:Connect(function()
    if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        if humanoid and rootPart and humanoid.MoveDirection.Magnitude > 0 then
            rootPart.AssemblyLinearVelocity = Vector3.new(
                humanoid.MoveDirection.X * speedValue,
                rootPart.AssemblyLinearVelocity.Y,
                humanoid.MoveDirection.Z * speedValue
            )
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if jumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        rootPart.AssemblyLinearVelocity = Vector3.new(rootPart.AssemblyLinearVelocity.X, jumpValue, rootPart.AssemblyLinearVelocity.Z)
    end
end)

-- ===================================================
-- 5. ESP MODULE
-- ===================================================
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
                elseif string.find(name, "2") or string.find(pName, "2") or string.find(name, "gold") or string.find(name, "silver") then tier = 2
                end
                table.insert(detectedChests, {Part = obj, Tier = tier})
            end
        end
    end
end

task.spawn(function()
    while true do
        refreshChestList()
        task.wait(3)
    end
end)

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
                    bbGui = Instance.new("BillboardGui")
                    bbGui.Name = "Zenith_PlayerBillboard"
                    bbGui.Size = UDim2.new(0, 200, 0, 45)
                    bbGui.StudsOffset = Vector3.new(0, 2.8, 0)
                    bbGui.AlwaysOnTop = true
                    bbGui.Adornee = head
                    bbGui.Parent = head
                    
                    local txt = Instance.new("TextLabel")
                    txt.Name = "Info"
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Font = Enum.Font.GothamBold
                    txt.TextSize = 11
                    txt.TextColor3 = Color3.fromRGB(255, 60, 90)
                    txt.TextStrokeTransparency = 0
                    txt.Parent = bbGui
                end
                
                local hpPercent = math.floor((hum.Health / hum.MaxHealth) * 100)
                bbGui.Info.Text = string.format("%s\n[%dm] • HP: %d/%d (%d%%)", p.DisplayName, dist, math.floor(hum.Health), math.floor(hum.MaxHealth), hpPercent)
                
                local highlight = char:FindFirstChild("Zenith_Highlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "Zenith_Highlight"
                    highlight.FillColor = Color3.fromRGB(255, 45, 85)
                    highlight.FillTransparency = 0.5
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = char
                end
            else
                if head and head:FindFirstChild("Zenith_PlayerBillboard") then head.Zenith_PlayerBillboard:Destroy() end
                if char:FindFirstChild("Zenith_Highlight") then char.Zenith_Highlight:Destroy() end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.2)
        updatePlayerESP()
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then continue end

        -- Fruit ESP
        for _, obj in ipairs(Workspace:GetChildren()) do
            if (obj:IsA("Tool") and string.find(obj.Name, "Fruit")) or obj:FindFirstChild("Fruit") then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    if espFruitEnabled then
                        local dist = math.floor((handle.Position - myHRP.Position).Magnitude)
                        local b = handle:FindFirstChild("Zenith_FruitESP")
                        if not b then
                            b = Instance.new("BillboardGui", handle)
                            b.Name = "Zenith_FruitESP"
                            b.Size = UDim2.new(0, 180, 0, 30)
                            b.StudsOffset = Vector3.new(0, 2, 0)
                            b.AlwaysOnTop = true
                            local t = Instance.new("TextLabel", b)
                            t.Name = "Label"
                            t.Size = UDim2.new(1, 0, 1, 0)
                            t.BackgroundTransparency = 1
                            t.Font = Enum.Font.GothamBold
                            t.TextSize = 12
                            t.TextColor3 = Color3.fromRGB(255, 70, 220)
                            t.TextStrokeTransparency = 0
                        end
                        b.Label.Text = string.format("🍎 %s\n[%dm]", obj.Name, dist)
                    else
                        if handle:FindFirstChild("Zenith_FruitESP") then handle.Zenith_FruitESP:Destroy() end
                    end
                end
            end
        end
        
        -- Chest ESP
        for _, item in ipairs(detectedChests) do
            local rootPart, tier = item.Part, item.Tier
            if rootPart and rootPart.Parent then
                local shouldShow = (tier == 1 and espChest1Enabled) or (tier == 2 and espChest2Enabled) or (tier == 3 and espChest3Enabled)
                if shouldShow then
                    local dist = math.floor((rootPart.Position - myHRP.Position).Magnitude)
                    local b = rootPart:FindFirstChild("Zenith_ChestESP")
                    if not b then
                        b = Instance.new("BillboardGui", rootPart)
                        b.Name = "Zenith_ChestESP"
                        b.Size = UDim2.new(0, 160, 0, 25)
                        b.StudsOffset = Vector3.new(0, 2, 0)
                        b.AlwaysOnTop = true
                        local t = Instance.new("TextLabel", b)
                        t.Name = "Label"
                        t.Size = UDim2.new(1, 0, 1, 0)
                        t.BackgroundTransparency = 1
                        t.Font = Enum.Font.GothamBold
                        t.TextSize = 11
                        t.TextStrokeTransparency = 0
                    end
                    b.Label.TextColor3 = (tier == 3 and Color3.fromRGB(0, 240, 255)) or (tier == 2 and Color3.fromRGB(255, 215, 0)) or Color3.fromRGB(205, 127, 50)
                    b.Label.Text = string.format("%s [%dm]", (tier == 3 and "💎 Diamond") or (tier == 2 and "🪙 Gold") or "📦 Bronze", dist)
                else
                    if rootPart:FindFirstChild("Zenith_ChestESP") then rootPart.Zenith_ChestESP:Destroy() end
                end
            end
        end
    end
end)

-- ===================================================
-- 6. COMBAT ENGINE & FARM TWEEN (RE-ENGINEERED PERFECTLY)
-- ===================================================
local currentTween = nil
local isAttackingTarget = false

local function executeDirectSlash()
    local char = LocalPlayer.Character
    if not char then return end

    -- Active Tool
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then tool:Activate() end

    -- Bypass CombatFramework Cooldowns
    pcall(function()
        local cf = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework", 1))
        if cf and cf.activeController then
            cf.activeController.hitboxLimiter = 0
            cf.activeController.timeToNextAttack = 0
            cf.activeController.attacking = false
            cf.activeController.increment = 3
            cf.activeController:attack()
        end
    end)

    -- Auto Click Center (Safe Method)
    pcall(function()
        local midX, midY = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(midX, midY))
    end)
    if mouse1click then pcall(mouse1click) end
end

-- Vòng lặp ra đòn Tối Ưu (0.12s là chuẩn nhất để không bị kick/miss dmg)
task.spawn(function()
    while true do
        if AutoFarmLevel and isAttackingTarget then
            executeDirectSlash()
            task.wait(0.12)
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
    local speed = 300 -- Tốc độ bay an toàn
    local time = distance / speed

    if currentTween then currentTween:Cancel() end
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
end

RunService.Stepped:Connect(function()
    if (AutoFarmLevel or AutoCollectFruit) and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
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
        if item:IsA("Tool") and (item.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (item.ToolTip == "Melee" or item.ToolTip == "Combat" or item.Name == "Combat" or item.Name == "Võ Tân Binh"))) then
            return item
        end
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
            if hum and hrp and hum.Health > 0 then
                table.insert(list, mob)
            end
        end
    end
    return list
end

-- VÒNG LẶP CHÍNH: KHÓA MỤC TIÊU VÀ TẤN CÔNG
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
                        -- Nhìn thẳng vào quái vật để hitbox nhận chuẩn 100%
                        local targetCFrame = CFrame.new(clusterPosition + Vector3.new(0, 1.5, 3.5), clusterPosition)
                        local dist = (myHRP.Position - clusterPosition).Magnitude

                        if dist > 15 then
                            isAttackingTarget = false
                            toTargetPos(targetCFrame)
                        else
                            if currentTween then currentTween:Cancel() end
                            
                            -- FIX LỖI DAMAGE: Chỉ cập nhật CFrame khi bị trượt vị trí, không spam liên tục
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
-- 8. GIAO DIỆN CYBERPUNK GLASSMORPHISM (TABS FIXED)
-- ===================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentGui

local FULL_HEIGHT = 310
local MIN_HEIGHT = 38
local isMinimized = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, FULL_HEIGHT)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19)
MainFrame.BackgroundTransparency = 0.12
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UIScale = Instance.new("UIScale", MainFrame)
UIScale.Scale = 1.0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(30, 36, 50)
MainStroke.Transparency = 0.2
MainStroke.Thickness = 1.2

-- Kéo thả cửa sổ
local isDraggingWindow = false
local dragStartPos, frameStartPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingWindow = true
        dragStartPos = input.Position
        frameStartPos = MainFrame.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingWindow = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDraggingWindow and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = (input.Position - dragStartPos) / UIScale.Scale
        MainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
    end
end)

-- TopBar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0

local TopBarStroke = Instance.new("Frame", TopBar)
TopBarStroke.Size = UDim2.new(1, 0, 0, 1)
TopBarStroke.Position = UDim2.new(0, 0, 1, -1)
TopBarStroke.BackgroundColor3 = Color3.fromRGB(26, 32, 46)
TopBarStroke.BorderSizePixel = 0

local LogoIcon = Instance.new("ImageLabel", TopBar)
LogoIcon.Size = UDim2.new(0, 22, 0, 22)
LogoIcon.Position = UDim2.new(0, 10, 0.5, -11)
LogoIcon.BackgroundTransparency = 1
LogoIcon.Image = "rbxassetid://100412534591942"
LogoIcon.ScaleType = Enum.ScaleType.Fit

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 140, 1, 0)
Title.Position = UDim2.new(0, 38, 0, 0)
Title.BackgroundTransparency = 1
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
registerText(Title, "title", true)

local Badge = Instance.new("TextLabel", TopBar)
Badge.Size = UDim2.new(0, 32, 0, 16)
Badge.Position = UDim2.new(0, 172, 0.5, -8)
Badge.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
Badge.BackgroundTransparency = 0.8
Badge.TextColor3 = Color3.fromRGB(0, 210, 255)
Badge.Font = Enum.Font.GothamBold
Badge.TextSize = 9
Instance.new("UICorner", Badge).CornerRadius = UDim.new(0, 4)
local BadgeStroke = Instance.new("UIStroke", Badge)
BadgeStroke.Color = Color3.fromRGB(0, 180, 255)
BadgeStroke.Transparency = 0.5
registerText(Badge, "badge")

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -56, 0.5, -12)
MinBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(160, 170, 190)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 13
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(160, 170, 190)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(13, 15, 22)
Sidebar.BackgroundTransparency = 0.15
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 2

-- FIX TABS LỖI: Di chuyển SidebarRightBorder ra ngoài Sidebar để không bị dính vào UIListLayout
local SidebarRightBorder = Instance.new("Frame", MainFrame)
SidebarRightBorder.Size = UDim2.new(0, 1, 1, -38)
SidebarRightBorder.Position = UDim2.new(0, 139, 0, 38)
SidebarRightBorder.BackgroundColor3 = Color3.fromRGB(26, 32, 46)
SidebarRightBorder.BorderSizePixel = 0
SidebarRightBorder.ZIndex = 3

local TabListLayout = Instance.new("UIListLayout", Sidebar)
TabListLayout.Padding = UDim.new(0, 3)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local TabPadding = Instance.new("UIPadding", Sidebar)
TabPadding.PaddingTop = UDim.new(0, 6)

-- Content Container
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -140, 1, -38)
ContentContainer.Position = UDim2.new(0, 140, 0, 38)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 1

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 520, 0, MIN_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible = false
        SidebarRightBorder.Visible = false
        ContentContainer.Visible = false
        MinBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 520, 0, FULL_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible = true
        SidebarRightBorder.Visible = true
        ContentContainer.Visible = true
        MinBtn.Text = "−"
    end
end)

local tabButtons = {}
local tabPages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.BorderSizePixel = 0
    page.Visible = false
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    
    tabPages[name] = page
    return page
end

local function switchTab(name)
    for tName, item in pairs(tabButtons) do
        if tName == name then
            item.Button.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
            item.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            item.Pill.Visible = true
        else
            item.Button.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
            item.Button.TextColor3 = Color3.fromRGB(140, 148, 165)
            item.Pill.Visible = false
        end
    end
    for pName, page in pairs(tabPages) do page.Visible = (pName == name) end
end

local function createTabButton(name, icon, transKey)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.92, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(140, 148, 165)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 10)

    local pill = Instance.new("Frame", btn)
    pill.Size = UDim2.new(0, 3, 0, 14)
    pill.Position = UDim2.new(0, -7, 0.5, -7)
    pill.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
    pill.BorderSizePixel = 0
    pill.Visible = false
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local entry = {
        Label = btn, Key = transKey, Button = btn, Pill = pill,
        Update = function() btn.Text = icon .. "  " .. LangDict[currentLang][transKey] end
    }
    table.insert(translatableElements, entry)
    btn.Text = icon .. "  " .. LangDict[currentLang][transKey]
    tabButtons[name] = entry
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

local function createToggle(page, transKey, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(0.94, 0, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(28, 34, 48)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220, 225, 235)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    registerText(label, transKey)

    local switch = Instance.new("TextButton", frame)
    switch.Size = UDim2.new(0, 32, 0, 16)
    switch.Position = UDim2.new(1, -40, 0.5, -8)
    switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
    switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 12, 0, 12)
    circle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
    frame.Size = UDim2.new(0.94, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(28, 34, 48)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -70, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 3)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220, 225, 235)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    registerText(label, transKey)

    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size = UDim2.new(0, 55, 0, 20)
    valueLabel.Position = UDim2.new(1, -65, 0, 3)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(current)
    valueLabel.TextColor3 = Color3.fromRGB(0, 210, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("TextButton", frame)
    track.Size = UDim2.new(0.94, 0, 0, 4)
    track.Position = UDim2.new(0.03, 0, 0, 28)
    track.BackgroundColor3 = Color3.fromRGB(35, 42, 58)
    track.AutoButtonColor = false
    track.Text = ""
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 190, 255)
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSlider = true
            update((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingSlider = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update((UserInputService:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
        end
    end)
end

local function createButton(page, transKey, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(0.94, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    btn.TextColor3 = Color3.fromRGB(0, 210, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Transparency = 0.8
    registerText(btn, transKey)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

-- ===================================================
-- 9. KHỞI TẠO TẤT CẢ MENU
-- ===================================================
local cats = {
    {"Farm", "🌾", "tab_farm"},
    {"Fruit", "🍎", "tab_fruit"},
    {"PVP-ESP", "⚔️", "tab_pvp"},
    {"Server", "🌐", "tab_server"},
    {"RAID", "⚡", "tab_raid"},
    {"FARM ITEM", "🗡️", "tab_item"},
    {"SETTING", "⚙️", "tab_setting"}
}
for _, c in ipairs(cats) do
    createTabButton(c[1], c[2], c[3])
    createPage(c[1])
end

-- [TAB 1: FARM LEVEL]
local farmPage = tabPages["Farm"]
local infoCard = Instance.new("Frame", farmPage)
infoCard.Size = UDim2.new(0.94, 0, 0, 42)
infoCard.BackgroundColor3 = Color3.fromRGB(15, 19, 28)
infoCard.BackgroundTransparency = 0.2
Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", infoCard).Color = Color3.fromRGB(32, 40, 58)

local icBar = Instance.new("Frame", infoCard)
icBar.Size = UDim2.new(0, 3, 1, -10)
icBar.Position = UDim2.new(0, 5, 0, 5)
icBar.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
Instance.new("UICorner", icBar).CornerRadius = UDim.new(1, 0)

local infoLabel = Instance.new("TextLabel", infoCard)
infoLabel.Size = UDim2.new(1, -22, 1, 0)
infoLabel.Position = UDim2.new(0, 14, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.RichText = true
infoLabel.TextColor3 = Color3.fromRGB(230, 235, 245)
infoLabel.Font = Enum.Font.GothamMedium
infoLabel.TextSize = 10
infoLabel.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    while true do
        task.wait(1)
        local curQuest = getAutoQuestByLevel()
        local pLevel = 1
        pcall(function() pLevel = LocalPlayer.Data.Level.Value end)
        if curQuest then
            infoLabel.Text = string.format("Level: <font color='#00d2ff'><b>%d</b></font>  |  Mục Tiêu:\nQuái: <font color='#ffb703'><b>%s</b></font> (Yêu Cầu Lv.%d)", pLevel, curQuest.MonName, curQuest.ReqLevel)
        end
    end
end)

local weaponSegment = Instance.new("Frame", farmPage)
weaponSegment.Size = UDim2.new(0.94, 0, 0, 28)
weaponSegment.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
weaponSegment.BackgroundTransparency = 0.2
Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", weaponSegment).Color = Color3.fromRGB(28, 34, 48)
local wsLayout = Instance.new("UIListLayout", weaponSegment)
wsLayout.FillDirection = Enum.FillDirection.Horizontal
wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
wsLayout.Padding = UDim.new(0, 3)

local weaponBtns = {}
local weaponList = {{name = "Melee", label = "🥊 Melee"}, {name = "Sword", label = "⚔️ Sword"}, {name = "Blox Fruit", label = "🍎 Fruit"}, {name = "Gun", label = "🔫 Gun"}}
for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size = UDim2.new(0.235, 0, 0.78, 0)
    b.BackgroundColor3 = (selectedWeaponType == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(20, 24, 34)
    b.Text = wData.label
    b.TextColor3 = (selectedWeaponType == wData.name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    weaponBtns[wData.name] = b
    b.MouseButton1Click:Connect(function()
        selectedWeaponType = wData.name
        for name, btn in pairs(weaponBtns) do
            btn.BackgroundColor3 = (name == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(20, 24, 34)
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
trackerTitle.Size = UDim2.new(0.94, 0, 0, 18)
trackerTitle.BackgroundTransparency = 1
trackerTitle.TextColor3 = Color3.fromRGB(0, 210, 255)
trackerTitle.Font = Enum.Font.GothamBold
trackerTitle.TextSize = 10
trackerTitle.TextXAlignment = Enum.TextXAlignment.Left
registerText(trackerTitle, "fruit_tracker_title")

local fruitListDisplay = Instance.new("ScrollingFrame", fruitPage)
fruitListDisplay.Size = UDim2.new(0.94, 0, 0, 70)
fruitListDisplay.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
fruitListDisplay.BackgroundTransparency = 0.2
fruitListDisplay.BorderSizePixel = 0
fruitListDisplay.ScrollBarThickness = 2
fruitListDisplay.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
Instance.new("UICorner", fruitListDisplay).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", fruitListDisplay).Color = Color3.fromRGB(28, 34, 48)
local flLayout = Instance.new("UIListLayout", fruitListDisplay)
flLayout.Padding = UDim.new(0, 2)
flLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

task.spawn(function()
    while true do
        task.wait(1.5)
        for _, ch in ipairs(fruitListDisplay:GetChildren()) do if ch:IsA("TextLabel") then ch:Destroy() end end
        local foundFruits = 0
        for _, obj in ipairs(Workspace:GetChildren()) do
            if (obj:IsA("Tool") and string.find(obj.Name, "Fruit")) or obj:FindFirstChild("Fruit") then
                foundFruits = foundFruits + 1
                local item = Instance.new("TextLabel", fruitListDisplay)
                item.Size = UDim2.new(0.95, 0, 0, 18)
                item.BackgroundTransparency = 1
                item.Text = "🍎 " .. obj.Name
                item.TextColor3 = Color3.fromRGB(255, 120, 200)
                item.Font = Enum.Font.GothamMedium
                item.TextSize = 10
                item.TextXAlignment = Enum.TextXAlignment.Left
            end
        end
        if foundFruits == 0 then
            local none = Instance.new("TextLabel", fruitListDisplay)
            none.Size = UDim2.new(0.95, 0, 0, 18)
            none.BackgroundTransparency = 1
            none.Text = "• Không có trái nào rơi trên sàn"
            none.TextColor3 = Color3.fromRGB(120, 130, 145)
            none.Font = Enum.Font.Gotham
            none.TextSize = 10
            none.TextXAlignment = Enum.TextXAlignment.Left
        end
    end
end)

-- [TAB 3: PVP & ESP]
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
createButton(serverPage, "redeem_codes", function()
    task.spawn(function()
        for _, code in ipairs(gameCodes) do
            pcall(function() CommF:InvokeServer("RedeemCustomCode", code) end)
            task.wait(0.1)
        end
    end)
end)
createButton(serverPage, "rejoin_btn", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
createButton(serverPage, "serverhop_btn", function()
    local placeId = game.PlaceId
    local serversApi = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, response = pcall(function() return HttpService:JSONDecode(game:HttpGet(serversApi)) end)
    if success and response and response.data then
        for _, s in ipairs(response.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(placeId, s.id, LocalPlayer)
                break
            end
        end
    end
end)

-- [TAB 5: RAID]
local raidPage = tabPages["RAID"]
createToggle(raidPage, "auto_raid_start", false, function(v) end)
createToggle(raidPage, "auto_raid_kill", false, function(v) end)

-- [TAB 6: FARM ITEM]
local farmItemPage = tabPages["FARM ITEM"]
createToggle(farmItemPage, "auto_bones", false, function(v) end)
createToggle(farmItemPage, "auto_chest", false, function(v) end)

-- [TAB 7: SETTING]
local settingPage = tabPages["SETTING"]
local langFrame = Instance.new("Frame", settingPage)
langFrame.Size = UDim2.new(0.94, 0, 0, 36)
langFrame.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
langFrame.BackgroundTransparency = 0.2
Instance.new("UICorner", langFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", langFrame).Color = Color3.fromRGB(28, 34, 48)

local langLabel = Instance.new("TextLabel", langFrame)
langLabel.Size = UDim2.new(0.48, 0, 1, 0)
langLabel.Position = UDim2.new(0, 10, 0, 0)
langLabel.BackgroundTransparency = 1
langLabel.TextColor3 = Color3.fromRGB(220, 225, 235)
langLabel.Font = Enum.Font.Gotham
langLabel.TextSize = 11
langLabel.TextXAlignment = Enum.TextXAlignment.Left
registerText(langLabel, "lang_title")

local vnBtn = Instance.new("TextButton", langFrame)
vnBtn.Size = UDim2.new(0.22, 0, 0.7, 0)
vnBtn.Position = UDim2.new(0.52, 0, 0.15, 0)
vnBtn.BackgroundColor3 = (currentLang == "VI") and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(24, 28, 40)
vnBtn.Text = "🇻🇳 VN"
vnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
vnBtn.Font = Enum.Font.GothamBold
vnBtn.TextSize = 10
Instance.new("UICorner", vnBtn).CornerRadius = UDim.new(0, 4)

local enBtn = Instance.new("TextButton", langFrame)
enBtn.Size = UDim2.new(0.22, 0, 0.7, 0)
enBtn.Position = UDim2.new(0.76, 0, 0.15, 0)
enBtn.BackgroundColor3 = (currentLang == "EN") and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(24, 28, 40)
enBtn.Text = "🇬🇧 EN"
enBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
enBtn.Font = Enum.Font.GothamBold
enBtn.TextSize = 10
Instance.new("UICorner", enBtn).CornerRadius = UDim.new(0, 4)

vnBtn.MouseButton1Click:Connect(function()
    vnBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    enBtn.BackgroundColor3 = Color3.fromRGB(24, 28, 40)
    setLanguage("VI")
end)
enBtn.MouseButton1Click:Connect(function()
    enBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    vnBtn.BackgroundColor3 = Color3.fromRGB(24, 28, 40)
    setLanguage("EN")
end)

createSlider(settingPage, "ui_scale", 60, 140, 100, function(val) UIScale.Scale = val / 100 end)
createSlider(settingPage, "ui_transparency", 0, 80, 12, function(val)
    MainFrame.BackgroundTransparency = val / 100
    Sidebar.BackgroundTransparency = math.clamp((val + 8) / 100, 0, 1)
end)
createButton(settingPage, "fix_lag", function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    for _, v in ipairs(Lighting:GetChildren()) do if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then v.Enabled = false end end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic obj.CastShadow = false
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then obj.Enabled = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1 end
    end
end)
createButton(settingPage, "close_hub", function() ScreenGui:Destroy() end)

switchTab("Farm")
