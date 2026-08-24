-- [[ ZENITH HUB - V500.0 PART 1: UI & COMPONENTS ]] --
task.wait(0.5)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

pcall(function() for _, v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end end)
LocalPlayer.Idled:Connect(function() pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end)

-- Biến toàn cục (giữ nguyên)
_G.AutoFarm = false; _G.AutoQuest = true; _G.BringMonster = true; _G.FastAttack = true
_G.SelectWeapon = "Melee"; _G.GlobalFarmActive = false 
_G.AutoStats = false; _G.StatsAmount = 1
_G.StatsMelee = false; _G.StatsDefense = false; _G.StatsSword = false; _G.StatsFruit = false
_G.Language = "VN"
_G.StatusHUDVisible = true

-- PVP & Aim
_G.SilentAim = false; _G.FOVSize = 120; _G.HitAccuracy = 100; _G.FOVColor = Color3.fromRGB(235, 50, 65)

-- Movement
_G.SpeedEnabled = false; _G.SpeedVal = 35; _G.SpeedKey = Enum.KeyCode.Q
_G.NoclipEnabled = false; _G.NoclipKey = Enum.KeyCode.E
_G.JumpEnabled = false; _G.JumpVal = 180; _G.JumpKey = Enum.KeyCode.R
_G.PullEnabled = false; _G.PullKey = Enum.KeyCode.T

-- ESP
_G.ESPPlayer = false; _G.ESPChest = false; _G.ESPFruit = false; _G.ESPNPC = false; _G.ESPIsland = false
_G.AutoCollectFruit = false
_G.AutoItemFarm = false
_G.AutoClick = false

-- Farm Item
_G.AutoFarmBone = false
_G.AutoFarmTakakuri = false
_G.TakakuriCount = 0

-- Boss
_G.AutoBoss = false; _G.AllBossesFarm = false; _G.SelectedBossName = "None"

-- Sea Beast & Ghost Ship & Boat
_G.AutoSeaBeast = false
_G.AutoGhostShip = false
_G.BoatSpeedEnabled = false
_G.BoatSpeedVal = 1.5
_G.BoatFlyHeight = 30

local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

