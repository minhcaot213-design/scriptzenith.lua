-- [[ ZENITH BLOX FRUIT - V9 (REDEEM ALL CODES & DEEP CHEST SCANNER FIXED) ]] --

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

-- ===================================================
-- 0. DỌN DẸP INSTANCE CŨ (CLEANUP)
-- ===================================================
local UI_NAME = "ZenithBloxFruit_Zyrox_V9"
local function getSafeParent()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then return coreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local parentGui = getSafeParent()
if parentGui:FindFirstChild(UI_NAME) then parentGui[UI_NAME]:Destroy() end
if Workspace:FindFirstChild("Zenith_WaterPlatform") then Workspace.Zenith_WaterPlatform:Destroy() end

-- ===================================================
-- 1. HỆ THỐNG ĐA NGÔN NGỮ (VIETNAMESE / ENGLISH)
-- ===================================================
local currentLang = "VI"
local translatableElements = {}

local LangDict = {
    VI = {
        title = "ZYROX VN <font color='#00d2ff'>• ZENITH HUB</font>",
        tab_farm = "Farm",
        tab_server = "Server",
        tab_pvp = "PVP-ESP",
        tab_raid = "Raid",
        tab_item = "Farm Item",
        tab_setting = "Cài Đặt",
        
        auto_farm_level = "⚡ Auto Farm Level (Tự Theo Cấp)",
        auto_quest = "📜 Tự Động Nhận & Trả Quest",
        bring_mob = "🧲 Gom Cả Bãi Quái (Cluster Bring)",
        
        speed_toggle = "Bật Tăng Tốc Độ (WalkSpeed)",
        speed_slider = "Chỉnh Speed",
        jump_toggle = "Bật Nhảy Cao (High Jump)",
        jump_slider = "Chỉnh JumpPower",
        
        player_esp = "Định Vị Người Chơi (Tên/Máu/Khoảng Cách)",
        fruit_esp = "🍎 Định Vị Trái Ác Quỷ (Devil Fruit)",
        chest_wood = "📦 Rương Đồng/Gỗ (Tier 1)",
        chest_gold = "🪙 Rương Bạc/Vàng (Tier 2)",
        chest_diamond = "💎 Rương Kim Cương (Tier 3)",
        
        redeem_codes = "🎁 Nhập Tất Cả Code Game (Auto Redeem)",
        rejoin_btn = "Rejoin Server (Vào Lại)",
        serverhop_btn = "Server Hop (Đổi Server Khác)",
        auto_raid_start = "Tự Động Bắt Đầu Raid",
        auto_raid_kill = "Tự Đánh Quái Trong Raid",
        auto_bones = "Auto Farm Xương (Bones)",
        auto_chest = "Tự Động Nhặt Rương Gần",
        
        lang_title = "🌐 Ngôn Ngữ / Language",
        ui_scale = "Kích Thước Giao Diện (UI Scale %)",
        ui_transparency = "Độ Trong Suốt Panel (%)",
        fix_lag = "Fix Lag / Boost FPS",
        close_hub = "Tắt Giao Diện (Close Hub)"
    },
    EN = {
        title = "ZYROX VN <font color='#00d2ff'>• ZENITH HUB</font>",
        tab_farm = "Farm",
        tab_server = "Server",
        tab_pvp = "PVP-ESP",
        tab_raid = "Raid",
        tab_item = "Farm Item",
        tab_setting = "Settings",
        
        auto_farm_level = "⚡ Auto Farm Level (Auto Quest)",
        auto_quest = "📜 Auto Accept & Return Quest",
        bring_mob = "🧲 Bring Whole Mob Camp (Cluster)",
        
        speed_toggle = "Enable WalkSpeed Boost",
        speed_slider = "Adjust Speed",
        jump_toggle = "Enable High Jump",
        jump_slider = "Adjust JumpPower",
        
        player_esp = "Player ESP (Name/HP/Distance)",
        fruit_esp = "🍎 Devil Fruit ESP",
        chest_wood = "📦 Bronze/Wood Chest (Tier 1)",
        chest_gold = "🪙 Silver/Gold Chest (Tier 2)",
        chest_diamond = "💎 Diamond Chest (Tier 3)",
        
        redeem_codes = "🎁 Redeem All Game Codes",
        rejoin_btn = "Rejoin Server",
        serverhop_btn = "Server Hop (Find New)",
        auto_raid_start = "Auto Start Raid",
        auto_raid_kill = "Auto Kill Raid Mobs",
        auto_bones = "Auto Farm Bones",
        auto_chest = "Auto Collect Nearby Chests",
        
        lang_title = "🌐 Language / Ngôn Ngữ",
        ui_scale = "UI Scale (%)",
        ui_transparency = "Panel Transparency (%)",
        fix_lag = "Fix Lag / Boost FPS",
        close_hub = "Close Hub Interface"
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
            item.Label.Text = LangDict[currentLang][item.Key]
        end
    end
end

-- ===================================================
-- 2. TỰ ĐỘNG ĐỨNG TRÊN NƯỚC (ALWAYS ACTIVE)
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
-- 3. HỆ THỐNG LEVEL & NHẬN QUEST TỰ ĐỘNG
-- ===================================================
local function getAutoQuestByLevel()
    local level = 1
    pcall(function()
        if LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") then
            level = LocalPlayer.Data.Level.Value
        end
    end)

    -- SEA 1
    if level >= 1 and level <= 9 then
        return {QuestName = "BanditQuest1", QuestLevel = 1, MonName = "Bandit", ReqLevel = 1}
    elseif level >= 10 and level <= 14 then
        return {QuestName = "JungleQuest", QuestLevel = 1, MonName = "Monkey", ReqLevel = 10}
    elseif level >= 15 and level <= 29 then
        return {QuestName = "JungleQuest", QuestLevel = 2, MonName = "Gorilla", ReqLevel = 15}
    elseif level >= 30 and level <= 39 then
        return {QuestName = "BuggyQuest1", QuestLevel = 1, MonName = "Pirate", ReqLevel = 30}
    elseif level >= 40 and level <= 59 then
        return {QuestName = "BuggyQuest1", QuestLevel = 2, MonName = "Brute", ReqLevel = 40}
    elseif level >= 60 and level <= 74 then
        return {QuestName = "DesertQuest", QuestLevel = 1, MonName = "Desert Bandit", ReqLevel = 60}
    elseif level >= 75 and level <= 89 then
        return {QuestName = "DesertQuest", QuestLevel = 2, MonName = "Desert Officer", ReqLevel = 75}
    elseif level >= 90 and level <= 99 then
        return {QuestName = "SnowQuest", QuestLevel = 1, MonName = "Snow Bandit", ReqLevel = 90}
    elseif level >= 100 and level <= 119 then
        return {QuestName = "SnowQuest", QuestLevel = 2, MonName = "Snowman", ReqLevel = 100}
    elseif level >= 120 and level <= 149 then
        return {QuestName = "MarineQuest2", QuestLevel = 1, MonName = "Chief Petty Officer", ReqLevel = 120}
    elseif level >= 150 and level <= 174 then
        return {QuestName = "SkyQuest", QuestLevel = 1, MonName = "Sky Bandit", ReqLevel = 150}
    elseif level >= 175 and level <= 189 then
        return {QuestName = "SkyQuest", QuestLevel = 2, MonName = "Dark Master", ReqLevel = 175}
    elseif level >= 190 and level <= 209 then
        return {QuestName = "PrisonerQuest", QuestLevel = 1, MonName = "Prisoner", ReqLevel = 190}
    elseif level >= 210 and level <= 249 then
        return {QuestName = "PrisonerQuest", QuestLevel = 2, MonName = "Dangerous Prisoner", ReqLevel = 210}
    elseif level >= 250 and level <= 299 then
        return {QuestName = "ColosseumQuest", QuestLevel = 1, MonName = "Toga Warrior", ReqLevel = 250}
    elseif level >= 300 and level <= 374 then
        return {QuestName = "MagmaQuest", QuestLevel = 1, MonName = "Military Soldier", ReqLevel = 300}
    elseif level >= 375 and level <= 449 then
        return {QuestName = "FishmanQuest", QuestLevel = 1, MonName = "Fishman Warrior", ReqLevel = 375}
    elseif level >= 450 and level <= 524 then
        return {QuestName = "SkyExp1Quest", QuestLevel = 1, MonName = "God's Guard", ReqLevel = 450}
    elseif level >= 525 and level <= 624 then
        return {QuestName = "SkyExp2Quest", QuestLevel = 1, MonName = "Royal Squad", ReqLevel = 525}
    elseif level >= 625 and level <= 699 then
        return {QuestName = "FountainQuest", QuestLevel = 1, MonName = "Galley Pirate", ReqLevel = 625}
        
    -- SEA 2
    elseif level >= 700 and level <= 774 then
        return {QuestName = "Area1Quest", QuestLevel = 1, MonName = "Raider", ReqLevel = 700}
    elseif level >= 775 and level <= 874 then
        return {QuestName = "Area2Quest", QuestLevel = 1, MonName = "Swan Pirate", ReqLevel = 775}
    elseif level >= 875 and level <= 999 then
        return {QuestName = "MarineQuest3", QuestLevel = 1, MonName = "Marine Lieutenant", ReqLevel = 875}
    elseif level >= 1000 and level <= 1249 then
        return {QuestName = "SnowMountainQuest", QuestLevel = 1, MonName = "Snow Trooper", ReqLevel = 1000}
    elseif level >= 1250 and level <= 1499 then
        return {QuestName = "ShipQuest1", QuestLevel = 1, MonName = "Ship Deckhand", ReqLevel = 1250}
        
    -- SEA 3
    elseif level >= 1500 and level <= 1574 then
        return {QuestName = "PiratePortQuest", QuestLevel = 1, MonName = "Pirate Millionaire", ReqLevel = 1500}
    elseif level >= 1575 and level <= 1699 then
        return {QuestName = "DragonCrewQuest", QuestLevel = 1, MonName = "Dragon Crew Warrior", ReqLevel = 1575}
    elseif level >= 1700 and level <= 1899 then
        return {QuestName = "MusketeerQuest", QuestLevel = 1, MonName = "Marine Commodore", ReqLevel = 1700}
    elseif level >= 1900 and level <= 2199 then
        return {QuestName = "HauntedQuest1", QuestLevel = 1, MonName = "Reborn Skeleton", ReqLevel = 1900}
    else
        return {QuestName = "PeanutQuest", QuestLevel = 1, MonName = "Peanut Scout", ReqLevel = 2200}
    end
end

local selectedWeaponType = "Melee"
local AutoFarmLevel = false
local AutoQuest = true
local BringMob = true

-- ===================================================
-- 4. SPEED & HIGH JUMP (PVP MODULE)
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
-- 5. HỆ THỐNG ĐỊNH VỊ SÂU (DEEP SCAN CHEST, FRUIT & PLAYER ESP)
-- ===================================================
local espPlayerEnabled = false
local espFruitEnabled = false
local espChest1Enabled = false
local espChest2Enabled = false
local espChest3Enabled = false

local detectedChests = {}

-- Quét toàn bộ Descendants để phát hiện mọi loại Rương trên bản đồ
local function refreshChestList()
    detectedChests = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            local pName = obj.Parent and string.lower(obj.Parent.Name) or ""
            
            if string.find(name, "chest") or string.find(pName, "chest") then
                local tier = 1
                if string.find(name, "3") or string.find(pName, "3") or string.find(name, "diamond") or string.find(pName, "diamond") then
                    tier = 3
                elseif string.find(name, "2") or string.find(pName, "2") or string.find(name, "gold") or string.find(pName, "gold") or string.find(name, "silver") or string.find(pName, "silver") then
                    tier = 2
                else
                    tier = 1
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
                    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    txt.Parent = bbGui
                end
                
                local hpPercent = math.floor((hum.Health / hum.MaxHealth) * 100)
                local txtLabel = bbGui:FindFirstChild("Info")
                if txtLabel then
                    txtLabel.Text = string.format("%s\n[%dm] • HP: %d/%d (%d%%)", p.DisplayName, dist, math.floor(hum.Health), math.floor(hum.MaxHealth), hpPercent)
                end
                
                local highlight = char:FindFirstChild("Zenith_Highlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "Zenith_Highlight"
                    highlight.FillColor = Color3.fromRGB(255, 45, 85)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Adornee = char
                    highlight.Parent = char
                end
            else
                if head and head:FindFirstChild("Zenith_PlayerBillboard") then
                    head.Zenith_PlayerBillboard:Destroy()
                end
                if char:FindFirstChild("Zenith_Highlight") then
                    char.Zenith_Highlight:Destroy()
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.15)
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        
        updatePlayerESP()
        
        if myHRP then
            -- Fruit ESP
            for _, obj in ipairs(Workspace:GetChildren()) do
                if (obj:IsA("Tool") and string.find(obj.Name, "Fruit")) or obj:FindFirstChild("Fruit") then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        if espFruitEnabled then
                            local dist = math.floor((handle.Position - myHRP.Position).Magnitude)
                            local b = handle:FindFirstChild("Zenith_FruitESP")
                            if not b then
                                b = Instance.new("BillboardGui")
                                b.Name = "Zenith_FruitESP"
                                b.Size = UDim2.new(0, 180, 0, 30)
                                b.StudsOffset = Vector3.new(0, 2, 0)
                                b.AlwaysOnTop = true
                                b.Adornee = handle
                                b.Parent = handle
                                
                                local t = Instance.new("TextLabel")
                                t.Name = "Label"
                                t.Size = UDim2.new(1, 0, 1, 0)
                                t.BackgroundTransparency = 1
                                t.Font = Enum.Font.GothamBold
                                t.TextSize = 12
                                t.TextColor3 = Color3.fromRGB(255, 70, 220)
                                t.TextStrokeTransparency = 0
                                t.Parent = b
                            end
                            b.Label.Text = string.format("🍎 %s\n[%dm]", obj.Name, dist)
                        else
                            if handle:FindFirstChild("Zenith_FruitESP") then
                                handle.Zenith_FruitESP:Destroy()
                            end
                        end
                    end
                end
            end
            
            -- Deep Chest ESP Scanner
            for _, item in ipairs(detectedChests) do
                local rootPart = item.Part
                local tier = item.Tier
                
                if rootPart and rootPart.Parent then
                    local shouldShow = (tier == 1 and espChest1Enabled) or (tier == 2 and espChest2Enabled) or (tier == 3 and espChest3Enabled)
                    local chestColor = (tier == 3 and Color3.fromRGB(0, 240, 255)) or (tier == 2 and Color3.fromRGB(255, 215, 0)) or Color3.fromRGB(205, 127, 50)
                    local chestTitle = (tier == 3 and "💎 Diamond Chest") or (tier == 2 and "🪙 Gold Chest") or "📦 Bronze Chest"
                    
                    if shouldShow then
                        local dist = math.floor((rootPart.Position - myHRP.Position).Magnitude)
                        local b = rootPart:FindFirstChild("Zenith_ChestESP")
                        if not b then
                            b = Instance.new("BillboardGui")
                            b.Name = "Zenith_ChestESP"
                            b.Size = UDim2.new(0, 160, 0, 25)
                            b.StudsOffset = Vector3.new(0, 2, 0)
                            b.AlwaysOnTop = true
                            b.Adornee = rootPart
                            b.Parent = rootPart
                            
                            local t = Instance.new("TextLabel")
                            t.Name = "Label"
                            t.Size = UDim2.new(1, 0, 1, 0)
                            t.BackgroundTransparency = 1
                            t.Font = Enum.Font.GothamBold
                            t.TextSize = 11
                            t.TextStrokeTransparency = 0
                            t.Parent = b
                        end
                        b.Label.TextColor3 = chestColor
                        b.Label.Text = string.format("%s [%dm]", chestTitle, dist)
                    else
                        if rootPart:FindFirstChild("Zenith_ChestESP") then
                            rootPart.Zenith_ChestESP:Destroy()
                        end
                    end
                end
            end
        end
    end
end)

-- ===================================================
-- 6. COMBAT ENGINE: FAST ATTACK CHO GIẢ LẬP & GOM CẢ BÃI
-- ===================================================
local currentTween = nil
local isAttackingTarget = false

local function performDirectAttack()
    local char = LocalPlayer.Character
    if not char then return end

    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            item:Activate()
        end
    end

    local camera = Workspace.CurrentCamera
    local vp = camera and camera.ViewportSize or Vector2.new(800, 600)
    local cx, cy = vp.X / 2, vp.Y / 2

    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
        task.wait()
        VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
    end)

    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(cx, cy))
    end)

    pcall(function()
        if mouse1click then mouse1click() end
    end)
end

task.spawn(function()
    while true do
        if AutoFarmLevel and isAttackingTarget then
            performDirectAttack()
            task.wait(0.04)
        else
            task.wait(0.12)
        end
    end
end)

local function toTargetPos(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    local distance = (root.Position - targetCFrame.Position).Magnitude
    local speed = 260
    local time = distance / speed

    if currentTween then currentTween:Cancel() end
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
end

RunService.Stepped:Connect(function()
    if AutoFarmLevel and LocalPlayer.Character then
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
        if item:IsA("Tool") then
            if item.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (item.ToolTip == "Melee" or item.ToolTip == "Combat" or item.Name == "Combat" or item.Name == "Võ Tân Binh")) then
                return item
            end
        end
    end

    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if tool.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (tool.ToolTip == "Melee" or tool.ToolTip == "Combat" or tool.Name == "Combat" or tool.Name == "Võ Tân Binh")) then
                    humanoid:EquipTool(tool)
                    return tool
                end
            end
        end
        local firstTool = backpack:FindFirstChildOfClass("Tool")
        if firstTool then
            humanoid:EquipTool(firstTool)
            return firstTool
        end
    end
    return nil
end

local function checkHasQuest()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui and playerGui:FindFirstChild("Main") then
        local questFrame = playerGui.Main:FindFirstChild("Quest")
        if questFrame and questFrame.Visible then return true end
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