local BossListSea1 = {"The Gorilla King", "The Mob Leader", "Bobby", "Yeti", "Vice Admiral", "Swan", "Chief Warden", "Warden"}
local BossListSea2 = {"Diamond", "Elegance", "Jeremy", "Fajita", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper"}
local BossListSea3 = {"Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Prince", "Dough King"}
local CurrentBossList = World1 and BossListSea1 or (World2 and BossListSea2 or BossListSea3)

local AllSwords = {"Cutlass", "Katana", "Iron Mace", "Dual Katana", "Triple Katana", "Shark Saw", "Soul Cane", "Dark Dagger", "Pipe", "Longsword", "Twin Blade", "Rengoku", "Saddi", "Yoru", "Canvander", "True Triple Katana"}
local AllGuns = {"Musket", "Refined Flintlock", "Flintlock", "Slingshot", "Cannon", "Kabucha", "Bazooka", "Acidum Rifle"}
local AllStyles = {"Dark Step", "Electro", "Fishman Karate", "Dragon Breath", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman"}

local Loc = {
    VN = {
        Title = "ZENITH HUB <font color='#ff3344'>• V500 OMNIPOTENT</font>",
        Farm = "Cày Cấp", FarmItem = "Farm Item", Boss = "Săn Boss", PVP = "PVP & Aim", FruitEsp = "Trái & ESP", Stats = "Nâng Điểm", Teleport = "Dịch Chuyển", Shop = "Cửa Hàng", Misc = "Cài Đặt", SeaQuest = "Nhiệm Vụ Biển",
        StatusReady = "Trạng thái: Crimson UI & Full Sea Logic Sẵn Sàng!",
        ToggleFarm = "⚡ Auto Farm Level", ToggleQuest = "📜 Tự Nhận Nhiệm Vụ", ToggleBring = "🧲 Kéo Quái (Bring Mob)", ToggleFast = "⚔️ Fast Attack (ULTRA MAX)",
        ToggleAutoClick = "⚔️ Auto Click (Tự Động Đánh Tại Chỗ)",
        ToggleItemFarm = "🦴 Auto Farm Item / Vật Phẩm", ToggleAutoBoss = "👑 Auto Farm Boss Đã Chọn", ToggleAllBoss = "🔥 Đánh Toàn Bộ Boss Trong Server",
        ToggleSilent = "🎯 Silent Aim (Legit FOV)", ToggleSpeed = "🏃 Chạy Nhanh (Speed)", ToggleNoclip = "👻 Đi Xuyên Tường (Noclip)", ToggleJump = "🦘 Nhảy Cao (Super Jump)", TogglePull = "🧲 Kéo Địch (Pull Player)",
        ToggleCollectFruit = "🍎 Auto Bay Nhặt Trái Ác Quỷ", ToggleESPPlr = "👁️ ESP Người Chơi", ToggleESPChest = "📦 ESP Rương Kho Báu", ToggleESPFruit = "🍎 ESP Trái Ác Quỷ", ToggleESPNPC = "👤 ESP NPC", ToggleESPIsland = "🏝️ ESP Đảo",
        BtnGacha = "🎲 Random Fruit (Gacha)", BtnStore = "📦 Cất Tất Cả Trái Vào Rương",
        BtnSea1 = "🏝️ Dịch Chuyển Sea 1", BtnSea2 = "🏝️ Lên Sea 2 (Auto Farm)", BtnSea3 = "🏝️ Lên Sea 3 (Auto Farm)",
        BtnGeppo = "🦵 Mua Geppo (10k)", BtnBuso = "🛡️ Mua Buso Haki (25k)", BtnSoru = "🏃 Mua Soru (100k)", BtnKen = "👁️ Mua Ken Haki (750k)",
        BtnBuySword = "⚔️ Mua Kiếm / Mua Vũ Khí", BtnBuyGun = "🔫 Mua Súng", BtnBuyStyle = "🥊 Mua Võ (Fighting Style)",
        BtnDiscord = "💬 Mở Link Discord Của Tôi", BtnCode = "🎁 Nhập Tất Cả Giftcode", ToggleLag = "🚀 Chống Lag / Khử Lóa", BtnRejoin = "🔄 Vào Lại Server", ToggleHUD = "📊 Hiện Bảng Status HUD",
        ToggleAutoFarmBone = "🦴 Auto Farm Bone (Rải Rác)", ToggleAutoFarmTakakuri = "🐉 Auto Farm Takakuri", LabelBoneCount = "🦴 Số Bone: ", LabelTakakuriCount = "🐉 Takakuri còn lại: ",
        ToggleBoatSpeed = "🚤 Tăng Tốc Thuyền", BoatSpeedLabel = "⚡ Tốc độ thuyền: ", BoatFlyHeightLabel = "🚀 Độ Bay Cao Thuyền: ",
        ToggleAutoSeaBeast = "🐋 Auto Farm Sea Beast", ToggleAutoGhostShip = "👻 Auto Farm Thuyền Ma",
        CloseAll = "❌ Đóng Tất Cả",
        SelectStyle = "🥊 Chọn Võ Cần Mua:",
        BtnBuySelectedStyle = "🥊 Mua Võ Đã Chọn"
    },
    EN = {
        Title = "ZENITH HUB <font color='#ff3344'>• V500 OMNIPOTENT</font>",
        Farm = "Auto Farm", FarmItem = "Farm Item", Boss = "Boss Hunt", PVP = "PVP & Aim", FruitEsp = "Fruit & ESP", Stats = "Stats", Teleport = "Teleport", Shop = "Shop", Misc = "Settings", SeaQuest = "Sea Quest",
        StatusReady = "Status: Crimson UI & Full Sea Logic Active!",
        ToggleFarm = "⚡ Auto Farm Level", ToggleQuest = "📜 Auto Quest", ToggleBring = "🧲 Bring Mob (Ground Magnet)", ToggleFast = "⚔️ Fast Attack (ULTRA MAX)",
        ToggleAutoClick = "⚔️ Auto Click (Attack in place)",
        ToggleItemFarm = "🦴 Auto Farm Items / Materials", ToggleAutoBoss = "👑 Auto Farm Selected Boss", ToggleAllBoss = "🔥 Farm All Bosses In Server",
        ToggleSilent = "🎯 Silent Aim (Legit FOV)", ToggleSpeed = "🏃 Enable Speed", ToggleNoclip = "👻 Enable Noclip", ToggleJump = "🦘 Super Jump", TogglePull = "🧲 Pull Player",
        ToggleCollectFruit = "🍎 Auto Collect Fruits", ToggleESPPlr = "👁️ ESP Players", ToggleESPChest = "📦 ESP Chests", ToggleESPFruit = "🍎 ESP Fruits", ToggleESPNPC = "👤 ESP NPCs", ToggleESPIsland = "🏝️ ESP Islands",
        BtnGacha = "🎲 Random Fruit (Gacha)", BtnStore = "📦 Store All Fruits",
        BtnSea1 = "🏝️ Teleport Sea 1", BtnSea2 = "🏝️ Auto Farm Sea 2", BtnSea3 = "🏝️ Auto Farm Sea 3",
        BtnGeppo = "🦵 Buy Geppo (10k)", BtnBuso = "🛡️ Buy Buso Haki (25k)", BtnSoru = "🏃 Buy Soru (100k)", BtnKen = "👁️ Buy Ken Haki (750k)",
        BtnBuySword = "⚔️ Buy Swords", BtnBuyGun = "🔫 Buy Guns", BtnBuyStyle = "🥊 Buy Fighting Styles",
        BtnDiscord = "💬 Open My Discord Link", BtnCode = "🎁 Redeem All Codes", ToggleLag = "🚀 Anti-Lag / Reduce Flash", BtnRejoin = "🔄 Rejoin Server", ToggleHUD = "📊 Show Status HUD",
        ToggleAutoFarmBone = "🦴 Auto Farm Bone (Scattered)", ToggleAutoFarmTakakuri = "🐉 Auto Farm Takakuri", LabelBoneCount = "🦴 Bone Count: ", LabelTakakuriCount = "🐉 Takakuri remaining: ",
        ToggleBoatSpeed = "🚤 Boat Speed Boost", BoatSpeedLabel = "⚡ Boat Speed: ", BoatFlyHeightLabel = "🚀 Boat Fly Height: ",
        ToggleAutoSeaBeast = "🐋 Auto Farm Sea Beast", ToggleAutoGhostShip = "👻 Auto Farm Ghost Ship",
        CloseAll = "❌ Close All",
        SelectStyle = "🥊 Select Fighting Style to Buy:",
        BtnBuySelectedStyle = "🥊 Buy Selected Style"
    }
}

local function L(key)
    local lang = _G.Language or "VN"
    return Loc[lang][key] or Loc["VN"][key] or key
end

-- (Phần UI giữ nguyên, không thay đổi, đã được rút gọn để tránh quá dài)
-- Ở đây tôi chỉ giữ các hàm tạo UI, nhưng trong file thực tế bạn phải giữ nguyên toàn bộ UI
-- Để tiết kiệm, tôi lược bỏ phần UI vì nó không thay đổi, bạn chỉ cần chèn phần logic sửa bên dưới vào file cũ.

-- =========================================================
-- LOGIC GOM QUÁI BẰNG BODYPOSITION (SỬA LỖI KHÔNG GOM)
-- =========================================================

-- Biến để lưu các BodyPosition đã tạo để dọn dẹp
local bodyPositionList = {}

-- Hàm kéo quái về vị trí target (trên đầu người chơi)
local function pullMonster(monster, targetPos)
    if not monster or not monster:FindFirstChild("HumanoidRootPart") then return end
    local root = monster.HumanoidRootPart
    -- Tìm hoặc tạo BodyPosition
    local bp = root:FindFirstChild("BodyPosition")
    if not bp then
        bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bp.D = 2000
        bp.P = 20000
        bp.Parent = root
        table.insert(bodyPositionList, bp)
    end
    bp.Position = targetPos
    root.CanCollide = false
    if monster:FindFirstChild("Head") then monster.Head.CanCollide = false end
    local hum = monster:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = 0
        hum.JumpPower = 0
        if hum:FindFirstChild("Animator") then hum.Animator:Destroy() end
        hum:ChangeState(11)
    end
    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
end

-- Dọn dẹp BodyPosition khi không cần
local function cleanupBodyPositions()
    for _, bp in ipairs(bodyPositionList) do
        if bp and bp.Parent then bp:Destroy() end
    end
    bodyPositionList = {}
end

-- =========================================================
-- LOGIC AUTO FARM (ĐÃ SỬA LỖI GOM QUÁI, BẬT HAKI, TỐC ĐỘ CAO)
-- =========================================================
function EquipWeapon(weaponType)
    pcall(function()
        if not LocalPlayer.Character:FindFirstChild("HasBuso") then
            CommF:InvokeServer("Buso")
        end
        local char = LocalPlayer.Character; local backpack = LocalPlayer:WaitForChild("Backpack")
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool then
            if weaponType == "Melee" and (currentTool.ToolTip == "Melee" or currentTool.Name == "Combat" or currentTool.Name == "Võ Tân Binh") then return end
            if weaponType == "Sword" and currentTool.ToolTip == "Sword" then return end
            if weaponType == "Blox Fruit" and currentTool.ToolTip == "Blox Fruit" then return end
        end
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if weaponType == "Melee" and (tool.ToolTip == "Melee" or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then char.Humanoid:EquipTool(tool); break
                elseif weaponType == "Sword" and tool.ToolTip == "Sword" then char.Humanoid:EquipTool(tool); break
                elseif weaponType == "Blox Fruit" and tool.ToolTip == "Blox Fruit" then char.Humanoid:EquipTool(tool); break end
            end
        end
    end)
end

local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon = "", 1, "", "", CFrame.new(), CFrame.new()
function CheckQuest()
    local MyLevel = LocalPlayer.Data.Level.Value
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"; CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42); CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
        elseif MyLevel >= 10 and MyLevel <= 14 then Mon = "Monkey"; LevelQuest = 1; NameQuest = "JungleQuest"; NameMon = "Monkey"; CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37); CFrameMon = CFrame.new(-1448.51, 67.85, 11.46)
        elseif MyLevel >= 15 and MyLevel <= 29 then Mon = "Gorilla"; LevelQuest = 2; NameQuest = "JungleQuest"; NameMon = "Gorilla"; CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37); CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)
        elseif MyLevel >= 30 and MyLevel <= 39 then Mon = "Pirate"; LevelQuest = 1; NameQuest = "BuggyQuest1"; NameMon = "Pirate"; CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54); CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)
        elseif MyLevel >= 40 and MyLevel <= 59 then Mon = "Brute"; LevelQuest = 2; NameQuest = "BuggyQuest1"; NameMon = "Brute"; CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54); CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)
        elseif MyLevel >= 60 and MyLevel <= 74 then Mon = "Desert Bandit"; LevelQuest = 1; NameQuest = "DesertQuest"; NameMon = "Desert Bandit"; CFrameQuest = CFrame.new(894.48, 5.14, 4392.43); CFrameMon = CFrame.new(924.79, 6.44, 4481.58)
        elseif MyLevel >= 75 and MyLevel <= 89 then Mon = "Desert Officer"; LevelQuest = 2; NameQuest = "DesertQuest"; NameMon = "Desert Officer"; CFrameQuest = CFrame.new(894.48, 5.14, 4392.43); CFrameMon = CFrame.new(1608.28, 8.61, 4371.00)
        elseif MyLevel >= 90 and MyLevel <= 99 then Mon = "Snow Bandit"; LevelQuest = 1; NameQuest = "SnowQuest"; NameMon = "Snow Bandit"; CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90); CFrameMon = CFrame.new(1354.34, 87.27, -1393.94)
        elseif MyLevel >= 100 and MyLevel <= 119 then Mon = "Snowman"; LevelQuest = 2; NameQuest = "SnowQuest"; NameMon = "Snowman"; CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90); CFrameMon = CFrame.new(1201.64, 144.57, -1550.06)
        elseif MyLevel >= 120 and MyLevel <= 149 then Mon = "Chief Petty Officer"; LevelQuest = 1; NameQuest = "MarineQuest2"; NameMon = "Chief Petty Officer"; CFrameQuest = CFrame.new(-5039.58, 27.35, 4324.68); CFrameMon = CFrame.new(-4881.23, 22.65, 4273.75)
        elseif MyLevel >= 150 and MyLevel <= 174 then Mon = "Sky Bandit"; LevelQuest = 1; NameQuest = "SkyQuest"; NameMon = "Sky Bandit"; CFrameQuest = CFrame.new(-4839, 717, -2622); CFrameMon = CFrame.new(-4968, 717, -2577)
        elseif MyLevel >= 175 and MyLevel <= 189 then Mon = "Dark Master"; LevelQuest = 2; NameQuest = "SkyQuest"; NameMon = "Dark Master"; CFrameQuest = CFrame.new(-4839, 717, -2622); CFrameMon = CFrame.new(-5185, 717, -2346)
        elseif MyLevel >= 190 and MyLevel <= 209 then Mon = "Prisoner"; LevelQuest = 1; NameQuest = "PrisonerQuest"; NameMon = "Prisoner"; CFrameQuest = CFrame.new(5308, 1, 474); CFrameMon = CFrame.new(5361, 1, 620)
        elseif MyLevel >= 210 and MyLevel <= 249 then Mon = "Dangerous Prisoner"; LevelQuest = 2; NameQuest = "PrisonerQuest"; NameMon = "Dangerous Prisoner"; CFrameQuest = CFrame.new(5308, 1, 474); CFrameMon = CFrame.new(5564, 1, 747)
        elseif MyLevel >= 250 and MyLevel <= 274 then Mon = "Toga Warrior"; LevelQuest = 1; NameQuest = "ColosseumQuest"; NameMon = "Toga Warrior"; CFrameQuest = CFrame.new(-1580, 7, -2986); CFrameMon = CFrame.new(-1661, 7, -2824)
        elseif MyLevel >= 275 and MyLevel <= 299 then Mon = "Gladiator"; LevelQuest = 2; NameQuest = "ColosseumQuest"; NameMon = "Gladiator"; CFrameQuest = CFrame.new(-1580, 7, -2986); CFrameMon = CFrame.new(-1319, 7, -3163)
        elseif MyLevel >= 300 and MyLevel <= 324 then Mon = "Magma Ninja"; LevelQuest = 1; NameQuest = "MagmaQuest"; NameMon = "Magma Ninja"; CFrameQuest = CFrame.new(-5313, 12, 8515); CFrameMon = CFrame.new(-5403, 15, 8352)
        elseif MyLevel >= 325 and MyLevel <= 374 then Mon = "Military Spy"; LevelQuest = 2; NameQuest = "MagmaQuest"; NameMon = "Military Spy"; CFrameQuest = CFrame.new(-5313, 12, 8515); CFrameMon = CFrame.new(-5816, 84, 8835)
        elseif MyLevel >= 375 and MyLevel <= 399 then Mon = "Fishman Warrior"; LevelQuest = 1; NameQuest = "FishmanQuest"; NameMon = "Fishman Warrior"; CFrameQuest = CFrame.new(61122, 18, 1569); CFrameMon = CFrame.new(60934, 18, 1541)
        elseif MyLevel >= 400 and MyLevel <= 449 then Mon = "Fishman Commando"; LevelQuest = 2; NameQuest = "FishmanQuest"; NameMon = "Fishman Commando"; CFrameQuest = CFrame.new(61122, 18, 1569); CFrameMon = CFrame.new(61849, 18, 1494)
        elseif MyLevel >= 450 and MyLevel <= 474 then Mon = "God's Guard"; LevelQuest = 1; NameQuest = "SkyExp1Quest"; NameMon = "God's Guard"; CFrameQuest = CFrame.new(-4721, 843, -1949); CFrameMon = CFrame.new(-4664, 844, -1896)
        elseif MyLevel >= 475 and MyLevel <= 524 then Mon = "Shanda"; LevelQuest = 2; NameQuest = "SkyExp1Quest"; NameMon = "Shanda"; CFrameQuest = CFrame.new(-4721, 843, -1949); CFrameMon = CFrame.new(-4033, 804, -2091)
        elseif MyLevel >= 525 and MyLevel <= 549 then Mon = "Royal Squad"; LevelQuest = 1; NameQuest = "SkyExp2Quest"; NameMon = "Royal Squad"; CFrameQuest = CFrame.new(-7927, 5545, -319); CFrameMon = CFrame.new(-7667, 5601, -446)
        elseif MyLevel >= 550 and MyLevel <= 624 then Mon = "Royal Soldier"; LevelQuest = 2; NameQuest = "SkyExp2Quest"; NameMon = "Royal Soldier"; CFrameQuest = CFrame.new(-7927, 5545, -319); CFrameMon = CFrame.new(-7809, 5601, -127)
        elseif MyLevel >= 625 and MyLevel <= 649 then Mon = "Galley Pirate"; LevelQuest = 1; NameQuest = "FountainQuest"; NameMon = "Galley Pirate"; CFrameQuest = CFrame.new(5256, 38, 4050); CFrameMon = CFrame.new(5569, 38, 3991)
        else Mon = "Galley Captain"; LevelQuest = 2; NameQuest = "FountainQuest"; NameMon = "Galley Captain"; CFrameQuest = CFrame.new(5256, 38, 4050); CFrameMon = CFrame.new(5662, 38, 4920) end
    elseif World2 then
        if MyLevel >= 700 and MyLevel <= 724 then Mon = "Raider"; LevelQuest = 1; NameQuest = "Area1Quest"; NameMon = "Raider"; CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18); CFrameMon = CFrame.new(-728.32, 52.77, 2345.77)
        else Mon = "Swan Pirate"; LevelQuest = 1; NameQuest = "Area2Quest"; NameMon = "Swan Pirate"; CFrameQuest = CFrame.new(638.43, 71.76, 918.28); CFrameMon = CFrame.new(1068.66, 137.61, 1322.10) end
    else
        Mon = "Pirate Millionaire"; LevelQuest = 1; NameQuest = "PiratePortQuest"; NameMon = "Pirate Millionaire"; CFrameQuest = CFrame.new(-450.10, 107.68, 5950.72); CFrameMon = CFrame.new(-245.99, 47.30, 5584.10)
    end
end

local function getQuestMonsterName()
    local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
    if not questGui or not questGui.Visible then return nil end
    local title = questGui:FindFirstChild("Container") and questGui.Container:FindFirstChild("QuestTitle") and questGui.Container.QuestTitle:FindFirstChild("Title")
    if not title then return nil end
    local text = title.Text
    local monster = text:match("Đánh%b*%s*%d+%s*(.-)%s*%((%d+)/(%d+)%)")
    if not monster then
        monster = text:match("Đánh%b*%s*%d+%s*(.*)")
    end
    return monster and monster:gsub("^%s+", ""):gsub("%s+$", "") or nil
end

local function isQuestCompleted()
    local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
    if not questGui or not questGui.Visible then return false end
    local track = questGui:FindFirstChild("Container") and questGui.Container:FindFirstChild("QuestTitle") and questGui.Container.QuestTitle:FindFirstChild("QuestTrack")
    if not track then return false end
    local text = track.Text
    local current, required = text:match("(%d+)/(%d+)")
    if current and required then
        return tonumber(current) >= tonumber(required)
    end
    return false
end

local function completeQuest()
    if not CommF then return false end
    local success = pcall(function() CommF:InvokeServer("FinishQuest", NameQuest) end)
    if success then return true end
    success = pcall(function() CommF:InvokeServer("CompleteQuest", NameQuest) end)
    if success then return true end
    success = pcall(function() CommF:InvokeServer("ClaimQuestReward", NameQuest) end)
    return success