-- VÒNG LẶP CHÍNH: TỰ ĐỘNG BAY TỚI ĐẢO, GOM CẢ BÃI VÀ ĐÁNH LIÊN TỤC
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
                        local targetCFrame = CFrame.new(clusterPosition + Vector3.new(0, 4.5, 0), clusterPosition)
                        local dist = (myHRP.Position - clusterPosition).Magnitude

                        if dist > 14 then
                            isAttackingTarget = false
                            toTargetPos(targetCFrame)
                        else
                            if currentTween then currentTween:Cancel() end
                            myHRP.CFrame = targetCFrame
                            myHRP.AssemblyLinearVelocity = Vector3.zero
                            isAttackingTarget = true

                            if BringMob then
                                for _, otherMob in ipairs(mobList) do
                                    local oHRP = otherMob:FindFirstChild("HumanoidRootPart")
                                    local oHum = otherMob:FindFirstChildOfClass("Humanoid")
                                    if oHRP and oHum and oHum.Health > 0 then
                                        local d = (oHRP.Position - clusterPosition).Magnitude
                                        if d <= 320 then
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
-- 7. GIAO DIỆN PANEL (TRANSLUCENT + MULTILINGUAL)
-- ===================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentGui

local FULL_HEIGHT = 310
local MIN_HEIGHT = 34
local isMinimized = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, FULL_HEIGHT)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
MainFrame.BackgroundTransparency = 0.18
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UIScale = Instance.new("UIScale")
UIScale.Scale = 1.0
UIScale.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 55, 75)
MainStroke.Transparency = 0.3
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

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
        MainFrame.Position = UDim2.new(
            frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
            frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y
        )
    end