end

-- Vòng lặp Auto Farm chính (có quản lý StartBring)
spawn(function()
    while task.wait() do
        if _G.AutoFarm or _G.AutoItemFarm then
            pcall(function()
                CheckQuest()
                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                if not questGui or not questGui.Visible then
                    StartBring = false
                    _G.GlobalFarmActive = false
                    cleanupBodyPositions()
                    if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 20 then topos(CFrameQuest)
                    else if _G.AutoQuest and CommF then CommF:InvokeServer("StartQuest", NameQuest, LevelQuest) end end
                else
                    local questCompleted = isQuestCompleted()
                    if questCompleted then
                        if CommF then completeQuest() end
                        task.wait(0.5)
                        if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 20 then topos(CFrameQuest)
                        else if _G.AutoQuest and CommF then CommF:InvokeServer("StartQuest", NameQuest, LevelQuest) end end
                        StartBring = false
                        _G.GlobalFarmActive = false
                        cleanupBodyPositions()
                    else
                        local questMonster = getQuestMonsterName()
                        local monsterName = questMonster or NameMon
                        local foundMob = false
                        local enemies = Workspace:FindFirstChild("Enemies") or Workspace
                        for _, v512 in pairs(enemies:GetChildren()) do
                            if v512:FindFirstChild("HumanoidRootPart") and v512:FindFirstChild("Humanoid") and v512.Humanoid.Health > 0 and v512.Name:lower() == monsterName:lower() then
                                foundMob = true
                                -- Di chuyển đến gần quái
                                local targetPos = v512.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                                if (LocalPlayer.Character.HumanoidRootPart.Position - targetPos.Position).Magnitude > 10 then
                                    topos(targetPos)
                                end
                                -- Bắt đầu gom quái
                                StartBring = true
                                _G.GlobalFarmActive = true
                                repeat
                                    task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    local hrp = LocalPlayer.Character.HumanoidRootPart
                                    hrp.CFrame = CFrame.lookAt(hrp.Position, v512.HumanoidRootPart.Position)
                                    -- Kéo quái về trên đầu người chơi
                                    if _G.BringMonster then
                                        pullMonster(v512, hrp.Position + Vector3.new(0, 15, 0))
                                    end
                                    VirtualUser:CaptureController()
                                    VirtualUser:Button1Down(Vector2.new(1280, 672))
                                until not (_G.AutoFarm or _G.AutoItemFarm) or v512.Humanoid.Health <= 0 or not v512.Parent or not questGui.Visible
                                StartBring = false
                                cleanupBodyPositions()
                            end
                        end
                        if not foundMob then
                            StartBring = false
                            _G.GlobalFarmActive = false
                            cleanupBodyPositions()
                            if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameMon.Position).Magnitude > 15 then
                                topos(CFrameMon)
                            end
                        end
                    end
                end
            end)
        else
            if not (_G.AutoBoss or _G.AllBossesFarm) then
                _G.GlobalFarmActive = false
                cleanupBodyPositions()
            end
        end
    end
end)

-- Auto Click
spawn(function()
    while task.wait() do
        if _G.AutoClick then
            pcall(function()
                EquipWeapon(_G.SelectWeapon)
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(1280, 672))
            end)
        end
    end
end)

-- Vòng lặp gom quái cũ đã được thay thế bằng hàm pullMonster bên trong vòng lặp farm chính, nên không cần vòng lặp riêng nữa.

-- Boss Farm (có gom quái)
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local liveBosses = {}
            local enemies = Workspace:FindFirstChild("Enemies") or Workspace
            for _, v in pairs(enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and (string.find(v.Name, "Boss") or table.find(CurrentBossList, v.Name)) then
                    table.insert(liveBosses, v.Name)
                end
            end

            if _G.AutoBoss or _G.AllBossesFarm then
                for _, v in pairs(enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        if _G.AllBossesFarm or v.Name == _G.SelectedBossName then
                            _G.GlobalFarmActive = true
                            local targetPos = v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                            if (LocalPlayer.Character.HumanoidRootPart.Position - targetPos.Position).Magnitude > 10 then
                                topos(targetPos)
                            end
                            repeat
                                task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                local hrp = LocalPlayer.Character.HumanoidRootPart
                                hrp.CFrame = CFrame.lookAt(hrp.Position, v.HumanoidRootPart.Position)
                                if _G.BringMonster then
                                    pullMonster(v, hrp.Position + Vector3.new(0, 15, 0))
                                end
                                VirtualUser:CaptureController()
                                VirtualUser:Button1Down(Vector2.new(1280, 672))
                            until not (_G.AutoBoss or _G.AllBossesFarm) or v.Humanoid.Health <= 0 or not v.Parent
                            cleanupBodyPositions()
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto Collect Fruit, Fast Attack, Auto Stats, Farm Bone, Takakuri, Sea Beast, Ghost Ship giữ nguyên (không thay đổi)

-- Tự động bật Haki (đã có)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChild("HasBuso") and CommF then
                CommF:InvokeServer("Buso")
            end
        end)
    end
end)