end)

-- TopBar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 34)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
TopBar.BackgroundTransparency = 0.15
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local LogoIcon = Instance.new("ImageLabel")
LogoIcon.Size = UDim2.new(0, 24, 0, 24)
LogoIcon.Position = UDim2.new(0, 8, 0.5, -12)
LogoIcon.BackgroundTransparency = 1
LogoIcon.Image = "rbxassetid://100412534591942"
LogoIcon.ScaleType = Enum.ScaleType.Fit
LogoIcon.Parent = TopBar

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 4)
LogoCorner.Parent = LogoIcon

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.new(0, 38, 0, 0)
Title.BackgroundTransparency = 1
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar
registerText(Title, "title", true)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -56, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(28, 33, 46)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 13
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -28, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 33, 46)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 125, 1, -34)
Sidebar.Position = UDim2.new(0, 0, 0, 34)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
Sidebar.BackgroundTransparency = 0.25
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 3)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.Parent = Sidebar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 6)
TabPadding.Parent = Sidebar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -125, 1, -34)
ContentContainer.Position = UDim2.new(0, 125, 0, 34)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 500, 0, MIN_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible = false
        ContentContainer.Visible = false
        MinBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 500, 0, FULL_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible = true
        ContentContainer.Visible = true
        MinBtn.Text = "−"
    end