-- Fast Attack với tốc độ cực cao (15 lần) - giữ nguyên
local v1 = next; local v2 = {ReplicatedStorage.Util, ReplicatedStorage.Common, ReplicatedStorage.Remotes, ReplicatedStorage.Assets, ReplicatedStorage.FX}; local v3, u4, u5 = nil, nil, nil
task.spawn(function()
    while true do
        local v6; v3, v6 = v1(v2, v3)
        if v3 == nil then break end
        local v7 = next; local v8, v9 = v6:GetChildren()
        while true do
            local v10; v9, v10 = v7(v8, v9)
            if v9 == nil then break end
            if v10:IsA('RemoteEvent') and v10:GetAttribute('Id') then u5 = v10:GetAttribute('Id'); u4 = v10 end
        end
        v6.ChildAdded:Connect(function(p11) if p11:IsA('RemoteEvent') and p11:GetAttribute('Id') then u5 = p11:GetAttribute('Id'); u4 = p11 end end)
    end
end)

task.spawn(function()
    while RunService.Heartbeat:Wait() do
        if (_G.AutoFarm or _G.AutoItemFarm or _G.GlobalFarmActive or _G.AutoClick or _G.AutoFarmBone or _G.AutoFarmTakakuri or _G.AutoSeaBeast or _G.AutoGhostShip) and _G.FastAttack then
            pcall(function()
                local _Character = LocalPlayer.Character; local v13 = _Character and _Character:FindFirstChild('HumanoidRootPart'); if not v13 then return end
                local v14, v15, v16 = ipairs({Workspace.Enemies, Workspace.Characters}); local u17 = {}
                while true do
                    local v18; v16, v18 = v14(v15, v16); if v16 == nil then break end
                    local v19, v20, v21 = ipairs(v18 and v18:GetChildren() or {})
                    while true do
                        local v22; v21, v22 = v19(v20, v21); if v21 == nil then break end
                        local _HumanoidRootPart = v22:FindFirstChild('HumanoidRootPart'); local _Humanoid = v22:FindFirstChild('Humanoid')
                        if v22 ~= _Character and (_HumanoidRootPart and (_Humanoid and (_Humanoid.Health > 0 and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 120))) then
                            local v25, v26, v27 = ipairs(v22:GetChildren())
                            while true do
                                local v28; v27, v28 = v25(v26, v27); if v27 == nil then break end
                                if v28:IsA('BasePart') and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 120 then u17[#u17 + 1] = {v22, v28} end
                            end
                        end
                    end
                end
                local _Tool = _Character:FindFirstChildOfClass('Tool')
                if #u17 > 0 and _Tool then
                    pcall(function()
                        require(ReplicatedStorage.Modules.Net):RemoteEvent('RegisterHit', true)
                        ReplicatedStorage.Modules.Net['RE/RegisterAttack']:FireServer()
                        local _Head = u17[1][1]:FindFirstChild('Head')
                        if _Head then
                            for _ = 1, 15 do
                                ReplicatedStorage.Modules.Net['RE/RegisterHit']:FireServer(_Head, u17, {}, tostring(LocalPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
                                local r_u4 = (typeof(cloneref) == "function" and cloneref(u4)) or u4
                                if r_u4 then r_u4:FireServer(string.gsub('RE/RegisterHit', '.', function(p31) return string.char(bit32.bxor(string.byte(p31), math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1)) end), bit32.bxor(u5 + 909090, ReplicatedStorage.Modules.Net.seed:InvokeServer() * 2), _Head, u17) end
                            end
                        end
                    end)
                end
            end)
        end
    end
end)

-- Các vòng lặp farm khác (Bone, Takakuri, Sea Beast, Ghost Ship) giữ nguyên, chỉ cần chèn hàm pullMonster vào.
-- Ở đây tôi lược bỏ để tránh dài, nhưng bạn phải thay thế các đoạn kéo quái cũ bằng pullMonster trong các vòng lặp đó.

-- Kết thúc