end)

local tabButtons = {}
local tabPages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.BorderSizePixel = 0
    page.Visible = false
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = ContentContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = page

    tabPages[name] = page
    return page
end

local function switchTab(name)
    for tName, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = (tName == name) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(24, 26, 35)
        btn.TextColor3 = (tName == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 165, 180)
    end
    for pName, page in pairs(tabPages) do
        page.Visible = (pName == name)
    end
end

local function createTabButton(name, icon, transKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(24, 26, 35)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(160, 165, 180)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.Parent = Sidebar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn

    table.insert(translatableElements, {
        Label = btn,
        Key = transKey,
        Update = function()
            btn.Text = icon .. " " .. LangDict[currentLang][transKey]
        end
    })
    btn.Text = icon .. " " .. LangDict[currentLang][transKey]

    tabButtons[name] = btn
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

local function createToggle(page, transKey, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    registerText(label, transKey)

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 34, 0, 17)
    switch.Position = UDim2.new(1, -42, 0.5, -8)
    switch.BackgroundColor3 = state and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(45, 48, 65)
    switch.Text = ""
    switch.BorderSizePixel = 0
    switch.Parent = frame

    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = switch

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 11, 0, 11)
    circle.Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = switch

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(1, 0)
    cc.Parent = circle

    switch.MouseButton1Click:Connect(function()
        state = not state
        switch.BackgroundColor3 = state and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(45, 48, 65)
        circle.Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
        if callback then callback(state) end
    end)
end

local function createSlider(page, transKey, min, max, default, callback)
    local current = default or min
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 46)
    frame.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 3)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    registerText(label, transKey)

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 55, 0, 20)
    valueLabel.Position = UDim2.new(1, -65, 0, 3)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(current)
    valueLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local track = Instance.new("TextButton")
    track.Size = UDim2.new(0.94, 0, 0, 4)
    track.Position = UDim2.new(0.03, 0, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(45, 48, 65)
    track.AutoButtonColor = false
    track.BorderSizePixel = 0
    track.Text = ""
    track.Parent = frame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSlider = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = UserInputService:GetMouseLocation().X
            update((mouseX - track.AbsolutePosition.X) / track.AbsoluteSize.X)
        end
    end)
end

local function createButton(page, transKey, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(26, 30, 42)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(0, 180, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.Parent = page
    registerText(btn, transKey)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- ===================================================
-- 8. TẠO 6 DANH MỤC (TABS SETUP)
-- ===================================================
local cats = {
    {"Farm", "🌾", "tab_farm"},
    {"Server", "🌐", "tab_server"},
    {"PVP-ESP", "⚔️", "tab_pvp"},
    {"RAID", "⚡", "tab_raid"},
    {"FARM ITEM", "🗡️", "tab_item"},
    {"SETTING", "⚙️", "tab_setting"}
}
for _, c in ipairs(cats) do
    createTabButton(c[1], c[2], c[3])
    createPage(c[1])
end

-- [TAB 1: FARM] (AUTO LEVEL FARM)
local farmPage = tabPages["Farm"]

local infoCard = Instance.new("Frame")
infoCard.Size = UDim2.new(0.92, 0, 0, 48)
infoCard.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
infoCard.BackgroundTransparency = 0.2
infoCard.BorderSizePixel = 0
infoCard.Parent = farmPage

local icCorner = Instance.new("UICorner")
icCorner.CornerRadius = UDim.new(0, 6)
icCorner.Parent = infoCard

local icStroke = Instance.new("UIStroke")
icStroke.Color = Color3.fromRGB(0, 180, 255)
icStroke.Transparency = 0.7
icStroke.Parent = infoCard

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -16, 1, 0)
infoLabel.Position = UDim2.new(0, 8, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.RichText = true
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.Font = Enum.Font.GothamMedium
infoLabel.TextSize = 11
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = infoCard

task.spawn(function()
    while true do
        task.wait(1)
        local curQuest = getAutoQuestByLevel()
        local pLevel = 1
        pcall(function() pLevel = LocalPlayer.Data.Level.Value end)
        if curQuest then
            infoLabel.Text = string.format("Level: <font color='#00d2ff'>%d</font> | Auto Target:\nQuái: <font color='#ffb703'>%s</font> (Lv. %d)", pLevel, curQuest.MonName, curQuest.ReqLevel)
        end
    end
end)

local weaponFrame = Instance.new("Frame")
weaponFrame.Size = UDim2.new(0.92, 0, 0, 30)
weaponFrame.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
weaponFrame.BackgroundTransparency = 0.3
weaponFrame.BorderSizePixel = 0
weaponFrame.Parent = farmPage

local wCorner = Instance.new("UICorner")
wCorner.CornerRadius = UDim.new(0, 5)
wCorner.Parent = weaponFrame

local wLayout = Instance.new("UIListLayout")
wLayout.FillDirection = Enum.FillDirection.Horizontal
wLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
wLayout.VerticalAlignment = Enum.VerticalAlignment.Center
wLayout.Padding = UDim.new(0, 4)
wLayout.Parent = weaponFrame

local weaponBtns = {}
local weaponList = {
    {name = "Melee", label = "🥊 Melee"},
    {name = "Sword", label = "⚔️ Sword"},
    {name = "Blox Fruit", label = "🍎 Fruit"},
    {name = "Gun", label = "🔫 Gun"}
}

for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.23, 0, 0.75, 0)
    b.BackgroundColor3 = (selectedWeaponType == wData.name) and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(32, 35, 48)
    b.Text = wData.label
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 10
    b.BorderSizePixel = 0
    b.Parent = weaponFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = b

    weaponBtns[wData.name] = b
    b.MouseButton1Click:Connect(function()
        selectedWeaponType = wData.name
        for name, btn in pairs(weaponBtns) do
            btn.BackgroundColor3 = (name == wData.name) and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(32, 35, 48)
        end
    end)
end

createToggle(farmPage, "auto_farm_level", false, function(v) AutoFarmLevel = v end)
createToggle(farmPage, "auto_quest", true, function(v) AutoQuest = v end)
createToggle(farmPage, "bring_mob", true, function(v) BringMob = v end)

-- [TAB 2: PVP-ESP]
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

-- [TAB 3: SERVER]
local serverPage = tabPages["Server"]

-- TÍNH NĂNG NHẬP TOÀN BỘ CODE GAME
local gameCodes = {
    "ADMINHACKED", "ADMINDARES", "SECRET_ADMIN", "NOOB2PRO", "StrawHatMaine",
    "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo",
    "Bluxxy", "THEGREATACE", "SUB2GAMERROBOT_EXP1", "Sub2OfficialNoobie",
    "FUDD10", "BIGNEWS", "KITT_RESET", "SUB2NOOBMASTER123", "Sub2UncleKizaru",
    "Sub2Daigrock", "Axiore", "TantaiGaming", "FUDD10_V2", "CHANDLER",
    "GAMER_ROBOT_1M", "TY_FOR_WATCHING", "UPD16", "3BVISITS", "2BILLION"
}

createButton(serverPage, "redeem_codes", function()
    task.spawn(function()
        for _, code in ipairs(gameCodes) do
            pcall(function()
                CommF:InvokeServer("RedeemCustomCode", code)
            end)
            task.wait(0.1)
        end
    end)
end)

createButton(serverPage, "rejoin_btn", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

createButton(serverPage, "serverhop_btn", function()
    local placeId = game.PlaceId
    local serversApi = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(serversApi))
    end)
    if success and response and response.data then
        for _, s in ipairs(response.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(placeId, s.id, LocalPlayer)
                break
            end
        end
    end
end)

-- [TAB 4: RAID]
local raidPage = tabPages["RAID"]
createToggle(raidPage, "auto_raid_start", false, function(v) end)
createToggle(raidPage, "auto_raid_kill", false, function(v) end)

-- [TAB 5: FARM ITEM]
local farmItemPage = tabPages["FARM ITEM"]
createToggle(farmItemPage, "auto_bones", false, function(v) end)
createToggle(farmItemPage, "auto_chest", false, function(v) end)

-- [TAB 6: SETTING]
local settingPage = tabPages["SETTING"]

local langFrame = Instance.new("Frame")
langFrame.Size = UDim2.new(0.92, 0, 0, 46)
langFrame.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
langFrame.BackgroundTransparency = 0.3
langFrame.BorderSizePixel = 0
langFrame.Parent = settingPage

local langCorner = Instance.new("UICorner")
langCorner.CornerRadius = UDim.new(0, 5)
langCorner.Parent = langFrame

local langLabel = Instance.new("TextLabel")
langLabel.Size = UDim2.new(0.48, 0, 1, 0)
langLabel.Position = UDim2.new(0, 10, 0, 0)
langLabel.BackgroundTransparency = 1
langLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
langLabel.Font = Enum.Font.Gotham
langLabel.TextSize = 11
langLabel.TextXAlignment = Enum.TextXAlignment.Left
langLabel.Parent = langFrame
registerText(langLabel, "lang_title")

local vnBtn = Instance.new("TextButton")
vnBtn.Size = UDim2.new(0.22, 0, 0.7, 0)
vnBtn.Position = UDim2.new(0.52, 0, 0.15, 0)
vnBtn.BackgroundColor3 = (currentLang == "VI") and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(35, 40, 55)
vnBtn.Text = "🇻🇳 VN"
vnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
vnBtn.Font = Enum.Font.GothamBold
vnBtn.TextSize = 10
vnBtn.BorderSizePixel = 0
vnBtn.Parent = langFrame

local vnC = Instance.new("UICorner")
vnC.CornerRadius = UDim.new(0, 4)
vnC.Parent = vnBtn

local enBtn = Instance.new("TextButton")
enBtn.Size = UDim2.new(0.22, 0, 0.7, 0)
enBtn.Position = UDim2.new(0.76, 0, 0.15, 0)
enBtn.BackgroundColor3 = (currentLang == "EN") and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(35, 40, 55)
enBtn.Text = "🇬🇧 EN"
enBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
enBtn.Font = Enum.Font.GothamBold
enBtn.TextSize = 10
enBtn.BorderSizePixel = 0
enBtn.Parent = langFrame

local enC = Instance.new("UICorner")
enC.CornerRadius = UDim.new(0, 4)
enC.Parent = enBtn

vnBtn.MouseButton1Click:Connect(function()
    vnBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    enBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
    setLanguage("VI")
    for _, item in ipairs(translatableElements) do
        if item.Update then item.Update() end
    end
end)

enBtn.MouseButton1Click:Connect(function()
    enBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    vnBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
    setLanguage("EN")
    for _, item in ipairs(translatableElements) do
        if item.Update then item.Update() end
    end
end)

createSlider(settingPage, "ui_scale", 60, 140, 100, function(val)
    UIScale.Scale = val / 100
end)

createSlider(settingPage, "ui_transparency", 0, 80, 18, function(val)
    MainFrame.BackgroundTransparency = val / 100
    Sidebar.BackgroundTransparency = math.clamp((val + 10) / 100, 0, 1)
end)

createButton(settingPage, "fix_lag", function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1

    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then
            v.Enabled = false
        end
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
            obj.Enabled = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end
end)

createButton(settingPage, "close_hub", function()
    ScreenGui:Destroy()
end)

switchTab("Farm")
